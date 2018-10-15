---
title: okhttp3链式调用
date: 2018-10-13 16:47:18
tags:
- http调用客户端
categories:
- java
- http调用客户端
comments: true
---
# 前言
HTTP是现代应用常用的一种交换数据和媒体的网络方式，高效地使用HTTP能让资源加载更快，节省带宽。OkHttp是一个高效的HTTP客户端，它有以下默认特性：
```
支持HTTP/2，允许所有同一个主机地址的请求共享同一个socket连接
连接池减少请求延时
透明的GZIP压缩减少响应数据的大小
缓存响应内容，避免一些完全重复的请求
```

# 目的
介绍一些okhttp3的基本用法
<!-- more -->

# 正文
## 获取OkHttpClient客户端
{% codeblock %}
//简单获取
OkHttpClient client = new OkHttpClient();

//设置超时时间
private static final OkHttpClient client = new OkHttpClient.Builder()
            .connectTimeout(10, TimeUnit.SECONDS)
            .readTimeout(20, TimeUnit.SECONDS)
            .build();
{% endcodeblock %}

## get请求
### 普通get请求
{% codeblock %}
String url = "https://www.baidu.com/";
OkHttpClient okHttpClient = new OkHttpClient();
Request request = new Request.Builder()
    .url(url)
    .build();
Call call = okHttpClient.newCall(request);
try {
    Response response = call.execute();
    if (response.isSuccessful()) {
        System.out.println(response.body().string());
    }
} catch (IOException e) {
    e.printStackTrace();
}
{% endcodeblock %}

### 设置header参数
可以设置例如Cookie，User-Agent什么的
{% codeblock %}
Request request = new Request.Builder()
    .url(url)
    .header("键", "值")
    .header("键", "值")
    ...
    .build();
{% endcodeblock %}

## post请求
### 普通的表单提交
{% codeblock %}
String url = "https://www.baidu.com/";
OkHttpClient okHttpClient = new OkHttpClient();

RequestBody body = new FormBody.Builder()
    .add("键", "值")
    .add("键", "值")
    .build();

Request request = new Request.Builder()
    .url(url)
    .post(body)
    .build();

Call call = okHttpClient.newCall(request);
try {
    Response response = call.execute();
    System.out.println(response.body().string());
} catch (IOException e) {
    e.printStackTrace();
}
{% endcodeblock %}

# 参考资料
{% link OkHttp3的基本用法 简书 许宏川 https://www.jianshu.com/p/1873287eed87 %}