#!/bin/bash

# Set default values or accept values as command-line arguments
DOCKER_IMAGE_NAME=${1:-"default-name"}
DOCKER_IMAGE_TAG=${2:-"latest"}
DOCKER_REGISTRY=${3:-"mesrarbrand"}  # Replace with the address of your Docker registry

# Validate input values
if [ -z "$DOCKER_IMAGE_NAME" ] || [ -z "$DOCKER_IMAGE_TAG" ] || [ -z "$DOCKER_REGISTRY" ]; then
    echo "Usage: $0 <image-name> <image-tag> <docker-registry>"
    exit 1
fi

# Build the Docker image


docker build --build-arg APP_NAME=$APP_NAME -t "$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG" .

# Tag the Docker image
docker tag "$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG" "$DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"

# Log in to the Docker registry (if needed)
# docker login "$DOCKER_REGISTRY"

# Push the Docker image to the registry
docker push "$DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"

# Clean up: Optionally remove local images to save space
docker image rm "$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"
docker image rm "$DOCKER_REGISTRY/$DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG"

echo "Build, tag, and push completed for $DOCKER_IMAGE_NAME:$DOCKER_IMAGE_TAG to $DOCKER_REGISTRY"
