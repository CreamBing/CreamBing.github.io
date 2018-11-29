---
title: nodejs微服务集成consul
date: 2018-11-23 11:07:48
tags:
- nodejs
- consul
categories:
- nodejs
- consul
comments: true
---
# 前言
**{% post_link 使用Sidecar来整合非jvm微服务 %}**这篇文章讲解了非jvm集成到springcloud体系中的方法
<font color="#eb4d4b">需要说明的是上述方法是用Netflix的sidecar,然而它依赖Eureka作为服务发现组件，consul有自己的注册接口</font>
# 目的
利用consul的http api将nodejs微服务注册到consul中
<!-- more -->

# 正文
js中有目前实现最为完备的Consul 客户端是{% link node-consul https://github.com/silas/node-consul#agent-service-register %}
它支持的功能有
```
ACL: 访问控制
Agent: 检查/服务注册
Health: 健康信息获取
Catalog: 目录列表
KV: 键值对存取
Event: 发送事件与列表
Query: 查询服务信息
Status: Raft一致性的状态信息
...
```
不过我目前就只需要当node程序启动时能将服务注册到consul中，关闭程序时能注销
我发现{% link Consul-SDK http://www.moye.me/2016/10/26/node-consul-sdk/ %}实现了这一点
使用方法在nodejs工程目录下运行命令安装,当时安装的版本为1.1.9，其中依赖的consul(即node-consul)版本为0.27.0，当前最新为0.34.1
```
npm i consul-sdk --save
```
在根目录下添加consul.json，<font color="#eb4d4b">check是我后面添加健康检查自己修改源码所加的配置</font>
```json
{
  "serverHost": "localhost",
  "serverPort": 18500,
  "secure": false,
  "name": "node-service",
  "host": "192.168.5.105",
  "port": 3000,
  "check":{
    "http":"http://192.168.5.105:3000/health",
    "interval":"10s"
  }
}
```
在app.js中引入consul-sdk
```javascript
require('consul-sdk');
```
这样在项目启动和结束就会触发相应的注册和注销操作
由于我现在的consul服务器端版本是1.3.0，这个js版本的consul客户端版本是0.27.0，其中注销时报错405，get方法不被允许
需要修改consul源码包中service.js中注销逻辑中get方法为put方法，和注册一样
{% img /images/java/springcloud/consul/node/node3.png %}
我们对比一下js版本的consul客户端和java版本的客户端(spring-cloud-starter-consul-discovery),在服务发现的功能上
```
js实现了服务注册和注销，但是还没有健康检查，如果注销失败会出现下面截图中出现的事情，服务在consul上依然存在并且正常
java实现了服务注册和健康检查，并没有服务注销(不知道是不是我没有配置)
```
其实node-consul是支持健康检查的，只不过consul-sdk不支持，但它是依赖node-consul来做的，我们把consul-sdk源码修改一下
其实consul-sdk是对consul的一层封装，作者用es5写的，可以借鉴思路自己改写
{% img /images/java/springcloud/consul/node/check-health1.png %}
同时配置文件添加上面那一段check.
{% img /images/java/springcloud/consul/node/check-health2.png %}
下面我们在我们之前实现的网关服务中**{% post_link springcloud使用zuul聚合微服务 %}**添加代码来调用一下node中的相关服务
添加服务类和控制类
```java
@Service
public class NodeRibbonService {

    @Autowired
    RestTemplate restTemplate;

    @HystrixCommand(fallbackMethod = "fallback")
    public String getHealthInfo() {
        return restTemplate.getForObject("http://node-service/health", String.class);
    }

    public String fallback(Throwable throwable) {
        System.out.println("node-service /health 报错:"+throwable);
        Map<String, Object> map = Maps.newHashMap();
        map.put("status", "unkown");
        return new Gson().toJson(map);
    }
}


@RestController
@RequestMapping("/un")
public class UserAndNodeController {
    @Autowired
    UserRibbonService userRibbonService;
    @Autowired
    NodeRibbonService nodeRibbonService;

    @RequestMapping(value = "/getUserAndNodeHealth",method = RequestMethod.GET)
    public Map<String, Object> getUserAndNodeHealth(){
        List<User> users = userRibbonService.getAllUsers1();
        String s = nodeRibbonService.getHealthInfo();
        Map<String, Object> map = Maps.newHashMap();
        map.put("users",users);
        map.put("node",s);
        return map;
    }
}
```
调用接口http://localhost:1051/un/getUserAndNodeHealth
{% img /images/java/springcloud/consul/node/node1.png %}
关掉node服务，但是没有在consul上注销并且consul上显示node服务正常
{% img /images/java/springcloud/consul/node/node2.png %}
利用上面修改源码程序退出成功在consul上注销后再调用
{% img /images/java/springcloud/consul/node/node4.jpg %}
关掉node程序，增加健康检查后，但是在consul上不注销，此时consul上显示node服务不健康，调用该接口直接走hytrix,和java类似
{% img /images/java/springcloud/consul/node/check-health3.png %}
# 参考资料
1.js版本的consul客户端 [https://github.com/silas/node-consul#agent-service-register]
2.Consul-SDK博客地址 [http://www.moye.me/2016/10/26/node-consul-sdk/]
3.consul-sdkgithub地址 [https://github.com/rockdragon/node-consul-sdk]
4.consul官网service的http api [https://www.consul.io/api/agent/service.html]
