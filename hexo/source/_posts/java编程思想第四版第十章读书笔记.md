---
title: java编程思想第四版第十章读书笔记
comments: true
date: 2019-01-18 00:00:45
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
整理知识点，方便以后回顾，这一章主要讲解了java的<font color="#eb4d4b">内部类</font>
<!-- more -->
# 正文
#### 1.内部类
可以将一个类的定义放在另一个类的定义内部，这就是内部类
内部类和组合是完全不同的概念

#### 2.创建内部类
内部类是嵌在外部类内部的类。
如果想从外部类的非静态方法创建一个内部类对象，一定要用“. ”,Outer Class . InnerClass
比如： Parcel2.Contents c = q.contents();

#### 3.链接到外部类
内部类可以访问外围对象的所有成员。对外围类的所有元素都有访问权。
内部类的对象只有在于外部类的对象相关联时才能被创建。当某个外围类对象创建一个内部类对象，此内部类的对象必定会秘密的捕获一个指向那个外围类对象的引用。依赖于外部对象，也就是，必须是外部类对象 . 某方法（）    的方式创建
下面是"迭代器"设计模式的一个梨子
```java
public class Sequence{
        private Object[] items;
        private int next=0;
        public Sequence(int size){
            items=new Object[size];
        }
        private class SequenceSelector{
            private int i=0;
            public boolean end(){
                return i=items.length;//
            }
            public void next(){
                i++;
            }
        }
        public SequenceSelector selector(){
            return new SequenceSelector();
        }
        
        public static void main(String[] args){
            Sequence seq=new Sequence();
            Sequence.SequenceSelector=seq.selector();
        }        
    }
```

#### 4.使用.this和.new
内部类创建外部类对象，return OuterClass.this;
在其它地方创建内部类，要用外围类对象创建，而不是用类名。 OuterClass.InnerClass inner = outer.new Inner();
在拥有外部类对象之前是不可能创建内部类对象的，这是因为内部类对象会暗暗的连接到创建他的外部类对象上，但是如果你创建的是嵌套类(静态内部类),就不需要对外部类对象的引用了
```java
public class DotThis{
        void f(){}
        public class Inner{
            public DotThis outer(){
                return DotThis.this;
            }
        }
        public Inner inner(){return new Inner();}
        public static void main(String[] args){
            DotThis dt=new DotThis();
            DotThis.Inner dti=dt.new Inner();
            dti.outer().f();
        }
    }
```

#### 5.内部类与向上转型
接口的所有成员自动被设置为public
private内部类给类的设计者提供了一种途径，通过这种方式可以完全阻止任何依赖于类型的编码，并且完全隐藏了细节。因为是private，所以除了外围类不能访问它，只能通过outer.contents() 方法return的new出来。 因为上转型为接口，所以隐藏了原本的类型。
由于不能访问任何新增加的，原本不属于公共接口的方法，所以扩展接口是没有价值的。这也给Java编译器提供了生成更高效代码的机会。因为转型只能转型成接口类型，收窄了
```java
public interface Destination{
    String readLabel();
}
public interface Contents{
    int value();
}

class Parcel{
    private class PContents implements Contents{
        public int value(){return 10;}
    }
    
    protected class PDestination implements Destination{
        public String readLabel(){
            return "Hello word";
        }
    }
    
    public PContent contents(){
        return new PContents();
    }
    public PDestination destination(){
        return new PDestination();
    }
}
public class TestParcel{
    public static void main(String[] args){
        Parcel p=new Parcel();
        Contents c=p.contents();
        Destination d=p.destination();
    }
}
```

#### 6.在方法和作用域内的内部类
可以在一个方法或者任意的作用域内定义内部类，这样做有两个理由：
1、实现了某类型的接口，于是可以创建并返回对其的引用。
2、要解决一个复杂的问题，想创建一个类来辅助解决方案，但是不希望这个类是公用的。
可以看到内部类可以在以下定义
```
一个定义在方法中的类
一个定义在作用域的类，此作用域在方法的内部
一个实现了接口的匿名类
一个匿名类，它扩展了有非默认构造器的类
一个匿名类，他执行字段初始化
一个匿名类，它通过实例初始化实现构造
```
下面两个梨子实现了前两个
```java
//方法内部类(又称局部内部类)
public class Parcel{
    //方法
    public Destination destination(){
        //方法内部类
        class PInner implements Destination{
            public String say(){
                return "Hello word!";
            }
        }
        return new PInner();
    }
    
    public static void main(String[] args){
        Parcel p=new Parcel();
        Destination d=p.destination();
    }
}

//作用域内部类
public class Parcel{
    public void fun(boolean b){
        if(b){
            //作用域内部类
            class Inner{
                private String id;
                Inner(String id){
                    this.id=id;
                }
                public String say(){}
            }
            new Inner().say();
        }
    }
    public static void main(String[] args){
        Parcel p=new Parcel();
        p.fun(true);
    }
}
```

#### 7.匿名内部类
```java
public class Parcel7 {
    public Contents contents() {
        return new Contents() { // Insert a class definition   
        private int i = 11;
        public int value() { return i; }
        }; // Semicolon required in this case   
    }
    public static void main(String[] args) {
        Parcel7 p = new Parcel7();
        Contents c = p.contents();
    }
}
```
由此可以创建一个继承自Contents的匿名内部类。
不能给内部类用构造器初始化，因为匿名内部类没有名字。
如果定义一个匿名内部类，它需要使用外部定义的参数，那么次参数引用需要是final的,实例初始化的效果就是构造器
```java
abstract class Base{
        public Base(int i){
            print("Base constructor ");
        }
        public abstract void f();
    }
    public class Anonymous{
        public static Base getBase(int i){//这里的i参数传递给了匿名类的基类构造函数,
        //并没有在匿名类内部使用
            return new Base(i){
                public void f(){
                    print("Anonymout f()");
                }
            };
        }
        
        public Destination destination(final String dest,final float price){
            return new Destination(){
                private int cost;
                {
                    cost=Math.round(price);//当直接在匿名类直接使用参数时必须加final                    
                }
                private String str=dest;
            };
            
        }
        
        public static void main(String[] args){
            Base base=getBase(4);
            base.f();
        }
    }
```
因为匿名内部类既可以扩展类，也可以实现接口，但是不能两者兼备，而且如果是实现接口，也只能实现要给接口
**在访工厂方法**
利用匿名内部类可以更加优雅的实现工厂方法
```java
interface Game{boolean move();}
interface GameFactory{Game getGame();}

class Checker implements Game{
    public boolean move(){return true;}
    public static GameFactory factory=new GameFactory(){
        public Game getGame(){return new Checker();}
    };
}
class Chess implements Game{
    public boolean move(){return true;}
    public static GameFactory factory=new GameFactory(){
        public Game getGame(){return new Chess();}
    };
}
public class TestGames{
    public static void playGame(GameFactory g){
        Game game=g.getGame();
        g.move();
    }
    
    public static void main(String[] args){
        playGame(Checker.factory);
        playGame(Chess.factory);
    }    
}
```

#### 8.嵌套类
将内部类声明为static，这通常称为嵌套类。
嵌套类意味着：
1、要创建嵌套类的对象，不需要其外围类的对象。
2、不能从嵌套类的对象中访问非静态的外围对象。
普通内部类不能有static数据和static字段，也不能包含嵌套类，而嵌套类可以包含。它不需要依赖外围类引用
```java
public class Parcel11 {   
        private static class ParcelContents implements Contents {   
          private int i = 11;   
          public int value() { return i; }   
        }   
        protected static class ParcelDestination   
        implements Destination{   
          private String label;   
          private ParcelDestination(String whereTo) {   
           label = whereTo;   
          }   
          public String readLabel() { return label; }   
          // Nested classes can contain other static elements:   
          public static void f() {}   
          static int x = 10;   
          static class AnotherLevel {   
           public static void f() {}   
           static int x = 10;   
          }   
        }   
        public static Destination destination(String s) {   
          return new ParcelDestination(s);   
        }   
        public static Contents contents() {   
          return new ParcelContents();   
        }   
        public static void main(String[] args) {   
          Contents c = contents();   
          Destination d = destination("Tasmania");   
        }   
  }
```
**接口内部的类**
接口中的任何类自动是public和static的
如果想创建某些公共代码，使得它们可以被某个接口的所有不同实现所公用，那么使用接口内部的嵌套类会显得很方便
```java
public interface ClassInInterface { 
       void howdy(); 
       class Test implements ClassInInterface { 
          public void howdy() { 
             System.out.println("Howdy!"); 
          } 
          public static void main(String[] args) { 
             new Test().howdy(); 
          } 
       } 
     } 
```
**<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>**
java8接口增强
```
a. 在接口中可以添加使用 default 关键字修饰的非抽象方法。即：默认方法（或扩展方法）
b. 接口里可以声明静态方法，并且可以实现。
```
**a:在接口中可以添加使用 default 关键字修饰的非抽象方法。即：默认方法（或扩展方法）**:
Java 8 允许给接口添加一个非抽象的方法实现，只需要使用 default 关键字即可，这个特征又叫做扩展方法（也称为默认方法或虚拟扩展方法或防护方法）。在实现该接口时，该默认扩展方法在子类上可以直接使用，它的使用方式类似于抽象类中非抽象成员方法。
Note：扩展方法不能够重写（也称复写或覆盖） Object 中的方法，却可以重载Object 中的方法。
eg：toString、equals、 hashCode 不能在接口中被覆盖，却可以被重载。
默认方法允许我们在接口里添加新的方法，而不会破坏实现这个接口的已有类的兼容性，也就是说不会强迫实现接口的类实现默认方法。
默认方法和抽象方法的区别是抽象方法必须要被实现，默认方法不是。作为替代方式，接口可以提供一个默认的方法实现，所有这个接口的实现类都会通过继承得到这个方法（如果有需要也可以重写这个方法）
```java
interface Defaulable {
    //使用default关键字声明了一个默认方法
     @SuppressLint("NewApi")
     default String myDefalutMethod() {
        return "Default implementation";
    }
}
class DefaultableImpl implements Defaulable {
    //DefaultableImpl实现了Defaulable接口，没有对默认方法做任何修改
}
class OverridableImpl implements Defaulable {
        //OverridableImpl实现了Defaulable接口重写接口的默认实现，提供了自己的实现方法。
        @Override
        public String myDefalutMethod() {
            return "Overridden implementation";
        }
}
```
**b:接口里可以声明静态方法，并且可以实现**
注意:Supplier 的使用,可看参考资料，在接口部分(**{% post_link java编程思想第四版第九章读书笔记 %}** 第十点)我们分别建一个工厂和一个产品接口类，然后实现，不同的工厂建立不同的产品，但是我们通过接口静态方法，将工厂的实现利用多态都写在一个接口内。
```java
private interface DefaulableFactory {
   // Interfaces now allow static methods
   static Defaulable create(Supplier< Defaulable > supplier ) {
       return supplier.get();
   }
}
```
a,b的调用
```
public static void main( String[] args ) {
   Defaulable defaulable = DefaulableFactory.create( DefaultableImpl::new );
   System.out.println( defaulable.myDefalutMethod() );
 
   defaulable = DefaulableFactory.create( OverridableImpl::new );
   System.out.println( defaulable.myDefalutMethod() );
}
```

#### 9.为什么需要内部类
内部类继承自某个类或实现某个接口，内部类的代码操作创建它的外围类的对象。可以认为内部类提供了某种进入其外围类的窗口。
内部类最吸引人的原因是：
```
内部类使得多重继承的解决方案变得完整。接口解决了部分问题，而内部类有效的实现了“多重继承”。也就是说，内部类允许继承多个非接口类型（类或抽样类）。（个人感觉一个外围类可以包含多个内部类，然后每个内部类通过多个方法分别return new baseClass1{.......};  return new baseClass2{.......};  return new baseClass3{.......};  在调用时使用 outer.方法() 可以返回多重类型，作为函数的参数，达到“多重继承”的效果。）
如果拥有的是抽象类或者具体的类，而非接口，那就只有内部类才能实现多重继承。
```
如果使用内部类，可以获得一些特别的特性：
```
内部类可以有多个实例，每个实例都有自己的状态信息，并且与其外围类对象的信息相互独立。
在单个外围类中，可以让多个内部类以不同的方式实现同一个接口，或继承同一个类。
创建内部类对象的时刻并不依赖于外围类对象的创建。
内部类没有令人迷惑的“is-a”关系，它就是一个独立的实体。
```
闭包与回调：
闭包是一个可调用的对象，它记录了一些信息，这些信息来自于创建它的作用域。内部类是面向对象的闭包。在此作用域内，内部类有权操作所有的成员，包括private成员。
继承两个类，含有同名方法，使用内部类可以避免覆盖。当创建一个内部类，没有在外围类接口中添加东西，也没有修改外围类接口。
通过回调，对象能够携带一些信息，这些信息允许它在稍后的某个时刻调用初始的对象。
回调的价值在于它的灵活性——可以在运行时动态的决定要调用什么方法
```java
package com.test.demo;

interface Incrementable {
    void increment();
}

class Callee1 implements Incrementable {
    private int i = 0;

    public void increment() {
        i++;
        System.out.println(i);
    }
}

class MyIncrement {
    public void increment() {// 注意这里已经有了一个increment方法
        System.out.println("\nOther operation");
    }

    static void f(MyIncrement mi) {
        mi.increment();
    }
}
//因为Callee2继承MyIncrement中已经又increment方法了
//如果Callee2想要implements(实现) Incrementable
//那么就需要使用内部类
class Callee2 extends MyIncrement {
    private int i = 0;

    public void increment() {
        super.increment();
        i++;
        System.err.println(i);
    }

    private class ClosureDe implements Incrementable {
        @Override
        public void increment() {
            Callee2.this.increment();//这里调用外部类的increment方法
        }
    }

    Incrementable getCallbackReference() {
        return new ClosureDe();
    }
}

class Caller {
    private Incrementable callbackreference;

    public Caller(Incrementable inc) {
        this.callbackreference = inc;
    }

    void go() {
        callbackreference.increment();
    }
}

public class Closure {
    public static void main(String[] args) {
        Callee1 c1 = new Callee1();
        Caller caller1 = new Caller(c1);
        caller1.go();
        caller1.go();

        Callee2 c2 = new Callee2();
        MyIncrement.f(c2);
        Caller caller2 = new Caller(c2.getCallbackReference());
        caller2.go();
        caller2.go();
    }
}
```
**内部类与控制框架:**
应用程序框架就是被设计用以解决某类特定问题的一个类或者一组类。
模板方法是保持不变的事物，而可覆盖的方法就是变化的事物。
控制框架是一类特殊的应用程序框架，它用来解决响应事件的需求。主要用来响应事件的系统被称作事件驱动系统。
“变化向量”是各种不同的Event对象所具有的不同行为，通过创建不同的Event子类来表现不同的行为。
内部类允许：
```
控制框架的完整实现是由单个类创建的，从而使得实现的细节被封装起来。内部类用来表示解决问题所必需的各种不同的action()。
内部类可以很容易的访问外围类的任意成员，所以可以避免这种实现变得笨拙。
```

#### 10.内部类的继承
```java
package com.test.demo;
class WithInner {
class Inner {}
}

public class InheritInner extends WithInner.Inner {
   public InheritInner(WithInner wi) {
  wi.super();
 }
public InheritInner() {
new WithInner().super();
}
public static void main(String[] args) {
    WithInner wi = new WithInner();
    InheritInner ii = new InheritInner(wi);
   }
}
```
在继承内部类时如果继续使用默认构造器会报错,而且不能只传递一个指向外部类对象的引用。此时必须在构造器内使用如下语法：
```
外部类对象.super();
```
这样才提供了必要的引用，才可以编译通过
内部类可以被覆盖吗》当继承某个外部类时,内部类并没有发生什么变化。内部类是完全独立的两个实体，各自在自己的命名空间内
局部内部类》局部内部类不能有访问说明符,因为它不是外部类的一部分;但是它可以访问当前代码代码块中的常量，以及此外部类的所有成员
内部类标识符》内部类也会生成一个.class文件。这些文件的命名规则是:外部类的名字+“$”+内部类的名字；如果是匿名内部类编译器也会产生一个数字作为你其标识

# 参考资料
https://blog.csdn.net/severusyue/article/details/49444629  severusyue
https://blog.csdn.net/sun_promise/article/details/51220518  莫若吻 
https://my.oschina.net/0sbVMw/blog/535010 Solid 