#!/bin/bash
set -e

POSTGRES_USER=${1:-postgres}
POSTGRES_PASSWORD=${2:-postgres}
POSTGRES_DB=${3:-$DOCKER_USER}

SHM_SIZE=${SHM_SIZE:-64m}

IMAGE=$IMAGE
CONTAINER=$CONTAINER

DOCKER_USER=$DOCKER_USER
DOCKER_ENV=$DOCKER_ENV
DOCKER_BINDS_DIR=$DOCKER_BINDS_DIR

SECRET=$SECRET

POSTGIS_PORT=$(docker4gis/port.sh "${POSTGIS_PORT:-5432}")

docker volume create "$CONTAINER" >/dev/null
docker container run --restart always --name "$CONTAINER" \
	--shm-size="$SHM_SIZE" \
	-e DOCKER_USER="$DOCKER_USER" \
	-e SECRET="$SECRET" \
	-e DOCKER_ENV="$DOCKER_ENV" \
	-e "$(docker4gis/noop.sh POSTFIX_DOMAIN "$POSTFIX_DOMAIN")" \
	-e POSTGRES_USER="$POSTGRES_USER" \
	-e POSTGRES_PASSWORD="$POSTGRES_PASSWORD" \
	-e POSTGRES_DB="$POSTGRES_DB" \
	-e CONTAINER="$CONTAINER" \
	-v "$(docker4gis/bind.sh "$DOCKER_BINDS_DIR"/secrets /secrets)" \
	-v "$(docker4gis/bind.sh "$DOCKER_BINDS_DIR"/certificates /certificates)" \
	-v "$(docker4gis/bind.sh "$DOCKER_BINDS_DIR"/fileport /fileport)" \
	-v "$(docker4gis/bind.sh "$DOCKER_BINDS_DIR"/runner /util/runner/log)" \
	--mount source="$CONTAINER",target=/var/lib/postgresql/data \
	-p "$POSTGIS_PORT":5432 \
	--network "$DOCKER_USER" \
	-d "$IMAGE"

while
	sql="select current_setting('app.ddl_done', true)"
	result=$(docker container exec "$CONTAINER" pg.sh -Atc "$sql")
	[ "$result" != "true" ]
do
	sleep 1
done
