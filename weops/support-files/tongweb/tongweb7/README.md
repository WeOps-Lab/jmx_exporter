## 嘉为蓝鲸tongweb7监控插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

Tongweb: 7

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

Tongweb7默认JMX已开启，端口为7200。
如果想修改JMX远程端口可以查看TongWeb7.0.4.9_M5_Enterprise_Linux/conf/tongweb.xml找到以下配置进行修改
```xml
<jmx-service port="7200" address="127.0.0.1" protocol="rmi"/>
<jms-service/>
```

如果使用远程采集则需要将address中的IP替换为远程访问的IP地址  

修改完成后重启服务(startservernohup.sh)    

重启完成后即可使用JMX远程连接, JMX认证用户名和密码与console管理界面的用户名和密码一致       
默认账户: `thanos`   
默认密码: `thanos123.com`     

有部分版本必须先初次登录并修改密码，才允许JMX远程访问。     

#### 其他方式开启JMX远程
不修改tongweb.xml的情况下，下两种方式选择一种即可，不能都修改  

##### 管理控制台修改配置
进入tongweb console `http://127.0.0.1:9060/console`  

登录后在左侧找到 `启动参数配置` , 进入后找到 `服务器参数`, 分别增加以下参数  
```
-Djava.rmi.server.hostname={填写远程IP}
-Dtongweb.jconsole.cbport=7200
-Dtongweb.rmijmx.cbport=7200
```

##### 配置文件(external.vmoptions)
找到TongWeb7.0.4.9_M5_Enterprise_Linux/bin/external.vmoptions文件, 增加配置  
```
-Djava.rmi.server.hostname={填写远程IP}
-Dtongweb.jconsole.cbport=7200
-Dtongweb.rmijmx.cbport=7200
```


### 指标简介
| **指标ID**                                       | **指标中文名**   | **维度ID**                | **维度含义** | **单位** |
|------------------------------------------------|-------------|-------------------------|----------|--------|
| tongweb7_globalrequestprocessor_processingtime | 全局请求总处理时间   | name_info               | 名称       | ms     |
| tongweb7_globalrequestprocessor_bytessent      | 全局请求发送字节数   | name_info               | 名称       | bytes  |
| tongweb7_globalrequestprocessor_bytesreceived  | 全局请求接收字节数   | name_info               | 名称       | bytes  |
| tongweb7_globalrequestprocessor_errorcount     | 全局请求错误总数    | name_info               | 名称       | -      |
| tongweb7_globalrequestprocessor_maxtime        | 全局请求最大处理时间  | name_info               | 名称       | ms     |
| tongweb7_globalrequestprocessor_requestcount   | 全局请求总数      | name_info               | 名称       | -      |
| tongweb7_connector_maxparametercount           | 最大参数数量      | port                    | 端口       | -      |
| tongweb7_connector_asynctimeout                | 异步超时时间      | port                    | 端口       | ms     |
| tongweb7_connector_maxsavepostsize             | 最大保存POST体大小 | port                    | 端口       | bytes  |
| tongweb7_connector_maxpostsize                 | 最大POST体大小   | port                    | 端口       | bytes  |
| tongweb7_manager_expiredsessions               | 管理器过期会话数    | host_info, context_info | 主机, 上下文  | -      |
| tongweb7_manager_rejectedsessions              | 管理器被拒绝会话数   | host_info, context_info | 主机, 上下文  | -      |
| tongweb7_manager_activesessions                | 管理器活动会话数    | host_info, context_info | 主机, 上下文  | -      |
| tongweb7_manager_sessionaveragealivetime       | 管理器会话平均存活时间 | host_info, context_info | 主机, 上下文  | ms     |
| tongweb7_manager_sessionmaxalivetime           | 管理器会话最大存活时间 | host_info, context_info | 主机, 上下文  | ms     |
| tongweb7_manager_maxactive                     | 管理器最大活动会话数  | host_info, context_info | 主机, 上下文  | -      |
| tongweb7_threadpool_keepalivecount             | 线程池存活线程数    | name_info               | 名称       | -      |
| tongweb7_threadpool_queuesize                  | 线程池队列大小     | name_info               | 名称       | -      |
| tongweb7_threadpool_currentthreadshang         | 当前挂起线程数     | name_info               | 名称       | -      |
| tongweb7_threadpool_currentthreadsbusy         | 当前忙线程数      | name_info               | 名称       | -      |
| tongweb7_threadpool_currentthreadcount         | 当前线程总数      | name_info               | 名称       | -      |
| jmx_scrape_duration_seconds                    | JMX抓取消耗时间   | -                       | -        | s      |
| jmx_scrape_error                               | 抓取失败的指标     | -                       | -        | -      |

**注意**
threadpool和connector分类指标需要jdk21+才能采集到  

### 版本日志

#### weops_tongweb7_jmx v2.5.5

- weops调整


添加“小嘉”微信即可获取tongweb7监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
