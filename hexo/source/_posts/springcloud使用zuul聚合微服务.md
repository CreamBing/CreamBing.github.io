---
title: springcloud使用zuul聚合微服务
date: 2018-10-30 16:08:28
tags:
- java
- springcloud
- zuul
- rxjava
categories:
- java
- springcloud
- zuul
- rxjava
comments: true
---
# 前言
1.**{% post_link springcloud编写用户微服务 %}**
2.**{% post_link springcloud编写电影微服务 %}**
3.**{% post_link springcloud集成网关ZUUL %}**
依上面教程，我已经实现了用户，电影微服务以及zuul网关，微服务的设计难点之一在于对原有业务的拆分，
在我看来每个微服务职责要尽可能单一，但是这样同样也带来了一个问题，那就是微服务之间不可避免的一
些交集.例如终端需要查询用户信息和电影信息，这里有两种做法
1.让终端查询用户信息后在查询电影信息
2.网关层查询用户信息和电影信息，聚合后返回给终端
后一种方式显然更好一些，因为他节省了带宽，相较于终端两次请求网关，显然网关两次请求微服务的网络情况更好
# 目的
利用RXJAVA聚合微服务，这里面其实很多东西可以讨论，关于分布式协议和分布式事务,这次先简单的说明
一下查询聚合，因为查询是幂等操作，不需要事务
<!-- more -->

# 正文
## 工程初始化
可以参见这篇博客**{% post_link springcloud集成网关ZUUL %}**
验证:
http://localhost:1051/api/user/user/getAll
http://localhost:1051/api/movie/movie/findOneById?id=2
{% img /images/java/springcloud/consul/zuul/zuul-um.png %}

## 集成feign,添加用户和电影的消费端
可以参见这篇博客**{% post_link springcloud集成feign %}**
仿照user创建movie的feign客户端
```
@FeignClient(name = "consul-movie")
public interface MovieFeignClient {

    @RequestMapping(value = "/movie/findOneById",method = RequestMethod.GET)
    Movie findOneById(@RequestParam("id") Long id);
}

错误的写法
@FeignClient(name = "consul-movie")
public interface MovieFeignClient {

    @RequestMapping(value = "/movie/findOneById",method = RequestMethod.GET)
    Movie findOneById(Long id);
}
```
get多参数写法
```
直接写Long id或者直接是User user这种对象，feign依然会用post方式调用，所以会报错接口不支持
需要用@RequestParam("id")注解，或者@RequestParam Map<String,Object> map
```
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
<font color="#eb4d4b">20181031更新:zuul上的service中添加hystrix回退并没有执行，如下图，想着service中利用的是
feign实现的，所以给feign加上回退，需要在配置上加上feign.hystrix.enabled=true</font>
{% img /images/java/springcloud/consul/zuul/zuul_rxjava_hystrix_failed.png %}
```java
@FeignClient(name = "consul-movie",fallback = MovieFeignClient.MovieFeignClientFallBack.class)
public interface MovieFeignClient {

    @RequestMapping(value = "/movie/findOneById",method = RequestMethod.GET)
    Movie findOneById(@RequestParam("id") Long id);

    @Component
    class MovieFeignClientFallBack implements MovieFeignClient{

        @Override
        public Movie findOneById(Long id) {
            Movie movie = new Movie();
            movie.setId(-1L);
            return movie;
        }
    }
}
//加上日志的版本
@FeignClient(name = "consul-movie",fallbackFactory = MovieFeignClient.MovieFeignClientFallBackFactory.class)
public interface MovieFeignClient {

    @RequestMapping(value = "/movie/findOneById",method = RequestMethod.GET)
    Movie findOneById(@RequestParam("id") Long id);

    @Component
    class MovieFeignClientFallBackFactory implements FallbackFactory<MovieFeignClient>{

        private static final Logger LOGGER = LoggerFactory.getLogger(MovieFeignClientFallBackFactory.class);
        @Override
        public MovieFeignClient create(Throwable throwable) {
            return new MovieFeignClient() {
                @Override
                public Movie findOneById(Long id) {
                    LOGGER.error("MovieFeignClient findOneById fallback;reason was:[{}]",throwable);
                    Movie movie = new Movie();
                    movie.setId(-1L);
                    return movie;
                }
            };
        }
    }
}
```

## 新建聚合controller和服务(RXjava)
针对feign实现的service,之前在上面截图中可以发现我在上面加了HystrixCommand没有用，所以去掉了，不知道是不是因为里面是feign实现的，所以下面会有ribbon实现
```java
/**
 * creambing.com Inc.
 * Copyright (c) 2016-2017 All Rights Reserved.
 */


package com.springcloud.consulzuulum.service.rxjava;

import com.springcloud.consulzuulum.feign.movie.Movie;
import com.springcloud.consulzuulum.feign.movie.MovieFeignClient;
import io.reactivex.Observable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Class Name:MovieService
 * Description:movie rxjava 服务类
 *
 * @author Bing
 * @version v1.0
 * @create 2018-10-30  22:01
 */
@Service
public class MovieService {

    @Autowired
    MovieFeignClient movieFeignClient;

    public Observable<Movie> findOneById(Long id) {
        return Observable.create(observer -> {
            Movie movie = movieFeignClient.findOneById(id);
            observer.onNext(movie);
            observer.onComplete();
        });
    }
}
```
控制类
```java
/**
 * creambing.com Inc.
 * Copyright (c) 2016-2017 All Rights Reserved.
 */


package com.springcloud.consulzuulum.controller;

import com.google.common.collect.Maps;
import com.springcloud.consulzuulum.feign.movie.Movie;
import com.springcloud.consulzuulum.feign.movie.MovieFeignClient;
import com.springcloud.consulzuulum.feign.user.User;
import com.springcloud.consulzuulum.feign.user.UserFeignClient;
import com.springcloud.consulzuulum.service.rxjava.MovieService;
import com.springcloud.consulzuulum.service.rxjava.UserService;
import io.reactivex.Observable;
import io.reactivex.Observer;
import io.reactivex.disposables.Disposable;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.context.request.async.DeferredResult;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Class Name:UserAndMovieController
 * Description:用户和电影聚合控制类
 *
 * @author Bing
 * @version v1.0
 * @create 2018-10-30  17:11
 */
@RestController
@RequestMapping("/um")
public class UserAndMovieController {

    @Autowired
    UserFeignClient userFeignClient;

    @Autowired
    MovieFeignClient movieFeignClient;

    @Autowired
    UserService userService;

    @Autowired
    MovieService movieService;

    @RequestMapping(value = "/getUserAndMovie", method = RequestMethod.GET)
    Map<String, Object> getUserAndMovie(Long id) {
        Long startTime = System.currentTimeMillis();
        Map<String, Object> result = new HashMap<>();
        //同步调用
        List<User> users = userFeignClient.getAllUser();
        Movie movie = movieFeignClient.findOneById(id);
        result.put("users", users);
        result.put("movie", movie);
        Long endTime = System.currentTimeMillis();
        System.out.println("getUserAndMovie同步调用花费时间:"+(endTime-startTime));
        return result;
    }

    @RequestMapping(value = "/getUserAndMovieUseRx", method = RequestMethod.GET)
    DeferredResult<HashMap<String,Object>> getUserAndMovieUseRx(Long id) {
        Long startTime = System.currentTimeMillis();
        //rx异步调用
        Observable<HashMap<String,Object>> observable = aggregateObservable(id);
        DeferredResult<HashMap<String,Object>> result = toDefer(observable);
        Long endTime = System.currentTimeMillis();
        System.out.println("getUserAndMovieUseRx异步调用花费时间:"+(endTime-startTime));
        return result;
    }

    public Observable<HashMap<String,Object>> aggregateObservable(Long id){
        return Observable.zip(
                userService.getAllUsers(),
                movieService.findOneById(id),
                (users,movie) -> {
                    HashMap<String,Object> map = Maps.newHashMap();
                    map.put("users",users);
                    map.put("movie",movie);
                    return map;
                }
        );
    }

    public DeferredResult<HashMap<String,Object>> toDefer(Observable<HashMap<String,Object>> details){
        DeferredResult<HashMap<String, Object>> result = new DeferredResult<>();
        details.subscribe(new Observer<HashMap<String, Object>>() {
            @Override
            public void onSubscribe(Disposable disposable) {
                System.out.println("");
            }

            @Override
            public void onNext(HashMap<String, Object> stringObjectHashMap) {
                result.setResult(stringObjectHashMap);
            }

            @Override
            public void onError(Throwable throwable) {
                System.out.println("发生错误:"+throwable);
            }

            @Override
            public void onComplete() {
                System.out.println("完成");
            }
        });
        return result;
    }

}
```
访问
http://localhost:1051/um/getUserAndMovie?id=1
http://localhost:1051/um/getUserAndMovieUseRx?id=1


