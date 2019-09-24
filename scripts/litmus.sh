#!/usr/bin/env bash
set -euo pipefail

#pdk bundle exec rake 'litmus:provision_list[default]'
pdk bundle exec bolt command run 'apt install wget -y' --inventoryfile inventory.yaml --targets ssh_nodes
pdk bundle exec rake 'litmus:install_agent[puppet5]'
pdk bundle exec rake litmus:install_module
pdk bundle exec rake litmus:acceptance:parallel

