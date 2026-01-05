# components/organisms/

> Molecules 조합 컴포넌트 (Atomic Design Pattern - Organisms)

## 📌 목적과 역할

여러 Molecule과 Atom을 조합하여 페이지의 주요 섹션을 구성합니다. Header, Footer, Navigation 등 독립적으로 동작하는 복잡한 UI 단위입니다.

## 📂 폴더 구조 예시

```
components/organisms/
├── index.ts              # Barrel export
├── header/
│   ├── header.tsx        # 메인 컴포넌트
│   ├── header.variants.ts
│   ├── type.ts           # 타입 정의
│   └── index.ts         # export
├── user-form/
│   ├── user-form.tsx
│   ├── user-form.variants.ts
│   ├── type.ts
│   └── index.ts
└── product-list/
    ├── product-list.tsx
    ├── product-list.variants.ts
    ├── type.ts
    └── index.ts
```

## 🎯 네이밍 컨벤션

**폴더명**: 소문자 (kebab-case)
- ✅ `header/`, `user-form/`, `product-list/`
- ❌ `Header/`, `UserForm/`, `productList/`

**파일명**: 소문자 (컴포넌트명과 동일)
- ✅ `header.tsx`, `user-form.tsx`, `product-list.tsx`
- ✅ `header.variants.ts`, `type.ts`, `index.ts`

**컴포넌트명**: PascalCase (export 시)
- ✅ `Header`, `UserForm`, `ProductList`

**복잡한 컴포넌트**: Compound 패턴 사용
```
components/organisms/user-form/
├── user-form.tsx
├── user-form.variants.ts
├── user-form.field.tsx    # Compound sub-component
├── user-form.submit.tsx   # Compound sub-component
├── type.ts
└── index.ts
```

## 💡 코드 예제

### Header Organism

```typescript
// components/organisms/header/type.ts
export interface HeaderProps {
  title: string;
  onSearch?: (query: string) => void;
  onLogout?: () => void;
  className?: string;
}

// components/organisms/header/header.variants.ts
import { cva } from 'class-variance-authority';

export const headerVariants = cva(
  'px-4 py-3 bg-white border-b border-gray-200'
);

// components/organisms/header/header.tsx
import { Text, Button } from '@/components/atoms';
import { SearchBar } from '@/components/molecules';
import { HeaderProps } from './type';
import { headerVariants } from './header.variants';
import { cn } from '@/lib/utils';

export function Header({
  title,
  onSearch,
  onLogout,
  className = '',
}: HeaderProps) {
  return (
    <header className={cn(headerVariants(), className)}>
      <div className="flex items-center justify-between mb-3">
        <Text variant="heading" weight="bold">{title}</Text>
        {onLogout && (
          <Button variant="outline" size="sm" onClick={onLogout}>
            Logout
          </Button>
        )}
      </div>
      {onSearch && <SearchBar onSearch={onSearch} />}
    </header>
  );
}

// components/organisms/header/index.ts
export { Header } from './header';
export type { HeaderProps } from './type';
export { headerVariants } from './header.variants';
```

## ✅ 베스트 프랙티스

1. **비즈니스 로직 분리**: UI 렌더링과 로직 분리 (hooks 활용)
2. **컴포넌트 조합**: Atoms/Molecules 재사용
3. **Variants 분리**: 스타일 variants는 별도 파일로 관리
4. **타입 분리**: 타입 정의는 `type.ts`로 분리
5. **Compound 패턴**: 복잡한 컴포넌트는 Compound 패턴으로 분리
