#!/bin/bash
set -e

if [[ -s ert-bosh-creds/bosh-ca.pem ]]; then
  bosh -n --ca-cert ert-bosh-creds/bosh-ca.pem target `cat ert-bosh-creds/director_ip`
else
  bosh -n target `cat ert-bosh-creds/director_ip`
fi

bosh -n target ${ert_director_ip}

BOSH_USERNAME=$(cat ert-bosh-creds/bosh-username)
BOSH_PASSWORD=$(cat ert-bosh-creds/bosh-pass)

echo "Logging in to BOSH..."
bosh login <<EOF 1>/dev/null
$BOSH_USERNAME
$BOSH_PASSWORD
EOF

echo "Uploading Runtime Config..."
bosh update runtime-config pcf-prometheus-git/runtime.yml
