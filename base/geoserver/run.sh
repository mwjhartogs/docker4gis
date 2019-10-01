#!/bin/bash
set -e

DOCKER_REGISTRY="${DOCKER_REGISTRY}"
DOCKER_USER="${DOCKER_USER}"
DOCKER_TAG="${DOCKER_TAG}"
DOCKER_ENV="${DOCKER_ENV}"
DOCKER_BINDS_DIR="${DOCKER_BINDS_DIR}"

repo=$(basename "$0")
container="${DOCKER_USER}-${repo}"
image="${DOCKER_REGISTRY}${DOCKER_USER}/${repo}:${DOCKER_TAG}"

GEOSERVER_HOST="${GEOSERVER_HOST:-geoserver.merkator.com}"
GEOSERVER_USER="${GEOSERVER_USER:-admin}"
GEOSERVER_PASSWORD="${GEOSERVER_PASSWORD:-geoserver}"
GEOSERVER_PORT="${GEOSERVER_PORT:-58080}"

if .run/start.sh "${image}" "${container}"; then exit; fi

mkdir -p "${DOCKER_BINDS_DIR}/secrets"
mkdir -p "${DOCKER_BINDS_DIR}/fileport"
mkdir -p "${DOCKER_BINDS_DIR}/runner"
mkdir -p "${DOCKER_BINDS_DIR}/certificates"
mkdir -p "${DOCKER_BINDS_DIR}/gwc"

docker volume create "${container}"
docker run --name "${container}" \
	-e GEOSERVER_HOST=$GEOSERVER_HOST \
	-v $DOCKER_BINDS_DIR/secrets:/secrets \
	-v $DOCKER_BINDS_DIR/fileport:/fileport \
	-v $DOCKER_BINDS_DIR/certificates:/certificates \
	-v $DOCKER_BINDS_DIR/gwc:/geoserver/cache \
	-v $DOCKER_BINDS_DIR/runner:/util/runner/log \
	--mount source="${container}",target=/geoserver/data/workspaces/dynamic \
	--network "${DOCKER_USER}-net" \
	-e "GEOSERVER_USER=${GEOSERVER_USER}" \
	-e "GEOSERVER_PASSWORD=${GEOSERVER_PASSWORD}" \
	-p "${GEOSERVER_PORT}":8080 \
	"$@" \
	-d "${image}"
