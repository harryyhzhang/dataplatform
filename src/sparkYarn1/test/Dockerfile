# author mjaglan@umail.iu.edu
# Coding Style: Shell form

# Start from Ubuntu OS image
FROM harryyhzhang/testimage:latest 
MAINTAINER harryyhzhang@gmail.com 
#docker build -t harryyhzhang/hadoop2.7spark2.0.2r3.4:2.0 .


# run hadoop services
ENTRYPOINT ["/bin/bash", "-c"," sudo service ssh start;cd $SPARK_HOME;bash"]


#usefull command
#./bin/spark-shell --master yarn --deploy-mode client
# some spark version need this update: wget http://repo1.maven.org/maven2/com/sun/jersey/jersey-bundle/1.19.1/jersey-bundle-1.19.1.jar -o $SPARK_HOME/jars/jersey-bundle-1.19.1.jar 

