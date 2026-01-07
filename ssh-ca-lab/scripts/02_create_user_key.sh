#!/bin/bash
set -e

USER_NAME="aminulpmics"

mkdir -p users/${USER_NAME}

ssh-keygen -t ed25519 \
  -f users/${USER_NAME}/${USER_NAME}_key \
  -C "${USER_NAME}@ssh-ca-lab"

echo "[OK] User key created"
