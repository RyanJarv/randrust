#!/usr/bin/env bash
set -euo pipefail

openssl req -x509 -newkey rsa:2048 -keyout ssl/test/cert.key -out ssl/test/cert.pem -nodes -subj  "/C=TE/ST=Test/L=Test/O=Test/OU=Test/CN=example.com"
