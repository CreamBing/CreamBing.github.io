---
title: java编程思想第四版第八章读书笔记
comments: true
date: 2019-01-16 23:34:40
tags:
- 书籍
- java
- java编程思想第四版
categories:
- 书籍
- java
- java编程思想第四版
---
# 前言
最近一段时间重读了java编程思想，把一些东西重新理解记录一遍
# 目的
整理知识点，方便以后回顾，这一章主要讲解了java的多态
<!-- more -->
# 正文
#### 1.多态
在面向对象的程序设计语言中，<font color="#eb4d4b">多态</font>是继数据<font color="#eb4d4b">抽象</font>和<font color="#eb4d4b">继承</font>之后的第三种基本特征
“封装”通过合并特征和行为来创建新的数据类型。（合并成员函数和方法创建类）
“多态”消除类型之间的耦合关系
多态也称做动态绑定，后期绑定或运行时绑定

#### 2.在论向上转型
子类对象的引用向上转型为基类，传递到相应方法中

#### 3.转机
将一个方法调用同一个方法主体关联起来被称作绑定。
程序执行前的绑定（由编译器和连接程序实现），称为前期绑定。
运行时根据对象的类型进行绑定，称为后期绑定，也称为动态绑定或运行时绑定。
Java中除了static方法和final方法（private属于final方法）外，其它所有方法都是动态绑定。
多态让程序员将“改变的事物与未改变的事物分离开来
注意:<font color="#eb4d4b">只有非private方法才能被覆盖，当然覆盖private类时，编译器不会报错。但是导出类和基类中的该同名方法，是两个不同的方法，向上转型为基类调用时，会调用基类的那个private的方法</font> 
静态方法是与类，而非单个对象关联的，因此不是多态的
任何域访问操作都有编译器解析，因此不是多态的
当Sub对象转型为Super使用时，任何域访问操作都将由编译器解析，因此不是多态的。（在包含相同成员变量时，子类包含两个域，基类和自己的，当要调用基类中该重名成员变量时，系统不会多态的自动的调用基类的该变量，需要显式的指明super.成员变量。）

#### 4.构造器和多态
当有多重继承关系时，调用构造器顺序：
基类构造器 -> 成员的初始化方法 -> 子类构造器
完整:基类staitic-->子类static-->基类基本类型设为默认值0，对象引用被设为Null-->基类构造器-->子类基本类型设为默认值0，对象引用被设为Null-->子类构造器
在销毁时，需要显式的调用基类的dispose()方法，销毁的顺序和初始化相反，包括字段的销毁顺序和申明的顺序相反。共享数据最后dispose()。
```java
/**
 * https://creambing.github.io Inc.
 * Copyright(c)2018-2025 All Rights Reserved.
 */
package com.creambing.thinkinginjava.polymorphism;

/**
 * Class Name: Share
 * Description: 清理，用来记录引用计数
 *
 * author: CreamBing
 * time: 2019-01-11 14:32
 * version: v1.0.0
 */
public class Share {

    private int refcount = 0;
    private static long counter = 0;
    private final long id = ++counter;

    public Share() {
        System.out.println("create"+this);
    }

    public void addRef(){
        refcount++;
    }

    public int getRefcount() {
        return refcount;
    }

    protected void dispose(){
        if(--refcount==0){
            System.out.println("dispose"+this);
        }
    }

    @Override
    public String toString() {
        return "Share{" +
                "refcount=" + refcount +
                ", id=" + id +
                '}';
    }

    public static void main(String[] args) {
        Share s1 = new Share();
        Share s2 = new Share();
        System.out.println("**********");
        System.out.println(s1);
        System.out.println("************");
        System.out.println(s2);
    }
}


/**
 * https://creambing.github.io Inc.
 * Copyright(c)2018-2025 All Rights Reserved.
 */
//package com.creambing.thinkinginjava.polymorphism;
/**
 * Class Name: Composing
 * Description: 共享类
 *
 * author: CreamBing
 * time: 2019-01-11 14:42
 * version: v1.0.0
 */
public class Composing {

    private Share share;
    private static long count = 0;
    private final long id = ++count;

    public Composing(Share share) {
        this.share = share;
        this.share.addRef();
        System.out.println("create "+this);
    }

    protected void dispose(){
        System.out.println("dispose "+this);
        share.dispose();
    }

    @Override
    public String toString() {
        return "Composing{" +
                "share=" + share +
                ", id=" + id +
                '}';
    }

}

/**
 * https://creambing.github.io Inc.
 * Copyright(c)2018-2025 All Rights Reserved.
 */
//package com.creambing.thinkinginjava.polymorphism;

/**
 * Class Name: ReferenceCounting
 * Description: 对象引用计数
 * <p>
 * author: CreamBing
 * time: 2019-01-11 14:48
 * version: v1.0.0
 */
public class ReferenceCounting {
    Share s1 = new Share();
    Composing[] ca;

    public ReferenceCounting() {
        this.ca = new Composing[]{new Composing(s1), new Composing(s1), new Composing(s1)};
    }

    @Override
    protected void finalize() throws Throwable {
        if (s1.getRefcount() != 0) {
            System.out.println("Composing没有清理干净，还有实例引用Share");
        } else {
            System.out.println("Composing清理干净，开始垃圾回收");
            super.finalize();
        }
    }

    /**
     * createShare{refcount=0, id=1}
     * create Composing{share=Share{refcount=1, id=1}, id=1}
     * create Composing{share=Share{refcount=2, id=1}, id=2}
     * create Composing{share=Share{refcount=3, id=1}, id=3}
     * dispose Composing{share=Share{refcount=3, id=1}, id=1}
     * c[0] dispose
     * 开始强制垃圾回收
     * *************************************
     * dispose Composing{share=Share{refcount=2, id=1}, id=2}
     * dispose Composing{share=Share{refcount=1, id=1}, id=3}
     * disposeShare{refcount=0, id=1}
     * ca[1],ca[2]清理，所有Composing对象清理完毕
     * 开始强制垃圾回收
     * Composing清理干净，开始垃圾回收
     * 注释掉********************************后面的东西
     * createShare{refcount=0, id=1}
     * create Composing{share=Share{refcount=1, id=1}, id=1}
     * create Composing{share=Share{refcount=2, id=1}, id=2}
     * create Composing{share=Share{refcount=3, id=1}, id=3}
     * dispose Composing{share=Share{refcount=3, id=1}, id=1}
     * c[0] dispose
     * 开始强制垃圾回收
     * *************************************
     * Composing没有清理干净，还有实例引用Share
     * @param args
     */
    public static void main(String[] args) {
        ReferenceCounting r = new ReferenceCounting();
        r.ca[0].dispose();
        System.out.println("c[0] dispose");
        System.out.println("开始强制垃圾回收");
        System.runFinalizersOnExit(true);
        System.out.println("*************************************");
        r.ca[1].dispose();
        r.ca[2].dispose();
        System.out.println("ca[1],ca[2]清理，所有Composing对象清理完毕");
        System.out.println("开始强制垃圾回收");
        System.runFinalizersOnExit(true);
    }
}
```
上面Share类中的下列代码实现了引用计数,refcount记录其他类中对这个类对象的引用数，id记录这是这个类的第几个实例，counter记录了这个类工实例的几次
不过下面的实现虽然巧妙但是并不完美，因为counter的值还是可以通过反射进行修改，详情可见**{% post_link EffectiveJava第三版第一条读书笔记 %}**
```
private int refcount = 0;
private static long counter = 0;
private final long id = ++counter;
```
构造器内部的多态方法的行为：
在初始化时，基类构造器中调用子类中覆盖的方法，此时子类的成员变量未赋值，如果此时对其操作可能会产生意想之外的结果。所以应该避免这样做。在构造器内唯一能够安全调用的事基类中的final方法。
<font color="#eb4d4b">编写构造器时一条有效的准则:用尽可能简单的方法使对象进入正常状态，如果可以的话，避免调用其它方法</font>

#### 5.协变返回类型
子类中被覆盖的方法可以返回基类方法所返回类型的子类，这样虽然返回值类型不同，但是也算覆盖。

#### 6.用继承进行设计
组合更加灵活，首选组合
用继承表达行为间的差异，用字段表达状态上的变化

状态设计模式
创建一个基类的引用，通过方法改变其所指向的对象类型（子类们），调用相同的方法，行为产生变化。（调用了相应子类的方法）。 这样可以实现动态灵活性。
如下所示：
```java
import static net.mindview.util.Print.*;
class Actor {
public void act() {}
}
class HappyActor extends Actor {
public void act() { print("HappyActor"); }
}
class SadActor extends Actor {
public void act() { print("SadActor"); }
}
class Stage {
private Actor actor = new HappyActor();
public void change() { actor = new SadActor(); }
public void performPlay() { actor.act(); }
}
public class Transmogrify {
public static void main(String[] args) {
Stage stage = new Stage();
stage.performPlay();
stage.change();
stage.performPlay();
}
} /* Output:
HappyActor
SadActor
```
对于子类扩展基类接口的情况，向上转型后不能调用子类的不同于基类的新方法。
这样需要用到向下转型，在Java中，所有的转型都会对其进行检查。称为“运行时类型识别”（RTTT）如果转型正确，则转型成功；如果所转类型不是正确的类型，则转型失败，返回ClassCastException异常。
父类引用可以指向子类对象，子类引用不可以指向父类对象
```java
class Useful {
public void f() {}
public void g() {}
}
class MoreUseful extends Useful {
public void f() {}
public void g() {}
public void u() {}
public void v() {}
public void w() {}
}
public class RTTI {
public static void main(String[] args) {
Useful[] x = {
new Useful(),
new MoreUseful()
};
x[0].f();
x[1].g();
// Compile time: method not found in Useful:
//! x[1].u();
((MoreUseful)x[1]).u(); // Downcast/RTTI
((MoreUseful)x[0]).u(); // Exception thrown
}
}
```

# 参考资料
https://blog.csdn.net/severusyue/article/details/51721940 Java编程思想第四版读书笔记——第八章 多态 severusyue