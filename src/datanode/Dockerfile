FROM  harryyhzhang/docker-hadoop-base:hadoop2.7.7-java8
MAINTAINER harryyhzhang@gmail.com     docker build -t harryyhzhang/docker-hadoop-datanode:hadoop2.7.7-java8 . && docker push harryyhzhang/docker-hadoop-datanode:hadoop2.7.7-java8

HEALTHCHECK CMD curl -f http://localhost:50075/ || exit 1

ENV HDFS_CONF_dfs_datanode_data_dir=file:///hadoop/dfs/data
RUN mkdir -p /hadoop/dfs/data
VOLUME /hadoop/dfs/data

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 50075

CMD ["/run.sh"]
