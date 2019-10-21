# author mjaglan@umail.iu.edu
# Coding Style: Shell form

# Start from Ubuntu OS image
FROM ubuntu:14.04
MAINTAINER harryyhzhang@gmail.com 
#docker build -t harryyhzhang/hadoop2.7spark2.0.2r3.4:2.0 .

# set root user
USER root

RUN addgroup hadoop
RUN adduser --ingroup hadoop hduser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "hduser:hduser" | sudo chpasswd
RUN usermod -aG sudo hduser

RUN adduser   rstudio --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "rstudio:rstudio" | chpasswd 

RUN su hduser
USER hduser
#setup env variables in bash, but it may not be necessary
RUN echo $'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64  \n\
export HADOOP_HOME=/usr/local/hadoop   \n\
export SPARK_HOME=/usr/local/spark    \n\
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME:sbin  \n\
' >> ~/.profile

# install utilities on up-to-date node
RUN sudo apt-get update && apt-get -y dist-upgrade 
CMD ["su", "-", "hduser"]
