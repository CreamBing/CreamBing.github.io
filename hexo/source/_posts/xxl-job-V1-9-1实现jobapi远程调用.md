---
title: xxl-job-V1.9.1实现jobapi远程调用
date: 2018-10-12 10:43:19
tags:
- xxl-job
- 分布式java调度框架
categories:
- java
- 分布式
- 任务调度框架
comments: true
---
# 前言
{% link xxl-job http://www.xuxueli.com/xxl-job/#/ %}是一个非常好用的分布式java任务调度框架,目前实际应用中框架建议我们在其管理页面手动新
增调度任务,但是由于一些情况,我们更加希望能够通过代码动态添加job,官方在job-core中提供了相关api,位置:<font color="#eb4d4b">com.xxl.job.core.biz.AdminBiz.java</font>但是
提供的功能有限,无法满足我们的需求,但是根据后面官方的说法，可以通过修改xxl-jobadmin的源码,实现其部分接口可以绕过登陆来远程调用

# 目的
通过修改xxl-jobadmin的源码,实现其部分接口可以绕过登陆来远程调用:
1、任务列表查询
2、任务新增
3、任务更新
4、任务删除
5、任务暂停
6、任务恢复
7、任务触发
<!-- more -->

# 正文
## 下载xxl-job-v1.9.1的源码
{% link xxl-job-v1.9.1 下载地址 https://github.com/xuxueli/xxl-job/releases %}
目前我们用的是v1.9.1的,此版本适合这种方式，如果是后续版本建议看一下官方文档，没准官方给出了更合适的方法

## 修改源码重新打包
准确修改位置为<font color="#eb4d4b">com.xxl.job.admin.controller.JobInfoController</font>中的接口方法上加上<font color="#f9ca24">@PermessionLimit(limit = false)</font>
{% img /images/xxl-job/xxl-jobadmin.jpg %}

## 测试
通过postman调用接口,一个是未修改源码的,请求被登陆拦截
{% img /images/xxl-job/xxl-jobadmin-fail.jpg %}
修改源码后，调用后通过json方式返回
{% img /images/xxl-job/xxl-jobadmin-success.jpg %}