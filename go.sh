#!/bin/bash
currentfodler=$(pwd -P)
cd "$(dirname "$0")"

#./bin/create-swarm-mode-cluster.sh create nodes
#./bin/create-swarm-mode-cluster.sh create swarm 1
 

#./bin/getconfig.sh
docker-machine rm host1 -f
vagrant destroy -f

vagrant.exe up

docker-machine create \
      --driver "generic" \
      --generic-ip-address 192.168.33.10 \
      --generic-ssh-user vagrant \
      --generic-ssh-key .vagrant/machines/host1/virtualbox/private_key \
      --generic-ssh-port 22 \
      host1


#echo '' > ~/.ssh/known_hosts
#scp -r -i ../dataplatform/.vagrant/machines/host1/virtualbox/private_key ../dataplatform vagrant@192.168.33.10:~/
vagrant ssh -c 'sudo usermod -aG docker vagrant '

vagrant ssh -c '(sudo apt-get install -y git || true) && 
git clone https://github.com/harryyhzhang/dataplatform.git &&
cd dataplatform &&
chmod +x ./gofromlinux.sh &&
./gofromlinux.sh 
 '
 
 #docker-machine ssh host1 "sudo ip addr del 192.168.33.10/24 dev eth1"
vagrant ssh -c "(sudo ip addr del 192.168.33.10/24 dev eth1 || true) && 
sudo brctl addif docker1 eth1  &&
echo 'ip addr del 192.168.33.10/24 dev eth1
brctl addif docker1 eth1
exit 0
' |sudo tee  /etc/rc.local
"
 

eval $(docker-machine env host1)
 
 ######################################3
 
#docker-machine ssh host1 "mkdir ./haproxy"
#scp haproxy/result_haproxy.cfg vagrant@192.168.33.10:./haproxy/haproxy.cfg
#scp src/*.yml vagrant@192.168.33.10:.
# scp -r dataplatform vagrant@192.168.33.10:~/
#scp docker-compose vagrant@192.168.33.10:.
#scp src/hadoop-hive.env vagrant@192.168.33.10:.
#scp src/hadoop.env vagrant@192.168.33.10:.

  
#docker-machine ssh node-1 "docker stack deploy -c docker-compose.yml getstartedlab"
#docker-machine ssh host1 "docker-compose -f docker-compose_network.yml up"

#route delete 172.18.0.0
#route add 172.18.0.0 MASK 255.255.255.0 `docker-machine ip node-1` METRIC 2
#docker-machine ls


#cd ${currentfodler}

#sudo curl -L https://github.com/docker/compose/releases/download/1.20.0-rc1/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
#sudo chmod +x /usr/local/bin/docker-compose

#sudo docker-compose -f docker-compose_hive.yml up