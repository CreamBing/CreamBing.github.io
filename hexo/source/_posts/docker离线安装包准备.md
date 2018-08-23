---
title: docker离线安装包准备
date: 2018-08-23 18:53:35
tags:
- docker
- 离线
- 安装包
categories:
- docker
- 离线
comments: true
---
# 前言
在一台有网络的centos上准备docker-ce.18离线安装包,然后可以根据**{% post_link docker离线安装 %}**这篇博客离线安装docker
***下面的操作都是在有网络的centos7上进行操作的***

# 目的
为离线安装docker提供相关依赖和程序包
<!-- more -->
# 正文
## 建立本地文件夹
{% codeblock lang:bash %}
mkdir -p /apps/docker/packages
{% endcodeblock %}
## 修改yum源镜像地址
先看一下有没有wget ,没有先装一下，在备份
{% codeblock lang:bash %}
yum install wget
{% endcodeblock %}
备份原来的repo
{% codeblock lang:bash %}
cd /etc/yum.repos.d/
mkdir backup
mv ./CentOS-* ./backup/
{% endcodeblock %}
下载阿里的镜像源并应用
{% codeblock lang:bash %}
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
yum clean all
yum makecache
{% endcodeblock %}
截图:
{% img /images/docker/aliyumrepo.png %}
## 下载createrepo软件包及其依赖
{% codeblock lang:bash %}
repotrack -a x86_64 -p /apps/docker/packages createrepo
{% endcodeblock %}
如果上诉指令不存在,先安装yum-utils
{% codeblock lang:bash %}
yum install -y yum-utils
{% endcodeblock %}
截图:
{% img /images/docker/yum_install_yumutils.png %}
再次执行repotrack上面那个指令,开始下载依赖包
截图:
{% img /images/docker/repotrack.png %}
下载libgudev1和systemd-sysv，是因为centos7.2的libgudev1和systemd-sysv依赖systemd-219-19.el7.x86_64，
而docker-ce需要systemd-219-30el7.x86_64.下载 libgudev1和systemd-sysv软件包机器依赖
{% codeblock lang:bash %}
repotrack -a x86_64 -p /apps/docker/packages libgudev1
repotrack -a x86_64 -p /apps/docker/packages systemd-sysv
{% endcodeblock %}
## 下载docker-ce及依赖
由于你的yum远程仓库可能没有docker-ce的相关依赖,建议之前先执行下面的命令添加阿里的docker仓库镜像
{% codeblock lang:bash %}
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
{% endcodeblock %}
然后下载docker-ce相关依赖
{% codeblock lang:bash %}
repotrack -a x86_64 -p /apps/docker/packages docker-ce
{% endcodeblock %}
## 压缩下载
执行下面的命令,将在/apps/docker目录下生成一个docker-ce-18-offline-yum.tgz的包,这个包通过xftp下载后可以在其他地方离线安装docker
只要离线的电脑上有yum命令并且是centos7以上的系统
{% codeblock lang:bash %}
cd /apps/docker
tar -zcvf docker-ce-18-offline-yum.tgz /apps/docker/packages
{% endcodeblock %}




