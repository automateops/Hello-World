#!/bin/sh

export DOCKER_REGISTRY=${1}
export DOCKER_HUB_USERNAME=${2}
export DOCKER_HUB_PASSWORD=${3}
export APP_NAME=${4}
export APP_VERSION=${5}



docker_login() {
    echo ${DOCKER_HUB_PASSWORD} | docker login ${DOCKER_REGISTRY} --username ${DOCKER_HUB_USERNAME} --password-stdin
}

docker_build_push(){
    docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION} .
    docker push ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}
}

docker_login
docker_build_push