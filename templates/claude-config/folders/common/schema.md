# schema/

> Validation Schema 디렉토리

## 📌 목적과 역할

런타임 데이터 유효성 검증 스키마를 관리합니다. Zod, Yup 등을 활용하여 폼 입력, API 요청/응답, 환경 변수 등의 데이터를 검증하고 타입 안전성을 확보합니다. 함수 네이밍 및 파일 네이밍은 최대한 간결하게 작성

## 📂 폴더 구조 예시

```
schema/
├── index.ts              # Barrel export
├── auth.schema.ts        # 인증 관련 스키마
├── user.schema.ts        # 사용자 스키마
├── post.schema.ts        # 게시물 스키마
└── env.schema.ts         # 환경 변수 스키마
```

## 🎯 네이밍 컨벤션

**파일명**: `[도메인].schema.ts` (camelCase + .schema 접미사)
- ✅ `auth.schema.ts`, `user.schema.ts`, `post.schema.ts`
- ❌ `authSchema.ts`, `Auth.schema.ts`, `auth-validation.ts`

**스키마명**: `[도메인]Schema` (camelCase + Schema 접미사)
- ✅ `loginSchema`, `createUserSchema`, `postSchema`
- ❌ `LoginSchema`, `login_schema`, `schema_login`

## 💡 코드 예제와 사용 패턴

### 1. Zod 기본 스키마

```typescript
// schema/auth.schema.ts
import { z } from 'zod';

export const loginSchema = z.object({
  email: z.string().email('유효한 이메일을 입력하세요'),
  password: z.string().min(8, '비밀번호는 최소 8자 이상이어야 합니다'),
});

export const registerSchema = z.object({
  email: z.string().email('유효한 이메일을 입력하세요'),
  password: z
    .string()
    .min(8, '비밀번호는 최소 8자 이상이어야 합니다')
    .regex(/[A-Z]/, '대문자를 포함해야 합니다')
    .regex(/[a-z]/, '소문자를 포함해야 합니다')
    .regex(/[0-9]/, '숫자를 포함해야 합니다'),
  confirmPassword: z.string(),
  name: z.string().min(2, '이름은 최소 2자 이상이어야 합니다'),
}).refine((data) => data.password === data.confirmPassword, {
  message: '비밀번호가 일치하지 않습니다',
  path: ['confirmPassword'],
});

// 타입 추출
export type LoginInput = z.infer<typeof loginSchema>;
export type RegisterInput = z.infer<typeof registerSchema>;
```

**사용법**:
```typescript
import { loginSchema, LoginInput } from '@/schema';

async function handleLogin(formData: unknown) {
  try {
    // 런타임 검증 + 타입 안전성
    const data: LoginInput = loginSchema.parse(formData);
    await login(data.email, data.password);
  } catch (error) {
    if (error instanceof z.ZodError) {
      console.error(error.errors); // 검증 오류 처리
    }
  }
}
```

### 2. 중첩된 객체 스키마

```typescript
// schema/user.schema.ts
import { z } from 'zod';

export const addressSchema = z.object({
  street: z.string(),
  city: z.string(),
  state: z.string(),
  zipCode: z.string().regex(/^\d{5}$/, '우편번호는 5자리 숫자입니다'),
});

export const userSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  name: z.string().min(2).max(50),
  age: z.number().int().min(18).max(120),
  address: addressSchema,
  roles: z.array(z.enum(['ADMIN', 'USER', 'GUEST'])),
  createdAt: z.date(),
});

export const createUserSchema = userSchema.omit({
  id: true,
  createdAt: true,
});

export const updateUserSchema = userSchema.partial().required({
  id: true,
});

export type User = z.infer<typeof userSchema>;
export type CreateUserInput = z.infer<typeof createUserSchema>;
export type UpdateUserInput = z.infer<typeof updateUserSchema>;
```

### 3. 환경 변수 스키마

```typescript
// schema/env.schema.ts
import { z } from 'zod';

const envSchema = z.object({
  NODE_ENV: z.enum(['development', 'production', 'test']),
  API_URL: z.string().url(),
  API_KEY: z.string().min(1),
  PORT: z.string().regex(/^\d+$/).transform(Number),
  DATABASE_URL: z.string().url(),
  REDIS_URL: z.string().url().optional(),
});

// 환경 변수 검증 및 타입 안전성 확보
export const env = envSchema.parse(process.env);

export type Env = z.infer<typeof envSchema>;
```

**사용법**:
```typescript
import { env } from '@/schema/env.schema';

// Type-safe 환경 변수 사용
const apiClient = createClient({
  baseURL: env.API_URL,
  apiKey: env.API_KEY,
  port: env.PORT, // number 타입으로 자동 변환됨
});
```

### 4. API 요청/응답 스키마

```typescript
// schema/post.schema.ts
import { z } from 'zod';

export const postSchema = z.object({
  id: z.string().uuid(),
  title: z.string().min(1).max(200),
  content: z.string().min(1),
  author: z.object({
    id: z.string().uuid(),
    name: z.string(),
  }),
  tags: z.array(z.string()).max(10),
  published: z.boolean(),
  createdAt: z.string().datetime(),
});

export const createPostSchema = z.object({
  title: z.string().min(1, '제목을 입력하세요').max(200, '제목은 최대 200자입니다'),
  content: z.string().min(1, '내용을 입력하세요'),
  tags: z.array(z.string()).max(10, '태그는 최대 10개입니다').optional(),
});

export const updatePostSchema = createPostSchema.partial();

export const postListResponseSchema = z.object({
  data: z.array(postSchema),
  pagination: z.object({
    page: z.number(),
    limit: z.number(),
    total: z.number(),
    totalPages: z.number(),
  }),
});

export type Post = z.infer<typeof postSchema>;
export type CreatePostInput = z.infer<typeof createPostSchema>;
export type UpdatePostInput = z.infer<typeof updatePostSchema>;
export type PostListResponse = z.infer<typeof postListResponseSchema>;
```

**사용법**:
```typescript
import { postListResponseSchema, PostListResponse } from '@/schema';

async function fetchPosts(): Promise<PostListResponse> {
  const response = await fetch('/api/posts');
  const data = await response.json();
  
  // API 응답 검증
  return postListResponseSchema.parse(data);
}
```

### 5. Form Validation (React Hook Form)

```typescript
// schema/form.schema.ts
import { z } from 'zod';

export const contactFormSchema = z.object({
  name: z.string().min(2, '이름은 최소 2자 이상이어야 합니다'),
  email: z.string().email('유효한 이메일을 입력하세요'),
  phone: z.string().regex(/^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$/, '유효한 전화번호를 입력하세요'),
  message: z.string().min(10, '메시지는 최소 10자 이상이어야 합니다').max(1000),
});

export type ContactFormInput = z.infer<typeof contactFormSchema>;
```

**사용법** (React Hook Form):
```typescript
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import { contactFormSchema, ContactFormInput } from '@/schema';

function ContactForm() {
  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<ContactFormInput>({
    resolver: zodResolver(contactFormSchema),
  });

  const onSubmit = (data: ContactFormInput) => {
    console.log(data); // Type-safe & validated
  };

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      <input {...register('name')} />
      {errors.name && <span>{errors.name.message}</span>}
      {/* ... */}
    </form>
  );
}
```

## ✅ 베스트 프랙티스

1. **런타임 검증**: TypeScript 타입만으로는 부족, 런타임 검증 필수
2. **타입 추론**: `z.infer`로 스키마에서 타입 자동 생성
3. **명확한 에러 메시지**: 사용자가 이해하기 쉬운 메시지 작성
4. **재사용성**: 공통 스키마는 조합하여 사용
5. **환경 변수 검증**: 앱 시작 시 env 검증으로 런타임 에러 방지

## 🚫 안티 패턴

```typescript
// ❌ Bad: 검증 없이 타입 단언
const data = formData as LoginInput; // 위험!

// ✅ Good: 스키마로 검증
const data = loginSchema.parse(formData); // 안전!

// ❌ Bad: 중복된 스키마 정의
const loginSchema1 = z.object({ email: z.string().email() });
const loginSchema2 = z.object({ email: z.string().email() });

// ✅ Good: 스키마 재사용
const emailSchema = z.string().email();
const loginSchema = z.object({ email: emailSchema });
const registerSchema = z.object({ email: emailSchema });

// ❌ Bad: 불명확한 에러 메시지
z.string().min(8)

// ✅ Good: 명확한 에러 메시지
z.string().min(8, '비밀번호는 최소 8자 이상이어야 합니다')
```

## 📚 추천 리소스

- [Zod](https://zod.dev/) - TypeScript-first schema validation
- [React Hook Form](https://react-hook-form.com/) - Form validation library
- [Yup](https://github.com/jquense/yup) - Alternative validation library
