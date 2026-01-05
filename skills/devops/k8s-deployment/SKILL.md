---
name: k8s-deployment
description: Generate Kubernetes manifests and Helm charts with best practices
version: 1.2.0
author: DevOps Team <devops@company.com>
category: devops
tags: [kubernetes, k8s, helm, deployment, orchestration]
status: stable
allowed-tools: [Write, Read, Bash]
triggers:
  - "쿠버네티스 배포"
  - "K8s 매니페스트"
  - "kubernetes deployment"
  - "create helm chart"
  - "k8s manifest"
dependencies: []
---

# Kubernetes Deployment

## 목적

Kubernetes 매니페스트와 Helm 차트를 Best Practice에 따라 자동 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새 애플리케이션의 K8s 배포 설정
- Helm 차트 생성 및 구조화
- 멀티 환경 배포 구성 (dev/staging/prod)

### ❌ 이 스킬을 사용하지 않을 때

- 복잡한 Operator 패턴 (수동 작성 권장)
- 레거시 배포 시스템 마이그레이션

## 작동 방식

1. **애플리케이션 분석**: 컨테이너 이미지, 포트, 환경변수 감지
2. **매니페스트 생성**: Deployment, Service, Ingress, ConfigMap 등
3. **보안 설정**: RBAC, Network Policy, Security Context
4. **Helm 차트**: Values, templates, 환경별 설정

## 예제

### 예제 1: 기본 Deployment + Service

**생성되는 매니페스트:**
```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: myapp
  labels:
    app: myapp
    version: v1
spec:
  replicas: 3
  selector:
    matchLabels:
      app: myapp
  template:
    metadata:
      labels:
        app: myapp
        version: v1
    spec:
      # 보안: non-root 사용자
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
        fsGroup: 1000

      containers:
      - name: myapp
        image: myapp:1.0.0
        ports:
        - containerPort: 8080
          name: http

        # 리소스 제한
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"

        # Health checks
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10

        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5

        # 환경변수
        env:
        - name: NODE_ENV
          value: "production"
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: myapp-secrets
              key: database-url

        # 보안 컨텍스트
        securityContext:
          allowPrivilegeEscalation: false
          readOnlyRootFilesystem: true
          capabilities:
            drop:
            - ALL

        # 볼륨 마운트
        volumeMounts:
        - name: tmp
          mountPath: /tmp
        - name: cache
          mountPath: /app/cache

      volumes:
      - name: tmp
        emptyDir: {}
      - name: cache
        emptyDir: {}

---
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: myapp
  labels:
    app: myapp
spec:
  type: ClusterIP
  ports:
  - port: 80
    targetPort: 8080
    protocol: TCP
    name: http
  selector:
    app: myapp
```

### 예제 2: Ingress + TLS

```yaml
# ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: myapp
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - myapp.example.com
    secretName: myapp-tls
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp
            port:
              number: 80
```

### 예제 3: ConfigMap + Secret

```yaml
# configmap.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: myapp-config
data:
  app.properties: |
    server.port=8080
    logging.level=INFO
  nginx.conf: |
    server {
      listen 80;
      location / {
        proxy_pass http://localhost:8080;
      }
    }

---
# secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: myapp-secrets
type: Opaque
stringData:
  database-url: "postgresql://user:pass@db:5432/myapp"
  api-key: "your-api-key"
```

### 예제 4: HPA (Horizontal Pod Autoscaler)

```yaml
# hpa.yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: myapp
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: myapp
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80
```

### 예제 5: Helm Chart 구조

**생성되는 Helm Chart:**
```
myapp/
├── Chart.yaml
├── values.yaml
├── values-dev.yaml
├── values-staging.yaml
├── values-production.yaml
└── templates/
    ├── deployment.yaml
    ├── service.yaml
    ├── ingress.yaml
    ├── configmap.yaml
    ├── secret.yaml
    ├── hpa.yaml
    ├── serviceaccount.yaml
    ├── _helpers.tpl
    └── NOTES.txt
```

**Chart.yaml:**
```yaml
apiVersion: v2
name: myapp
description: A Helm chart for MyApp
type: application
version: 1.0.0
appVersion: "1.0.0"
keywords:
  - myapp
  - nodejs
maintainers:
  - name: DevOps Team
    email: devops@company.com
```

**values.yaml:**
```yaml
replicaCount: 3

image:
  repository: myapp
  pullPolicy: IfNotPresent
  tag: "1.0.0"

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: true
  className: "nginx"
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: myapp-tls
      hosts:
        - myapp.example.com

resources:
  limits:
    cpu: 200m
    memory: 256Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: true
  minReplicas: 3
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 80

env:
  - name: NODE_ENV
    value: "production"
```

**values-production.yaml:**
```yaml
replicaCount: 5

image:
  tag: "1.0.0"

ingress:
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix

resources:
  limits:
    cpu: 500m
    memory: 512Mi
  requests:
    cpu: 250m
    memory: 256Mi

autoscaling:
  minReplicas: 5
  maxReplicas: 20
```

**templates/deployment.yaml:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "myapp.fullname" . }}
  labels:
    {{- include "myapp.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "myapp.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "myapp.selectorLabels" . | nindent 8 }}
    spec:
      containers:
      - name: {{ .Chart.Name }}
        image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
        imagePullPolicy: {{ .Values.image.pullPolicy }}
        ports:
        - name: http
          containerPort: 8080
          protocol: TCP
        livenessProbe:
          httpGet:
            path: /health
            port: http
        readinessProbe:
          httpGet:
            path: /ready
            port: http
        resources:
          {{- toYaml .Values.resources | nindent 12 }}
        {{- with .Values.env }}
        env:
          {{- toYaml . | nindent 10 }}
        {{- end }}
```

### 예제 6: 배포 명령어

```bash
# Helm chart 검증
helm lint ./myapp

# Development 환경 배포
helm upgrade --install myapp ./myapp \
  --namespace dev \
  --create-namespace \
  --values values-dev.yaml

# Production 환경 배포 (dry-run)
helm upgrade --install myapp ./myapp \
  --namespace production \
  --create-namespace \
  --values values-production.yaml \
  --dry-run --debug

# Production 환경 실제 배포
helm upgrade --install myapp ./myapp \
  --namespace production \
  --values values-production.yaml \
  --wait --timeout 5m

# 배포 상태 확인
kubectl get pods -n production
kubectl get svc -n production
kubectl get ingress -n production
```

## 설정

`.skillconfig.json`:
```json
{
  "k8sDeployment": {
    "helmEnabled": true,
    "environments": ["dev", "staging", "production"],
    "features": {
      "ingress": true,
      "hpa": true,
      "pdb": true,
      "networkPolicy": true,
      "serviceMonitor": true
    },
    "securityContext": {
      "runAsNonRoot": true,
      "readOnlyRootFilesystem": true
    }
  }
}
```

## 의존성

```json
{
  "kubernetes": "^1.28.0",
  "helm": "^3.13.0",
  "kubectl": "^1.28.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
