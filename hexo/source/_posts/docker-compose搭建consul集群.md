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
如果没有docker和docker-compose环境，先查看上面两篇博客完成docker和docker-compose的安装和设置

## 下载consul镜像
