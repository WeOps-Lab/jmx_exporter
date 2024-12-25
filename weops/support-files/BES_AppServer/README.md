## 嘉为蓝鲸宝兰德BES AppServer监控插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

BES AppServer: 9.5

**是否支持远程采集:**

是

### 参数说明


| **参数名**  | **含义**                                                                          | **是否必填** | **使用举例**                                            |
|----------|---------------------------------------------------------------------------------|----------|-----------------------------------------------------|
| host     | 监听IP(采集器IP)，建议使用默认的127.0.0.1                                                    | 是        | 127.0.0.1                                           |
| port     | 监听端口(采集器监听端口)，一般为9601，注意不要与已使用端口冲突                                              | 是        | 9601                                                |
| username | jmx认证用户名，若未配置则留空                                                                | 否        |                                                     |
| password | jmx认证密码，若未配置则留空                                                                 | 否        |                                                     |
| jmx_url  | jmx 连接字符串，格式为service:jmx:rmi:///jndi/rmi://${target_host}:${target_port}/jmxrmi | 是        | service:jmx:rmi:///jndi/rmi://127.0.0.1:6600/jmxrmi |

### 使用指引  

BES9.5提供了JMX监控功能，可通过控制台或者修改配置文件的方式配置JMX监控功能，默认JMX已开启，端口为6600    

对应配置文件$BES_HOME/conf/server.config中   
```yaml
<server>
  <jmx-connector address="0.0.0.0" port="6600" auth-realm-name="admin-realm" enabled="true" security-enabled="false">
```  

默认账户密码为`admin/B#2008_2108#es`  

### 指标简介
| **指标ID**                                 | **指标中文名**   | **维度ID**                 | **维度含义**    | **单位**  |
|------------------------------------------|-------------|--------------------------|-------------|---------|
| bes_jmx_openfiledescriptorcount          | 打开文件描述符计数   | -                        | -           | -       |
| bes_jmx_maxfiledescriptorcount           | 最大打开文件描述符计数 | -                        | -           | -       |
| bes_jmx_committedvirtualmemorysize       | 已提交虚拟内存大小   | -                        | -           | bytes   |
| bes_jmx_totalswapspacesize               | 总Swap空间大小   | -                        | -           | bytes   |
| bes_jmx_freeswapspacesize                | 空闲Swap空间大小  | -                        | -           | bytes   |
| bes_jmx_freephysicalmemorysize           | 空闲物理内存大小    | -                        | -           | bytes   |
| bes_jmx_totalphysicalmemorysize          | 总物理内存大小     | -                        | -           | bytes   |
| bes_jmx_systemcpuload                    | 系统CPU负载     | -                        | -           | -       |
| bes_jmx_processcpuload                   | 进程CPU利用率    | -                        | -           | percent |
| bes_jmx_availableprocessors              | 可用处理器数      | -                        | -           | -       |
| bes_jmx_systemloadaverage                | 系统平均负载      | -                        | -           | -       |
| bes_jmx_objectpendingfinalizationcount   | 挂起终结对象数     | gcname                   | gc名称        | -       |
| bes_jmx_collectioncount                  | GC次数        | gcname                   | gc名称        | -       |
| bes_jmx_collectiontime                   | GC时间        | gcname                   | gc名称        | -       |
| bes_jmx_maxthreads                       | 最大线程数       | executorname, threadpool | 执行名称, 线程池名称 | -       |
| bes_jmx_minsparethreads                  | 最小空闲线程数     | executorname, threadpool | 执行名称, 线程池名称 | -       |
| bes_jmx_poolsize                         | 线程池容量       | executorname, threadpool | 执行名称, 线程池名称 | bytes   |
| bes_jmx_activecount                      | 活跃线程数       | executorname, threadpool | 执行名称, 线程池名称 | -       |
| bes_jmx_idlecount                        | 空闲线程数       | executorname, threadpool | 执行名称, 线程池名称 | -       |
| bes_jmx_queuesize                        | 等待任务队列大小    | executorname, threadpool | 执行名称, 线程池名称 | -       |
| bes_jmx_completedtaskcount               | 完成任务数       | executorname, threadpool | 执行名称, 线程池名称 | -       |
| bes_jmx_createdcount                     | 已创建对象数      | datasource               | 数据源         | -       |
| bes_jmx_numactive                        | 活跃连接数       | datasource               | 数据源         | -       |
| bes_jmx_borrowedcount                    | 借用对象数       | datasource               | 数据源         | -       |
| bes_jmx_numidle                          | 空闲连接数       | datasource               | 数据源         | -       |
| bes_jmx_numwaiters                       | 等待连接数       | datasource               | 数据源         | -       |
| bes_jmx_connectionleakcount              | 泄露连接数       | datasource               | 数据源         | -       |
| bes_jmx_destroyedcount                   | 销毁连接数       | datasource               | 数据源         | -       |
| bes_jmx_destroyedbyborrowvalidationcount | 验证销毁连接数     | datasource               | 数据源         | -       |
| bes_jmx_destroyedbyevictorcount          | 驱逐销毁连接数     | datasource               | 数据源         | -       |
| bes_jmx_meanborrowwaittimemillis         | 平均借用等待时间    | datasource               | 数据源         | ms      |
| bes_jmx_meanactivetimemillis             | 平均活动时间      | datasource               | 数据源         | ms      |
| bes_jmx_meanidletimemillis               | 平均空闲时间      | datasource               | 数据源         | ms      |
| bes_jmx_maxidle                          | 最大空闲连接数     | datasource               | 数据源         | -       |
| bes_jmx_minidle                          | 最小空闲连接数     | datasource               | 数据源         | -       |
| bes_jmx_initialsize                      | 初始连接数       | datasource               | 数据源         | -       |
| bes_jmx_maxwait                          | 最大等待连接数     | datasource               | 数据源         | -       |
| bes_jmx_timebetweenevictionrunsmillis    | 驱逐间隔时间      | datasource               | 数据源         | ms      |
| bes_jmx_returnedcount                    | 归还连接数       | datasource               | 数据源         | -       |
| bes_jmx_activesessions                   | 活跃会话数       | context, host            | 应用名称, 主机名称  | -       |
| bes_jmx_sessioncounter                   | 会话计数        | context, host            | 应用名称, 主机名称  | -       |
| bes_jmx_expiredsessions                  | 过期会话数       | context, host            | 应用名称, 主机名称  | -       |
| bes_jmx_bytessent                        | 已发送字节数      | httpname                 | http名称      | bytes   |
| bes_jmx_bytesreceived                    | 已接收字节数      | httpname                 | http名称      | bytes   |
| bes_jmx_processingtime                   | 处理时间        | httpname                 | http名称      | s       |
| bes_jmx_errorcount                       | 错误数         | httpname                 | http名称      | -       |
| bes_jmx_maxTime                          | 最大时间值       | httpname                 | http名称      | ms      |
| bes_jmx_requestcount                     | 请求数         | httpname                 | http名称      | -       |
| bes_jmx_connectioncount                  | 连接数         | httpname                 | http名称      | -       |
| bes_jmx_jca_maxthreads                   | JCA最大线程数    | jcaname                  | jca名称       | -       |
| bes_jmx_jca_minsparethreads              | JCA最小空闲线程数  | jcaname                  | jca名称       | -       |
| bes_jmx_jca_poolsize                     | JCA线程池容量    | jcaname                  | jca名称       | -       |
| bes_jmx_jca_activecount                  | JCA活跃线程数    | jcaname                  | jca名称       | -       |
| bes_jmx_jca_idlecount                    | JCA空闲线程数    | jcaname                  | jca名称       | bytes   |
| bes_jmx_jca_queuesize                    | JCA等待队列大小   | jcaname                  | jca名称       | bytes   |
| bes_jmx_jca_completedtaskcount           | JCA完成任务数    | jcaname                  | jca名称       | -       |
| jmx_scrape_duration_seconds              | JMX 抓取持续时间  | -                        | -           | s       |
| jmx_scrape_error                         | JMX 抓取错误    | -                        | -           | -       |


### 版本日志

#### weops_BESAppServer_jmx v2.2.0

- weops调整


添加“小嘉”微信即可获取宝兰德AppServer监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
