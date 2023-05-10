#!/bin/bash
echo "Building image for 1st release"
echo
###
skaffold build --default-repo=europe-docker.pkg.dev/galloro-demos/cloudbuilds --file-output=artifacts.json
###
echo "Creating 1st release"
echo
gcloud deploy releases create first-release --delivery-pipeline cd-on-gcp-pipeline --region europe-west1 --build-artifacts artifacts.json
###
echo "Release creation completed"
