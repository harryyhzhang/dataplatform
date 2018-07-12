#!/bin/bash
currentfodler=$(pwd -P)
cd "$(dirname "$0")"

#./bin/create-swarm-mode-cluster.sh create nodes
#./bin/create-swarm-mode-cluster.sh create swarm 1
 

#./bin/getconfig.sh

vagrant.exe up

docker-machine create \
      --driver "generic" \
      --generic-ip-address 192.168.33.10 \
      --generic-ssh-user vagrant \
      --generic-ssh-key .vagrant/machines/host1/virtualbox/private_key \
      --generic-ssh-port 22 \
      host1


vagrant ssh -c 'sudo ip addr del 192.168.33.10/24 dev eth1'
vagrant ssh -c 'sudo docker network create  --driver bridge    --subnet=192.168.33.0/24    --gateway=192.168.33.10   --opt "com.docker.network.bridge.name"="docker1"  shared_nw'
vagrant ssh -c 'sudo brctl addif docker1 eth1' 
eval $(docker-machine env host1)

docker-machine ssh host1 "mkdir ./haproxy"
scp haproxy/result_haproxy.cfg vagrant@192.168.33.10:./haproxy/haproxy.cfg
scp src/*.yml vagrant@192.168.33.10:.
scp docker-compose vagrant@192.168.33.10:.
docker-machine ssh host1 "sudo usermod -aG docker vagrant"
  
#docker-machine ssh node-1 "docker stack deploy -c docker-compose.yml getstartedlab"
docker-machine ssh host1 "docker-compose -f docker-compose_network.yml up"

#route delete 172.18.0.0
#route add 172.18.0.0 MASK 255.255.255.0 `docker-machine ip node-1` METRIC 2
#docker-machine ls


cd ${currentfodler}
