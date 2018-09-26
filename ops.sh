gocontainer(){

arr=(`docker ps -aq`)
docker exec -it ${arr[$1]} $2

}

