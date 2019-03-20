---
title: docker-compose搭建zookeeper集群
comments: true
date: 2019-03-20 12:48:45
password: 20190320
tags:
- docker
- docker-compose
- zookeeper
categories:
- 运维(OP)
- docker
- zookeeper
---
# 前言
根据之前的博客中的描述，我们在任何平台上安装好了docker以及docker-compose,利用它们我们可以快速的开启一个zookeeper集群
# 目的
利用docker-compose快速的开启zookeeper集群,注意版本和yml脚本在不同版本的写法
```
docker:Docker version 18.09.3, build 774a1f4
docker-compose:docker-compose version 1.22.0, build f46880fe
```
<!-- more -->
# 正文
#### 1.docker search zookeeper
```
docker search zookeeper
```
:camera:截图
{% img /images/op/centos7/docker_search_zk.png %}
#### 2.docker pull 镜像
```
docker pull zookeeper
```
#### 3.编写docker-compose脚本
```
version: '3.1'

services:
  zoo1:
    image: zookeeper
    restart: always
    container_name: zoo1
    hostname: zoo1
    ports:
      - 2181:2181
    networks:
      static-network:
        ipv4_address: 172.20.5.1
    environment:
      ZOO_MY_ID: 1
      ZOO_SERVERS: server.1=0.0.0.0:2888:3888 server.2=zoo2:2888:3888 server.3=zoo3:2888:3888

  zoo2:
    image: zookeeper
    restart: always
    container_name: zoo2
    hostname: zoo2
    ports:
      - 2182:2181
    networks:
      static-network:
        ipv4_address: 172.20.5.2
    environment:
      ZOO_MY_ID: 2
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=0.0.0.0:2888:3888 server.3=zoo3:2888:3888

  zoo3:
    image: zookeeper
    restart: always
    container_name: zoo3
    hostname: zoo3
    ports:
      - 2183:2181
    networks:
      static-network:
        ipv4_address: 172.20.5.3
    environment:
      ZOO_MY_ID: 3
      ZOO_SERVERS: server.1=zoo1:2888:3888 server.2=zoo2:2888:3888 server.3=0.0.0.0:2888:3888

networks:
  static-network:
    ipam:
      config:
        - subnet: 172.20.0.0/16
```
#### 4.启动zk集群
```
docker-compose -f zk.yml up -d
``` 
:camera:截图
{% img /images/op/centos7/docker-compose-up-d-zk.png %}
#### 5.利用zkui工具连接zk,查看是否异常
:camera:截图
{% img /images/op/centos7/zkui.png %}

# 参考资料
1. dockerhub官网 https://hub.docker.com/_/zookeeper
2. github issue 地址 https://github.com/31z4/zookeeper-docker/issues
3. zk 的 dockerfile https://github.com/31z4/zookeeper-docker/blob/c6ef4c1ada3c59dc3c1aaef43619b6e048d3c9e8/3.4.13/Dockerfile