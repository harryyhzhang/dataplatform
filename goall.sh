#!/bin/bash
currentfodler=$(pwd -P)
cd "$(dirname "$0")"

./bin/create-swarm-mode-cluster.sh create nodes
#./bin/create-swarm-mode-cluster.sh create swarm 1
 

function buildspark(){
	docker-machine scp src/docker-compose_spark.yml node-1:.
	docker-machine scp -r spark/conf node-1:.
	docker-machine ssh node-1 "mkdir ~/data"
	docker-machine ssh node-1 "docker pull gettyimages/spark"
	docker-machine ssh node-1 "docker stack deploy -c docker-compose_spark.yml getstartedlab"
	start chrome `docker-machine ip node-1`':8080'
}

function buildanalysis(){
	docker-machine scp src/docker-compose node-1:.
	docker-machine ssh node-1 "sudo mv ~/docker-compose /usr/local/bin/"
	docker-machine ssh node-1 "sudo chmod +x /usr/local/bin/docker-compose"
	docker-machine scp src/docker-compose_analysis.yml node-1:.
	docker-machine scp -r spark/conf node-1:.
	docker-machine scp src/hadoop-hive.env node-1:.
	docker-machine ssh node-1 "mkdir ~/data"
	docker-machine ssh node-1 "docker pull gettyimages/spark"
	#docker-machine ssh node-1 "docker stack deploy -c docker-compose_analysis.yml getstartedlab"
	docker-machine ssh node-1 "docker-compose -f docker-compose_analysis.yml up"
	start chrome `docker-machine ip node-1`':8080'
}

function buildrstudioserver(){
	docker-machine scp src/docker-docker-compose_rstudioserver.yml node-1:.
}



function buildnetwork(){
	docker-machine scp src/docker-compose_network.yml node-1:.
}

function buildhadoop(){
	docker-machine scp src/docker-compose_analysis.yml node-1:.
	docker-machine scp src/hadoop.env node-1:.
}

function buildhadoophive(){
	docker-machine scp src/docker-compose_hive.yml node-1:.
	docker-machine scp src/hadoop-hive.env node-1:.
	docker-machine ssh node-1 "docker-compose -f docker-compose_hive.yml up"
	#docker-machine ssh node-1 "docker exec -it docker_hive-server_1 /opt/hive/bin/beeline -u jdbc:hive2://localhost:10000"
}

 

function main() {
	Command=$1  
	case "${Command}" in
			spark) buildspark "$@" ;;
			rstudioserver) buildrstudioserver "$@" ;;
			network) buildnetwork "$@" ;;
			analysis) buildanalysis "$@" ;;
			hadoop) buildhadoop "$@" ;;
			hive) buildhadoophive "$@" ;;
			*)      echo "Usage: $0 all|analysis|spark|rstudioserver|hive|network" ;;
	esac
}

main "$@"
	
	
cd ${currentfodler}



#https://github.com/gettyimages/docker-spark
#https://github.com/vkorukanti/spark-docker-compose/blob/master/docker-compose.yml
#https://medium.com/@ivanermilov/scalable-spark-hdfs-setup-using-docker-2fd0ffa1d6bf
#https://docs.docker.com/compose/networking/#update-containers
#https://docs.docker.com/engine/userguide/networking/default_network/container-communication/