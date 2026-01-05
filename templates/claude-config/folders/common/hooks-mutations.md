# hooks/mutations/

> React Query - 데이터 변경 훅 (POST, PUT, DELETE)

## 📌 목적과 역할

서버의 데이터를 생성, 수정, 삭제하는 React Query 훅을 관리합니다. useMutation을 활용하여 비동기 데이터 변경 작업과 자동 캐시 무효화를 처리합니다.

## 🎯 네이밍 컨벤션

**생성 (CREATE)**:
- `useCreate[엔티티명].ts`
- ✅ `useCreateUser.ts`, `useCreatePost.ts`
- ❌ `createUserMutation.ts`, `addUser.ts`

**수정 (UPDATE)**:
- `useUpdate[엔티티명].ts`
- ✅ `useUpdateUser.ts`, `useUpdatePost.ts`
- ❌ `updateUserMutation.ts`, `editUser.ts`

**삭제 (DELETE)**:
- `useDelete[엔티티명].ts`
- ✅ `useDeleteUser.ts`, `useDeletePost.ts`
- ❌ `deleteUserMutation.ts`, `removeUser.ts`

## 💡 코드 예제와 사용 패턴

### 1. 기본 Mutation Hook (생성)

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
      queryClient.invalidateQueries({ queryKey: ['users'] });
    },
  });
}
```

**사용법**:
```typescript
import { useCreateUser } from '@/hooks/mutations';

function CreateUserForm() {
  const createUser = useCreateUser();

  const handleSubmit = (formData: CreateUserInput) => {
    createUser.mutate(formData, {
      onSuccess: (newUser) => {
        console.log('Created:', newUser);
      },
      onError: (error) => {
        console.error('Failed:', error);
      },
    });
  };

  return (
    <form onSubmit={handleSubmit}>
      <button disabled={createUser.isPending}>
        {createUser.isPending ? 'Creating...' : 'Create User'}
      </button>
    </form>
  );
}
```

### 2. 수정 Mutation Hook

```typescript
// hooks/mutations/useUpdateUser.ts
interface UpdateUserInput {
  id: string;
  data: Partial<User>;
}

export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, data }: UpdateUserInput) =>
      api.put<User>(`/users/${id}`, data),
    onSuccess: (updatedUser, variables) => {
      queryClient.invalidateQueries({ queryKey: ['users'] });
      queryClient.invalidateQueries({ queryKey: ['users', variables.id] });
    },
  });
}
```

### 3. Optimistic Updates (낙관적 업데이트)

```typescript
// hooks/mutations/useUpdateUser.ts
export function useUpdateUser() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: ({ id, data }: UpdateUserInput) =>
      api.put<User>(`/users/${id}`, data),

    onMutate: async (variables) => {
      await queryClient.cancelQueries({ queryKey: ['users', variables.id] });
      const previousUser = queryClient.getQueryData(['users', variables.id]);

      queryClient.setQueryData(['users', variables.id], (old: User) => ({
        ...old,
        ...variables.data,
      }));

      return { previousUser };
    },

    onError: (err, variables, context) => {
      queryClient.setQueryData(
        ['users', variables.id],
        context?.previousUser
      );
    },

    onSettled: (data, error, variables) => {
      queryClient.invalidateQueries({ queryKey: ['users', variables.id] });
    },
  });
}
```

**사용법**:
```typescript
function UserProfile({ user }: { user: User }) {
  const updateUser = useUpdateUser();

  const toggleActive = () => {
    // UI가 즉시 변경되고, 실패 시 자동 롤백
    updateUser.mutate({
      id: user.id,
      data: { active: !user.active },
    });
  };

  return (
    <button onClick={toggleActive}>
      {user.active ? 'Deactivate' : 'Activate'}
    </button>
  );
}
```

### 4. 여러 Query 무효화

```typescript
// hooks/mutations/useCreatePost.ts
export function useCreatePost() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: (data: CreatePostInput) =>
      api.post<Post>('/posts', data),
    onSuccess: (newPost) => {
      queryClient.invalidateQueries({ queryKey: ['posts'] });
      queryClient.invalidateQueries({
        queryKey: ['users', newPost.authorId, 'posts']
      });
      queryClient.invalidateQueries({ queryKey: ['dashboard', 'stats'] });
    },
  });
}
```

## ✅ 베스트 프랙티스

### 1. Invalidation 전략

```typescript
// ✅ Good: 관련된 모든 쿼리 무효화
onSuccess: (newUser) => {
  queryClient.invalidateQueries({ queryKey: ['users'] });
  queryClient.invalidateQueries({ queryKey: ['dashboard'] });
}

// ❌ Bad: 일부만 무효화
onSuccess: () => {
  queryClient.invalidateQueries({ queryKey: ['users'] });
  // dashboard는 무효화 안 함
}
```

### 2. 타입 안전성

```typescript
// ✅ Good: 입력/출력 타입 명시
export function useCreateUser() {
  return useMutation<User, ApiError, CreateUserInput>({
    mutationFn: (data) => api.post('/users', data),
  });
}
```

### 3. mutate vs mutateAsync

```typescript
// ✅ Good: 일반적인 경우 mutate 사용
const handleClick = () => {
  createUser.mutate(data, {
    onSuccess: () => console.log('Success'),
  });
};

// ✅ Good: await 필요 시 mutateAsync 사용
const handleClick = async () => {
  try {
    const result = await createUser.mutateAsync(data);
  } catch (error) {
    console.error(error);
  }
};
```

## 🚫 안티 패턴

```typescript
// ❌ Bad: onSuccess에서 직접 UI 업데이트
export function useCreateUser() {
  return useMutation({
    mutationFn: (data) => api.post('/users', data),
    onSuccess: () => {
      alert('Success!'); // UI 로직을 hook 내부에
    },
  });
}

// ✅ Good: 컴포넌트에서 UI 처리
function CreateUserForm() {
  const createUser = useCreateUser();

  const handleSubmit = (data) => {
    createUser.mutate(data, {
      onSuccess: () => {
        alert('Success!');
      },
    });
  };
}
```

## 📚 추천 리소스

- [TanStack Query - useMutation](https://tanstack.com/query/latest/docs/react/reference/useMutation)
- [Optimistic Updates](https://tanstack.com/query/latest/docs/react/guides/optimistic-updates)
- [Mutations Best Practices](https://tkdodo.eu/blog/mastering-mutations-in-react-query)
