# mock/

> 목 데이터 및 픽스처 디렉토리

## 📌 목적과 역할

개발 및 테스트를 위한 가짜 데이터를 관리합니다. API 모킹, 테스트 픽스처 등을 제공하여 실제 백엔드 없이 프론트엔드 개발을 진행할 수 있습니다. 함수 네이밍 및 파일 네이밍은 최대한 간결하게 작성

## 📂 폴더 구조 예시

```
mock/
├── index.ts              # Barrel export
├── users.ts              # 사용자 목 데이터
├── posts.ts              # 게시물 목 데이터
├── handlers.ts           # MSW handlers (API 모킹)
└── factories.ts          # 데이터 팩토리 함수
```

## 💡 코드 예제

```typescript
// mock/users.ts
export const mockUsers = [
  { id: '1', email: 'alice@example.com', name: 'Alice' },
  { id: '2', email: 'bob@example.com', name: 'Bob' },
];

// mock/factories.ts
export function createUser(overrides?: Partial<User>): User {
  return {
    id: Math.random().toString(36).substr(2, 9),
    email: `user@example.com`,
    name: 'Test User',
    ...overrides,
  };
}
```

## ✅ 베스트 프랙티스

1. **타입 안전성**: 실제 타입과 동일한 구조 사용
2. **현실적인 데이터**: 실제 사용 시나리오를 반영한 데이터 생성
3. **팩토리 패턴**: 동적 데이터 생성 시 팩토리 함수 활용
4. **MSW 활용**: 실제 네트워크 요청처럼 동작하는 모킹

## 📚 추천 리소스

- [MSW (Mock Service Worker)](https://mswjs.io/) - API mocking library
- [Faker.js](https://fakerjs.dev/) - 랜덤 데이터 생성
