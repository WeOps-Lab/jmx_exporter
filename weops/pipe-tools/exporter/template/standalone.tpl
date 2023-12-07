apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{OBJECT}}-exporter-{{VERSION}}
  namespace: {{OBJECT}}
spec:
  serviceName: {{OBJECT}}-exporter-{{VERSION}}
  replicas: 1
  selector:
    matchLabels:
      app: {{OBJECT}}-exporter-{{VERSION}}
  template:
    metadata:
      annotations:
        telegraf.influxdata.com/interval: 1s
        telegraf.influxdata.com/inputs: |+
          [[inputs.cpu]]
            percpu = false
            totalcpu = true
            collect_cpu_time = true
            report_active = true

          [[inputs.disk]]
            ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]

          [[inputs.diskio]]

          [[inputs.kernel]]

          [[inputs.mem]]

          [[inputs.processes]]

          [[inputs.system]]
            fielddrop = ["uptime_format"]

          [[inputs.net]]
            ignore_protocol_stats = true

          [[inputs.procstat]]
          ## pattern as argument for exporter (ie, exporter -f <pattern>)
            pattern = "jmx_prometheus_httpserver"
        telegraf.influxdata.com/class: opentsdb
        telegraf.influxdata.com/env-fieldref-NAMESPACE: metadata.namespace
        telegraf.influxdata.com/limits-cpu: '300m'
        telegraf.influxdata.com/limits-memory: '300Mi'
      labels:
        app: {{OBJECT}}-exporter-{{VERSION}}
        exporter_object: {{OBJECT}}
        object_mode: standalone
        object_version: {{VERSION}}
        pod_type: exporter
    spec:
      nodeSelector:
        node-role: worker
      shareProcessNamespace: true
      volumes:
        - name: jmx-config
          configMap:
            name: tomcat-jmx-config-{{VERSION}}
      containers:
      - name: {{OBJECT}}-exporter-{{VERSION}}
        image: bitnami/jmx-exporter:0.20.0
        imagePullPolicy: IfNotPresent
        securityContext:
          allowPrivilegeEscalation: false
          runAsUser: 0
        args:
          - "12345"
          - /jmx_config/{{OBJECT}}_jmx_config_{{VERSION}}.yml
        volumeMounts:
          - mountPath: /jmx_config
            name: jmx-config
        resources:
          requests:
            cpu: 100m
            memory: 100Mi
          limits:
            cpu: 500m
            memory: 500Mi
        ports:
        - containerPort: 12345

---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: {{OBJECT}}-exporter-{{VERSION}}
  name: {{OBJECT}}-exporter-{{VERSION}}
  namespace: {{OBJECT}}
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "12345"
    prometheus.io/path: '/metrics'
spec:
  ports:
  - port: 12345
    protocol: TCP
    targetPort: 12345
  selector:
    app: {{OBJECT}}-exporter-{{VERSION}}
