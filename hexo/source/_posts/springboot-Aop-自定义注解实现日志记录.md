---
title: springboot+Aop+自定义注解实现日志记录
date: 2018-10-21 17:49:54
tags:
- java
- springboot
- aop
- 注解
categories:
- java
- springboot
- aop
- 注解
comments: true
---
# 前言
 AOP（Aspect Orient Programming），也就是面向方面编程，作为面向对象编程的一种补充，专门用于处理系统中分布于各个模块（不同方法）中的交叉关注点的问题，在Java EE应用中，常常通过AOP来处理一些具有横切性质的系统级服务，如事务管理、安全检查、缓存、对象池管理等。AOP实现的关键就在于AOP框架自动创建的AOP代理，<font color="#eb4d4b">AOP代理主要分为静态代理和动态代理两大类，静态代理以AspectJ为代表；而动态代理则以Spring AOP为代表</font>
# 目的
简单说明一下AspectJ，另外实现一个springboot+Aop+自定义注解实现日志记录的梨子

<!-- more -->

# 正文
## AspectJ
AspectJ 是一个基于 Java 语言的 AOP 框架，提供了强大的 AOP 功能，其他很多 AOP 框架都借鉴或采纳其中的一些思想。
AspectJ 是 Java 语言的一个 AOP 实现，其主要包括两个部分：第一个部分定义了如何表达、定义 AOP 编程中的语法规范，通过这套语言规范，我们可以方便地用 AOP 来解决 Java 语言中存在的交叉关注点问题；另一个部分是工具部分，包括编译器、调试工具等。
AspectJ 是编译期增强的框架，需要遵从相关语法然后用他的工具编译织入

## springboot aop
添加依赖
{% codeblock %}
<!-- AOP依赖模块 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-aop</artifactId>
</dependency>

<!-- 测试 -->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
</dependency>
{% endcodeblock %}

{% codeblock %}
自定义注解
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface AnalysisActuator {

    String note() default "";
}

定义切面
@Aspect
@Component
public class AnalysisActuatorAspect {

    final static Logger log = LoggerFactory.getLogger(AnalysisActuatorAspect.class);

    ThreadLocal<Long> beginTime = new ThreadLocal<>();

    @Pointcut("@annotation(analysisActuator)")
    public void serviceStatistics(AnalysisActuator analysisActuator) {
    }

    @Before("serviceStatistics(analysisActuator)")
    public void doBefore(JoinPoint joinPoint, AnalysisActuator analysisActuator) {
        // 记录请求到达时间
        beginTime.set(System.currentTimeMillis());
    }

    @After("serviceStatistics(analysisActuator)")
    public void doAfter(AnalysisActuator analysisActuator) {
        log.info("statistic time:{}, note:{}", System.currentTimeMillis() - beginTime.get(), analysisActuator.note());
    }
}

服务改写
@Service
public class PersonServiceForAopImpl implements PersonService {

    @AnalysisActuator(note = "[PersonServiceForAopImpl]插入")
    @Override
    public int insert(Object obj) {
        System.out.println("成功插入一个person");
        return 1;
    }

    @AnalysisActuator(note = "[PersonServiceForAopImpl]更新")
    @Override
    public int update(Object obj) {
        System.out.println("成功更新一个person");
        return 1;
    }

}

测试服务
@RunWith(SpringRunner.class)
@SpringBootTest
public class TestPersonServiceForAopImpl {

    @Qualifier("personServiceForAopImpl")
    @Autowired
    PersonService personService;

    @Test
    public void testInsert(){
        personService.insert(new Object());
    }
}
{% endcodeblock %}
执行结果
{% img /images/java/refect/reflect6.png %}
# 参考资料
1.{% link Spring AOP实现原理与CGLIB应用 https://www.ibm.com/developerworks/cn/java/j-lo-springaopcglib/ %}
2.{% link 使用Spring Boot的AOP处理自定义注解 https://blog.csdn.net/u014717036/article/details/79039803 %}

