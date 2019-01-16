---
title: java编程思想第四版第九章读书笔记
comments: true
date: 2019-01-16 23:34:52
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
整理知识点，方便以后回顾，这一章主要讲解了java的接口
<!-- more -->
# 正文
#### 1.接口
接口和内部类为我们提供了一种将接口与实现分离的更加结构化的方法

#### 2.抽象类和抽象方法
```
public abstract void f();
```
创建抽象类是希望通过这个通用接口操纵一系列类。如果一个类包含大于等于一个抽象方法，那么这个类就是抽象类，必须用abstract关键字来限定这个抽象类。
如果试图直接创建该抽象类的对象，编译器会报错。
如果抽象类的子类没有为基类的抽象方法提供定义，那么这个导出类依旧是抽象类。
抽象类也可以不包含任何抽象方法，单纯的用abstract限定类。（该类不能产生对象）
抽象类是很有用的重构工具，它可以使我们可以很容易的将公共方法沿着继承层次结构向上移动

#### 3.接口
interface这个关键字替代class关键字，产生了一个完全抽象的类。接口只提供形式，未提供任何具体实现。
接口被用了建立类与类之间的协议。接口也可以包含域，但是这些域隐式的是static和final的。因此，其中定义的成员变量，是static&final的。
implenments关键字可以跟一组接口，extends关键字只能跟一个基类。
接口中的方法必须是public的，隐式的被声明public的，如果要显示声明，它们也必须被声明为public的。否则在继承的过程中，可访问权限被降低，这是java编译器所不允许的。

#### 4.完全解耦
策略设计模式：创建一个能够根据传递参数对象不同而具有不同行为的方法
```java
package interfaces.classprocessor;
import java.util.*;
import static net.mindview.util.Print.*;
class Processor {
public String name() {
return getClass().getSimpleName();
}
Object process(Object input) { return input; }
}
class Upcase extends Processor {
String process(Object input) { // Covariant return
return ((String)input).toUpperCase();
}
}
class Downcase extends Processor {
String process(Object input) {
return ((String)input).toLowerCase();
}
}
class Splitter extends Processor {
String process(Object input) {
// The split() argument divides a String into pieces:
return Arrays.toString(((String)input).split(" "));
}
}
public class Apply {
public static void process(Processor p, Object s) {
print("Using Processor " + p.name());
print(p.process(s));
}
public static String s =
"Disagreement with beliefs is by definition incorrect";
public static void main(String[] args) {
process(new Upcase(), s);
process(new Downcase(), s);
process(new Splitter(), s);
}
} /* Output:
Using Processor Upcase
DISAGREEMENT WITH BELIEFS IS BY DEFINITION INCORRECT
Using Processor Downcase
disagreement with beliefs is by definition incorrect
Using Processor Splitter
[Disagreement, with, beliefs, is, by, definition, incorrect]
```
适配器设计模式:当一个类是第三方jar中，你无法修改，但是你想用这个类实现某些接口，可以利用适配器模式，新建一个类实现接口，并将不可修改的类作为它的属性，利用这个属性的方法来实现接口，调用的时候在外面包一层
```java
/* Solution includes, in same package:
* package interfaces.interfaceprocessor;

* public class StringMixer {
*	static String process(String s) {
*		char[] ca = new char[s.length()];
*		if((s.length())%2 == 0) {
*			for(int i = 0; i < s.length(); i += 2) {
*				ca[i] = s.charAt(i + 1);
*				ca[i + 1] = s.charAt(i);			
*			}		
*			return new String(ca);
*		}
*		else {
*		for(int i = 0; i < s.length() - 1; i += 2) {
*				ca[i] = s.charAt(i + 1);
*				ca[i + 1] = s.charAt(i);			
*			}
*			ca[s.length() - 1] = s.charAt(s.length() - 1);		
*			return new String(ca);
*		}
*	}	
* }
*/
// program takes command line String argument:
package interfaces.interfaceprocessor;

class StringMixerAdapter implements Processor {
	public String name() { return "StringMixerAdapter"; }
	StringMixer stringMixer;
	public StringMixerAdapter(StringMixer stringMixer) {
		this.stringMixer = stringMixer;
	}
	public String process(Object input) {
		return stringMixer.process((String)input);
	}	
}

public class StringMixerProcessor {
	public static void main(String[] args) {
		String s = new String(args[0]);
		Apply.process(new StringMixerAdapter(new StringMixer()), s);
	}
}
```
#### 5.java中的多重继承
java没有任何与接口相关的存储，因此可以实现继承多个接口
使用接口的核心原因：1.为了能够向上转型为多个基本类型 2.顺带可以防止客户端程序员创建该类的对象，确保这是一个接口
java通过接口和内部类来达到多重继承的效果

#### 6.通过继承扩展接口
extends只能用于单一类，但是接口继承时却可以引用多个接口，用逗号分开。
```
interface Interface1 extends Interface2，Interface3{}
```
接口无法用implements来实现别的接口，必须用extends。
应该尽量避免组合的多个接口中包含相同方法名，这样会造成代码可读性的混乱。

#### 7.适配接口
类的构造器接受一个接口，将希望使用该类的类都实现该接口，这样可以类就可以作用于更多的类型。比如Scanner类，想使用该类的类型
和策略模式的不同：
方法可以作用于不同的类型。
而适配器模式是，将接口作为类的构造器参数，子类传入这个类，就能调用这个类的方法

#### 8、接口中的域
接口中的域是static&final的，所以常量初始化值会用大写字母的风格。
package interfaces;
public interface Months {
int
JANUARY = 1, FEBRUARY = 2, MARCH = 3,
APRIL = 4, MAY = 5, JUNE = 6, JULY = 7,
AUGUST = 8, SEPTEMBER = 9, OCTOBER = 10,
NOVEMBER = 11, DECEMBER = 12;
}

但是一般不这么做，在接口中定义常量，而是用enum关键字实现。
接口中定义的常量一定要初始化，不能出现空final，但是可以被非常量表达式初始化。

#### 9.嵌套接口
嵌套在另一个接口中的接口自动是 public 的，而不能声明为 private 的.
嵌套在另一个类中的接口可以是 private 的，可以在内部实现成为一个 public 类，但是这个类不允许向上转型
当实现某个接口是，并不需要实现嵌套在其内部的任何借口，而且，private接口不能在定义它的类之外被实现。

#### 10.接口与工厂
工厂设计模式：
在工厂对象上调用创建方法，该工厂对象将生成接口的某个实现对象。这样将代码与接口实现分离，这样使得我们可以透明的将某个实现替换成另一个实现。
```java
import static net.mindview.util.Print.*;
interface Service {
void method1();
void method2();
}
interface ServiceFactory {
Service getService();
}
class Implementation1 implements Service {
Implementation1() {} // Package access
public void method1() {print("Implementation1 method1");}
public void method2() {print("Implementation1 method2");}
}
class Implementation1Factory implements ServiceFactory {
public Service getService() {
return new Implementation1();
}
}
class Implementation2 implements Service {
Implementation2() {} // Package access
public void method1() {print("Implementation2 method1");}
public void method2() {print("Implementation2 method2");}
}
class Implementation2Factory implements ServiceFactory {
public Service getService() {
return new Implementation2();
}
}
public class Factories {
public static void serviceConsumer(ServiceFactory fact) {
Service s = fact.getService();
s.method1();
s.method2();
}
public static void main(String[] args) {
serviceConsumer(new Implementation1Factory());
// Implementations are completely interchangeable:
serviceConsumer(new Implementation2Factory());
}
} /* Output:
Implementation1 method1
Implementation1 method2
Implementation2 method1
Implementation2 method2
```
对消费者传递一个工厂1对象，产生工厂1的产品，调用产品1的方法。
对消费者传递一个工厂2对象，产生工厂2的产品，调用产品2的方法。

#### 总结：
> 确定接口是理想选择，因而应该总是选择接口而不是具体的类,对于创建类，几乎在任何时刻，都可以替代为创建一个工厂和一个接口

这其实是一种陷阱，变成了一种草率的设计优化，任何抽象性应该是真正的需求而产生的

# 参考资料
https://blog.csdn.net/severusyue/article/details/51766573  severusyue