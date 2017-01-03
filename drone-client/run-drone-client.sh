#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Error require 2 args!"
    exit 1
fi

DRONE_SERVER=$1
DRONE_SECRET=$2

docker run -d \
  -e DRONE_SERVER=${DRONE_SERVER} \
  -e DRONE_SECRET=${DRONE_SECRET} \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --restart=always \
  --name=drone-agent \
  drone/drone:0.5 agent
