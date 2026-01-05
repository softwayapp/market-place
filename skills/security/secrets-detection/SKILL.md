---
name: secrets-detection
description: Detect hardcoded secrets, API keys, and credentials in code and git history
version: 1.0.0
author: Security Team <security@company.com>
category: security
tags: [secrets, api-keys, credentials, git-history, security]
status: stable
allowed-tools: [Read, Grep, Bash]
triggers:
  - "시크릿 탐지"
  - "API 키 검사"
  - "secrets detection"
  - "find api keys"
  - "credential scan"
dependencies: []
---

# Secrets Detection

## 목적

하드코딩된 비밀번호, API 키, 토큰 등을 코드와 Git 히스토리에서 탐지합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 커밋 전 자동 검사
- 레거시 코드 감사
- Git 히스토리 스캔

### ❌ 이 스킬을 사용하지 않을 때

- 이미 암호화된 값
- 환경 변수로 관리 중인 경우

## 작동 방식

1. **패턴 매칭**: 알려진 시크릿 패턴 탐지
2. **Git 히스토리**: 과거 커밋 스캔
3. **엔트로피 분석**: 랜덤 문자열 탐지
4. **알림**: 발견 시 즉시 경고

## 예제

### 예제 1: 탐지되는 시크릿 패턴

```javascript
// ❌ AWS Access Key
const AWS_ACCESS_KEY = 'AKIAIOSFODNN7EXAMPLE';

// ❌ GitHub Token
const GITHUB_TOKEN = 'ghp_1234567890abcdefghijklmnopqrstuvwxyz';

// ❌ JWT Secret
const JWT_SECRET = 'my-super-secret-jwt-key-12345';

// ❌ Database URL with password
const DB_URL = 'postgresql://user:MyPassword123@localhost/db';

// ❌ Private Key
const PRIVATE_KEY = '-----BEGIN RSA PRIVATE KEY-----\nMIIEpAIBAAKCAQE...';
```

### 예제 2: 탐지 결과

```
🔍 Secrets Detection Report
━━━━━━━━━━━━━━━━━━━━━━━━━━━

🚨 Found 5 secrets:

1. AWS Access Key
   File: src/config/aws.js:3
   Pattern: AKIA[0-9A-Z]{16}

2. GitHub Personal Access Token
   File: scripts/deploy.sh:10
   Pattern: ghp_[a-zA-Z0-9]{36}

3. JWT Secret (High Entropy)
   File: src/auth/jwt.ts:5
   Pattern: Suspicious string

4. Database Password
   File: .env.example:7
   Pattern: Connection string with password

5. Private Key
   File: config/cert.js:15
   Pattern: RSA PRIVATE KEY

⚠️  Action Required:
- Remove secrets from code
- Use environment variables
- Rotate compromised credentials
- Add .gitignore rules
```

### 예제 3: Pre-commit Hook

```bash
#!/bin/bash
# .git/hooks/pre-commit

# Run secrets detection
if detect-secrets scan --baseline .secrets.baseline; then
  echo "✅ No secrets detected"
  exit 0
else
  echo "❌ Secrets detected! Commit blocked."
  exit 1
fi
```

## 설정

`.skillconfig.json`:
```json
{
  "secretsDetection": {
    "scanGitHistory": true,
    "customPatterns": [
      {
        "name": "Custom API Key",
        "pattern": "api_key_[a-z0-9]{32}"
      }
    ],
    "exclude": [
      "**/test/**",
      "**/*.example"
    ]
  }
}
```

## 의존성

```json
{
  "detect-secrets": "^1.4.0",
  "gitleaks": "^8.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
