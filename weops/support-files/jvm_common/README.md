## 嘉为蓝鲸jvm JMX插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

通用

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
需要监控对象打开JMX远程连接, 具体操作请参考对应组件的文档

#### 网络策略问题
jmx采集会同时随机打开rmi端口, 所以在有网络限制(防火墙)的情况下, 需要注意在参数中添加 `Dcom.sun.management.jmxremote.rmi.port=9999`, 指定rmi打开的端口, 该端口可以和 `Dcom.sun.management.jmxremote.port` 填写的值一样  

### 指标简介
| **指标ID**                        | **指标中文名**      | **维度ID** | **维度含义** | **单位** |
|---------------------------------|----------------|----------|----------|--------|
| jvm_memory_usage_init           | 初始内存大小         | type     | 内存类型     | bytes  |
| jvm_memory_usage_committed      | 已提交内存大小        | type     | 内存类型     | bytes  |
| jvm_memory_usage_used           | 已使用内存大小        | type     | 内存类型     | bytes  |
| jvm_memory_usage_max            | 已使用最大内存        | type     | 内存类型     | bytes  |
| jvm_threads_total_started_count | 总线程数           | type     | 线程类型     | -      |
| jvm_threads_daemon_count        | 守护线程数          | type     | 线程类型     | -      |
| jvm_threads_peak_count          | 峰值线程数          | type     | 线程类型     | -      |
| jvm_threads_count               | 启动的线程总数        | type     | 线程类型     | -      |
| jvm_threads_current_user_time   | 当前线程用户时间       | -        | -        | s      |
| jvm_os_memory_physical_free     | 可用物理内存         | type     | 内存类型     | bytes  |
| jvm_os_memory_physical_total    | 总物理内存          | type     | 内存类型     | bytes  |
| jvm_os_memory_swap_free         | 可用交换空间         | type     | 内存类型     | bytes  |
| jvm_os_memory_swap_total        | 总交换空间          | type     | 内存类型     | bytes  |
| jvm_os_memory_committed_virtual | 提交的虚拟内存        | type     | 内存类型     | bytes  |
| jvm_os_available_processors     | 可用处理器数         | -        | -        | -      |
| jvm_os_processcputime_seconds   | 进程CPU时间        | -        | -        | s      |
| jvm_bufferpool_count            | BufferPool计数   | type     | 缓冲池类型    | count  |
| jvm_bufferpool_memoryused       | BufferPool已用内存 | type     | 缓冲池类型    | bytes  |
| jvm_bufferpool_totalcapacity    | BufferPool总容量  | type     | 缓冲池类型    | bytes  |
| jvm_gc_collectiontime_seconds   | GC收集总时间        | type     | GC类型     | s      |
| jvm_gc_collectioncount          | GC收集总次数        | type     | GC类型     | -      |
| jvm_memorypool_usage_init       | 内存池初始内存使用量     | type     | 内存池类型    | bytes  |
| jvm_memorypool_usage_committed  | 内存池提交内存使用量     | type     | 内存池类型    | bytes  |
| jvm_memorypool_usage_used       | 内存池已使用内存       | type     | 内存池类型    | bytes  |
| jvm_memorypool_usage_max        | 内存池最大内存使用量     | type     | 内存池类型    | bytes  |
| jmx_scrape_duration_seconds     | JMX抓取消耗时间      | -        | -        | s      |
| jmx_scrape_error                | 抓取失败的指标        | -        | -        | -      |


### 版本日志

#### weops_jvm_jmx v2.1.2

- weops调整



添加“小嘉”微信即可获取jvm监控指标最佳实践礼包，其他更多问题欢迎咨询 

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
