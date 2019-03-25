---
title: 利用docker安装jenkins
comments: true
date: 2019-03-25 23:00:20
password: 20190325
tags:
- docker
- docker-compose
- jenkins
categories:
- 运维(OP)
- docker
- jenkins
---
# 前言
利用docker快速安装jenkins
# 目的
利用docker快速安装jenkins
```
docker:Docker version 18.09.3, build 774a1f4
docker-compose:docker-compose version 1.22.0, build f46880fe
jenkins:2.1
```
<!-- more -->
# 正文
#### 1.安装 docker  和 docker-compose 
**{% post_link centos7在线安装docker %}**
**{% post_link linux上安装docker-compose %}**

#### 2.docker run 直接安装
```
docker pull jenkins/jenkins:lts
docker run --name=jekins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```

#### 3.利用 docker-compose 安装
jenkins.yml文件如下
```
```
其中挂载如果和 run 命令一样的话，如下会报错
```
volumes:
  - 'jenkins_home:/var/jenkins_home'
```
需要挂载在一个真实的地址,完整如下
```

```
不过启动的时候，由于 Jenkins 用户没有权限，需要在宿主机上运行下面命令
```
chown -R 1000:1000 /home/soft/jenkins/jenkins_home
```
经过上面操作之后，Jenkins 能正常启动

#### 4.Jenkins 配置 gitlab 源码库
由于我的 Jenkins 和 gitlab 虽然都是 docker 安装的，但庆幸的是都在同一个 docker 桥接网络中
{% img /images/docker/softs/jenkins/jenkins_gitlab.png %}
由于上面报错，可以将 git ssh 认证关闭
{% img /images/docker/softs/jenkins/jenkins_git_conf.png %}

#### 5.jenkins 安装 maven 插件
下面这种方式有问题
{% img /images/docker/softs/jenkins/maven_fail.png %}

#### 6.构建
-> springboot2 Failed to execute goal org.apache.maven.plugins:maven-surefire-plugin:2.22.1:test (default-test) on project demo: There are test failures
{% img /images/docker/softs/jenkins/jdk_wrong.png %}
报错详细信息
{% img /images/docker/softs/jenkins/surefire_msg.png %}
{% img /images/docker/softs/jenkins/openjdk.png %}
根据报错查询是 openjdk 的问题，切换成 oracle jdk
终于构建成功
{% img /images/docker/softs/jenkins/build_success.png %}

#### 7.发布到远程环境
```
echo "hello demo-0.0.1-SNAPSHOT.jar"
DAY=`date +%Y-%m-%d`
pid=`ps -ef|grep demo-0.0.1-SNAPSHOT.jar|grep -v grep|awk '{print $2}'`
if [ -n "$pid" ]
then
echo 'The pid: server' $pid ' will be killed....'
kill -9 $pid
echo 'The pid: server' $pid ' will be start'
nohup java -jar /home/apps/softs/demo-0.0.1-SNAPSHOT.jar >  /dev/null & 
else
echo 'The pid: server' $pid ' not exist , will be start'
nohup java -jar /home/apps/softs/demo-0.0.1-SNAPSHOT.jar >  /dev/null & 
fi
pid=`ps -ef|grep demo-0.0.1-SNAPSHOT.jar|grep -v grep|awk '{print $2}'`
echo 'The pid: server' $pid ' started'
```


# 参考资料
1.docker 安装 jenkins 
https://hub.docker.com/r/jenkins/jenkins
https://github.com/jenkinsci/docker/blob/master/README.md
2.可行的安装 maven 插件 http://echoyuan.me/2017/07/29/jenkins-cannot-run-program-mvn-error-2-no-such-file-or-directory/
3.jenkins 重启 https://www.jianshu.com/p/59f52d043b95
4.jdk 插件 http://www.mdslq.cn/archives/4183e6f8.html
5.发布到远程服务器 https://blog.csdn.net/lu_wei_wei/article/details/79278211
