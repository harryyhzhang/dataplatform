#!/bin/bash

./bin/create-swarm-mode-cluster.sh create nodes
./bin/create-swarm-mode-cluster.sh create swarm
docker-machine ls
docker-machine ip node-1
docker-machine ip node-2
docker-machine ip node-3