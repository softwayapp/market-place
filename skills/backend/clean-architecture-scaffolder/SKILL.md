---
name: clean-architecture-scaffolder
description: Generate complete Clean Architecture project structure for NestJS with 4-layer separation (API, Application, Domain, Infrastructure)
version: 1.0.0
author: Backend Team <backend@company.com>
category: backend
tags: [clean-architecture, scaffolding, ddd, nestjs, project-structure]
status: stable
allowed-tools: [Read, Write, Edit, Grep, Bash]
triggers:
  - "Clean Architecture 생성"
  - "프로젝트 구조 생성"
  - "4-layer 구조"
  - "generate clean architecture"
  - "scaffold project"
  - "create project structure"
dependencies: []
---

# Clean Architecture Scaffolder

## 목적

NestJS 프로젝트를 위한 Clean Architecture 4-Layer 구조를 자동으로 생성합니다. API, Application, Domain, Infrastructure 레이어를 명확히 분리하여 확장 가능하고 유지보수하기 쉬운 코드베이스를 구축합니다.

## 🎯 2025 Best Practices 반영

- ✅ **4-Layer Architecture**: API/Application/Domain/Infrastructure 분리
- ✅ **CQRS Integration**: Command/Query 패턴 통합
- ✅ **Repository Pattern**: 데이터 접근 추상화
- ✅ **Dependency Inversion**: 올바른 의존성 방향
- ✅ **Domain-Driven Design**: 순수한 비즈니스 로직
- ✅ **Test Structure**: 레이어별 테스트 구조

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새로운 NestJS 프로젝트 시작
- 기존 프로젝트를 Clean Architecture로 마이그레이션
- 엔터프라이즈급 확장 가능한 구조 필요
- 명확한 레이어 분리로 유지보수성 향상
- 팀의 아키텍처 표준 수립

### ❌ 이 스킬을 사용하지 않을 때

- 단순한 프로토타입이나 MVP
- 소규모 프로젝트 (< 5개 엔드포인트)
- Clean Architecture가 과도한 경우
- Express.js나 다른 프레임워크

## 작동 방식

1. **프로젝트 분석**: 기존 구조 확인
2. **디렉토리 생성**: 4-Layer 구조 생성
3. **템플릿 파일 생성**: 각 레이어별 예제 파일
4. **모듈 설정**: NestJS 모듈 구성
5. **문서 생성**: 아키텍처 가이드 문서

## 예제

### 예제 1: 전체 프로젝트 구조 생성

**사용자 입력:**
```
"Clean Architecture 구조로 새 프로젝트 생성해줘"
```

**생성되는 디렉토리 구조:**

```
src/
├── api/                          # API Layer (진입점)
│   ├── user/
│   │   ├── user.controller.ts   # HTTP Controller
│   │   ├── user.module.ts       # NestJS Module
│   │   └── dto/
│   │       ├── create-user.dto.ts
│   │       ├── update-user.dto.ts
│   │       └── user-response.dto.ts
│   ├── product/
│   └── order/
│
├── application/                  # Application Layer (오케스트레이션)
│   ├── user/
│   │   ├── command/             # Write Operations
│   │   │   ├── create-user.command.ts
│   │   │   ├── create-user.handler.ts
│   │   │   ├── update-user.command.ts
│   │   │   └── update-user.handler.ts
│   │   ├── query/               # Read Operations
│   │   │   ├── get-user.query.ts
│   │   │   ├── get-user.handler.ts
│   │   │   ├── get-users.query.ts
│   │   │   └── get-users.handler.ts
│   │   └── event/               # Domain Events
│   │       ├── user-created.event.ts
│   │       ├── user-created.handler.ts
│   │       └── user-updated.event.ts
│   ├── product/
│   └── order/
│
├── domain/                       # Domain Layer (비즈니스 로직)
│   ├── user/
│   │   ├── entity/              # Domain Entities
│   │   │   └── user.entity.ts
│   │   ├── repository/          # Repository Interfaces
│   │   │   └── user.repository.interface.ts
│   │   ├── service/             # Domain Services
│   │   │   └── user-domain.service.ts
│   │   └── value-object/        # Value Objects
│   │       └── email.value-object.ts
│   ├── product/
│   └── order/
│
├── infrastructure/               # Infrastructure Layer (기술 구현)
│   ├── database/
│   │   ├── entity/              # ORM Entities (TypeORM/Prisma)
│   │   │   ├── user.entity.ts
│   │   │   ├── product.entity.ts
│   │   │   └── order.entity.ts
│   │   ├── repository/          # Repository Implementations
│   │   │   ├── user.repository.impl.ts
│   │   │   ├── product.repository.impl.ts
│   │   │   └── order.repository.impl.ts
│   │   ├── migration/           # Database Migrations
│   │   └── seed/                # Seed Data
│   ├── config/                  # Configuration
│   │   ├── database.config.ts
│   │   ├── cache.config.ts
│   │   └── app.config.ts
│   ├── logger/                  # Logging
│   │   └── winston.config.ts
│   └── external/                # External Services
│       ├── email/
│       └── payment/
│
├── shared/                       # Shared (공통 모듈)
│   ├── decorators/
│   ├── filters/
│   ├── guards/
│   ├── interceptors/
│   ├── pipes/
│   └── utils/
│
└── test/                         # Tests
    ├── unit/
    ├── integration/
    └── e2e/
```

### 예제 2: User 모듈 완전한 예제

#### 1. API Layer (Controller & DTO)

**api/user/user.controller.ts**
```typescript
import { Controller, Get, Post, Put, Delete, Body, Param, UseGuards } from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { CreateUserDto, UpdateUserDto, UserResponseDto } from './dto';
import { CreateUserCommand } from '../../application/user/command/create-user.command';
import { GetUserQuery } from '../../application/user/query/get-user.query';
import { JwtAuthGuard } from '../../shared/guards/jwt-auth.guard';

@ApiTags('users')
@Controller('users')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class UserController {
  constructor(
    private readonly commandBus: CommandBus,
    private readonly queryBus: QueryBus,
  ) {}

  @Post()
  @ApiOperation({ summary: 'Create new user' })
  async create(@Body() dto: CreateUserDto): Promise<UserResponseDto> {
    return this.commandBus.execute(
      new CreateUserCommand(dto.email, dto.name, dto.role),
    );
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  async findOne(@Param('id') id: string): Promise<UserResponseDto> {
    return this.queryBus.execute(new GetUserQuery(id));
  }
}
```

#### 2. Application Layer (CQRS Handlers)

**application/user/command/create-user.handler.ts**
```typescript
import { CommandHandler, ICommandHandler, EventBus } from '@nestjs/cqrs';
import { Injectable } from '@nestjs/common';
import { CreateUserCommand } from './create-user.command';
import { IUserRepository } from '../../../domain/user/repository/user.repository.interface';
import { User } from '../../../domain/user/entity/user.entity';
import { UserCreatedEvent } from '../event/user-created.event';
import { UserAlreadyExistsException } from '../../../shared/exceptions/domain-exceptions';

@Injectable()
@CommandHandler(CreateUserCommand)
export class CreateUserHandler implements ICommandHandler<CreateUserCommand> {
  constructor(
    private readonly userRepository: IUserRepository,
    private readonly eventBus: EventBus,
  ) {}

  async execute(command: CreateUserCommand): Promise<User> {
    // Business validation
    const existing = await this.userRepository.findByEmail(command.email);
    if (existing) {
      throw new UserAlreadyExistsException(command.email);
    }

    // Create domain entity
    const user = new User(command.email, command.name, command.role);

    // Persist
    const savedUser = await this.userRepository.save(user);

    // Publish event
    this.eventBus.publish(new UserCreatedEvent(savedUser.id, savedUser.email));

    return savedUser;
  }
}
```

#### 3. Domain Layer (Pure Business Logic)

**domain/user/entity/user.entity.ts**
```typescript
import { Email } from '../value-object/email.value-object';

export class User {
  constructor(
    public readonly email: string,
    public readonly name: string,
    public readonly role: string,
    public readonly id?: string,
    public readonly createdAt?: Date,
    public readonly updatedAt?: Date,
  ) {
    this.validateEmail(email);
    this.validateName(name);
  }

  // Domain logic methods
  isAdmin(): boolean {
    return this.role === 'admin';
  }

  canEditUser(targetUser: User): boolean {
    return this.isAdmin() || this.id === targetUser.id;
  }

  updateProfile(name: string, role: string): User {
    this.validateName(name);

    return new User(
      this.email,
      name,
      role,
      this.id,
      this.createdAt,
      new Date(),
    );
  }

  // Private validation methods
  private validateEmail(email: string): void {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      throw new Error('Invalid email format');
    }
  }

  private validateName(name: string): void {
    if (!name || name.length < 2) {
      throw new Error('Name must be at least 2 characters');
    }
  }
}
```

**domain/user/repository/user.repository.interface.ts**
```typescript
import { User } from '../entity/user.entity';

export interface IUserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  findAll(options: FindAllOptions): Promise<[User[], number]>;
  save(user: User): Promise<User>;
  update(id: string, user: Partial<User>): Promise<User>;
  delete(id: string): Promise<void>;
}

export const IUserRepository = Symbol('IUserRepository');

export interface FindAllOptions {
  page: number;
  limit: number;
  sort: string;
}
```

#### 4. Infrastructure Layer (Technical Implementation)

**infrastructure/database/repository/user.repository.impl.ts**
```typescript
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IUserRepository, FindAllOptions } from '../../../domain/user/repository/user.repository.interface';
import { User } from '../../../domain/user/entity/user.entity';
import { UserEntity } from '../entity/user.entity';

@Injectable()
export class UserRepositoryImpl implements IUserRepository {
  constructor(
    @InjectRepository(UserEntity)
    private readonly ormRepository: Repository<UserEntity>,
  ) {}

  async findById(id: string): Promise<User | null> {
    const entity = await this.ormRepository.findOne({ where: { id } });
    return entity ? this.toDomain(entity) : null;
  }

  async findByEmail(email: string): Promise<User | null> {
    const entity = await this.ormRepository.findOne({ where: { email } });
    return entity ? this.toDomain(entity) : null;
  }

  async findAll(options: FindAllOptions): Promise<[User[], number]> {
    const [entities, total] = await this.ormRepository.findAndCount({
      skip: (options.page - 1) * options.limit,
      take: options.limit,
      order: { createdAt: options.sort.startsWith('-') ? 'DESC' : 'ASC' },
    });

    return [entities.map(e => this.toDomain(e)), total];
  }

  async save(user: User): Promise<User> {
    const entity = this.toEntity(user);
    const saved = await this.ormRepository.save(entity);
    return this.toDomain(saved);
  }

  async update(id: string, user: Partial<User>): Promise<User> {
    await this.ormRepository.update(id, user);
    const updated = await this.ormRepository.findOne({ where: { id } });
    return this.toDomain(updated);
  }

  async delete(id: string): Promise<void> {
    await this.ormRepository.delete(id);
  }

  // Mappers
  private toDomain(entity: UserEntity): User {
    return new User(
      entity.email,
      entity.name,
      entity.role,
      entity.id,
      entity.createdAt,
      entity.updatedAt,
    );
  }

  private toEntity(user: User): UserEntity {
    const entity = new UserEntity();
    entity.id = user.id;
    entity.email = user.email;
    entity.name = user.name;
    entity.role = user.role;
    return entity;
  }
}
```

### 예제 3: Module 구성

**api/user/user.module.ts**
```typescript
import { Module } from '@nestjs/common';
import { CqrsModule } from '@nestjs/cqrs';
import { TypeOrmModule } from '@nestjs/typeorm';
import { UserController } from './user.controller';
import { UserEntity } from '../../infrastructure/database/entity/user.entity';
import { UserRepositoryImpl } from '../../infrastructure/database/repository/user.repository.impl';
import { IUserRepository } from '../../domain/user/repository/user.repository.interface';

// Command Handlers
import { CreateUserHandler } from '../../application/user/command/create-user.handler';
import { UpdateUserHandler } from '../../application/user/command/update-user.handler';
import { DeleteUserHandler } from '../../application/user/command/delete-user.handler';

// Query Handlers
import { GetUserHandler } from '../../application/user/query/get-user.handler';
import { GetUsersHandler } from '../../application/user/query/get-users.handler';

// Event Handlers
import { UserCreatedHandler } from '../../application/user/event/user-created.handler';

const CommandHandlers = [CreateUserHandler, UpdateUserHandler, DeleteUserHandler];
const QueryHandlers = [GetUserHandler, GetUsersHandler];
const EventHandlers = [UserCreatedHandler];

@Module({
  imports: [
    CqrsModule,
    TypeOrmModule.forFeature([UserEntity]),
  ],
  controllers: [UserController],
  providers: [
    ...CommandHandlers,
    ...QueryHandlers,
    ...EventHandlers,
    {
      provide: IUserRepository,
      useClass: UserRepositoryImpl,
    },
  ],
  exports: [IUserRepository],
})
export class UserModule {}
```

### 예제 4: 아키텍처 문서 자동 생성

**docs/ARCHITECTURE.md**
```markdown
# Clean Architecture Guide

## Layer Overview

### 1. API Layer (src/api/)
**Purpose**: HTTP 진입점, 요청/응답 처리
**Dependencies**: Application Layer
**Prohibited**: Domain Layer 직접 접근, Infrastructure Layer 직접 접근

**Components**:
- Controllers: HTTP 요청 처리
- DTOs: 입력/출력 데이터 검증
- Guards: 인증/인가
- Interceptors: 로깅, 캐싱

### 2. Application Layer (src/application/)
**Purpose**: 비즈니스 로직 오케스트레이션
**Dependencies**: Domain Layer
**Prohibited**: Infrastructure Layer 구현체 직접 참조

**Components**:
- Commands: 쓰기 작업
- Queries: 읽기 작업
- Events: 도메인 이벤트
- Handlers: 비즈니스 로직 실행

### 3. Domain Layer (src/domain/)
**Purpose**: 순수한 비즈니스 로직
**Dependencies**: None (외부 의존성 없음)
**Prohibited**: 프레임워크 의존성, ORM, HTTP

**Components**:
- Entities: 비즈니스 엔티티
- Value Objects: 불변 값 객체
- Repository Interfaces: 데이터 접근 인터페이스
- Domain Services: 복잡한 비즈니스 로직

### 4. Infrastructure Layer (src/infrastructure/)
**Purpose**: 기술적 구현
**Dependencies**: Domain Layer (인터페이스)
**Prohibited**: Application Layer 직접 접근

**Components**:
- Database: ORM 엔티티, Repository 구현
- Config: 설정 파일
- External Services: 외부 API 연동
- Logger: 로깅 구현

## Dependency Flow

```
API Layer
    ↓ depends on
Application Layer
    ↓ depends on
Domain Layer (Interfaces)
    ↑ implemented by
Infrastructure Layer
```

## Testing Strategy

- **Unit Tests**: Domain Layer, Handlers
- **Integration Tests**: Repository, External Services
- **E2E Tests**: API Layer

## Best Practices

1. **Dependency Inversion**: Infrastructure가 Domain 인터페이스 구현
2. **No Circular Dependencies**: 레이어 간 순환 참조 금지
3. **Repository Pattern**: 모든 데이터 접근은 Repository 통과
4. **Pure Domain**: Domain Layer는 외부 의존성 없음
5. **CQRS**: 읽기/쓰기 분리로 확장성 확보
```

## 설정

**.skillconfig.json**
```json
{
  "cleanArchitectureScaffolder": {
    "projectRoot": "src",
    "layers": {
      "api": "src/api",
      "application": "src/application",
      "domain": "src/domain",
      "infrastructure": "src/infrastructure",
      "shared": "src/shared"
    },
    "features": {
      "cqrs": true,
      "eventDriven": true,
      "repository": true,
      "ddd": true
    },
    "orm": "typeorm",
    "generateDocs": true,
    "generateTests": true,
    "includeExamples": true
  }
}
```

## Clean Architecture 원칙

### 1. Dependency Rule
**의존성은 안쪽(Domain)을 향해야 함**

```
✅ Correct:
Infrastructure → Domain (Interface)
Application → Domain
API → Application

❌ Wrong:
Domain → Infrastructure
Domain → Application
Application → API
```

### 2. Layer Responsibilities

| Layer | Can Import | Cannot Import |
|-------|-----------|---------------|
| **API** | Application, Domain (types) | Infrastructure |
| **Application** | Domain | API, Infrastructure (implementation) |
| **Domain** | Nothing (순수) | API, Application, Infrastructure |
| **Infrastructure** | Domain (interface) | API, Application |

### 3. Entity vs Value Object

**Entity** (식별자 있음):
```typescript
class User {
  constructor(
    public readonly id: string, // 식별자
    public readonly email: string,
    public readonly name: string,
  ) {}
}
```

**Value Object** (식별자 없음):
```typescript
class Email {
  constructor(private readonly value: string) {
    this.validate();
  }

  private validate(): void {
    if (!this.value.includes('@')) {
      throw new Error('Invalid email');
    }
  }

  toString(): string {
    return this.value;
  }
}
```

## 의존성

```json
{
  "@nestjs/common": "^10.0.0",
  "@nestjs/core": "^10.0.0",
  "@nestjs/cqrs": "^10.0.0",
  "@nestjs/typeorm": "^10.0.0",
  "typeorm": "^0.3.0"
}
```

## 버전 이력

### 1.0.0 (2025-01-05) - Initial Release
- 4-Layer 구조 자동 생성
- CQRS 패턴 통합
- Repository Pattern 구현
- 아키텍처 문서 자동 생성
- 예제 코드 포함

## 참고 자료

- [Clean Architecture (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [NestJS Clean Architecture Template](https://github.com/CollatzConjecture/nestjs-clean-architecture)
- [Domain-Driven Design (Eric Evans)](https://www.domainlanguage.com/ddd/)
- [2025 NestJS Best Practices](../../../claudedocs/research_nestjs_best_practices_2025.md)

## 라이선스

MIT License - 조직 내부 사용 전용
