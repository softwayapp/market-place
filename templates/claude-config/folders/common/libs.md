# libs/

> 외부 라이브러리 설정 및 래퍼 디렉토리

## 📌 목적과 역할

외부 라이브러리의 초기화, 설정, 래퍼 함수를 관리합니다. 라이브러리 의존성을 캡슐화하여 변경 시 영향 범위를 최소화하고, 프로젝트에 맞게 커스터마이징합니다. 함수 네이밍 및 파일 네이밍은 최대한 간결하게 작성

## 📂 폴더 구조 예시

```
libs/
├── index.ts              # Barrel export
├── api.ts                # API client (axios, fetch)
├── storage.ts            # Storage wrapper (localStorage, AsyncStorage)
├── analytics.ts          # Analytics (GA, Mixpanel)
├── auth.ts               # Auth provider (Firebase, Supabase)
└── logger.ts             # Logger (winston, pino)
```

## 🎯 네이밍 컨벤션

**파일명**: `[라이브러리명].ts` (camelCase)
- ✅ `api.ts`, `analytics.ts`, `storage.ts`
- ❌ `apiLib.ts`, `Api.ts`, `api-library.ts`

**함수명**: 동사 + 명사 (camelCase)
- ✅ `createApiClient()`, `initAnalytics()`, `logEvent()`
- ❌ `ApiClient()`, `analytics_init()`, `LOG_EVENT()`

## 💡 코드 예제와 사용 패턴

### 1. API Client (Axios Wrapper)

```typescript
// libs/api.ts
import axios from 'axios';

const api = axios.create({
  baseURL: process.env.NEXT_PUBLIC_API_URL,
  timeout: 10000,
});

export { api };
```

### 2. Storage Wrapper

```typescript
// libs/storage.ts
export const storage = {
  async get<T>(key: string): Promise<T | null> {
    const value = localStorage.getItem(key);
    return value ? JSON.parse(value) : null;
  },
  async set<T>(key: string, value: T): Promise<void> {
    localStorage.setItem(key, JSON.stringify(value));
  },
};
```

## ✅ 베스트 프랙티스

1. **의존성 캡슐화**: 외부 라이브러리 변경 시 영향 최소화
2. **싱글톤 패턴**: 하나의 인스턴스만 유지하여 일관성 확보
3. **타입 안전성**: TypeScript 제네릭으로 타입 추론
4. **에러 처리**: 라이브러리 에러를 적절히 처리하고 전파
5. **환경별 설정**: dev/prod 환경에 따라 다른 설정 적용

## 📚 추천 리소스

- [Axios](https://axios-http.com/) - HTTP client
- [Winston](https://github.com/winstonjs/winston) - Logging library
