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
<font color="#eb4d4b">放在pom驱动配置的configuration标签内
20181030更新:注意这个标签添加之后，无论编译打包甚至直接运行这个插件都不再生成相关东西，如果你现在需要重新运行一遍，请先提交或者保存你做过的修改，然后注释掉这个，运行完之后再加上，然后再将你做的修改重新添加回来</font>
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
4.<font color="#eb4d4b">20181030更新:当h2的数据库类型为内存时，结果jooq-codegen-maven无法生成</font>
```
<!-- JDBC connection parameters -->
<jdbc>
    <driver>org.h2.Driver</driver>
    <url>jdbc:h2:mem:test</url>
    <user>sa</user>
    <password>123456</password>
</jdbc>
```
需要改成文件类型
```
<!-- JDBC connection parameters -->
<jdbc>
    <driver>org.h2.Driver</driver>
    <url>jdbc:h2:~/testmovie</url>
    <user>sa</user>
    <password>123456</password>
</jdbc>
```
jooq-codegen-maven以上配置生成的目录结构如下
{% img /images/java/springboot2/jooq/dir_jooq_mavn.png %}
**yml配置文件添加相关配置**
```
spring:
  datasource:
    #url: jdbc:h2:mem:test
    #url: jdbc:h2:file:~/.h2/testdb
    url: jdbc:h2:~/testuser
    driverClassName: org.h2.Driver
    username: sa
    password: 123456
    platform: h2
    schema: classpath:db/schema.sql
    data: classpath:db/data.sql
    initialization-mode: always #springboot2.0加上上述sql才会执行
    # 下面为druid连接池的补充设置，应用到上面所有数据源中
    # 初始化大小，最小，最大
    initialSize: 1
    minIdle: 3
    maxActive: 20
    # 配置获取连接等待超时的时间
    maxWait: 60000
    # 配置间隔多久才进行一次检测，检测需要关闭的空闲连接，单位是毫秒
    timeBetweenEvictionRunsMillis: 60000
    # 配置一个连接在池中最小生存的时间，单位是毫秒
    minEvictableIdleTimeMillis: 30000
    validationQuery: select 'x'
    testWhileIdle: true
    testOnBorrow: false
    testOnReturn: false
    # 打开PSCache，并且指定每个连接上PSCache的大小
    poolPreparedStatements: true
    maxPoolPreparedStatementPerConnectionSize: 20
    # 配置监控统计拦截的filters，去掉后监控界面sql无法统计
    filters: stat
    # 通过connectProperties属性来打开mergeSql功能；慢SQL记录
    connectionProperties: druid.stat.mergeSql=true;druid.stat.slowSqlMillis=5000
    # 合并多个DruidDataSource的监控数据
    useGlobalDataSourceStat: true 
  h2:
    console:
      settings:
        web-allow-others: true #进行该配置后，h2 web consloe就可以在远程访问了。否则只能在本机访问。
      path: /h2-console #进行该配置，你就可以通过YOUR_URL/h2-console访问h2 web consloe。YOUR_URL是你程序的访问URl。
      enabled: true #进行该配置，程序开启时就会启动h2 web consloe。当然这是默认的，如果你不想在启动程序时启动h2 web consloe，那么就设置为false。
```
<font color="#2ecc71" size="4"><i class="fa fa-spinner fa-spin"></i>扩展</font>
1.上面的配置中添加initialization-mode之后才会初始化schema.sql和data.sql
2.initialization-mode配置之后的是druid的补充配置，需结合java程序手动初始化或者添加spring.datasource.type=com.alibaba.druid.pool.DruidDataSource自动初始化，不过这种初始化之前我的druid监控页面无法打开
3.h2的控制页面配置如上，如果不加无法访问
4.集成druid,详情见**{% post_link springboot集成druid %}**
# 参考资料
{% link java api doc http://www.jooq.org/javadoc/latest/overview-summary.html %}
{% link jooq-codegen-maven其他配置 https://www.jianshu.com/p/bb558aa56191 %}
{% link jooq官方example https://github.com/jOOQ/jOOQ/blob/master/jOOQ-examples/jOOQ-spring-example/pom.xml %}

