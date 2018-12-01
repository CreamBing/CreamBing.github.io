---
title: centos7在线安装docker
date: 2018-11-30 17:06:04
tags:
- centos7
- docker
- 在线
categories:
- centos7
- docker
- 在线
comments: true
---
# 前言
在线在centos7安装docker
# 目的
CentOS Linux release 7.5.1804 (Core)
docker-ce.x86_64 3:18.09.0-3.el7
<!-- more -->
# 正文
**1.确认系统是否是centos7，内核在3.10以上**
```
uname -r
或者
cat /etc/redhat-release
```
{% img /images/docker/centos7/uname-r.jpg %}
**2.执行如下命令安装**
在root用户下，或者在sudo执行
```
yum install -y yum-utils \
        device-mapper-persistent-data \
        lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo
    
yum install docker-ce
```
{% img /images/docker/centos7/docker_install1.png %}
{% img /images/docker/centos7/docker_install2.png %}
{% img /images/docker/centos7/docker_install3.png %}
在第一次执行安装命令时，无法解析远程仓库，此时用浏览器访问了一下,确认可以访问，于是再次执行，安装成功，这说明这个网站针对国内不够稳定，最后下载的时候确实显示速度也比较慢
所以这里可以切换成阿里的源 http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
{% img /images/docker/centos7/docker_install6.png %}
{% img /images/docker/centos7/docker_install4.png %}
{% img /images/docker/centos7/docker_install5.png %}
**3.启动并验证**
```
systemctl start docker.service
docker run hello-world
```
{% img /images/docker/centos7/check_docker.png %}

# 参考资料
1.docker官方网站
[https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository]