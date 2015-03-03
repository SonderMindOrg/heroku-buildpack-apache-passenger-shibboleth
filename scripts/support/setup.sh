#!/usr/bin/env bash

# Fail fast
set -o pipefail
set -eux

# Make sure gpg is initialized
gpg --list-keys

get="curl -s -L -O"
verify="gpg --keyserver-options auto-key-retrieve --verify"
extract="tar xzf"

APP_DIR=/app
INSTALL_DIR=${APP_DIR}/opt
