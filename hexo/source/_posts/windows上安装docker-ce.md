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
必须是windows 10操作系统,如果是企业版，版本号需要大于14393
开启bios的intel virtualization
安装Hyper-V 软件
```
# 目的
windows上安装docker，版本18.06.1-ce-win73(19507)

<!-- more -->

# 正文
## 下载docker-ce程序包
{% link docker-ce windows下载地址 https://store.docker.com/editions/community/docker-ce-desktop-windows %}
{% img /images/docker/windows/docker-windows-download.png %}
注意需要登录
如果这里不好下载，可以下载我在百度云上的
**{% link Docker for Windows Installer.exe 18.06.1-ce-win73(19507)下载 https://pan.baidu.com/s/1JizYRJat2UnejWDN9sq6Fg %}**
提取码:***j7pp***

## 安装
第一次安装失败
{% img /images/docker/windows/docker_install_fail.png %}
**检查Hyper-V 是否打开，打开Hyper-V并重启**
{% img /images/docker/windows/hyper-v.png %}
**根据错误提示检查系统版本**
{% img /images/docker/windows/system_version.jpg %}
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
查看系统版本方法
```
win+r
输入dxdiag

cmd上面也显示了版本号
```
发现当前版本是win10企业版10240比需要的14393要低，所以这里需要将当前系统升级
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
升级win10需要的注意的几点
```
系统需要激活
wifi最好不要选择自动连接，如果是有线的话在更新完之后要重启的时候拔掉网线，保证在重启的时候无网络连接
360等一些软件在window更新时候退出
如果一次更新失败，多尝试几次，我也是更新了三次才成功，中间可以将windows update禁用后重新打开试试
网上说双硬盘就是固态+硬盘这种方式可能更新不成功，需要拆掉一个，我就是固态+硬盘，最终更新成功了
```
系统更新完之后，版本如下
{% img /images/docker/windows/system_version_enable.jpg %}
**检查bios的intel virtualization**
一个比较方便的查看方式是底部导航栏右键属性查看任务处理器-性能
{% img /images/docker/windows/virtualization_enable.jpg %}
上诉检查通过之后重新安装docker，出现了正常安装的画面
{% img /images/docker/windows/docker_install_1.jpg %}
安装过程中会创建用户，360等软件会拦截，最好退出

## 验证
点击桌面docker图标，docker is starting,这需要一段时间，然后需要docker账号登陆
在cmd中运行hello-world
{% img /images/docker/windows/docker_run_helloworld_fail.png %}
网上说这是由于你的账号没有登陆的原因，但其实我是登录的的，不过我还是在docker程序上右键restart了一下，然后就好了
{% img /images/docker/windows/docker_run_helloworld_success.jpg %}



