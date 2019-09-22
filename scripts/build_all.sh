#!/usr/bin/env bash
set -evuo pipefail

cargo build --verbose --all --release --frozen --offline
cargo test --verbose --all --release --frozen --offline
