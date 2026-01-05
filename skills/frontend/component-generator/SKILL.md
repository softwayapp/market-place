---
name: component-generator
description: Generate React/Vue components with TypeScript, styled-components, and storybook integration
version: 2.0.0
author: Frontend Team <frontend@company.com>
category: frontend
tags: [react, vue, component, typescript, storybook]
status: stable
allowed-tools: [Write, Read, Edit]
triggers:
  - "컴포넌트 생성"
  - "리액트 컴포넌트"
  - "create component"
  - "generate react component"
  - "new component"
dependencies: []
---

# Component Generator

## 목적

React 또는 Nextjs, Expo 컴포넌트를 TypeScript, 스타일, 테스트, 자동생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새로운 UI 컴포넌트가 필요할 때
- Atomic Design 패턴을 따르는 컴포넌트 생성
- 컴포넌트 보일러플레이트 자동화

### ❌ 이 스킬을 사용하지 않을 때

- 백엔드 API 컴포넌트
- Native Mobile 컴포넌트 (React Native 제외)

## 작동 방식

1. **컴포넌트 타입 결정**: Atom, Molecule, Organism, Template
2. **파일 생성**: Component, Styles, Test, Story
3. **타입 정의**: Props interface 자동 생성
4. **Export 추가**: index.ts에 자동 추가

## 예제

### 예제 1: React Button 컴포넌트

**사용자 입력:**
```
"Button 컴포넌트 생성"
```

**생성되는 파일:**

`components/atoms/Button/Button.tsx`:
```typescript
import React from 'react';
import styled from 'styled-components';

export interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  onClick?: () => void;
}

const StyledButton = styled.button<ButtonProps>`
  padding: ${props =>
    props.size === 'small' ? '8px 16px' :
    props.size === 'large' ? '16px 32px' :
    '12px 24px'
  };
  background-color: ${props =>
    props.variant === 'primary' ? '#007AFF' :
    props.variant === 'secondary' ? '#5856D6' :
    'transparent'
  };
  color: ${props => props.variant === 'outline' ? '#007AFF' : '#fff'};
  border: ${props => props.variant === 'outline' ? '2px solid #007AFF' : 'none'};
  border-radius: 8px;
  cursor: ${props => props.disabled ? 'not-allowed' : 'pointer'};
  opacity: ${props => props.disabled ? 0.6 : 1};

  &:hover:not(:disabled) {
    opacity: 0.8;
  }
`;

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  ...props
}) => {
  return (
    <StyledButton variant={variant} size={size} {...props}>
      {children}
    </StyledButton>
  );
};
```

`components/atoms/Button/Button.stories.tsx`:
```typescript
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  title: 'Atoms/Button',
  component: Button,
  tags: ['autodocs'],
};

export default meta;
type Story = StoryObj<typeof Button>;

export const Primary: Story = {
  args: {
    children: 'Button',
    variant: 'primary',
  },
};

export const Secondary: Story = {
  args: {
    children: 'Button',
    variant: 'secondary',
  },
};
```

`components/atoms/Button/Button.test.tsx`:
```typescript
import { render, screen } from '@testing-library/react';
import { Button } from './Button';

describe('Button', () => {
  it('renders children correctly', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('applies correct variant class', () => {
    render(<Button variant="secondary">Button</Button>);
    const button = screen.getByText('Button');
    expect(button).toHaveStyle({ backgroundColor: '#5856D6' });
  });
});
```

## 설정

`.skillconfig.json`:
```json
{
  "componentGenerator": {
    "framework": "react",
    "typescript": true,
    "styling": "styled-components",
    "generateTests": true,
    "generateStories": true
  }
}
```

## 의존성

```json
{
  "react": "^18.0.0",
  "styled-components": "^6.0.0",
  "@storybook/react": "^7.0.0",
  "@testing-library/react": "^14.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
