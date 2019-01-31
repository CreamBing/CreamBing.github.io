---
title: EffectiveJava第三版第一条读书笔记
comments: true
date: 2019-01-14 11:02:18
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
> Consider static factory methods instead of constructors
  用静态工厂方法代替构造器
<!-- more -->
# 正文
#### 思考
对于类而言，为了让客户端获取它自身的一个实例，最传统的方法就是提供一个公有的构造器，<font color="#eb4d4b">但同时，你是否应该考虑提供一个公有的静态工厂方法，来返回此类的实例的静态方法?</font>

#### 提供静态工厂方法的优势
```
 * 它们有名字,比起构造方法的不同参数列表，静态工厂方法能提供有含义且带有参数的初始化方法
 * 不用每次被调用时都创建新对象，例如单例模式
 * 可以返回原返回类型的子类，设计模式中的基本的原则之一—— 『里氏替换』 原则，就是说子类应该能替换父类。这项技术用于基于接口的框架，例如Collections Framework API
 * 返回的对象的类可以随着每次调用而发生变化，这取决于静态工厂方法的参数值。例如EnumSet
 * 方法返回的对象所属的类，在编写包含该静态工厂方法的类时，可以不存在，构成了服务提供者框架(Service Provider Framework)例如 JDBC API
```
我们现在对每条优点来实践一下
1.它们有名字
假设我们有一个苹果类 (Appale.java) 它有三个属性:颜色(color)，重量(weight)和是否好吃(delicious)
```java
/**
 * creambing.com Inc.
 * Copyright (c) 2016-2017 All Rights Reserved.
 */


package com.creambing.effectivejava;

/**
 * Class Name:Apple
 * Description:静态工厂代替构造器
 *
 * @author Bing
 * @create 2019-01-14  11:32
 * @version v1.0
 */
public class Apple {

    //设为final表示一旦建造成功不许修改
    //这里不能设为final,因为final定义的要不在定义时候初始化，要不在构造器初始化
    private  Color color;
    private int weight;//单位为g
    private boolean delicious;//是否好吃 true:好吃，false:不好吃

    private Apple() {
    }

    //作为例子讲解，本应注释掉
    public Apple(Color color, int weight) {
        this.color = color;
        this.weight = weight;
    }

    //作为例子讲解，本应注释掉
    public Apple(Color color, int weight, boolean delicious) {
        this.color = color;
        this.weight = weight;
        this.delicious = delicious;
    }

    public Color getColor() {
        return color;
    }

    public void setColor(Color color) {
        this.color = color;
    }

    public int getWeight() {
        return weight;
    }

    public void setWeight(int weight) {
        this.weight = weight;
    }

    public boolean isDelicious() {
        return delicious;
    }

    public void setDelicious(boolean delicious) {
        this.delicious = delicious;
    }

    //**********上面的是一个标准的 javabeans 除了将无参构造器设置为私有的*********************************************

    public static Apple newInstance(){
        return new Apple();
    }

    public static Apple createRedDelicious(){
        return Apple.newInstance().withColor(Color.RED).withDelicious(Boolean.TRUE);
    }

    public static Apple createRedNoDelicious(){
        return Apple.newInstance().withColor(Color.RED).withDelicious(Boolean.FALSE);
    }

    //********************上面提供了三个静态工厂方法，很明显意义更加明确而且用户不会调用出错，封装性更好******************
    //那这个跟set方法没什么区别了
    public Apple withColor(Color c){
        this.color = c;
        return this;
    }

    public Apple withWeight(int w){
        this.weight = w;
        return this;
    }

    public Apple withDelicious(Boolean b){
        this.delicious = b;
        return this;
    }

    //*******************为了不破坏 javabeans 规范，又达到链式调用的目的，新增的一系列 withxxx() 方法******************

    @Override
    public String toString() {
        return "Apple{" +
                "color=" + color +
                ", weight=" + weight +
                '}';
    }

    public enum Color{
        RED,GREEN
    }

    public static void main(String[] args) {
        //设置一个5克的绿色苹果
        Apple a = Apple.newInstance().withColor(Color.GREEN).withWeight(5);
        System.out.println(a);
        //设置一个好吃的红苹果,直接将好吃和不好吃封装到了api里面，通过函数名字表示，用户就很难调用错误的方法
        Apple a1 = Apple.createRedDelicious();
        //我不得不传一个重量的参数，虽然 0g 的红苹果现实没意义，但是如果是其它可选参数了，另外第三个参数我们也有可能写错，到底是ture好吃，还是false好吃，我们不得不去看api
        Apple a2 = new Apple(Color.RED,0,Boolean.TRUE);
    }
}

```
类中的注释很好的说明了问题，另外调用时候的意义也更加明确
```
//设置一个好吃的红苹果,直接将好吃和不好吃封装到了api里面，通过函数名字表示，用户就很难调用错误的方法
Apple a1 = Apple.createRedDelicious();
//我不得不传一个重量的参数，虽然 0g 的红苹果现实没意义，但是如果是其它可选参数了，另外第三个参数我们也有可能写错，到底是ture好吃，还是false好吃，我们不得不去看api
Apple a2 = new Apple(Color.RED,0,Boolean.TRUE);
```
2.单例模式
这里可以看一下之前在读java编程思想-类的访问权限的时候所做的笔记:**{% post_link java编程思想第四版第六章读书笔记 %}**
3.基于接口的框架
例如 jdk 中 java.util.Collections.java 类其中的很多方法就是返回类型是一个接口，其真正返回的是它的子类对象
```
public static <T> Collection<T> unmodifiableCollection(Collection<? extends T> c) {
        return new UnmodifiableCollection<>(c);
    }
```
扩展:https://blog.csdn.net/cilen/article/details/7744969 Collections.unmodifiableList方法的使用与场景
4.返回的对象的类可以随着每次调用而发生变化，这取决于静态工厂方法的参数值
例如 jdk 中 EnumSet 的noneOf方法
```
public static <E extends Enum<E>> EnumSet<E> noneOf(Class<E> elementType) {
    Enum<?>[] universe = getUniverse(elementType);
    if (universe == null)
        throw new ClassCastException(elementType + " not an enum");
    if (universe.length <= 64)
        return new RegularEnumSet<>(elementType, universe);
    else
        return new JumboEnumSet<>(elementType, universe);
}
```
5.方法返回的对象所属的类，在编写包含该静态工厂方法的类时，可以不存在，构成了服务提供者框架(Service Provider Framework)例如 JDBC API
TODO:等我看了相关api再来记录

#### 提供静态工厂方法的缺点
```
 * .类如果不含有公有的或者受保护的构造器，就不能被子类化
 * .程序员很难发现它们
```

#### 常用静态工厂方法的取名
```
*                       from: 类型转化方法
 *                        of: 聚合方法，带有多个参数，返回该类型的一个实例，把它们合并起来
 *                   valueOf：该方法返回的实例与它的参数具有相同的 “值” 。
 *                   getType：返回的类型是根据方法的参数来描述的，但是不能够说与参数具有相同的值。就像是针对类型的getInstance，但是在工厂方法处于不同的类中的时候使用
 *                   newType：像newInstance一样，但是在工厂方法处于不同的类中的时候使用
 *                      type: getType和newType的简版
 * instance 或者 getInstance: 返回的实例是根据方法的参数来描述的，但是不能够说与参数具有相同的值。一般用来表示获取相同的实例，如单例模式，或根根参数获取不同的单例等。
 *   create 或者 newInstance：类似于getInstance。不同的是，一般用来表示获取新的实例，如Class#newInstance()方法等
 *                              Class#newInstance()破坏了编译时的检查：
 *                              newInstance方法总是企图调用类的无参构造器。这个构造器甚至可能根本不存在，或者用户无访问权限，但编译期间你不会收到任何错误
 *                              newInstance方法还会传播由无参构造器抛出的任何异常，即使newInstance缺乏相应的throws子句
```
梨子:
```java
/**
 * https://creambing.github.io Inc.
 * Copyright(c)2018-2025 All Rights Reserved.
 */
package com.creambing.effectivejava3;

import com.google.common.collect.Maps;

import java.util.EnumSet;
import java.util.HashMap;
import java.util.Map;

/**
 * Class Name: StaticFactory
 * Description: 考虑用静态工厂方法代替构造器
 * 优势:
 * 它们有名字,比起构造方法的不同参数列表，静态工厂方法能提供有含义且带有参数的初始化方法
 * 不用每次被调用时都创建新对象，例如单例模式
 * 可以返回原返回类型的子类，设计模式中的基本的原则之一—— 『里氏替换』 原则，就是说子类应该能替换父类。这项技术用于基于接口的框架，例如Collections Framework API
 * 返回的对象的类可以随着每次调用而发生变化，这取决于静态工厂方法的参数值。例如EnumSet
 * 方法返回的对象所属的类，在编写包含该静态工厂方法的类时，可以不存在，构成了服务提供者框架(Service Provider Framework)例如 JDBC API
 *
 *缺点
 * 1.类如果不含有公有的或者受保护的构造器，就不能被子类化
 * 2.程序员很难发现它们
 *
 * 静态工厂方法惯用名称：
 *                      from: 类型转化方法
 *                        of: 聚合方法，带有多个参数，返回该类型的一个实例，把它们合并起来
 *                   valueOf：该方法返回的实例与它的参数具有相同的 “值” 。
 *                   getType：返回的类型是根据方法的参数来描述的，但是不能够说与参数具有相同的值。就像是针对类型的getInstance，但是在工厂方法处于不同的类中的时候使用
 *                   newType：像newInstance一样，但是在工厂方法处于不同的类中的时候使用
 *                      type: getType和newType的简版
 * instance 或者 getInstance: 返回的实例是根据方法的参数来描述的，但是不能够说与参数具有相同的值。一般用来表示获取相同的实例，如单例模式，或根根参数获取不同的单例等。
 *   create 或者 newInstance：类似于getInstance。不同的是，一般用来表示获取新的实例，如Class#newInstance()方法等
 *                              Class#newInstance()破坏了编译时的检查：
 *                              newInstance方法总是企图调用类的无参构造器。这个构造器甚至可能根本不存在，或者用户无访问权限，但编译期间你不会收到任何错误
 *                              newInstance方法还会传播由无参构造器抛出的任何异常，即使newInstance缺乏相应的throws子句
 *
 * author: CreamBing
 * time: 2019-01-13 14:53
 * version: v1.0.0
 */
public class StaticFactory {

    /**
     * 需要引入依赖
     * <dependency>
     *     <groupId>com.google.guava</groupId>
     *     <artifactId>guava</artifactId>
     *     <version>27.0.1-jre</version>
     * </dependency>
     * @param args
     */
    public static void main(String[] args) {
        //不过自从 java7 开始,由于泛型参数是可以被推导出，所以可以在创建实例时省略掉泛型参数。
        Map<String,String> map = new HashMap<>();
        //google guava类库 我们来看看别人类库是怎么封装的
        /*
            public static <K, V> HashMap<K, V> newHashMap() {
                return new HashMap();
            }
         */
        Map<String,String> map1 = Maps.newHashMap();
        /*
        *
            public static <E extends Enum<E>> EnumSet<E> noneOf(Class<E> elementType) {
                Enum<?>[] universe = getUniverse(elementType);
                if (universe == null)
                    throw new ClassCastException(elementType + " not an enum");
                if (universe.length <= 64)
                    return new RegularEnumSet<>(elementType, universe);
                else
                    return new JumboEnumSet<>(elementType, universe);
            }
        * */
        //jdk8内部实现,它返回两种子类之一的一个实例，取决于传入枚举类型的大小
        EnumSet<Season> enumSet = EnumSet.of(Season.SUMMER, Season.WINTER);
    }

    enum Season {
        SPRING, SUMMER, FALL, WINTER
    }
}

```
# 参考资料
https://blog.csdn.net/cilen/article/details/7744969 Collections.unmodifiableList方法的使用与场景 cilen