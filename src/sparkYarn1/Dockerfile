# author mjaglan@umail.iu.edu
# Coding Style: Shell form

# Start from Ubuntu OS image
FROM ubuntu:14.04
MAINTAINER harryyhzhang@gmail.com 
#docker build -t harryyhzhang/hadoop2.7spark2.0.2r3.4:2.0 .

# set root user
USER root
#RUN groupadd -g 999 appuser && \
#    useradd -r -u 999 -g appuser appuser
#USER appuser

RUN addgroup hadoop
RUN adduser --ingroup hadoop hduser --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "hduser:hduser" | sudo chpasswd
RUN usermod -aG sudo hduser

RUN adduser   rstudio --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "rstudio:rstudio" | chpasswd 

RUN echo "hduser ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/user && \
    chmod 0440 /etc/sudoers.d/user

#RUN su hduser
USER hduser 
#setup env variables in bash, but it may not be necessary
RUN echo $'export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64  \n\
export HADOOP_HOME=/usr/local/hadoop   \n\
export HIVE_HOME=/usr/local/hive   \n\
export SPARK_HOME=/usr/local/spark    \n\
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SPARK_HOME/bin:$SPARK_HOME:sbin  \n\
' >> ~/.profile


# install utilities on up-to-date node

RUN sudo apt-get update
RUN sudo apt-get -y dist-upgrade
RUN sudo apt-get install -y openssh-server wget  default-jdk scala netcat procps

# set java home
ENV JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64

# setup ssh with no passphrase
RUN ssh-keygen -t rsa -f $HOME/.ssh/id_rsa -P "" \
    && cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

# download & extract & move hadoop & clean up
# TODO: write a way of untarring file to "/usr/local/hadoop" directly
RUN cd ~ && wget -O ./hadoop.tar.gz -q http://www.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz \
	&& tar xfz hadoop.tar.gz \
	&& sudo mv hadoop-2.7.7 /usr/local/hadoop \
	&& rm hadoop.tar.gz

# download & extract & move spark & clean up
# TODO: write a way of untarring file to "/usr/local/spark" directly
RUN cd ~ && wget -O ./spark.tar.gz -q http://archive.apache.org/dist/spark/spark-2.0.2/spark-2.0.2-bin-hadoop2.7.tgz \
	&& tar xfz spark.tar.gz \
	&& sudo mv spark-2.0.2-bin-hadoop2.7 /usr/local/spark \
	&& rm spark.tar.gz

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
COPY --chown=hduser:hadoop config/ /tmp/
RUN sudo mv /tmp/ssh_config $HOME/.ssh/config \
    && sudo mv /tmp/hadoop-env.sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh \
    && sudo mv /tmp/core-site.xml $HADOOP_HOME/etc/hadoop/core-site.xml \
    && sudo mv /tmp/hdfs-site.xml $HADOOP_HOME/etc/hadoop/hdfs-site.xml \
    && sudo mv /tmp/mapred-site.xml $HADOOP_HOME/etc/hadoop/mapred-site.xml.template \
    && cp $HADOOP_HOME/etc/hadoop/mapred-site.xml.template $HADOOP_HOME/etc/hadoop/mapred-site.xml \
    && sudo mv /tmp/yarn-site.xml $HADOOP_HOME/etc/hadoop/yarn-site.xml \
    && cp /tmp/slaves $HADOOP_HOME/etc/hadoop/slaves \
    && sudo mv /tmp/slaves $SPARK_HOME/conf/slaves \
    && sudo mv /tmp/spark/spark-env.sh $SPARK_HOME/conf/spark-env.sh \
    && sudo mv /tmp/spark/log4j.properties $SPARK_HOME/conf/log4j.properties

# Add startup script
ADD --chown=hduser:hadoop scripts/spark-services.sh $HADOOP_HOME/spark-services.sh
RUN chmod +x $HADOOP_HOME/spark-services.sh
# set permissions
#RUN chmod 744 -R $HADOOP_HOME

# format namenode
RUN $HADOOP_HOME/bin/hdfs namenode -format

# install HIVE2.3.2
ENV HIVE_VERSION=2.3.2
ENV HIVE_HOME=/usr/local/hive
ENV PATH=$HIVE_HOME/bin:$PATH
RUN cd ~ && wget  -O ./hive.tar.gz -q https://archive.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz && \
	tar xfz hive.tar.gz && \
	sudo mv apache-hive-$HIVE_VERSION-bin $HIVE_HOME 
RUN cd /usr/local/hive/bin && ./schematool -initSchema -dbType derby
	
RUN wget https://jdbc.postgresql.org/download/postgresql-9.4.1212.jar -O $HIVE_HOME/lib/postgresql-jdbc.jar 
	 

#RUN sudo echo "deb http://mirrors.kernel.org/ubuntu/ $(lsb_release -sc) main" >> /etc/apt/sources.list
RUN echo "deb http://mirrors.kernel.org/ubuntu/ $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list
#RUN sudo add-apt-repository "deb http://archive.ubuntu.com/ubuntu $(lsb_release -sc) main"
RUN sudo apt-get update 
RUN sudo apt-get install -y vim libpng12-0 libxml2-dev libcurl4-openssl-dev libssl-dev gfortran wget libapparmor1 gdebi-core curl

# get R 3.4.5
#ref:https://cran.rstudio.com/bin/linux/ubuntu/README.html
RUN sudo apt-get update 
RUN sudo apt-get install -y apt-transport-https
RUN echo "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -sc)-cran35/" | sudo tee -a /etc/apt/sources.list
RUN sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN sudo apt-get update 
RUN sudo apt-get install -y r-base
#RUN R -e "install.packages('sparklyr')"
#RUN R -e "install.packages('devtools', repos = 'http://cran.us.r-project.org')"
#RUN R -e "install.packages('ggplot2', repos = 'http://cran.us.r-project.org')" 

# Install R studio server 1.1.456
RUN cd ~ && wget https://download2.rstudio.org/rstudio-server-1.1.456-amd64.deb
RUN cd ~ && sudo gdebi --non-interactive rstudio-server-1.1.456-amd64.deb 
RUN sudo sed -i "1 a www-port=8090" /etc/rstudio/rserver.conf


# run hadoop services
#ENTRYPOINT sudo service ssh start; cd $SPARK_HOME; bash
ENTRYPOINT ["/bin/bash", "-c"," sudo service ssh start;cd $SPARK_HOME;bash"]

#usefull command
#./bin/spark-shell --master yarn --deploy-mode client
# some spark version need this update: wget http://repo1.maven.org/maven2/com/sun/jersey/jersey-bundle/1.19.1/jersey-bundle-1.19.1.jar -o $SPARK_HOME/jars/jersey-bundle-1.19.1.jar 

