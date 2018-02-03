#/bin/bash


function printhaproxyconfigfile(){
	cp ./haproxy/haproxy.cfg ./haproxy/result_haproxy.cfg
	while IFS='' read -r line || [[ -n "$line" ]]; do
		echo "   server node1 $line:8888 check" >> ./haproxy/result_haproxy.cfg
	done < "result_ip.txt"
}

printhaproxyconfigfile	