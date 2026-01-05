# components/atoms/

> 기본 UI 요소 (Atomic Design Pattern - Atoms)

## 📌 목적과 역할

더 이상 분해할 수 없는 가장 작은 UI 요소입니다. Button, Input, Text 등 단일 기능의 컴포넌트로, 애플리케이션 전체에서 재사용됩니다.

## 📂 폴더 구조 예시

```
components/atoms/
├── index.ts              # Barrel export
├── button/
│   ├── button.tsx        # 메인 컴포넌트
│   ├── button.variants.ts # variants 정의
│   ├── type.ts           # 타입 정의
│   └── index.ts          # export
├── input/
│   ├── input.tsx
│   ├── input.variants.ts
│   ├── type.ts
│   └── index.ts
├── text/
│   ├── text.tsx
│   ├── text.variants.ts
│   ├── type.ts
│   └── index.ts
└── icon/
    ├── icon.tsx
    ├── icon.variants.ts
    ├── type.ts
    └── index.ts
```

## 🎯 네이밍 컨벤션

**폴더명**: 소문자 (kebab-case)
- ✅ `button/`, `input/`, `text-field/`
- ❌ `Button/`, `Input/`, `textField/`

**파일명**: 소문자 (컴포넌트명과 동일)
- ✅ `button.tsx`, `input.tsx`, `text.tsx`
- ✅ `button.variants.ts`, `type.ts`, `index.ts`
- ❌ `Button.tsx`, `button.component.tsx`

**컴포넌트명**: PascalCase (export 시)
- ✅ `Button`, `Input`, `Text`
- ❌ `button`, `ButtonComp`, `btn`

**복잡한 컴포넌트**: Compound 패턴 사용
```
components/atoms/button/
├── button.tsx
├── button.variants.ts
├── button.trigger.tsx    # Compound sub-component
├── button.content.tsx   # Compound sub-component
├── type.ts
└── index.ts
```

## 💡 코드 예제 (Next.js + Tailwind)

### Button Atom

```typescript
// components/atoms/button/type.ts
import { ButtonHTMLAttributes } from 'react';

export interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
}

// components/atoms/button/button.variants.ts
import { ButtonProps } from './type';
import { cva, type VariantProps } from 'class-variance-authority';

export const buttonVariants = cva(
  'rounded-lg font-pretendard-medium transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2',
  {
    variants: {
      variant: {
        primary: 'bg-primary text-white hover:bg-primary/90 focus:ring-primary',
        secondary: 'bg-secondary text-white hover:bg-secondary/90 focus:ring-secondary',
        outline: 'bg-transparent border-2 border-primary text-primary hover:bg-primary/10 focus:ring-primary',
      },
      size: {
        sm: 'px-3 py-2 text-sm',
        md: 'px-4 py-3 text-base',
        lg: 'px-6 py-4 text-lg',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  }
);

export type ButtonVariants = VariantProps<typeof buttonVariants>;

// components/atoms/button/button.tsx
import { ButtonProps } from './type';
import { buttonVariants } from './button.variants';
import { cn } from '@/lib/utils';

export function Button({
  variant = 'primary',
  size = 'md',
  className = '',
  children,
  ...props
}: ButtonProps) {
  return (
    <button
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    >
      {children}
    </button>
  );
}

// components/atoms/button/index.ts
export { Button } from './button';
export type { ButtonProps } from './type';
export { buttonVariants, type ButtonVariants } from './button.variants';
```

### Input Atom

```typescript
// components/atoms/input/type.ts
import { InputHTMLAttributes } from 'react';

export interface InputProps extends InputHTMLAttributes<HTMLInputElement> {
  label?: string;
  error?: string;
}

// components/atoms/input/input.variants.ts
import { cva } from 'class-variance-authority';

export const inputVariants = cva(
  'px-4 py-3 border rounded-lg font-pretendard transition-colors focus:outline-none focus:ring-2',
  {
    variants: {
      error: {
        true: 'border-danger focus:ring-danger',
        false: 'border-gray-300 focus:ring-primary',
      },
    },
    defaultVariants: {
      error: false,
    },
  }
);

// components/atoms/input/input.tsx
import { InputProps } from './type';
import { inputVariants } from './input.variants';
import { cn } from '@/lib/utils';

export function Input({
  label,
  error,
  className = '',
  ...props
}: InputProps) {
  return (
    <div className="w-full">
      {label && (
        <label className="block mb-2 text-sm font-pretendard-medium text-gray-700">
          {label}
        </label>
      )}
      <input
        className={cn(inputVariants({ error: !!error }), className)}
        {...props}
      />
      {error && (
        <p className="mt-1 text-xs text-danger">{error}</p>
      )}
    </div>
  );
}

// components/atoms/input/index.ts
export { Input } from './input';
export type { InputProps } from './type';
export { inputVariants } from './input.variants';
```

### Text Atom

```typescript
// components/atoms/text/type.ts
import { HTMLAttributes } from 'react';

export interface TextProps extends HTMLAttributes<HTMLParagraphElement> {
  variant?: 'body' | 'caption' | 'heading';
  weight?: 'regular' | 'medium' | 'semibold' | 'bold';
}

// components/atoms/text/text.variants.ts
import { cva } from 'class-variance-authority';

export const textVariants = cva('', {
  variants: {
    variant: {
      body: 'text-base',
      caption: 'text-xs',
      heading: 'text-2xl',
    },
    weight: {
      regular: 'font-pretendard',
      medium: 'font-pretendard-medium',
      semibold: 'font-pretendard-semibold',
      bold: 'font-pretendard-bold',
    },
  },
  defaultVariants: {
    variant: 'body',
    weight: 'regular',
  },
});

// components/atoms/text/text.tsx
import { TextProps } from './type';
import { textVariants } from './text.variants';
import { cn } from '@/lib/utils';

export function Text({
  variant = 'body',
  weight = 'regular',
  className = '',
  children,
  ...props
}: TextProps) {
  return (
    <p
      className={cn(textVariants({ variant, weight }), className)}
      {...props}
    >
      {children}
    </p>
  );
}

// components/atoms/text/index.ts
export { Text } from './text';
export type { TextProps } from './type';
export { textVariants } from './text.variants';
```

## ✅ 베스트 프랙티스

1. **HTML 속성 확장**: extends HTMLAttributes로 네이티브 props 상속
2. **Tailwind 활용**: className으로 유틸리티 클래스 조합
3. **접근성**: label, aria-* 속성 활용
4. **Variants 분리**: 스타일 variants는 별도 파일로 관리 (`*.variants.ts`)
5. **타입 분리**: 타입 정의는 `type.ts`로 분리하여 재사용성 향상
6. **CVA 활용**: `class-variance-authority`로 variants 관리
7. **Compound 패턴**: 복잡한 컴포넌트는 Compound 패턴으로 sub-components 분리

## 📚 추천 리소스

- [Tailwind CSS](https://tailwindcss.com/)
