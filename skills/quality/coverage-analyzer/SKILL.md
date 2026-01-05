---
name: coverage-analyzer
description: Analyze test coverage and identify untested code paths with visualization
version: 1.1.0
author: QA Team <qa@company.com>
category: quality
tags: [coverage, testing, analysis, istanbul, c8]
status: stable
allowed-tools: [Bash, Read, Grep]
triggers:
  - "커버리지 분석"
  - "테스트 커버리지"
  - "coverage analysis"
  - "analyze coverage"
  - "code coverage"
dependencies: []
---

# Coverage Analyzer

## 목적

테스트 커버리지를 분석하고 테스트되지 않은 코드 경로를 식별합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- CI/CD 파이프라인에서 커버리지 검증
- 테스트 부족 영역 식별
- 커버리지 리포트 생성

### ❌ 이 스킬을 사용하지 않을 때

- 테스트가 없는 프로젝트
- 커버리지 도구가 설정되지 않은 경우

## 작동 방식

1. **테스트 실행**: --coverage 플래그로 실행
2. **데이터 수집**: Istanbul/c8로 커버리지 수집
3. **분석**: 커버리지 미달 파일 식별
4. **리포트**: HTML, JSON, 텍스트 리포트

## 예제

### 예제 1: Jest 커버리지

**실행:**
```bash
npm test -- --coverage
```

**결과:**
```
--------------------|---------|----------|---------|---------|
File                | % Stmts | % Branch | % Funcs | % Lines |
--------------------|---------|----------|---------|---------|
All files           |   78.23 |    65.45 |   80.12 |   77.89 |
 src/               |         |          |         |         |
  api.ts            |     100 |      100 |     100 |     100 |
  auth.ts           |   85.71 |    66.67 |     100 |   85.71 |
  utils.ts          |   45.45 |    33.33 |      50 |   44.44 | ⚠️
 src/components     |         |          |         |         |
  Button.tsx        |     100 |      100 |     100 |     100 |
  Modal.tsx         |   60.00 |    50.00 |   66.67 |   58.33 | ⚠️
--------------------|---------|----------|---------|---------|
```

### 예제 2: 커버리지 리포트

**생성되는 분석:**
```markdown
# Coverage Analysis Report

## Summary
- **Total Coverage**: 78.23%
- **Target**: 80%
- **Status**: ⚠️ Below Target

## Files Needing Attention

### 🔴 Critical (< 50%)
- `src/utils.ts` - 44.44%
  - Uncovered lines: 15-23, 45-52
  - Missing tests for edge cases

### 🟡 Warning (50-80%)
- `src/components/Modal.tsx` - 58.33%
  - Uncovered branches: close button callback
  - Missing tests for keyboard events

- `src/auth.ts` - 66.67%
  - Uncovered branches: token refresh logic

## Recommendations
1. Add tests for `utils.ts` error handling
2. Test Modal keyboard interactions
3. Cover token refresh edge cases
```

### 예제 3: CI/CD 통합

```yaml
# .github/workflows/test.yml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Run tests with coverage
        run: npm test -- --coverage
      - name: Check coverage threshold
        run: |
          if [ $(grep -oP '(?<=All files.*\|.*)\d+' coverage/lcov-report/index.html) -lt 80 ]; then
            echo "Coverage below 80%"
            exit 1
          fi
```

## 설정

`.skillconfig.json`:
```json
{
  "coverageAnalyzer": {
    "threshold": {
      "statements": 80,
      "branches": 75,
      "functions": 80,
      "lines": 80
    },
    "reportFormat": ["html", "json", "text"],
    "excludePatterns": ["**/*.test.ts", "**/mocks/**"]
  }
}
```

## 의존성

```json
{
  "jest": "^29.0.0",
  "c8": "^8.0.0",
  "istanbul": "^0.4.5"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
