# zencastr-homework

## REST app

I did not spend very much time here, because this is not where I see myself adding value to Zencastr. The app is the most basic express app possible with just some simple echo routes.

## Container build

The Dockerfile is a production ready multi-stage build. The main thing that I would change for an actual production scenario would be using privately maintained base images rather than the upstream alpine node images.

## Kubernetes manifests

I included a deployment and a service for the method to deploy and load balance requests to the container. In order to autoscale the pods, a horizontal pod autoscaler is also included. This would need to be tuned for a real application in terms of what metric is the choke point and what threshold should cause scale up events.

## Integration test

This is where I focused most of my efforts for this exercise. There is a test.sh script which builds and pushes the container image. Then it starts a local kubernetes cluster using kind[1]. After the cluster is up, the script deploys the deployment and service manifests. Finally, it port-fowards the service locally, and runs a curl to check the endpoint returns 200. This script is integrated as a pre-commit hook using husky.


[1] https://kind.sigs.k8s.io/