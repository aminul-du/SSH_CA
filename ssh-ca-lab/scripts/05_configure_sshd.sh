#!/bin/bash
set -e

echo "TrustedUserCAKeys /etc/ssh/aminulpmics-ca-pub" >> /etc/ssh/sshd_config
echo "HostCertificate /etc/ssh/ssh_host_ed25519_key-cert.pub" >> /etc/ssh/sshd_config

systemctl restart sshd

echo "[OK] SSHD configured"
