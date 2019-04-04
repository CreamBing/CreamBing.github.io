---
title: IDEA新建Gradle项目
comments: true
date: 2019-03-21 16:14:41
tags:
- IDEA
- Gradle
- springboot2
categories:
- IDEA
- 管理依赖
---
# 前言
利用 IDEA 快速新建一个 springboot2 的基于 gradle 依赖管理的项目
# 目的
利用 IDEA 快速新建一个 springboot2 的基于 gradle 依赖管理的项目
<!-- more -->

# 正文
#### 1.下载 gradle
网上也有教程说直接用 idea 自带的，但是为了性能，我选择下载当下最新版本-v5.3
下面是下载链接:https://gradle.org/releases/ ,我一般下载 complete 版本

#### 2.设置环境变量或者在IDEA中导入
如果只是在 IDEA 中新建，只需导入即可，但为了之后方便使用命令，遂添加环境变量
:camera:截图
{% img /images/java/DependencyManagement/gradle/gradle_success.png %}
:no_entry:
gradle5.3 需要在java8 环境下才能正确显示 gradle -v

#### 3.IDEA 新建 gradle 项目
:camera:截图
{% img /images/java/DependencyManagement/gradle/idea_gradle_1.png %}
{% img /images/java/DependencyManagement/gradle/idea_gradle_2.png %}

#### 4.IDEA 导入 gradle 的 springboot2 项目
在sprign官网生成项目骨架，然后利用idea导入
:camera:截图
{% img /images/java/DependencyManagement/gradle/springboot2-gradle.png %}

# 参考资料
1.spring 官网 