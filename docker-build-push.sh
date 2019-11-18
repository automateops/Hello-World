#!/bin/sh

export ROOT=$(pwd)
export APP_NAME=${1}
export APP_VERSION=${2}
export DOCKER_REGISTRY=${3}
export DOCKER_HUB_USERNAME=${4}
export DOCKER_HUB_PASSWORD=${5}

echo ${DOCKER_PASSWORD} | docker login --username ${DOCKER_USER} --password-stdin
docker build -t ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}
docker push ${DOCKER_REGISTRY}/${APP_NAME}:${APP_VERSION}