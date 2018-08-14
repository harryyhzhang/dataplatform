FROM harryyhzhang/docker-hadoop-base:hadoop2.7.7-java8
MAINTAINER harryyhzhang@gmail.com   docker build -t harryyhzhang/docker-hadoop-namenode: . && docker push harryyhzhang/docker-hadoop-namenode:hadoop2.7.7-java8

HEALTHCHECK CMD curl -f http://localhost:50070/ || exit 1

ENV HDFS_CONF_dfs_namenode_name_dir=file:///hadoop/dfs/name
RUN mkdir -p /hadoop/dfs/name
VOLUME /hadoop/dfs/name

ADD run.sh /run.sh
RUN chmod a+x /run.sh

EXPOSE 50070

CMD ["/run.sh"]