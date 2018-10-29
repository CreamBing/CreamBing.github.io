---
title: springcloud集成网关ZUUL
date: 2018-10-29 14:17:16
tags:
- java
- springcloud
- zuul
categories:
- java
- springcloud
- zuul
comments: true
---
# 前言
Routing in an integral part of a microservice architecture. For example, / may be mapped to your web application, /api/users is mapped to the user service and /api/shop is mapped to the shop service. Zuul is a JVM based router and server side load balancer by Netflix.
路由在微服务架构的一个组成部分。 例如，/可以映射到您的Web应用程序，/api/users映射到用户服务，并且/api/shop映射到商店服务。 Zuul是Netflix的基于JVM的路由器和服务器端负载均衡器。
其功能包括 
```
验证
见解
压力测试
金丝雀测试
动态路由
服务迁移
减载
安全
静态响应处理
主动/主动流量管理
```
Zuul的规则引擎允许规则和过滤器基本上用任何JVM语言编写，内置支持Java和Groovy
# 目的
1.springcloud Finchley.SR2版本
2.springboot 版本2.0.6.RELEASE
以consul为服务发现和配置中心的前提下，集成一个zuul网关服务
<!-- more -->

# 正文
## 初始化工程
方法跟**{% post_link springcloud集成consul %}**中前期准备工程一般，勾选下列依赖
{% img /images/java/springcloud/consul/zuul/idea_zuul.png %}
<font color="#eb4d4b">20181029更新:上面不用勾选hystrix,下面也说明了zuul中已经集成了</font>
在resources文件夹下新增bootstrap.yml文件，写入以下内容
```
#tomcat启动启动端口
server:
  port: 1050
spring:
  application:
    #项目名称
    name: consul-zuul
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
        service-name: consul-zuul
        #服务检查的路径
        health-check-path: /actuator/health
        #服务检查的时间间隔
        health-check-interval: 10s
        #服务检查的完整路径
        health-check-url: http://192.168.0.150:${server.port}${spring.cloud.consul.discovery.health-check-path}
        tags: dev
```
在远程配置中心上添加如下配置
```
zuul:
  routes:
    user:                                               # 可以随便写，在zuul上面唯一即可；当这里的值 = service-id时，service-id可以不写。
      path: /api/user/**                                    # 想要映射到的路径
      service-id: consul-user            # consul中的service-name
#Actuator的健康检查开启所有包括health，info，metrics等
management:
  endpoints:
    web:
      exposure:
        include: "*"
  #开启health端点详细检查
  endpoint:
    health:
      show-details: always
```
修改主类，在主类上加上@EnableZuulProxy注解，这样就完成了
{% img /images/java/springcloud/consul/zuul/zuul_success.png %}
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
由于zuul已经集成hystrix，所以当打开详细健康检查时可以看到hystrix已经打开
{% img /images/java/springcloud/consul/zuul/hystrix.png %}
同时查看 http://localhost:1050/actuator/hystrix.stream <font color="#eb4d4b">注意当没有接口调用时，会显示一直ping,需要调用一个接口，这个页面数据是实时刷新的</font>
{% img /images/java/springcloud/consul/zuul/hystrix_stream.jpg %}

# 参考资料
1.{% link 自定义zuul过滤器 https://blog.csdn.net/smartdt/article/details/79043282 %}
2.{% link zuul比较详细的说明 https://www.cnblogs.com/520playboy/p/7234218.html %}
3.{% link springcloud+zuul+hystrix https://cloud.tencent.com/developer/article/1333796 %}


