FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    openssh-server \
    rsync \
    curl \
    sudo \
    net-tools \
    && rm -rf /var/lib/apt/lists/*

# Create hadoop user
RUN useradd -ms /bin/bash hadoop && \
    echo "hadoop ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Hadoop install
ENV HADOOP_VERSION=3.3.6

RUN curl -O https://downloads.apache.org/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    mv hadoop-${HADOOP_VERSION} /opt/hadoop && \
    rm hadoop-${HADOOP_VERSION}.tar.gz && \
    chown -R hadoop:hadoop /opt/hadoop

# Environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
ENV HADOOP_HOME=/opt/hadoop
ENV HADOOP_CONF_DIR=/opt/hadoop/etc/hadoop
ENV PATH=$PATH:/opt/hadoop/bin:/opt/hadoop/sbin

# SSH setup
RUN mkdir /var/run/sshd && \
    ssh-keygen -A && \
    sed -i 's/#PermitUserEnvironment yes/PermitUserEnvironment yes/' /etc/ssh/sshd_config

# Hadoop configs
COPY config/ /opt/hadoop/etc/hadoop/
RUN chown -R hadoop:hadoop /opt/hadoop/etc/hadoop

# HDFS directories (container-local)
RUN mkdir -p /hadoopdata/namenode /hadoopdata/datanode && \
    chown -R hadoop:hadoop /hadoopdata

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

USER hadoop
WORKDIR /home/hadoop

ENTRYPOINT ["/entrypoint.sh"]
