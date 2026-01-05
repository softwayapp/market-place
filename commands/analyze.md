---
name: analyze
description: Comprehensive code quality analysis with actionable insights
version: 1.0.0
author: Quality Team <quality@company.com>
category: analysis
tags: [analysis, code-quality, linting, complexity, maintainability]
status: stable
---

# /analyze - Code Quality Analysis

## 목적

코드베이스의 품질을 종합적으로 분석하고, 개선 가능한 영역을 식별합니다.

## 사용법

```bash
# 전체 프로젝트 분석
/analyze

# 특정 파일 분석
/analyze src/app.ts

# 특정 디렉토리 분석
/analyze src/components/

# 특정 범위 분석
/analyze --scope [file|module|project]

# 특정 영역에 집중
/analyze --focus performance
/analyze --focus security
/analyze --focus maintainability
```

## 분석 항목

### 1. 코드 복잡도 (Complexity)
- **Cyclomatic Complexity**: 코드 경로 복잡도
- **Cognitive Complexity**: 인지적 복잡도
- **Nesting Depth**: 중첩 깊이
- **Function Length**: 함수 길이

### 2. 코드 품질 (Quality)
- **Code Smells**: 잠재적 문제 패턴
- **Duplications**: 중복 코드 탐지
- **Dead Code**: 사용되지 않는 코드
- **Magic Numbers**: 하드코딩된 값

### 3. 유지보수성 (Maintainability)
- **Technical Debt**: 기술 부채 추정
- **Maintainability Index**: 유지보수 지수
- **Documentation Coverage**: 문서화 수준
- **Test Coverage**: 테스트 커버리지

### 4. 보안 (Security)
- **Vulnerabilities**: 보안 취약점
- **Code Injection Risks**: 코드 주입 위험
- **Hardcoded Secrets**: 하드코딩된 비밀번호
- **Dependency Vulnerabilities**: 의존성 취약점

### 5. 성능 (Performance)
- **Performance Anti-patterns**: 성능 안티패턴
- **Memory Leaks**: 메모리 누수 가능성
- **Inefficient Algorithms**: 비효율적 알고리즘
- **N+1 Queries**: 데이터베이스 쿼리 최적화

## 출력 예시

### 전체 프로젝트 분석

```markdown
# Code Quality Analysis Report

Generated: 2025-01-05 10:30:00
Scope: project
Files Analyzed: 156

---

## 📊 Overall Score: 72/100

```yaml
Category Scores:
  Code Quality:        78/100 🟢
  Maintainability:     68/100 🟡
  Security:            81/100 🟢
  Performance:         65/100 🟡
  Test Coverage:       70/100 🟡
```

---

## 🔴 Critical Issues (3)

### 1. High Cyclomatic Complexity
**File**: `src/utils/validation.ts:45`
**Function**: `validateUserInput`
**Complexity**: 23 (threshold: 10)

```typescript
// src/utils/validation.ts:45
function validateUserInput(input) {
  if (input.type === 'email') {
    if (input.value.includes('@')) {
      if (input.value.split('@')[1].includes('.')) {
        if (input.value.length > 5) {
          if (input.value.length < 100) {
            // ... 더 많은 중첩 ...
```

**Recommendation**:
```typescript
// ✅ 개선: Early returns + 함수 분해
function validateUserInput(input: UserInput): ValidationResult {
  if (input.type !== 'email') {
    return validateNonEmail(input);
  }

  return validateEmail(input.value);
}

function validateEmail(email: string): ValidationResult {
  if (!email.includes('@')) {
    return { valid: false, error: 'Missing @' };
  }

  const [, domain] = email.split('@');
  if (!domain?.includes('.')) {
    return { valid: false, error: 'Invalid domain' };
  }

  if (email.length < 5 || email.length > 100) {
    return { valid: false, error: 'Invalid length' };
  }

  return { valid: true };
}
```

**Impact**: High
**Effort**: Medium
**Priority**: 1

---

### 2. Code Duplication
**Locations**:
- `src/api/users.controller.ts:20-45` (26 lines)
- `src/api/products.controller.ts:15-40` (26 lines)
- `src/api/orders.controller.ts:18-43` (26 lines)

```typescript
// 중복된 코드 패턴
async function getItems(req, res) {
  try {
    const items = await Model.findAll();
    res.json({ success: true, data: items });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, error: error.message });
  }
}
```

**Recommendation**:
```typescript
// ✅ 개선: 공통 핸들러 추출
function asyncHandler(fn) {
  return async (req, res, next) => {
    try {
      const result = await fn(req, res, next);
      res.json({ success: true, data: result });
    } catch (error) {
      console.error(error);
      res.status(500).json({ success: false, error: error.message });
    }
  };
}

// 사용
app.get('/users', asyncHandler(async (req) => {
  return await User.findAll();
}));
```

**Impact**: Medium
**Effort**: Low
**Priority**: 2

---

### 3. Hardcoded Configuration
**File**: `src/config/app.ts:10`

```typescript
// ❌ 하드코딩된 설정
const config = {
  apiUrl: 'https://api.example.com',
  timeout: 5000,
  maxRetries: 3
};
```

**Recommendation**:
```typescript
// ✅ 환경 변수 사용
const config = {
  apiUrl: process.env.API_URL || 'https://api.example.com',
  timeout: parseInt(process.env.API_TIMEOUT || '5000'),
  maxRetries: parseInt(process.env.API_MAX_RETRIES || '3')
};
```

**Impact**: Medium
**Effort**: Low
**Priority**: 3

---

## 🟡 Warnings (12)

### Code Smells (5)
- Long Parameter List: `src/services/userService.ts:34` (8 parameters)
- Large Class: `src/models/User.ts` (450 lines)
- Switch Statements: `src/utils/formatter.ts:12` (12 cases)
- Primitive Obsession: `src/types/` (using strings for types)
- Feature Envy: `src/controllers/orderController.ts:45`

### Performance Issues (4)
- N+1 Query: `src/api/users.ts:23`
- Inefficient Loop: `src/utils/processor.ts:67`
- Unnecessary Re-renders: `src/components/UserList.tsx:15`
- Memory Leak Risk: `src/services/eventEmitter.ts:89`

### Maintainability (3)
- Missing JSDoc: 45 functions without documentation
- Magic Numbers: 23 occurrences
- TODO Comments: 12 unresolved todos

---

## 🟢 Good Practices (89)

- ✅ Type Safety: 95% TypeScript coverage
- ✅ Error Handling: Consistent error patterns
- ✅ Naming Conventions: Clear and descriptive names
- ✅ Module Organization: Well-structured directories
- ✅ Git Practices: Meaningful commit messages

---

## 📈 Metrics Summary

```yaml
Code Metrics:
  Total Lines: 15,234
  Code Lines: 11,456
  Comment Lines: 1,892 (12.4%)
  Blank Lines: 1,886

Complexity:
  Average Complexity: 5.2
  Max Complexity: 23 (threshold: 10)
  Functions > 10: 12 (8%)

Duplication:
  Duplicate Blocks: 8
  Duplicate Lines: 156 (1.4%)

Test Coverage:
  Statements: 70.5%
  Branches: 65.2%
  Functions: 75.8%
  Lines: 69.3%
```

---

## 🎯 Actionable Recommendations

### Immediate (This Week)
1. ⚡ **Reduce complexity in `validateUserInput`**
   - Break into smaller functions
   - Use early returns
   - Extract validation logic

2. 🔄 **Extract duplicate code patterns**
   - Create `asyncHandler` utility
   - Reuse across controllers
   - Reduce code by ~150 lines

3. 🔧 **Move hardcoded config to env vars**
   - Create `.env.example`
   - Update documentation
   - Improve deployment flexibility

**Expected Impact**: +8 points (72 → 80)

### Short Term (This Month)
4. 📚 **Add JSDoc to public APIs**
   - Document 45 undocumented functions
   - Improve code comprehension
   - Enable better IDE support

5. 🧪 **Increase test coverage**
   - Target: 80% coverage
   - Focus on critical paths
   - Add edge case tests

**Expected Impact**: +10 points (80 → 90)

### Long Term (This Quarter)
6. 🏗️ **Refactor large classes**
   - Break `User` model into smaller modules
   - Apply Single Responsibility Principle
   - Improve maintainability

7. ⚡ **Optimize N+1 queries**
   - Add eager loading
   - Implement caching
   - Reduce DB load

**Expected Impact**: +5 points (90 → 95)

---

## 🔗 Related Commands

- `/test` - Run test suite with coverage
- `/security-scan` - Deep security analysis
- `/refactor` - Apply automated refactoring

---

## 📊 Trend Analysis

```
Score History (Last 30 Days):
Jan 05: 72 ▓▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░
Dec 29: 68 ▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░
Dec 22: 65 ▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░
Dec 15: 70 ▓▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░

Trend: ↗️ Improving (+2 points in 7 days)
```

---

Generated by Claude Code Marketplace - internal-marketplace v1.0.0
```

## 옵션

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `--scope` | 분석 범위 (file, module, project, system) | `project` |
| `--focus` | 집중 분야 (performance, security, quality, architecture) | `all` |
| `--threshold` | 복잡도 임계값 | `10` |
| `--format` | 출력 형식 (markdown, json, html) | `markdown` |
| `--output` | 리포트 저장 경로 | `./analysis-report.md` |
| `--fix` | 자동 수정 가능한 문제 즉시 수정 | `false` |

## 설정

`.skillconfig.json`:
```json
{
  "analyze": {
    "complexityThreshold": 10,
    "duplicationThreshold": 3,
    "coverageThreshold": 80,
    "includeTests": true,
    "excludePatterns": ["**/node_modules/**", "**/*.test.ts"]
  }
}
```

## 통합 도구

- **ESLint**: JavaScript/TypeScript 린팅
- **SonarQube**: 코드 품질 플랫폼
- **CodeClimate**: 자동화된 코드 리뷰
- **Semgrep**: 정적 분석 도구

## 라이선스

MIT License - 조직 내부 사용 전용
