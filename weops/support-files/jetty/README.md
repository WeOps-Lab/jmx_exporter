## 嘉为蓝鲸Jetty监控插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

Jetty: 9.x、10.x、11.x、12.x  

7.x和8.x可以尝试使用，但不一定能正常采集  

**是否支持远程采集:**

是 

### 参数说明


| **参数名**  | **含义**                                                          | **是否必填** | **使用举例**                                            |
|----------|-----------------------------------------------------------------|----------|-----------------------------------------------------|
| host     | 监听IP(采集器IP)，建议使用默认的127.0.0.1                                    | 是        | 127.0.0.1                                           |
| port     | 监听端口(采集器监听端口)，一般为9601，注意不要与已使用端口冲突                              | 是        | 9601                                                |
| username | jmx认证用户名，若未配置则留空                                                | 否        |                                                     |
| password | jmx认证密码，若未配置则留空                                                 | 否        |                                                     |
| jmx_url  | jmx 连接字符串，格式为service:jmx:rmi:///jndi/rmi://{服务IP}:{管理端口}/jmxrmi | 是        | service:jmx:rmi:///jndi/rmi://127.0.0.1:1099/jmxrmi |


### 使用指引  
#### 查看当前jetty支持的所有模块
```shell
java -jar "$JETTY_HOME/start.jar" --list-modules
```

正常情况下，输出应该要包含如下内容：
```shell
...省略其他模块内容...
jmx - This module enables local Java Management Extension (JMX) support for Jetty components.
jmx-remote - Enables clear-text remote RMI access to platform MBeans.
...省略其他模块内容...
```

**不同版本下查看和开启module方式可能有所不同，可以参考Jetty官方文档查看具体的module开启方式。**  

#### 配置Jetty
通过添加JMX模块启用JMX, 需要在启动参数中添加`--add-module=jmx`，并指定远程端口(有一些jetty指定端口会在xml中，但建议在启动命令中指定端口，以免xml配置文件被覆盖)。  

##### Linux
```shell
# 打开JMX并指定远程端口
java -Dcom.sun.management.jmxremote.port=1099 \
     -Dcom.sun.management.jmxremote.rmi.port=1099 \
     -Dcom.sun.management.jmxremote.ssl=false \
     -Dcom.sun.management.jmxremote=true \
     -Dcom.sun.management.jmxremote.authenticate=false \
     -jar $JETTY_HOME/start.jar --add-module=jmx
```

##### Windows
```shell
# 打开JMX并指定远程端口
java -Dcom.sun.management.jmxremote.port=1099 ^
     -Dcom.sun.management.jmxremote.rmi.port=1099 ^
     -Dcom.sun.management.jmxremote.ssl=false ^
     -Dcom.sun.management.jmxremote=true ^
     -Dcom.sun.management.jmxremote.authenticate=false ^
     -jar %JETTY_HOME%\start.jar --add-module=jmx
```



### 指标简介
| **指标ID**                                        | **指标中文名**            | **维度ID**    | **维度含义** | **单位**  |
|-------------------------------------------------|----------------------|-------------|----------|---------|
| jetty_eatwhatyoukill_pictasksexecuted           | PIC模式执行的任务数          | context, id | 上下文, id  | -       |
| jetty_eatwhatyoukill_pctasksconsumed            | PC模式执行的任务数           | context, id | 上下文, id  | -       |
| jetty_eatwhatyoukill_pectasksexecuted           | PEC模式执行的任务数          | context, id | 上下文, id  | -       |
| jetty_eatwhatyoukill_epctasksconsumed           | EPC模式消费任务数           | context, id | 上下文, id  | -       |
| jetty_eatwhatyoukill_stoptimeout                | 停止超时时间               | context, id | 上下文, id  | ms      |
| jetty_queuedthreadpool_availablereservedthreads | 可用预留线程数              | id          | 线程池ID    | -       |
| jetty_queuedthreadpool_reservedthreads          | 配置的预留线程数             | id          | 线程池ID    | -       |
| jetty_queuedthreadpool_maxleasedthreads         | 最大可租用线程数             | id          | id       | -       |
| jetty_queuedthreadpool_stoptimeout              | 停止超时时间               | id          | id       | ms      |
| jetty_queuedthreadpool_readythreads             | 准备执行的线程数             | id          | id       | -       |
| jetty_queuedthreadpool_idletimeout              | 线程空闲超时时间             | id          | id       | ms      |
| jetty_queuedthreadpool_maxthreads               | 最大线程数                | id          | id       | -       |
| jetty_queuedthreadpool_queuesize                | 作业队列的大小              | id          | id       | -       |
| jetty_queuedthreadpool_threads                  | 线程池中的线程数             | id          | id       | -       |
| jetty_queuedthreadpool_busythreads              | 执行内部分支作业的线程数         | id          | id       | -       |
| jetty_queuedthreadpool_leasedthreads            | 内部组件使用的线程数           | id          | id       | -       |
| jetty_queuedthreadpool_maxavailablethreads      | 可执行临时作业的最大线程数        | id          | id       | -       |
| jetty_queuedthreadpool_utilizedthreads          | 执行临时作业的线程数           | id          | id       | -       |
| jetty_queuedthreadpool_utilizationrate          | 执行临时作业的线程利用率         | id          | id       | percent |
| jetty_queuedthreadpool_maxreservedthreads       | 预留线程的最大数量            | id          | id       | -       |
| jetty_queuedthreadpool_idlethreads              | 空闲线程数                | id          | id       | -       |
| jetty_queuedthreadpool_threadspriority          | 线程池中线程的优先级           | id          | id       | -       |
| jetty_queuedthreadpool_minthreads               | 线程池中的最小线程数           | id          | id       | -       |
| jetty_queuedthreadpool_lowthreadsthreshold      | 低线程阈值                | id          | id       | -       |
| jetty_threadpoolbudget_leasedthreads            | 租用的线程数               | id          | id       | -       |
| jetty_serverconnector_acceptedreceivebuffersize | 接收缓冲区大小              | context, id | 上下文, id  | bytes   |
| jetty_serverconnector_idletimeout               | 空闲超时时间               | context, id | 上下文, id  | ms      |
| jetty_serverconnector_acceptedsendbuffersize    | 发送缓冲区大小              | context, id | 上下文, id  | bytes   |
| jetty_serverconnector_acceptqueuesize           | 接受队列大小               | context, id | 上下文, id  | -       |
| jetty_serverconnector_stoptimeout               | 服务器连接器停止超时时间         | context, id | 上下文, id  | ms      |
| jetty_httpconfiguration_outputaggregationsize   | HTTP输出聚合最大大小         | context, id | 上下文, id  | bytes   |
| jetty_httpconfiguration_minresponsedatarate     | 最小响应数据传输速率           | context, id | 上下文, id  | Bps     |
| jetty_httpconfiguration_minrequestdatarate      | 最小请求数据传输速率           | context, id | 上下文, id  | Bps     |
| jetty_httpconfiguration_requestheadersize       | HTTP请求头字段的最大允许大小     | context, id | 上下文, id  | bytes   |
| jetty_httpconfiguration_maxerrordispatches      | 请求的最大错误调度次数          | context, id | 上下文, id  | -       |
| jetty_httpconfiguration_idletimeout             | 处理HTTP请求期间I/O操作的空闲超时 | context, id | 上下文, id  | ms      |
| jetty_httpconfiguration_headercachesize         | HTTP头字段缓存允许的最大大小     | context, id | 上下文, id  | bytes   |
| jetty_httpconfiguration_maxerrordispatches      | 请求的最大错误调度次数          | context, id | 上下文, id  | -       |
| jetty_httpconfiguration_outputbuffersize        | 输出缓冲区大小              | context, id | 上下文, id  | bytes   |
| jetty_httpconfiguration_responseheadersize      | 响应头最大大小              | context, id | 上下文, id  | bytes   |
| jetty_managedselector_averageselectedkeys       | 平均选择的键数              | context, id | 上下文, id  | -       |
| jetty_managedselector_selectcount               | select功能调用总数         | context, id | 上下文, id  | -       |
| jetty_managedselector_stoptimeout               | 停止超时时间               | context, id | 上下文, id  | ms      |
| jetty_managedselector_totalkeys                 | 总键数                  | context, id | 上下文, id  | -       |
| jetty_managedselector_maxselectedkeys           | 最大选择的键数              | context, id | 上下文, id  | -       |
| jetty_reservedthreadexecutor_capacity           | 预留线程容量               | id          | id       | -       |
| jetty_reservedthreadexecutor_idletimeoutms      | 预留线程空闲超时时间           | id          | id       | ms      |
| jetty_reservedthreadexecutor_capacity           | 预留线程的最大数量            | id          | id       | -       |
| jetty_reservedthreadexecutor_available          | 可用的预留线程数             | id          | id       | -       |
| jetty_reservedthreadexecutor_pending            | 挂起的预留线程数             | id          | id       | -       |
| jetty_arraybufferpool_directbytebuffercount     | 直接ByteBuffer池的数量     | id          | id       | -       |
| jetty_bufferpool_heapmemory                     | 堆字节缓冲区总保留大小          | -           | -        | bytes   |
| jetty_arraybufferpool_heapbytebuffercount       | 堆ByteBuffer池的数量      | id          | id       | -       |
| jetty_arraybufferpool_directmemory              | 直接ByteBuffers保留内存    | id          | id       | bytes   |
| jetty_bufferpool_heapmemory                     | 堆ByteBuffers保留内存     | -           | -        | bytes   |
| jetty_webappprovider_stoptimeout                | 停止超时时间               | id          | id       | ms      |
| jetty_deploymentmanager_stoptimeout             | 停止超时时间               | id          | id       | ms      |
| jvm_memory_heap_usage_max                       | 堆内存最大值               | -           | -        | bytes   |
| jvm_memory_heap_usage_used                      | 堆内存使用量               | -           | -        | bytes   |
| jvm_memory_heap_usage_committed                 | 堆内存提交量               | -           | -        | bytes   |
| jvm_memory_heap_usage_init                      | 堆内存初始化大小             | -           | -        | bytes   |
| jvm_memory_nonheap_usage_max                    | 非堆内存最大值              | -           | -        | bytes   |
| jvm_memory_nonheap_usage_used                   | 非堆内存使用量              | -           | -        | bytes   |
| jvm_memory_nonheap_usage_committed              | 非堆内存提交量              | -           | -        | bytes   |
| jvm_memory_nonheap_usage_init                   | 非堆内存初始化大小            | -           | -        | bytes   |
| jmx_scrape_duration_seconds                     | JMX抓取消耗时间            | -           | -        | s       |
| jmx_scrape_error                                | 抓取失败的指标              | -           | -        | -       |



### 版本日志

#### weops_jetty_jmx v1.7.2

- weops调整

