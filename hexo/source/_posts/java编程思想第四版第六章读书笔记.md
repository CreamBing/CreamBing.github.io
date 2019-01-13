---
title: java编程思想第四版第六章读书笔记
date: 2019-01-13 11:39:08
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
整理知识点，方便以后回顾，这一章主要讲解了java的访问权限控制
<!-- more -->
# 正文
#### 1.包:库单元
Java代码文件，也可以成为编译单元（有时也成为转译单元）。
编译单元内有一个public类，该类名称必须与文件名称相同。
每个编译单元只能有一个public类。
Java包命名规则是必须全是小写字母。
package和import将单一的全局名字空间分开，使得不会出现名称冲突问题。
想要使用某类，需要指定全名或者使用import关键字，import可以使用该包中的public类。
使用静态导入 import static可以在系统中使用包中静态的方法。
<font color="#eb4d4b">jdk5之前需要设置classpath,那是因为引入jar需要指定jar的具体目录，因为java编译需要调用javac,5之前依赖tools.jar，相当与"javac -Calsspath=%JAVA_HOME%\lib\tools.jar  xx.xxx.Main  XXX.java"所以需要设置，jdk5之后不建议设置classpath,设置javahome的原因也是方便命令的输入</font>

#### 2.Java访问权限修饰词
访问权限：
不加修饰词，就是包访问权限。包内所有其他类对那个成员都有访问权限。对包外类都是private。
取得某成员访问权限的唯一途径是：
1、该成员是public
2、不加权限修饰词并将其他类放在同一个包内，包内其它成员可访问此成员。
3、继承而来的类既可以访问public又可以访问protected。
4、通过访问器和变异器方法（get/set方法），以读取和改变值。

public:接口访问权限：
任何人都可以访问它。不同包里的都可以。

默认包：
对于隶属于相同目录却没有给自己设定任何包名称的文件，Java默认其为该目录的默认包里，这样它们之间的包访问权限可以使它们互相访问。
private:私有
除了包含该类成员的类（这个private成员在的类）之外，任何其他类都无法访问这个成员。
好处：
1、可以控制如何创建该对象，别人必须使用特定构造器创建，例如单例模式，如果默认构造器是唯一并且是自己定义的private构造器，那么它可以防止被继承
2、对于辅助方法，可以指定其为private，防止误用它
protected:继承访问权限
protected成员除了只能被派生类使用外，还提供包访问权限。

#### 3.接口和实现
访问权限的控制常被称为具体实现的隐藏，这被便是“封装”。

#### 4.类的访问权限
1、每个编译单元（文件）只能有一个public类
2、public类的名称必须与文件名相匹配，包括大小写.
类只能是public或者包访问权限的，除了内部类
单例模式的五种实现方式
1.饿汉式(线程安全，调用效率高，但是不能延时加载)
```java
public class ImageLoader{ 
     private static ImageLoader instance = new ImageLoader();
     private ImageLoader(){} 
     public static ImageLoader getInstance(){  
          return instance;  
      } 
}
```
上来就把单例对象创建出来了，要用的时候直接返回即可，这种可以说是单例模式中最简单的一种实现方式。但是问题也比较明显。单例在还没有使用到的时候，初始化就已经完成了。也就是说，如果程序从头到位都没用使用这个单例的话，单例的对象还是会创建。这就造成了不必要的资源浪费。所以不推荐这种实现方式。
2.懒汉式(线程安全，调用效率不高，但是能延时加载)：
```java
public class SingletonDemo2 {
     
    //类初始化时，不初始化这个对象(延时加载，真正用的时候再创建)
    private static SingletonDemo2 instance;
     
    //构造器私有化
    private SingletonDemo2(){}
     
    //方法同步，调用效率低
    public static synchronized SingletonDemo2 getInstance(){
        if(instance==null){
            instance=new SingletonDemo2();
        }
        return instance;
    }
}
```
3.Double CheckLock实现单例：DCL也就是双重锁判断机制（由于JVM底层模型原因，偶尔会出问题，不建议使用）
```java
public class SingletonDemo5 {
        private volatile static SingletonDemo5 SingletonDemo5;
 
        private SingletonDemo5() {
        }
 
        public static SingletonDemo5 newInstance() {
            if (SingletonDemo5 == null) {
                synchronized (SingletonDemo5.class) {
                    if (SingletonDemo5 == null) {
                        SingletonDemo5 = new SingletonDemo5();
                    }
                }
            }
            return SingletonDemo5;
        }
    }
```
4.静态内部类实现模式（线程安全，调用效率高，可以延时加载）
```java
public class SingletonDemo3 {
     
    private static class SingletonClassInstance{
        private static final SingletonDemo3 instance=new SingletonDemo3();
    }
     
    private SingletonDemo3(){}
     
    public static SingletonDemo3 getInstance(){
        return SingletonClassInstance.instance;
    }
     
}
```
5.枚举类（线程安全，调用效率高，不能延时加载，可以天然的防止反射和反序列化调用）
```java
public enum SingletonDemo4 {
     
    //枚举元素本身就是单例
    INSTANCE;
     
    //添加自己需要的操作
    public void singletonOperation(){     
    }
}
```
如何选用：
-单例对象 占用资源少，不需要延时加载，枚举 好于 饿汉
-单例对象 占用资源多，需要延时加载，静态内部类 好于 懒汉式

#### 5.总结
控制对成员的访问有两个原因：
1、是用户不要去触碰不该触碰的部分
2、让库类设计者可以改变类内部工作的方式，而不必担心对客户端程序员产生重大影响。

# 参考资料
https://blog.csdn.net/severusyue/article/details/49175943?utm_source=blogxgwz1 Java编程思想第四版读书笔记——第六章 访问权限控制 severusyue
https://www.cnblogs.com/ngy0217/p/9006716.html java单例模式几种实现方式 点点积累