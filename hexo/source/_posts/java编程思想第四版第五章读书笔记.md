---
title: java编程思想第四版第五章读书笔记
date: 2019-01-11 00:20:18
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
整理知识点，方便以后回顾，这一章主要讲解了java的初始化和清理
<!-- more -->

# 正文
#### 1.用构造器确保初始化
使用构造器（constructor），在创建对象时初始化。分为带参数的初始化和不带参数的初始化。
构造器初始化之前会先进行域的初始化，基本类型和String会被给予相应默认值

#### 2.方法重载
类型提升（向上提升）：int — long — float — double
                    byte — short — int 
                    char — int 
窄化转换：和向上提升反过来，注意先考虑降到byte再考虑char
返回值是无法区分重载方法的

#### 3.默认构造器
没有构造器的时候，系统会自动生成一个无参的默认构造器。如果写了构造器，就别指望系统生成了，所以如果写了带参构造器，就不能无参初始化了。
另外只有私有构造器，该类无法继承

#### 4.this关键字
this关键字只能在方法内部使用，表示对“调用方法的那个对象”的引用。
尽管可以用this调用一个构造器，但不能调用两个。当在一个构造器中调用另一个构造器时，需要用到this关键字。并且置于最起始处
将自身传递到外部方法，必须用this关键字
```java
public class Peeler {

    //需要把工具类写出来
    static Apple peel(Apple apple){
        System.out.println("皮削了");
        return apple;
    }
}

public class Apple {

    Apple getPeeled(){
        return Peeler.peel(this);
    }

    public static void main(String[] args) {
        Apple a = new Apple();
        a.getPeeled();
    }
}
```
除构造器外，编译器禁止在其他任何方法中调用构造器。
static方法是没有this的方法。所以有些人认为static方法不是“面向对象”的，这个概念还是有争议的

#### 5.清理：终结处理和垃圾回收
垃圾回收器只知道释放那些经由new分配的内存。
```
对象可能不被垃圾回收。
垃圾回收不等于“析构”。
垃圾回收只与内存有关（使用垃圾回收器的唯一原因就是回收程序不再使用的内存）。
```
不应该将finalize()作为统一的清理方法，因为它可能不被执行，这是一个陷阱。
无论是“垃圾回收”还是“终结”，都不保证一定会发生。
finalize()还有一个有趣的用法，它并不依赖于每次都要对finalize()进行调用，这就是对象“终结条件”的验证。
System.gc() 用于强制进行终结动作。比如
强制进入finalize（随着程序的运行也许程序自己也会调用这个方法），当某个关系的标记量有异，打印出来。可供程序员找出程序代码尤其是创建对象时隐晦的缺陷。

垃圾回收器如何工作：
Java虚拟机采用一种自适应的垃圾回收技术。
要是没有新垃圾及产生，就会转换到 "标记——清扫"工作模式。
"标记——清扫"所依据的思路同样是从堆栈和静态存储区出发，遍历所有的引用，进而找出存活的对象，给对象一个标记。全部标记工作完成后，清理动作才会开始。
“停止——复制”的回收动作不是在后台运行的，它发生时，程序将会被暂停。它将所有活对象从旧堆复制到新堆，然后再释放旧堆中的对象所占内存。
如果所有对象都很稳定，垃圾回收器的效率降低，就切换到“标记——清扫”方式，同样，Java虚拟机会追踪“标记——清扫”的效果，如果堆空间出现很多碎片，就会切换回“停止——复制”方式。
Java虚拟机中有很多附加技术提升速度，比如“即时”编译器技术。这种技术将程序全部或部分翻译成本地机器码。
```java
public class Practice11 {

    @Override
    protected void finalize() throws Throwable {
        System.out.println("我被清理了");
        super.finalize();
    }


    /**
     * output
     * Try 1:
     * Try 2:
     * Try 3:
     * Try 4:
     * 我被清理了
     * @param args
     */
    public static void main(String[] args) {
        Practice11 p = new Practice11();
        System.out.println("Try 1: ");
        System.runFinalization();
        System.out.println("Try 2: ");
        Runtime.getRuntime().runFinalization();
        System.out.println("Try 3: ");
        System.gc();
        System.out.println("Try 4: ");
        // using deprecated since 1.1 method:
        System.runFinalizersOnExit(true);
    }
}
//用于终结条件的判断
public class Practice12 {
    //默认true,满的
    private boolean flag=true;

    public Practice12(boolean flag) {
        this.flag = flag;
    }

    @Override
    protected void finalize() throws Throwable {
        if(flag){
            System.out.println("我是满的,我被清理了");
            super.finalize();
        }else {
            System.out.println("我不是满的,我不清理");
        }
    }


    /**
     * output
     * true
     * false
     * 我不是满的,我不清理
     * 我是满的,我被清理了
     * @param args
     */
    public static void main(String[] args)throws Exception {
        Practice12 p = new Practice12(true);
        Practice12 p1 = new Practice12(false);
        System.runFinalizersOnExit(true);
        Thread.sleep(10000);
        //貌似会保证引用调用完被清理
        System.out.println(p.flag);
        System.out.println(p1.flag);
    }
}
```

#### 6.成员的初始化
所有变量在使用前都能得到适当的初始化。对于函数局部变量，Java以编译错误的形式强制初始化。不初始化编译就不成功。下面是各类型基本数据的初始值
```
     boolean            false 
     char               [ ] 
     byte               0 
     short              0 
     int                0 
     long               0 
     float              0.0 
     double             0.0 
     reference          null 
```

#### 7.构造器的初始化
无法阻止自动初始化的进行，它将在构造器被调用之前发生。因此，编译器不会强制一定在构造器某个地方或者在使用它们之前对元素进行初始化——因为初始化早已得到了保证。

静态数据初始化：
静态数据只占用一份存储区域。静态初始化只有在必要时候进行。只有在第一个类型对象创建（或第一次访问静态数据）的时候，他们才会被初始化。此后，静态对象不会再被初始化。
初始化顺序：
静态对象（只一次）——> 非静态对象——>构造器
可以使用静态块的方式，对静态对象成员进行初始化，放在static关键字后面，如下：
```java
public class Spoon { 
       static int i; 
       static { 
          i = 47; 
       } 
     }
```
非静态实例初始化：
```java
public class Mug {
    Mug mug1;
    Mug mug2;
    {
        mug1 = new Mug(1);
        mug2 = new Mug(2);
        System.out.println("mug1 & mug2 initialized");
    }
    Mug() {
    }
    Mug(int i) {
    }
}
```
如上，看起来比静态块少了个static关键字，它保证了每新建一个该类的对象，不论调用何种构造器，这些操作都会发生。实例初始化子句是发生在构造器之前执行.另外这种语法对于匿名内部类的初始化是必须的

#### 8.数组初始化
注意数组的别名问题。
不确定在数组里需要多少个元素时，可以直接new。在运行时再创建。这里再提一下，数组元素中基本数据类型，数字和字符会被自动初始化为0，而布尔型会自动初始化为false。
Array.toString()方法属于java.util标准类库，它将产生一维数组的可打印版本。
试图使用数组中的空引用（null），则会在运行时产生异常。
可变参数列表(C通常称之为varags)：
所谓可变参数列表，可以理解为函数的参数列表中某类型的数量是不确定的。这个特性是在JavaSE5之后添加的。
```
static void printArray(Object... args) { 
          for(Object obj : args) 
            System.out.print(obj + " "); 
          System.out.println(); 
       } 
```
有了可变参数，就不用显示的编写数组语法了，当指定参数，编译器会自动填充数组。也就是输入一个列表，编译器会自动将其转化为数组，作为可变参数列表接受。
0个参数传递给可变参数列表是可行的，当局有可选的尾随参数时，这一特性就会很有用。
对于如下方法：
```
 static void f(int required, String... trailing) { 
          System.out.print("required: " + required + " "); 
          for(String s : trailing) 
            System.out.print(s + " "); 
          System.out.println(); 
       } 
```
f(0)是可以代入的，尽管并没有String类型参数。
getClass()方法属于Object的一部分，它将产生对象的类，并且在打印该类时，可以看到该类型的编码字符串。前导[表示int类型。
它是这样用的：
```
static void g(int... args) { 
          System.out.print(args.getClass()); 
          System.out.println(" length " + args.length); 
       }
```
输出是这样的：
```
     class [Ljava.lang.Character; length 1 
     class [Ljava.lang.Character; length 0 
     class [I length 1 
     class [I length 0 
     int[]: class [I 
```
可以在单一的参数列表中将类型混合在一起，而自动包装机制将有选择的将Int提升为Integer。可变参数列表使重载变得复杂，编译器无法知道应该调用哪种方法。因此应当总是只在重载的一个版本上使用可变参数列表，或者压根不用。
数组初始化的几种方式
```
基本数据类型
        int[] a = new int[10];//创建大小为10的int数组并自动初始化为零
        int[] a1 = {1,2};//创建并初始化
        int[] a2 = new int[]{1,2,4};
        int[] a3 = IntStream.of(1, 2, 3, 4, 5).toArray();
        Arrays.stream(a).forEach(System.out::print);
        System.out.println();
        Arrays.stream(a1).forEach(System.out::print);
        System.out.println();
        Arrays.stream(a2).forEach(System.out::print);
        System.out.println();
//对于包装类型
        Integer[] b1 = {1,2};//创建并初始化
        Integer[] b2 = new Integer[]{1,2,4};
        Integer[] b3 = Stream.of(1, 2, 3, 4, 5).toArray(Integer[]::new);
        //nullnullnullnullnullnullnullnullnullnull
        Integer[] b4 = new Integer[10];
        //试图使用数组中的空引用，空指针异常
        if(b4[0]==0){
            System.out.println("b4[0]==0");
        }
        Stream.of(b4).forEach(System.out::print);
```

#### 9.枚举类型
ava SE5添加了enum关键字
（枚举类型的实例都是常量，因此都用大写字母表示，如果有多个单词，就用下划线隔开。）
创建一个枚举类型：
```java
public enum Spiciness {
            NOT,MILD,MEDIUM,HOT,FLAMING
    }
```
创建enum实例：
Spiciness howHot = Spiciness.MEDIUM;
enum的一些特性：
toString() 函数可以方便的显示某个实例的名字。
ordinal() 函数可以显示某个特定enum常量的申明顺序。
static values() 函数可以按照enum常量的申明顺序构成相应数组。
枚举类型可以配合switch case使用。

# 参考资料
https://blog.csdn.net/severusyue/article/details/48633599 Java编程思想第四版读书笔记——第五章 初始化与清理 severusyue