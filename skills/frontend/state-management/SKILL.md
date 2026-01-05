---
name: state-management
description: Implement state management patterns with React Context, Zustand, or Redux Toolkit
version: 1.0.0
author: Frontend Team <frontend@company.com>
category: frontend
tags: [state, redux, zustand, context, react-query]
status: stable
allowed-tools: [Write, Read, Edit]
triggers:
  - "상태 관리"
  - "전역 상태"
  - "state management"
  - "create store"
dependencies: []
---

# State Management

## 목적

전역 상태 관리 패턴을 자동으로 구현하고 보일러플레이트를 제거합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 컴포넌트 간 상태 공유가 필요할 때
- 전역 상태가 필요할 때
- Props drilling을 피하고 싶을 때

### ❌ 이 스킬을 사용하지 않을 때

- 로컬 상태만 필요한 경우
- 서버 상태 관리 (React Query 사용)

## 작동 방식

1. **Store 생성**: Zustand 또는 Context 기반
2. **Actions 정의**: 상태 변경 함수
3. **Selectors**: 최적화된 상태 선택
4. **Persistence**: 선택적 로컬스토리지 연동

## 예제

### 예제 1: Zustand Store

**사용자 입력:**
```
"유저 상태 관리 스토어 생성"
```

**생성되는 코드:**
```typescript
// stores/userStore.ts
import { create } from 'zustand';
import { persist } from 'zustand/middleware';

interface User {
  id: string;
  name: string;
  email: string;
}

interface UserState {
  user: User | null;
  isAuthenticated: boolean;
  login: (user: User) => void;
  logout: () => void;
}

export const useUserStore = create<UserState>()(
  persist(
    (set) => ({
      user: null,
      isAuthenticated: false,

      login: (user) => set({
        user,
        isAuthenticated: true
      }),

      logout: () => set({
        user: null,
        isAuthenticated: false
      }),
    }),
    {
      name: 'user-storage',
    }
  )
);
```

**사용법:**
```typescript
function Header() {
  const { user, logout } = useUserStore();

  return (
    <div>
      <p>Welcome, {user?.name}</p>
      <button onClick={logout}>Logout</button>
    </div>
  );
}
```

### 예제 2: React Context Pattern

```typescript
// contexts/ThemeContext.tsx
import React, { createContext, useContext, useState } from 'react';

type Theme = 'light' | 'dark';

interface ThemeContextType {
  theme: Theme;
  toggleTheme: () => void;
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined);

export const ThemeProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [theme, setTheme] = useState<Theme>('light');

  const toggleTheme = () => {
    setTheme(prev => prev === 'light' ? 'dark' : 'light');
  };

  return (
    <ThemeContext.Provider value={{ theme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  );
};

export const useTheme = () => {
  const context = useContext(ThemeContext);
  if (!context) {
    throw new Error('useTheme must be used within ThemeProvider');
  }
  return context;
};
```

## 설정

`.skillconfig.json`:
```json
{
  "stateManagement": {
    "library": "zustand",
    "persist": true,
    "devtools": true
  }
}
```

## 의존성

```json
{
  "zustand": "^4.0.0",
  "@reduxjs/toolkit": "^2.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
