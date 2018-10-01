source ./ops.sh &&
cd src &&
chmod +x docker-compose &&
sudo docker network create  --driver bridge    --subnet=192.168.33.0/24    --gateway=192.168.33.10   --opt "com.docker.network.bridge.name"="docker1"  shared_nw &&
docker-compose -f docker-compose_rstudioserver2.yml up -d  &&
while ! gocontainer 0 'hdfs dfsadmin -report' | grep -m1 Normal; do
       echo 'wait'
              sleep 1        
              done
              docker cp sparkR.R  testbed-master:/sparkR.R &&
              gocontainer 0 'R CMD BATCH sparkR.R'
              
