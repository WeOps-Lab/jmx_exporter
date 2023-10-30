#!/bin/bash

# 设置监控对象
object="tomcat"

for version in v7-0 v8-5 v9-0 v10-1; do
    # dp
    standalone_output_file="standalone_${version}.yaml"
    sed "s/{{VERSION}}/${version}/g; s/{{OBJECT}}/${object}/g;" standalone.tpl > ../standalone/${standalone_output_file}

    # configMap
    configMap_output_file="configMap_${version}.yaml"
    sed "s/{{VERSION}}/${version}/g; s/{{OBJECT}}/${object}/g;" jmx_configMap.tpl > ../configMap/${configMap_output_file}
done
