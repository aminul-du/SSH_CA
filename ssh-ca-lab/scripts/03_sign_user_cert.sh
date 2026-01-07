#!/bin/bash
set -e

USER_NAME="aminulpmics"
VALIDITY="+7d"

ssh-keygen -s ca/private/${USER_NAME}_ca \
  -I ${USER_NAME}-user-cert \
  -n ${USER_NAME} \
  -V ${VALIDITY} \
  users/${USER_NAME}/${USER_NAME}_key.pub

echo "[OK] User certificate signed"
