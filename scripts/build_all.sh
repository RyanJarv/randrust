#!/usr/bin/env bash
set -evuo pipefail

cargo build --verbose --all
cargo test --verbose --all
