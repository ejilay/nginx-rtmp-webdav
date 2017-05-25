#!/bin/bash
set -e

DOCKER_RUN_IMAGE=nginx-rtmp-webdav
DOCKER_BUILD_IMAGE=nginx-build

rm -f nginx.tar.gz

cd build

docker build -t ${DOCKER_BUILD_IMAGE} .

cd ..

DID=`docker create ${DOCKER_BUILD_IMAGE}`

docker cp ${DID}:/tmp/nginx.tar.gz ./

docker rm ${DID}
docker rmi ${DOCKER_BUILD_IMAGE}

TIMESTAMP=`date "+%s"`

docker build -t ${DOCKER_RUN_IMAGE} .
docker tag ${DOCKER_RUN_IMAGE} ${DOCKER_RUN_IMAGE}:latest
docker tag ${DOCKER_RUN_IMAGE} ${DOCKER_RUN_IMAGE}:${TIMESTAMP}

docker images | grep ${DOCKER_RUN_IMAGE}
#docker run -d --name ${DOCKER_RUN_IMAGE} -p 1935:1935 -t ${DOCKER_RUN_IMAGE}
#docker ps -a

