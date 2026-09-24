# LibreTranslate on Docker Hardened Images

`Dockerfile` builds [LibreTranslate](https://github.com/LibreTranslate/LibreTranslate) on top of
[Docker Hardened Images](https://hub.docker.com/hardened-images/catalog/dhi/python)
(`dhi.io/python:3.14-dev`) instead of the upstream `python:slim` base, for a reduced-CVE,
signed-provenance base image.

The `-dev` tag is used for both build stages, not the minimal/distroless tag, because
LibreTranslate needs a shell and package manager at both build and run time (see
[Why `-dev`](#why--dev-and-not-the-minimal-tag) below).

## Prerequisites

- Docker logged in to the `dhi.io` registry with an account that has Hardened Images access:
  ```
  docker login dhi.io
  ```
- The build context must be a checkout of the LibreTranslate source — this Dockerfile only lives
  in this repo, it does not vendor LibreTranslate's source. Use `setup-build-context.sh` to fetch
  one:
  ```
  ./setup-build-context.sh                          # clones main into /tmp/libretranslate-src
  ./setup-build-context.sh /tmp/my-dir v1.9.6        # custom target dir / tag / branch
  ```
  On Windows, if you clone the LibreTranslate source some other way instead of using this script,
  make sure it's cloned with `core.autocrlf=false` (or equivalent). LibreTranslate's
  `.gitattributes` only forces LF line endings on `*.py` files, not `*.sh`, so a Windows git
  config with `autocrlf=true` (a common default) checks out `scripts/entrypoint.sh` with CRLF line
  endings. That breaks its shebang once the container tries to run it, and shows up as:
  ```
  exec ./scripts/entrypoint.sh: no such file or directory
  ```
  — a container that appears to start (`docker run -d` returns a container ID) but then
  immediately exits, so it won't show up in `docker ps` (only `docker ps -a`). `setup-build-context.sh`
  already clones with `core.autocrlf=false` to avoid this.

## Build

```
docker build -f translationproviders/docker/libretranslate/Dockerfile \
  -t libretranslate-dhi \
  /tmp/libretranslate-src
```

### Baking in language models at build time (recommended for production)

By default no translation models are included, so the image is small but downloads models on
first boot. To bake specific models in instead:

```
docker build -f translationproviders/docker/libretranslate/Dockerfile \
  --build-arg with_models=true \
  --build-arg models="en,fr,de,nl" \
  -t libretranslate-dhi \
  /tmp/libretranslate-src
```

- `with_models=true` — required to install any models at build time.
- `models` — comma-separated language codes. Leave empty (default) with `with_models=true` to
  install **all** available models (large image).

## Run

```
docker run -d -p 5000:5000 libretranslate-dhi
curl http://localhost:5000/languages
```

Runs as the non-root `libretranslate` user (uid 1032) by default.

### Verifying translation works (fr -> en)

```
curl -X POST http://localhost:5000/translate -H "Content-Type: application/json" -d '{"q": "Bonjour le monde", "source": "fr", "target": "en", "format": "text"}'
```

Expected response:

```
{"translatedText":"Hello world"}
```

If `fr` and/or `en` weren't baked in at build time or restricted via `LT_LOAD_ONLY`, the first
call triggers a model download and may take longer to respond.

### Useful runtime environment variables

Set with `-e` on `docker run` (or `environment:` in compose). Full list in
[LibreTranslate's own docs](https://github.com/LibreTranslate/LibreTranslate#arguments) — most
relevant here:

| Variable           | Effect                                                                 |
|--------------------|-------------------------------------------------------------------------|
| `LT_LOAD_ONLY`     | Comma-separated language codes to download/load on boot, instead of all installed/available models. |
| `LT_UPDATE_MODELS`  | `true` to check for and pull newer versions of installed models on startup. |
| `LT_THREADS`       | Number of gunicorn worker threads.                                     |
| `LT_HOST` / `LT_PORT` | Bind address/port (container listens on `5000` by default, see `EXPOSE`). |

Example, restricting to four languages at runtime instead of baking them into the image:

```
docker run -d -p 5000:5000 -e LT_LOAD_ONLY=en,fr,de,nl libretranslate-dhi
```

If models are downloaded at runtime rather than baked in at build time, mount a volume at
`/home/libretranslate/.local` to avoid re-downloading them on every container restart:

```
docker run -d -p 5000:5000 -e LT_LOAD_ONLY=en,fr,de,nl \
  -v libretranslate_models:/home/libretranslate/.local \
  libretranslate-dhi
```

## Why `-dev`, and not the minimal tag?

DHI's default/minimal Python tag is distroless-style: no shell, no package manager, no
`useradd`/`adduser`. LibreTranslate's own `scripts/entrypoint.sh` is a real bash script (IPv6
bind detection, Prometheus dir setup, env var parsing, then `exec`s gunicorn), and the upstream
Dockerfile creates its non-root user via `addgroup`/`adduser` — both need a shell and, for the
final user setup, `apt` to install the `adduser` package (DHI's Debian doesn't preinstall it,
unlike stock Debian). The `-dev` tag provides both, at the cost of a larger image than the fully
distroless tag would give.

## Known deviations from the upstream Dockerfile

- `pip install --upgrade pip setuptools` in the builder stage: newer Python's `venv` no longer
  bundles `setuptools` by default, but Babel's locale compiler (`scripts/compile_locales.py`)
  needs it via a `distutils` shim.
- `apt-get install adduser` in the final stage before `addgroup`/`adduser`: not preinstalled on
  DHI's Debian base.

Both were found and fixed by actually building the image; if a future DHI base image update
reintroduces these tools by default, the corresponding `apt-get install` step becomes a no-op and
can be dropped.
