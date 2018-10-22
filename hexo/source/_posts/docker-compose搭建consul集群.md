---
title: docker-compose搭建consul集群
date: 2018-10-21 20:09:32
password: 20181015
tags:
- docker-compose
- consul集群
categories:
- docker-compose
- consul集群
comments: true
---
# 前言
consul是google开源的一个使用go语言开发的服务发现、配置管理中心服务。内置了服务注册与发现框架、分布一致性协议实现、健康检查、Key/Value存储、多数据中心方案，不再需要依赖其他工具（比如ZooKeeper等）。服务部署简单，只有一个可运行的二进制的包。每个节点都需要运行agent，他有两种运行模式server和client。每个数据中心官方建议需要3或5个server节点以保证数据安全，同时保证server-leader的选举能够正确的进行。
# 目的
利用docker-compose快速搭建consul集群

<!-- more -->

# 正文
## 环境准备
1.**{% post_link docker离线安装 %}**
2.**{% post_link linux上安装docker-compose %}**
或者
1.**{% post_link windows上安装docker-ce %}**
如果没有docker和docker-compose环境，先查看上面博客完成docker和docker-compose的安装和设置

## 下载consul镜像
以下教程和截图在windows环境下，linux上差不多
打开cmd
{% codeblock %}
docker pull consul
{% endcodeblock %}

## docker-compose运行脚本
新建一个目录，目录里面新建一个consuls.yml,里面添加如下内容
```
version: '3.1'

services:
  consul1:
    image: consul:latest
    restart: always
    hostname: consul1
    container_name: consul1
    networks:
      static-network:
        ipv4_address: 172.20.5.2
    command: consul agent -server -client 0.0.0.0 -bootstrap-expect 3 -data-dir /tmp/consul -node=consul1 -bind=172.20.5.2 -datacenter dockerconsuls -ui
    ports:
      - 8500:8500

  consul2:
    image: consul:latest
    restart: always
    hostname: consul2
    container_name: consul2
    networks:
      static-network:
        ipv4_address: 172.20.5.3
    command: consul agent -server -client 0.0.0.0 -bootstrap-expect 3 -data-dir /tmp/consul -node=consul2 -bind=172.20.5.3 -datacenter dockerconsuls -retry-join 172.20.5.2

  consul3:
    image: consul:latest
    restart: always
    hostname: consul3
    container_name: consul3
    networks:
      static-network:
        ipv4_address: 172.20.5.4
    command: consul agent -server -client 0.0.0.0 -bootstrap-expect 3 -data-dir /tmp/consul -node=consul3 -bind=172.20.5.4 -datacenter dockerconsuls -retry-join 172.20.5.2

networks:
  static-network:
    ipam:
      config:
        - subnet: 172.20.0.0/16
```
cd到这个目录下，执行命令
{% codeblock %}
docker-compose -f consuls.yml up -d
{% endcodeblock %}
执行报错
{% img /images/docker/softs/consuls/docker_consuls_fail1.png %}
这里报了本地端口8500被占用，那么我们换一个端口
{% img /images/docker/softs/consuls/consuls_change_port.png %}
在启动试一下成功
{% img /images/docker/softs/consuls/docker_consuls_success.png %}

## 验证
访问http://localhost:18500/ui/dockerconsuls/services
{% img /images/docker/softs/consuls/consuls_ui.png %}

