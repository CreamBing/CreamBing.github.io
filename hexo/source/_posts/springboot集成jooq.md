---
title: springboot集成jooq
date: 2018-10-26 22:49:41
tags:
- java
- springboot2
- jooq
categories:
- java
- springboot2
- jooq
comments: true
---
# 前言
说明一下springboot2.0.6.RELEASE集成jooq3.10.8以及jooq-codegen-maven3.10.8
# 目的
简单说明一下jooq的集成和用法

<!-- more -->

# 正文
## 初始化工程
idea初始化工程方法可以参见**{% post_link springcloud编写用户微服务 %}**

## h2
以h2为梨子说明一下
**添加依赖**
```
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jooq</artifactId>
</dependency>
 <dependency>
    <groupId>com.h2database</groupId>
    <artifactId>h2</artifactId>
    <scope>runtime</scope>
</dependency>
```
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
这种不需要写版本的是因为父工程为springboot或者用下面那种写法
{% codeblock %}
<parent>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-parent</artifactId>
    <version>2.0.6.RELEASE</version>
    <relativePath/> <!-- lookup parent from repository -->
</parent>
或者
<dependencyManagement>
    <dependencies>
        <dependency>
            <groupId>org.springframework.cloud</groupId>
            <artifactId>spring-cloud-dependencies</artifactId>
            <version>${spring-cloud.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
    </dependencies>
</dependencyManagement>
{% endcodeblock %}
**添加驱动工具**
```
<plugin>

    <!-- Specify the maven code generator plugin -->
    <!-- Use org.jooq            for the Open Source Edition
             org.jooq.pro        for commercial editions,
             org.jooq.pro-java-6 for commercial editions with Java 6 support,
             org.jooq.trial      for the free trial edition

         Note: Only the Open Source Edition is hosted on Maven Central.
               Import the others manually from your distribution -->
    <groupId>org.jooq</groupId>
    <artifactId>jooq-codegen-maven</artifactId>

    <!-- The plugin should hook into the generate goal -->
    <executions>
        <execution>
            <goals>
                <goal>generate</goal>
            </goals>
        </execution>
    </executions>

    <!-- Manage the plugin's dependency. In this example, we'll use a PostgreSQL database -->
    <dependencies>
        <dependency>
            <groupId>com.h2database</groupId>
            <artifactId>h2</artifactId>
            <version>1.4.197</version>
        </dependency>
    </dependencies>

    <!-- Specify the plugin configuration.
         The configuration format is the same as for the standalone code generator -->
    <configuration>

        <!-- install 跳过 -->
        <skip>true</skip>

        <!-- JDBC connection parameters -->
        <jdbc>
            <driver>org.h2.Driver</driver>
            <url>jdbc:h2:~/testuser</url>
            <user>sa</user>
            <password>123456</password>
        </jdbc>

        <!-- Generator parameters -->
        <generator>
            <database>
                <name>org.jooq.util.h2.H2Database</name>
                <includes>.*</includes>
                <excludes></excludes>
                <!-- In case your database supports catalogs, e.g. SQL Server:
                <inputCatalog>public</inputCatalog>
                  -->
                <inputSchema>PUBLIC</inputSchema>
            </database>
            <generate>
                <instanceFields>true</instanceFields>
                <pojos>true</pojos>
                <daos>true</daos>
                <springAnnotations>true</springAnnotations>
            </generate>
            <target>
                <packageName>com.springcloud.consuluser.dao</packageName>
                <directory>src/main/java</directory>
            </target>
        </generator>
    </configuration>
</plugin>
```
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
1.这是以h2作为梨子，如果要用mysql的话差不过需要修改相关位置
2.maven package打包忽略插件
```
<!-- install 跳过 -->
<skip>true</skip>
```
3.需要生成相关dao和实体，添加如下配置
```
<generate>
    <instanceFields>true</instanceFields>
    <pojos>true</pojos>
    <daos>true</daos>
    <springAnnotations>true</springAnnotations>
</generate>
```
jooq-codegen-maven以上配置生成的目录结构如下
{% img /images/java/springboot2/jooq/dir_jooq_mavn.png %}
{% link jooq官方example https://github.com/jOOQ/jOOQ/blob/master/jOOQ-examples/jOOQ-spring-example/pom.xml %}

