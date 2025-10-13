#!/bin/bash
# source: https://www.eksworkshop.com/docs/aiml/q-cli/q-cli-setup
#
ARCH=$(arch)
curl --proto '=https' --tlsv1.2 \
  -sSf "https://desktop-release.q.us-east-1.amazonaws.com/latest/q-${ARCH}-linux-musl.zip" \
  -o /tmp/q.zip

unzip /tmp/q.zip -d /tmp
sudo Q_INSTALL_GLOBAL=true /tmp/q/install.sh --no-confirm

q --version
