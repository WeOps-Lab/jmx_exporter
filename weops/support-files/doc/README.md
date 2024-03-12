## 嘉为蓝鲸Tomcat插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

tomcat版本: 6.x, 7.x, 8.x, 9.x, 10.x

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
#### 配置tomcat jmx参数
##### Linux环境  
   - 打开tomcat的bin目录下的catalina.sh文件
   - 在文件中找到CATALINA_OPTS变量，添加如下参数
      ```
      -Dcom.sun.management.jmxremote
      -Dcom.sun.management.jmxremote.port=1234
      -Dcom.sun.management.jmxremote.ssl=false
      -Dcom.sun.management.jmxremote.authenticate=false
      ```
      
      例如:
      ```
      CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.1.1 -Dcom.sun.management.jmxremote.port=1234 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
      ```
      
      配置JMX的账号密码验证(选择性)：
      ```
      CATALINA_OPTS="$CATALINA_OPTS -Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.1.1 -Dcom.sun.management.jmxremote.port=1234 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=true -Dcom.sun.management.jmxremote.access.file=./jmx.access -Dcom.sun.management.jmxremote.password.file=./jmx.password"
      ```
      
      jmx.access文件内容参考：
      ```
      #用户名	权限
      monitor readonly
      ```
      
      jmx.password参考内容：
      ```
      注意：若无法启动tomcat则建议修改jmx.password文件的权限，权限设置为400或600
      #用户名	密码
      monitor monitor
      ```
   
   - 重启tomcat
   - 验证jmx端口是否生效: `netstat -antlp |grep 1234`

##### Windows环境
修改Tomcat目录下 `bin\catalina.bat` 文件内容, 先搜索 `CATALINA_OPTS` 

方式一: 
在 `CATALINA_OPTS` 上方添加    
```shell
#添加的参数内容。192.168.1.1改为对应主机ip，若1234端口已使用，可改为其他未在使用的端口
set CATALINA_OPTS=$CATALINA_OPTS -Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.1.1 -Dcom.sun.management.jmxremote.port=1234 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false

#   CATALINA_OPTS   (Optional) Java runtime options used when the "start",
#                   "run" or "debug" command is executed.
#..........
```

方式二: 
搜索 `CATALINA_OPTS` 并在附近找到下方内容  
`rem ----- Execute The Requested Command ---------------------------------------`

在这一行下面添加  
```shell
set CATALINA_OPTS=$CATALINA_OPTS -Dcom.sun.management.jmxremote -Djava.rmi.server.hostname=192.168.1.1 -Dcom.sun.management.jmxremote.port=1234 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false
```

如果尝试两种方式都发现启动tomcat异常, 请检查是否将变量放入不合适的位置, 比如注释区域或者其他变量和启动命令。   

#### 网络策略问题
jmx采集会同时随机打开rmi端口, 所以在有网络限制(防火墙)的情况下, 需要注意在参数中添加 `Dcom.sun.management.jmxremote.rmi.port=1234`, 指定rmi打开的端口, 该端口可以和 `Dcom.sun.management.jmxremote.port` 填写的值一样  

### 指标简介
| **指标ID**                              | **指标中文名**          | **维度ID**        | **维度含义**      | **单位** |
|---------------------------------------|--------------------|-----------------|---------------|--------|
| tomcat_serverinfo                     | Tomcat服务器信息        | serverinfo      | 服务器信息         | -      |
| tomcat_bytesreceived_total            | Tomcat全局接收总流量      | port, protocol  | 端口号, 协议类型     | bytes  |
| tomcat_bytessent_total                | Tomcat全局发送总流量      | port, protocol  | 端口号, 协议类型     | bytes  |
| tomcat_errorcount_total               | Tomcat全局错误总数       | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_processingtime_total           | Tomcat全局处理总时长      | port, protocol  | 端口号, 协议类型     | ms     |
| tomcat_maxtime_total                  | Tomcat全局最大处理时长     | port, protocol  | 端口号, 协议类型     | ms     |
| tomcat_requestcount_total             | Tomcat全局请求总数       | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_maxthreads          | Tomcat线程池最大线程数     | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_pollerthreadcount   | Tomcat线程池轮询线程数     | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_connectioncount     | Tomcat线程池连接数       | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_acceptorthreadcount | Tomcat线程池接收器线程数    | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_keepalivecount      | Tomcat线程池保持活跃线程数   | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_minsparethreads     | Tomcat线程池最小空闲线程数   | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_currentthreadcount  | Tomcat线程池当前线程数     | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_currentthreadsbusy  | Tomcat线程池繁忙线程数     | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_threadpool_acceptcount         | Tomcat线程池接受计数      | port, protocol  | 端口号, 协议类型     | -      |
| tomcat_session_sessioncounter_total   | Tomcat会话计数器总数      | context, host   | 上下文路径, 主机     | -      |
| tomcat_session_rejectedsessions_total | Tomcat会话拒绝会话总数     | context, host   | 上下文路径, 主机     | -      |
| tomcat_session_expiredsessions_total  | Tomcat会话过期会话总数     | context, host   | 上下文路径, 主机     | -      |
| tomcat_session_processingtime_total   | Tomcat会话处理总时长      | context, host   | 上下文路径, 主机     | ms     |
| tomcat_servlet_errorcount_total       | Tomcat servlet错误总数 | module, servlet | 模块, servlet名称 | -      |
| tomcat_servlet_requestcount_total     | Tomcat servlet请求总数 | module, servlet | 模块, servlet名称 | -      |
| tomcat_servlet_processingtime_total   | Tomcat servlet处理总数 | module, servlet | 模块, servlet名称 | ms     |
| jmx_scrape_duration_seconds           | JMX抓取消耗时间          | -               | -             | s      |
| jmx_scrape_error                      | 抓取失败的指标            | -               | -             | -      |


### 版本日志

#### weops_tomcat_jmx v2.1.0

- weops调整

#### weops_tomcat_jmx v2.2.0

- 增加windows tomcat配置内容
- 增加rmi端口说明

添加“小嘉”微信即可获取elasticsearch监控指标最佳实践礼包，其他更多问题欢迎咨询

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
