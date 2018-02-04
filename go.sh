#!/bin/bash
currentfodler=$(pwd -P)
cd "$(dirname "$0")"

./bin/create-swarm-mode-cluster.sh create nodes
./bin/create-swarm-mode-cluster.sh create swarm 1
docker-machine ls
docker-machine ip node-1
docker-machine ip node-2
docker-machine ip node-3

./bin/getconfig.sh

docker-machine ssh node-1 "mkdir ./haproxy"
docker-machine scp src/*.yml node-1:.
docker-machine scp haproxy/result_haproxy.cfg node-1:./haproxy/haproxy.cfg

docker-machine ssh node-1 "docker stack deploy -c docker-compose.yml getstartedlab"

route delete 172.18.0.0
route add 172.18.0.0 MASK 255.255.255.0 `docker-machine ip node-1` METRIC 2
docker-machine ls


cd ${currentfodler}
