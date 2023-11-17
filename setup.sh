#!/bin/bash
# Exit Script if any command fails

set -e
# Define Docker Image 
DOCKER_IMAGE=lbg-py
DOCKER_CONTAINER_NAME=lbg-py-app

cleanup(){
    echo "Cleaning Up the previous artifacts"
    sleep 3
    # Add Commands to remove the previous artifacts
    docker rm -f $(docker rm -aq) || true
    docker rmi -f $(docker images) || true 
    echo "Cleanup done"
}
# Function to build the artifacts
build_docker(){
    echo "Building the image"
    sleep 3
    docker build -t $DOCKER_IMAGE .
    docker push $DOCKER_IMAGE
}
# Function to modify app
modify_app(){
    echo "Modifying the app"
    sleep 3
    export PORT=5001
    echo "Modifications done.PORT is now set to $PORT"
}
# Function to run the docker container
run_docker(){
    echo "Running the docker container"
    sleep 3
    docker pull $DOCKER_IMAGE
    docker run -d -p 80:$PORT -e PORT=$PORT --name $DOCKER_CONTAINER_NAME $DOCKER_IMAGE
}

# Main script execution
echo "Starting build process..."
sleep 3
cleanup
build_docker
modify_app
build_docker
run_docker
echo "Build process completed successfully."
