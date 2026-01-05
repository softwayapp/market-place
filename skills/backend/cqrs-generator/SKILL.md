---
name: cqrs-generator
description: Automatically generate CQRS pattern files (Commands, Queries, Events, Handlers) for NestJS applications
version: 1.0.0
author: Backend Team <backend@company.com>
category: backend
tags: [cqrs, command, query, event, nestjs, automation, ddd]
status: stable
allowed-tools: [Read, Write, Edit, Grep, Bash]
triggers:
  - "CQRS 생성"
  - "Command 생성"
  - "Query 생성"
  - "Event 생성"
  - "generate cqrs"
  - "create command"
  - "create query"
  - "create event"
dependencies: []
---

# CQRS Pattern Generator

## 목적

NestJS 애플리케이션에서 CQRS (Command Query Responsibility Segregation) 패턴을 자동으로 생성합니다. Command, Query, Event, Handler 파일을 표준화된 구조로 빠르게 생성하여 개발 생산성을 향상시킵니다.

## 🎯 2025 Best Practices 반영

- ✅ **Command Pattern**: 쓰기 작업 자동 생성
- ✅ **Query Pattern**: 읽기 작업 자동 생성
- ✅ **Event Pattern**: 도메인 이벤트 자동 생성
- ✅ **Handler Pattern**: 비즈니스 로직 템플릿
- ✅ **Repository Integration**: Repository 인터페이스 연동
- ✅ **Type Safety**: 완전한 TypeScript 지원

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새로운 기능에 CQRS 패턴 적용
- Command/Query/Event 파일을 일괄 생성
- 표준화된 Handler 템플릿 필요
- 반복적인 보일러플레이트 코드 제거
- Clean Architecture + CQRS 구조 유지

### ❌ 이 스킬을 사용하지 않을 때

- CQRS 패턴을 사용하지 않는 프로젝트
- Express.js나 다른 프레임워크
- 단순 CRUD만 필요한 경우
- GraphQL 전용 API (별도 패턴)

## 작동 방식

1. **입력 분석**: 기능명, 엔티티, 작업 타입 파악
2. **파일 생성**: Command/Query/Event 파일 생성
3. **Handler 생성**: 비즈니스 로직 템플릿 작성
4. **Module 업데이트**: Module providers 자동 등록
5. **타입 검증**: TypeScript 컴파일 확인

## 예제

### 예제 1: Create Command 생성

**사용자 입력:**
```
"User 생성을 위한 CQRS Command 생성해줘"
```

**생성되는 파일:**

#### 1. Command 클래스

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

#### 2. Command Handler

**application/user/command/create-user.handler.ts**
```typescript
import { CommandHandler, ICommandHandler, EventBus } from '@nestjs/cqrs';
import { Injectable, ConflictException } from '@nestjs/common';
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
    // 1. Validation
    const existingUser = await this.userRepository.findByEmail(command.email);
    if (existingUser) {
      throw new ConflictException(`User with email ${command.email} already exists`);
    }

    // 2. Create domain entity
    const user = new User(
      command.email,
      command.name,
      command.role,
    );

    // 3. Persist
    const savedUser = await this.userRepository.save(user);

    // 4. Publish domain event
    this.eventBus.publish(
      new UserCreatedEvent(savedUser.id, savedUser.email, savedUser.name),
    );

    return savedUser;
  }
}
```

#### 3. Domain Event

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

#### 4. Event Handler

**application/user/event/user-created.handler.ts**
```typescript
import { EventsHandler, IEventHandler } from '@nestjs/cqrs';
import { Injectable, Logger } from '@nestjs/common';
import { UserCreatedEvent } from './user-created.event';

@Injectable()
@EventsHandler(UserCreatedEvent)
export class UserCreatedHandler implements IEventHandler<UserCreatedEvent> {
  private readonly logger = new Logger(UserCreatedHandler.name);

  constructor(
    // Inject required services (EmailService, ProfileService, etc.)
  ) {}

  async handle(event: UserCreatedEvent) {
    this.logger.log(`User created: ${event.userId} (${event.email})`);

    // TODO: Implement side effects
    // - Send welcome email
    // - Create user profile
    // - Trigger analytics event
    // - Send notification
  }
}
```

### 예제 2: Query 생성

**사용자 입력:**
```
"User 조회를 위한 Query 생성해줘"
```

**생성되는 파일:**

#### 1. Query 클래스

**application/user/query/get-user.query.ts**
```typescript
export class GetUserQuery {
  constructor(public readonly userId: string) {}
}
```

#### 2. Query Handler

**application/user/query/get-user.handler.ts**
```typescript
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { Injectable, NotFoundException } from '@nestjs/common';
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

### 예제 3: 전체 CQRS 세트 생성

**사용자 입력:**
```
"Product 엔티티에 대한 전체 CQRS 패턴 생성해줘 (Create, Update, Delete, GetById, GetAll)"
```

**생성되는 파일 구조:**
```
application/product/
├── command/
│   ├── create-product.command.ts
│   ├── create-product.handler.ts
│   ├── update-product.command.ts
│   ├── update-product.handler.ts
│   ├── delete-product.command.ts
│   └── delete-product.handler.ts
├── query/
│   ├── get-product.query.ts
│   ├── get-product.handler.ts
│   ├── get-products.query.ts
│   └── get-products.handler.ts
└── event/
    ├── product-created.event.ts
    ├── product-created.handler.ts
    ├── product-updated.event.ts
    ├── product-updated.handler.ts
    ├── product-deleted.event.ts
    └── product-deleted.handler.ts
```

#### Module 자동 업데이트

**api/product/product.module.ts**
```typescript
import { Module } from '@nestjs/common';
import { CqrsModule } from '@nestjs/cqrs';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductController } from './product.controller';
import { ProductEntity } from '../../infrastructure/database/entity/product.entity';

// Auto-generated imports
import { CreateProductHandler } from '../../application/product/command/create-product.handler';
import { UpdateProductHandler } from '../../application/product/command/update-product.handler';
import { DeleteProductHandler } from '../../application/product/command/delete-product.handler';
import { GetProductHandler } from '../../application/product/query/get-product.handler';
import { GetProductsHandler } from '../../application/product/query/get-products.handler';
import { ProductCreatedHandler } from '../../application/product/event/product-created.handler';
import { ProductUpdatedHandler } from '../../application/product/event/product-updated.handler';
import { ProductDeletedHandler } from '../../application/product/event/product-deleted.handler';

const CommandHandlers = [
  CreateProductHandler,
  UpdateProductHandler,
  DeleteProductHandler,
];

const QueryHandlers = [
  GetProductHandler,
  GetProductsHandler,
];

const EventHandlers = [
  ProductCreatedHandler,
  ProductUpdatedHandler,
  ProductDeletedHandler,
];

@Module({
  imports: [
    CqrsModule,
    TypeOrmModule.forFeature([ProductEntity]),
  ],
  controllers: [ProductController],
  providers: [
    ...CommandHandlers,
    ...QueryHandlers,
    ...EventHandlers,
  ],
})
export class ProductModule {}
```

### 예제 4: Update Command with Validation

**application/product/command/update-product.command.ts**
```typescript
export class UpdateProductCommand {
  constructor(
    public readonly productId: string,
    public readonly name?: string,
    public readonly price?: number,
    public readonly description?: string,
    public readonly published?: boolean,
  ) {}

  // Validation logic
  validate(): void {
    if (this.price !== undefined && this.price < 0) {
      throw new Error('Price must be positive');
    }

    if (this.name !== undefined && this.name.length < 2) {
      throw new Error('Name must be at least 2 characters');
    }
  }
}
```

**application/product/command/update-product.handler.ts**
```typescript
import { CommandHandler, ICommandHandler, EventBus } from '@nestjs/cqrs';
import { Injectable, NotFoundException } from '@nestjs/common';
import { UpdateProductCommand } from './update-product.command';
import { IProductRepository } from '../../../domain/product/repository/product.repository.interface';
import { Product } from '../../../domain/product/entity/product.entity';
import { ProductUpdatedEvent } from '../event/product-updated.event';

@Injectable()
@CommandHandler(UpdateProductCommand)
export class UpdateProductHandler implements ICommandHandler<UpdateProductCommand> {
  constructor(
    private readonly productRepository: IProductRepository,
    private readonly eventBus: EventBus,
  ) {}

  async execute(command: UpdateProductCommand): Promise<Product> {
    // Validate command
    command.validate();

    // Find existing product
    const existingProduct = await this.productRepository.findById(command.productId);
    if (!existingProduct) {
      throw new NotFoundException(`Product with ID ${command.productId} not found`);
    }

    // Update product
    const updatedProduct = await this.productRepository.update(
      command.productId,
      {
        name: command.name,
        price: command.price,
        description: command.description,
        published: command.published,
      },
    );

    // Publish event
    this.eventBus.publish(
      new ProductUpdatedEvent(
        updatedProduct.id,
        command.name !== undefined,
        command.price !== undefined,
        command.published !== undefined,
      ),
    );

    return updatedProduct;
  }
}
```

### 예제 5: Saga Pattern with CQRS

**application/order/saga/order-processing.saga.ts**
```typescript
import { Injectable } from '@nestjs/common';
import { ICommand, ofType, Saga } from '@nestjs/cqrs';
import { Observable } from 'rxjs';
import { map, mergeMap, catchError } from 'rxjs/operators';
import { OrderCreatedEvent } from '../event/order-created.event';
import { PaymentProcessedEvent } from '../event/payment-processed.event';
import { PaymentFailedEvent } from '../event/payment-failed.event';
import { ProcessPaymentCommand } from '../../payment/command/process-payment.command';
import { CancelOrderCommand } from '../command/cancel-order.command';
import { ShipOrderCommand } from '../command/ship-order.command';

@Injectable()
export class OrderProcessingSaga {
  @Saga()
  orderCreated = (events$: Observable<any>): Observable<ICommand> => {
    return events$.pipe(
      ofType(OrderCreatedEvent),
      map((event) => new ProcessPaymentCommand(event.orderId, event.amount)),
    );
  };

  @Saga()
  paymentProcessed = (events$: Observable<any>): Observable<ICommand> => {
    return events$.pipe(
      ofType(PaymentProcessedEvent),
      map((event) => new ShipOrderCommand(event.orderId)),
    );
  };

  @Saga()
  paymentFailed = (events$: Observable<any>): Observable<ICommand> => {
    return events$.pipe(
      ofType(PaymentFailedEvent),
      map((event) => new CancelOrderCommand(event.orderId, 'Payment failed')),
    );
  };
}
```

## 설정

**.skillconfig.json**
```json
{
  "cqrsGenerator": {
    "outputDir": "src/application",
    "entityLocation": "src/domain",
    "generateTests": true,
    "includeValidation": true,
    "autoRegisterModule": true,
    "namingConvention": {
      "command": "kebab-case",
      "handler": "kebab-case",
      "event": "kebab-case"
    },
    "templates": {
      "command": "default",
      "query": "default",
      "event": "default",
      "handler": "default"
    },
    "features": {
      "eventBus": true,
      "saga": false,
      "validation": true,
      "logging": true
    }
  }
}
```

## CQRS 패턴 가이드라인

### Command (쓰기 작업)

**목적**: 시스템 상태 변경
**특징**:
- 반환값: 생성된 엔티티 또는 void
- 부작용: 데이터베이스 변경
- 이벤트: Command 성공 시 Event 발행

**네이밍 규칙**:
- Command: `{Verb}{Entity}Command` (예: `CreateUserCommand`)
- Handler: `{Verb}{Entity}Handler` (예: `CreateUserHandler`)

### Query (읽기 작업)

**목적**: 데이터 조회
**특징**:
- 반환값: 조회된 데이터
- 부작용: 없음 (읽기 전용)
- 캐싱: 가능하면 캐시 적용

**네이밍 규칙**:
- Query: `Get{Entity}Query` 또는 `Get{Entity}ListQuery`
- Handler: `Get{Entity}Handler`

### Event (도메인 이벤트)

**목적**: 시스템 간 통신, 비동기 작업
**특징**:
- 과거형: `{Entity}{Action}edEvent` (예: `UserCreatedEvent`)
- Fire and forget: Event 발행 후 결과 기다리지 않음
- 다중 Handler: 여러 Handler가 동일 Event 구독 가능

## 의존성

```json
{
  "@nestjs/cqrs": "^10.0.0",
  "@nestjs/common": "^10.0.0",
  "@nestjs/core": "^10.0.0",
  "rxjs": "^7.8.0"
}
```

## CQRS vs 전통적 Service 비교

| 항목 | 전통적 Service | CQRS |
|------|---------------|------|
| **구조** | Service 하나에 모든 로직 | Command/Query 분리 |
| **책임** | 혼재 (읽기/쓰기) | 명확히 분리 |
| **테스트** | 복잡 | 단순 (각 Handler 독립) |
| **확장성** | 제한적 | 독립 스케일링 가능 |
| **이벤트** | 수동 처리 | EventBus 자동 처리 |
| **복잡도** | 낮음 | 초기 높음, 장기적 낮음 |

## 버전 이력

### 1.0.0 (2025-01-05) - Initial Release
- Command/Query/Event 자동 생성
- Handler 템플릿 제공
- Module 자동 등록
- Saga 패턴 지원
- Validation 통합

## 참고 자료

- [NestJS CQRS 공식 문서](https://docs.nestjs.com/recipes/cqrs)
- [CQRS Pattern (Martin Fowler)](https://martinfowler.com/bliki/CQRS.html)
- [Event Sourcing](https://martinfowler.com/eaaDev/EventSourcing.html)
- [2025 NestJS Best Practices](../../../claudedocs/research_nestjs_best_practices_2025.md)

## 라이선스

MIT License - 조직 내부 사용 전용
