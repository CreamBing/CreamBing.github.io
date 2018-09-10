---
title: linux上安装docker-compose
date: 2018-09-10 20:18:06
tags:
- docker-compose
- docker服务编排工具
categories:
- docker-compose
- docker服务编排工具
comments: true
---
# 前言
linux上安装docker-compose,为了在安装了docker的机器上更加方便的编排容器

# 目的
利用docker-compose快速编排docker容器
<!-- more -->

# 正文
## wget
{% codeblock %}
wget https://github.com/docker/compose/releases/download/1.22.0/docker-compose-Linux-x86_64
{% endcodeblock %}
如果wget没有安装,利用下面命令安装
{% codeblock %}
yum install wget
{% endcodeblock %}
另外如果wget下载不下来,因为直接从github上下载,国内可能网速并不理想
{% link docker-compose v1.22.0 下载 https://pan.baidu.com/s/1BcGqg2yly_X8YWIYi7KmkQ %}
提取码:***ixnx***

## mv并设置环境变量

{% img /images/docker/docker-compose.png %}