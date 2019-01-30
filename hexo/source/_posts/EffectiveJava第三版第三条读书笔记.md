---
title: EffectiveJava第三版第三条读书笔记
comments: true
date: 2019-01-30 23:14:57
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
> 用私有构造器或者枚举类型强化Singleton属性
<!-- more -->
# 正文
#### 利用枚举类型实现单例-天然的防止反射和反序列化调用
```java
public enum  SingletonWithEnum {
    //枚举元素本身就是单例
    INSTANCE;

    //添加自己需要的操作
    public void singletonOperation(){
        System.out.println("complete singleton");
    }
}
```
这里貌似没有提供私有构造，其实在enum内部实现中隐藏了私有构造
```
枚举类实现其实省略了private类型的构造函数
枚举类的域(field)其实是相应的enum类型的一个实例对象
```
推荐的写法时面向接口
```java
public interface MySingleton {

    void doSomething();
}
```
```java
public enum MySingletonImpl implements MySingleton {
    INSTANCE;

    @Override
    public void doSomething() {
        System.out.println("complete singleton");
    }

    public static MySingleton getInstance() {
        return MySingletonImpl.INSTANCE;
    }
}
```
#### 静态内部类实现单例
```java
public class Singleton {
    private static class SingletonHolder {
        private static final Singleton INSTANCE = new Singleton();
    }

    private Singleton() {
    }

    public static Singleton getInstance() {
        return SingletonHolder.INSTANCE;
    }
}
```
解决序列化和反射漏洞需如下修改
```java
public class Singleton2 implements Serializable {

    private static class SingletonHolder {
        private static final Singleton2 INSTANCE = new Singleton2();
    }
    private Singleton2() {
        // 防止反射获取多个对象的漏洞
        if (null != SingletonHolder.INSTANCE) {
            throw new RuntimeException("it is a Singleton");
        }
    }
    public static Singleton2 getInstance() {
        return SingletonHolder.INSTANCE;
    }
    // 防止反序列化获取多个对象的漏洞
    private Object readResolve() throws ObjectStreamException {
        return SingletonHolder.INSTANCE;
    }
}
```
如何选用：
-单例对象 占用资源少，不需要延时加载，枚举 好于 饿汉
-单例对象 占用资源多，需要延时加载，静态内部类 好于 懒汉式
# 参考资料
https://blog.csdn.net/qq_27093465/article/details/52180865 Java 枚举(enum) 详解7种常见的用法
https://www.jianshu.com/p/4e8ca4e2af6c Java 单例模式的两种高效写法