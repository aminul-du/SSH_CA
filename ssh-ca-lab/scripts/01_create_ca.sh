#!/bin/bash
set -e

CA_OWNER="aminulpmics"

mkdir -p ca/private ca/aminul-public
chmod 700 ca/private

ssh-keygen -t ed25519 \
  -f ca/private/${CA_OWNER}_ca \
  -C "${CA_OWNER} SSH USER CA"

cp ca/private/${CA_OWNER}_ca.pub \
   ca/aminul-public/${CA_OWNER}-ca-pub

echo "[OK] CA created for ${CA_OWNER}"
