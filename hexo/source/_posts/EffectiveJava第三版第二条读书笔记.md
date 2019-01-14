---
title: EffectiveJava第三版第二条读书笔记
comments: true
date: 2019-01-14 13:50:49
tags:
categories:
---
# 前言
自己java编程已有两年，自己也写过一些轮子，也在工作中针对自己以前写的代码重构过，但是距离那些优秀的类库总有一些差距，最近在看 Effective Java 第三版，书中总结甚为精辟，遂在阅读过程中逐条写下笔记，以指导自己更加有效的使用 java 编程语言及基本类库,涵盖部分jdk 7,8,9 的新特性
# 目的
> 遇到多个构造器参数时要考虑使用构建器
<!-- more -->
# 正文
*例:用一个类表示包装食品外面显示的营养成分标签，其中有几个域是必须的*
**当有一个类需要多个参数的构造器，我们一般最开始考虑到的是重叠构造器**
```java
// Telescoping constructor pattern - does not scale well! (Pages 10-11)不能很好的扩展
public class NutritionFacts {
    private final int servingSize;  // (mL)            required
    private final int servings;     // (per container) required
    private final int calories;     // (per serving)   optional
    private final int fat;          // (g/serving)     optional
    private final int sodium;       // (mg/serving)    optional
    private final int carbohydrate; // (g/serving)     optional

    public NutritionFacts(int servingSize, int servings) {
        this(servingSize, servings, 0);
    }

    public NutritionFacts(int servingSize, int servings,
                          int calories) {
        this(servingSize, servings, calories, 0);
    }

    public NutritionFacts(int servingSize, int servings,
                          int calories, int fat) {
        this(servingSize, servings, calories, fat, 0);
    }

    public NutritionFacts(int servingSize, int servings,
                          int calories, int fat, int sodium) {
        this(servingSize, servings, calories, fat, sodium, 0);
    }
    public NutritionFacts(int servingSize, int servings,
                          int calories, int fat, int sodium, int carbohydrate) {
        this.servingSize  = servingSize;
        this.servings     = servings;
        this.calories     = calories;
        this.fat          = fat;
        this.sodium       = sodium;
        this.carbohydrate = carbohydrate;
    }

    public static void main(String[] args) {
        //servingSize，servings,calories,fat,sodium,carbohydrate
        NutritionFacts cocaCola =
                new NutritionFacts(240, 8, 100, 0, 35, 27);
    }
    
}
```

如上面 main 方法中的调用方法所示：假设我们需要设置 sodium 和 carbohydrate 的值，但是我们不想要设置 fat 的值，如上所见，所调用的构造器需要我们设置我们不想设置的参数，除非我们在编写一个构造器，内部用 set 方法初始化.
> 重叠构造器在有很多参数的时候，客户端代码会很难编写并且难以阅读，另外其本身也不能很好的扩展

**那我们现在考虑更为普遍的一种方式:  JavaBeans**
```java
// JavaBeans Pattern - allows inconsistency, mandates mutability  (pages 11-12)允许不一致，强制要求可变性
public class NutritionFacts {
    // Parameters initialized to default values (if any)
    private int servingSize  = -1; // Required; no default value
    private int servings     = -1; // Required; no default value
    private int calories     = 0;
    private int fat          = 0;
    private int sodium       = 0;
    private int carbohydrate = 0;

    public NutritionFacts() { }
    // Setters
    public void setServingSize(int val)  { servingSize = val; }
    public void setServings(int val)     { servings = val; }
    public void setCalories(int val)     { calories = val; }
    public void setFat(int val)          { fat = val; }
    public void setSodium(int val)       { sodium = val; }
    public void setCarbohydrate(int val) { carbohydrate = val; }

    public static void main(String[] args) {
        NutritionFacts cocaCola = new NutritionFacts();
        cocaCola.setServingSize(240);
        cocaCola.setServings(8);
        cocaCola.setCalories(100);
        cocaCola.setSodium(35);
        cocaCola.setCarbohydrate(27);
    }
}
```
JavaBeans 方法的缺点：
```
由于 JavaBeans 方式将构造过程分隔到了几个调用过程中，在构造过程中 JavaBeans 可能处于不一致的状态，无法仅仅通过检查构造器参数的有效性在保证一致性
JavaBeans 模式使得把类做成不可变的可能性不复存在，也就是说可能存在线程安全问题
```
那么这里我们扩展一下 SpringMVC 中的单例模式，我们知道 controller -> service -> dao 这个流程，他们的对象都是单例的，想想一下这些单例的对象在处理我们传给后台的实体 bean 时会不会有问题了？如果一个张三带着正确密码在登陆的同时，一个李四在登陆，如果是单例并且状态可变，那么最后校验是张三和李四的密码导致他登陆失败？
答：是不会有问题的，因为我们的实体bean是前台的json串反序列化，或者我们自己 new,然后拼装起来的，所以他并不是单例模式。另外这也说明单例模式中存在可变域可能导致线程不安全，因此 1.在 controller 类中不要定义非单例成员变量 2.万一必须要定义一个非静态成员变量时候，则通过注解@Scope(“prototype”)，将其设置为多例模式
另外上网查了下(未验证)了 JavaBeans 的反序列化的三种工具：fastJson  JackJson 以及 Gson

```
Gson是通过反射遍历该类中的所有属性，并把其值序列化成json
三个工具类的序列化结果跟类的set方法没有关系。
JackJson和FastJson序列化结果跟get方法有关系
```

**第三种方法就是建造者模式**
```java
public class NutritionFacts {
    //必须域
    private final int servingSize;
    //必须域
    private final int servings;
    //卡路里
    private final int calories;
    //脂肪
    private final int fat;
    //钠
    private final int sodium;
    //糖类
    private final int carbohydrate;

    public static class Builder {
        // Required parameters
        private final int servingSize;
        private final int servings;

        // Optional parameters - initialized to default values
        private int calories      = 0;
        private int fat           = 0;
        private int sodium        = 0;
        private int carbohydrate  = 0;

        //必须参数通过唯一构造器初始化
        public Builder(int servingSize, int servings) {
            this.servingSize = servingSize;
            this.servings    = servings;
        }

        public Builder calories(int val)
        { calories = val;      return this; }
        public Builder fat(int val)
        { fat = val;           return this; }
        public Builder sodium(int val)
        { sodium = val;        return this; }
        public Builder carbohydrate(int val)
        { carbohydrate = val;  return this; }

        public NutritionFacts build() {
            return new NutritionFacts(this);
        }
    }

    private NutritionFacts(Builder builder) {
        servingSize  = builder.servingSize;
        servings     = builder.servings;
        calories     = builder.calories;
        fat          = builder.fat;
        sodium       = builder.sodium;
        carbohydrate = builder.carbohydrate;
    }

    public static void main(String[] args) {
        NutritionFacts cocaCola = new NutritionFacts.Builder(240, 8)
                .calories(100).sodium(35).carbohydrate(27).build();
    }
}
```
从上面的链式调用可以发现，这样做确实比较优雅，但是他开销比较大。由于上面的这个建造器的属性都设置的final,所以在建造后就无法在修改了？这里有几个疑问？
1.建造器模式是否只是应用于不可变类？
2.假设我们要对建造器模式类中的一个属性值在建造后重新赋值，我们怎么做？将  final 去掉，提供 setter 方法吗？如果这样，它和静态内部类中的对应属性是否就不一致了，而且 api 混乱，导致初始化域的方法有两个？
3.建造器模式的序列化和反序列化？还是上一个问题，静态内部类的属性和建造器内的属性是否需要保持一致，如果是利用 fastjson 的话，内部和外部都得提供 getter 方法，如此种种，感觉建造器模式还是适合工具类，不太适合 web 中的 javabeans,比如表单。尽管可能提供多个参数的构造方法
4.由建造器模式的链式调用想到 JavaBeans 的 setter 方法为什么不return this了，这样就可以链式调用了？

比如 guava 中 Ordering 的链式调用
```java
/**
 * creambing.com Inc.
 * Copyright (c) 2016-2017 All Rights Reserved.
 */


package com.creambing;

import com.google.common.collect.Ordering;
import org.junit.Assert;
import org.junit.Test;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.hamcrest.core.IsEqual.equalTo;

/**
 * Class Name:BuilderModeTest
 * Description:建造者模式测试
 *
 * @author Bing
 * @create 2019-01-14  16:05
 * @version v1.0
 */
public class BuilderModeTest {

    /**
     * 将空值放置在最前面的情况
     */
    @Test
    public void testOrderNaturalByNullFirst() {
        List<Integer> list = Arrays.asList(1, 5, null, 3, 8, 2);
        Collections.sort(list, Ordering.natural().nullsFirst());
        System.out.println("空在最前面-排序后" + list.toString());
        Assert.assertThat(list.toString(),equalTo("[null, 1, 2, 3, 5, 8]"));
    }
}

```
```
类的定义
public abstract class Ordering<T> implements Comparator<T> {}
@GwtCompatible(
    serializable = true
)
final class NaturalOrdering extends Ordering<Comparable> implements Serializable {}
@GwtCompatible(
    serializable = true
)
final class NullsFirstOrdering<T> extends Ordering<T> implements Serializable {}

Ordering抽象类中的静态方法，返回他的子类NaturalOrdering的一个实例，这是个饿汉式不可变单例
@GwtCompatible(
        serializable = true
    )
    public static <C extends Comparable> Ordering<C> natural() {
        return NaturalOrdering.INSTANCE;
    }
NaturalOrdering中的成员变量
static final NaturalOrdering INSTANCE = new NaturalOrdering();
Ordering抽象类中的一个公共方法
@GwtCompatible(
        serializable = true
    )
    public <S extends T> Ordering<S> nullsFirst() {
        return new NullsFirstOrdering(this);
    }
NaturalOrdering中的重写了
public <S extends Comparable> Ordering<S> nullsFirst() {
        Ordering<Comparable> result = this.nullsFirst;
        if (result == null) {
            result = this.nullsFirst = super.nullsFirst();
        }

        return result;
    }
```
从上可以看到跟构造器关系不大，更符合第一点，用静态工厂方法代替构造器，基于接口编程，初始化返回其子类对象,接着在调基类接口方法
# 参考资料