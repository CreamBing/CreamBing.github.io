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
**4.centos7以下安装docker的方式**
>一.什么是epel?
如果既想获得 RHEL 的高质量、高性能、高可靠性，又需要方便易用(关键是免费)的软件包更新功能，那么 Fedora Project 推出的 EPEL(Extra Packages for Enterprise Linux)正好适合你。EPEL(http://fedoraproject.org/wiki/EPEL) 是由 Fedora 社区打造，为 RHEL 及衍生发行版如 CentOS、Scientific Linux 等提供高质量软件包的项目。

具体步骤链接:https://www.jianshu.com/p/4e74f11ee309,这个我没有亲自实验，想来应该可以，但是升级一大堆包毕竟感觉有点慌张，这里提供我之前的安装方式
通过epel安装已经行不通了，因为里面已经没有了docker-io的包了
2019/03/19实验可行
centos6最后支持的docker版本是1.7.1
```
yum install https://get.docker.com/rpm/1.7.1/centos-6/RPMS/x86_64/docker-engine-1.7.1-1.el6.x86_64.rpm
service docker start
docker run hello-world
```
docker1.7.1安装docker-compose
这里目前还是安装失败

# 参考资料
1.docker官方网站
[https://docs.docker.com/install/linux/docker-ce/centos/#install-using-the-repository]
2.各个操作系统安装docker社区版的官方网址
https://hub.docker.com/search/?type=edition&offering=community
3.centos6.x安装docker
http://icyleaf.com/2016/12/docker-with-centos/