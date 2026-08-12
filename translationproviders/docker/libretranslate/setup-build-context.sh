#!/bin/bash
#
# Clones the LibreTranslate source tree into a tmp folder to use as the Docker
# build context for Dockerfileold in this directory (COPY . . in that Dockerfileold
# expects a LibreTranslate checkout, not this repo).
#
# Usage:   setup-build-context.sh [target-dir] [ref]
# Example: setup-build-context.sh /tmp/libretranslate-src main

set -e

TARGET_DIR=${1:-./tmp/libretranslate-src}
REF=${2:-main}

rm -rf "$TARGET_DIR"
git clone --depth 1 --branch "$REF" https://github.com/LibreTranslate/LibreTranslate "$TARGET_DIR"

echo ""
echo "Build context ready at $TARGET_DIR"
echo "Build the image with:"
echo "  docker build -f Dockerfile -t libretranslate-dhi $TARGET_DIR"
