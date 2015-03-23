#! /bin/bash

echo $GCLOUD_KEY | base64 --decode > gcloud.p12
gcloud auth activate-service-account 793693906404-62c2cpnt2vrdtegokfpeqng963oqe5us.apps.googleusercontent.com --key-file gcloud.p12
ssh-keygen -f ~/.ssh/google_compute_engine -N ""
