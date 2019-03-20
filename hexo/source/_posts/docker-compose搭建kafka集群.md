---
title: docker-compose搭建kafka集群
comments: true
date: 2019-03-20 20:27:44
password: 20190320
tags:
- docker
- docker-compose
- kafka
categories:
- 运维(OP)
- docker
- kafka
# 前言
根据之前的博客中的描述，我们在任何平台上安装好了docker以及docker-compose,利用 **{% post_link docker-compose搭建zookeeper集群 %}** 安装好之后安装kafka集群
# 目的
docker-compose安装好zk集群后，安装kafka集群
```
docker:Docker version 18.09.3, build 774a1f4
docker-compose:docker-compose version 1.22.0, build f46880fe
zookeeper:zookeeper-3.4.13
```
<!-- more -->
# 正文
#### 1.docker search kafka
```
docker search kafka
```
:camera:截图
{% img /images/op/centos7/docker_search_kafka.png %}
#### 2.docker pull 镜像
```
docker pull wurstmeister/kafka
```
#### 3.编写docker-compose脚本
```
version: '3.1'

services:
  kafka1:
    image: wurstmeister/kafka
    hostname: kafka1
    restart: always
    container_name: kafka1
    ports:
      - "19092:19092"
    networks:
      default:
        ipv4_address: 172.20.5.4
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      KAFKA_LISTENERS: PLAINTEXT://kafka1:19092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka1:19092
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
      JMX_PORT: 9999
    volumes:
      - ./kafka1/logs:/kafka

  kafka2:
    image: wurstmeister/kafka
    hostname: kafka2
    restart: always
    container_name: kafka2
    ports:
      - "19093:19093"
    networks:
      default:
        ipv4_address: 172.20.5.5
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      KAFKA_LISTENERS: PLAINTEXT://kafka2:19093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka2:19093
      KAFKA_BROKER_ID: 2
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
      JMX_PORT: 9998
    volumes:
      - ./kafka2/logs:/kafka


  kafka3:
    image: wurstmeister/kafka
    hostname: kafka3
    restart: always
    container_name: kafka3
    ports:
      - "19094:19094"
    networks:
      default:
        ipv4_address: 172.20.5.6
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      KAFKA_LISTENERS: PLAINTEXT://kafka3:19094
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka3:19094
      KAFKA_BROKER_ID: 3
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
      JMX_PORT: 9997
    volumes:
      - ./kafka3/logs:/kafka

  kafka-manager:
    image: sheepkiller/kafka-manager
    hostname: kafka.manager
    container_name: kafka-manager
    ports:
      - "9000:9000"
    links:
      - kafka1
      - kafka2
      - kafka3
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      ZK_HOSTS: zoo1:2181,zoo2:2181,zoo3:2181
      KAFKA_BROKERS: kafka1:19092,kafka2:19093,kafka3:19094
      APPLICATION_SECRET: letmein
      KM_ARGS: -Djava.net.preferIPv4Stack=true
    networks:
      default:
        ipv4_address: 172.20.5.7

networks:
  default:
    external:
      name: zk_static-network
```
#### 4.启动kafka集群
```
docker-compose -f kafaka.yml up -d
``` 
:camera:截图
{% img /images/op/centos7/docker-compose-up-d-kafka.png %}
#### 5.在kafka-manager页面查看是否正常
当使用最新版 kafka-manager 的时候，会出现akka.event.Logging$LoggerInitializationException: TimeOut 异常
https://hub.docker.com/r/sheepkiller/kafka-manager/tags
https://github.com/sheepkiller/kafka-manager-docker/issues/33
使用稳定版
```
docker pull sheepkiller/kafka-manager:stable
```
```
version: '3.1'

services:
  kafka1:
    image: wurstmeister/kafka
    hostname: kafka1
    restart: always
    container_name: kafka1
    ports:
      - "19092:19092"
    networks:
      default:
        ipv4_address: 172.20.5.4
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      KAFKA_LISTENERS: PLAINTEXT://kafka1:19092
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka1:19092
      KAFKA_BROKER_ID: 1
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
      JMX_PORT: 9999
    volumes:
      - ./kafka1/logs:/kafka

  kafka2:
    image: wurstmeister/kafka
    hostname: kafka2
    restart: always
    container_name: kafka2
    ports:
      - "19093:19093"
    networks:
      default:
        ipv4_address: 172.20.5.5
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      KAFKA_LISTENERS: PLAINTEXT://kafka2:19093
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka2:19093
      KAFKA_BROKER_ID: 2
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
      JMX_PORT: 9998
    volumes:
      - ./kafka2/logs:/kafka


  kafka3:
    image: wurstmeister/kafka
    hostname: kafka3
    restart: always
    container_name: kafka3
    ports:
      - "19094:19094"
    networks:
      default:
        ipv4_address: 172.20.5.6
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      KAFKA_LISTENERS: PLAINTEXT://kafka3:19094
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka3:19094
      KAFKA_BROKER_ID: 3
      KAFKA_ZOOKEEPER_CONNECT: zoo1:2181,zoo2:2181,zoo3:2181
      JMX_PORT: 9997
    volumes:
      - ./kafka3/logs:/kafka

  kafka-manager:
    image: sheepkiller/kafka-manager:stable
    hostname: kafka.manager
    container_name: kafka-manager
    ports:
      - "9000:9000"
    links:
      - kafka1
      - kafka2
      - kafka3
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      ZK_HOSTS: zoo1:2181,zoo2:2181,zoo3:2181
      APPLICATION_SECRET: letmein
      KM_ARGS: -Djava.net.preferIPv4Stack=true
    networks:
      default:
        ipv4_address: 172.20.5.7

networks:
  default:
    external:
      name: zk_static-network
```
:camera:截图
{% img /images/op/centos7/kafkamanager.png %}
不过这个版本重启会有异常
https://github.com/yahoo/kafka-manager/issues/439
需要加上命令 command: -Dpidfile.path=/dev/null
```
  kafka-manager:
    image: sheepkiller/kafka-manager:stable
    hostname: kafka.manager
    container_name: kafka-manager
    ports:
      - "9000:9000"
    links:
      - kafka1
      - kafka2
      - kafka3
    external_links:
      - zoo1
      - zoo2
      - zoo3
    environment:
      ZK_HOSTS: zoo1:2181,zoo2:2181,zoo3:2181
      APPLICATION_SECRET: letmein
      KM_ARGS: -Djava.net.preferIPv4Stack=true
    networks:
      default:
        ipv4_address: 172.20.5.7
    command: -Dpidfile.path=/dev/null
```
使用程序命令验证消息能否正常消费和生产
当我们开启jmx使用特殊端口是，会影响命令的使用
https://github.com/wurstmeister/kafka-docker/issues/171
使用命令之前需要卸载JMX_PORT变量 unset JMX_PORT
```
进入docker容器:docker exec -it kafka1 /bin/bash
开始生产者命令:
cd /opt/kafka/bin
unset JMX_PORT
kafka-console-producer.sh --broker-list kafka1:19092,kafka2:19093,kafka3:19094 --topic test
在另一个容器里面打开消费者
cd /opt/kafka/bin
unset JMX_PORT
kafka-console-consumer.sh --bootstrap-server kafka1:19092,kafka2:19093,kafka3:19094 --topic test
```
:camera:截图
{% img /images/op/centos7/kafka_console.png %}

# 参考资料