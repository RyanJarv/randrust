#!/usr/bin/env bash
set -evuo pipefail

OS="$(uname)"

CMD="
set -evu
cargo install cargo-deb
cargo deb
"

# Linux is required so use docker if we aren't already using that
if [[ $OS == "Linux" ]]; then
    exec bash -c "${CMD}"
else 
    if ! docker images -q cargo-deb|grep -qE '.*'; then
        docker build -f scripts/Dockerfile-cargodeb -t cargo-deb ./scripts
    fi
    docker run -w /app -v "$(pwd):/app" -it rust bash -c "${CMD}"
fi
