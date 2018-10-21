---
title: java反射基础用法
date: 2018-10-15 16:42:41
tags:
- java语法
- 反射
categories:
- java
- 语法
- 反射
comments: true
---
# 前言
Java让我们在运行时识别对象和类的信息，主要有2种方式:
```
传统的RTTI，它假定我们在编译时已经知道了所有的类型信息;
反射机制，它允许我们在运行时发现和使用类的信息;
```

# 目的
简单介绍一下反射的机制和应用.
<!-- more -->

# 正文
## class对象
class对象包含了与类有关的信息,是用来创建所有“常规”对象的.每个类都会产生一个对应的Class对象，也就是保存在.class文件。<font color="#eb4d4b">所有类都是在对其第一次使用时，动态加载到JVM的</font>，当程序创建一个对类的静态成员的引用时，就会加载这个类.Class对象仅在需要的时候才会加载，<font color="#eb4d4b">static初始化是在类加载时进行的</font>

<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
{% codeblock %}
public class TestClass {

    public static void main(String[] args) {
        //静态内部类-静态属性
        System.out.println(InnerClass.staticName);
        System.out.println("**************************");
        //静态内部类-普通属性
        InnerClass in = new InnerClass();
        System.out.println(in.name);
        System.out.println("**************************");
        //外部类-普通属性
        System.out.println(new OutterClass().outterName);
        System.out.println("**************************");
        //外部类-静态属性
        System.out.println(OutterClass.outterStaticName);

    }

    static class InnerClass {
        public static String staticName = "innerStaticName";

        public String name = "innerName";

        static {
            System.out.println("静态内部类静态块");
        }

        public InnerClass() {
            System.out.println("静态内部类已经构造好了");
        }
    }
}
{% endcodeblock %}
上面代码运行的结果:
{% img /images/java/refect/static_load_class.jpg %}
结论:
<ul class="fa-ul"><li><i class="fa-li fa fa-check-square"></i>说明当第一次引用一个类的静态属性时，该类会加载到jvm中并调用静态块</li><li><i class="fa-li fa fa-check-square"></i>初始化类时会调用相应构造方法，由于该类已经加载到jvm中，所以不会调用静态块</li><li><i class="fa-li fa fa-check-square"></i>第三点同时印证了第二点，第一次初始化某个类时，该类加载到jvm中，首先调用静态块方法，然后调用相应构造方法</li><li><i class="fa-li fa fa-check-square"></i>第四点印证第二点</li></ul>

## 获取class对象引用的两种方式及区别
```
使用功能”.class”来创建Class对象的引用
使用功能Class.forName(“xxx”)
```
区别:
想在运行时使用类型信息，必须获取对象(比如类Base对象)的Class对象的引用，使用功能Class.forName(“Base”)可以实现该目的，或者使用base.class。注意，有一点很有趣，使用功能”.class”来创建Class对象的引用时，不会自动初始化该Class对象，使用forName()会自动初始化该Class对象。为了使用类而做的准备工作一般有以下3个步骤:
```
加载：由类加载器完成，找到对应的字节码，创建一个Class对象
链接：验证类中的字节码，为静态域分配空间
初始化：如果该类有超类，则对其初始化，执行静态初始化器和静态初始化块
```
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
{% codeblock %}
public class BaseMain {

    public static void main(String[] args) throws Exception {
        //通过obj.class获取class对象的引用
        Class clz1 = StaticBase.class;
        System.out.println("*********************");
        //通过Class.获取class对象的引用--静态内部类
        Class clz2 = Class.forName("com.example.demo.java.reflect.BaseMain$StaticBase");
        //通过Class.获取class对象的引用--普通内部类
        Class clz3 = Class.forName("com.example.demo.java.reflect.BaseMain$Base");
        System.out.println("*********************");
        //内部类的构造方法获取 clz3也可以换成Base.class
        Constructor con3 = clz3.getDeclaredConstructor(BaseMain.class);
        //私有构造需要设置
        con3.setAccessible(true);
        Object obj3 = con3.newInstance(BaseMain.class.newInstance());
    }

    static class StaticBase {
        static int num = 1;

        static {
            System.out.println("StaticBase 静态块:num = " + num);
        }
    }

    public class BaseParent{

        public BaseParent() {
            System.out.println("父类被构造了");
        }
    }

    private class Base extends BaseParent{
        int num = 2;

        private Base() {
            System.out.println("普通内部类被构造了:num = " + num);
        }
    }
}
{% endcodeblock %}
执行结果:
{% img /images/java/refect/reflect1.png %}
结论
```
obj.class确实不会初始化类
Class.forName会调用静态块
初始化子类构造先初始化父类构造
```

## 反射获取私有属性和方法
{% codeblock %}
public class ReflectDemo {

    public static void main(String[] args) throws Exception {
        OutterClass out = new OutterClass();
        System.out.println("***************");
        getAllFields(out);
        System.out.println("***************");
        getAllMethods(out);
    }

    /**
     * 获取一个对象的所有属性
     * @param obj
     */
    public static void getAllFields (Object obj) throws Exception{
        //获取该类包括父类的属性，未注释的表示只有该类的
        //Field[] fields = obj.getClass().getFields();
        Field[] fields = obj.getClass().getDeclaredFields();
        for(Field f : fields){
            f.setAccessible(true);
            System.out.println("属性-值:"+f.getName()+"-"+f.get(obj));
        }
    }

    public static void getAllMethods (Object obj) throws Exception {
        //获取该类包括父类的属性，未注释的表示只有该类的
        //Method[] methods = obj.getClass().getMethods();
        Method[] methods = obj.getClass().getDeclaredMethods();
        for(Method m : methods){
            m.setAccessible(true);
            System.out.println(m+"\n参数个数:"+m.getParameterCount());
            switch (m.getParameterCount()){
                case 0:
                    m.invoke(obj);
                    break;
                case 1:
                    m.invoke(obj,"hello");
                    break;
                default:
                    System.out.println("参数个数大于1");
            }


        }
    }
}
{% endcodeblock %}
执行结果:
{% img /images/java/refect/reflect2.png %}
