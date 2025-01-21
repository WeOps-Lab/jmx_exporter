## 嘉为蓝鲸tongweb6监控插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

Tongweb: 6

**是否支持远程采集:**

是

### 参数说明


| **参数名**  | **含义**                                                                          | **是否必填** | **使用举例**                                            |
|----------|---------------------------------------------------------------------------------|----------|-----------------------------------------------------|
| host     | 监听IP(采集器IP)，建议使用默认的127.0.0.1                                                    | 是        | 127.0.0.1                                           |
| port     | 监听端口(采集器监听端口)，一般为9601，注意不要与已使用端口冲突                                              | 是        | 9601                                                |
| username | jmx认证用户名，若未配置则留空                                                                | 否        |                                                     |
| password | jmx认证密码，若未配置则留空                                                                 | 否        |                                                     |
| jmx_url  | jmx 连接字符串，格式为service:jmx:rmi:///jndi/rmi://${target_host}:${target_port}/jmxrmi | 是        | service:jmx:rmi:///jndi/rmi://127.0.0.1:7200/jmxrmi |

### 使用指引  

Tongweb6默认JMX已开启，端口为7200。
如果想修改JMX远程端口可以查看TongWeb6.1/conf/tongweb.xml找到以下配置进行修改
```xml
<jmx-service port="7200" address="127.0.0.1"/>
```

#### 开启JMX远程的配置
找到TongWeb6.1/bin/external.vmoptions文件  
在文件中添加以下内容, 若已存在内容则修改对应配置  
```
-Djava.rmi.server.hostname={填写远程IP}
-Dtongweb.jconsole.cbport=7200
-Dtongweb.rmijmx.cbport=7200
```

修改完成后重启服务(startservernohup.sh)  

重启完成后即可使用JMX远程连接, JMX认证用户名和密码与console管理界面的用户名和密码一致    
默认账户: `twnt` 
默认密码: `twnt123.com`

### 指标简介
| **指标ID**                                             | **指标中文名**     | **维度ID**                | **维度含义** | **单位** |
|------------------------------------------------------|---------------|-------------------------|----------|--------|
| tongweb6_monitor_runtime_uptime                      | 实例已运行时间       | -                       | -        | ms     |
| tongweb6_monitor_http_connector_requestcount         | HTTP连接请求数     | name_info               | 名称       | -      |
| tongweb6_monitor_http_connector_bytessent            | HTTP连接发送字节数   | name_info               | 名称       | bytes  |
| tongweb6_monitor_http_connector_bytesreceived        | HTTP连接接收字节数   | name_info               | 名称       | bytes  |
| tongweb6_monitor_http_connector_errorcount           | HTTP连接错误数     | name_info               | 名称       | -      |
| tongweb6_monitor_http_connector_maxtime              | HTTP连接最大处理时间  | name_info               | 名称       | ms     |
| tongweb6_monitor_http_connector_bytesreceivedandsent | HTTP连接收发字节数   | name_info               | 名称       | bytes  |
| tongweb6_monitor_http_connector_maxthreads           | HTTP连接最大线程数   | name_info               | 名称       | -      |
| tongweb6_monitor_http_connector_processingtime       | HTTP连接总处理时间   | name_info               | 名称       | ms     |
| tongweb6_monitor_http_connector_currentthreadsbusy   | HTTP连接当前繁忙线程数 | name_info               | 名称       | -      |
| tongweb6_monitor_http_connector_minsparethreads      | HTTP连接最小空闲线程数 | name_info               | 名称       | -      |
| tongweb6_monitor_http_connector_currentthreadshang   | HTTP连接当前挂起线程数 | name_info               | 名称       | -      |
| tongweb6_monitor_http_connector_currentthreadcount   | HTTP连接当前线程总数  | name_info               | 名称       | -      |
| tongweb6_monitor_http_connector_averagetime          | HTTP连接平均处理时间  | name_info               | 名称       | ms     |
| tongweb6_tongweb6_global_request_processor_bytessent | 全局请求发送字节数     | name_info               | 名称       | bytes  |
| tongweb6_global_request_processor_maxtime            | 全局请求最大处理时间    | name_info               | 名称       | ms     |
| tongweb6_global_request_processor_processingtime     | 全局请求总处理时间     | name_info               | 名称       | ms     |
| tongweb6_global_request_processor_bytesreceived      | 全局请求接收字节数     | name_info               | 名称       | bytes  |
| tongweb6_global_request_processor_requestcount       | 全局请求总数        | name_info               | 名称       | -      |
| tongweb6_global_request_processor_errorcount         | 全局请求错误总数      | name_info               | 名称       | -      |
| tongweb6_manager_expiredsessions                     | 管理器过期会话数      | host_info, context_info | 主机, 上下文  | -      |
| tongweb6_manager_processingtime                      | 管理器处理总时间      | host_info, context_info | 主机, 上下文  | ms     |
| tongweb6_manager_rejectedsessions                    | 管理器被拒绝会话数     | host_info, context_info | 主机, 上下文  | -      |
| tongweb6_manager_sessionaveragealivetime             | 管理器会话平均存活时间   | host_info, context_info | 主机, 上下文  | ms     |
| tongweb6_manager_sessionmaxalivetime                 | 管理器会话最大存活时间   | host_info, context_info | 主机, 上下文  | ms     |
| tongweb6_manager_activesessions                      | 管理器活动会话数      | host_info, context_info | 主机, 上下文  | -      |
| tongweb6_manager_maxactive                           | 管理器最大活动会话数    | host_info, context_info | 主机, 上下文  | -      |
| tongweb6_thread_pool_keepalivecount                  | 线程池存活线程数      | name_info               | 名称       | -      |
| tongweb6_thread_pool_currentthreadshang              | 当前挂起线程数       | name_info               | 名称       | -      |
| tongweb6_thread_pool_currentthreadsbusy              | 当前忙线程数        | name_info               | 名称       | -      |
| jmx_scrape_duration_seconds                          | JMX抓取消耗时间     | -                       | -        | s      |
| jmx_scrape_error                                     | 抓取失败的指标       | -                       | -        | -      |


### 版本日志

#### weops_tongweb6_jmx v1.5.0

- weops调整


添加“小嘉”微信即可获取tongweb6监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
