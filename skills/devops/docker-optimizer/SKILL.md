---
name: docker-optimizer
description: Optimize Docker images for size, security, and build performance
version: 1.0.0
author: DevOps Team <devops@company.com>
category: devops
tags: [docker, optimization, security, multi-stage, caching]
status: stable
allowed-tools: [Read, Write, Edit, Bash]
triggers:
  - "도커 최적화"
  - "Docker 이미지 최적화"
  - "optimize docker"
  - "reduce image size"
  - "docker best practices"
dependencies: []
---

# Docker Optimizer

## 목적

Docker 이미지의 크기, 보안, 빌드 성능을 최적화합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 이미지 크기가 너무 큰 경우 (>500MB)
- 빌드 시간이 오래 걸리는 경우 (>5분)
- 보안 취약점이 많은 베이스 이미지 사용

### ❌ 이 스킬을 사용하지 않을 때

- 이미 최적화된 공식 이미지 사용 중
- 로컬 개발 전용 Dockerfile

## 작동 방식

1. **Dockerfile 분석**: 레이어, 캐싱, 베이스 이미지 분석
2. **최적화 적용**: Multi-stage build, layer 최소화, 보안 강화
3. **검증**: 이미지 크기, 취약점 스캔, 빌드 시간 측정
4. **리포트**: 최적화 전후 비교 및 권장사항

## 예제

### 예제 1: Node.js 애플리케이션 최적화

**최적화 전:**
```dockerfile
FROM node:20
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build
EXPOSE 3000
CMD ["npm", "start"]
```
**문제점:**
- 큰 베이스 이미지 (node:20 ~900MB)
- 모든 파일 복사 (불필요한 파일 포함)
- 캐시 효율 낮음
- 개발 의존성 포함

**최적화 후:**
```dockerfile
# Multi-stage build
FROM node:20-alpine AS builder
WORKDIR /app

# 캐싱 최적화: package.json만 먼저 복사
COPY package*.json ./
RUN npm ci --only=production

# 소스 복사 및 빌드
COPY . .
RUN npm run build

# Production 이미지
FROM node:20-alpine
WORKDIR /app

# 보안: non-root 사용자
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nodejs -u 1001

# 빌드 결과물만 복사
COPY --from=builder --chown=nodejs:nodejs /app/dist ./dist
COPY --from=builder --chown=nodejs:nodejs /app/node_modules ./node_modules
COPY --from=builder --chown=nodejs:nodejs /app/package*.json ./

USER nodejs
EXPOSE 3000
CMD ["node", "dist/index.js"]
```

**개선 결과:**
- 이미지 크기: 900MB → 120MB (87% 감소)
- 빌드 시간: 5분 → 1분 (캐시 히트 시)
- 보안: 취약점 50개 → 5개

### 예제 2: Python 애플리케이션 최적화

**최적화 전:**
```dockerfile
FROM python:3.11
WORKDIR /app
COPY . .
RUN pip install -r requirements.txt
CMD ["python", "app.py"]
```

**최적화 후:**
```dockerfile
# Builder stage
FROM python:3.11-slim AS builder
WORKDIR /app

# 가상환경 생성
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# 의존성 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Runtime stage
FROM python:3.11-slim
WORKDIR /app

# 가상환경 복사
COPY --from=builder /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# 애플리케이션 코드만 복사
COPY app/ ./app/
COPY config/ ./config/

# 보안: non-root 사용자
RUN useradd -m -u 1000 appuser && \
    chown -R appuser:appuser /app

USER appuser
EXPOSE 8000

# Healthcheck 추가
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD python -c "import requests; requests.get('http://localhost:8000/health')"

CMD ["python", "-m", "app.main"]
```

### 예제 3: .dockerignore 최적화

```
# .dockerignore
# 버전 관리
.git
.gitignore
.gitattributes

# 문서
*.md
docs/
LICENSE

# 개발 환경
.vscode/
.idea/
*.swp
*.swo

# 테스트
tests/
**/*.test.js
**/*.spec.ts
coverage/
.nyc_output/

# 빌드 아티팩트
dist/
build/
*.log
npm-debug.log*

# 환경 설정
.env
.env.local
.env.*.local

# 의존성 (package-lock은 유지)
node_modules/

# OS 파일
.DS_Store
Thumbs.db
```

### 예제 4: 이미지 분석 및 리포트

**생성되는 분석 리포트:**
```markdown
# Docker Image Optimization Report

## Summary
- **Original Size**: 945 MB
- **Optimized Size**: 128 MB
- **Reduction**: 817 MB (86.5%)
- **Build Time**: 4m 32s → 58s (with cache)

## Layer Analysis

### Before
```
LAYER 1: FROM node:20 (900 MB)
LAYER 2: COPY . . (25 MB)
LAYER 3: RUN npm install (15 MB)
LAYER 4: RUN npm run build (5 MB)
```

### After
```
BUILDER:
LAYER 1: FROM node:20-alpine (115 MB)
LAYER 2: COPY package*.json (2 KB)
LAYER 3: RUN npm ci (10 MB)
LAYER 4: COPY . . (5 MB)

RUNTIME:
LAYER 1: FROM node:20-alpine (115 MB)
LAYER 2: COPY --from=builder /app/dist (3 MB)
LAYER 3: COPY --from=builder /app/node_modules (10 MB)
```

## Security Scan

### Vulnerabilities Fixed
- **Critical**: 3 → 0
- **High**: 12 → 1
- **Medium**: 35 → 4
- **Total**: 50 → 5

## Recommendations
✅ Multi-stage build implemented
✅ Alpine base image used
✅ Non-root user configured
✅ .dockerignore optimized
✅ Layer caching improved
⚠️ Consider distroless image for even smaller size
⚠️ Add HEALTHCHECK instruction
```

## 설정

`.skillconfig.json`:
```json
{
  "dockerOptimizer": {
    "targetSize": "200MB",
    "baseImagePreference": "alpine",
    "securityScanning": true,
    "multiStage": true,
    "cacheOptimization": true,
    "healthcheck": true
  }
}
```

## 의존성

```json
{
  "docker": "^24.0.0",
  "trivy": "^0.48.0",
  "dive": "^0.11.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
