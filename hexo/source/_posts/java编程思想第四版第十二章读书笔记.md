---
title: java编程思想第四版第十二章读书笔记
comments: true
date: 2019-01-20 13:55:47
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
整理知识点，方便以后回顾，这一章主要讲解了java的通过异常处理错误
<!-- more -->
# 正文
#### 1.通过异常处理错误
Java的基本理念是“结构不佳的代码不能运行”。
Java中异常处理的目的在于通过使用少于目前数量的代码来简化大型、可靠的程序的生成，并且通过这种方式可以使程序员增加自信

#### 2.概念
因为异常机制将保证能够捕获这个错误，所以不用小心翼翼的各种去检查。而处理错误只需要在一个地方完成，那就是 异常处理程序。
只需要在异常处理程序中处理错误。

#### 3.基本异常
异常情形是指阻止当前方法或作用域继续执行的问题。
异常处理程序将程序从错误状态中恢复，以使程序要么换一种方式运行，要么继续运行下去。
在没有其它办法的情况下，异常允许我们强制程序停止运行，并告诉我们出现了什么问题。理想状态下，还可以强制程序处理问题，并返回到稳定状态的。
异常参数：
用new在堆上创建异常对象，所有标准异常类都有两个构造器，一个默认的，一个带参的。
能够抛出任意类型的Throwable对象，它是异常类型的根类。

#### 4.捕获异常
监控区域是一个可能产生异常的代码，并且后面跟着处理这些异常的代码。
如果在方法内部抛出了异常，那么这个方法就此结束。如果不希望这个方法结束，那么可以在方法内设置一个特殊的块来捕获异常，即try块。为什么叫try呢，因为在这个块里“尝试”各种可能产生异常的方法进行调用，所以是try。
```
try {
// Code that might generate exceptions
} catch(Type1 id1)|{
// Handle exceptions of Type1
} catch(Type2 id2) {
// Handle exceptions of Type2
} catch(Type3 id3) {
// Handle exceptions of Type3
}
```
异常抛出后，异常处理机制将搜索参数与异常类型相匹配的第一个处理程序，进入catch语句处理，此时认为异常的到了处理。catch子句结束，则处理程序不再往下找匹配了。
终止与恢复：
异常处理理论上有两种基本模型，java支持终止模型。该模型假设错误非常关键，一旦异常被抛出，那么错误已经无可挽回，程序不能继续执行。
另一种模型是恢复模型，就是先修正错误，然后重新进入该方法。这个模型假定了修正完之后再进入执行一定会成功。
相比较终止模型还是比较占优的，因为恢复模型需要了解异常抛出的地点，麻烦。

#### 5.创建自定义异常
可以异常类不写构造函数，使用默认无参构造函数，也可以写构造函数。酱紫可以实现在抛出的异常后面打印出异常所在函数等功能。比如：
```java
class MyException extends Exception { 
       public MyException() {} 
       public MyException(String msg) { super(msg); } 
     } 
```
在抛出异常时
```
public static void g() throws MyException { 
          System.out.println("Throwing MyException from g()"); 
          throw new MyException("Originated in g()"); 
       } 
```
那么，在打印的时候，就可以打印出
```
MyException: Originated in g() 
```
在异常处理程序中，调用Throwable类的printStackTrace()方法，那么“从异常方法调用处直到异常抛出处”的方法调用序列将被打印出来
```
MyException 
     at FullConstructors.f(FullConstructors.java:11) 
     at FullConstructors.main(FullConstructors.java:19) 
```
printStackTrace()方法可以带参数，比如printStackTrace(System.out)，这样打印出来的信息将被发送到System.out，如果该方法不带参，那么信息将被输出到标准错误流
异常与记录日志
使用java.util.logging工具将输出记录到日志中
当然，不能指望每个程序员把记录日志的程序的基础设施都构建在异常里，所以更常见的情形是需要捕获和记录他人编写的异常，因此需要在异常处理程序中生成日志消息
我们甚至可以进一步定义异常，比如加入额外的构造器和成员，然而一般来说并不会用上这些功能
**TODO:** 现在都用的slf4j集成log4j来记录日志的，这里分享一下好用的日志框架集成方法

#### 6.异常说明
异常说明使用了关键字 throws，后面接一个潜在的异常类型列表。
void f() throws TooBig, TooSmall, DivZero { //...
这种在编译时被强制检查的异常称为被检查的异常。
也可以声明方法将抛出异常，但是实际上却不抛出。这样做可以先为异常占个位置，以后可以抛出这类异常而不用修改已有方法，这种“作弊”方法通常用在你定义抽象基类和接口时，这样派生类或者接口实现就能抛出这些预先声明的异常。

#### 7.捕获所有异常
捕获异常类型的基类Exception（还有其它基类），这可以保证异常一定会被捕获，最好把它放到异常处理程序列表的末尾
```
catch(Exception e) {
System.out.println("Caught an exception");
}
Exception可以调用其从基类继承的方法：
String getMessage( )
String getLocalizedMessage( )
```
获取详细信息（抛出异常对象所带的参数），或者用本地语言表示的详细信息。
栈轨迹：
printStackTrace()方法所提供的信息可以通过getStackTrace()方法来直接访问，该方法返回一个由栈轨迹元素所构成的数组，每个元素表示栈中的一帧，元素0也是栈顶元素，是最后调用的方法（Throwable被创建和抛出之处），最后一个元素是栈底，是调用序列的第一个方法调用。

重新抛出异常
挡在异常处理模块里继续抛出异常，那么printStackTrace()方法显示的将是原来异常抛出点的调用栈信息，而非重新抛出点的的信息。
此时可以使用fillinStackTrace()方法
```
catch(Exception e) {
System.out.println("An exception was thrown");
throw (Exception)e.fillInStackTrace();
}
```
调用fillInStackTrace()的这一行就成为异常的新发生地了。
在异常捕获之后抛出另一种异常，其效果类似于fillInStackTrace()

异常链
在捕获一个异常后抛出另一个异常，并希望把原始异常的信息保存下来，这被称为异常链。
Throwable的子类可以在构造器中接受一个case对象作为参数。这个case参数表示原始异常，这样通过把原始异常传递给新的异常。
Throwable子类，只有三种基本异常提供了带case参数的构造器，它们是Error(用于Java虚拟机报告系统错误)、Exception以及RuntimeException。

#### 8.Java标准异常
Throwable对象可分为两种类型（指从Throwable继承而得到的类型）：Error用来表示编译时和系统错误，Exception是可以被抛出的基本类型，包括Java类库，用户方法以及运行时故障都可以抛出此异常。
Error一般不用自己关心，来讲Exception:
特例RuntimeException
比如nullPointerException，空指针异常。
运行时产生的异常，不需要在异常说明中声明方法将抛出RuntimeException类型的异常。它们被称为“不受检查的异常”。这种异常属于错误，会被自动捕获，而不用程序员自己写代码捕获。
如果RuntimeException没有被捕获而直达main()，那么在程序退出前将调用异常的printStackTrace()方法。

#### 9.使用finally进行清理
在异常处理程序后面加上finamlly子句，可保证无论try块里的异常是否抛出，都能执行。（通常适用于内存回收之外的情况）
finally执行未必要放在最后，正常的顺序执行到它就是它了
```java
import static net.mindview.util.Print.*;
class FourException extends Exception {}
public class AlwaysFinally {
public static void main(String[] args) {
print("Entering first try block");
try {
print("Entering second try block");
try {
throw new FourException();
} finally {
print("finally in 2nd try block");
}
} catch(FourException e) {
System.out.println(
"Caught FourException in 1st try block");
} finally {
System.out.println("finally in 1st try block");
}
}
} /* Output:
Entering first try block
Entering second try block
finally in 2nd try block
Caught FourException in 1st try block
finally in 1st try block
```
当涉及break和continue时，finally子句也会得到执行。
如果把finally子句和带标签的break以及continue配合使用，在java里没必要使用goto语句了。
有return语句时，finally依旧会执行。
异常丢失：
在一个异常还没得到处理的情况下，应该尽量避免抛出另一个异常。
1、使用finally可能导致一个异常还没处理，在接下来的finally字句中又抛出了一个异常，那么前一个异常就会丢失，外面的catch块捕捉到的就是finally抛出的异常而未察觉到最开始抛出的异常。
2、一种更简单的丢失异常的方式是在finally语句中直接return，这就更别说到catch块匹配异常了。
应该避免以上两种编程错误。

#### 10.异常的限制
当覆盖 方法时，只能抛出在基类方法的异常说明里列出的那些异常或者不抛出，但是不能新增异常说明。这个限制意味着，当基类代码运用到派生类时，依旧有用
当处理派生类对象时，编译器只会强制要求捕获派生类该方法产生的异常。如果向上转型为基类，编译器会要求捕获基类方法产生的异常。很智能的。
异常说明本身并不属于方法类型的范畴中，因此不参与重载的判断。
基于特定方法的“异常说明的接口”不是变大了而是变小了，小于等于基类异常说明表——这恰好和类接口在继承时的情形相反

#### 11.构造器
> 如果异常发生了，所有东西能正常清理吗？

例如io操作的时候，文件没有正常的构造，在finally中却要file.close，所以一般在close中又加一层try catch
基本规则是:在创建需要清理的对象之后，立即进入一个try-finally块，不过新版jdk有新的语法了

#### 12.异常的匹配
异常匹配并不要求与抛出的异常完全匹配，也可以匹配该异常的基类。
如果故意把基类异常放在前面，导致子类异常的catch子句永远得不到执行，编译器会报错。

#### 13.其它可选方式
1、将异常传递给控制台，使用FileInputStream进行打开关闭操作，记录在一个文件中。
2、用RuntimeException来包装“被检查的异常”。

# 参考资料
https://blog.csdn.net/severusyue/article/details/51780879 Java编程思想第四版读书笔记——第十二章 通过异常处理错误 severusyue 