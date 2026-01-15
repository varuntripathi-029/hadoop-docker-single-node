#!/bin/bash

# Start SSH daemon
sudo service ssh start

# Setup passwordless SSH for hadoop user (idempotent)
if [ ! -f /home/hadoop/.ssh/id_rsa ]; then
  ssh-keygen -t rsa -P "" -f /home/hadoop/.ssh/id_rsa
  cat /home/hadoop/.ssh/id_rsa.pub >> /home/hadoop/.ssh/authorized_keys
  chmod 700 /home/hadoop/.ssh
  chmod 600 /home/hadoop/.ssh/authorized_keys
fi

# Ensure SSH to localhost works
ssh -o StrictHostKeyChecking=no localhost "echo SSH OK"

# Format NameNode ONLY if not already formatted (container-local)
if [ ! -d "/hadoopdata/namenode/current" ]; then
  hdfs namenode -format -force
fi

# Start Hadoop services
start-dfs.sh
start-yarn.sh

echo "Hadoop Docker container is running."

# Keep container alive
tail -f /dev/null
