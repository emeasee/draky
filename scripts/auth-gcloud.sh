#! /bin/bash

envsubst < scripts/gcloud.json.template > gcloud.json
gcloud auth activate-service-account $GCLOUD_EMAIL --key-file gcloud.json
ssh-keygen -f ~/.ssh/google_compute_engine -N ""
gcloud preview docker -a
