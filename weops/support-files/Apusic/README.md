## 嘉为蓝鲸金蝶中间件Apusic监控插件使用说明

## 使用说明

### 插件功能

通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

Apusic: v10

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
#### 配置JMX参数
##### Linux环境

##### 配置JMX连接器

**配置路径：** 【配置】→【server-config】→【管理服务】→【JMX连接器】

需要修改以下参数：

- **安全性：** 设置为 `false`（关闭安全认证以简化配置）
- **地址：** 填写真实的远程IP地址（**不能使用** `localhost` 或 `127.0.0.1`）
- **端口：** 默认 `6886`，可根据实际需求修改
- **重要提示：** 修改配置后必须重启服务才能生效

##### 启用监控配置

> **注意：** 此步骤必须在图形界面操作，无法通过命令行完成

**配置路径：** 【配置】→【server-config】→【监视配置】→【监视服务】

1. 启用以下选项：
   - **监视服务**：✓ 启用
   - **监视MBean**：✓ 启用

2. 将以下组件的监视级别设置为 `高`：
   - Jvm
   - Jdbc Connection Pool
   - Thread Pool
   - Http Service
   - Deployment
   - Transaction Service
   - Web Container

##### 重启服务

**操作路径：** 【服务器】→【管控服务器】→【一般信息】→ 选择 **重新启动**

### 指标简介
| **指标ID**                                       | **指标中文名**     | **维度ID**    | **维度含义** | **单位**  | **指标类型** |
|------------------------------------------------|---------------|-------------|----------|---------|----------|
| amx_web_maxtime                                | 最长响应时间        | -           | -        | ms      | gauge    |
| amx_web_processingtime                         | 平均请求处理时间      | -           | -        | ms      | gauge    |
| amx_web_errorcount                             | 错误计数的累积值      | -           | -        | -       | counter  |
| amx_web_requestcount                           | 已处理请求的累计数量    | -           | -        | -       | counter  |
| amx_jsp_mon_totaljspcount                      | 处理数据次数        | -           | -        | -       | untyped  |
| amx_transactions_committedcount                | 已提交事务数        | -           | -        | -       | gauge    |
| amx_transactions_rolledbackcount               | 回滚事务数         | -           | -        | -       | gauge    |
| amx_transactions_activecount                   | 当前活跃事务数       | -           | -        | -       | gauge    |
| amx_jdbc_pool_mon_numconnfree                  | 空闲连接数         | pool_name   | 连接名称     | -       | gauge    |
| amx_jdbc_pool_mon_numconnused                  | 正在被使用连接数      | pool_name   | 连接名称     | -       | gauge    |
| amx_jdbc_pool_mon_waitqueuelength              | 等待线程数         | pool_name   | 连接名称     | -       | gauge    |
| amx_thread_pool_currentthreadsbusy             | 正在请求处理的线程数    | -           | -        | -       | gauge    |
| amx_thread_pool_corethreads                    | 线程池中的线程核心数    | -           | -        | -       | gauge    |
| amx_sessions_activesessionscurrent             | 当前活跃会话数       | -           | -        | -       | gauge    |
| amx_sessions_rejectedsessionstotal             | 拒绝的会话总数       | -           | -        | -       | untyped  |
| amx_sessions_sessionstotal                     | 会话总数          | -           | -        | -       | untyped  |
| amx_sessions_persistedsessionstotal            | 持久化会话总数       | -           | -        | -       | untyped  |
| amx_sessions_expiredsessionstotal              | 已过期的会话总数      | -           | -        | -       | untyped  |
| amx_deployment_activeapplicationsdeployedcount | 当前活跃的应用程序数    | -           | -        | -       | gauge    |
| amx_deployment_totalapplicationsdeployedcount  | 部署的应用程序总数     | -           | -        | -       | counter  |
| amx_request_mon_countbytestransmitted          | 传输数据量         | server_name | 虚拟主机     | bytes   | untyped  |
| amx_request_mon_countbytesreceived             | 接收数据量         | server_name | 虚拟主机     | bytes   | untyped  |
| amx_servlet_activeservletsloadedcount          | 当前活跃的servlet数 | -           | -        | -       | gauge    |
| amx_servlet_servletprocessingtimes             | 累计servlet处理时间 | -           | -        | ms      | untyped  |
| amx_servlet_totalservletsloadedcount           | 已加载的servlet总数 | -           | -        | -       | untyped  |
| amx_jvm_memory_freephysicalmemory_count        | 空闲物理内存        | -           | -        | bytes   | gauge    |
| amx_jvm_memory_usedheapsize_count              | 已用内存量         | -           | -        | bytes   | gauge    |
| amx_jvm_memory_processcpuload_count            | cpu负载         | -           | -        | percent | gauge    |
| jmx_scrape_duration_seconds                    | JMX抓取消耗时间     | -           | -        | s       | gauge    |
| jmx_scrape_error                               | 抓取失败的指标       | -           | -        | -       | gauge    |


### 版本日志

#### weops_Apusic_jmx v1.1.2

- weops调整
