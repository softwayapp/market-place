# frontend:api-structure

Initialize React Query API structure with HTTP client, API layer, queries, and mutations for React Native/Expo projects.

## Purpose
Set up a complete, production-ready API architecture with:
- HTTP client configuration (axios)
- API layer with typed endpoints
- React Query hooks for queries
- React Query hooks for mutations
- TypeScript types and interfaces
- Error handling and interceptors

## Usage
```bash
/frontend:api-structure
```

## What This Skill Creates

### Directory Structure
```
src/
├── libs/
│   ├── http/
│   │   ├── index.ts           # HTTP client with interceptors
│   │   ├── types.ts           # HTTP types and interfaces
│   │   └── errors.ts          # Error handling utilities
│   └── api/
│       ├── index.ts           # API exports
│       ├── auth.api.ts        # Auth endpoints example
│       └── types.ts           # API response types
├── hooks/
│   ├── queries/
│   │   ├── index.ts           # Query hooks exports
│   │   ├── useAuth.ts         # Auth query hooks example
│   │   └── keys.ts            # Query key factory
│   └── mutations/
│       ├── index.ts           # Mutation hooks exports
│       └── useAuth.ts         # Auth mutation hooks example
```

## Implementation

```typescript
// Execute the skill
import { promises as fs } from 'fs';
import path from 'path';

const PROJECT_ROOT = 'D:\\iot-expo';
const SRC_DIR = path.join(PROJECT_ROOT, 'src');

// Directory structure
const DIRS = [
  'libs/http',
  'libs/api',
  'hooks/queries',
  'hooks/mutations'
];

// Create directories
for (const dir of DIRS) {
  const fullPath = path.join(SRC_DIR, dir);
  await fs.mkdir(fullPath, { recursive: true });
  console.log(`✅ Created: ${dir}`);
}

// Create files with templates
// See templates below
```

## Templates

### 1. HTTP Client Layer (`src/libs/http/`)

#### `src/libs/http/types.ts`
```typescript
export interface ApiResponse<T = unknown> {
  data: T;
  message?: string;
  success: boolean;
}

export interface ApiError {
  message: string;
  code?: string;
  status?: number;
  errors?: Record<string, string[]>;
}

export interface PaginatedResponse<T> {
  data: T[];
  meta: {
    total: number;
    page: number;
    perPage: number;
    totalPages: number;
  };
}

export interface RequestConfig {
  skipAuth?: boolean;
  skipErrorHandling?: boolean;
  timeout?: number;
}
```

#### `src/libs/http/errors.ts`
```typescript
export class ApiException extends Error {
  constructor(
    message: string,
    public status?: number,
    public code?: string,
    public errors?: Record<string, string[]>
  ) {
    super(message);
    this.name = 'ApiException';
  }

  static fromResponse(error: any): ApiException {
    const message = error.response?.data?.message || error.message || 'An error occurred';
    const status = error.response?.status;
    const code = error.response?.data?.code;
    const errors = error.response?.data?.errors;

    return new ApiException(message, status, code, errors);
  }

  get isUnauthorized(): boolean {
    return this.status === 401;
  }

  get isForbidden(): boolean {
    return this.status === 403;
  }

  get isNotFound(): boolean {
    return this.status === 404;
  }

  get isValidationError(): boolean {
    return this.status === 422 && !!this.errors;
  }

  get isServerError(): boolean {
    return this.status ? this.status >= 500 : false;
  }
}
```

#### `src/libs/http/index.ts`
```typescript
import axios, { AxiosError, AxiosRequestConfig, AxiosResponse } from 'axios';
import Constants from 'expo-constants';
import * as SecureStore from 'expo-secure-store';
import { ApiException } from './errors';
import type { ApiResponse, RequestConfig } from './types';

const API_URL = Constants.expoConfig?.extra?.apiUrl || 'http://localhost:3000/api';
const TIMEOUT = 30000; // 30 seconds

// Create axios instance
export const httpClient = axios.create({
  baseURL: API_URL,
  timeout: TIMEOUT,
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

// Request interceptor
httpClient.interceptors.request.use(
  async (config) => {
    const customConfig = config as AxiosRequestConfig & { skipAuth?: boolean };

    // Add auth token if available and not skipped
    if (!customConfig.skipAuth) {
      try {
        const token = await SecureStore.getItemAsync('auth_token');
        if (token) {
          config.headers.Authorization = `Bearer ${token}`;
        }
      } catch (error) {
        console.error('Error getting auth token:', error);
      }
    }

    return config;
  },
  (error) => {
    return Promise.reject(error);
  }
);

// Response interceptor
httpClient.interceptors.response.use(
  (response: AxiosResponse<ApiResponse>) => {
    return response;
  },
  async (error: AxiosError) => {
    const customConfig = error.config as AxiosRequestConfig & RequestConfig;

    // Handle unauthorized errors
    if (error.response?.status === 401) {
      // Clear stored token
      await SecureStore.deleteItemAsync('auth_token');

      // You can emit an event here to redirect to login
      // EventEmitter.emit('unauthorized');
    }

    // Skip error handling if requested
    if (customConfig?.skipErrorHandling) {
      return Promise.reject(error);
    }

    // Transform to ApiException
    const apiError = ApiException.fromResponse(error);
    return Promise.reject(apiError);
  }
);

// Helper functions
export async function setAuthToken(token: string): Promise<void> {
  await SecureStore.setItemAsync('auth_token', token);
}

export async function clearAuthToken(): Promise<void> {
  await SecureStore.deleteItemAsync('auth_token');
}

export async function getAuthToken(): Promise<string | null> {
  return await SecureStore.getItemAsync('auth_token');
}

// Export types
export * from './types';
export * from './errors';
```

### 2. API Layer (`src/libs/api/`)

#### `src/libs/api/types.ts`
```typescript
// Common API types
export interface User {
  id: string;
  email: string;
  name: string;
  avatar?: string;
  createdAt: string;
  updatedAt: string;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface LoginResponse {
  user: User;
  token: string;
  refreshToken: string;
}

export interface RegisterRequest {
  email: string;
  password: string;
  name: string;
}

export interface RegisterResponse {
  user: User;
  token: string;
}

// Add more API types as needed
```

#### `src/libs/api/auth.api.ts`
```typescript
import { httpClient } from '../http';
import type { ApiResponse } from '../http/types';
import type {
  LoginRequest,
  LoginResponse,
  RegisterRequest,
  RegisterResponse,
  User,
} from './types';

export const authApi = {
  /**
   * Login user
   */
  async login(data: LoginRequest): Promise<LoginResponse> {
    const response = await httpClient.post<ApiResponse<LoginResponse>>(
      '/auth/login',
      data
    );
    return response.data.data;
  },

  /**
   * Register new user
   */
  async register(data: RegisterRequest): Promise<RegisterResponse> {
    const response = await httpClient.post<ApiResponse<RegisterResponse>>(
      '/auth/register',
      data
    );
    return response.data.data;
  },

  /**
   * Logout user
   */
  async logout(): Promise<void> {
    await httpClient.post('/auth/logout');
  },

  /**
   * Get current user profile
   */
  async getProfile(): Promise<User> {
    const response = await httpClient.get<ApiResponse<User>>('/auth/profile');
    return response.data.data;
  },

  /**
   * Refresh auth token
   */
  async refreshToken(refreshToken: string): Promise<LoginResponse> {
    const response = await httpClient.post<ApiResponse<LoginResponse>>(
      '/auth/refresh',
      { refreshToken },
      { skipAuth: true } as any
    );
    return response.data.data;
  },
};
```

#### `src/libs/api/index.ts`
```typescript
export * from './types';
export * from './auth.api';

// Export all API modules
export const api = {
  auth: authApi,
  // Add more API modules here
  // users: usersApi,
  // posts: postsApi,
};
```

### 3. Query Hooks Layer (`src/hooks/queries/`)

#### `src/hooks/queries/keys.ts`
```typescript
import { createQueryKeyStore } from '@lukemorales/query-key-factory';

/**
 * Query key factory for type-safe and organized query keys
 *
 * Benefits:
 * - Type-safe query keys
 * - Centralized key management
 * - Easy invalidation
 * - Automatic key inference
 */
export const queryKeys = createQueryKeyStore({
  auth: {
    profile: null,
    user: (userId: string) => [userId],
  },
  // Add more query keys as needed
  // users: {
  //   list: (filters?: UserFilters) => [filters],
  //   detail: (userId: string) => [userId],
  // },
});
```

#### `src/hooks/queries/useAuth.ts`
```typescript
import { useQuery, UseQueryOptions } from '@tanstack/react-query';
import { authApi } from '@/libs/api';
import type { User } from '@/libs/api/types';
import { ApiException } from '@/libs/http/errors';
import { queryKeys } from './keys';

/**
 * Hook to fetch current user profile
 *
 * @example
 * ```tsx
 * const { data: user, isLoading, error } = useAuthProfile();
 * ```
 */
export function useAuthProfile(
  options?: Omit<UseQueryOptions<User, ApiException>, 'queryKey' | 'queryFn'>
) {
  return useQuery<User, ApiException>({
    queryKey: queryKeys.auth.profile.queryKey,
    queryFn: authApi.getProfile,
    staleTime: 1000 * 60 * 5, // 5 minutes
    gcTime: 1000 * 60 * 30, // 30 minutes (formerly cacheTime)
    retry: (failureCount, error) => {
      // Don't retry on auth errors
      if (error.isUnauthorized || error.isForbidden) {
        return false;
      }
      return failureCount < 3;
    },
    ...options,
  });
}

/**
 * Hook to check if user is authenticated
 *
 * @example
 * ```tsx
 * const isAuthenticated = useIsAuthenticated();
 * ```
 */
export function useIsAuthenticated(): boolean {
  const { data } = useAuthProfile({
    retry: false,
    gcTime: Infinity,
  });
  return !!data;
}
```

#### `src/hooks/queries/index.ts`
```typescript
export * from './keys';
export * from './useAuth';

// Export all query hooks
// export * from './useUsers';
// export * from './usePosts';
```

### 4. Mutation Hooks Layer (`src/hooks/mutations/`)

#### `src/hooks/mutations/useAuth.ts`
```typescript
import { useMutation, useQueryClient, UseMutationOptions } from '@tanstack/react-query';
import { authApi } from '@/libs/api';
import type {
  LoginRequest,
  LoginResponse,
  RegisterRequest,
  RegisterResponse,
} from '@/libs/api/types';
import { setAuthToken, clearAuthToken } from '@/libs/http';
import { ApiException } from '@/libs/http/errors';
import { queryKeys } from '@/hooks/queries';

/**
 * Hook to login user
 *
 * @example
 * ```tsx
 * const { mutate: login, isPending } = useLogin({
 *   onSuccess: (data) => {
 *     console.log('Logged in:', data.user);
 *   },
 * });
 *
 * login({ email: 'user@example.com', password: 'password' });
 * ```
 */
export function useLogin(
  options?: UseMutationOptions<LoginResponse, ApiException, LoginRequest>
) {
  const queryClient = useQueryClient();

  return useMutation<LoginResponse, ApiException, LoginRequest>({
    mutationFn: authApi.login,
    onSuccess: async (data, variables, context) => {
      // Store auth token
      await setAuthToken(data.token);

      // Update user profile cache
      queryClient.setQueryData(queryKeys.auth.profile.queryKey, data.user);

      // Call user's onSuccess
      options?.onSuccess?.(data, variables, context);
    },
    ...options,
  });
}

/**
 * Hook to register new user
 *
 * @example
 * ```tsx
 * const { mutate: register, isPending } = useRegister({
 *   onSuccess: (data) => {
 *     console.log('Registered:', data.user);
 *   },
 * });
 *
 * register({ email: 'user@example.com', password: 'password', name: 'John' });
 * ```
 */
export function useRegister(
  options?: UseMutationOptions<RegisterResponse, ApiException, RegisterRequest>
) {
  const queryClient = useQueryClient();

  return useMutation<RegisterResponse, ApiException, RegisterRequest>({
    mutationFn: authApi.register,
    onSuccess: async (data, variables, context) => {
      // Store auth token
      await setAuthToken(data.token);

      // Update user profile cache
      queryClient.setQueryData(queryKeys.auth.profile.queryKey, data.user);

      // Call user's onSuccess
      options?.onSuccess?.(data, variables, context);
    },
    ...options,
  });
}

/**
 * Hook to logout user
 *
 * @example
 * ```tsx
 * const { mutate: logout } = useLogout({
 *   onSuccess: () => {
 *     console.log('Logged out');
 *   },
 * });
 *
 * logout();
 * ```
 */
export function useLogout(
  options?: UseMutationOptions<void, ApiException, void>
) {
  const queryClient = useQueryClient();

  return useMutation<void, ApiException, void>({
    mutationFn: authApi.logout,
    onSuccess: async (data, variables, context) => {
      // Clear auth token
      await clearAuthToken();

      // Clear all queries
      queryClient.clear();

      // Call user's onSuccess
      options?.onSuccess?.(data, variables, context);
    },
    ...options,
  });
}
```

#### `src/hooks/mutations/index.ts`
```typescript
export * from './useAuth';

// Export all mutation hooks
// export * from './useUsers';
// export * from './usePosts';
```

## Additional Setup Required

### 1. Update `app.config.js` or `app.json`
```javascript
export default {
  expo: {
    // ... other config
    extra: {
      apiUrl: process.env.API_URL || 'http://localhost:3000/api',
    },
  },
};
```

### 2. Create `.env` file
```env
API_URL=http://localhost:3000/api
```

### 3. Setup React Query Provider (if not already done)

Create `src/providers/QueryProvider.tsx`:
```typescript
import { QueryClient, QueryClientProvider } from '@tanstack/react-query';
import { PropsWithChildren } from 'react';

const queryClient = new QueryClient({
  defaultOptions: {
    queries: {
      retry: 3,
      staleTime: 1000 * 60, // 1 minute
      gcTime: 1000 * 60 * 5, // 5 minutes
      refetchOnWindowFocus: false,
      refetchOnReconnect: true,
    },
    mutations: {
      retry: 1,
    },
  },
});

export function QueryProvider({ children }: PropsWithChildren) {
  return (
    <QueryClientProvider client={queryClient}>
      {children}
    </QueryClientProvider>
  );
}
```

Then wrap your app in `app/_layout.tsx`:
```typescript
import { QueryProvider } from '@/providers/QueryProvider';

export default function RootLayout() {
  return (
    <QueryProvider>
      {/* Your app content */}
    </QueryProvider>
  );
}
```

## Usage Examples

### Login Flow
```typescript
import { useLogin, useAuthProfile } from '@/hooks';

function LoginScreen() {
  const { mutate: login, isPending } = useLogin({
    onSuccess: () => {
      // Navigate to home
      router.replace('/(tabs)');
    },
    onError: (error) => {
      if (error.isValidationError) {
        // Handle validation errors
        console.log(error.errors);
      } else {
        // Handle other errors
        console.log(error.message);
      }
    },
  });

  const handleLogin = () => {
    login({
      email: 'user@example.com',
      password: 'password',
    });
  };

  return (
    <View>
      <Button onPress={handleLogin} disabled={isPending}>
        {isPending ? 'Logging in...' : 'Login'}
      </Button>
    </View>
  );
}
```

### Protected Profile Screen
```typescript
import { useAuthProfile, useLogout } from '@/hooks';

function ProfileScreen() {
  const { data: user, isLoading, error } = useAuthProfile();
  const { mutate: logout } = useLogout({
    onSuccess: () => {
      router.replace('/login');
    },
  });

  if (isLoading) return <Text>Loading...</Text>;
  if (error) return <Text>Error: {error.message}</Text>;
  if (!user) return <Text>Not authenticated</Text>;

  return (
    <View>
      <Text>Welcome, {user.name}!</Text>
      <Text>{user.email}</Text>
      <Button onPress={() => logout()}>Logout</Button>
    </View>
  );
}
```

## Best Practices

1. **Error Handling**: Always handle errors in mutations and queries
2. **Loading States**: Show loading indicators during pending states
3. **Optimistic Updates**: Use optimistic updates for better UX
4. **Cache Invalidation**: Invalidate related queries after mutations
5. **Type Safety**: Always type your API responses and request payloads
6. **Query Keys**: Use the query key factory for consistency
7. **Retry Logic**: Configure retry behavior based on error types
8. **Security**: Never store sensitive data in query cache

## Features

✅ Type-safe HTTP client with axios
✅ Centralized error handling
✅ Auth token management with SecureStore
✅ Request/Response interceptors
✅ React Query integration
✅ Query key factory for type safety
✅ Mutation hooks with cache updates
✅ Optimistic updates support
✅ Comprehensive error types
✅ Environment-based configuration
✅ Production-ready architecture

## Notes

- This skill creates example files for auth flow
- Customize the templates based on your API requirements
- Add more API modules, query hooks, and mutation hooks as needed
- Update TypeScript paths in `tsconfig.json` if using path aliases
- Consider adding React Query DevTools for development
