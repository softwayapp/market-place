# utils/

> 유틸리티 함수 디렉토리

## 📌 목적과 역할

순수 함수 기반의 재사용 가능한 헬퍼 함수를 관리합니다. 날짜 포맷팅, 문자열 처리, 배열 조작, 유효성 검증 등 비즈니스 로직과 독립적인 유틸리티를 제공합니다. 함수 네이밍 및 파일 네이밍은 최대한 간결하게 작성

## 📂 폴더 구조 예시

```
utils/
├── index.ts              # Barrel export
├── format.ts             # 포맷팅 유틸
├── validation.ts         # 유효성 검증
├── array.ts              # 배열 조작
├── string.ts             # 문자열 처리
├── number.ts             # 숫자 처리
└── date.ts               # 날짜 처리
```

## 🎯 네이밍 컨벤션

**파일명**: `[카테고리명].ts` (camelCase)
- ✅ `format.ts`, `validation.ts`, `string.ts`
- ❌ `formatUtils.ts`, `Format.ts`, `format-util.ts`

**함수명**: 동사 + 명사 (camelCase)
- ✅ `formatDate()`, `validateEmail()`, `debounce()`
- ❌ `dateFormat()`, `email_validation()`, `Debounce()`

## 💡 코드 예제와 사용 패턴

### 1. 날짜 포맷팅

```typescript
// utils/date.ts
export function formatDate(
  date: Date | string,
  format: 'short' | 'long' | 'iso' = 'short'
): string {
  const d = typeof date === 'string' ? new Date(date) : date;

  switch (format) {
    case 'short':
      return d.toLocaleDateString('ko-KR');
    case 'long':
      return d.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: 'long',
        day: 'numeric',
      });
    case 'iso':
      return d.toISOString();
    default:
      return d.toLocaleDateString();
  }
}

export function getRelativeTime(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date;
  const now = new Date();
  const diff = now.getTime() - d.getTime();

  const seconds = Math.floor(diff / 1000);
  const minutes = Math.floor(seconds / 60);
  const hours = Math.floor(minutes / 60);
  const days = Math.floor(hours / 24);

  if (days > 0) return `${days}일 전`;
  if (hours > 0) return `${hours}시간 전`;
  if (minutes > 0) return `${minutes}분 전`;
  return '방금 전';
}
```

**사용법**:
```typescript
import { formatDate, getRelativeTime } from '@/utils';

formatDate(new Date(), 'short'); // "2025. 1. 5."
formatDate(new Date(), 'long');  // "2025년 1월 5일"
getRelativeTime('2025-01-05T10:00:00'); // "2시간 전"
```

### 2. 유효성 검증

```typescript
// utils/validation.ts
export function validateEmail(email: string): boolean {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
}

export function validatePhone(phone: string): boolean {
  // 한국 전화번호 형식: 010-1234-5678 또는 01012345678
  const phoneRegex = /^01[0-9]-?[0-9]{3,4}-?[0-9]{4}$/;
  return phoneRegex.test(phone);
}

export function validatePassword(password: string): {
  isValid: boolean;
  errors: string[];
} {
  const errors: string[] = [];

  if (password.length < 8) {
    errors.push('비밀번호는 최소 8자 이상이어야 합니다');
  }
  if (!/[A-Z]/.test(password)) {
    errors.push('대문자를 포함해야 합니다');
  }
  if (!/[a-z]/.test(password)) {
    errors.push('소문자를 포함해야 합니다');
  }
  if (!/[0-9]/.test(password)) {
    errors.push('숫자를 포함해야 합니다');
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
}
```

**사용법**:
```typescript
import { validateEmail, validatePassword } from '@/utils';

validateEmail('test@example.com'); // true
validateEmail('invalid-email'); // false

const { isValid, errors } = validatePassword('weak');
// { isValid: false, errors: ['비밀번호는 최소 8자 이상...', ...] }
```

### 3. 디바운스 & 쓰로틀

```typescript
// utils/performance.ts
export function debounce<T extends (...args: any[]) => any>(
  func: T,
  delay: number = 300
): (...args: Parameters<T>) => void {
  let timeoutId: NodeJS.Timeout;

  return (...args: Parameters<T>) => {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func(...args), delay);
  };
}

export function throttle<T extends (...args: any[]) => any>(
  func: T,
  limit: number = 300
): (...args: Parameters<T>) => void {
  let inThrottle: boolean;

  return (...args: Parameters<T>) => {
    if (!inThrottle) {
      func(...args);
      inThrottle = true;
      setTimeout(() => (inThrottle = false), limit);
    }
  };
}
```

**사용법**:
```typescript
import { debounce, throttle } from '@/utils';

const searchAPI = debounce((query: string) => {
  console.log('Searching:', query);
}, 500);

const handleScroll = throttle(() => {
  console.log('Scrolling...');
}, 100);
```

### 4. 배열 유틸리티

```typescript
// utils/array.ts
export function uniqueBy<T>(array: T[], key: keyof T): T[] {
  const seen = new Set();
  return array.filter((item) => {
    const value = item[key];
    if (seen.has(value)) {
      return false;
    }
    seen.add(value);
    return true;
  });
}

export function groupBy<T>(array: T[], key: keyof T): Record<string, T[]> {
  return array.reduce((result, item) => {
    const group = String(item[key]);
    if (!result[group]) {
      result[group] = [];
    }
    result[group].push(item);
    return result;
  }, {} as Record<string, T[]>);
}

export function chunk<T>(array: T[], size: number): T[][] {
  const chunks: T[][] = [];
  for (let i = 0; i < array.length; i += size) {
    chunks.push(array.slice(i, i + size));
  }
  return chunks;
}
```

**사용법**:
```typescript
import { uniqueBy, groupBy, chunk } from '@/utils';

const users = [
  { id: 1, name: 'Alice' },
  { id: 2, name: 'Bob' },
  { id: 1, name: 'Alice' }, // 중복
];

uniqueBy(users, 'id'); // [{ id: 1, ... }, { id: 2, ... }]

const grouped = groupBy(users, 'name');
// { 'Alice': [{ id: 1, ... }, { id: 1, ... }], 'Bob': [{ id: 2, ... }] }

chunk([1, 2, 3, 4, 5], 2); // [[1, 2], [3, 4], [5]]
```

### 5. 문자열 유틸리티

```typescript
// utils/string.ts
export function capitalize(str: string): string {
  return str.charAt(0).toUpperCase() + str.slice(1).toLowerCase();
}

export function truncate(str: string, maxLength: number): string {
  if (str.length <= maxLength) return str;
  return str.slice(0, maxLength - 3) + '...';
}

export function slugify(str: string): string {
  return str
    .toLowerCase()
    .trim()
    .replace(/[^\w\s-]/g, '')
    .replace(/[\s_-]+/g, '-')
    .replace(/^-+|-+$/g, '');
}
```

**사용법**:
```typescript
import { capitalize, truncate, slugify } from '@/utils';

capitalize('hello world'); // "Hello world"
truncate('Long text here', 10); // "Long te..."
slugify('Hello World! 123'); // "hello-world-123"
```

## ✅ 베스트 프랙티스

1. **순수 함수**: 사이드 이펙트 없이 같은 입력에 같은 출력
2. **단일 책임**: 하나의 함수는 하나의 일만 수행
3. **타입 안전성**: TypeScript Generic과 타입 추론 활용
4. **테스트 가능성**: 순수 함수이므로 테스트 용이
5. **문서화**: JSDoc으로 사용법과 예제 제공

## 🚫 안티 패턴

```typescript
// ❌ Bad: 사이드 이펙트 있음
function formatUser(user: User) {
  user.name = user.name.toUpperCase(); // 원본 수정
  return user;
}

// ✅ Good: 순수 함수
function formatUser(user: User): User {
  return {
    ...user,
    name: user.name.toUpperCase(),
  };
}

// ❌ Bad: 너무 많은 책임
function validateAndFormatAndSave(data: any) {
  // 검증 + 포맷팅 + 저장
}

// ✅ Good: 분리된 책임
function validate(data: any): boolean { /* ... */ }
function format(data: any): any { /* ... */ }
function save(data: any): Promise<void> { /* ... */ }
```

## 📚 추천 리소스

- [date-fns](https://date-fns.org/) - 날짜 처리 라이브러리
- [validator.js](https://github.com/validatorjs/validator.js) - 유효성 검증 라이브러리
