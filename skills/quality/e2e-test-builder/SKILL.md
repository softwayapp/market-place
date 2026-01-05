---
name: e2e-test-builder
description: Build end-to-end test scenarios with Playwright or Cypress
version: 1.2.0
author: QA Team <qa@company.com>
category: quality
tags: [e2e, playwright, cypress, integration, testing]
status: stable
allowed-tools: [Write, Read]
triggers:
  - "E2E 테스트"
  - "통합 테스트 시나리오"
  - "end to end test"
  - "create e2e test"
  - "playwright test"
dependencies: []
---

# E2E Test Builder

## 목적

사용자 시나리오를 기반으로 종단 간(E2E) 테스트를 자동으로 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 사용자 플로우 테스트 (로그인, 회원가입 등)
- 다중 페이지 시나리오
- 실제 브라우저 동작 테스트

### ❌ 이 스킬을 사용하지 않을 때

- 단위 테스트 (test-generator 사용)
- API 테스트만 필요한 경우

## 작동 방식

1. **시나리오 정의**: 사용자 플로우 분석
2. **테스트 생성**: Playwright/Cypress 스크립트
3. **Assertion 추가**: 예상 결과 검증
4. **스크린샷**: 실패 시 자동 캡처

## 예제

### 예제 1: 로그인 플로우 (Playwright)

**생성되는 테스트:**
```typescript
// e2e/login.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Login Flow', () => {
  test('should login successfully with valid credentials', async ({ page }) => {
    await page.goto('https://example.com/login');

    // Fill login form
    await page.fill('input[name="email"]', 'user@example.com');
    await page.fill('input[name="password"]', 'password123');

    // Submit form
    await page.click('button[type="submit"]');

    // Verify redirect to dashboard
    await expect(page).toHaveURL(/.*dashboard/);

    // Verify user is logged in
    await expect(page.locator('.user-name')).toContainText('Welcome');
  });

  test('should show error with invalid credentials', async ({ page }) => {
    await page.goto('https://example.com/login');

    await page.fill('input[name="email"]', 'invalid@example.com');
    await page.fill('input[name="password"]', 'wrongpassword');
    await page.click('button[type="submit"]');

    // Verify error message
    await expect(page.locator('.error-message')).toBeVisible();
    await expect(page.locator('.error-message')).toContainText('Invalid credentials');
  });
});
```

### 예제 2: 쇼핑 플로우 (Cypress)

```javascript
// cypress/e2e/shopping.cy.js
describe('Shopping Flow', () => {
  beforeEach(() => {
    cy.visit('/products');
  });

  it('should add product to cart and checkout', () => {
    // Add product to cart
    cy.get('[data-testid="product-1"]').click();
    cy.get('[data-testid="add-to-cart"]').click();

    // Verify cart count
    cy.get('[data-testid="cart-count"]').should('contain', '1');

    // Go to cart
    cy.get('[data-testid="cart-icon"]').click();
    cy.url().should('include', '/cart');

    // Verify product in cart
    cy.get('[data-testid="cart-item"]').should('have.length', 1);

    // Proceed to checkout
    cy.get('[data-testid="checkout-button"]').click();
    cy.url().should('include', '/checkout');

    // Fill checkout form
    cy.get('input[name="address"]').type('123 Main St');
    cy.get('input[name="card"]').type('4242424242424242');

    // Complete order
    cy.get('[data-testid="complete-order"]').click();

    // Verify success
    cy.get('.order-success').should('be.visible');
  });
});
```

## 설정

`.skillconfig.json`:
```json
{
  "e2eTestBuilder": {
    "framework": "playwright",
    "headless": true,
    "screenshotOnFailure": true,
    "videoRecording": true
  }
}
```

## 의존성

```json
{
  "@playwright/test": "^1.40.0",
  "cypress": "^13.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
