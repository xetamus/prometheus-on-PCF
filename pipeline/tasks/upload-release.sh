#!/bin/bash
set -e

if [[ -s deploy-bosh-creds/bosh-ca.pem ]]; then
  bosh -n --ca-cert deploy-bosh-creds/bosh-ca.pem target `cat deploy-bosh-creds/director_ip`
else
  bosh -n target `cat deploy-bosh-creds/director_ip`
fi

BOSH_USERNAME=$(cat deploy-bosh-creds/bosh-username)
BOSH_PASSWORD=$(cat deploy-bosh-creds/bosh-pass)

bosh -n target ${ert_director_ip}

echo "Logging in to BOSH..."
bosh login <<EOF 1>/dev/null
$BOSH_USERNAME
$BOSH_PASSWORD
EOF

echo "Uploading Prometheus Release..."
bosh -n upload release prometheus-release/prometheus-*.tgz

echo "Uploading Prometheus Customizations Release..."
bosh -n upload release prometheus-custom-release/prometheus-custom-*.tgz

if [[ -s ert-bosh-creds/bosh-ca.pem ]]; then
  bosh -n --ca-cert ert-bosh-creds/bosh-ca.pem target `cat ert-bosh-creds/director_ip`
else
  bosh -n target `cat ert-bosh-creds/director_ip`
fi

BOSH_USERNAME=$(cat ert-bosh-creds/bosh-username)
BOSH_PASSWORD=$(cat ert-bosh-creds/bosh-pass)

bosh -n target ${deploy_director_ip}

echo "Logging in to BOSH..."
bosh login <<EOF 1>/dev/null
$BOSH_USERNAME
$BOSH_PASSWORD
EOF

echo "Uploading Node exporter Release..."
bosh -n upload release node-exporter-release/node-exporter-*.tgz
