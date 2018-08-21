---
title: hexo在多台电脑之间迁移写作
date: 2018-08-21 22:37:22
tags:
- 博客
- hexo
- 迁移
categories:
- hexo
- 博客
comments: true
---
# 前言
首先根据[]这篇博客将hexo部署到github上,注意最后的效果需是hexo源文件包在远程dev分支下，hexo编译后的静态文件在master目录下。

# 目的
能够方便在不同场合下,或家里,或公司,在不同电脑上随时更新我的blog,而不用手动的拷贝hexo源文件
<!-- more -->
# 正文
## clone
{% codeblock %}
git clone https://github.com/CreamBing/CreamBing.github.io.git
{% endcodeblock %}
截图(idea)
{% img /images/hexo/clone1.png %}

{% img /images/hexo/clone2.png %}




