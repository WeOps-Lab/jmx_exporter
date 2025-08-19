## 嘉为蓝鲸InforSuite_AS插件使用说明

## 使用说明

### 插件功能
通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

InforSuite_AS版本: 10.0.5.3.9

**是否支持远程采集:**

是

### 参数说明


| **参数名**  | **含义**                                                                          | **是否必填** | **使用举例**                                            |
|----------|---------------------------------------------------------------------------------|----------|-----------------------------------------------------|
| host     | 监听IP(采集器IP)，建议使用默认的127.0.0.1                                                    | 是        | 127.0.0.1                                           |
| port     | 监听端口(采集器监听端口)，一般为9601，注意不要与已使用端口冲突                                              | 是        | 9601                                                |
| username | jmx认证用户名，若未配置则留空                                                                | 否        |                                                     |
| password | jmx认证密码，若未配置则留空                                                                 | 否        |                                                     |
| jmx_url  | jmx 连接字符串，格式为service:jmx:rmi:///jndi/rmi://${target_host}:${target_port}/jmxrmi | 是        | service:jmx:rmi:///jndi/rmi://127.0.0.1:8686/jmxrmi |

### 使用指引  
#### 配置InforSuite_AS jmx参数
##### Linux环境  

1. 图形界面配置JMX连接和监控配置  
**配置路径：** 【配置】→ 【server-config】->【管理服务】→【JMX连接器】  

只需要修改

- 安全性： 关闭（设置为false）以简化配置
- 地址： 必须填写真实的远程IP地址，不能使用localhost或127.0.0.1
- 端口： 默认8686，可根据需要修改
- 修改配置后需要重启InforSuite AS服务器

2. 图形界面配置监控配置(该步骤必须在图形界面操作，无法用命令)     
启用监控配置  
**配置路径：** 【配置】→ 【server-config】->【监控】→【一般信息】  
将该选项勾上 **AMX 可用性**：启用     

3. 命令行配置JMX连接  
**配置路径：** `{InforSuite AS安装路径}/as/bin`

**配置命令：**
```bash
# 修改安全性（建议设置为false）
./asadmin set server.admin-service.jmx-connector.system.security-enabled=false

# 修改地址（填写实际服务器IP）
./asadmin set server.admin-service.jmx-connector.system.address=IP地址

# 修改端口（默认8686）
./asadmin set server.admin-service.jmx-connector.system.port=8686
```

4. JMX连接方式说明
   - **启用安全性：** 需要用户名密码认证（如：Admin/123456）, 可能还需要认证配置文件
   - **关闭安全性：** 仅需IP和端口即可连接（**推荐使用**）  

5. JDBC连接池监控配置  
    **必要条件：** 【资源】→【JDBC连接池】中必须存在已配置的连接池，否则无法采集相关监控数据  
    **说明：** 资源监控主要是监控JDBC连接池统计信息。当监控开启并且监控级别为高时显示，当监控级别为低时不进行该项监控  

6. **配置完成后重启服务器**

7. 访问 https://127.0.0.1:8060/console/#/

#### 网络策略问题
jmx采集会同时随机打开rmi端口, 所以在有网络限制(防火墙)的情况下, 需要注意在参数中添加 `Dcom.sun.management.jmxremote.rmi.port=1234`, 指定rmi打开的端口, 该端口可以和 `Dcom.sun.management.jmxremote.port` 填写的值一样  

### 指标简介
| **指标ID**                                   | **指标中文名** | **维度ID**    | **维度含义** | **单位**  |
|--------------------------------------------|-----------|-------------|----------|---------|
| amx_server_mon_cpu_percent                 | CPU使用率    | -           | -        | percent |
| amx_http_request_processingtime            | 响应时间      | server_name | 虚拟主机     | ms      |
| amx_http_request_countrequests             | 请求数       | server_name | 虚拟主机     | -       |
| amx_jsp_mon_totaljspcount                  | 处理数据次数    | -           | -        | -       |
| amx_request_mon_countbytestransmitted      | 传输数据量     | server_name | 虚拟主机     | bytes   |
| amx_request_mon_countbytesreceived         | 接收数据量     | server_name | 虚拟主机     | bytes   |
| amx_jdbc_pool_mon_numconnused              | 正在被使用连接数  | pool_name   | 连接名称     | -       |
| amx_jdbc_pool_mon_numconnfree              | 空闲连接数     | pool_name   | 连接名称     | -       |
| amx_jdbc_pool_mon_waitqueuelength          | 等待线程数     | pool_name   | 连接名称     | -       |
| amx_thread_pool_runtime_currentthreadcount | 正在使用线程数   | -           | -        | -       |
| amx_thread_pool_runtime_corethreads        | 核心线程数     | -           | -        | -       |
| amx_thread_pool_runtime_totalexecutedtasks | 等待队列大小    | -           | -        | -       |
| jmx_scrape_duration_seconds                | JMX抓取消耗时间 | -           | -        | s       |
| jmx_scrape_error                           | 抓取失败的指标   | -           | -        | -       |

### 版本日志

#### weops_InforSuite_AS_jmx v2.1.0

- weops调整


