# {{PROJECT_NAME}}

> Next.js 프로젝트 - Atomic Design Pattern + Tailwind CSS

## 📊 프로젝트 정보

- **Framework**: Next.js {{NEXTJS_VERSION}}
- **언어**: TypeScript
- **스타일링**: Tailwind CSS
- **디자인 패턴**: Atomic Design Pattern
- **상태 관리**: Zustand (추천)

## 📂 프로젝트 구조

```
{{PROJECT_NAME}}/
├── app/                  # Next.js App Router
├── pages/                # Pages Router (선택적)
├── components/           # Atomic Design 컴포넌트
│   ├── atoms/           # 기본 UI 요소 (Button, Input)
│   ├── molecules/       # atoms 조합 (SearchBar, Card)
│   ├── organisms/       # molecules 조합 (Header, Form)
│   └── templates/       # 페이지 레이아웃
├── hooks/               # 커스텀 React 훅
├── utils/               # 유틸리티 함수
├── types/               # TypeScript 타입 정의
├── schema/              # Zod validation schemas
├── libs/                # 외부 라이브러리 래퍼
├── stores/              # 전역 상태 관리
├── styles/              # Tailwind CSS 전역 스타일
├── constants/           # 앱 상수 (colors, spacing, theme)
├── mock/                # 목 데이터 및 fixtures
└── public/
    └── fonts/           # Pretendard 폰트 파일
```

## 🚀 시작하기

### 개발 서버 실행

```bash
# 의존성 설치
npm install

# 개발 서버 시작
npm run dev

# 프로덕션 빌드
npm run build

# 프로덕션 서버 실행
npm start
```

### 린트 및 타입 체크

```bash
# ESLint
npm run lint

# TypeScript 타입 체크
npm run type-check
```

## 🎨 스타일링 가이드 (Tailwind CSS)

### 기본 사용법

```typescript
export function MyComponent() {
  return (
    <div className="flex flex-col bg-primary p-4">
      <h1 className="text-white font-pretendard-bold text-2xl">
        Hello World
      </h1>
    </div>
  );
}
```

### 커스텀 색상 사용

```typescript
// tailwind.config.ts에 정의된 색상 사용
<div className="bg-primary" />
<span className="text-secondary" />
<div className="border-danger" />
```

### 폰트 사용

```typescript
<p className="font-pretendard">Regular</p>
<p className="font-pretendard-medium">Medium</p>
<p className="font-pretendard-semibold">SemiBold</p>
<p className="font-pretendard-bold">Bold</p>
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
   interface ButtonProps extends ButtonHTMLAttributes<HTMLButtonElement> {
     variant?: 'primary' | 'secondary';
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

### API 라우트

```typescript
// app/api/users/route.ts
import { NextResponse } from 'next/server';

export async function GET() {
  const users = await fetchUsers();
  return NextResponse.json({ data: users });
}

export async function POST(request: Request) {
  const body = await request.json();
  const newUser = await createUser(body);
  return NextResponse.json({ data: newUser }, { status: 201 });
}
```

## 🧪 테스트

```bash
# 단위 테스트 (Jest + React Testing Library)
npm test

# E2E 테스트 (Playwright)
npm run test:e2e
```

## 📦 주요 라이브러리

- **next**: Next.js 프레임워크
- **tailwindcss**: Tailwind CSS
- **zustand**: 상태 관리
- **zod**: 스키마 검증
- **react-hook-form**: 폼 관리

## 📚 추가 리소스

- [Next.js Documentation](https://nextjs.org/docs)
- [Tailwind CSS Documentation](https://tailwindcss.com/)
- [React Documentation](https://react.dev/)
- [Atomic Design Methodology](https://atomicdesign.bradfrost.com/)

## 💡 각 폴더의 역할

각 폴더에는 `CLAUDE.md` 파일이 있습니다. 폴더 내에서 역할, 네이밍 컨벤션, 코드 예제, 베스트 프랙티스를 확인할 수 있습니다.

```bash
# 예: hooks 폴더의 가이드 확인
cat hooks/CLAUDE.md
```
