# Hadoop Single-Node Docker Setup

## Overview
This repository provides a fully reproducible **single-node pseudo-distributed Apache Hadoop** setup using Docker.  
It includes **HDFS, YARN, and MapReduce**, configured to run entirely inside a container with no dependency on host Hadoop installations.

The goal is **infrastructure reproducibility**, not a prebuilt demo image.

---

## Architecture
- Apache Hadoop 3.3.6
- Single-node pseudo-distributed cluster
- HDFS for storage
- YARN for resource management
- MapReduce for batch processing
- SSH-based daemon orchestration (as required by Hadoop)

All HDFS metadata and data live **inside the container**.

---

## Prerequisites
- Docker Engine or Docker Desktop
- Linux, macOS, or Windows (via Docker Desktop)

No Hadoop installation is required on the host.

---

## Repository Structure
hadoop-docker/
├── Dockerfile
├── entrypoint.sh
├── README.md
└── config/
├── core-site.xml
├── hdfs-site.xml
├── yarn-site.xml
├── mapred-site.xml
└── hadoop-env.sh

---

## Build Image
From the repository root:

```bash
docker build -t hadoop-single-node .

Run Container
docker run -it --name hadoop-test hadoop-single-node
The container will:

Start SSH

Format HDFS (container-local, first run only)

Start HDFS and YARN services

Verify Hadoop Services

Enter the container:

docker exec -it hadoop-test bash


Check running daemons:

jps


Expected processes:

NameNode

DataNode

SecondaryNameNode

ResourceManager

NodeManager

Verify MapReduce Execution

Run a sample WordCount job:

hdfs dfs -put /etc/passwd /input
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar wordcount /input /output
hdfs dfs -ls /output


Successful execution will produce:

_SUCCESS

part-r-00000

Notes

This setup is intentionally single-node

Designed for learning, testing, and reproducible experimentation

Does not reuse or depend on host HDFS metadata

Cleanup

Stop and remove container:

docker rm -f hadoop-test


Remove image:

docker rmi hadoop-single-node


---

# 🧠 Mentor verdict (direct)

- File size + line count = **objective verification**
- README focuses on **how to run**, not theory
- Repo is now **auditable**, not just runnable

If someone clones this and can’t run Hadoop in 2 commands — **that’s on you**.  
Right now, they can.

---

### Next options (pick one)
- “Help me polish this README for resume impact”
- “Proceed to Docker Compose multi-container Hadoop”
- “Proceed to HBase on this Dockerized HDFS”

Choose.
