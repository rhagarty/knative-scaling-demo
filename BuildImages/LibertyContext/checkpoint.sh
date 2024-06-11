#!/bin/bash
set -e
set -o pipefail
set -x

# The following is my normal image without instantON
ACMEAIR_DEFAULT_IMAGE_NAME="localhost/liberty-acmeair-ee8:24.0.0.4"
# The following is my image with InstantON
ACMEAIR_INSTANT_ON_IMAGE_NAME="localhost/liberty-acmeair-ee8:24.0.0.4-instanton"

podman run --name my-container -m 512m --cpus=1.0 -e _JAVA_OPTIONS="" -e MONGO_HOST="10.21.72.64" -e MONGO_PORT="27017" -e MONGO_DBNAME="acmeair" --privileged -e WLP_CHECKPOINT=afterAppStart $ACMEAIR_DEFAULT_IMAGE_NAME
podman commit my-container $ACMEAIR_INSTANT_ON_IMAGE_NAME
podman rm my-container

