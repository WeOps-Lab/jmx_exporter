## 嘉为蓝鲸ActiveMQ监控插件使用说明

## 使用说明

### 插件功能

通过抓取和公开JMX目标的mBeans来收集有关应用程序的度量数据，并将这些度量数据转换为Prometheus监控指标格式。

### 版本支持

操作系统支持: linux, windows

是否支持arm: 支持

**组件支持版本：**

ActiveMQ: 5.10.x ~ 5.15.x

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

#### 开启远程JMX

找到 bin/activemq 或 bin/env 文件(具体路径和文件名根据 ActiveMQ 版本略有不同)
在文件中找到 `ACTIVEMQ_SUNJMX_START` 变量定义并修改。根据采集任务实际环境，设置 Djava.rmi.server.hostname 等 JMX 参数。如果是本地连接，可以设置为 127.0.0.1；如果是远程采集，需要设置为具体的远程 IP

```shell
ACTIVEMQ_SUNJMX_START="$ACTIVEMQ_SUNJMX_START -Djava.rmi.server.hostname=127.0.0.1 -Dcom.sun.management.jmxremote.port=1099 -Dcom.sun.management.jmxremote.rmi.port=1099 -Dcom.sun.management.jmxremote=true  -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false"
```



进入 conf 目录，编辑 activemq.xml

在 broker 节点增加 `useJmx="true"` , 在 managementContext 节点将 `createConnector` 设置为true，并将连接端口 `connectorPort` 设置为1099 。 
```xml
    <broker xmlns="http://activemq.apache.org/schema/core" brokerName="localhost" dataDirectory="${activemq.data}" useJmx="true">
    <!--省略其他配置--> 
        <managementContext>
            <managementContext createConnector="true" connectorPort="1099"/>
        </managementContext>
    <!--省略其他配置-->
    </broker>
```

重启 ActiveMQ 服务使配置生效。  
```shell
bin/activemq stop
bin/activemq start
```



### 指标简介
| **指标ID**                                         | **指标中文名**   | **维度ID**    | **维度含义** | **单位**  |
|--------------------------------------------------|-------------|-------------|----------|---------|
| activemq_connections_total                       | 连接总数        | -           | -        | -       |
| activemq_connections                             | 当前连接数       | -           | -        | -       |
| activemq_topic_memory_limit                      | 内存限制大小      | destination | 目标       | bytes   |
| activemq_topic_memory_percent_usage              | 内存使用百分比     | destination | 目标       | percent |
| activemq_topic_memory_usage_byte_count           | 未投递消息的内存使用量 | destination | 目标       | bytes   |
| activemq_memory_usage_ratio                      | 内存使用率       | -           | -        | percent |
| activemq_topic_average_enqueue_time              | 平均进入队列时间    | destination | 目标       | ms      |
| activemq_topic_max_enqueue_time                  | 最大入队时间      | destination | 目标       | ms      |
| activemq_topic_min_enqueue_time                  | 最小入队时间      | destination | 目标       | ms      |
| activemq_topic_queue_size                        | 队列大小        | destination | 目标       | -       |
| activemq_topic_enqueue_count                     | 发送到目标的消息数量  | destination | 目标       | -       |
| activemq_topic_dequeue_count                     | 确认的消息数量     | destination | 目标       | -       |
| activemq_dequeue_total                           | 确认的消息总数     | -           | -        | -       |
| activemq_enqueue_total                           | 发送到代理的消息数量  | -           | -        | -       |
| activemq_topic_dlq                               | 死信队列状态      | destination | 目标       | -       |
| activemq_message_total                           | 未确认消息总数     | -           | -        | -       |
| activemq_topic_prioritized_messages              | 优先消息设置状态    | destination | 目标       | -       |
| activemq_topic_average_message_size              | 平均消息大小      | destination | 目标       | bytes   |
| activemq_topic_max_message_size                  | 最大消息大小      | destination | 目标       | bytes   |
| activemq_topic_blocked_sends                     | 被流控阻塞的消息数量  | destination | 目标       | -       |
| activemq_topic_dispatch_count                    | 传递的消息数量     | destination | 目标       | -       |
| activemq_topic_in_flight_count                   | 未确认的传递消息数量  | destination | 目标       | -       |
| activemq_topic_expired_count                     | 已过期的消息数量    | destination | 目标       | -       |
| activemq_producer_total                          | 生产者总数       | -           | -        | -       |
| activemq_topic_max_producers_to_audit            | 最大生产者审核数    | destination | 目标       | -       |
| activemq_topic_producer_count                    | 生产者数量       | destination | 目标       | -       |
| activemq_topic_producer_flow_control             | 生产者流量控制状态   | destination | 目标       | -       |
| activemq_topic_blocked_producer_warning_interval | 阻塞生产者警告间隔   | destination | 目标       | ms      |
| activemq_topic_consumer_count                    | 消费者数量       | destination | 目标       | -       |
| activemq_consumer_total                          | 消费者总数       | -           | -        | -       |
| activemq_topic_consumer_count                    | 消费者数量       | destination | 目标       | -       |
| activemq_topic_max_audit_depth                   | 最大审计深度      | destination | 目标       | -       |
| activemq_topic_use_cache                         | 允许缓存状态      | destination | 目标       | -       |
| activemq_topic_always_retroactive                | 是否总是逆向处理    | destination | 目标       | -       |
| activemq_topic_total_blocked_time                | 被流控阻塞的总时间   | destination | 目标       | ms      |
| activemq_topic_max_page_size                     | 最大分页大小      | destination | 目标       | -       |
| activemq_topic_average_blocked_time              | 平均被阻塞时间     | destination | 目标       | ms      |
| activemq_jobschedulerstore_usage_ratio           | 作业存储使用率     | -           | -        | percent |
| activemq_store_usage_ratio                       | 存储使用率       | -           | -        | percent |
| activemq_temp_usage_ratio                        | 临时存储使用率     | -           | -        | percent |
| jvm_memory_heap_usage_max                        | 堆内存最大值      | -           | -        | bytes   |
| jvm_memory_heap_usage_used                       | 堆内存使用量      | -           | -        | bytes   |
| jvm_memory_heap_usage_committed                  | 堆内存提交量      | -           | -        | bytes   |
| jvm_memory_heap_usage_init                       | 堆内存初始化大小    | -           | -        | bytes   |
| jvm_memory_nonheap_usage_max                     | 非堆内存最大值     | -           | -        | bytes   |
| jvm_memory_nonheap_usage_used                    | 非堆内存使用量     | -           | -        | bytes   |
| jvm_memory_nonheap_usage_committed               | 非堆内存提交量     | -           | -        | bytes   |
| jvm_memory_nonheap_usage_init                    | 非堆内存初始化大小   | -           | -        | bytes   |
| jmx_scrape_duration_seconds                      | JMX抓取消耗时间   | -           | -        | s       |
| jmx_scrape_error                                 | 抓取失败的指标     | -           | -        | -       |


### 版本日志

#### weops_activemq_jmx v1.4.0

- weops调整
