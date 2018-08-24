---
title: docker镜像迁移
date: 2018-08-24 09:48:30
tags:
- docker
- 镜像
- 迁移
categories:
- docker
- 镜像
comments: true
---
# 前言
一般正规的做法应该是将自己做好的镜像push到远程仓库去,然后需要的时候从远处仓库拉取.由于目前我还没有建立私有远程仓库
所以这篇博客主要是讲手动导出镜像的方法

# 目的
手动导出镜像以便于在其他地方使用
<!-- more -->
# 正文
## 查看镜像列表
{% codeblock lang:bash %}
docker images
{% endcodeblock %}

## save导出镜像
指令: ***docker save repository:tag > 自定义导出名字.tar*** 推荐
或者  ***docker save image_id > 自定义导出名字.tar***
{% codeblock lang:bash %}
docker save webapi:0814 > webapi0814.tar
{% endcodeblock %}
截图:
{% img /images/docker/docker_save.png %}
## load导入镜像
{% codeblock lang:bash %}
docker load -qi webapi0814.tar
{% endcodeblock %}
截图:
{% img /images/docker/docker_load.png %}
验证:
{% img /images/docker/docker_load_success.png %}
docker images 查看一下导入情况,这里说明一下,如果之前指令是通过save imageid导出的镜像的话,这里导入的时候仓库和标签名可能为空,推荐save repository:tag导出

