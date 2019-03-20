---
title: centos7最小化安装设置固定ip
comments: true
date: 2019-03-20 09:36:56
tags:
- centos7
- 最小化安装
- 固定ip
categories:
- centos7
- 运维(OP)
---
# 前言
虚拟机装了个CentOS7，使用的NAT的网络模式，为了防止再次启动系统的时候网络IP发生变化，因此设置静态IP和DNS
# 目的
使虚拟机中的centos7在重启后ip不变
<!-- more -->
# 正文
#### 1.查看原有ip分配情况
由于CentOS是最小化安装，没有ifconfig命令，因此可以采用ip命令查看。
```
ip addr
```
:camera:截图
{% img /images/op/centos7/centos7_mini.png %}
我们发现 lo 是回环地址,另一个 ens33 就是就是我们要修改的文件
#### 2.vi修改文件
```
vi /etc/sysconfig/network-scripts/ifcfg-*
```
:camera:截图
{% img /images/op/centos7/editor_ens33.png %}
```
BOOTPROTO=static #dhcp改为static（修改）
ONBOOT=yes #开机启用本配置，一般在最后一行（修改）
IPADDR=192.168.1.204 #静态IP（增加）
GATEWAY=192.168.1.2 #默认网关，虚拟机安装的话，通常是2，也就是VMnet8的网关设置,（增加）
NETMASK=255.255.255.0 #子网掩码（增加）
DNS1=192.168.1.2 #DNS 配置，虚拟机安装的话，DNS就网关就行，多个DNS网址的话再增加（增加）
```
:camera:截图
{% img /images/op/centos7/net_gateway.png %}
#### 3.重启网络服务
```
service network restart
```
#### 4.检查网络
```
ip addr
```
# 参考资料