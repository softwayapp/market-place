# {{PROJECT_NAME}}

> Expo (React Native) 프로젝트 - Atomic Design Pattern + NativeWind

## 📊 프로젝트 정보

- **Framework**: Expo SDK {{EXPO_VERSION}}
- **언어**: TypeScript
- **스타일링**: NativeWind (Tailwind CSS for React Native)
- **디자인 패턴**: Atomic Design Pattern
- **상태 관리**: Zustand (추천)

## 📂 프로젝트 구조

```
{{PROJECT_NAME}}/
├── app/                  # Expo Router 앱 디렉토리
├── components/           # Atomic Design 컴포넌트
│   ├── atoms/           # 기본 UI 요소 (Button, Input, Text)
│   ├── molecules/       # atoms 조합 (SearchBar, Card)
│   ├── organisms/       # molecules 조합 (Header, Form)
│   └── templates/       # 페이지 레이아웃
├── hooks/               # 커스텀 React 훅
├── utils/               # 유틸리티 함수
├── types/               # TypeScript 타입 정의
├── schema/              # Zod validation schemas
├── libs/                # 외부 라이브러리 래퍼
├── stores/              # 전역 상태 관리
├── styles/              # NativeWind 전역 스타일
├── constants/           # 앱 상수 (colors, spacing, theme)
├── mock/                # 목 데이터 및 fixtures
└── assets/
    └── fonts/           # Pretendard 폰트 파일
```

## 🚀 시작하기

### 개발 서버 실행

```bash
# 의존성 설치
npm install

# 개발 서버 시작
npx expo start

# iOS 시뮬레이터
npx expo start --ios

# Android 에뮬레이터
npx expo start --android

# 웹 브라우저
npx expo start --web
```

### 빌드

```bash
# EAS Build (클라우드 빌드)
eas build --platform ios
eas build --platform android

# 로컬 빌드
npx expo run:ios
npx expo run:android
```

## 🎨 스타일링 가이드 (NativeWind)

### 기본 사용법

```typescript
import { View, Text } from 'react-native';

function MyComponent() {
  return (
    <View className="flex-1 bg-primary p-4">
      <Text className="text-white font-pretendard-bold text-2xl">
        Hello World
      </Text>
    </View>
  );
}
```

### 커스텀 색상 사용

```typescript
// tailwind.config.js에 정의된 색상 사용
<View className="bg-primary" />
<Text className="text-secondary" />
<View className="border-danger" />
```

### 폰트 사용

```typescript
<Text className="font-pretendard">Regular</Text>
<Text className="font-pretendard-medium">Medium</Text>
<Text className="font-pretendard-semibold">SemiBold</Text>
<Text className="font-pretendard-bold">Bold</Text>
```

## 📝 개발 가이드라인

### 컴포넌트 작성

1. **Atomic Design 패턴 준수**
   - Atoms: 재사용 가능한 기본 UI 요소
   - Molecules: Atoms 조합
   - Organisms: Molecules 조합
   - Templates: 페이지 레이아웃

2. **파일 구조**
   ```
   components/atoms/Button/
   ├── Button.tsx
   └── index.ts
   ```

3. **TypeScript 타입 정의**
   ```typescript
   interface ButtonProps {
     variant?: 'primary' | 'secondary';
     onPress?: () => void;
     children: React.ReactNode;
   }
   ```

### 상태 관리 (Zustand)

```typescript
// stores/authStore.ts
import { create } from 'zustand';

interface AuthState {
  user: User | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  login: async (email, password) => {
    // ... login logic
  },
  logout: () => set({ user: null }),
}));
```

### API 호출

```typescript
// libs/api.ts 사용
import { api } from '@/libs';

const users = await api.get<User[]>('/users');
const newUser = await api.post<User>('/users', userData);
```

## 🧪 테스트

```bash
# 단위 테스트
npm test

# E2E 테스트 (Detox)
npx detox test
```

## 📦 주요 라이브러리

- **expo**: Expo SDK
- **nativewind**: Tailwind CSS for React Native
- **zustand**: 상태 관리
- **zod**: 스키마 검증
- **react-hook-form**: 폼 관리

## 📚 추가 리소스

- [Expo Documentation](https://docs.expo.dev/)
- [NativeWind Documentation](https://www.nativewind.dev/)
- [React Native Documentation](https://reactnative.dev/)
- [Atomic Design Methodology](https://atomicdesign.bradfrost.com/)

## 💡 각 폴더의 역할

각 폴더에는 `CLAUDE.md` 파일이 있습니다. 폴더 내에서 역할, 네이밍 컨벤션, 코드 예제, 베스트 프랙티스를 확인할 수 있습니다.

```bash
# 예: hooks 폴더의 가이드 확인
cat hooks/CLAUDE.md
```
