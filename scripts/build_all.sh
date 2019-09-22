#!/usr/bin/env bash
set -evuo pipefail

cargo build --verbose --all --release
cargo test --verbose --all --release
