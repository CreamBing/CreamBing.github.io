---
title: java编程思想第四版第四章读书笔记
date: 2019-01-10 00:38:51
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
整理知识点，方便以后回顾，这一章主要讲解了java的控制执行流程
<!-- more -->

# 正文
#### 1.true和false
Java不允许我们将一个数字作为布尔值使用，虽然这在C和C++里是允许的（在这些语句里，“真”是非零，“假”是零）

#### 2.break和continue
break用于强行退出循环，不执行循环中剩余的语句，只能跳出一层循环。而continue则停止执行当前的迭代（不执行本次循环的后续代码），然后退回循环起始处，开始下一次迭代。

#### 3.臭名昭著的goto
不提倡使用goto，会给程序带来毁灭性灾害。
break和continue配合标签使用，效果更佳。
```
一般continue会返回最内层循环的开头（顶部），并继续执行。
带标签的continue会达到标签的位置，并重新进入紧接在那个标签后面的循环。
一般break会中断并跳出当前循环。
带标签的break会中断并跳出标签所指的循环。
在Java里需要使用标签的唯一理由就是因为有循
```
在Java里需要使用标签的唯一理由就是因为有循环嵌套存在，从而想从多层嵌套中break或continue。

#### 4.switch
switch中的选择因子必须是int或者char那样的整数值

# 参考资料
https://blog.csdn.net/severusyue/article/details/48632345?utm_source=blogxgwz5 Java编程思想第四版读书笔记——第四章 控制执行流程 severusyue