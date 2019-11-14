#!/usr/bin/env bash

set -euox pipefail

KEY="$1"

git config --global user.email "cyclone@wirelesscar.com"
git config --global user.name "Cyclone admin"

cat << EOF >> ~/.ssh/config
Host ssh.dev.azure.com
    HostName ssh.dev.azure.com
    User git
    IdentityFile ~/.ssh/${KEY}
EOF

cat << EOF >> ~/.ssh/known_hosts
ssh.dev.azure.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7Hr1oTWqNqOlzGJOfGJ4NakVyIzf1rXYd4d7wo6jBlkLvCA4odBlL0mDUyZ0/QUfTTqeu+tm22gOsv+VrVTMk6vwRU75gY/y9ut5Mb3bR5BV58dKXyq9A9UeB5Cakehn5Zgm6x1mKoVyf+FFn26iYqXJRgzIZZcZ5V6hrE0Qg39kZm4az48o0AUbf6Sp4SLdvnuMa2sVNwHBboS7EJkm57XQPVU3/QpyNLHbWDdzwtrlS+ez30S3AdYhLKEOxAG8weOnyrtLJAUen9mTkol8oII1edf7mWWbWVf0nBmly21+nZcmCTISQBtdcyPaEno7fFQMDD26/s0lfKob4Kw8H
EOF

chmod 700 ~/.ssh
chmod 600 ~/.ssh/${KEY}
