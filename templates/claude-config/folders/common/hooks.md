# hooks/

> Custom React Hooks 디렉토리

## 📌 목적과 역할

재사용 가능한 로직을 캡슐화한 커스텀 React 훅을 관리합니다. React Query를 활용한 서버 상태 관리(queries, mutations)와 클라이언트 상태 로직을 분리하여 관리합니다.

## 📂 폴더 구조

```
hooks/
├── index.ts              # Barrel export
├── queries/              # React Query - 데이터 조회 (GET)
│   ├── index.ts
│   ├── useUsers.ts       # 사용자 목록 조회
│   ├── useUser.ts        # 단일 사용자 조회
│   └── usePosts.ts       # 게시물 목록 조회
├── mutations/            # React Query - 데이터 변경 (POST, PUT, DELETE)
│   ├── index.ts
│   ├── useCreateUser.ts  # 사용자 생성
│   ├── useUpdateUser.ts  # 사용자 수정
│   └── useDeleteUser.ts  # 사용자 삭제
└── useDebounce.ts        # 일반 유틸리티 훅 (루트에 배치)
```

## 🎯 네이밍 컨벤션

**Queries (데이터 조회)**:
- 파일명: `use[엔티티명].ts` 또는 `use[엔티티명]s.ts`
- ✅ `useUsers.ts`, `useUser.ts`, `usePosts.ts`
- ❌ `getUsersQuery.ts`, `users.ts`, `UserQuery.ts`

**Mutations (데이터 변경)**:
- 파일명: `use[액션][엔티티명].ts`
- ✅ `useCreateUser.ts`, `useUpdatePost.ts`, `useDeleteComment.ts`
- ❌ `createUserMutation.ts`, `update-user.ts`, `DeleteUser.ts`

**일반 훅**:
- 파일명: `use[기능명].ts`
- ✅ `useDebounce.ts`, `useLocalStorage.ts`, `useIntersection.ts`

## 💡 코드 예제와 사용 패턴

### 1. Query Hook (데이터 조회)

```typescript
// hooks/queries/useUsers.ts
import { useQuery } from '@tanstack/react-query';
import { api } from '@/libs';
import { User } from '@/types';

export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => api.get<User[]>('/users'),
  });
}

// 단일 사용자 조회 (파라미터 있는 경우)
// hooks/queries/useUser.ts
export function useUser(userId: string) {
  return useQuery({
    queryKey: ['users', userId],
    queryFn: () => api.get<User>(`/users/${userId}`),
    enabled: !!userId, // userId가 있을 때만 쿼리 실행
  });
}
```

**사용법**:
```typescript
import { useUsers, useUser } from '@/hooks/queries';

function UserList() {
  const { data: users, isLoading, error } = useUsers();

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <ul>
      {users?.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

function UserProfile({ userId }: { userId: string }) {
  const { data: user } = useUser(userId);
  return <div>{user?.name}</div>;
}
```

### 2. Mutation Hook (데이터 변경)

```typescript
// hooks/mutations/useCreateUser.ts
import { useMutation, useQueryClient } from '@tanstack/react-query';
import { api } from '@/libs';
import { User } from '@/types';

interface CreateUserInput {
  name: string;
  email: string;
}

export function useCreateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreateUserInput) =>
      api.post<User>('/users', data),
    onSuccess: () => {
      // 성공 시 users 쿼리 무효화 (자동 refetch)
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}

// hooks/mutations/useUpdateUser.ts
export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, data }: { id: string; data: Partial<User> }) =>
      api.put<User>(`/users/${id}`, data),
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      queryClient.invalidateQueries({ queryKey: ['users', variables.id] });
    },
  });
}

// hooks/mutations/useDeleteUser.ts
export function useDeleteUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (userId: string) =>
      api.delete(`/users/${userId}`),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

**사용법**:
```typescript
import { useCreateUser, useUpdateUser, useDeleteUser } from '@/hooks/mutations';

function CreateUserForm() {
  const createUser = useCreateUser();

  const handleSubmit = (formData: CreateUserInput) => {
    createUser.mutate(formData, {
      onSuccess: () => {
        console.log('User created!');
      },
      onError: (error) => {
        console.error('Failed:', error);
      },
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      {/* ... */}
      <button disabled={createUser.isPending}>
        {createUser.isPending ? 'Creating...' : 'Create User'}
      </button>
    </form>
  );
}

function UserActions({ userId }: { userId: string }) {
  const updateUser = useUpdateUser();
  const deleteUser = useDeleteUser();

  return (
    <>
      <button onClick={() => updateUser.mutate({ id: userId, data: { name: 'New Name' } })}>
        Update
      </button>
      <button onClick={() => deleteUser.mutate(userId)}>
        Delete
      </button>
    </>
  );
}
```

### 3. 일반 유틸리티 훅

```typescript
// hooks/useDebounce.ts
import { useState, useEffect } from 'react';

export function useDebounce<T>(value: T, delay: number = 500): T {
  const [debouncedValue, setDebouncedValue] = useState<T>(value);

  useEffect(() => {
    const handler = setTimeout(() => {
      setDebouncedValue(value);
    }, delay);

    return () => {
      clearTimeout(handler);
    };
  }, [value, delay]);

  return debouncedValue;
}

// hooks/useLocalStorage.ts
export function useLocalStorage<T>(
  key: string,
  initialValue: T
): [T, (value: T) => void] {
  const [storedValue, setStoredValue] = useState<T>(() => {
    try {
      const item = window.localStorage.getItem(key);
      return item ? JSON.parse(item) : initialValue;
    } catch (error) {
      return initialValue;
    }
  });

  const setValue = (value: T) => {
    try {
      setStoredValue(value);
      window.localStorage.setItem(key, JSON.stringify(value));
    } catch (error) {
      console.error(error);
    }
  };

  return [storedValue, setValue];
}
```

### 4. Barrel Exports

```typescript
// hooks/index.ts
export * from './queries';
export * from './mutations';
export { useDebounce } from './useDebounce';
export { useLocalStorage } from './useLocalStorage';

// hooks/queries/index.ts
export { useUsers } from './useUsers';
export { useUser } from './useUser';
export { usePosts } from './usePosts';

// hooks/mutations/index.ts
export { useCreateUser } from './useCreateUser';
export { useUpdateUser } from './useUpdateUser';
export { useDeleteUser } from './useDeleteUser';
```

## ✅ 베스트 프랙티스

### React Query 관련

1. **QueryKey 일관성**: 동일한 엔티티는 동일한 키 사용
   ```typescript
   ['users']           // 목록
   ['users', userId]   // 상세
   ['users', userId, 'posts']  // 관계 데이터
   ```

2. **Invalidation 전략**: mutation 성공 시 관련 쿼리 무효화
   ```typescript
   onSuccess: () => {
     queryClient.invalidateQueries({ queryKey: ['users'] });
   }
   ```

3. **Optimistic Updates**: 즉각적인 UI 반영
   ```typescript
   onMutate: async (newUser) => {
     await queryClient.cancelQueries({ queryKey: ['users'] });
     const previousUsers = queryClient.getQueryData(['users']);
     queryClient.setQueryData(['users'], (old) => [...old, newUser]);
     return { previousUsers };
   },
   onError: (err, newUser, context) => {
     queryClient.setQueryData(['users'], context.previousUsers);
   },
   ```

4. **Error Handling**: 전역 에러 처리 설정
   ```typescript
   // QueryClient 설정
   const queryClient = new QueryClient({
     defaultOptions: {
       queries: {
         retry: 1,
         refetchOnWindowFocus: false,
       },
     },
   });
   ```

### 일반 훅 관련

1. **단일 책임 원칙**: 하나의 훅은 하나의 기능만
2. **의존성 배열 명시**: deps 정확히 지정
3. **cleanup 함수**: 구독, 타이머는 반드시 cleanup
4. **타입 안전성**: Generic으로 타입 추론

## 🚫 안티 패턴

```typescript
// ❌ Bad: Query와 Mutation이 섞임
function useUser() {
  const query = useQuery(...);
  const mutation = useMutation(...);
  // ... 너무 많은 책임
}

// ✅ Good: 분리된 책임
function useUser() { return useQuery(...); }      // queries/
function useUpdateUser() { return useMutation(...); }  // mutations/

// ❌ Bad: QueryKey 불일치
useQuery({ queryKey: ['user'] });
useQuery({ queryKey: ['users', id] }); // 일관성 없음

// ✅ Good: 일관된 QueryKey
useQuery({ queryKey: ['users'] });
useQuery({ queryKey: ['users', id] });

// ❌ Bad: mutation 후 invalidation 누락
useMutation({
  mutationFn: createUser,
  // onSuccess 없음 - 캐시가 업데이트되지 않음
});

// ✅ Good: 성공 시 관련 쿼리 무효화
useMutation({
  mutationFn: createUser,
  onSuccess: () => {
    queryClient.invalidateQueries({ queryKey: ['users'] });
  },
});
```

## 📚 추천 리소스

- [TanStack Query (React Query)](https://tanstack.com/query/latest/docs/react/overview)
- [React Query Best Practices](https://tkdodo.eu/blog/practical-react-query)
- [React Hooks 공식 문서](https://react.dev/reference/react)
