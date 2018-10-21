---
title: java动态代理
date: 2018-10-21 14:46:16
tags:
- java
- 动态代理
categories:
- java
- 动态代理
comments: true
---
# 前言
**{% post_link java反射基础用法 %}**这边博客讲解了java反射的一些基础用法，那么动态代理就是利用反射实现的一个高级用法
# 目的
简单介绍一下动态代理的用法，<font color="#eb4d4b">JDK提供的代理只能针对接口做代理,我们有更强大的代理**{% post_link CGLib代理 %}**</font>

<!-- more -->

# 正文
假设有个personservice服务类接口以及实现类，现如今需要在尽可能少量修改代码的前提下，让原来的方法增加一些其他方法
{% codeblock %}
public interface PersonService {

    //插入一个person
    int insert(Object obj);

    //更新一个person
    int update(Object obj);
}

public class PersonServiceImpl implements PersonService {

    @Override
    public int insert(Object obj) {
        System.out.println("成功插入一个person");
        return 1;
    }

    @Override
    public int update(Object obj) {
        System.out.println("成功更新一个person");
        return 1;
    }
}
{% endcodeblock %}
## 静态代理
{% codeblock %}
public class SimplePersonServiceProxy implements  PersonService{

    //被代理接口类
    private PersonService personService;

    public SimplePersonServiceProxy(PersonService personService) {
        this.personService = personService;
    }

    @Override
    public int insert(Object obj) {
        System.out.println("SimplePersonServiceProxy 插入静态代理方法");
        return personService.insert(obj);
    }

    @Override
    public int update(Object obj) {
        System.out.println("SimplePersonServiceProxy 更新静态代理方法");
        return personService.update(obj);
    }

    public static void main(String[] args) {
        //原来的调用方式
        PersonService personService = new PersonServiceImpl();
        personService.insert(new Object());
        personService.update(new Object());
        System.out.println("**********************");
        //增加功能的调用方法，原来的PersonService和PersonServiceImpl代码都不需要变
        PersonService proxy = new SimplePersonServiceProxy(new PersonServiceImpl());
        proxy.insert(new Object());
        proxy.update(new Object());
    }
}
{% endcodeblock %}
执行结果:
{% img /images/java/refect/reflect3.png %}

## 动态代理
{% codeblock %}
public class DynamicProxyHandler implements InvocationHandler {

    //被代理对象，这里跟静态代理对比，这里的代码扩展性更高，可以是任何对象
    private Object object;

    public DynamicProxyHandler(Object object) {
        this.object = object;
    }

    @Override
    public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
        System.out.println("DynamicProxyHandler java动态代理方法");
        return method.invoke(object,args);
    }

    public static void main(String[] args) {
        //原来的调用方式
        PersonService personService = new PersonServiceImpl();
        personService.insert(new Object());
        personService.update(new Object());
        System.out.println("**********************");
        //增加功能的调用方法，原来的PersonService和PersonServiceImpl代码都不需要变
        PersonService proxy = (PersonService) Proxy.newProxyInstance(PersonService.class.getClassLoader(),new
        Class[]{PersonService.class},new DynamicProxyHandler(new PersonServiceImpl()));
        proxy.insert(new Object());
        proxy.update(new Object());
    }
}
{% endcodeblock %}
执行结果:
{% img /images/java/refect/reflect4.png %}
对比两种方式，我们可以得出结论
```
相同点:
    1.两个都新增了一个代理类，并且属性都是代理类，只不过静态代理的属性限制的更大，必须是
    代理接口类
    2.两种方式都不需要修改接口类以及实现类，只需要修改调用的地方即可，利用代理类调用
不同点
    1.静态代理需要实现代理接口，并且属性为代理类接口，这说明每个接口都需要实现一个静态代
    理类，扩展性不高，正因为如此，其每个代理的类中的方法可以各自写相关的代理方法
    2.动态代理类由于其属性为Object,所以可以代理任何接口,扩展性高，不过由于每个方法执行
    前的代理方法都是一样的，所以更适合做一些通用的代理
```