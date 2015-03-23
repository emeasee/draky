#! /bin/bash

set -eu

CTRL_BASENAME=webcontroller
GKE_CMD="gcloud preview container kubectl"

envsubst < scripts/web-controller.json.template > web-controller.json
$GKE_CMD rollingupdate $CTRL_BASENAME --update-period=10s -f web-controller.json
