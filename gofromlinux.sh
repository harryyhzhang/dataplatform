 

source ./ops.sh &&
cd src &&
chmod +x docker-compose &&
sudo docker network create  --driver bridge    --subnet=192.168.33.0/24    --gateway=192.168.33.10   --opt "com.docker.network.bridge.name"="docker1"  shared_nw &&
docker-compose -f docker-compose_rstudioserver2.yml up -d &&
gocontainer 0 "/usr/local/hadoop/spark-services.sh"

 