---
name: mock-data-generator
description: Generate realistic mock data for testing with Faker.js and JSON Schema
version: 1.0.0
author: QA Team <qa@company.com>
category: quality
tags: [mock, faker, test-data, json-schema, fixtures]
status: stable
allowed-tools: [Write, Read]
triggers:
  - "목 데이터 생성"
  - "테스트 데이터"
  - "generate mock data"
  - "create fixtures"
  - "fake data"
dependencies: []
---

# Mock Data Generator

## 목적

테스트를 위한 현실적인 모의 데이터를 자동으로 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 테스트용 데이터 필요 시
- API 모킹 데이터
- 프로토타입/데모 데이터

### ❌ 이 스킬을 사용하지 않을 때

- 프로덕션 데이터 생성
- 실제 사용자 데이터 필요 시

## 작동 방식

1. **스키마 분석**: TypeScript 타입 또는 JSON Schema
2. **데이터 생성**: Faker.js로 현실적 데이터
3. **관계 설정**: 외래 키, 연관 데이터
4. **파일 저장**: JSON, TypeScript 상수

## 예제

### 예제 1: User 모의 데이터

**타입 정의:**
```typescript
interface User {
  id: string;
  name: string;
  email: string;
  age: number;
  createdAt: Date;
}
```

**생성되는 Mock:**
```typescript
// mocks/users.ts
import { faker } from '@faker-js/faker';

export const mockUsers: User[] = Array.from({ length: 10 }, (_, i) => ({
  id: faker.string.uuid(),
  name: faker.person.fullName(),
  email: faker.internet.email(),
  age: faker.number.int({ min: 18, max: 80 }),
  createdAt: faker.date.past(),
}));

export const mockUser: User = {
  id: '123e4567-e89b-12d3-a456-426614174000',
  name: 'John Doe',
  email: 'john.doe@example.com',
  age: 30,
  createdAt: new Date('2023-01-01'),
};
```

### 예제 2: API Response Mock

```typescript
// mocks/api/products.ts
import { rest } from 'msw';
import { faker } from '@faker-js/faker';

export const mockProducts = Array.from({ length: 50 }, () => ({
  id: faker.string.uuid(),
  name: faker.commerce.productName(),
  description: faker.commerce.productDescription(),
  price: Number(faker.commerce.price()),
  category: faker.commerce.department(),
  inStock: faker.datatype.boolean(),
  image: faker.image.url(),
}));

// MSW Handler
export const productsHandler = rest.get('/api/products', (req, res, ctx) => {
  return res(ctx.status(200), ctx.json(mockProducts));
});
```

### 예제 3: JSON Schema 기반 생성

**JSON Schema:**
```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "id": { "type": "string", "format": "uuid" },
    "username": { "type": "string", "minLength": 3 },
    "email": { "type": "string", "format": "email" },
    "age": { "type": "integer", "minimum": 18, "maximum": 100 }
  }
}
```

**생성되는 데이터:**
```json
[
  {
    "id": "f47ac10b-58cc-4372-a567-0e02b2c3d479",
    "username": "johndoe",
    "email": "john@example.com",
    "age": 25
  },
  {
    "id": "550e8400-e29b-41d4-a716-446655440000",
    "username": "janedoe",
    "email": "jane@example.com",
    "age": 32
  }
]
```

## 설정

`.skillconfig.json`:
```json
{
  "mockDataGenerator": {
    "locale": "ko",
    "seed": 123,
    "count": 10,
    "format": "typescript",
    "outputDir": "mocks"
  }
}
```

## 의존성

```json
{
  "@faker-js/faker": "^8.0.0",
  "json-schema-faker": "^0.5.0",
  "msw": "^2.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
