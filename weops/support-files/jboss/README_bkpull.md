## 嘉为蓝鲸JBoss bkpull插件使用说明

## 使用说明

### 插件功能
从JBoss jmx exporter提供的指标接口采集监控数据。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

JBoss: 7.x 
JBoss EAP: 6.x

**是否支持远程采集:**

是

### 参数说明


| **参数名**      | **含义** | **是否必填** | **使用举例**               |
|--------------|--------|----------|------------------------|
| metrics_url	 | 采集URL	 | 是        | 127.0.0.1:9601/metrics |


注意jboss版本，某些旧版本使用的是jmxrmi，新版本使用的是remote+http  
如果是旧版本，那么请填写 `service:jmx:rmi:///jndi/rmi://{服务IP}:{管理端口}/jmxrmi`

### 使用指引  
#### 配置JBoss  
需要确保JBoss打开了管理端口，新版本的JBoss默认管理端口为9990，一般都默认打开，否则无法登录。此处新版本指JBoss 7.x 和 JBoss EAP 6.x。  

##### Linux环境  
需要配合jboss-cli-client.jar和jmx_exporter.jar使用，具体步骤如下：
如果要运行探针，请执行命令
`java -cp jmx_exporter.jar:jboss-cli-client.jar io.prometheus.jmx.WebServer 127.0.0.1:9601 etc/config.yaml`

**蓝鲸下发的采集任务缺少部分参数，可以更改start.sh内容后再次启动采集任务**  

客户端包一般存放于   
`<WILDFLY_HOME>/bin/client/jboss-cli-client.jar`

config.yaml内容
```
---
jmxUrl: service:jmx:remote+http://127.0.0.1:9990
ssl: false
username: {JBoss管理员账户}
password: {JBoss管理员密码}
lowercaseOutputName: true
lowercaseOutputLabelNames: true
whitelistObjectNames: 
 - "jboss.as:subsystem=messaging-activemq,server=*,jms-queue=*"
 - "jboss.as:subsystem=messaging-activemq,server=*,jms-topic=*"
 - "jboss.as:subsystem=datasources,data-source=*,statistics=*"
 - "jboss.as:subsystem=datasources,xa-data-source=*,statistics=*"
 - "jboss.as:subsystem=transactions*"
 - "jboss.as:subsystem=undertow,server=*,http-listener=*"
 - "jboss.as:subsystem=undertow,server=*,https-listener=*"
 # - "java.lang:*"
rules:
  - pattern: "^jboss.as<subsystem=messaging-activemq, server=.+, jms-(queue|topic)=(.+)><>(.+):"
    attrNameSnakeCase: true
    name: wildfly_messaging_$3
    labels:
      $1: $2

  - pattern: "^jboss.as<subsystem=datasources, (?:xa-)*data-source=(.+), statistics=(.+)><>(.+):"
    attrNameSnakeCase: true
    name: wildfly_datasource_$2_$3
    labels:
      source_name: $1

  - pattern: "^jboss.as<subsystem=transactions><>number_of_(.+):"
    attrNameSnakeCase: true
    name: wildfly_transaction_$1

  - pattern: "^jboss.as<subsystem=undertow, server=(.+), (http[s]?-listener)=(.+)><>(bytes_.+|error_count|processing_time|request_count):"
    attrNameSnakeCase: true
    name: wildfly_undertow_$4
    labels:
      server_name: $1
      listener: $3

```

##### Windows环境
windows环境配置原理与linux基本一致，都是通过管理端口连接。

#### 采集方案
##### 方案1 使用蓝鲸JMX采集任务
如果想使用监控平台JMX采集，请确保下发采集机器的java，默认1.8是不支持使用jboss-cli-client.jar的，需要自行安装java。  
因蓝鲸JMX采集任务写死java运行命令，下发后，需要找到对应的采集任务目录，修改start.sh  
原始内容  
`java -jar jmx_exporter.jar ${BK_LISTEN_HOST}:${BK_LISTEN_PORT} ${BK_CONFIG_PATH} > ${log_filepath} 2>&1 &`

修改为  
`java -cp jmx_exporter.jar:jboss-cli-client.jar io.prometheus.jmx.WebServer ${BK_LISTEN_HOST}:${BK_LISTEN_PORT} ${BK_CONFIG_PATH} > ${log_filepath} 2>&1 &`

修改后，重启采集任务即可。

##### 方案2 使用bkpull 
在服务器上手动启动监控探针   
`java -cp jmx_exporter.jar:jboss-cli-client.jar io.prometheus.jmx.WebServer 127.0.0.1:9601 config.yaml`  
启动后，使用bkpull拉取该探针提供的监控指标


### 指标简介
| **指标ID**                                                      | **指标中文名**   | **维度ID**              | **维度含义**     | **单位** |
|---------------------------------------------------------------|-------------|-----------------------|--------------|--------|
| wildfly_datasource_pool_average_pool_time                     | 池内平均使用时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_total_pool_time                       | 池内总使用时间     | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_max_pool_time                         | 池内最大使用时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_total_usage_time                      | 总使用时间       | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_total_creation_time                   | 总创建时间       | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_total_blocking_time                   | 总阻塞时间       | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_total_get_time                        | 获取连接总时间     | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_average_blocking_time                 | 平均阻塞时间      | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_average_get_time                      | 平均获取时间      | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_average_usage_time                    | 平均使用时间      | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_average_creation_time                 | 平均创建时间      | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_max_usage_time                        | 最大使用时间      | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_max_creation_time                     | 最大创建时间      | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_max_wait_time                         | 最长等待时间      | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_max_get_time                          | 最长获取连接时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_max_wait_count                        | 最大等待数       | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_max_used_count                        | 最大使用连接数     | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_wait_count                            | 等待数         | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_blocking_failure_count                | 阻塞失败数       | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_idle_count                            | 空闲连接数       | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_destroyed_count                       | 销毁连接数       | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_created_count                         | 创建连接数       | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_in_use_count                          | 使用中的连接数     | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_active_count                          | 活动连接数       | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_timed_out                             | 超时数         | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_available_count                       | 可用连接数       | source_name           | 数据源名称        | -      |
| wildfly_datasource_jdbc_prepared_statement_cache_add_count    | 预处理语句缓存增加数  | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_statistics_enabled                    | 数据源池统计是否启用  | source_name           | 数据源名称        | -      |
| wildfly_datasource_jdbc_statistics_enabled                    | JDBC统计是否启用  | source_name           | 数据源名称        | -      |
| wildfly_datasource_jdbc_prepared_statement_cache_hit_count    | 预处理语句缓存命中数  | source_name           | 数据源名称        | -      |
| wildfly_datasource_jdbc_prepared_statement_cache_access_count | 预处理语句缓存访问数  | source_name           | 数据源名称        | -      |
| wildfly_datasource_jdbc_prepared_statement_cache_current_size | 预处理语句缓存当前大小 | source_name           | 数据源名称        | -      |
| wildfly_datasource_jdbc_prepared_statement_cache_delete_count | 预处理语句缓存删除数  | source_name           | 数据源名称        | -      |
| wildfly_datasource_jdbc_prepared_statement_cache_miss_count   | 预处理语句缓存未命中数 | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_xacommit_count                        | XA 提交数      | source_name           | 数据源名称        | -      |
| wildfly_datasource_pool_xaend_count                           | XA 结束数      | source_name           | 数据源名称        |        |
| wildfly_datasource_pool_xarecover_count                       | XA 恢复数      | source_name           | 数据源名称        |        |
| wildfly_datasource_pool_xarollback_count                      | XA 回滚数      | source_name           | 数据源名称        |        |
| wildfly_datasource_pool_xastart_count                         | XA 启动数      | source_name           | 数据源名称        |        |
| wildfly_datasource_pool_xaprepare_count                       | XA 预备数      | source_name           | 数据源名称        |        |
| wildfly_datasource_pool_xaforget_count                        | XA 忘记数      | source_name           | 数据源名称        |        |
| wildfly_datasource_pool_xaprepare_average_time                | XA 预备平均时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaprepare_total_time                  | XA 预备总时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xarecover_total_time                  | XA 恢复总时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaforget_average_time                 | XA 忘记平均时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xacommit_total_time                   | XA 提交总时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaforget_total_time                   | XA 忘记总时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xarecover_average_time                | XA 恢复平均时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xacommit_max_time                     | XA 提交最大时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xarollback_total_time                 | XA 回滚总时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xastart_total_time                    | XA 启动总时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xarecover_max_time                    | XA 恢复最大时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xarollback_average_time               | XA 回滚平均时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xacommit_average_time                 | XA 提交平均时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaend_average_time                    | XA 结束平均时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaend_max_time                        | XA 结束最大时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xastart_average_time                  | XA 启动平均时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaend_total_time                      | XA 结束总时间    | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaforget_max_time                     | XA 忘记最大时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xastart_max_time                      | XA 启动最大时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xaprepare_max_time                    | XA 预备最大时间   | source_name           | 数据源名称        | ms     |
| wildfly_datasource_pool_xarollback_max_time                   | XA 回滚最大时间   | source_name           | 数据源名称        | ms     |
| wildfly_undertow_bytes_sent                                   | 发送字节数       | listener, server_name | 监听器名称, 服务器名称 | bytes  |
| wildfly_undertow_processing_time                              | 处理时间        | listener, server_name | 监听器名称, 服务器名称 | ms     |
| wildfly_undertow_bytes_received                               | 接收字节数       | listener, server_name | 监听器名称, 服务器名称 | bytes  |
| wildfly_undertow_request_count                                | 请求数         | listener, server_name | 监听器名称, 服务器名称 | -      |
| wildfly_undertow_error_count                                  | 错误数         | listener, server_name | 监听器名称, 服务器名称 | -      |
| wildfly_transaction_heuristics                                | 启发式数        | -                     | -            | -      |
| wildfly_transaction_nested_transactions                       | 嵌套事务数       | -                     | -            | -      |
| wildfly_transaction_inflight_transactions                     | 正在进行的事务数    | -                     | -            | -      |
| wildfly_transaction_application_rollbacks                     | 应用回滚数       | -                     | -            | -      |
| wildfly_transaction_timed_out_transactions                    | 超时事务数       | -                     | -            | -      |
| wildfly_transaction_system_rollbacks                          | 系统回滚数       | -                     | -            | -      |
| wildfly_transaction_committed_transactions                    | 提交的事务数      | -                     | -            | -      |
| wildfly_transaction_transactions                              | 事务总数        | source_name           | 数据源名称        | -      |
| wildfly_transaction_resource_rollbacks                        | 资源回滚数       | source_name           | 数据源名称        | -      |
| wildfly_transaction_aborted_transactions                      | 已中止的事务数     | source_name           | 数据源名称        | -      |
| jmx_scrape_duration_seconds                                   | JMX抓取消耗时间   | -                     | -            | s      |
| jmx_scrape_error                                              | JMX抓取失败状态   | -                     | -            | -      |
| jmx_config_reload_failure_total                               | JMX配置重载失败次数 | -                     | -            | -      |

