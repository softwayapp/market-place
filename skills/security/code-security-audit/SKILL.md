---
name: code-security-audit
description: Comprehensive code security audit with SAST and secure coding practices validation
version: 1.2.0
author: Security Team <security@company.com>
category: security
tags: [security, sast, code-audit, secure-coding]
status: stable
allowed-tools: [Read, Grep, Bash]
triggers:
  - "코드 보안 감사"
  - "보안 코드 리뷰"
  - "code security audit"
  - "security code review"
dependencies: []
---

# Code Security Audit

## 목적

정적 분석(SAST)을 통해 코드 보안 취약점을 탐지하고 안전한 코딩 관행을 검증합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- PR 리뷰 시 보안 검증
- 보안 코딩 표준 준수 확인
- 민감 정보 노출 검사

### ❌ 이 스킬을 사용하지 않을 때

- 동적 분석 (DAST)
- 네트워크 보안

## 작동 방식

1. **하드코딩 검사**: 비밀번호, API 키 탐지
2. **취약 함수**: eval, exec 등 위험 함수
3. **암호화 검증**: 안전한 암호화 알고리즘
4. **인증/인가**: 보안 미들웨어 확인

## 예제

### 예제 1: 하드코딩된 비밀 탐지

**탐지된 이슈:**
```javascript
// ❌ Hardcoded API key
const apiKey = 'sk-1234567890abcdef';

// ❌ Hardcoded password
const dbPassword = 'MySecretPassword123';
```

**수정 방안:**
```javascript
// ✅ Environment variables
const apiKey = process.env.API_KEY;
const dbPassword = process.env.DB_PASSWORD;
```

### 예제 2: 취약한 암호화

**취약한 코드:**
```javascript
// ❌ Weak hashing (MD5)
const crypto = require('crypto');
const hash = crypto.createHash('md5').update(password).digest('hex');
```

**수정 방안:**
```javascript
// ✅ Strong hashing (bcrypt)
const bcrypt = require('bcrypt');
const saltRounds = 10;
const hash = await bcrypt.hash(password, saltRounds);
```

## 설정

`.skillconfig.json`:
```json
{
  "codeSecurityAudit": {
    "checkHardcodedSecrets": true,
    "checkWeakCrypto": true,
    "excludePatterns": ["**/test/**"]
  }
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
