# hooks/queries/

> React Query - 데이터 조회 훅 (GET 요청)

## 📌 목적과 역할

서버에서 데이터를 조회(fetch)하는 React Query 훅을 관리합니다. useQuery를 활용하여 데이터 캐싱, 자동 리페칭, 로딩/에러 상태를 자동으로 관리합니다.

## 🎯 네이밍 컨벤션

**단일 엔티티 조회**:
- `use[엔티티명].ts` (단수형)
- ✅ `useUser.ts`, `usePost.ts`, `useProduct.ts`
- ❌ `getUserQuery.ts`, `user.ts`, `fetchUser.ts`

**목록 조회**:
- `use[엔티티명]s.ts` (복수형)
- ✅ `useUsers.ts`, `usePosts.ts`, `useProducts.ts`
- ❌ `getUsersQuery.ts`, `userList.ts`

**관계 데이터 조회**:
- `use[엔티티명][관계명].ts`
- ✅ `useUserPosts.ts`, `usePostComments.ts`

## 💡 코드 예제와 사용 패턴

### 1. 기본 Query Hook (목록 조회)

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
```

**사용법**:
```typescript
import { useUsers } from '@/hooks/queries';

function UserList() {
  const { data, isLoading, error, refetch } = useUsers();

  if (isLoading) return <div>Loading...</div>;
  if (error) return <div>Error: {error.message}</div>;

  return (
    <div>
      <button onClick={() => refetch()}>Refresh</button>
      <ul>
        {data?.map((user) => (
          <li key={user.id}>{user.name}</li>
        ))}
      </ul>
    </div>
  );
}
```

### 2. 파라미터가 있는 Query Hook (단일 조회)

```typescript
// hooks/queries/useUser.ts
export function useUser(userId: string) {
  return useQuery({
    queryKey: ['users', userId],
    queryFn: () => api.get<User>(`/users/${userId}`),
    enabled: !!userId, // userId가 있을 때만 실행
  });
}
```

**사용법**:
```typescript
function UserProfile({ userId }: { userId: string }) {
  const { data: user, isLoading } = useUser(userId);

  if (isLoading) return <div>Loading...</div>;
  return <div>{user?.name}</div>;
}
```

### 3. 필터/정렬 파라미터가 있는 Query Hook

```typescript
// hooks/queries/useUsers.ts
interface UseUsersParams {
  page?: number;
  limit?: number;
  search?: string;
  role?: string;
}

export function useUsers(params?: UseUsersParams) {
  return useQuery({
    queryKey: ['users', params], // params가 변경되면 자동 refetch
    queryFn: () => api.get<User[]>('/users', { params }),
  });
}
```

**사용법**:
```typescript
function UserList() {
  const [page, setPage] = useState(1);
  const [search, setSearch] = useState('');

  // search나 page가 변경되면 자동으로 refetch
  const { data: users } = useUsers({ page, search });

  return (
    <div>
      <input value={search} onChange={(e) => setSearch(e.target.value)} />
      {users?.map((user) => <div key={user.id}>{user.name}</div>)}
      <button onClick={() => setPage(page + 1)}>Next Page</button>
    </div>
  );
}
```

### 4. 관계 데이터 조회

```typescript
// hooks/queries/useUserPosts.ts
export function useUserPosts(userId: string) {
  return useQuery({
    queryKey: ['users', userId, 'posts'],
    queryFn: () => api.get<Post[]>(`/users/${userId}/posts`),
    enabled: !!userId,
  });
}
```

### 5. 조건부 실행 (enabled)

```typescript
// hooks/queries/useUserProfile.ts
export function useUserProfile(userId: string | null) {
  return useQuery({
    queryKey: ['users', userId, 'profile'],
    queryFn: () => api.get<UserProfile>(`/users/${userId}/profile`),
    enabled: !!userId, // userId가 null이면 쿼리 실행 안 함
  });
}

// 권한 기반 조건부 실행
export function useAdminData(isAdmin: boolean) {
  return useQuery({
    queryKey: ['admin', 'data'],
    queryFn: () => api.get('/admin/data'),
    enabled: isAdmin, // 관리자일 때만 실행
  });
}
```

### 6. 캐싱 옵션 설정

```typescript
// hooks/queries/useStaticData.ts
export function useStaticData() {
  return useQuery({
    queryKey: ['static-data'],
    queryFn: () => api.get('/static-data'),
    staleTime: 1000 * 60 * 60, // 1시간 동안 fresh 상태 유지
    gcTime: 1000 * 60 * 60 * 24, // 24시간 동안 캐시 유지
  });
}

// hooks/queries/useRealtimeData.ts
export function useRealtimeData() {
  return useQuery({
    queryKey: ['realtime-data'],
    queryFn: () => api.get('/realtime-data'),
    refetchInterval: 5000, // 5초마다 자동 refetch
  });
}
```

## ✅ 베스트 프랙티스

### 1. QueryKey 일관성

```typescript
// ✅ Good: 일관된 계층 구조
['users']                    // 전체 사용자 목록
['users', userId]            // 특정 사용자
['users', userId, 'posts']   // 특정 사용자의 게시물

// ❌ Bad: 불일치하는 구조
['user']                     // 단수형 사용
['users', 'detail', userId]  // 불필요한 중간 키
```

### 2. enabled 옵션 활용

```typescript
// ✅ Good: 필수 파라미터 확인
export function useUser(userId: string | undefined) {
  return useQuery({
    queryKey: ['users', userId],
    queryFn: () => api.get(`/users/${userId}`),
    enabled: !!userId, // undefined일 때 실행 안 함
  });
}

// ❌ Bad: enabled 없이 사용
export function useUser(userId: string | undefined) {
  return useQuery({
    queryKey: ['users', userId],
    queryFn: () => api.get(`/users/${userId}`), // userId가 undefined면 에러
  });
}
```

### 3. 타입 안전성

```typescript
// ✅ Good: 제네릭으로 타입 추론
import { User } from '@/types';

export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => api.get<User[]>('/users'), // User[] 타입 추론
  });
}

// 사용 시 data의 타입이 User[] | undefined로 자동 추론됨
const { data } = useUsers();
```

### 4. 에러 처리

```typescript
// ✅ Good: 에러 타입 정의
import { ApiError } from '@/types';

export function useUsers() {
  return useQuery<User[], ApiError>({
    queryKey: ['users'],
    queryFn: async () => {
      try {
        return await api.get<User[]>('/users');
      } catch (error) {
        // 에러 변환 로직
        throw new ApiError(error);
      }
    },
  });
}

// 사용 시
const { error } = useUsers();
if (error) {
  console.log(error.statusCode); // 타입 안전
}
```

### 5. 의존성 있는 Query

```typescript
// ✅ Good: 순차적 실행
export function useUserWithPosts(userId: string) {
  const { data: user } = useUser(userId);
  const { data: posts } = useUserPosts(userId);

  return { user, posts };
}

// 또는 enabled로 제어
export function useUserPosts(userId: string) {
  const { data: user } = useUser(userId);
  
  return useQuery({
    queryKey: ['users', userId, 'posts'],
    queryFn: () => api.get(`/users/${userId}/posts`),
    enabled: !!user, // user가 로드된 후에만 실행
  });
}
```

## 🚫 안티 패턴

```typescript
// ❌ Bad: Query 안에서 mutation 실행
export function useUser() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const data = await api.get('/users');
      await api.post('/analytics', { event: 'view' }); // mutation!
      return data;
    },
  });
}

// ✅ Good: Query는 순수하게 조회만
export function useUser() {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => api.get('/users'),
  });
}

// ❌ Bad: 동기 함수를 queryFn에 사용
export function useConfig() {
  return useQuery({
    queryKey: ['config'],
    queryFn: () => localStorage.getItem('config'), // 동기 함수
  });
}

// ✅ Good: 비동기 작업만 React Query 사용
export function useConfig() {
  return useQuery({
    queryKey: ['config'],
    queryFn: async () => {
      return JSON.parse(localStorage.getItem('config') || '{}');
    },
  });
}
```

## 📚 추천 리소스

- [TanStack Query - useQuery](https://tanstack.com/query/latest/docs/react/reference/useQuery)
- [Effective React Query Keys](https://tkdodo.eu/blog/effective-react-query-keys)
- [React Query Data Transformations](https://tkdodo.eu/blog/react-query-data-transformations)
