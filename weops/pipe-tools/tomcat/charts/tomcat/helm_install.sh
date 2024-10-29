#!/bin/bash

# 设置监控对象
object="tomcat"
object_versions=("7.0.109" "8.5" "9.0" "10.1")

# 设置起始端口号
port=30880

for version in "${object_versions[@]}"; do
    version_suffix="v$(echo "$version" | grep -Eo '[0-9]{1,2}\.[0-9]{1,2}' | tr '.' '-')"

    helm install $object-$version_suffix --namespace $object -f ./values/bitnami_values.yaml ./$object \
    --set image.tag=$version \
    --set commonLabels.object_version=$version_suffix \
    --set service.nodePorts.http=$port

    ((port++))
    sleep 1
done
