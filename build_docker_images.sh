#!/bin/bash

source .env

# Clean up the DOCKER_USERNAME and DOCKER_REPO to remove any unwanted characters
DOCKER_USERNAME=$(echo "$DOCKER_USERNAME" | tr -d '\r\n\t')
DOCKER_REPO=$(echo "$DOCKER_REPO" | tr -d '\r\n\t')

# Array of services to build and push
services=("frontend" "auth" "backend" "database")

# Loop over each service, build, tag, and push the Docker images
for service in "${services[@]}"; do
    echo "Building image for $service..."

    # Build and tag the image properly
    IMAGE_TAG="${DOCKER_USERNAME}/${DOCKER_REPO}-${service}:latest"

    echo $IMAGE_TAG

    docker build -t "$IMAGE_TAG" -f "./dockerfile/${service}.Dockerfile" .

    # Push the image to Docker Hub
    echo "Pushing image $IMAGE_TAG to Docker Hub..."
    docker push "$IMAGE_TAG"

    # Debug: Confirm image pushed
    if [ $? -eq 0 ]; then
        echo "Successfully pushed $IMAGE_TAG to Docker Hub"
    else
        echo "Failed to push $IMAGE_TAG to Docker Hub"
        exit 1
    fi
done
