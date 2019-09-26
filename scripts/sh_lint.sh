#!/usr/bin/env bash
set -euo pipefail

for script in scripts/*.sh; do
	docker run -v "$(pwd)":/app -w /app -it koalaman/shellcheck-alpine shellcheck -x "$script"
done
