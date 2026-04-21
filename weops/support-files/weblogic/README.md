## 嘉为蓝鲸Weblogic JMX插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

Weblogic版本: 10.3.6.0

**是否支持远程采集:**

是

### 参数说明


| **参数名**  | **含义**                                                                          | **是否必填** | **使用举例**                                            |
|----------|---------------------------------------------------------------------------------|----------|-----------------------------------------------------|
| host     | 监听IP(采集器IP)，建议使用默认的127.0.0.1                                                    | 是        | 127.0.0.1                                           |
| port     | 监听端口(采集器监听端口)，一般为9601，注意不要与已使用端口冲突                                              | 是        | 9601                                                |
| username | jmx认证用户名，若未配置则留空                                                                | 否        |                                                     |
| password | jmx认证密码，若未配置则留空                                                                 | 否        |                                                     |
| jmx_url  | jmx 连接字符串，格式为service:jmx:rmi:///jndi/rmi://${target_host}:${target_port}/jmxrmi | 是        | service:jmx:rmi:///jndi/rmi://127.0.0.1:1234/jmxrmi |

### 使用指引  
#### 配置weblogic jmx参数
##### Linux环境  
   - 与其他jmx采集有一些不同, 需要注意weblogic必须启用 `-Djavax.management.builder.initial=weblogic.management.jmx.mbeanserver.WLSMBeanServerBuilder` 参数  
   - 打开weblogic的bin目录下的startNodeManager.sh文件, 新建或者找到最外层的第一个JAVA_OPTIONS中，添加如下参数
      ```
        JAVA_OPTIONS="-Dcom.sun.management.jmxremote=true -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9999 -Djava.rmi.server.hostname=127.0.0.1 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Djavax.management.builder.initial=weblogic.management.jmx.mbeanserver.WLSMBeanServerBuilder"
      ```
   - 如果不想改动startNodeManager.sh, 还可以直接在启动weblogic服务的java命令中直接添加上方提到的jmx参数, 下方是运行中的weblogic服务的java命令, 可以看到其中添加了jmx参数:  
    ```
   /root/jdk/jdk1.6.0_45/bin/java /root/jdk/jdk1.6.0_45/bin/java -client -Xms256m -Xmx512m -XX:CompileThreshold=8000 -XX:PermSize=128m -XX:MaxPermSize=256m -Dweblogic.Name=AdminServer -Djava.security.policy=/root/Oracle/Middleware/wlserver_10.3/server/lib/weblogic.policy -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9999 -Dcom.sun.management.jmxremote.rmi.port=9999 -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djavax.management.builder.initial=weblogic.management.jmx.mbeanserver.WLSMBeanServerBuilder -Xverify:none -da -Dplatform.home=/root/Oracle/Middleware/wlserver_10.3 -Dwls.home=/root/Oracle/Middleware/wlserver_10.3/server -Dweblogic.home=/root/Oracle/Middleware/wlserver_10.3/server -Dweblogic.management.discover=true -Dwlw.iterativeDev= -Dwlw.testConsole= -Dwlw.logErrorsToConsole= -Dweblogic.ext.dirs=/root/Oracle/Middleware/patch_wls1036/profiles/default/sysext_manifest_classpath weblogic.Server
    ```

   - 重启weblogic
   - 验证jmx端口是否生效: `netstat -antlp |grep 9999`

#### 网络策略问题
jmx采集会同时随机打开rmi端口, 所以在有网络限制(防火墙)的情况下, 需要注意在参数中添加 `Dcom.sun.management.jmxremote.rmi.port=9999`, 指定rmi打开的端口, 该端口可以和 `Dcom.sun.management.jmxremote.port` 填写的值一样  

### 指标简介
| **指标分类**                 | **指标ID**                                                     | **指标中文名**        | **维度ID**                       | **维度含义**    | **单位** |
|--------------------------|--------------------------------------------------------------|------------------|--------------------------------|-------------|--------|
| 服务器(WebServer)           | weblogic_webserver_default_web_server                        | 默认Web服务器         | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_execute_thread_idle_count                | 线程池空闲执行线程计数      | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_standby_thread_count                     | 线程池待命线程计数        | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_throughput                               | 线程池吞吐量           | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_execute_thread_total_count               | 线程池总执行线程数        | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_pending_user_request_count               | 线程池待处理用户请求数      | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_execute_thread_total_count               | 线程池总执行线程数        | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_completed_request_count                  | 线程池完成请求数         | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_min_threads_constraints_pending          | 待满足最小线程约束数       | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_suspended                                | 线程池暂停状态          | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_shared_capacity_for_work_managers        | 工作管理器的共享容量       | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_queue_length                             | 线程池队列长度          | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_min_threads_constraints_completed        | 最小线程约束完成数        | bea_name, runtime              | 名称, 运行时     | -      |
| 线程池(Threadpool)          | weblogic_threadpool_hogging_thread_count                     | 占用线程数            | bea_name, runtime              | 名称, 运行时     | -      |
| 应用(Application)          | weblogic_application_workmanager_stuck_thread_count          | 应用工作管理器卡住线程计数    | application, bea_name, runtime | 应用, 名称, 运行时 | -      |
| 应用(Application)          | weblogic_application_workmanager_completed_requests          | 应用工作管理器完成请求数     | application, bea_name, runtime | 应用, 名称, 运行时 | -      |
| 应用(Application)          | weblogic_application_workmanager_pending_requests            | 应用工作管理器待处理请求数    | application, bea_name, runtime | 应用, 名称, 运行时 | -      |
| 应用(Application)          | weblogic_application_ear                                     | 应用是否为EAR文件       | bea_name, runtime              | 名称, 运行时     | -      |
| 应用(Application)          | weblogic_application_active_version_state                    | 应用活动版本状态         | bea_name, runtime              | 名称, 运行时     | -      |
| 工作管理器(WorkManager)       | weblogic_workmanager_completed_requests                      | 工作管理器完成请求数       | bea_name, runtime              | 名称, 运行时     | -      |
| 工作管理器(WorkManager)       | weblogic_workmanager_stuck_thread_count                      | 工作管理器卡住线程计数      | bea_name, runtime              | 名称, 运行时     | -      |
| 工作管理器(WorkManager)       | weblogic_workmanager_pending_requests                        | 工作管理器待处理请求数      | bea_name, runtime              | 名称, 运行时     | -      |
| 消息传递服务(JMS)              | weblogic_jms_connections_high_count                          | 最高JMS连接数         | bea_name, runtime              | 名称, 运行时     | -      |
| 消息传递服务(JMS)              | weblogic_jms_jmsservers_total_count                          | 总JMS服务器计数        | bea_name, runtime              | 名称, 运行时     | -      |
| 消息传递服务(JMS)              | weblogic_jms_connections_total_count                         | 总JMS连接数          | bea_name, runtime              | 名称, 运行时     | -      |
| 消息传递服务(JMS)              | weblogic_jms_jmsservers_current_count                        | 当前JMS服务器计数       | bea_name, runtime              | 名称, 运行时     | -      |
| 消息传递服务(JMS)              | weblogic_jms_connections_current_count                       | 当前JMS连接数         | bea_name, runtime              | 名称, 运行时     | -      |
| 消息传递服务(JMS)              | weblogic_jms_jmsservers_high_count                           | 最高JMS服务器数        | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_delete_count                        | 持久化存储删除计数        | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_create_count                        | 持久化存储创建计数        | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_allocated_io_buffer_bytes           | 分配的IO缓冲区字节数      | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_allocated_window_buffer_bytes       | 分配的窗口缓冲区字节数      | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_update_count                        | 持久化存储更新计数        | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_read_count                          | 持久化存储读取计数        | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_physical_write_count                | 持久化存储物理写入计数      | bea_name, runtime              | 名称, 运行时     | -      |
| 持久化存储(PersistentStore)   | weblogic_persistentstore_object_count                        | 持久化存储对象数         | bea_name, runtime              | 名称, 运行时     | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_active_connections_average_count     | JDBC活动连接平均数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_waiting_for_connection_high_count    | JDBC等待连接峰值数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_connection_delay_time                | JDBC连接延迟时间       | name, runtime                  | 数据源名称, 运行时  | ms     |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_waiting_for_connection_current_count | JDBC当前等待连接数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_highest_num_available                | JDBC历史最大可用连接数    | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_curr_capacity                        | JDBC当前容量         | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_waiting_for_connection_failure_total | JDBC等待连接失败总数     | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_prep_stmt_cache_current_size         | JDBC预编译语句缓存当前大小  | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_wait_seconds_high_count              | JDBC等待秒数峰值       | name, runtime                  | 数据源名称, 运行时  | s      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_enabled                              | JDBC数据源启用状态      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_prep_stmt_cache_add_count            | JDBC预编译语句缓存加入次数  | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_failed_reserve_request_count         | JDBC连接预留失败请求数    | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_highest_num_unavailable              | JDBC历史最大不可用连接数   | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_active_connections_high_count        | JDBC活动连接峰值数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_num_available                        | JDBC当前可用连接数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_curr_capacity_high_count             | JDBC容量峰值数        | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_waiting_for_connection_success_total | JDBC等待连接成功总数     | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_deployment_state                     | JDBC部署状态         | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_prep_stmt_cache_miss_count           | JDBC预编译语句缓存未命中次数 | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_num_unavailable                      | JDBC当前不可用连接数     | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_active_connections_current_count     | JDBC当前活动连接数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_leaked_connection_count              | JDBC连接泄漏数        | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_reserve_request_count                | JDBC连接申请请求数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_prep_stmt_cache_access_count         | JDBC预编译语句缓存访问次数  | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_prep_stmt_cache_delete_count         | JDBC预编译语句缓存删除次数  | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_failures_to_reconnect_count          | JDBC重连失败次数       | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_waiting_for_connection_total         | JDBC等待连接总次数      | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_connections_total_count              | JDBC连接总数         | name, runtime                  | 数据源名称, 运行时  | -      |
| JDBC连接池(JDBCDataSource)  | weblogic_jdbcdatasource_prep_stmt_cache_hit_count            | JDBC预编译语句缓存命中次数  | name, runtime                  | 数据源名称, 运行时  | -      |
| JMX自监控信息(JMXselfMonitor) | jmx_scrape_duration_seconds                                  | JMX 抓取持续时间       | -                              | -           | s      |
| JMX自监控信息(JMXselfMonitor) | jmx_scrape_error                                             | JMX 抓取错误         | -                              | -           | -      |


### 版本日志

#### weops_weblogic_jmx v1.1.5

- weops调整

#### weops_weblogic_jmx v1.1.6

- 新增jdbc类指标

添加“小嘉”微信即可获取weblogic监控指标最佳实践礼包，其他更多问题欢迎咨询 

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
