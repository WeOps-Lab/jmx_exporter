#!/bin/bash

# 设置监控对象
object="tomcat"
object_versions=("7.0.109" "8.5" "9.0" "10.1")

# 设置起始端口号
http_port=30880
jmx_port=30990

for version in "${object_versions[@]}"; do
    version_suffix="v$(echo "$version" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}' | tr '.' '-')"

    helm install $object-$version_suffix --namespace $object -f ./values/bitnami_values.yaml ./$object \
    --set image.tag=$version \
    --set commonLabels.object_version=$version_suffix \
    --set service.nodePorts.http=$http_port \
    --set service.extraPorts[0].nodePort=$jmx_port
    ((http_port++))
    ((jmx_port++))
    sleep 1
done
