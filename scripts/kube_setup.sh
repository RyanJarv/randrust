#!/usr/bin/env bash
set -euo pipefail

pushd helm/randrust
helm dep build
popd

pushd helm
helm install ./randrust
popd
