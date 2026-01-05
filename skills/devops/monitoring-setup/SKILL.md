---
name: monitoring-setup
description: Setup monitoring stack with Prometheus, Grafana, and alerting
version: 1.1.0
author: DevOps Team <devops@company.com>
category: devops
tags: [monitoring, prometheus, grafana, alerting, observability]
status: stable
allowed-tools: [Write, Read, Bash]
triggers:
  - "모니터링 설정"
  - "프로메테우스 설정"
  - "setup monitoring"
  - "configure prometheus"
  - "grafana dashboard"
dependencies: []
---

# Monitoring Setup

## 목적

Prometheus, Grafana, Alertmanager를 사용한 완전한 모니터링 스택을 자동 구성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새 프로젝트의 모니터링 인프라 구축
- 기존 시스템에 Observability 추가
- 알림 및 대시보드 자동화

### ❌ 이 스킬을 사용하지 않을 때

- 클라우드 네이티브 모니터링 사용 중 (CloudWatch, Azure Monitor)
- 커스텀 메트릭 수집기 필요 시

## 작동 방식

1. **인프라 분석**: 애플리케이션 타입, 언어, 프레임워크 감지
2. **스택 설정**: Prometheus, Grafana, Alertmanager 구성
3. **메트릭 수집**: 애플리케이션별 exporter 및 수집 규칙
4. **대시보드 생성**: 자동화된 Grafana 대시보드
5. **알림 설정**: 중요 메트릭 기반 알림 규칙

## 예제

### 예제 1: Prometheus 기본 설정

**생성되는 prometheus.yml:**
```yaml
# prometheus.yml
global:
  scrape_interval: 15s
  evaluation_interval: 15s
  external_labels:
    cluster: 'production'
    environment: 'prod'

# Alertmanager 설정
alerting:
  alertmanagers:
    - static_configs:
        - targets:
            - alertmanager:9093

# 알림 규칙 파일
rule_files:
  - '/etc/prometheus/rules/*.yml'

# 스크랩 설정
scrape_configs:
  # Prometheus 자체 모니터링
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  # Node Exporter (시스템 메트릭)
  - job_name: 'node'
    static_configs:
      - targets:
          - 'node-exporter:9100'

  # 애플리케이션 메트릭
  - job_name: 'myapp'
    static_configs:
      - targets:
          - 'myapp:8080'
    metrics_path: /metrics
    scrape_interval: 10s

  # Kubernetes 메트릭
  - job_name: 'kubernetes-apiservers'
    kubernetes_sd_configs:
      - role: endpoints
    scheme: https
    tls_config:
      ca_file: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
    bearer_token_file: /var/run/secrets/kubernetes.io/serviceaccount/token
    relabel_configs:
      - source_labels: [__meta_kubernetes_namespace, __meta_kubernetes_service_name, __meta_kubernetes_endpoint_port_name]
        action: keep
        regex: default;kubernetes;https

  # Kubernetes Pods
  - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
      - role: pod
    relabel_configs:
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
        action: keep
        regex: true
      - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
        action: replace
        target_label: __metrics_path__
        regex: (.+)
      - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
        action: replace
        regex: ([^:]+)(?::\d+)?;(\d+)
        replacement: $1:$2
        target_label: __address__
```

### 예제 2: Alert Rules

**생성되는 alert_rules.yml:**
```yaml
# /etc/prometheus/rules/alert_rules.yml
groups:
  - name: application_alerts
    interval: 30s
    rules:
      # High Error Rate
      - alert: HighErrorRate
        expr: |
          rate(http_requests_total{status=~"5.."}[5m]) > 0.05
        for: 5m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }} on {{ $labels.instance }}"

      # High Response Time
      - alert: HighResponseTime
        expr: |
          histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
          team: backend
        annotations:
          summary: "High response time detected"
          description: "95th percentile response time is {{ $value }}s on {{ $labels.instance }}"

      # High CPU Usage
      - alert: HighCPUUsage
        expr: |
          100 - (avg by(instance) (rate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 10m
        labels:
          severity: warning
          team: devops
        annotations:
          summary: "High CPU usage detected"
          description: "CPU usage is {{ $value }}% on {{ $labels.instance }}"

      # High Memory Usage
      - alert: HighMemoryUsage
        expr: |
          (1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100 > 90
        for: 5m
        labels:
          severity: critical
          team: devops
        annotations:
          summary: "High memory usage detected"
          description: "Memory usage is {{ $value }}% on {{ $labels.instance }}"

      # Service Down
      - alert: ServiceDown
        expr: up == 0
        for: 2m
        labels:
          severity: critical
          team: devops
        annotations:
          summary: "Service is down"
          description: "{{ $labels.job }} on {{ $labels.instance }} is down"

      # Database Connection Issues
      - alert: DatabaseConnectionIssues
        expr: |
          rate(database_errors_total[5m]) > 10
        for: 5m
        labels:
          severity: critical
          team: backend
        annotations:
          summary: "Database connection issues"
          description: "Database error rate is {{ $value }}/s on {{ $labels.instance }}"
```

### 예제 3: Alertmanager 설정

**생성되는 alertmanager.yml:**
```yaml
# alertmanager.yml
global:
  resolve_timeout: 5m
  slack_api_url: 'https://hooks.slack.com/services/YOUR/SLACK/WEBHOOK'

# 알림 라우팅
route:
  group_by: ['alertname', 'cluster', 'service']
  group_wait: 10s
  group_interval: 10s
  repeat_interval: 12h
  receiver: 'default'

  routes:
    # Critical alerts to PagerDuty
    - match:
        severity: critical
      receiver: 'pagerduty'
      continue: true

    # Backend team alerts
    - match:
        team: backend
      receiver: 'slack-backend'

    # DevOps team alerts
    - match:
        team: devops
      receiver: 'slack-devops'

# 알림 수신자 설정
receivers:
  - name: 'default'
    slack_configs:
      - channel: '#alerts'
        title: '{{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

  - name: 'slack-backend'
    slack_configs:
      - channel: '#backend-alerts'
        title: '🔥 {{ .GroupLabels.alertname }}'
        text: |
          *Severity:* {{ .CommonLabels.severity }}
          *Description:* {{ range .Alerts }}{{ .Annotations.description }}{{ end }}
        send_resolved: true

  - name: 'slack-devops'
    slack_configs:
      - channel: '#devops-alerts'
        title: '⚠️ {{ .GroupLabels.alertname }}'
        text: |
          *Severity:* {{ .CommonLabels.severity }}
          *Description:* {{ range .Alerts }}{{ .Annotations.description }}{{ end }}
        send_resolved: true

  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_SERVICE_KEY'
        description: '{{ .GroupLabels.alertname }}: {{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

# 알림 억제 규칙
inhibit_rules:
  - source_match:
      severity: 'critical'
    target_match:
      severity: 'warning'
    equal: ['alertname', 'instance']
```

### 예제 4: Grafana Dashboard JSON

**생성되는 app-dashboard.json:**
```json
{
  "dashboard": {
    "title": "Application Metrics",
    "tags": ["application", "monitoring"],
    "timezone": "browser",
    "panels": [
      {
        "id": 1,
        "title": "Request Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total[5m])",
            "legendFormat": "{{method}} {{status}}"
          }
        ],
        "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0}
      },
      {
        "id": 2,
        "title": "Response Time (95th percentile)",
        "type": "graph",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))",
            "legendFormat": "{{method}} {{path}}"
          }
        ],
        "gridPos": {"h": 8, "w": 12, "x": 12, "y": 0}
      },
      {
        "id": 3,
        "title": "Error Rate",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(http_requests_total{status=~\"5..\"}[5m])",
            "legendFormat": "{{method}} {{status}}"
          }
        ],
        "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8},
        "alert": {
          "name": "High Error Rate",
          "conditions": [
            {
              "evaluator": {"params": [0.05], "type": "gt"},
              "operator": {"type": "and"},
              "query": {"params": ["A", "5m", "now"]},
              "reducer": {"params": [], "type": "avg"},
              "type": "query"
            }
          ]
        }
      },
      {
        "id": 4,
        "title": "CPU Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "rate(process_cpu_seconds_total[5m]) * 100",
            "legendFormat": "{{instance}}"
          }
        ],
        "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8}
      }
    ]
  }
}
```

### 예제 5: Docker Compose 스택

**생성되는 docker-compose.yml:**
```yaml
version: '3.8'

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - ./rules:/etc/prometheus/rules
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
      - '--storage.tsdb.retention.time=30d'
    ports:
      - "9090:9090"
    restart: unless-stopped

  grafana:
    image: grafana/grafana:latest
    container_name: grafana
    volumes:
      - grafana_data:/var/lib/grafana
      - ./grafana/dashboards:/etc/grafana/provisioning/dashboards
      - ./grafana/datasources:/etc/grafana/provisioning/datasources
    environment:
      - GF_SECURITY_ADMIN_USER=admin
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    ports:
      - "3000:3000"
    restart: unless-stopped
    depends_on:
      - prometheus

  alertmanager:
    image: prom/alertmanager:latest
    container_name: alertmanager
    volumes:
      - ./alertmanager.yml:/etc/alertmanager/alertmanager.yml
      - alertmanager_data:/alertmanager
    command:
      - '--config.file=/etc/alertmanager/alertmanager.yml'
      - '--storage.path=/alertmanager'
    ports:
      - "9093:9093"
    restart: unless-stopped

  node-exporter:
    image: prom/node-exporter:latest
    container_name: node-exporter
    command:
      - '--path.rootfs=/host'
    volumes:
      - '/:/host:ro,rslave'
    ports:
      - "9100:9100"
    restart: unless-stopped

volumes:
  prometheus_data:
  grafana_data:
  alertmanager_data:
```

## 설정

`.skillconfig.json`:
```json
{
  "monitoringSetup": {
    "stack": "prometheus-grafana",
    "retention": "30d",
    "alerting": {
      "enabled": true,
      "channels": ["slack", "pagerduty", "email"]
    },
    "exporters": ["node", "postgres", "redis"],
    "dashboards": ["application", "infrastructure", "database"]
  }
}
```

## 의존성

```json
{
  "prometheus": "^2.48.0",
  "grafana": "^10.2.0",
  "alertmanager": "^0.26.0",
  "node-exporter": "^1.7.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
