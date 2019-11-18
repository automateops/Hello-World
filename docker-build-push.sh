#!/bin/sh

export DOCKER_REGISTRY=${1}
export DOCKER_REPOSITORY=${2}
export DOCKER_HUB_USERNAME=${3}
export DOCKER_HUB_PASSWORD=${4}
export APP_NAME=${5}
export APP_VERSION=${6}



docker_login() {
    echo ${DOCKER_HUB_PASSWORD} | docker login ${DOCKER_REGISTRY} --username ${DOCKER_HUB_USERNAME} --password-stdin
}

docker_build_push(){
    docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/${APP_NAME}:${APP_VERSION} .
    docker push ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/${APP_NAME}:${APP_VERSION}
}

docker_login
docker_build_push