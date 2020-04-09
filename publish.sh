#!/bin/sh

IMAGE_NAME=deloitte-irsm/rhjdg
IMAGE_VERSION="7.3.5"

# Publish the image
docker tag ${IMAGE_NAME}:${IMAGE_VERSION} 481315189088.dkr.ecr.us-east-1.amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}

docker push 481315189088.dkr.ecr.us-east-1.amazonaws.com/${IMAGE_NAME}:${IMAGE_VERSION}

if [ $? -eq 0 ]; then
    echo "Image Successfully Published with tag $IMAGE_VERSION"
else
    echo "Error: Unable to Publish Image"
fi
