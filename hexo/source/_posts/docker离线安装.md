---
title: docker离线安装
date: 2018-08-21 17:27:25
password: 20181015
tags:
- docker
- 离线
- 安装
categories:
- docker
- 离线
comments: true
---
# 前言
首先根据**{% post_link docker离线安装包准备 %}**这篇博客准备好docker离线安装包。
下面的操作全程在离线的电脑上操作,要求电脑系统是centos7以上且具备yum命令

# 目的
能够在无网络的环境下安装好docker-ce.18版本
<!-- more -->
# 正文
## 解压
由于上篇文章在制作压缩包的时候将路径打进去了，所以采用下面的命令解压到/apps/docker/packages
{% codeblock lang:bash %}
tar -zxvf docker-ce-18-offline-yum.tgz --strip-components 3 -C /apps/docker/packages
{% endcodeblock %}
## 安装createrepo
{% codeblock lang:bash %}
cd /apps/docker/packages/
rpm -ivh createrepo-0.9.9-28.el7.noarch.rpm
{% endcodeblock %}
上面的命令可能会失败,原因是部分包需要升级
截图:
{% img /images/docker/createrepo_failed.png %}
{% codeblock lang:bash %}
rpm -Uvh deltarpm-3.6-3.el7.x86_64.rpm
rpm -Uvh libxml2-python-2.9.1-6.el7_2.3.x86_64.rpm
rpm -Uvh python-deltarpm-3.6-3.el7.x86_64.rpm
{% endcodeblock %}
截图:
{% img /images/docker/createrepo_update.png %}
然后重新安装createrepo
截图:
{% img /images/docker/createrepo_success.png %}
## 制作本地yum仓库
{% codeblock lang:bash %}
cd /etc/yum.repos.d/
vi CentOS-Local.repo
{% endcodeblock %}
CentOS-Local.repo里面添加如下内容
```
[local]
name=local
baseurl=file:///apps/docker/packages
gpgcheck=0
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7
enabled=1
```
开始建立本地仓库索引
{% codeblock lang:bash %}
createrepo /apps/docker/packages/
{% endcodeblock %}
备份并移除其他仓库
{% codeblock lang:bash %}
mv CentOS-* /home/zb/
mv /home/zb/CentOS-Local.repo ./
{% endcodeblock %}
yum建立缓存
{% codeblock lang:bash %}
yum clean all
yum makecache
{% endcodeblock %}
截图:
{% img /images/docker/yum_clean_makecache.png %}
如果没有上一步的移除其他仓库，可能会出现以下错误,因为离线，一些在线的仓库无法使用会报错，所以先移除
截图:
{% img /images/docker/移除其他仓库.png %}
## 安装docker
{% codeblock lang:bash %}
yum install docker-ce
{% endcodeblock %}
截图:
{% img /images/docker/docker_install_success.png %}
有可能会安装失败，第一次安装失败,主要是在进行**{% post_link docker离线安装包准备 %}**的时候没有进行第二步**修改yum源镜像地址**,添加之后重新制作就好了
截图
{% img /images/docker/docker_install_fail.png %}
这里主要是audit-libs-2.8.1-3.e17_5.1.x86_64(local)与需要安装的audit-2.8.1-3.e17.x86_64冲突，卸载就好了






