---
title: springboot集成druid
date: 2018-10-26 21:40:18
tags:
- java
- springboot2
- druid
categories:
- java
- springboot2
- druid
comments: true
---
# 前言
Druid是Java语言中最好的数据库连接池。Druid能够提供强大的监控和扩展功能
# 目的
springboot2.0.6.RELEASE集成druid1.1.10
<!-- more -->

# 正文
## 添加依赖
```
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid</artifactId>
    <version>1.1.10</version>
</dependency>
```

## 添加配置
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
```

## 初始化datasource
1.添加spring.datasource.type=com.alibaba.druid.pool.DruidDataSource自动初始化，不过这种初始化之前我的druid监控页面无法打开
2.利用java程序手动初始化
在java源码，springboot主程序的所在目录的子目录下，添加如下两个文件DataSourceBean.java和DatasourceConf.java
{% codeblock %}
@ConfigurationProperties(prefix = "spring.datasource")
@Component
@Data
public class DatasourceConf {

    private String url;
    private String username;
    private String password;
    private String driverClassName;
    private int initialSize;
    private int minIdle;
    private int maxActive;
    private int maxWait;
    private int timeBetweenEvictionRunsMillis;
    private int minEvictableIdleTimeMillis;
    private String validationQuery;
    private Boolean testWhileIdle;
    private Boolean testOnBorrow;
    private Boolean testOnReturn;
    private Boolean poolPreparedStatements;
    private int maxPoolPreparedStatementPerConnectionSize;
    private String filters;
    private String connectionProperties;
    private Boolean useGlobalDataSourceStat;
}

@Configuration
@Component
@Data
public class DataSourceBean {

    private static final Logger LOGGER = LoggerFactory.getLogger(DataSourceBean.class);

    @Autowired
    DatasourceConf datasourceConf;

    @Bean
    public DataSource getDataSource() {
        DruidDataSource datasource = new DruidDataSource();
        datasource.setUrl(datasourceConf.getUrl());
        datasource.setUsername(datasourceConf.getUsername());
        datasource.setPassword(datasourceConf.getPassword());
        datasource.setDriverClassName(datasourceConf.getDriverClassName());
        //configuration
        datasource.setInitialSize(datasourceConf.getInitialSize());
        datasource.setMinIdle(datasourceConf.getMinIdle());
        datasource.setMaxActive(datasourceConf.getMaxActive());
        datasource.setMaxWait(datasourceConf.getMaxWait());
        datasource.setTimeBetweenEvictionRunsMillis(datasourceConf.getTimeBetweenEvictionRunsMillis());
        datasource.setMinEvictableIdleTimeMillis(datasourceConf.getMinEvictableIdleTimeMillis());
        datasource.setValidationQuery(datasourceConf.getValidationQuery());
        datasource.setTestWhileIdle(datasourceConf.getTestWhileIdle());
        datasource.setTestOnBorrow(datasourceConf.getTestOnBorrow());
        datasource.setTestOnReturn(datasourceConf.getTestOnReturn());
        datasource.setPoolPreparedStatements(datasourceConf.getPoolPreparedStatements());
        datasource.setMaxPoolPreparedStatementPerConnectionSize(datasourceConf.getMaxPoolPreparedStatementPerConnectionSize());
        datasource.setUseGlobalDataSourceStat(datasourceConf.getUseGlobalDataSourceStat());
        try {
            datasource.setFilters(datasourceConf.getFilters());
        } catch (SQLException e) {
            LOGGER.error("druid configuration initialization filter: " + e);
        }
        datasource.setConnectionProperties(datasourceConf.getConnectionProperties());
        return datasource;
    }

    /**
     * 配置监控服务器
     *
     * @return 返回监控注册的servlet对象
     */
    @Bean
    public ServletRegistrationBean statViewServlet() {
        ServletRegistrationBean servletRegistrationBean = new ServletRegistrationBean(new StatViewServlet(), "/druid/*");
        // 添加IP白名单
        servletRegistrationBean.addInitParameter("allow", "192.168.14.32,127.0.0.1");
        // 添加IP黑名单，当白名单和黑名单重复时，黑名单优先级更高
        servletRegistrationBean.addInitParameter("deny", "192.168.14.32");
        // 添加控制台管理用户
        servletRegistrationBean.addInitParameter("loginUsername", "druid");
        servletRegistrationBean.addInitParameter("loginPassword", "123456");
        // 是否能够重置数据
        servletRegistrationBean.addInitParameter("resetEnable", "false");
        return servletRegistrationBean;
    }

    /**
     * 配置服务过滤器
     *
     * @return 返回过滤器配置对象
     */
    @Bean
    public FilterRegistrationBean statFilter() {
        FilterRegistrationBean filterRegistrationBean = new FilterRegistrationBean(new WebStatFilter());
        // 添加过滤规则
        filterRegistrationBean.addUrlPatterns("/*");
        // 忽略过滤格式
        filterRegistrationBean.addInitParameter("exclusions", "*.js,*.gif,*.jpg,*.png,*.css,*.ico,/druid/*,");
        return filterRegistrationBean;
    }
}

{% endcodeblock %}

## 参考资料
{% link Druid 介绍及配置 https://www.cnblogs.com/niejunlei/p/5977895.html %}

