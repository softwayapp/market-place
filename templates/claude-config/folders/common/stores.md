# stores/

> 전역 상태 관리 디렉토리

## 📌 목적과 역할

애플리케이션의 전역 상태를 관리합니다. Zustand, Redux, Jotai 등을 사용하여 컴포넌트 간 상태 공유, 비동기 상태 관리, 상태 지속성을 제공합니다. 함수 네이밍 및 파일 네이밍은 최대한 간결하게 작성

## 📂 폴더 구조 예시

```
stores/
├── index.ts              # Barrel export
├── authStore.ts          # 인증 상태
├── userStore.ts          # 사용자 데이터
├── uiStore.ts            # UI 상태 (모달, 토스트 등)
└── cartStore.ts          # 장바구니 상태
```

## 🎯 네이밍 컨벤션

**파일명**: `[도메인]Store.ts` (camelCase + Store 접미사)
- ✅ `authStore.ts`, `userStore.ts`, `cartStore.ts`
- ❌ `auth.ts`, `AuthStore.ts`, `auth-store.ts`

**Store명**: `use[도메인]Store` (camelCase + use 접두사 + Store 접미사)
- ✅ `useAuthStore`, `useUserStore`, `useCartStore`
- ❌ `authStore`, `useAuth`, `AuthStore`

## 💡 코드 예제와 사용 패턴 (Zustand)

### 1. 기본 Store

```typescript
// stores/authStore.ts
import { create } from 'zustand';

interface AuthState {
  user: User | null;
  token: string | null;
  login: (email: string, password: string) => Promise<void>;
  logout: () => void;
}

export const useAuthStore = create<AuthState>((set) => ({
  user: null,
  token: null,
  login: async (email, password) => {
    const { user, token } = await loginAPI(email, password);
    set({ user, token });
  },
  logout: () => set({ user: null, token: null }),
}));
```

**사용법**:
```typescript
import { useAuthStore } from '@/stores';

function LoginButton() {
  const { login } = useAuthStore();
  return <button onClick={() => login('user@example.com', 'password')}>Login</button>;
}
```

## ✅ 베스트 프랙티스

1. **단일 책임**: 각 Store는 하나의 도메인만 관리
2. **선택적 구독**: 필요한 상태만 구독하여 리렌더링 최적화
3. **DevTools**: 개발 시 Redux DevTools로 상태 디버깅
4. **Persistence**: 필요 시 localStorage/AsyncStorage 연동

## 📚 추천 리소스

- [Zustand](https://zustand-demo.pmnd.rs/) - Simple state management
- [Redux Toolkit](https://redux-toolkit.js.org/) - Redux 공식 툴킷
- [Jotai](https://jotai.org/) - Atomic state management
