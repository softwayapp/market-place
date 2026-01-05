# components/molecules/

> Atoms 조합 컴포넌트 (Atomic Design Pattern - Molecules)

## 📌 목적과 역할

여러 Atom을 조합하여 특정 기능을 수행하는 UI 그룹입니다. SearchBar, FormField, Card 등 비교적 간단하지만 의미있는 기능 단위의 컴포넌트입니다.

## 📂 폴더 구조 예시

```
components/molecules/
├── index.ts              # Barrel export
├── search-bar/
│   ├── search-bar.tsx    # 메인 컴포넌트
│   ├── search-bar.variants.ts
│   ├── type.ts           # 타입 정의
│   └── index.ts         # export
├── form-field/
│   ├── form-field.tsx
│   ├── form-field.variants.ts
│   ├── type.ts
│   └── index.ts
└── card/
    ├── card.tsx
    ├── card.variants.ts
    ├── type.ts
    └── index.ts
```

## 🎯 네이밍 컨벤션

**폴더명**: 소문자 (kebab-case)
- ✅ `search-bar/`, `form-field/`, `product-card/`
- ❌ `SearchBar/`, `FormField/`, `productCard/`

**파일명**: 소문자 (컴포넌트명과 동일)
- ✅ `search-bar.tsx`, `form-field.tsx`, `card.tsx`
- ✅ `search-bar.variants.ts`, `type.ts`, `index.ts`

**컴포넌트명**: PascalCase (export 시)
- ✅ `SearchBar`, `FormField`, `Card`

**복잡한 컴포넌트**: Compound 패턴 사용
```
components/molecules/form-field/
├── form-field.tsx
├── form-field.variants.ts
├── form-field.label.tsx    # Compound sub-component
├── form-field.input.tsx    # Compound sub-component
├── form-field.error.tsx    # Compound sub-component
├── type.ts
└── index.ts
```

## 💡 코드 예제

### SearchBar Molecule

```typescript
// components/molecules/search-bar/type.ts
export interface SearchBarProps {
  onSearch: (query: string) => void;
  placeholder?: string;
  className?: string;
}

// components/molecules/search-bar/search-bar.variants.ts
export const searchBarVariants = {
  container: 'flex-row items-center gap-2',
} as const;

// components/molecules/search-bar/search-bar.tsx
import { View } from 'react-native';
import { Input, Icon } from '@/components/atoms';
import { useState } from 'react';
import { SearchBarProps } from './type';
import { searchBarVariants } from './search-bar.variants';

export function SearchBar({
  onSearch,
  placeholder = '검색...',
  className = '',
}: SearchBarProps) {
  const [query, setQuery] = useState('');

  const handleChange = (text: string) => {
    setQuery(text);
    onSearch(text);
  };

  return (
    <View className={`${searchBarVariants.container} ${className}`}>
      <Icon name="search" size={20} className="text-gray-500" />
      <Input
        value={query}
        onChangeText={handleChange}
        placeholder={placeholder}
        className="flex-1"
      />
    </View>
  );
}

// components/molecules/search-bar/index.ts
export { SearchBar } from './search-bar';
export type { SearchBarProps } from './type';
export { searchBarVariants } from './search-bar.variants';
```

### Card Molecule

```typescript
// components/molecules/card/type.ts
export interface CardProps {
  title: string;
  description?: string;
  children?: React.ReactNode;
  onPress?: () => void;
  className?: string;
}

// components/molecules/card/card.variants.ts
export const cardVariants = {
  container: 'p-4 bg-white rounded-lg shadow-sm',
} as const;

// components/molecules/card/card.tsx
import { View } from 'react-native';
import { Text } from '@/components/atoms';
import { CardProps } from './type';
import { cardVariants } from './card.variants';

export function Card({
  title,
  description,
  children,
  className = '',
}: CardProps) {
  return (
    <View className={`${cardVariants.container} ${className}`}>
      <Text variant="heading" weight="semibold" className="mb-2">
        {title}
      </Text>
      {description && (
        <Text variant="caption" className="text-textSecondary mb-3">
          {description}
        </Text>
      )}
      {children}
    </View>
  );
}

// components/molecules/card/index.ts
export { Card } from './card';
export type { CardProps } from './type';
export { cardVariants } from './card.variants';
```

## ✅ 베스트 프랙티스

1. **Atoms 재사용**: 직접 스타일링보다 Atoms 조합 우선
2. **Props 추상화**: 내부 구현 숨기고 간단한 인터페이스 제공
3. **유연성**: children prop으로 확장 가능하도록 설계

## 📚 추천 리소스

- [Atomic Design Methodology](https://atomicdesign.bradfrost.com/chapter-2/)
