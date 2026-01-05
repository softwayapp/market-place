---
name: deploy
description: Automated deployment with environment-specific configurations and rollback support
version: 1.0.0
author: DevOps Team <devops@company.com>
category: deployment
tags: [deploy, deployment, ci-cd, automation, production]
status: stable
---

# /deploy - Automated Deployment

## 목적

애플리케이션을 다양한 환경(development, staging, production)에 자동으로 배포하고 관리합니다.

## 사용법

```bash
# 기본 배포 (staging 환경)
/deploy

# 특정 환경 배포
/deploy production
/deploy staging
/deploy development

# 버전 지정 배포
/deploy production --version v1.2.3

# Dry-run (실제 배포 없이 시뮬레이션)
/deploy production --dry-run

# 롤백
/deploy production --rollback
/deploy production --rollback-to v1.2.2

# 배포 상태 확인
/deploy status
/deploy status production
```

## 배포 플로우

### 1. Pre-Deployment 체크

```yaml
Pre-deployment Checklist:
  ✓ Code Quality:
    - Linting passed
    - Type checking passed
    - Code analysis score > 70

  ✓ Testing:
    - Unit tests passed (100%)
    - Integration tests passed (95%)
    - E2E tests passed (90%)
    - Coverage > 80%

  ✓ Security:
    - No critical vulnerabilities
    - Dependency audit passed
    - Secrets detection passed

  ✓ Build:
    - Build successful
    - Assets optimized
    - Docker image created

  ✓ Documentation:
    - CHANGELOG.md updated
    - API docs current
    - Deployment notes prepared
```

### 2. 배포 실행

```markdown
# Deployment Process

## Stage 1: Preparation
[14:30:15] 📦 Building application...
[14:30:45] ✅ Build completed (30s)
[14:30:46] 🔍 Running tests...
[14:31:20] ✅ All tests passed (34s)
[14:31:21] 🔒 Security scan...
[14:31:35] ✅ No vulnerabilities found (14s)

## Stage 2: Deployment
[14:31:36] 🚀 Deploying to production...
[14:31:37] 📤 Uploading artifacts to S3...
[14:31:50] ✅ Upload complete (13s)
[14:31:51] 🐳 Building Docker image...
[14:32:25] ✅ Image built: myapp:v1.2.3 (34s)
[14:32:26] 📮 Pushing to registry...
[14:32:45] ✅ Push complete (19s)

## Stage 3: Rolling Update
[14:32:46] ♻️  Starting rolling update...
[14:32:47] 🔄 Updating pod 1/5...
[14:33:00] ✅ Pod 1 healthy
[14:33:01] 🔄 Updating pod 2/5...
[14:33:14] ✅ Pod 2 healthy
[14:33:15] 🔄 Updating pod 3/5...
[14:33:28] ✅ Pod 3 healthy
[14:33:29] 🔄 Updating pod 4/5...
[14:33:42] ✅ Pod 4 healthy
[14:33:43] 🔄 Updating pod 5/5...
[14:33:56] ✅ Pod 5 healthy

## Stage 4: Verification
[14:33:57] 🔍 Health checks...
[14:34:02] ✅ All endpoints responding
[14:34:03] 📊 Smoke tests...
[14:34:15] ✅ Critical paths verified
[14:34:16] 🎯 Load testing...
[14:34:45] ✅ Performance acceptable

## Stage 5: Finalization
[14:34:46] 📝 Updating deployment records...
[14:34:47] ✅ Records updated
[14:34:48] 🔔 Sending notifications...
[14:34:49] ✅ Team notified

---

✨ Deployment Successful!

Environment: production
Version: v1.2.3
Duration: 4m 34s
Deployed by: Claude Code
Timestamp: 2025-01-05 14:34:49 UTC

URL: https://app.example.com
Health: https://app.example.com/health
Metrics: https://metrics.example.com/dashboard
```

### 3. Post-Deployment 검증

```yaml
Post-deployment Verification:
  ✓ Health Checks:
    - API /health endpoint: OK
    - Database connectivity: OK
    - Redis connectivity: OK
    - External services: OK

  ✓ Smoke Tests:
    - User login flow: PASSED
    - Critical API endpoints: PASSED
    - Data integrity: PASSED

  ✓ Performance:
    - Response time < 200ms: OK
    - Error rate < 0.1%: OK
    - CPU usage < 60%: OK
    - Memory usage < 70%: OK

  ✓ Monitoring:
    - Prometheus scraping: OK
    - Logs streaming: OK
    - Alerts configured: OK
```

## 환경별 배포 전략

### Development
```yaml
Environment: development
Trigger: On push to develop branch
Strategy: Direct deployment
Approval: None required
Rollback: Automatic on failure

Checks:
  - Linting: Required
  - Unit Tests: Required
  - Build: Required

Notifications:
  - Slack: #dev-deployments
```

### Staging
```yaml
Environment: staging
Trigger: On push to main branch
Strategy: Blue-Green deployment
Approval: None required
Rollback: Automatic on failure

Checks:
  - All development checks
  - Integration tests: Required
  - E2E tests: Required
  - Security scan: Required

Notifications:
  - Slack: #staging-deployments
  - Email: qa-team@company.com
```

### Production
```yaml
Environment: production
Trigger: Manual or on tag
Strategy: Canary deployment (10% → 50% → 100%)
Approval: Required (2 approvers)
Rollback: Manual or automatic on critical alerts

Checks:
  - All staging checks
  - Performance tests: Required
  - Security audit: Required
  - Documentation: Required
  - Change log: Required

Notifications:
  - Slack: #prod-deployments
  - Email: all-engineering@company.com
  - PagerDuty: On-call team
```

## 배포 전략

### 1. Rolling Update (기본)
```yaml
Strategy: Rolling Update
Use Case: 일반적인 배포
Downtime: Zero
Risk: Low

Process:
  1. Update pods one by one
  2. Wait for health check
  3. Continue to next pod
  4. Complete when all updated
```

### 2. Blue-Green Deployment
```yaml
Strategy: Blue-Green
Use Case: 중요한 업데이트
Downtime: Zero
Risk: Very Low

Process:
  1. Deploy to Green environment
  2. Run full test suite
  3. Switch traffic: Blue → Green
  4. Keep Blue as backup
  5. Decommission Blue after validation
```

### 3. Canary Deployment
```yaml
Strategy: Canary
Use Case: 고위험 변경사항
Downtime: Zero
Risk: Minimal

Process:
  1. Deploy to 10% of traffic
  2. Monitor metrics for 15 minutes
  3. Increase to 50% if healthy
  4. Monitor for 15 minutes
  5. Complete to 100%
  6. Rollback if any issues
```

## 롤백 시나리오

### 자동 롤백
```markdown
# Automatic Rollback Triggered

Reason: Error rate > 1% threshold
Time: 2025-01-05 15:45:30 UTC
Version: v1.2.3 → v1.2.2

## Rollback Process
[15:45:31] 🚨 Error rate threshold exceeded
[15:45:32] 🔄 Initiating automatic rollback...
[15:45:33] 📦 Reverting to previous version (v1.2.2)
[15:45:45] ✅ Rollback complete (12s)
[15:45:46] 🔍 Verifying health...
[15:45:50] ✅ All systems normal
[15:45:51] 📧 Incident report sent

## Post-Rollback Status
- Version: v1.2.2
- Health: All systems operational
- Error rate: 0.05% (normal)
- Action required: Investigate v1.2.3 issues
```

### 수동 롤백
```bash
# 이전 버전으로 롤백
/deploy production --rollback

# 특정 버전으로 롤백
/deploy production --rollback-to v1.2.2

# Dry-run 롤백 (시뮬레이션)
/deploy production --rollback --dry-run
```

## 배포 모니터링

### 실시간 메트릭
```yaml
Deployment Metrics:
  - Deployment Duration: 4m 34s
  - Success Rate: 98.5%
  - Rollback Rate: 1.2%
  - Average Downtime: 0s

Health Metrics:
  - Request Rate: 1,250 req/s
  - Error Rate: 0.05%
  - Response Time (p95): 125ms
  - CPU Usage: 45%
  - Memory Usage: 62%

Business Metrics:
  - Active Users: 12,543
  - Conversion Rate: 3.2%
  - Revenue Impact: $0 (no change)
```

### 알림 설정
```yaml
Alerts:
  Critical:
    - Error rate > 1%
    - Response time > 1s
    - Service down
    → Action: Automatic rollback + PagerDuty

  Warning:
    - Error rate > 0.5%
    - Response time > 500ms
    - Memory > 80%
    → Action: Slack notification

  Info:
    - Deployment started
    - Deployment completed
    - Health check passed
    → Action: Slack notification
```

## 배포 체크리스트

### Before Deployment
- [ ] All tests passing
- [ ] Code reviewed and approved
- [ ] CHANGELOG.md updated
- [ ] Database migrations tested
- [ ] Feature flags configured
- [ ] Rollback plan prepared
- [ ] Team notified

### During Deployment
- [ ] Monitor error rates
- [ ] Watch response times
- [ ] Check health endpoints
- [ ] Verify metrics dashboard
- [ ] Stay available for rollback

### After Deployment
- [ ] Verify all features working
- [ ] Check error logs
- [ ] Review performance metrics
- [ ] Update documentation
- [ ] Notify stakeholders
- [ ] Post-mortem (if issues)

## 환경 설정

### 환경 변수
```bash
# Development
ENVIRONMENT=development
API_URL=https://dev-api.example.com
LOG_LEVEL=debug

# Staging
ENVIRONMENT=staging
API_URL=https://staging-api.example.com
LOG_LEVEL=info

# Production
ENVIRONMENT=production
API_URL=https://api.example.com
LOG_LEVEL=warn
```

### 배포 설정 파일
```yaml
# .deployment.yml
environments:
  development:
    replicas: 1
    resources:
      cpu: "500m"
      memory: "512Mi"
    autoscaling: false

  staging:
    replicas: 2
    resources:
      cpu: "1000m"
      memory: "1Gi"
    autoscaling: false

  production:
    replicas: 5
    resources:
      cpu: "2000m"
      memory: "2Gi"
    autoscaling:
      enabled: true
      minReplicas: 5
      maxReplicas: 20
      targetCPU: 70
```

## 통합 플랫폼

- **GitHub Actions**: CI/CD 자동화
- **Docker**: 컨테이너화
- **Kubernetes**: 오케스트레이션
- **Helm**: 패키지 관리
- **ArgoCD**: GitOps 배포
- **Terraform**: 인프라 as Code

## 라이선스

MIT License - 조직 내부 사용 전용
