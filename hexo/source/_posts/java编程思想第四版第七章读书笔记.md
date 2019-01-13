---
title: java编程思想第四版第七章读书笔记
date: 2019-01-13 12:24:29
tags:
- 书籍
- java
- java编程思想第四版
categories:
- 书籍
- java
- java编程思想第四版
comments: true
---
# 前言
最近一段时间重读了java编程思想，把一些东西重新理解记录一遍
# 目的
整理知识点，方便以后回顾，这一章主要讲解了java的复用类
<!-- more -->
# 正文
#### 1.组合语法
满足has-a关系
在类中，创建一个其它类的对象，使用该对象的一些方法，对这个对象进行操作。
类中域为基本类型时能自动被初始化为0，对象引用会被初始化为Null。
初始化类中的引用，可以在四种情况下进行：
1、在定义对象的地方（在类的构造器调用之前就初始化了）
2、在类的构造器中
3、在需要使用这些对象之前（惰性初始化）
4、使用实例初始化

#### 2.继承语法
使用继承我们一般认为导出类是一个或者像是一个，满足is-a或者is-like-a的关系，例如圆形是一个几何形
当创建一个导出类对象时，该对象包含了一个基类子对象。当初始化时，构造器的调用遵循由内到外的顺序，默认情况下调用基类的无参构造器，基类构造器都有参时，可以用super(“参数”)显式的调用基类构造器。

#### 3.代理
代理和组合就是不满足继承关系，他们是包含关系，比如飞机包含控制系统
当一个类并不是另一个类的子类型，却要完全或部分用到另一个类的全部方法时，可以用代理。
在类Ship中创建另一个类的对象controls，然后构造所需要的全部方法，在方法里只需要使用相应的controls.方法。即可使用对象类的所有方法。

#### 4.结合使用组合和继承
虽然编译器强制初始化基类，但是不强制初始化成员对象，所有在用组合的时候应该注意要自己初始化成员对象。
可以使用try finally强制对内存进行回收清理，自己编写函数回收内存，此时回收顺序是由外向内，最后使用super.dispose()回收基类内存。
Java中导出类重载某个基类方法，它并不会屏蔽其在基类中的任何版本，也就是在参数列表类型符合的情况下，基类中的该方法依旧可用。
@override是覆写关键字，如果添加这个注解而错误的重载（没有覆写）该方法，那么编译器会报错。
覆写（override）：函数名一样，返回值类型，参数列表类型都一样。子类函数的访问权限不能小于父类。
重载（overlode）：函数名一样，参数列表不一样，返回值类型可以相同也可以不同。
以上两种都是程序多态性的体现。
自己编写清理方法，不要使用finalize();1.可能永远不会调用，即使被调用也是按照他想要的顺序来回收
```java
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

#### 5.在组合和继承之间选择
is-a 继承
hsa -a 组合

#### 6.protected关键字
关键字protected表明，就类用户而言，它是private的，就继承自此类的导出类或者其它位于同一个包的类来说，它是可以访问的。
最好将域保持为private的，保留更改底层实现的权利。然后通过protected方法控制类的继承者的访问权限。

#### 7.向上转型
将导出类转型成基类，继承要慎用，需要向上转型时，推荐使用继承。
向上转型会丢失方法和域

#### 8.final关键字
final数据：
对于基本类型，final使数值恒定不变。对于对象的引用，final使引用恒定不变，但是对象自身是可以修改的。注意:数组也是一种引用。
带有恒定初值（即：编译期常量）的final static 基本类型全用大写命名，并且字与字之间用下划线隔开。
必须在域的定义处或者构造器中用表达式对final进行赋值，这真是final域在使用前总是初始化的原因。
final参数：
在函数参数列表中的final参数，在函数内无法修改它
f(final int i){ i++; } //非法
final方法：
使用场景：
1、把方法锁定，防止继承类修改，覆盖它。
2、提高效率。（逐渐淘汰）
类中所有的private方法都隐式地指定为final的。因为private方法无法被外界取用，所以并不算基类接口的一部分，所以尽管导出类含有相同名称的方法，但是互不干扰，也没有覆盖。

final类：
使用场景：
不可以作为基类被继承。

#### 9.初始化及类的加载
类的代码在初次使用时才会被加载，通常是指加载发生在创建类的第一个对象之时，在访问static域或static方法时，也会发生加载。
注意，只要加载包含static方法的类，static初始化就会执行。注意子类创建对象调用构造器时基类构造器也会被调用，此时基类会被加载，基类的static将会被初始化。
基类staitic-->子类static-->基类基本类型设为默认值0，对象引用被设为Null-->基类构造器-->子类基本类型设为默认值0，对象引用被设为Null-->子类构造器

#### 总结
继承和组合都是从现有类型生成新类型，组合一般是将现有类型作为新类型的底层实现的一部分来加以复用，而继承复用的是接口，这对多态来说至关重要，所以分析一个系统的时候应该弄清楚那些是is-a,那些是has=a关系
# 参考资料
https://blog.csdn.net/severusyue/article/details/49274695 Java编程思想第四版读书笔记——第七章 复用类 severusyue