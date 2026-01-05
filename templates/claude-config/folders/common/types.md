# types/

> TypeScript 타입 정의 디렉토리

## 📌 목적과 역할

프로젝트 전역에서 사용되는 TypeScript 타입, 인터페이스, Enum을 관리합니다. API 응답 타입, 도메인 모델, 유틸리티 타입 등을 정의하여 타입 안전성을 확보합니다. 함수 네이밍 및 파일 네이밍은 최대한 간결하게 작성

## 📂 폴더 구조 예시

```
types/
├── index.ts              # Barrel export
├── api.ts                # API 요청/응답 타입
├── models.ts             # 도메인 모델 타입
├── common.ts             # 공통 유틸리티 타입
├── enums.ts              # Enum 정의
└── guards.ts             # Type Guard 함수
```

## 🎯 네이밍 컨벤션

**타입명**: PascalCase
- ✅ `User`, `ApiResponse`, `UserRole`
- ❌ `user`, `api_response`, `USER_ROLE`

**인터페이스명**: `I` 접두사 없이 PascalCase
- ✅ `User`, `Props`, `Config`
- ❌ `IUser`, `iProps`, `UserInterface`

**Enum명**: PascalCase (단수형)
- ✅ `UserRole`, `Status`, `Color`
- ❌ `UserRoles`, `STATUSES`, `colors`

## 💡 코드 예제와 사용 패턴

### 1. 도메인 모델 타입

```typescript
// types/models.ts
export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  role: UserRole;
  createdAt: Date;
  updatedAt: Date;
}

export interface Post {
  id: string;
  title: string;
  content: string;
  author: User;
  tags: string[];
  published: boolean;
  createdAt: Date;
}

export interface Comment {
  id: string;
  postId: string;
  userId: string;
  content: string;
  createdAt: Date;
}
```

### 2. API 타입

```typescript
// types/api.ts
export interface ApiResponse<T> {
  data: T;
  message: string;
  status: number;
}

export interface ApiError {
  error: string;
  message: string;
  statusCode: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
  };
}

// 요청 타입
export interface LoginRequest {
  email: string;
  password: string;
}

export interface CreatePostRequest {
  title: string;
  content: string;
  tags?: string[];
}

// 응답 타입
export type LoginResponse = ApiResponse<{
  user: User;
  token: string;
}>;

export type PostListResponse = PaginatedResponse<Post>;
```

### 3. Enum 정의

```typescript
// types/enums.ts
export enum UserRole {
  Admin = 'ADMIN',
  User = 'USER',
  Guest = 'GUEST',
}

export enum PostStatus {
  Draft = 'DRAFT',
  Published = 'PUBLISHED',
  Archived = 'ARCHIVED',
}

export enum HttpMethod {
  GET = 'GET',
  POST = 'POST',
  PUT = 'PUT',
  PATCH = 'PATCH',
  DELETE = 'DELETE',
}
```

**사용법**:
```typescript
import { UserRole, PostStatus } from '@/types';

const user: User = {
  id: '1',
  role: UserRole.Admin, // Type-safe
};

function publishPost(status: PostStatus) {
  if (status === PostStatus.Published) {
    // ...
  }
}
```

### 4. 유틸리티 타입

```typescript
// types/common.ts
// Nullable 타입
export type Nullable<T> = T | null;

// Optional fields 타입
export type Optional<T, K extends keyof T> = Omit<T, K> & Partial<Pick<T, K>>;

// DeepPartial 타입
export type DeepPartial<T> = {
  [P in keyof T]?: T[P] extends object ? DeepPartial<T[P]> : T[P];
};

// ValueOf 타입 (객체의 값 타입)
export type ValueOf<T> = T[keyof T];

// NonEmptyArray 타입
export type NonEmptyArray<T> = [T, ...T[]];

// 함수 타입
export type AsyncFunction<T = void> = (...args: any[]) => Promise<T>;
export type VoidFunction = () => void;
```

**사용법**:
```typescript
import { Nullable, Optional, DeepPartial } from '@/types';

// Nullable 사용
const userName: Nullable<string> = null;

// Optional 사용 - email은 선택적
type UserWithOptionalEmail = Optional<User, 'email'>;

// DeepPartial 사용 - 모든 필드가 선택적
const partialConfig: DeepPartial<Config> = {
  api: {
    timeout: 5000, // endpoint는 생략 가능
  },
};
```

### 5. Type Guard

```typescript
// types/guards.ts
export function isUser(value: any): value is User {
  return (
    typeof value === 'object' &&
    value !== null &&
    'id' in value &&
    'email' in value &&
    'role' in value
  );
}

export function isApiError(error: any): error is ApiError {
  return (
    typeof error === 'object' &&
    error !== null &&
    'error' in error &&
    'statusCode' in error
  );
}

export function isNonEmpty<T>(array: T[]): array is NonEmptyArray<T> {
  return array.length > 0;
}
```

**사용법**:
```typescript
import { isUser, isApiError } from '@/types';

function handleData(data: unknown) {
  if (isUser(data)) {
    console.log(data.email); // Type-safe
  }
}

async function fetchUser() {
  try {
    const response = await api.getUser();
    return response.data;
  } catch (error) {
    if (isApiError(error)) {
      console.error(error.message); // Type-safe
    }
  }
}
```

### 6. 컴포넌트 Props 타입

```typescript
// types/components.ts
export interface BaseProps {
  className?: string;
  style?: React.CSSProperties;
  children?: React.ReactNode;
}

export interface ButtonProps extends BaseProps {
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'sm' | 'md' | 'lg';
  disabled?: boolean;
  onClick?: () => void;
}

export interface InputProps extends BaseProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  error?: string;
}
```

## ✅ 베스트 프랙티스

1. **명확한 네이밍**: 타입명만 봐도 용도를 알 수 있도록
2. **단일 책임**: 하나의 파일은 관련된 타입만 관리
3. **재사용성**: 공통 타입은 유틸리티 타입으로 추상화
4. **문서화**: JSDoc으로 복잡한 타입 설명
5. **Barrel Export**: index.ts로 깔끔한 import 제공

## 🚫 안티 패턴

```typescript
// ❌ Bad: any 남용
function process(data: any): any {
  return data;
}

// ✅ Good: 제네릭 활용
function process<T>(data: T): T {
  return data;
}

// ❌ Bad: 중복된 타입 정의
interface UserA {
  id: string;
  name: string;
}
interface UserB {
  id: string;
  name: string;
}

// ✅ Good: 공통 타입 재사용
interface BaseUser {
  id: string;
  name: string;
}
type UserA = BaseUser & { roleA: string };
type UserB = BaseUser & { roleB: string };

// ❌ Bad: 너무 넓은 타입
interface Props {
  data: object; // 너무 광범위
}

// ✅ Good: 구체적인 타입
interface Props {
  data: {
    id: string;
    name: string;
  };
}
```

## 📚 추천 리소스

- [TypeScript Handbook](https://www.typescriptlang.org/docs/handbook/intro.html)
- [Type Challenges](https://github.com/type-challenges/type-challenges) - 타입 연습
- [Utility Types](https://www.typescriptlang.org/docs/handbook/utility-types.html)
