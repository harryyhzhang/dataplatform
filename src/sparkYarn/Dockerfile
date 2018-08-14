FROM harryyhzhang/docker-hadoop-hive:hive2.3.2-hadoop2.7.7-java8
MAINTAINER harryyhzhang@gmail.com  docker build -t harryyhzhang/docker-hadoop-hive:r1.2_hive2.3.2-hadoop2.7.7-java8 .

 ENV  SPARK_VERSION=2.3.1
 ENV  SPARK_PACKAGE=spark-${SPARK_VERSION}-bin-hadoop2.7
 ENV  SPARK_HOME=/usr/spark-${SPARK_VERSION}
 ENV  PATH=$PATH:${SPARK_HOME}/bin
 RUN curl -sL --retry 3 \
  "https://www.apache.org/dyn/mirrors/mirrors.cgi?action=download&filename=spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz" \
  | gunzip \
  | tar x -C /usr/ \
 && mv /usr/$SPARK_PACKAGE $SPARK_HOME \
 && chown -R root:root $SPARK_HOME


 RUN echo 'deb http://mirrors.kernel.org/ubuntu/ xenial main' >> /etc/apt/sources.list
 RUN apt-get update
 RUN apt-get install -y vim libpng12-0
 
 RUN apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev
 RUN apt-get install -y     gfortran
 
 ENV DEBIAN_FRONTEND=noninteractive
 RUN apt-get install -y  wget libapparmor1 gdebi-core curl
 # get R 3.4.4
 RUN apt-get update && apt-get install -y r-base  
 #RUN wget https://cloud.r-project.org/bin/linux/ubuntu/xenial-cran35/r-base-core_3.5.0-1xenial_amd64.deb
 #RUN gdebi --non-interactive r-base-core_3.5.0-1xenial_amd64.deb
 
 RUN wget https://download2.rstudio.org/rstudio-server-1.1.456-amd64.deb
 RUN gdebi --non-interactive rstudio-server-1.1.456-amd64.deb 
 #RUN wget https://s3.amazonaws.com/rstudio-ide-build/server/debian9/x86_64/rstudio-server-1.2.830-amd64.deb
 #RUN gdebi --non-interactive  rstudio-server-1.2.830-amd64.deb
 # gdebi --non-interactive rstudio-server-1.1.456-amd64.deb
 
RUN adduser   rstudio --gecos "First Last,RoomNumber,WorkPhone,HomePhone" --disabled-password
RUN echo "rstudio:rstudio" | chpasswd  
 
RUN R -e "install.packages('sparklyr')"
RUN R -e "install.packages('devtools', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('ggplot2', repos = 'http://cran.us.r-project.org')"
 
# RUN apt-get update \
# && apt-get install -y locales \
# && dpkg-reconfigure -f noninteractive locales \
# && locale-gen C.UTF-8 \
# && /usr/sbin/update-locale LANG=C.UTF-8 \
# && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
# && locale-gen \
# && apt-get clean \
# && rm -rf /var/lib/apt/lists/*
 
# sed -i "1 a www-port=8090" /etc/rstudio/rserver.conf
 
# gdebi libssl-dev_1.0.2g-1ubuntu4.13_amd64.deb