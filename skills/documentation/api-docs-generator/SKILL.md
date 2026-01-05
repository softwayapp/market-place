---
name: api-docs-generator
description: Generate API documentation from OpenAPI/Swagger specs or code comments
version: 1.4.0
author: Documentation Team <docs@company.com>
category: documentation
tags: [api, openapi, swagger, documentation, rest]
status: stable
allowed-tools: [Read, Write, Grep, Bash]
triggers:
  - "API 문서 생성"
  - "OpenAPI 문서"
  - "generate api docs"
  - "create swagger"
  - "api documentation"
dependencies: []
---

# API Docs Generator

## 목적

코드 주석이나 타입 정의로부터 OpenAPI/Swagger API 문서를 자동 생성합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- RESTful API 문서화
- OpenAPI 3.0 스펙 생성
- Swagger UI 자동 설정

### ❌ 이 스킬을 사용하지 않을 때

- GraphQL 스키마 (다른 도구 사용)
- 비표준 API 프로토콜

## 작동 방식

1. **코드 분석**: 라우트, 컨트롤러, 타입 정의 스캔
2. **주석 파싱**: JSDoc, TypeScript 타입에서 정보 추출
3. **스펙 생성**: OpenAPI 3.0 YAML/JSON 생성
4. **UI 생성**: Swagger UI, ReDoc 설정

## 예제

### 예제 1: Express.js API 문서화

**원본 코드:**
```typescript
// controllers/user.controller.ts
import { Request, Response } from 'express';

/**
 * @openapi
 * /api/users:
 *   get:
 *     tags:
 *       - Users
 *     summary: Get all users
 *     description: Retrieve a list of all users
 *     responses:
 *       200:
 *         description: List of users
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/User'
 */
export const getUsers = async (req: Request, res: Response) => {
  const users = await User.findAll();
  res.json(users);
};

/**
 * @openapi
 * /api/users/{id}:
 *   get:
 *     tags:
 *       - Users
 *     summary: Get user by ID
 *     parameters:
 *       - name: id
 *         in: path
 *         required: true
 *         schema:
 *           type: string
 *           format: uuid
 *     responses:
 *       200:
 *         description: User details
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/User'
 *       404:
 *         description: User not found
 */
export const getUserById = async (req: Request, res: Response) => {
  const user = await User.findByPk(req.params.id);
  if (!user) return res.status(404).json({ error: 'User not found' });
  res.json(user);
};

/**
 * @openapi
 * /api/users:
 *   post:
 *     tags:
 *       - Users
 *     summary: Create new user
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             $ref: '#/components/schemas/CreateUserDto'
 *     responses:
 *       201:
 *         description: User created successfully
 *       400:
 *         description: Validation error
 */
export const createUser = async (req: Request, res: Response) => {
  const user = await User.create(req.body);
  res.status(201).json(user);
};
```

**생성되는 OpenAPI 스펙:**
```yaml
# openapi.yaml
openapi: 3.0.3
info:
  title: My API
  version: 1.0.0
  description: API documentation for My Application
  contact:
    name: API Support
    email: api@company.com

servers:
  - url: http://localhost:3000
    description: Development server
  - url: https://api.example.com
    description: Production server

tags:
  - name: Users
    description: User management endpoints

paths:
  /api/users:
    get:
      tags:
        - Users
      summary: Get all users
      description: Retrieve a list of all users
      responses:
        '200':
          description: List of users
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/User'

    post:
      tags:
        - Users
      summary: Create new user
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/CreateUserDto'
      responses:
        '201':
          description: User created successfully
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '400':
          description: Validation error
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

  /api/users/{id}:
    get:
      tags:
        - Users
      summary: Get user by ID
      parameters:
        - name: id
          in: path
          required: true
          schema:
            type: string
            format: uuid
      responses:
        '200':
          description: User details
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/User'
        '404':
          description: User not found
          content:
            application/json:
              schema:
                $ref: '#/components/schemas/Error'

components:
  schemas:
    User:
      type: object
      properties:
        id:
          type: string
          format: uuid
          example: "123e4567-e89b-12d3-a456-426614174000"
        email:
          type: string
          format: email
          example: "user@example.com"
        name:
          type: string
          example: "John Doe"
        createdAt:
          type: string
          format: date-time
      required:
        - id
        - email
        - name

    CreateUserDto:
      type: object
      properties:
        email:
          type: string
          format: email
        name:
          type: string
          minLength: 2
          maxLength: 100
        password:
          type: string
          minLength: 8
      required:
        - email
        - name
        - password

    Error:
      type: object
      properties:
        error:
          type: string
        message:
          type: string
        statusCode:
          type: integer
```

### 예제 2: Swagger UI 설정

**생성되는 swagger.ts:**
```typescript
// src/swagger.ts
import swaggerJsdoc from 'swagger-jsdoc';
import swaggerUi from 'swagger-ui-express';
import { Express } from 'express';

const options = {
  definition: {
    openapi: '3.0.3',
    info: {
      title: 'My API',
      version: '1.0.0',
      description: 'API documentation for My Application',
      contact: {
        name: 'API Support',
        email: 'api@company.com',
      },
    },
    servers: [
      {
        url: 'http://localhost:3000',
        description: 'Development server',
      },
      {
        url: 'https://api.example.com',
        description: 'Production server',
      },
    ],
  },
  apis: ['./src/controllers/*.ts', './src/routes/*.ts'],
};

const swaggerSpec = swaggerJsdoc(options);

export const setupSwagger = (app: Express) => {
  // Swagger UI
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec, {
    customCss: '.swagger-ui .topbar { display: none }',
    customSiteTitle: 'My API Documentation',
  }));

  // JSON spec endpoint
  app.get('/api-docs.json', (req, res) => {
    res.setHeader('Content-Type', 'application/json');
    res.send(swaggerSpec);
  });

  console.log('📚 Swagger UI available at http://localhost:3000/api-docs');
};
```

### 예제 3: NestJS API 문서화

**생성되는 main.ts:**
```typescript
// src/main.ts
import { NestFactory } from '@nestjs/core';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  const config = new DocumentBuilder()
    .setTitle('My API')
    .setDescription('API documentation for My Application')
    .setVersion('1.0')
    .addTag('users', 'User management endpoints')
    .addTag('auth', 'Authentication endpoints')
    .addBearerAuth()
    .addServer('http://localhost:3000', 'Development')
    .addServer('https://api.example.com', 'Production')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api-docs', app, document, {
    customSiteTitle: 'My API Documentation',
    customCss: '.swagger-ui .topbar { display: none }',
  });

  await app.listen(3000);
  console.log('📚 API Documentation: http://localhost:3000/api-docs');
}
bootstrap();
```

**컨트롤러 예제:**
```typescript
// src/users/users.controller.ts
import { Controller, Get, Post, Body, Param } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse, ApiParam } from '@nestjs/swagger';
import { UsersService } from './users.service';
import { CreateUserDto } from './dto/create-user.dto';
import { User } from './entities/user.entity';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get()
  @ApiOperation({ summary: 'Get all users' })
  @ApiResponse({
    status: 200,
    description: 'List of users',
    type: [User],
  })
  findAll(): Promise<User[]> {
    return this.usersService.findAll();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiParam({ name: 'id', type: 'string', format: 'uuid' })
  @ApiResponse({
    status: 200,
    description: 'User details',
    type: User,
  })
  @ApiResponse({ status: 404, description: 'User not found' })
  findOne(@Param('id') id: string): Promise<User> {
    return this.usersService.findOne(id);
  }

  @Post()
  @ApiOperation({ summary: 'Create new user' })
  @ApiResponse({
    status: 201,
    description: 'User created successfully',
    type: User,
  })
  @ApiResponse({ status: 400, description: 'Validation error' })
  create(@Body() createUserDto: CreateUserDto): Promise<User> {
    return this.usersService.create(createUserDto);
  }
}
```

### 예제 4: TypeScript 타입에서 스키마 생성

**타입 정의:**
```typescript
// types/user.ts
export interface User {
  /** Unique identifier */
  id: string;

  /** User's email address */
  email: string;

  /** User's full name */
  name: string;

  /** User's role */
  role: 'admin' | 'user' | 'guest';

  /** Account creation timestamp */
  createdAt: Date;

  /** Last update timestamp */
  updatedAt?: Date;
}

export interface CreateUserDto {
  /** Email address (must be unique) */
  email: string;

  /** Full name (2-100 characters) */
  name: string;

  /** Password (minimum 8 characters) */
  password: string;

  /** User role (defaults to 'user') */
  role?: 'admin' | 'user' | 'guest';
}
```

**자동 생성되는 스키마:**
```yaml
components:
  schemas:
    User:
      type: object
      description: User entity
      properties:
        id:
          type: string
          description: Unique identifier
        email:
          type: string
          format: email
          description: User's email address
        name:
          type: string
          description: User's full name
        role:
          type: string
          enum: [admin, user, guest]
          description: User's role
        createdAt:
          type: string
          format: date-time
          description: Account creation timestamp
        updatedAt:
          type: string
          format: date-time
          description: Last update timestamp
      required:
        - id
        - email
        - name
        - role
        - createdAt
```

## 설정

`.skillconfig.json`:
```json
{
  "apiDocsGenerator": {
    "format": "openapi-3.0",
    "outputPath": "docs/openapi.yaml",
    "uiFramework": "swagger-ui",
    "includeExamples": true,
    "securitySchemes": ["bearer", "apiKey"],
    "servers": [
      {
        "url": "http://localhost:3000",
        "description": "Development"
      },
      {
        "url": "https://api.example.com",
        "description": "Production"
      }
    ]
  }
}
```

## 의존성

```json
{
  "swagger-jsdoc": "^6.2.0",
  "swagger-ui-express": "^5.0.0",
  "@nestjs/swagger": "^7.0.0"
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
