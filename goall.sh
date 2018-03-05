#!/bin/bash
currentfodler=$(pwd -P)
cd "$(dirname "$0")"

./bin/create-swarm-mode-cluster.sh create nodes
./bin/create-swarm-mode-cluster.sh create swarm 1

docker-machine scp src/\*.yml node-1:.
docker-machine scp -r spark/conf node-1:.
docker-machine ssh node-1 "mkdir ~/data"
docker-machine ssh node-1 "mkdir ~/data2"
docker-machine ssh node-1 "docker pull gettyimages/spark"
docker-machine ssh node-1 "docker stack deploy -c docker-compose_spark.yml getstartedlab"

cd ${currentfodler}

start chrome `docker-machine ip node-1`':8080'

#docker stack deploy -c docker-compose_spark.yml getstartedlab1
#docker stack rm getstartedlab1

#https://github.com/gettyimages/docker-spark
#https://github.com/vkorukanti/spark-docker-compose/blob/master/docker-compose.yml
#https://medium.com/@ivanermilov/scalable-spark-hdfs-setup-using-docker-2fd0ffa1d6bf
#https://docs.docker.com/compose/networking/#update-containers
#https://docs.docker.com/engine/userguide/networking/default_network/container-communication/