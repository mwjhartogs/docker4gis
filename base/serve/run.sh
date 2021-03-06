#!/bin/bash
set -e

IMAGE=$IMAGE
CONTAINER=$CONTAINER

DOCKER_USER=$DOCKER_USER
DOCKER_ENV=$DOCKER_ENV
DOCKER_BINDS_DIR=$DOCKER_BINDS_DIR

docker container run --restart always --name "$CONTAINER" \
	-e DOCKER_USER="$DOCKER_USER" \
	--network "$DOCKER_USER" \
	-v "$(docker4gis/bind.sh "$DOCKER_BINDS_DIR"/fileport/"$DOCKER_USER" /fileport)" \
	-d "$IMAGE"
