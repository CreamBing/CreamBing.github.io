---
title: windows上安装docker-ce
date: 2018-10-21 20:27:53
password: 20181015
tags:
- windows
- docker
- 安装
categories:
- windows
- docker
- 安装
comments: true
---
# 前言
windows上安装docker,需满足以下条件
```
必须是windows 10 操作系统
开启bios的intel virtualization
安装Hyper-V 软件
```
# 目的
windows上安装docker

<!-- more -->

# 正文
## 下载docker-ce程序包
{% link docker-ce windows下载地址 https://store.docker.com/editions/community/docker-ce-desktop-windows %}
{% img /images/docker/windows/docker-windows-download.png %}
注意需要登录
如果这里不好下载，可以下载我在百度云上的
{% link Docker for Windows Installer.exe 下载 https://pan.baidu.com/s/1JizYRJat2UnejWDN9sq6Fg %}
提取码:***j7pp***

## 安装
第一次安装失败
{% img /images/docker/windows/docker_install_fail.png %}
检查Hyper-V 是否打开，打开Hyper-V并重启
{% img /images/docker/windows/hyper-v.png %}



