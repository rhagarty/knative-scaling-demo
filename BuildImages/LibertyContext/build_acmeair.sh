#!/bin/bash
podman build -m=1024m -f Dockerfile_acmeair -t localhost/liberty-acmeair-ee8:24.0.0.4 .

