#!/usr/bin/env sh
set -evuo pipefail

# TODO: Use image with cargo-deb installed already to speed this up
if ! docker images -q cargo-deb|grep -qE '.*'; then
    docker build -f scripts/Dockerfile-cargodep -t cargo-deb ./scripts
fi
docker run -w /app -v "$(pwd):/app" -it cargo-deb