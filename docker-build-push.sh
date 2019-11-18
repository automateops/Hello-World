#!/bin/sh

export ROOT=$(pwd)
export APP_NAME=${1}
export APP_VERSION=${2}
export DOCKER_REGISTRY=${3}
export DOCKER_HUB_USERNAME=${4}
export DOCKER_HUB_PASSWORD=${5}

docker_login() {
    echo ${DOCKER_HUB_PASSWORD} | docker login --username ${DOCKER_HUB_USERNAME} --password-stdin
}

docker_build_push(){
    docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION} .
    docker push ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}
}

docker_login
docker_build_push