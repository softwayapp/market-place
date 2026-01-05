---
name: api-generator
description: Generate NestJS modules with Clean Architecture, CQRS patterns, and automatic API documentation
version: 2.0.0
author: Backend Team <backend@company.com>
category: backend
tags: [api, rest, nestjs, cqrs, clean-architecture, automation, crud]
status: stable
allowed-tools: [Read, Write, Edit, Grep, Bash]
triggers:
  - "API 생성"
  - "NestJS 모듈 생성"
  - "REST API 만들기"
  - "엔드포인트 생성"
  - "CRUD API"
  - "CQRS API"
  - "create api endpoint"
  - "generate rest api"
  - "generate nestjs module"
dependencies: []
---

# NestJS API Generator (2025 Edition)

## 목적

NestJS 기반 Clean Architecture와 CQRS 패턴을 따르는 RESTful API 엔드포인트를 자동으로 생성합니다. 엔터프라이즈급 확장 가능한 구조로 표준화된 API를 빠르게 구축합니다.

## 🎯 2025 Best Practices 반영

- ✅ **Clean Architecture** (4-Layer: API/Application/Domain/Infrastructure)
- ✅ **CQRS Pattern** (Command/Query 분리)
- ✅ **Event-Driven** (Domain Events 자동 생성)
- ✅ **Repository Pattern** (데이터 접근 추상화)
- ✅ **DTO Validation** (class-validator 통합)
- ✅ **Swagger/OpenAPI** (자동 문서 생성)

## 사용 시기

### ✅ 이 스킬을 사용할 때

- NestJS 기반 새로운 기능 모듈을 추가할 때
- Clean Architecture 구조로 API를 구현할 때
- CQRS 패턴으로 읽기/쓰기를 분리하고 싶을 때
- 도메인 이벤트 기반 시스템을 구축할 때
- Repository Pattern으로 데이터 접근을 추상화할 때
- 엔터프라이즈급 확장 가능한 구조가 필요할 때

### ❌ 이 스킬을 사용하지 않을 때

- Express.js나 다른 프레임워크를 사용할 때
- GraphQL 전용 API를 만들 때 (별도 스킬 사용)
- 단순 프로토타입이나 MVP (CQRS 없이 simple CRUD로 충분)
- WebSocket 실시간 통신만 필요할 때

## 작동 방식

1. **스키마 분석**: Entity/Schema 정의를 분석하여 필드와 관계 파악
2. **4-Layer 구조 생성**: API → Application → Domain → Infrastructure
3. **CQRS 구현**: Command (쓰기), Query (읽기), Event (도메인 이벤트) 자동 생성
4. **Repository 추상화**: 인터페이스와 구현체 분리
5. **DTO & Validation**: 입력 검증 및 응답 DTO 자동 생성
6. **Swagger 문서화**: OpenAPI 스펙 자동 생성

## 예제

### 예제 1: User 모듈 Clean Architecture + CQRS 생성

**사용자 입력:**
```
"User 모듈을 Clean Architecture와 CQRS 패턴으로 생성해줘"
```

**생성되는 파일 구조:**
```
src/
├── api/
│   └── user/
│       ├── user.controller.ts          # HTTP 진입점
│       ├── dto/
│       │   ├── create-user.dto.ts      # 입력 DTO
│       │   ├── update-user.dto.ts
│       │   └── user-response.dto.ts    # 응답 DTO
│       └── user.module.ts              # NestJS 모듈
├── application/
│   └── user/
│       ├── command/                    # 쓰기 작업
│       │   ├── create-user.command.ts
│       │   ├── create-user.handler.ts
│       │   ├── update-user.command.ts
│       │   ├── update-user.handler.ts
│       │   ├── delete-user.command.ts
│       │   └── delete-user.handler.ts
│       ├── query/                      # 읽기 작업
│       │   ├── get-user.query.ts
│       │   ├── get-user.handler.ts
│       │   ├── get-users.query.ts
│       │   └── get-users.handler.ts
│       └── event/                      # 도메인 이벤트
│           ├── user-created.event.ts
│           ├── user-created.handler.ts
│           ├── user-updated.event.ts
│           └── user-deleted.event.ts
├── domain/
│   └── user/
│       ├── entity/
│       │   └── user.entity.ts          # 도메인 엔티티
│       ├── repository/
│       │   └── user.repository.interface.ts  # Repository 인터페이스
│       └── service/
│           └── user-domain.service.ts  # 도메인 로직
└── infrastructure/
    └── database/
        └── repository/
            └── user.repository.impl.ts # Repository 구현체
```

### 생성되는 코드 예제

#### 1. Controller (API Layer)

**api/user/user.controller.ts**
```typescript
import { Controller, Get, Post, Put, Delete, Body, Param, Query, UseGuards } from '@nestjs/common';
import { CommandBus, QueryBus } from '@nestjs/cqrs';
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth } from '@nestjs/swagger';
import { CreateUserDto, UpdateUserDto, UserResponseDto } from './dto';
import { CreateUserCommand } from '../../application/user/command/create-user.command';
import { UpdateUserCommand } from '../../application/user/command/update-user.command';
import { DeleteUserCommand } from '../../application/user/command/delete-user.command';
import { GetUserQuery } from '../../application/user/query/get-user.query';
import { GetUsersQuery } from '../../application/user/query/get-users.query';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

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
  @ApiResponse({ status: 201, description: 'User created successfully', type: UserResponseDto })
  @ApiResponse({ status: 400, description: 'Invalid input' })
  async create(@Body() dto: CreateUserDto): Promise<UserResponseDto> {
    const command = new CreateUserCommand(dto.email, dto.name, dto.role);
    return this.commandBus.execute(command);
  }

  @Get()
  @ApiOperation({ summary: 'Get all users with pagination' })
  @ApiResponse({ status: 200, description: 'List of users', type: [UserResponseDto] })
  async findAll(
    @Query('page') page: number = 1,
    @Query('limit') limit: number = 10,
    @Query('sort') sort: string = '-createdAt',
  ) {
    const query = new GetUsersQuery(page, limit, sort);
    return this.queryBus.execute(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiResponse({ status: 200, description: 'User details', type: UserResponseDto })
  @ApiResponse({ status: 404, description: 'User not found' })
  async findOne(@Param('id') id: string): Promise<UserResponseDto> {
    const query = new GetUserQuery(id);
    return this.queryBus.execute(query);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update user' })
  @ApiResponse({ status: 200, description: 'User updated successfully', type: UserResponseDto })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateUserDto,
  ): Promise<UserResponseDto> {
    const command = new UpdateUserCommand(id, dto.name, dto.role);
    return this.commandBus.execute(command);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete user' })
  @ApiResponse({ status: 204, description: 'User deleted successfully' })
  async remove(@Param('id') id: string): Promise<void> {
    const command = new DeleteUserCommand(id);
    await this.commandBus.execute(command);
  }
}
```

#### 2. DTO (Data Transfer Objects)

**api/user/dto/create-user.dto.ts**
```typescript
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, IsEnum, MinLength, MaxLength } from 'class-validator';

export enum UserRole {
  USER = 'user',
  ADMIN = 'admin',
}

export class CreateUserDto {
  @ApiProperty({ example: 'user@example.com', description: 'User email address' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'John Doe', description: 'User full name' })
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  name: string;

  @ApiProperty({ example: 'user', enum: UserRole, description: 'User role' })
  @IsEnum(UserRole)
  role: UserRole;
}
```

**api/user/dto/user-response.dto.ts**
```typescript
import { ApiProperty } from '@nestjs/swagger';
import { Exclude, Expose } from 'class-transformer';

@Exclude()
export class UserResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ example: 'user@example.com' })
  email: string;

  @Expose()
  @ApiProperty({ example: 'John Doe' })
  name: string;

  @Expose()
  @ApiProperty({ example: 'user' })
  role: string;

  @Expose()
  @ApiProperty({ example: '2025-01-05T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-05T10:00:00Z' })
  updatedAt: Date;
}
```

#### 3. Command Handler (Application Layer - Write)

**application/user/command/create-user.command.ts**
```typescript
export class CreateUserCommand {
  constructor(
    public readonly email: string,
    public readonly name: string,
    public readonly role: string,
  ) {}
}
```

**application/user/command/create-user.handler.ts**
```typescript
import { CommandHandler, ICommandHandler, EventBus } from '@nestjs/cqrs';
import { ConflictException, Injectable } from '@nestjs/common';
import { CreateUserCommand } from './create-user.command';
import { IUserRepository } from '../../../domain/user/repository/user.repository.interface';
import { User } from '../../../domain/user/entity/user.entity';
import { UserCreatedEvent } from '../event/user-created.event';

@Injectable()
@CommandHandler(CreateUserCommand)
export class CreateUserHandler implements ICommandHandler<CreateUserCommand> {
  constructor(
    private readonly userRepository: IUserRepository,
    private readonly eventBus: EventBus,
  ) {}

  async execute(command: CreateUserCommand): Promise<User> {
    // 1. 비즈니스 규칙 검증
    const existingUser = await this.userRepository.findByEmail(command.email);
    if (existingUser) {
      throw new ConflictException('User with this email already exists');
    }

    // 2. 도메인 엔티티 생성
    const user = new User(
      command.email,
      command.name,
      command.role,
    );

    // 3. 영속화
    const savedUser = await this.userRepository.save(user);

    // 4. 도메인 이벤트 발행
    this.eventBus.publish(
      new UserCreatedEvent(savedUser.id, savedUser.email, savedUser.name),
    );

    return savedUser;
  }
}
```

#### 4. Query Handler (Application Layer - Read)

**application/user/query/get-user.query.ts**
```typescript
export class GetUserQuery {
  constructor(public readonly userId: string) {}
}
```

**application/user/query/get-user.handler.ts**
```typescript
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { NotFoundException, Injectable } from '@nestjs/common';
import { GetUserQuery } from './get-user.query';
import { IUserRepository } from '../../../domain/user/repository/user.repository.interface';
import { User } from '../../../domain/user/entity/user.entity';

@Injectable()
@QueryHandler(GetUserQuery)
export class GetUserHandler implements IQueryHandler<GetUserQuery> {
  constructor(private readonly userRepository: IUserRepository) {}

  async execute(query: GetUserQuery): Promise<User> {
    const user = await this.userRepository.findById(query.userId);

    if (!user) {
      throw new NotFoundException(`User with ID ${query.userId} not found`);
    }

    return user;
  }
}
```

**application/user/query/get-users.handler.ts**
```typescript
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { Injectable } from '@nestjs/common';
import { GetUsersQuery } from './get-users.query';
import { IUserRepository } from '../../../domain/user/repository/user.repository.interface';

@Injectable()
@QueryHandler(GetUsersQuery)
export class GetUsersHandler implements IQueryHandler<GetUsersQuery> {
  constructor(private readonly userRepository: IUserRepository) {}

  async execute(query: GetUsersQuery) {
    const { page, limit, sort } = query;

    const [users, total] = await this.userRepository.findAll({
      page,
      limit,
      sort,
    });

    return {
      data: users,
      pagination: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }
}
```

#### 5. Domain Event (Application Layer - Events)

**application/user/event/user-created.event.ts**
```typescript
export class UserCreatedEvent {
  constructor(
    public readonly userId: string,
    public readonly email: string,
    public readonly name: string,
  ) {}
}
```

**application/user/event/user-created.handler.ts**
```typescript
import { EventsHandler, IEventHandler } from '@nestjs/cqrs';
import { Logger, Injectable } from '@nestjs/common';
import { UserCreatedEvent } from './user-created.event';

@Injectable()
@EventsHandler(UserCreatedEvent)
export class UserCreatedHandler implements IEventHandler<UserCreatedEvent> {
  private readonly logger = new Logger(UserCreatedHandler.name);

  constructor(
    // 다른 서비스 주입 (EmailService, ProfileService 등)
  ) {}

  async handle(event: UserCreatedEvent) {
    this.logger.log(`User created: ${event.userId}`);

    // 부가 작업 수행
    // - 환영 이메일 발송
    // - 프로필 자동 생성
    // - 알림 전송
    // - 분석 이벤트 트래킹
  }
}
```

#### 6. Domain Entity (Domain Layer)

**domain/user/entity/user.entity.ts**
```typescript
export class User {
  constructor(
    public readonly email: string,
    public readonly name: string,
    public readonly role: string,
    public readonly id?: string,
    public readonly createdAt?: Date,
    public readonly updatedAt?: Date,
  ) {}

  // 도메인 로직 메서드
  isAdmin(): boolean {
    return this.role === 'admin';
  }

  canEditUser(targetUser: User): boolean {
    return this.isAdmin() || this.id === targetUser.id;
  }

  updateProfile(name: string, role: string): User {
    // 비즈니스 규칙 검증
    if (!name || name.length < 2) {
      throw new Error('Invalid name');
    }

    return new User(
      this.email,
      name,
      role,
      this.id,
      this.createdAt,
      new Date(),
    );
  }
}
```

#### 7. Repository Interface (Domain Layer)

**domain/user/repository/user.repository.interface.ts**
```typescript
import { User } from '../entity/user.entity';

export interface FindAllOptions {
  page: number;
  limit: number;
  sort: string;
}

export interface IUserRepository {
  findById(id: string): Promise<User | null>;
  findByEmail(email: string): Promise<User | null>;
  findAll(options: FindAllOptions): Promise<[User[], number]>;
  save(user: User): Promise<User>;
  update(id: string, user: Partial<User>): Promise<User>;
  delete(id: string): Promise<void>;
}

export const IUserRepository = Symbol('IUserRepository');
```

#### 8. Repository Implementation (Infrastructure Layer)

**infrastructure/database/repository/user.repository.impl.ts**
```typescript
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { IUserRepository, FindAllOptions } from '../../../domain/user/repository/user.repository.interface';
import { User } from '../../../domain/user/entity/user.entity';
import { UserEntity } from '../entity/user.entity'; // TypeORM Entity

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
    const { page, limit, sort } = options;

    const [entities, total] = await this.ormRepository.findAndCount({
      skip: (page - 1) * limit,
      take: limit,
      order: { createdAt: sort.startsWith('-') ? 'DESC' : 'ASC' },
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

  // Mapper: ORM Entity ↔ Domain Entity
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

#### 9. Module Registration

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
import { UserUpdatedHandler } from '../../application/user/event/user-updated.handler';
import { UserDeletedHandler } from '../../application/user/event/user-deleted.handler';

const CommandHandlers = [CreateUserHandler, UpdateUserHandler, DeleteUserHandler];
const QueryHandlers = [GetUserHandler, GetUsersHandler];
const EventHandlers = [UserCreatedHandler, UserUpdatedHandler, UserDeletedHandler];

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

### 예제 2: 기존 Product 모듈에 CQRS 패턴 추가

**사용자 입력:**
```
"Product API를 CQRS 패턴으로 리팩토링해줘"
```

**스킬 동작:**

1. 기존 ProductService 분석
2. Command/Query로 분리
3. Event 추가 (ProductCreatedEvent, ProductUpdatedEvent 등)
4. Repository 인터페이스 추출

## 설정

프로젝트 루트에 `.skillconfig.json` 생성:

```json
{
  "apiGenerator": {
    "framework": "nestjs",
    "architecture": "clean",
    "patterns": {
      "cqrs": true,
      "eventDriven": true,
      "repository": true
    },
    "database": {
      "orm": "typeorm",
      "type": "postgresql"
    },
    "outputDir": "src",
    "layerStructure": {
      "api": "src/api",
      "application": "src/application",
      "domain": "src/domain",
      "infrastructure": "src/infrastructure"
    },
    "features": {
      "pagination": true,
      "filtering": true,
      "sorting": true,
      "softDelete": true,
      "optimisticLocking": true
    },
    "documentation": {
      "swagger": true,
      "generateExamples": true
    },
    "testing": {
      "generateUnitTests": true,
      "generateE2ETests": true
    }
  }
}
```

### 설정 옵션 설명

- **architecture**: 아키텍처 패턴 (clean, hexagonal, layered)
- **patterns.cqrs**: CQRS 패턴 사용 여부
- **patterns.eventDriven**: 도메인 이벤트 생성 여부
- **patterns.repository**: Repository Pattern 사용 여부
- **database.orm**: ORM 선택 (typeorm, prisma, sequelize)
- **layerStructure**: 각 레이어의 디렉토리 경로
- **features.optimisticLocking**: 동시성 제어 (version 필드 추가)

## 가이드라인

### Clean Architecture 원칙

1. **의존성 방향**: Infrastructure → Application → Domain
2. **도메인 순수성**: Domain Layer는 외부 의존성 없음
3. **인터페이스 분리**: Repository는 Domain에 인터페이스, Infrastructure에 구현
4. **단일 책임**: 각 Handler는 하나의 Command/Query만 처리

### CQRS 원칙

1. **명령 분리**: Command는 상태 변경, Query는 데이터 조회만
2. **이벤트 발행**: Command 성공 시 Domain Event 발행
3. **독립 최적화**: Command/Query 각각 최적화 가능
4. **읽기 전용**: Query Handler는 DB 변경 금지

### 보안

- 모든 DTO에 class-validator 검증 추가
- 민감한 데이터는 응답 DTO에서 제외 (@Exclude)
- Guards를 통한 인증/인가 적용
- Rate limiting 권장

### 성능

- Query에 pagination 기본 적용
- 적절한 인덱스 설정 (Infrastructure Layer)
- N+1 쿼리 방지 (eager loading 고려)
- 읽기 전용 쿼리는 캐싱 고려

## 출력 형식

생성되는 4-Layer 구조:

```
src/
├── api/                          # API Layer (Controllers, DTOs)
│   └── [resource]/
│       ├── [resource].controller.ts
│       ├── [resource].module.ts
│       └── dto/
├── application/                  # Application Layer (CQRS)
│   └── [resource]/
│       ├── command/
│       ├── query/
│       └── event/
├── domain/                       # Domain Layer (Business Logic)
│   └── [resource]/
│       ├── entity/
│       ├── repository/          # Interface only
│       └── service/
└── infrastructure/               # Infrastructure Layer
    ├── database/
    │   ├── entity/              # ORM Entities
    │   └── repository/          # Repository Implementation
    └── config/
```

## 의존성

필수 패키지:
```json
{
  "@nestjs/common": "^10.0.0",
  "@nestjs/core": "^10.0.0",
  "@nestjs/cqrs": "^10.0.0",
  "@nestjs/typeorm": "^10.0.0",
  "@nestjs/swagger": "^7.0.0",
  "typeorm": "^0.3.0",
  "class-validator": "^0.14.0",
  "class-transformer": "^0.5.0"
}
```

선택적 패키지 (Prisma 사용 시):
```json
{
  "@prisma/client": "^5.0.0",
  "prisma": "^5.0.0"
}
```

## 제한사항

- **프레임워크**: NestJS 전용 (v10+)
- **데이터베이스**: TypeORM, Prisma 지원 (Mongoose는 별도 처리)
- **복잡한 트랜잭션**: Saga Pattern은 수동 구현 필요
- **Event Sourcing**: 완전한 Event Store는 별도 스킬 필요

## 성능 벤치마크 (2025 조사 결과)

CQRS 패턴 적용 시:
- 읽기 성능: **최대 50% 향상** (읽기 전용 최적화)
- 유지보수 비용: **30% 감소** (명확한 책임 분리)
- 확장성: **독립적인 읽기/쓰기 스케일링 가능**

## 버전 이력

### 2.0.0 (2025-01-05) - Major Update
- NestJS를 기본 프레임워크로 전환
- Clean Architecture 4-Layer 구조 적용
- CQRS 패턴 완전 지원
- Event-Driven Architecture 통합
- Repository Pattern 구현
- Express.js 예제는 Legacy 섹션으로 이동

### 1.2.0 (2025-01-01) - Legacy
- 페이지네이션 및 필터링 자동 추가
- TypeScript 지원 개선
- Swagger 문서 생성 자동화

## Legacy: Express.js 예제

<details>
<summary>Express.js 기반 구현 (레거시 - 참고용)</summary>

이전 버전(v1.x)에서 사용하던 Express.js 기반 코드는 [Legacy Examples](./legacy/express-examples.md)에서 확인할 수 있습니다.

**마이그레이션 가이드**: Express.js → NestJS 전환 가이드는 [Migration Guide](./docs/express-to-nestjs-migration.md)를 참조하세요.

</details>

## 참고 자료

- [NestJS Clean Architecture 템플릿](https://github.com/CollatzConjecture/nestjs-clean-architecture)
- [NestJS CQRS 공식 문서](https://docs.nestjs.com/recipes/cqrs)
- [2025 NestJS Best Practices 리서치](../../../claudedocs/research_nestjs_best_practices_2025.md)

## 기여자

- Backend Team (backend@company.com) - 초기 개발 및 유지보수
- Architecture Team - Clean Architecture 패턴 적용
- DevOps Team - 성능 최적화 및 보안 개선

## 지원

문제가 발생하거나 질문이 있으면:
- **Slack**: #backend-support
- **Email**: backend@company.com
- **이슈**: GitHub Issues

## 라이선스

MIT License - 조직 내부 사용 전용
