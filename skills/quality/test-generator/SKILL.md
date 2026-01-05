---
name: test-generator
description: Automatically generate unit and integration tests with Jest, Vitest, or Mocha
version: 1.5.0
author: QA Team <qa@company.com>
category: quality
tags: [testing, jest, vitest, unit-test, integration-test]
status: stable
allowed-tools: [Read, Write, Edit]
triggers:
  - "테스트 생성"
  - "유닛 테스트"
  - "generate tests"
  - "create test"
  - "write tests"
dependencies: []
---

# Test Generator

## 목적

함수, 컴포넌트, API에 대한 단위 및 통합 테스트를 자동으로 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새로운 함수/컴포넌트에 테스트 추가
- 레거시 코드 테스트 커버리지 개선
- TDD 워크플로우 지원

### ❌ 이 스킬을 사용하지 않을 때

- E2E 테스트 (e2e-test-builder 사용)
- 복잡한 비즈니스 로직 테스트 (수동 작성 권장)

## 작동 방식

1. **코드 분석**: 함수 시그니처, Props 분석
2. **테스트 생성**: 기본 케이스, 엣지 케이스
3. **Mock 생성**: 의존성 모킹
4. **Assertion**: 예상 결과 검증

## 예제

### 예제 1: 함수 테스트

**원본 코드:**
```typescript
// utils/formatCurrency.ts
export function formatCurrency(amount: number, currency: string = 'USD'): string {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency,
  }).format(amount);
}
```

**생성되는 테스트:**
```typescript
// utils/formatCurrency.test.ts
import { formatCurrency } from './formatCurrency';

describe('formatCurrency', () => {
  it('should format USD currency correctly', () => {
    expect(formatCurrency(1234.56)).toBe('$1,234.56');
  });

  it('should handle zero amount', () => {
    expect(formatCurrency(0)).toBe('$0.00');
  });

  it('should handle negative amounts', () => {
    expect(formatCurrency(-100)).toBe('-$100.00');
  });

  it('should support different currencies', () => {
    expect(formatCurrency(1000, 'EUR')).toBe('€1,000.00');
    expect(formatCurrency(1000, 'JPY')).toBe('¥1,000');
  });
});
```

### 예제 2: React 컴포넌트 테스트

**원본 코드:**
```typescript
// components/Button.tsx
interface ButtonProps {
  children: React.ReactNode;
  onClick: () => void;
  disabled?: boolean;
}

export const Button: React.FC<ButtonProps> = ({ children, onClick, disabled }) => {
  return (
    <button onClick={onClick} disabled={disabled}>
      {children}
    </button>
  );
};
```

**생성되는 테스트:**
```typescript
// components/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders children correctly', () => {
    render(<Button onClick={() => {}}>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('calls onClick when clicked', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick}>Click</Button>);

    fireEvent.click(screen.getByText('Click'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });

  it('does not call onClick when disabled', () => {
    const handleClick = jest.fn();
    render(<Button onClick={handleClick} disabled>Click</Button>);

    fireEvent.click(screen.getByText('Click'));
    expect(handleClick).not.toHaveBeenCalled();
  });

  it('applies disabled attribute when disabled prop is true', () => {
    render(<Button onClick={() => {}} disabled>Click</Button>);
    expect(screen.getByText('Click')).toBeDisabled();
  });
});
```

## 설정

`.skillconfig.json`:
```json
{
  "testGenerator": {
    "framework": "jest",
    "generateMocks": true,
    "coverageTarget": 80,
    "includeEdgeCases": true
  }
}
```

## 의존성

```json
{
  "jest": "^29.0.0",
  "@testing-library/react": "^14.0.0",
  "@testing-library/jest-dom": "^6.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
