#!/bin/bash

net="${1:-$DOCKER_USER}"

docker network create "$net" 1>/dev/null 2>&1 &&
	echo "Network created: $net"

exit 0
