#!/bin/bash

# Exit on any error
set -e

KUBERNETES_VERSION=ce491e7d1529d89cd3c43d79b803e4d65192d09a

# Exit if already installed
if [[ -d ~/kubernetes ]]; then
  echo "Kubernetes already installed"
  exit 0
else
  echo "Installing Kubernetes..."
fi

# Clone repo
(cd ~ && git clone https://github.com/GoogleCloudPlatform/kubernetes.git)
(cd ~/kubernetes && git reset --hard $KUBERNETES_VERSION)

# Build go source
(cd ~/kubernetes && hack/build-go.sh)
