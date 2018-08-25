---
title: java程序打成docker镜像
date: 2018-08-25 13:33:46
tags:
- java
- Dockerfile
- 镜像
categories:
- java
- Dockerfile
comments: true
---
# 前言
本片教程适合idea+java+maven的环境,另外需要有docker环境,如果windows上没有，可以将程序拷贝到linux上有docker的环境上执行相关操作
docker环境安装教程[]

# 目的
将java程序打进docker镜像中,方便docker方式部署
<!-- more -->
# 正文
## mavne添加以下依赖并执行生成Dockerfile
在pom文件的bulid中添加如下驱动
{% codeblock lang:java%}
<plugin>
    <groupId>com.spotify</groupId>
    <artifactId>docker-maven-plugin</artifactId>
    <version>1.0.0</version>
    <configuration>
        <imageName>api</imageName>
        <baseImage>java</baseImage>
        <maintainer>test@email.com</maintainer>
        <workdir>/ROOT</workdir>
        <cmd>["java", "-version"]</cmd>
        <entryPoint>["java", "-jar", "${project.build.finalName}.jar"]</entryPoint>
        <!-- 这里是复制 jar 包到 docker 容器指定目录配置 -->
        <resources>
            <resource>
                <targetPath>/ROOT</targetPath>
                <directory>${project.build.directory}</directory>
                <include>${project.build.finalName}.jar</include>
            </resource>
        </resources>
    </configuration>
</plugin>
{% endcodeblock %}
执行docker_build之后会自动生成Dockerfile,如果你的windows上有docker,会生成镜像,由于我的机器上没有，因为新版的docker安装到window上有
系统限制，详情查看这篇博客[]
Dockerfile内容如下
{% codeblock %}
FROM java
MAINTAINER test@email.com
WORKDIR /ROOT
ADD /ROOT/xxx.jar /ROOT/
ENTRYPOINT ["java", "-jar", "xxx.jar"]
CMD ["java", "-version"]
{% endcodeblock %}
## 转移到linux上有docker环境的机器上开始build
修改一下Dockerfile,将配置文件也打入进去,上面驱动也可以改造成通过Dockerfile打包,而不是写到pom中
{% codeblock %}
FROM java
MAINTAINER test@email.com
WORKDIR /ROOT
ADD ./xxx.jar /ROOT/
ADD ./conf /ROOT/
ENTRYPOINT ["java", "-jar", "xxx.jar"]
CMD ["java", "-version"]
{% endcodeblock %}
linux上目录结构如下
{% img /images/docker/linux_docker_build_dir.png %}
执行build指令
{% codeblock %}
docker build -t job:0814 .
{% endcodeblock %}
终端打印成功截图
{% img /images/docker/linux_docker_build_success.png %}
docker images验证截图
{% img /images/docker/linux_docker_build_see.png %}
