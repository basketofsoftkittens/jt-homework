#!/bin/bash
set -euxo pipefail

TIMEOUT="60s"

# Build/Push the image
podman build -t quay.io/trown/backend:latest .
podman push quay.io/trown/backend:latest

# Setup a local k8s cluster using docker/podman
kind create cluster --wait $TIMEOUT

# Create the deployment and service in k8s
kubectl apply -f manifests

# Wait for the pods to be ready
kubectl wait --for=condition=ready pod -l app=zencastr-homework --timeout=$TIMEOUT

# Port-forward the service for local tests
kubectl port-forward svc/zencastr-homework 8000 > /dev/null 2>&1 &
# Small wait for port-forward setup
sleep 1

### Integration Tests ###
# This is a very basic smoke test using curl, but any number of tests could go into this section.
status=$(curl -s -o /dev/null -w "%{http_code}" 127.0.0.1:8000/podcast)

if [ $status -eq 200 ]; then
  echo "Success!"
else
  echo "Failed to reach podcast endpoint"
  exit 1
fi
### END TESTS ###

### CLEANUP ###
set +x

# Cleanup port-forward
kill -9 $(ps u | grep ' kubectl port-forward' | awk '{ print $2 }' | head -n1) > /dev/null 2>&1
# Cleanup kind cluster
kind delete cluster > /dev/null 2>&1