# Ported from https://github.com/LibreTranslate/LibreTranslate/blob/main/docker/Dockerfile,
# on top of Docker Hardened Images (https://hub.docker.com/hardened-images/catalog/dhi/python)
# instead of the upstream python:slim base.
#
# The -dev tag is required (not the default minimal/distroless tag) because this image needs
# apt/gcc/g++ to build native deps, and bash + adduser/addgroup to run LibreTranslate's own
# scripts/entrypoint.sh and create its non-root user. The default DHI python tag ships without
# a shell or package manager and would break both of those.
#
# Build context must be a checkout of the LibreTranslate source (this Dockerfile only, no COPY
# sources live here). Use setup-build-context.sh in this directory to prepare one, e.g.:
#   ./translationproviders/docker/libretranslate/setup-build-context.sh /tmp/libretranslate-src
#   docker build -f translationproviders/docker/libretranslate/Dockerfile -t libretranslate-dhi /tmp/libretranslate-src

FROM dhi.io/python:3.14-dev AS builder

WORKDIR /app

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq \
  && apt-get -qqq install --no-install-recommends -y pkg-config gcc g++ \
  && apt-get upgrade --assume-yes \
  && apt-get clean \
  && rm -rf /var/lib/apt

# setuptools is required by Babel's compiler below (distutils shim) but, unlike on the Python
# versions LibreTranslate pins to upstream, venv no longer bundles it by default on this Python.
RUN python -mvenv venv && ./venv/bin/pip install --no-cache-dir --upgrade pip setuptools

COPY . .

# Install package from source code, compile translations
RUN ./venv/bin/pip install Babel==2.12.1 && ./venv/bin/python scripts/compile_locales.py \
  && ./venv/bin/pip install "numpy<2" \
  && ./venv/bin/pip install gunicorn==23.0.0 \
  && ./venv/bin/pip install . \
  && ./venv/bin/pip cache purge

# -dev tag: needs bash (entrypoint.sh) and apt (to install the adduser package below).
# Unlike Debian's own base images, DHI's Debian doesn't preinstall the adduser package.
FROM dhi.io/python:3.14-dev

ARG with_models=false
ARG models=""

ENV HOME=/home/libretranslate
RUN apt-get update -qq \
  && apt-get -qqq install --no-install-recommends -y adduser \
  && apt-get clean \
  && rm -rf /var/lib/apt
RUN addgroup --system --gid 1032 libretranslate && adduser --system --uid 1032 libretranslate && mkdir -p /home/libretranslate/.local && chown -R libretranslate:libretranslate /home/libretranslate/
USER libretranslate

COPY --from=builder --chown=1032:1032 /app /app
WORKDIR /app

COPY --from=builder --chown=1032:1032 /app/venv/bin/ltmanage /usr/bin/

RUN if [ "$with_models" = "true" ]; then  \
  # initialize the language models
  if [ ! -z "$models" ]; then \
  ./venv/bin/python scripts/install_models.py --load_only_lang_codes "$models";   \
  else \
  ./venv/bin/python scripts/install_models.py;  \
  fi \
  fi

EXPOSE 5000
ENTRYPOINT [ "./scripts/entrypoint.sh" ]
