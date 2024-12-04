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

### 版本日志

#### weops_weblogic_jmx v1.1.5

- weops调整



添加“小嘉”微信即可获取weblogic监控指标最佳实践礼包，其他更多问题欢迎咨询 

<img src="https://wedoc.canway.net/imgs/img/小嘉.jpg" width="50%" height="50%">
