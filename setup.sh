#!/bin/bash
set -e

REPO_NAME="ssh-ca-lab"
USER_NAME="aminulpmics"
HOST_NAME="aminulpmics-thost"

echo "[+] Creating repository structure: $REPO_NAME"

mkdir -p $REPO_NAME/{ca/private,ca/aminul-public,users/$USER_NAME,hosts/$HOST_NAME,scripts,docs}

cd $REPO_NAME

# -----------------------------
# .gitignore
# -----------------------------
cat <<EOF > .gitignore
ca/private/*
users/*/*_key
EOF

# -----------------------------
# README.md
# -----------------------------
cat <<EOF > README.md
# SSH Certificate Authority Lab – aminulpmics

This repository demonstrates a production-style SSH Certificate Authority (CA)
implementation using OpenSSH.

Features:
- SSH User Certificates
- SSH Host Certificates
- CA-based trust (no authorized_keys)
- Git-safe structure
EOF

# -----------------------------
# topology.md
# -----------------------------
cat <<EOF > topology.md
CA Server      : 192.168.56.10
Target Host   : 192.168.56.20
Client        : 192.168.56.30

User          : aminulpmics
Target Host   : aminulpmics-thost
EOF

# -----------------------------
# docs/lab-steps.md
# -----------------------------
cat <<EOF > docs/lab-steps.md
1. Create CA
2. Generate user key
3. Sign user certificate
4. Sign host certificate
5. Configure sshd
6. Test SSH login
EOF

# -----------------------------
# Script: 01_create_ca.sh
# -----------------------------
cat <<'EOF' > scripts/01_create_ca.sh
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
EOF

# -----------------------------
# Script: 02_create_user_key.sh
# -----------------------------
cat <<'EOF' > scripts/02_create_user_key.sh
#!/bin/bash
set -e

USER_NAME="aminulpmics"

mkdir -p users/${USER_NAME}

ssh-keygen -t ed25519 \
  -f users/${USER_NAME}/${USER_NAME}_key \
  -C "${USER_NAME}@ssh-ca-lab"

echo "[OK] User key created"
EOF

# -----------------------------
# Script: 03_sign_user_cert.sh
# -----------------------------
cat <<'EOF' > scripts/03_sign_user_cert.sh
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
EOF

# -----------------------------
# Script: 04_sign_host_cert.sh
# -----------------------------
cat <<'EOF' > scripts/04_sign_host_cert.sh
#!/bin/bash
set -e

HOST_NAME="aminulpmics-thost"
HOST_IP="192.168.56.20"
CA_OWNER="aminulpmics"

ssh-keygen -s ca/private/${CA_OWNER}_ca \
  -I ${HOST_NAME}-host-cert \
  -h \
  -n ${HOST_NAME},${HOST_IP} \
  /etc/ssh/ssh_host_ed25519_key.pub

cp /etc/ssh/ssh_host_ed25519_key-cert.pub \
   hosts/${HOST_NAME}/

echo "[OK] Host certificate signed"
EOF

# -----------------------------
# Script: 05_configure_sshd.sh
# -----------------------------
cat <<'EOF' > scripts/05_configure_sshd.sh
#!/bin/bash
set -e

echo "TrustedUserCAKeys /etc/ssh/aminulpmics-ca-pub" >> /etc/ssh/sshd_config
echo "HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub" >> /etc/ssh/sshd_config

systemctl restart sshd

echo "[OK] SSHD configured"
EOF

# -----------------------------
# Script: 06_verify_cert.sh
# -----------------------------
cat <<'EOF' > scripts/06_verify_cert.sh
#!/bin/bash

ssh-keygen -L -f users/aminulpmics/aminulpmics_key-cert.pub
EOF

# -----------------------------
# Permissions
# -----------------------------
chmod +x scripts/*.sh

echo
echo "✅ Repository structure created successfully!"
echo "➡ Next steps:"
echo "   git init"
echo "   git add ."
echo "   git commit -m \"Initial SSH CA lab structure (aminulpmics)\""
