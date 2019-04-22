# author mjaglan@umail.iu.edu
# Coding Style: Shell form

# Start from Ubuntu OS image
FROM ubuntu:14.04
MAINTAINER harryyhzhang@gmail.com 
#docker build -t harryyhzhang/hadoop2.7spark2.0.2r3.4:2.0 .

# set root user
USER root

# install utilities on up-to-date node
RUN apt-get update && apt-get -y dist-upgrade && apt-get install -y openssh-server wget  default-jdk scala netcat procps

# set java home
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

# setup ssh with no passphrase
RUN ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" \
    && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

# download & extract & move hadoop & clean up
# TODO: write a way of untarring file to "/usr/local/hadoop" directly
RUN wget -O ./hadoop.tar.gz -q http://www.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz \
	&& tar xfz hadoop.tar.gz \
	&& mv /hadoop-2.7.7 /usr/local/hadoop \
	&& rm /hadoop.tar.gz

# download & extract & move spark & clean up
# TODO: write a way of untarring file to "/usr/local/spark" directly
RUN wget -O ./spark.tar.gz -q http://archive.apache.org/dist/spark/spark-2.0.2/spark-2.0.2-bin-hadoop2.7.tgz \
	&& tar xfz spark.tar.gz \
	&& mv /spark-2.0.2-bin-hadoop2.7 /usr/local/spark \
	&& rm /spark.tar.gz

# hadoop environment variables
ENV HADOOP_HOME=/usr/local/hadoop
ENV SPARK_HOME=/usr/local/spark
ENV PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME:sbin

# hadoop-store
RUN mkdir -p $HADOOP_HOME/hdfs/namenode \
	&& mkdir -p $HADOOP_HOME/hdfs/datanode

# setup configs - [standalone, pseudo-distributed mode, fully distributed mode]
# NOTE: Directly using COPY/ ADD will NOT work if you are NOT using absolute paths inside the docker image.
# Temporary files: http://refspecs.linuxfoundation.org/FHS_3.0/fhs/ch03s18.html
COPY config/ /tmp/
RUN mv /tmp/ssh_config $HOME/.ssh/config \
    && mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
    && mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml \
    && mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml.template \
    && cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml \
    && mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml \
    && cp /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves \
    && mv /tmp/slaves $SPARK_HOME/conf/slaves \
    && mv /tmp/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh \
    && mv /tmp/spark/log4j.properties $SPARK_HOME/conf/log4j.properties

# Add startup script
ADD scripts/spark-services.sh $HADOOP_HOME/spark-services.sh

# set permissions
RUN chmod 744 -R $HADOOP_HOME

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# install HIVE2.3.2
ENV HIVE_VERSION=2.3.2
ENV HIVE_HOME=/usr/local/hive
ENV PATH=$HIVE_HOME/bin:$PATH
RUN wget  -O ./hive.tar.gz -q https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar xfz hive.tar.gz && \
	mv apache-hive-$HIVE_VERSION-bin $HIVE_HOME 
	
RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar 
	 

RUN echo "deb http://mirrors.kernel.org/ubuntu/ $(lsb_release -sc) main" >> /etc/apt/sources.list
#RUN sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main"
RUN apt-get update && apt-get install -y vim libpng12-0 libxml2-dev libcurl4-openssl-dev libssl-dev gfortran wget libapparmor1 gdebi-core curl

# get R 3.4.5
#ref:https://cran.rstudio.com/bin/linux/ubuntu/README.html
RUN apt-get update && apt-get install -y apt-transport-https
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -sc)-cran35/" >> /etc/apt/sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN apt-get update && apt-get install -y r-base
RUN R -e "install.packages('sparklyr')"
RUN R -e "install.packages('devtools', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('ggplot2', repos = 'http://cran.us.r-project.org')" 

# Install R studio server 1.1.456
RUN wget https://download2.rstudio.org/rstudio-server-1.1.456-amd64.deb
RUN gdebi --non-interactive rstudio-server-1.1.456-amd64.deb 
RUN adduser   rstudio --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "rstudio:rstudio" | chpasswd 
RUN sed -i "1 a www-port=8090" /etc/rstudio/rserver.conf

# run hadoop services
ENTRYPOINT service ssh start; cd $SPARK_HOME; bash


#usefull command
#./bin/spark-shell --master yarn --deploy-mode client
# some spark version need this update: wget http://repo1.maven.org/maven2/com/sun/jersey/jersey-bundle/1.19.1/jersey-bundle-1.19.1.jar -o $SPARK_HOME/jars/jersey-bundle-1.19.1.jar 
