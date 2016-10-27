# Pull base image.
FROM bigboards/cdh-base-__arch__

MAINTAINER bigboards
USER root 

RUN apt-get update \
    && apt-get install -y hive hive-metastore hive-server2 hive-hbase \
    && apt-get clean \
    && apt-get autoclean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*

ADD docker_files/hive-metastore-run.sh /apps/hive-metastore-run.sh
ADD docker_files/hive-server-run.sh /apps/hive-server-run.sh
RUN chmod a+x /apps/hive-metastore-run \
    && chmod a+x /apps/hive-server-run

# declare the volumes
RUN mkdir /etc/hadoop/conf.bb && \
    update-alternatives --install /etc/hadoop/conf hadoop-conf /etc/hadoop/conf.bb 1 && \
    update-alternatives --set hadoop-conf /etc/hadoop/conf.bb
VOLUME /etc/hadoop/conf.bb

# external ports
EXPOSE 50070 50470

CMD ["/bin/bash"]
