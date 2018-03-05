#!/bin/bash
currentfodler=$(pwd -P)
cd "$(dirname "$0")"

#./bin/create-swarm-mode-cluster.sh create nodes
#./bin/create-swarm-mode-cluster.sh create swarm 1
 

function buildspark(){
	docker-machine scp src/docker-compose_spark.yml node-1:.
	docker-machine scp -r spark/conf node-1:.
	docker-machine ssh node-1 "mkdir ~/data"
	docker-machine ssh node-1 "mkdir ~/data2"
	docker-machine ssh node-1 "docker pull gettyimages/spark"
	docker-machine ssh node-1 "docker stack deploy -c docker-compose_spark.yml getstartedlab"
	start chrome `docker-machine ip node-1`':8080'
}


function buildrstudioserver(){
	docker-machine scp src/docker-docker-compose_rstudioserver.yml node-1:.
}



function buildnetwork(){
	docker-machine scp src/docker-compose_network.yml node-1:.
}


function main() {
	Command=$1  
	case "${Command}" in
			spark) buildspark "$@" ;;
			rstudioserver) buildrstudioserver "$@" ;;
			network) buildnetwork "$@" ;;
			*)      echo "Usage: $0 all|spark|rstudioserver|network" ;;
	esac
}

main "$@"
	
	
cd ${currentfodler}



#https://github.com/gettyimages/docker-spark
#https://github.com/vkorukanti/spark-docker-compose/blob/master/docker-compose.yml
#https://medium.com/@ivanermilov/scalable-spark-hdfs-setup-using-docker-2fd0ffa1d6bf
#https://docs.docker.com/compose/networking/#update-containers
#https://docs.docker.com/engine/userguide/networking/default_network/container-communication/