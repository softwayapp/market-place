---
name: test
description: Run comprehensive test suite with coverage analysis and reporting
version: 1.0.0
author: QA Team <qa@company.com>
category: testing
tags: [test, testing, coverage, unit-test, integration, e2e]
status: stable
---

# /test - Comprehensive Testing

## 목적

단위 테스트, 통합 테스트, E2E 테스트를 실행하고 커버리지를 분석합니다.

## 사용법

```bash
# 전체 테스트 실행
/test

# 특정 타입 테스트
/test unit
/test integration
/test e2e

# 특정 파일/폴더 테스트
/test src/auth.test.ts
/test tests/unit/

# Watch 모드
/test --watch
/test --watch src/components/

# 커버리지 포함
/test --coverage
/test unit --coverage

# 특정 테스트만 실행
/test --grep "user authentication"
/test --only "login flow"

# 실패한 테스트만 재실행
/test --failed
```

## 테스트 결과 예시

### 전체 테스트 실행

```markdown
# Test Suite Results

Started: 2025-01-05 14:30:00
Environment: test
Framework: Jest 29.7.0

---

## 📊 Summary

```
Test Suites: 45 passed, 45 total
Tests:       342 passed, 342 total
Snapshots:   12 passed, 12 total
Time:        45.234s
```

---

## 🧪 Unit Tests

```yaml
Duration: 15.234s
Tests: 245 passed, 245 total
Coverage: 85.4%

✓ Auth Module (8.234s)
  ✓ Login
    ✓ should authenticate with valid credentials (45ms)
    ✓ should reject invalid credentials (23ms)
    ✓ should handle missing credentials (12ms)
    ✓ should return JWT token on success (34ms)
  ✓ Registration
    ✓ should create new user (67ms)
    ✓ should validate email format (15ms)
    ✓ should hash password (42ms)
    ✓ should reject duplicate email (28ms)

✓ User Service (4.123s)
  ✓ CRUD Operations
    ✓ should create user (123ms)
    ✓ should read user (45ms)
    ✓ should update user (89ms)
    ✓ should delete user (56ms)
  ✓ Validation
    ✓ should validate user data (23ms)
    ✓ should sanitize input (18ms)

✓ Product Service (3.567s)
  ✓ should list products (89ms)
  ✓ should filter by category (102ms)
  ✓ should sort by price (78ms)
  ✓ should paginate results (65ms)
```

---

## 🔗 Integration Tests

```yaml
Duration: 18.456s
Tests: 78 passed, 78 total
Coverage: 72.3%

✓ API Endpoints (12.345s)
  ✓ GET /api/users
    ✓ should return all users (234ms)
    ✓ should paginate results (189ms)
    ✓ should filter by role (156ms)
    ✓ should require authentication (98ms)

  ✓ POST /api/users
    ✓ should create user (345ms)
    ✓ should validate input (123ms)
    ✓ should return 409 on duplicate (167ms)

  ✓ PUT /api/users/:id
    ✓ should update user (289ms)
    ✓ should require authorization (134ms)
    ✓ should return 404 for invalid ID (112ms)

✓ Database Integration (6.111s)
  ✓ Transactions
    ✓ should commit on success (456ms)
    ✓ should rollback on error (389ms)
  ✓ Relationships
    ✓ should load associations (234ms)
    ✓ should cascade delete (312ms)
```

---

## 🌐 E2E Tests

```yaml
Duration: 11.544s
Tests: 19 passed, 19 total
Browser: Chromium 120.0

✓ User Flows (8.234s)
  ✓ Login Flow
    ✓ should display login page (1.234s)
    ✓ should login with valid credentials (2.345s)
    ✓ should show error with invalid credentials (1.567s)
    ✓ should redirect after login (1.123s)

  ✓ Shopping Flow
    ✓ should browse products (2.456s)
    ✓ should add to cart (1.789s)
    ✓ should proceed to checkout (2.123s)
    ✓ should complete order (3.456s)

✓ Admin Flows (3.310s)
  ✓ Dashboard
    ✓ should load admin dashboard (1.234s)
    ✓ should display metrics (0.987s)
  ✓ User Management
    ✓ should list users (0.654s)
    ✓ should create user (0.435s)
```

---

## 📈 Coverage Report

```
----------------------------|---------|----------|---------|---------|
File                        | % Stmts | % Branch | % Funcs | % Lines |
----------------------------|---------|----------|---------|---------|
All files                   |   85.42 |    78.34 |   89.67 |   84.91 |
----------------------------|---------|----------|---------|---------|
 src/                       |         |          |         |         |
  auth/                     |         |          |         |         |
   auth.service.ts          |     100 |      100 |     100 |     100 | ✅
   jwt.service.ts           |   96.15 |    91.67 |     100 |   95.83 | ✅
  users/                    |         |          |         |         |
   users.service.ts         |   92.31 |    85.71 |     100 |   91.67 | ✅
   users.controller.ts      |   88.89 |    80.00 |     100 |   88.24 | ✅
  products/                 |         |          |         |         |
   products.service.ts      |   75.00 |    66.67 |   83.33 |   73.91 | 🟡
   products.controller.ts   |   70.59 |    62.50 |   80.00 |   69.57 | 🟡
  orders/                   |         |          |         |         |
   orders.service.ts        |   65.38 |    58.33 |   75.00 |   64.29 | 🟡
   orders.controller.ts     |   58.82 |    50.00 |   66.67 |   57.89 | ⚠️
----------------------------|---------|----------|---------|---------|
```

### Coverage Insights

**🟢 Well Covered (>80%)**
- Auth module: 98.5%
- User module: 90.2%

**🟡 Needs Improvement (60-80%)**
- Product module: 72.8%
- Payment module: 68.4%

**🔴 Critical Gap (<60%)**
- Order module: 57.9%
  - Missing tests:
    - Order cancellation flow
    - Refund processing
    - Edge cases for inventory

---

## 🎯 Test Quality Metrics

```yaml
Mutation Score: 78.5%
  - Killed: 314
  - Survived: 86
  - No Coverage: 12

Flakiness Score: 2.1%
  - Stable: 335
  - Flaky: 7

Performance:
  - Fastest: 12ms (auth validation)
  - Slowest: 3.456s (complete order E2E)
  - Average: 132ms
```

---

## ⚠️ Failed Tests

No failed tests! 🎉

---

## 💡 Recommendations

### Immediate Actions
1. **Increase Order Module Coverage**
   - Add tests for cancellation flow
   - Cover refund edge cases
   - Target: 80% coverage

2. **Fix Flaky Tests**
   - `E2E: Product Search` (flaky: 15%)
   - `Integration: Payment Processing` (flaky: 8%)

3. **Performance Optimization**
   - Reduce E2E test duration (11s → 8s)
   - Parallelize unit tests

### Long-term Improvements
4. **Mutation Testing**
   - Increase mutation score to 85%
   - Focus on critical business logic

5. **Visual Regression**
   - Add snapshot tests for UI components
   - Implement Percy/Chromatic integration

---

Generated: 2025-01-05 14:30:45
Duration: 45.234s
Status: ✅ All tests passed
```

## 테스트 타입별 상세

### Unit Tests
```yaml
Purpose: 개별 함수/모듈 테스트
Framework: Jest, Vitest
Coverage Target: >80%

Characteristics:
  - Fast (<100ms per test)
  - Isolated (no external dependencies)
  - Mocked dependencies
  - High code coverage

Example:
  ✓ calculateTotal() should sum prices correctly
  ✓ validateEmail() should reject invalid formats
  ✓ hashPassword() should generate bcrypt hash
```

### Integration Tests
```yaml
Purpose: 모듈 간 상호작용 테스트
Framework: Jest + Supertest
Coverage Target: >70%

Characteristics:
  - Medium speed (100ms-1s)
  - Real database (test DB)
  - API endpoints
  - Business logic flows

Example:
  ✓ POST /api/orders creates order and updates inventory
  ✓ User deletion cascades to related records
  ✓ Transaction rollback on payment failure
```

### E2E Tests
```yaml
Purpose: 전체 사용자 플로우 테스트
Framework: Playwright, Cypress
Coverage Target: Critical flows

Characteristics:
  - Slow (1-5s per test)
  - Real browser
  - Full stack integration
  - User perspective

Example:
  ✓ User can complete purchase flow
  ✓ Admin can manage inventory
  ✓ Password reset email workflow
```

## 커버리지 기준

### 권장 커버리지 목표
```yaml
Minimum Acceptable:
  - Statements: 70%
  - Branches: 65%
  - Functions: 75%
  - Lines: 70%

Good:
  - Statements: 80%
  - Branches: 75%
  - Functions: 85%
  - Lines: 80%

Excellent:
  - Statements: 90%
  - Branches: 85%
  - Functions: 95%
  - Lines: 90%
```

### 커버리지 우선순위
```yaml
Critical (Must be 100%):
  - Authentication logic
  - Payment processing
  - Data validation
  - Security checks

High Priority (Target: >90%):
  - Business logic
  - API endpoints
  - Data transformations

Medium Priority (Target: >80%):
  - Utilities
  - Helpers
  - Formatters

Low Priority (Target: >60%):
  - UI components
  - Constants
  - Types
```

## CI/CD 통합

### GitHub Actions
```yaml
name: Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: 20

      - name: Install dependencies
        run: npm ci

      - name: Run tests
        run: npm test -- --coverage

      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          files: ./coverage/lcov.info

      - name: Check coverage threshold
        run: |
          COVERAGE=$(cat coverage/coverage-summary.json | jq '.total.lines.pct')
          if (( $(echo "$COVERAGE < 80" | bc -l) )); then
            echo "Coverage $COVERAGE% is below 80%"
            exit 1
          fi
```

## 테스트 모범 사례

### ✅ Good Practices
```typescript
// ✅ 명확한 테스트 이름
test('should return user when valid ID provided', () => {});

// ✅ AAA 패턴 (Arrange, Act, Assert)
test('user creation', () => {
  // Arrange
  const userData = { name: 'John', email: 'john@example.com' };

  // Act
  const user = createUser(userData);

  // Assert
  expect(user.name).toBe('John');
});

// ✅ 독립적인 테스트
beforeEach(() => {
  // 각 테스트마다 깨끗한 상태
  resetDatabase();
});
```

### ❌ Anti-patterns
```typescript
// ❌ 모호한 테스트 이름
test('test1', () => {});

// ❌ 여러 개념 테스트
test('everything', () => {
  // login, create user, update, delete 모두 테스트
});

// ❌ 테스트 간 의존성
test('create user', () => { userId = createUser(); });
test('update user', () => { updateUser(userId); }); // 이전 테스트 의존
```

## 옵션

| 옵션 | 설명 | 기본값 |
|------|------|--------|
| `--coverage` | 커버리지 리포트 생성 | `false` |
| `--watch` | Watch 모드로 실행 | `false` |
| `--grep` | 특정 테스트 필터링 | - |
| `--failed` | 실패한 테스트만 재실행 | `false` |
| `--parallel` | 병렬 실행 | `true` |
| `--verbose` | 상세 출력 | `false` |

## 설정

`jest.config.js`:
```javascript
module.exports = {
  coverageThreshold: {
    global: {
      statements: 80,
      branches: 75,
      functions: 85,
      lines: 80
    }
  },
  collectCoverageFrom: [
    'src/**/*.{js,ts}',
    '!src/**/*.test.{js,ts}',
    '!src/**/index.{js,ts}'
  ]
};
```

## 통합 도구

- **Jest**: JavaScript 테스팅 프레임워크
- **Vitest**: Vite 기반 테스팅
- **Playwright**: 브라우저 자동화
- **Cypress**: E2E 테스팅
- **Codecov**: 커버리지 추적

## 라이선스

MIT License - 조직 내부 사용 전용
