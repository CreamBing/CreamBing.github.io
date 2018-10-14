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