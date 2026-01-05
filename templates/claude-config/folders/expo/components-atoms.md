# components/atoms/

> 기본 UI 요소 (Atomic Design Pattern - Atoms)

## 📌 목적과 역할

더 이상 분해할 수 없는 가장 작은 UI 요소입니다. Button, Input, Text, Icon 등 단일 기능의 컴포넌트로, 애플리케이션 전체에서 재사용됩니다.

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
├── button.content.tsx    # Compound sub-component
├── type.ts
└── index.ts
```

## 💡 코드 예제 (NativeWind)

### Button Atom

```typescript
// components/atoms/button/type.ts
export interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  loading?: boolean;
  onPress?: () => void;
  children: React.ReactNode;
  className?: string;
}

// components/atoms/button/button.variants.ts
import { ButtonProps } from './type';

export const buttonVariants = {
  variant: {
    primary: 'bg-primary',
    secondary: 'bg-secondary',
    outline: 'bg-transparent border-2 border-primary',
  },
  size: {
    sm: 'px-3 py-2',
    md: 'px-4 py-3',
    lg: 'px-6 py-4',
  },
} as const;

export function getButtonClasses(
  variant: ButtonProps['variant'] = 'primary',
  size: ButtonProps['size'] = 'md',
  disabled?: boolean
) {
  const baseClass = 'rounded-lg items-center justify-center flex-row';
  const variantClass = buttonVariants.variant[variant || 'primary'];
  const sizeClass = buttonVariants.size[size || 'md'];
  const disabledClass = disabled ? 'opacity-50' : '';
  
  return `${baseClass} ${variantClass} ${sizeClass} ${disabledClass}`;
}

// components/atoms/button/button.tsx
import { TouchableOpacity, Text, ActivityIndicator } from 'react-native';
import { ButtonProps } from './type';
import { getButtonClasses } from './button.variants';

export function Button({
  variant = 'primary',
  size = 'md',
  disabled = false,
  loading = false,
  onPress,
  children,
  className = '',
}: ButtonProps) {
  const classes = getButtonClasses(variant, size, disabled);

  return (
    <TouchableOpacity
      className={`${classes} ${className}`}
      onPress={onPress}
      disabled={disabled || loading}
      activeOpacity={0.7}
    >
      {loading ? (
        <ActivityIndicator color="#fff" />
      ) : (
        <Text className="text-white font-pretendard-medium">{children}</Text>
      )}
    </TouchableOpacity>
  );
}

// components/atoms/button/index.ts
export { Button } from './button';
export type { ButtonProps } from './type';
export { buttonVariants, getButtonClasses } from './button.variants';
```

### Input Atom

```typescript
// components/atoms/input/type.ts
export interface InputProps {
  value: string;
  onChangeText: (text: string) => void;
  placeholder?: string;
  error?: string;
  label?: string;
  className?: string;
}

// components/atoms/input/input.variants.ts
import { InputProps } from './type';

export function getInputClasses(error?: string) {
  const baseClass = 'px-4 py-3 border rounded-lg font-pretendard';
  const errorClass = error ? 'border-danger' : 'border-gray-300';
  return `${baseClass} ${errorClass}`;
}

// components/atoms/input/input.tsx
import { View, TextInput, Text } from 'react-native';
import { InputProps } from './type';
import { getInputClasses } from './input.variants';

export function Input({
  value,
  onChangeText,
  placeholder,
  error,
  label,
  className = '',
}: InputProps) {
  return (
    <View className={`w-full ${className}`}>
      {label && (
        <Text className="mb-2 text-sm font-pretendard-medium text-text">
          {label}
        </Text>
      )}
      <TextInput
        className={getInputClasses(error)}
        value={value}
        onChangeText={onChangeText}
        placeholder={placeholder}
        placeholderTextColor="#8E8E93"
      />
      {error && (
        <Text className="mt-1 text-xs text-danger">{error}</Text>
      )}
    </View>
  );
}

// components/atoms/input/index.ts
export { Input } from './input';
export type { InputProps } from './type';
export { getInputClasses } from './input.variants';
```

### Text Atom

```typescript
// components/atoms/text/type.ts
import { TextProps as RNTextProps } from 'react-native';

export interface TextProps extends RNTextProps {
  variant?: 'body' | 'caption' | 'heading';
  weight?: 'regular' | 'medium' | 'semibold' | 'bold';
  className?: string;
}

// components/atoms/text/text.variants.ts
import { TextProps } from './type';

export const textVariants = {
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
} as const;

export function getTextClasses(
  variant: TextProps['variant'] = 'body',
  weight: TextProps['weight'] = 'regular'
) {
  const variantClass = textVariants.variant[variant || 'body'];
  const weightClass = textVariants.weight[weight || 'regular'];
  return `${variantClass} ${weightClass}`;
}

// components/atoms/text/text.tsx
import { Text as RNText } from 'react-native';
import { TextProps } from './type';
import { getTextClasses } from './text.variants';

export function Text({
  variant = 'body',
  weight = 'regular',
  className = '',
  children,
  ...props
}: TextProps) {
  const classes = getTextClasses(variant, weight);

  return (
    <RNText
      className={`${classes} ${className}`}
      {...props}
    >
      {children}
    </RNText>
  );
}

// components/atoms/text/index.ts
export { Text } from './text';
export type { TextProps } from './type';
export { textVariants, getTextClasses } from './text.variants';
```

## ✅ 베스트 프랙티스

1. **단일 책임**: 하나의 Atom은 하나의 기능만 수행
2. **Props 인터페이스**: TypeScript로 명확한 타입 정의
3. **NativeWind 활용**: className으로 Tailwind 스타일 적용
4. **Accessibility**: 접근성 고려 (accessibilityLabel, accessibilityRole)
5. **재사용성**: 다양한 상황에서 사용 가능하도록 유연하게 설계
6. **Variants 분리**: 스타일 variants는 별도 파일로 관리 (`*.variants.ts`)
7. **타입 분리**: 타입 정의는 `type.ts`로 분리하여 재사용성 향상
8. **Compound 패턴**: 복잡한 컴포넌트는 Compound 패턴으로 sub-components 분리

## 🚫 안티 패턴

```typescript
// ❌ Bad: 너무 많은 로직 (Atom이 아님)
function Button() {
  const [loading, setLoading] = useState(false);
  const handleLogin = async () => { /* API call */ };
  // ... 비즈니스 로직
}

// ✅ Good: 순수한 UI 컴포넌트
function Button({ onPress, loading }: ButtonProps) {
  return <TouchableOpacity onPress={onPress}>...</TouchableOpacity>;
}

// ❌ Bad: 하드코딩된 스타일
<View style={{ backgroundColor: '#007AFF', padding: 16 }} />

// ✅ Good: NativeWind className 사용
<View className="bg-primary p-4" />

// ❌ Bad: 모든 코드를 한 파일에
// button.tsx에 variants, types 모두 포함

// ✅ Good: 파일 분리
// button.tsx, button.variants.ts, type.ts, index.ts

// ❌ Bad: 복잡한 컴포넌트를 하나의 파일에
function ComplexButton() {
  return (
    <>
      <ButtonTrigger />
      <ButtonContent />
      <ButtonIcon />
    </>
  );
}

// ✅ Good: Compound 패턴으로 분리
// button.tsx, button.trigger.tsx, button.content.tsx, button.icon.tsx
```

## 📚 추천 리소스

- [NativeWind](https://www.nativewind.dev/) - Tailwind for React Native
- [Atomic Design](https://bradfrost.com/blog/post/atomic-web-design/)
