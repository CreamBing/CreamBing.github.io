---
title: springcloud集成consul
date: 2018-10-23 15:15:36
tags:
- java
- springcloud
- consul
categories:
- java
- 微服务
- springcloud
- consul
comments: true
---
# 前言
1.springcloud Finchley.SR2版本
2.springboot 版本2.0.6.RELEASE
集成consul作为配置中心和服务发现中心，同时开启健康检查
# 目的
利用idea快速搭建一个springcloud集成上述功能的微服务
<!-- more -->

# 正文
## 利用idea新建工程
**新建springboot maven工程**
{% img /images/java/springcloud/consul/springcloud_consul_1.jpg %}
**设置项目信息**
{% img /images/java/springcloud/consul/springcloud_consul_2.png %}
**勾选自动配置**
{% img /images/java/springcloud/consul/springcloud_consul_3.jpg %}
**勾选consul配置中心**
{% img /images/java/springcloud/consul/springcloud_consul_config.png %}
**勾选consul服务发现中心**
{% img /images/java/springcloud/consul/springcloud_consul_discovery.png %}
**完成**
{% img /images/java/springcloud/consul/springcloud_consul_6.png %}

## 新建bootstrap.yml文件,添加如下内容，并启动主程序
```
#tomcat启动启动端口
server:
  port: 1015
spring:
  application:
    #项目名称
    name: springcloud-consul
  cloud:
    consul:
      #consul server的host或者ip
      host: localhost
      #consul server的端口
      port: 18500
      config:
        #开启consul配置中心
        enabled: true
        #consul表示consul上面文件的格式 有四种 YAML PROPERTIES KEY-VALUE FILES
        format: YAML
        #表示consul上面的KEY值(或者说文件的名字) 默认是data
        data-key: configuration
        #prefix设置配置值的基本文件夹
        prefix: config
        #defaultContext设置所有应用程序使用的文件夹名
        default-context: ${spring.application.name}
      discovery:
        #开启consul服务发现
        enabled: true
        #开启consul服务的名称
        service-name: springcloud-consul
        #服务检查的路径
        health-check-path: /actuator/health
        #服务检查的时间间隔
        health-check-interval: 10s
        #服务检查的完整路径
        health-check-url: http://192.168.0.101:${server.port}${spring.cloud.consul.discovery.health-check-path}
        tags: dev
```
**启动主程序,发现报错**
{% img /images/java/springcloud/consul/springcloud_consul_withoutweb.png %}
添加依赖
```
 <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
```
**重新启动正常**
{% img /images/java/springcloud/consul/springcloud_consul_withweb.png %}
**{% link 访问健康检查端点 http://ip:port/actuator/health %}** http://ip:port/actuator/health
{% img /images/java/springcloud/consul/springcloud_consul_healtcheck.png %}

## 在consul ui上查看
**访问{% link consul ui http://localhost:18500/ %}** http://localhost:18500/
{% img /images/java/springcloud/consul/springcloud_consul_ui1.png %}

## consul 作为配置中心
**访问{% link consul ui http://localhost:18500/ %}** 添加配置信息
{% img /images/java/springcloud/consul/springcloud_consul_keyval.png %}
```
app:
  port: 3232
```
**新增conf目录，新增如下代码**
{% codeblock %}
@Component
@ConfigurationProperties(prefix = "app")
@Data
public class AppConf {

    private static final Logger LOGGER = LoggerFactory.getLogger(AppConf.class);

    private int port;

    @PostConstruct
    public void printConf(){
        LOGGER.info("加载配置port:[{}]",port);
    }


}
{% endcodeblock %}
{% img /images/java/springcloud/consul/springcloud_consul_keyval1.png %}
**重新启动主程序**
{% img /images/java/springcloud/consul/springcloud_consul_keyval2.jpg %}

## 附加
工程pom
```
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>

    <groupId>com.springcloud</groupId>
    <artifactId>consul1</artifactId>
    <version>0.0.1-SNAPSHOT</version>
    <packaging>jar</packaging>

    <name>consul1</name>
    <description>Demo project for Spring Boot</description>

    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>2.0.6.RELEASE</version>
        <relativePath/> <!-- lookup parent from repository -->
    </parent>

    <properties>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
        <java.version>1.8</java.version>
        <spring-cloud.version>Finchley.SR2</spring-cloud.version>
    </properties>

    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-actuator</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-consul-config</artifactId>
        </dependency>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-starter-consul-discovery</artifactId>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-configuration-processor</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <optional>true</optional>
        </dependency>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>

        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
    </dependencies>

    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.springframework.cloud</groupId>
                <artifactId>spring-cloud-dependencies</artifactId>
                <version>${spring-cloud.version}</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>

    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>


</project>

```







