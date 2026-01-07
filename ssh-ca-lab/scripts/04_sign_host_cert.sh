#!/bin/bash
set -e

CA_OWNER="aminulpmics"
HOST_NAME="aminulpmics-thost"

HOST_DIR="hosts/${HOST_NAME}"
HOST_KEY="${HOST_DIR}/host_key"
CA_KEY="ca/private/${CA_OWNER}_ca"

mkdir -p "${HOST_DIR}"
chmod 700 "${HOST_DIR}"

# Generate host key if not exists
if [ ! -f "${HOST_KEY}" ]; then
  ssh-keygen -t ed25519 -f "${HOST_KEY}" -N "" -C "${HOST_NAME}"
fi

# Fix permissions
chmod 600 "${HOST_KEY}"
chmod 600 "${CA_KEY}"

# Sign host certificate
ssh-keygen -s "${CA_KEY}" \
  -I "${HOST_NAME}" \
  -h \
  -n "${HOST_NAME},192.168.56.20" \
  -V +52w \
  "${HOST_KEY}.pub"

echo "[OK] Host certificate signed"

