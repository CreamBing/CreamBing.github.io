---
title: springcloud集成feign
date: 2018-10-29 20:33:37
tags:
- java
- springcloud
- feign
categories:
- java
- springcloud
- feign
comments: true
---
# 前言
Feign是声明式、模板化的HTTP客户端，可以更加快捷优雅的调用HTTP API。在部分场景下和Ribbon类似，都是进行数据的请求处理，但是在请求参数使用实体类的时候显然更加方便，同时还支持安全性、授权控制等。
Feign是集成了Ribbon的，也就是说如果引入了Feign，那么Ribbon的功能也能使用，比如修改负载均衡策略等。
# 目的
1.springcloud Finchley.SR2版本
2.springboot 版本2.0.6.RELEASE
以consul为服务发现和配置中心的前提下，集成一个针对**{% post_link springcloud编写用户微服务 %}**的用户消费服务
<!-- more -->

# 正文
## 初始化工程
方法跟**{% post_link springcloud集成consul %}**中前期准备工程一般，勾选下列依赖
{% img /images/java/springcloud/consul/feign/idea_feign.jpg %}
如果不是上述方法初始化，添加依赖
```
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-openfeign</artifactId>
</dependency>
```
在resources文件夹下新增bootstrap.yml文件，写入以下内容
```
#tomcat启动启动端口
server:
  port: 1020
spring:
  application:
    #项目名称
    name: consul-feign
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
        service-name: consul-feign
        #服务检查的路径
        health-check-path: /actuator/health
        #服务检查的时间间隔
        health-check-interval: 10s
        #服务检查的完整路径
        health-check-url: http://192.168.0.150:${server.port}${spring.cloud.consul.discovery.health-check-path}
        tags: dev
```

## 添加controller类和feign接口
这里的user类就是{% post_link springcloud编写用户微服务 %}中jooq-codegen-maven3.10.8生成的实体对象
所以最好是将这些实体模块化，这样在共同需要的地方引用即可，不用像我这样图简便就直接复制过来
```
@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    UserFeignClient userFeignClient;

    @RequestMapping(value = "/getAll",method = RequestMethod.GET)
    public List<User> getAll(){
        return userFeignClient.getAllUser();
    }
}


@FeignClient(name = "consul-user")
public interface UserFeignClient {

    @RequestMapping(value = "/user/getAll",method = RequestMethod.GET)
    List<User> getAllUser();
}
```
<font color="#eb4d4b">20181030更新:get多参数写法</font>

```
直接写Long id或者直接是User user这种对象，feign依然会用post方式调用，所以会报错接口不支持
需要用@RequestParam("id") Long id，或者@RequestParam Map<String,Object> map
```
最终的工程结构
{% img /images/java/springcloud/consul/feign/dir_feign.jpg %}

## 修改主类
<font color="#eb4d4b">主类上添加@EnableFeignClients注解，否则报错找不到UserFeignClient</font>

## 集成健康检查和hystrix
**添加依赖**
```
健康检查需加依赖
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-web</artifactId>
</dependency>
hystrix需加
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-hystrix</artifactId>
</dependency>
```
**远程配置添加健康检查详细监控以及支持hystrix**
```
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
feign:
  hystrix:
    enabled: true
```
**修改主类**
<font color="#eb4d4b">主类上添加@EnableHystrix注解，否则没有/actuator/hystrix.stream信息，另外上面的配置需要打开，不然没数据</font>