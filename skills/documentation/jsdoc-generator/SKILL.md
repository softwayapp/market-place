---
name: jsdoc-generator
description: Generate comprehensive JSDoc/TSDoc documentation for code
version: 1.1.0
author: Documentation Team <docs@company.com>
category: documentation
tags: [jsdoc, tsdoc, documentation, api, comments]
status: stable
allowed-tools: [Read, Write, Edit, Grep]
triggers:
  - "JSDoc 생성"
  - "코드 문서화"
  - "generate jsdoc"
  - "add documentation"
  - "document code"
dependencies: []
---

# JSDoc Generator

## 목적

함수, 클래스, 타입 정의에 대한 JSDoc/TSDoc 주석을 자동 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 함수/클래스에 문서 주석 추가
- TypeScript 타입에서 JSDoc 생성
- API 문서화 자동화

### ❌ 이 스킬을 사용하지 않을 때

- 이미 충분한 주석이 있는 코드
- 내부 헬퍼 함수 (문서화 불필요)

## 작동 방식

1. **코드 분석**: 함수 시그니처, 파라미터, 반환 타입 추출
2. **JSDoc 생성**: 표준 JSDoc 형식으로 주석 생성
3. **예제 추가**: 사용 예제 자동 생성
4. **타입 정보**: TypeScript 타입 정보 포함

## 예제

### 예제 1: 함수 문서화

**원본 코드:**
```typescript
function calculateTotal(items: CartItem[], taxRate: number): number {
  const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  return subtotal * (1 + taxRate);
}
```

**JSDoc 추가 후:**
```typescript
/**
 * Calculate the total price including tax for a cart of items
 *
 * @param {CartItem[]} items - Array of cart items to calculate total for
 * @param {number} taxRate - Tax rate as a decimal (e.g., 0.1 for 10%)
 * @returns {number} Total price including tax
 *
 * @example
 * const items = [
 *   { name: 'Product A', price: 100, quantity: 2 },
 *   { name: 'Product B', price: 50, quantity: 1 }
 * ];
 * const total = calculateTotal(items, 0.1); // 275
 *
 * @throws {Error} When items array is empty
 * @throws {Error} When taxRate is negative
 */
function calculateTotal(items: CartItem[], taxRate: number): number {
  if (items.length === 0) {
    throw new Error('Items array cannot be empty');
  }
  if (taxRate < 0) {
    throw new Error('Tax rate cannot be negative');
  }

  const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
  return subtotal * (1 + taxRate);
}
```

### 예제 2: 클래스 문서화

**원본 코드:**
```typescript
class UserManager {
  private users: Map<string, User> = new Map();

  addUser(user: User): void {
    this.users.set(user.id, user);
  }

  getUser(id: string): User | undefined {
    return this.users.get(id);
  }

  deleteUser(id: string): boolean {
    return this.users.delete(id);
  }
}
```

**JSDoc 추가 후:**
```typescript
/**
 * Manages user data and operations
 *
 * @class UserManager
 * @description Provides methods for adding, retrieving, and deleting users
 *
 * @example
 * const manager = new UserManager();
 * manager.addUser({ id: '123', name: 'John Doe' });
 * const user = manager.getUser('123');
 */
class UserManager {
  /**
   * Internal storage for user data
   * @private
   * @type {Map<string, User>}
   */
  private users: Map<string, User> = new Map();

  /**
   * Add a new user to the manager
   *
   * @param {User} user - The user object to add
   * @returns {void}
   *
   * @example
   * manager.addUser({
   *   id: '123',
   *   name: 'John Doe',
   *   email: 'john@example.com'
   * });
   *
   * @throws {Error} When user with same ID already exists
   */
  addUser(user: User): void {
    if (this.users.has(user.id)) {
      throw new Error(`User with ID ${user.id} already exists`);
    }
    this.users.set(user.id, user);
  }

  /**
   * Retrieve a user by their ID
   *
   * @param {string} id - The unique identifier of the user
   * @returns {User | undefined} The user object if found, undefined otherwise
   *
   * @example
   * const user = manager.getUser('123');
   * if (user) {
   *   console.log(user.name);
   * }
   */
  getUser(id: string): User | undefined {
    return this.users.get(id);
  }

  /**
   * Delete a user from the manager
   *
   * @param {string} id - The unique identifier of the user to delete
   * @returns {boolean} True if user was deleted, false if user was not found
   *
   * @example
   * const deleted = manager.deleteUser('123');
   * console.log(deleted ? 'User deleted' : 'User not found');
   */
  deleteUser(id: string): boolean {
    return this.users.delete(id);
  }
}
```

### 예제 3: 비동기 함수 문서화

**원본 코드:**
```typescript
async function fetchUserData(userId: string, options?: FetchOptions): Promise<UserData> {
  const response = await fetch(`/api/users/${userId}`, options);
  if (!response.ok) throw new Error('Failed to fetch user');
  return response.json();
}
```

**JSDoc 추가 후:**
```typescript
/**
 * Fetch user data from the API
 *
 * @async
 * @param {string} userId - The unique identifier of the user to fetch
 * @param {FetchOptions} [options] - Optional fetch configuration
 * @param {number} [options.timeout=5000] - Request timeout in milliseconds
 * @param {boolean} [options.cache=true] - Whether to use cached data
 * @returns {Promise<UserData>} Promise resolving to user data
 *
 * @example
 * // Basic usage
 * const user = await fetchUserData('user123');
 *
 * @example
 * // With options
 * const user = await fetchUserData('user123', {
 *   timeout: 3000,
 *   cache: false
 * });
 *
 * @throws {Error} When the API request fails
 * @throws {Error} When userId is invalid or empty
 *
 * @see {@link https://api.example.com/docs|API Documentation}
 */
async function fetchUserData(userId: string, options?: FetchOptions): Promise<UserData> {
  if (!userId || userId.trim() === '') {
    throw new Error('User ID is required');
  }

  const response = await fetch(`/api/users/${userId}`, options);

  if (!response.ok) {
    throw new Error(`Failed to fetch user: ${response.statusText}`);
  }

  return response.json();
}
```

### 예제 4: 타입 정의 문서화

**원본 코드:**
```typescript
type User = {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'user' | 'guest';
  createdAt: Date;
  settings?: UserSettings;
};

interface UserSettings {
  theme: 'light' | 'dark';
  notifications: boolean;
  language: string;
}
```

**JSDoc 추가 후:**
```typescript
/**
 * Represents a user in the system
 *
 * @typedef {Object} User
 * @property {string} id - Unique identifier (UUID format)
 * @property {string} email - User's email address (must be unique)
 * @property {string} name - User's full name
 * @property {'admin' | 'user' | 'guest'} role - User's role in the system
 * @property {Date} createdAt - Account creation timestamp
 * @property {UserSettings} [settings] - Optional user preferences
 *
 * @example
 * const user: User = {
 *   id: '123e4567-e89b-12d3-a456-426614174000',
 *   email: 'john@example.com',
 *   name: 'John Doe',
 *   role: 'user',
 *   createdAt: new Date(),
 *   settings: {
 *     theme: 'dark',
 *     notifications: true,
 *     language: 'en'
 *   }
 * };
 */
type User = {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'user' | 'guest';
  createdAt: Date;
  settings?: UserSettings;
};

/**
 * User-specific settings and preferences
 *
 * @interface UserSettings
 * @property {'light' | 'dark'} theme - UI theme preference
 * @property {boolean} notifications - Whether to enable notifications
 * @property {string} language - Preferred language (ISO 639-1 code)
 *
 * @example
 * const settings: UserSettings = {
 *   theme: 'dark',
 *   notifications: true,
 *   language: 'en'
 * };
 */
interface UserSettings {
  theme: 'light' | 'dark';
  notifications: boolean;
  language: string;
}
```

### 예제 5: React 컴포넌트 문서화

**원본 코드:**
```tsx
interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  onClick?: () => void;
}

export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  disabled = false,
  onClick,
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size}`}
      disabled={disabled}
      onClick={onClick}
    >
      {children}
    </button>
  );
};
```

**JSDoc 추가 후:**
```tsx
/**
 * Props for the Button component
 *
 * @interface ButtonProps
 * @property {React.ReactNode} children - Button content
 * @property {'primary' | 'secondary' | 'outline'} [variant='primary'] - Visual style variant
 * @property {'small' | 'medium' | 'large'} [size='medium'] - Button size
 * @property {boolean} [disabled=false] - Whether the button is disabled
 * @property {() => void} [onClick] - Click event handler
 */
interface ButtonProps {
  children: React.ReactNode;
  variant?: 'primary' | 'secondary' | 'outline';
  size?: 'small' | 'medium' | 'large';
  disabled?: boolean;
  onClick?: () => void;
}

/**
 * A reusable button component with multiple variants and sizes
 *
 * @component
 * @param {ButtonProps} props - Component props
 * @returns {React.ReactElement} Rendered button element
 *
 * @example
 * // Primary button
 * <Button variant="primary" onClick={() => console.log('Clicked')}>
 *   Click Me
 * </Button>
 *
 * @example
 * // Large secondary button
 * <Button variant="secondary" size="large">
 *   Submit
 * </Button>
 *
 * @example
 * // Disabled outline button
 * <Button variant="outline" disabled>
 *   Disabled
 * </Button>
 */
export const Button: React.FC<ButtonProps> = ({
  children,
  variant = 'primary',
  size = 'medium',
  disabled = false,
  onClick,
}) => {
  return (
    <button
      className={`btn btn-${variant} btn-${size}`}
      disabled={disabled}
      onClick={onClick}
      aria-disabled={disabled}
    >
      {children}
    </button>
  );
};
```

### 예제 6: 복잡한 유틸리티 함수

**원본 코드:**
```typescript
function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout | null = null;

  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout);
    timeout = setTimeout(() => func(...args), wait);
  };
}
```

**JSDoc 추가 후:**
```typescript
/**
 * Creates a debounced function that delays invoking func until after wait milliseconds
 * have elapsed since the last time the debounced function was invoked
 *
 * @template T - The type of the function to debounce
 * @param {T} func - The function to debounce
 * @param {number} wait - The number of milliseconds to delay
 * @returns {(...args: Parameters<T>) => void} Returns the new debounced function
 *
 * @example
 * // Debounce search input
 * const handleSearch = debounce((query: string) => {
 *   console.log('Searching for:', query);
 * }, 300);
 *
 * input.addEventListener('input', (e) => {
 *   handleSearch(e.target.value);
 * });
 *
 * @example
 * // Debounce window resize
 * const handleResize = debounce(() => {
 *   console.log('Window resized to:', window.innerWidth);
 * }, 200);
 *
 * window.addEventListener('resize', handleResize);
 *
 * @see {@link https://lodash.com/docs#debounce|Lodash debounce}
 */
function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout | null = null;

  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout);
    timeout = setTimeout(() => func(...args), wait);
  };
}
```

## 설정

`.skillconfig.json`:
```json
{
  "jsdocGenerator": {
    "style": "jsdoc",
    "includeExamples": true,
    "includeTypes": true,
    "inferTypes": true,
    "generateForPrivate": false,
    "customTags": ["category", "package"],
    "exampleFormat": "typescript"
  }
}
```

## 의존성

```json
{
  "jsdoc": "^4.0.0",
  "typedoc": "^0.25.0",
  "documentation": "^14.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
