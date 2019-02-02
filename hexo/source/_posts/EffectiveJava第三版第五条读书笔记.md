---
title: EffectiveJava第三版第五条读书笔记
comments: true
date: 2019-02-01 23:28:28
tags:
- 书籍
- java
- EffectiveJava第三版
categories:
- 书籍
- java
- EffectiveJava第三版
---
# 前言
自己java编程已有两年，自己也写过一些轮子，也在工作中针对自己以前写的代码重构过，但是距离那些优秀的类库总有一些差距，最近在看 Effective Java 第三版，书中总结甚为精辟，遂在阅读过程中逐条写下笔记，以指导自己更加有效的使用 java 编程语言及基本类库,涵盖部分jdk 7,8,9 的新特性
# 目的
> Prefer dependency injection to hardwiring resources
  优先考虑依赖注入来引用资源,代替硬编码
<!-- more -->
# 正文
#### 硬编码
> 硬编码是将数据直接嵌入到程序或其他可执行对象的源代码中的软件开发实践，与从外部获取数据或在运行时生成数据不同。 硬编码数据通常只能通过编辑源代码和重新编译可执行文件来修改，尽管可以使用调试器或十六进制编辑器在内存或磁盘上进行更改。 硬编码的数据通常表示不变的信息，例如物理常量，版本号和静态文本元素。 另一方面，软编码数据对用户输入，HTTP服务器响应或配置文件等任意信息进行编码，并在运行时确定。

#### 使用场景
许多类依赖于一个或多个底层资源。例如，拼写检查器依赖于字典。将此类类实现为静态实用工具类并不少见
```java
// Inappropriate use of static utility - inflexible & untestable!
public class SpellChecker {
    private static final Lexicon dictionary = ...;

    private SpellChecker() {} // Noninstantiable

    public static boolean isValid(String word) { ... }
    public static List<String> suggestions(String typo) { ... }
}
```
# 参考资料