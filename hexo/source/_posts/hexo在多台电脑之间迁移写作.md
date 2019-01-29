---
title: hexo在多台电脑之间迁移写作
date: 2018-08-21 22:37:22
tags:
- 博客
- hexo
- 迁移
categories:
- 博客
- hexo
comments: true
password: 20190129
---
# 前言
首先根据[]这篇博客将hexo部署到github上,注意最后的效果需是hexo源文件包在远程dev分支下，hexo编译后的静态文件在master目录下。

# 目的
能够方便在不同场合下,或家里,或公司,在不同电脑上随时更新我的blog,而不用手动的拷贝hexo源文件
<!-- more -->
# 正文
## 1.clone
{% codeblock %}
git clone https://github.com/CreamBing/CreamBing.github.io.git
{% endcodeblock %}
截图(idea)
{% img /images/hexo/clone1.png %}

{% img /images/hexo/clone2.png %}

## 2.确保node环境
如果node没有安装，请到{% link nodejs下载 https://nodejs.org/zh-cn/download/ %}
cmd中输入node -v和npm -v
{% img /images/hexo/nodejsnpm-v.PNG %}
<font color="#eb4d4b">注意:安装完nodejs，idea需重启，这样 terminal 终端才有 node 命令</font>

## 3.切换分支安装依赖
上面第一步clone下来的是master分支，我们要先切换到dev分支[dev分支的创建请看另一篇文章或者下面的参考资料]
```
git checkout -b dev origin/dev
```
然后cd 到hexo目录下
```
npm install
npm install hexo-cli -g
npm install hexo-deployer-git --save
```
运行hexo,在http://localhost:4000访问，注意f12查看控制台是否有异常
```
hexo s -d 
```
提交
```
hexo g -d 
```
这里hexo g -d 将新的博客发布到master分支时，出现了Error: Host key verification failed.错误，因为在上一台电脑上是可以发布的，所以这里需要配置一下ssh认证
```
设置git全局邮箱和用户名git config --global user.name "yourgithubname"
git config --global user.email "yourgithubemail"
设置ssh keyssh-keygen -t rsa -C "youremail"
#生成后填到github和coding上（有coding平台的话）
#验证是否成功
ssh -T git@github.com
ssh -T git@git.coding.net #(有coding平台的话)
```
<font color="#eb4d4b">记得dev分支也要提交到对应的远程分支上,git push</font>


# 参考资料
https://www.zhihu.com/question/21193762 直上云霄的回答

