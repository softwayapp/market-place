---
name: dependency-check
description: Check dependencies for known vulnerabilities (CVE) with automated updates
version: 1.1.0
author: Security Team <security@company.com>
category: security
tags: [dependencies, cve, npm-audit, security, updates]
status: stable
allowed-tools: [Bash, Read]
triggers:
  - "의존성 검사"
  - "보안 업데이트"
  - "dependency check"
  - "npm audit"
  - "check vulnerabilities"
dependencies: []
---

# Dependency Check

## 목적

프로젝트 의존성의 알려진 보안 취약점(CVE)을 검사하고 자동 업데이트를 지원합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새로운 의존성 추가 시
- 정기적인 보안 점검 (주간/월간)
- CI/CD 파이프라인 통합

### ❌ 이 스킬을 사용하지 않을 때

- 의존성이 없는 프로젝트
- 오프라인 환경

## 작동 방식

1. **스캔**: npm audit 또는 yarn audit 실행
2. **CVE 확인**: 알려진 취약점 조회
3. **자동 수정**: 안전한 버전으로 업데이트
4. **리포트**: 취약점 요약

## 예제

### 예제 1: npm audit

**실행:**
```bash
npm audit
```

**결과:**
```
found 3 vulnerabilities (1 moderate, 2 high) in 1200 scanned packages

┌───────────────┬──────────────────────────────────────────────────────────┐
│ Moderate      │ Prototype Pollution                                       │
├───────────────┼──────────────────────────────────────────────────────────┤
│ Package       │ lodash                                                    │
├───────────────┼──────────────────────────────────────────────────────────┤
│ Patched in    │ >=4.17.19                                                │
├───────────────┼──────────────────────────────────────────────────────────┤
│ Dependency of │ express                                                   │
├───────────────┼──────────────────────────────────────────────────────────┤
│ Path          │ express > lodash                                          │
└───────────────┴──────────────────────────────────────────────────────────┘
```

**자동 수정:**
```bash
npm audit fix
```

### 예제 2: Snyk 통합

```bash
# Snyk로 의존성 스캔
snyk test

# 취약점 자동 수정
snyk fix
```

## 설정

`.skillconfig.json`:
```json
{
  "dependencyCheck": {
    "autoUpdate": false,
    "ignoreDevDependencies": false,
    "severityThreshold": "moderate",
    "schedule": "weekly"
  }
}
```

## 의존성

```json
{
  "snyk": "^1.0.0",
  "npm-check-updates": "^16.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
