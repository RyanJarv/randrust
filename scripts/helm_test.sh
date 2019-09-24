#!/usr/bin/env bash
set -euo pipefail

docker run --mount type=bind,source="$(pwd)",target=/app -w /app koalaman/shellcheck-alpine shellcheck -x test/e2e-kind.sh
docker run --mount type=bind,source="$(pwd)",target=/app -w /app -it quay.io/helmpack/chart-testing:v2.3.3 ct lint --config test/ct.yaml
test/e2e-kind.sh