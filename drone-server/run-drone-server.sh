#!/bin/bash

if [ "$#" -ne 4 ]; then
    echo "Error require 4 args!"
    exit 1
fi

GITHUB_CLIENT=$1
GITHUB_SECRET=$2
DRONE_ADMIN_USER=$3
DRONE_SECRET=$4

docker run -d \
  -e DRONE_GITHUB=true \
  -e DRONE_GITHUB_CLIENT=${GITHUB_CLIENT} \
  -e DRONE_GITHUB_SECRET=${GITHUB_SECRET} \
  -e DRONE_SECRET=${DRONE_SECRET} \
  -e DRONE_OPEN=true  \
  -e DRONE_ADMIN=${DRONE_ADMIN_USER}  \
  -v /var/lib/drone:/var/lib/drone \
  -p 80:8000 \
  --restart=always \
  --name=drone \
  drone/drone:0.5

