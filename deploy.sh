#!/bin/bash

# Exit on any error
set -e

KUBE_CMD="gcloud preview container kubectl"

# Update Kubernetes replicationController
envsubst < kubernetes/web-controller.json.template > web-controller.json
$KUBE_CMD -c web-controller.json \
  update replicationControllers/webcontroller

# Roll over Kubernetes pods
$KUBE_CMD rollingupdate webcontroller
