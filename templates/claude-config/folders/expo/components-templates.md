# components/templates/

> 페이지 레이아웃 템플릿 (Atomic Design Pattern - Templates)

## 📌 목적과 역할

Organisms를 배치하여 페이지의 전체 레이아웃을 정의합니다. 실제 콘텐츠 없이 구조만 제공하며, 여러 페이지에서 재사용 가능한 레이아웃 템플릿입니다.

## 📂 폴더 구조 예시

```
components/templates/
├── index.ts              # Barrel export
├── main-layout/
│   ├── main-layout.tsx   # 메인 컴포넌트
│   ├── main-layout.variants.ts
│   ├── type.ts           # 타입 정의
│   └── index.ts         # export
└── auth-layout/
    ├── auth-layout.tsx
    ├── auth-layout.variants.ts
    ├── type.ts
    └── index.ts
```

## 🎯 네이밍 컨벤션

**폴더명**: 소문자 (kebab-case)
- ✅ `main-layout/`, `auth-layout/`, `dashboard-layout/`
- ❌ `MainLayout/`, `AuthLayout/`, `dashboardLayout/`

**파일명**: 소문자 (컴포넌트명과 동일)
- ✅ `main-layout.tsx`, `auth-layout.tsx`
- ✅ `main-layout.variants.ts`, `type.ts`, `index.ts`

**컴포넌트명**: PascalCase (export 시)
- ✅ `MainLayout`, `AuthLayout`

**복잡한 레이아웃**: Compound 패턴 사용
```
components/templates/main-layout/
├── main-layout.tsx
├── main-layout.variants.ts
├── main-layout.header.tsx    # Compound sub-component
├── main-layout.sidebar.tsx   # Compound sub-component
├── main-layout.content.tsx   # Compound sub-component
├── type.ts
└── index.ts
```

## 💡 코드 예제

### MainLayout Template

```typescript
// components/templates/main-layout/type.ts
export interface MainLayoutProps {
  children: React.ReactNode;
  showHeader?: boolean;
  headerTitle?: string;
  className?: string;
}

// components/templates/main-layout/main-layout.variants.ts
export const mainLayoutVariants = {
  container: 'flex-1 bg-background',
  content: 'flex-1 px-4 py-3',
} as const;

// components/templates/main-layout/main-layout.tsx
import { View, ScrollView } from 'react-native';
import { Header } from '@/components/organisms';
import { MainLayoutProps } from './type';
import { mainLayoutVariants } from './main-layout.variants';

export function MainLayout({
  children,
  showHeader = true,
  headerTitle = 'App',
  className = '',
}: MainLayoutProps) {
  return (
    <View className={`${mainLayoutVariants.container} ${className}`}>
      {showHeader && <Header title={headerTitle} />}
      <ScrollView className={mainLayoutVariants.content}>
        {children}
      </ScrollView>
    </View>
  );
}

// components/templates/main-layout/index.ts
export { MainLayout } from './main-layout';
export type { MainLayoutProps } from './type';
export { mainLayoutVariants } from './main-layout.variants';
```

## ✅ 베스트 프랙티스

1. **구조 정의**: 콘텐츠가 아닌 구조에 집중
2. **재사용성**: 여러 페이지에서 사용 가능한 범용 레이아웃
3. **유연성**: children prop으로 콘텐츠 주입
