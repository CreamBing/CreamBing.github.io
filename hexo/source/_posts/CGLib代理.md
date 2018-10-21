---
title: CGLib代理
date: 2018-10-21 16:26:09
tags:
- CGLib
- 代理
categories:
- java
- CGLib
- 代理
comments: true
---
# 前言
**{% post_link java动态代理 %}**这篇博客介绍了java的动态代理，那么这里同样不得不介绍一下CGLib代理。JDK的动态代理机制只能代理实现了接口的类，而不能实现接口的类就不能实现JDK的动态代理.<font color="#eb4d4b">cglib是针对类来实现代理的，他的原理是对指定的目标类生成一个子类，并覆盖其中方法实现增强，但因为采用的是继承，所以不能对final修饰的类进行代理</font>
# 目的
简单介绍一下cglib的代理应用

<!-- more -->

# 正文
同样用java动态代理的那个梨子
## cglib代理
添加依赖
{% codeblock %}
<dependency>
    <groupId>cglib</groupId>
    <artifactId>cglib</artifactId>
    <version>3.2.4</version>
</dependency>
{% endcodeblock %}
{% codeblock %}
public class CglibProxyInterceptor implements MethodInterceptor {

    //通过Enhancer 创建代理对象
    private Enhancer enhancer = new Enhancer();

    //通过Class对象获取代理对象
    public <T> T getProxy(Class c){
        //设置创建子类的类
        enhancer.setSuperclass(c);
        enhancer.setCallback(this);
        return (T)enhancer.create();
    }

    @Override
    public Object intercept(Object o, Method method, Object[] objects, MethodProxy methodProxy) throws Throwable {
        System.out.println("CglibProxyInterceptor 代理方法");
         return methodProxy.invokeSuper(o,objects);
    }

    public static void main(String[] args) {
        //原来的调用方式
        PersonService personService = new PersonServiceImpl();
        personService.insert(new Object());
        personService.update(new Object());
        System.out.println("**********************");
        CglibProxyInterceptor proxy = new CglibProxyInterceptor();
        PersonService personServiceProxy = proxy.getProxy(PersonServiceImpl.class);
        personServiceProxy.insert(new Object());
        personServiceProxy.update(new Object());
    }
}
{% endcodeblock %}
执行结果
{% img /images/java/refect/reflect5.jpg %}
与java动态代理相比
```
相同点:
    1.两个都新增了一个代理类，代理的类限制不大,扩展性很高
    2.两种方式都不需要修改接口类以及实现类，只需要修改调用的地方即可，利用代理类调用
不同点:
    1.jdk动态代理需要对接口代理，cglib对非final修辞的类都可以代理
    2.cglib是第三方包,需要添加依赖
```
