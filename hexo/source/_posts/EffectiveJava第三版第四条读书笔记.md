---
title: EffectiveJava第三版第四条读书笔记
comments: true
date: 2019-01-31 23:57:39
tags:
- 书籍
- java
- EffectiveJava第三版
categories:
- 书籍
- java
- EffectiveJava第三版
---
# 前言
自己java编程已有两年，自己也写过一些轮子，也在工作中针对自己以前写的代码重构过，但是距离那些优秀的类库总有一些差距，最近在看 Effective Java 第三版，书中总结甚为精辟，遂在阅读过程中逐条写下笔记，以指导自己更加有效的使用 java 编程语言及基本类库,涵盖部分jdk 7,8,9 的新特性
# 目的
> Enforce noninstantiability with a private constructor
  通过私有构造器强化不可实例化的能力
<!-- more -->
# 正文
这个正是利用私有构造器的原因，例如 JDK 中 java.lang.Math 或者 java.util.Arrays 将基本类型的值或者数组类型上的相关方法利用静态方法组织起来
或者通过 java.util.Collections 的方式，把特定接口的对象上的静态方法，包括工厂方法组织起来
这样的工具类不希望被实例化，因为实例化对它没有任何意义
副作用:
这个类不能被子类化，无法被继承
```java
/**
 * https://creambing.github.io Inc.
 * Copyright(c)2018-2025 All Rights Reserved.
 */
package com.creambing.technicalbook.effectivejava3.creatinganddestroyingobjects.item4;

import java.util.HashMap;
import java.util.Map;

/**
 * Class Name: MapUtils
 * Description:
 * 通过私有构造器强化不可实例化的能力
 * Enforce noninstantiability with a private constructor
 * 使用范围：
 * 当需要编写只包含静态方法或者静态域的类时，例如 java.lang.Math java.uril.Arrays
 * 单例模式
 * 缺点：
 * 这个类不能被子类化，无法被继承
 * <p>
 * author: CreamBing
 * time: 2019-01-30 13:58
 * version: v1.0.0
 */
public class MapUtils {

    //私有构造，表示这个类初始化没有意义
    private MapUtils() {
        //可以防止反射实例化
        throw new AssertionError();
    }

    //在google guava类库中就有该工具方法，在方法类型推断还没有出来之前
    public static <K, V> HashMap<K, V> newHashMap() {
        return new HashMap<>();
    }

    public static void main(String[] args) {
        Map<String, String> map = MapUtils.newHashMap();
    }
}
```
# 参考资料