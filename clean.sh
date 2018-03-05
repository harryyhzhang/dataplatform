#!/bin/bash

docker-machine ssh node-1 "docker stack rm getstartedlab"

./bin/create-swarm-mode-cluster.sh remove swarm
./bin/create-swarm-mode-cluster.sh remove nodes