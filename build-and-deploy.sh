#!/bin/sh

export DOCKER_REGISTRY=${1}
export DOCKER_REPOSITORY=${2}
export DOCKER_HUB_USERNAME=${3}
export DOCKER_HUB_PASSWORD=${4}
export APP_NAME=${5}
export APP_VERSION=${6}
export ENVIRONMENT=${7}



docker_login() {
    echo ${DOCKER_HUB_PASSWORD} | docker login ${DOCKER_REGISTRY} --username ${DOCKER_HUB_USERNAME} --password-stdin
}

docker_build_push(){
    docker build -t ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/${ENVIRONMENT}-${APP_NAME}:${APP_VERSION} .
    docker push ${DOCKER_REGISTRY}/${DOCKER_REPOSITORY}/${ENVIRONMENT}-${APP_NAME}:${APP_VERSION}
}

deploy(){
    
    kubectl create ns ${ENVIRONMENT} || true

    helm upgrade -i ${APP_NAME} \
        --namespace ${ENVIRONMENT} \
        --set image.repository=${DOCKER_REGISTRY}/${DOCKER_REPOSITORY} \
        --set image.tag=${ENVIRONMENT}-${APP_NAME}:${APP_VERSION} \
        --set service.name=${APP_NAME} \
        ./charts/docker-kubernetes-hello-world
}


docker_login
docker_build_push
deploy