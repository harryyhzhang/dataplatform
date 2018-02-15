FROM rocker/rstudio-stable:devel
ENV http_proxy=http://hzha:Th0ughtW0rkerj@caa-proxybr.co.i.caa.ca:8080
ENV https_proxy=https://hzha:Th0ughtW0rkerj@caa-proxybr.co.i.caa.ca:8080
RUN apt-get update && apt-get install -y openjdk-8-jdk && apt-get install -y libxml2-dev 
CMD wget http://apache.mirror.colo-serv.net/spark/spark-2.2.1/spark-2.2.1-bin-ha
CMD tar -xvzf spark-2.2.1-bin-hadoop2.7.tgz
CMD mv spark-2.2.1-bin-hadoop2.7 /usr/local/
CMD chown -R rstudio /usr/local/spark-2.2.1-bin-hadoop2.7
CMD rm spark-2.2.1-bin-hadoop2.7.tgz
CMD echo 'Sys.setenv(https_proxy = "10.100.33.50:8080");\n\
Sys.setenv(https_proxy_user= "hzha:Th0ughtW0rkerj");\n\
Sys.setenv(http_proxy="http://10.100.33.50:8080");\n\
Sys.setenv(http_proxy_user="hzha:Th0ughtW0rkerj");\n\
Sys.setenv(SPARK_HOME ="/usr/local/spark-2.2.1-bin-hadoop2.7/")
Sys.setenv(SPARK_HOME_VERSION="2.2.1")
install.packages("sparklyr")' | R
EXPOSE 8787
CMD ["/init"]
