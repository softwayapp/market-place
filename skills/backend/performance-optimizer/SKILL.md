---
name: performance-optimizer
description: Analyze and optimize NestJS backend performance with Interceptors, Cache Manager, and database query optimization
version: 2.0.0
author: Backend Team <backend@company.com>
category: backend
tags: [performance, optimization, caching, query, profiling, nestjs, interceptors]
status: stable
allowed-tools: [Read, Write, Grep, Bash]
triggers:
  - "성능 최적화"
  - "느린 쿼리 분석"
  - "performance optimization"
  - "optimize queries"
  - "improve performance"
  - "NestJS 캐싱"
dependencies: []
---

# NestJS Performance Optimizer (2025 Edition)

## 목적

NestJS 애플리케이션의 성능 병목 지점을 분석하고 최적화합니다. Interceptors, Cache Manager, 데이터베이스 쿼리 최적화 등 NestJS 생태계의 best practices를 활용합니다.

## 🎯 2025 Best Practices 반영

- ✅ **NestJS Interceptors**: 응답 시간 측정 및 최적화
- ✅ **Cache Manager**: Redis/Memory 캐시 통합
- ✅ **Query Optimization**: Prisma/TypeORM N+1 문제 해결
- ✅ **Compression**: Response compression 자동 적용
- ✅ **Rate Limiting**: ThrottlerModule 통합
- ✅ **Monitoring**: Prometheus/Grafana 연동

## 사용 시기

### ✅ 이 스킬을 사용할 때

- API 응답 속도가 느릴 때 (>1초)
- 데이터베이스 쿼리가 비효율적일 때
- 메모리 사용량이 높을 때
- 동일한 데이터를 반복 조회할 때
- 서버 부하가 높을 때
- 프로덕션 배포 전 성능 검증

### ❌ 이 스킬을 사용하지 않을 때

- 프론트엔드 성능 최적화
- 네트워크 레벨 최적화 (CDN, DNS)
- 인프라 스케일링 (Kubernetes, Docker)

## 작동 방식

1. **프로파일링**: Interceptor로 느린 엔드포인트 식별
2. **쿼리 분석**: N+1 문제, 비효율적 쿼리 감지
3. **캐싱 전략**: 자주 조회되는 데이터 캐싱
4. **최적화 적용**: 코드 개선 및 성능 측정
5. **모니터링**: 지속적인 성능 추적

## 예제

### 예제 1: Performance Monitoring Interceptor

**interceptors/performance.interceptor.ts**
```typescript
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
  Logger,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';

@Injectable()
export class PerformanceInterceptor implements NestInterceptor {
  private readonly logger = new Logger(PerformanceInterceptor.name);
  private readonly SLOW_THRESHOLD = 1000; // 1초

  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    const request = context.switchToHttp().getRequest();
    const { method, url } = request;
    const startTime = Date.now();

    return next.handle().pipe(
      tap(() => {
        const duration = Date.now() - startTime;

        // 느린 요청 경고
        if (duration > this.SLOW_THRESHOLD) {
          this.logger.warn(`⚠️ Slow request detected: ${method} ${url} - ${duration}ms`);
        }

        // 모든 요청 로깅 (개발 환경)
        if (process.env.NODE_ENV === 'development') {
          this.logger.log(`${method} ${url} - ${duration}ms`);
        }
      }),
    );
  }
}
```

**main.ts**
```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { PerformanceInterceptor } from './interceptors/performance.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global Performance Monitoring
  app.useGlobalInterceptors(new PerformanceInterceptor());

  await app.listen(3000);
}
bootstrap();
```

### 예제 2: Redis 캐싱 with Cache Manager

#### Setup Cache Module

**app.module.ts**
```typescript
import { Module } from '@nestjs/common';
import { CacheModule } from '@nestjs/cache-manager';
import { redisStore } from 'cache-manager-redis-store';
import type { RedisClientOptions } from 'redis';

@Module({
  imports: [
    CacheModule.register<RedisClientOptions>({
      store: redisStore,
      host: process.env.REDIS_HOST || 'localhost',
      port: parseInt(process.env.REDIS_PORT) || 6379,
      ttl: 300, // 5 minutes default
      max: 100, // 최대 100개 캐시
    }),
  ],
})
export class AppModule {}
```

#### Controller with Caching

**api/product/product.controller.ts**
```typescript
import { Controller, Get, Param, UseInterceptors } from '@nestjs/common';
import { CacheInterceptor, CacheKey, CacheTTL } from '@nestjs/cache-manager';
import { QueryBus } from '@nestjs/cqrs';
import { GetProductQuery } from '../../application/product/query/get-product.query';
import { GetPopularProductsQuery } from '../../application/product/query/get-popular-products.query';

@Controller('products')
@UseInterceptors(CacheInterceptor) // 전체 컨트롤러 캐싱
export class ProductController {
  constructor(private readonly queryBus: QueryBus) {}

  @Get('popular')
  @CacheKey('popular_products') // 커스텀 캐시 키
  @CacheTTL(600) // 10분 캐싱
  async getPopularProducts() {
    return this.queryBus.execute(new GetPopularProductsQuery());
  }

  @Get(':id')
  @CacheTTL(300) // 5분 캐싱
  async getProduct(@Param('id') id: string) {
    return this.queryBus.execute(new GetProductQuery(id));
  }
}
```

#### Manual Cache Control

**application/product/query/get-popular-products.handler.ts**
```typescript
import { QueryHandler, IQueryHandler } from '@nestjs/cqrs';
import { Injectable, Inject } from '@nestjs/common';
import { CACHE_MANAGER } from '@nestjs/cache-manager';
import { Cache } from 'cache-manager';
import { GetPopularProductsQuery } from './get-popular-products.query';
import { IProductRepository } from '../../../domain/product/repository/product.repository.interface';

@Injectable()
@QueryHandler(GetPopularProductsQuery)
export class GetPopularProductsHandler implements IQueryHandler<GetPopularProductsQuery> {
  constructor(
    private readonly productRepository: IProductRepository,
    @Inject(CACHE_MANAGER) private cacheManager: Cache,
  ) {}

  async execute(query: GetPopularProductsQuery) {
    const cacheKey = `popular_products_${query.limit}`;

    // 캐시 확인
    const cached = await this.cacheManager.get(cacheKey);
    if (cached) {
      return cached;
    }

    // DB 조회
    const products = await this.productRepository.findPopular(query.limit);

    // 캐시 저장 (10분)
    await this.cacheManager.set(cacheKey, products, 600);

    return products;
  }
}
```

### 예제 3: N+1 쿼리 최적화 (Prisma)

#### Before (N+1 Problem)

```typescript
// ❌ N+1 Problem: users 조회 후 각 user마다 posts 조회
@QueryHandler(GetUsersWithPostsQuery)
export class GetUsersWithPostsHandler implements IQueryHandler<GetUsersWithPostsQuery> {
  constructor(private readonly prisma: PrismaService) {}

  async execute(query: GetUsersWithPostsQuery) {
    const users = await this.prisma.user.findMany();

    // N+1 문제 발생!
    for (const user of users) {
      user.posts = await this.prisma.post.findMany({
        where: { authorId: user.id },
      });
    }

    return users;
  }
}
```

#### After (Optimized)

```typescript
// ✅ Optimized: 한 번의 쿼리로 users + posts 조회
@QueryHandler(GetUsersWithPostsQuery)
export class GetUsersWithPostsHandler implements IQueryHandler<GetUsersWithPostsQuery> {
  constructor(private readonly prisma: PrismaService) {}

  async execute(query: GetUsersWithPostsQuery) {
    const users = await this.prisma.user.findMany({
      include: {
        posts: {
          where: { published: true },
          orderBy: { createdAt: 'desc' },
          take: 10, // 최근 10개만
        },
      },
    });

    return users;
  }
}
```

### 예제 4: Database Connection Pooling

**app.module.ts (Prisma)**
```typescript
import { Module } from '@nestjs/common';
import { PrismaService } from './infrastructure/database/prisma.service';

@Module({
  providers: [
    {
      provide: PrismaService,
      useFactory: () => {
        const prisma = new PrismaService({
          datasources: {
            db: {
              url: process.env.DATABASE_URL,
            },
          },
          log: ['query', 'info', 'warn', 'error'],
        });

        // Connection pool optimization
        prisma.$connect();

        return prisma;
      },
    },
  ],
  exports: [PrismaService],
})
export class DatabaseModule {}
```

**prisma/schema.prisma**
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")

  // Connection pooling
  relationMode = "prisma"
  poolSize     = 10
  maxIdleTime  = 30000
}
```

### 예제 5: Response Compression

**main.ts**
```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import * as compression from 'compression';
import helmet from 'helmet';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Security headers
  app.use(helmet());

  // Response compression (gzip)
  app.use(
    compression({
      threshold: 1024, // 1KB 이상만 압축
      level: 6, // 압축 레벨 (1-9)
    }),
  );

  await app.listen(3000);
}
bootstrap();
```

### 예제 6: Rate Limiting

**app.module.ts**
```typescript
import { Module } from '@nestjs/common';
import { ThrottlerModule, ThrottlerGuard } from '@nestjs/throttler';
import { APP_GUARD } from '@nestjs/core';

@Module({
  imports: [
    ThrottlerModule.forRoot([
      {
        name: 'short',
        ttl: 1000, // 1초
        limit: 3, // 최대 3번 요청
      },
      {
        name: 'medium',
        ttl: 10000, // 10초
        limit: 20,
      },
      {
        name: 'long',
        ttl: 60000, // 1분
        limit: 100,
      },
    ]),
  ],
  providers: [
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard, // Global rate limiting
    },
  ],
})
export class AppModule {}
```

**특정 엔드포인트에만 적용:**
```typescript
import { Controller, Get } from '@nestjs/common';
import { Throttle, SkipThrottle } from '@nestjs/throttler';

@Controller('products')
export class ProductController {
  @Get()
  @Throttle({ short: { limit: 10, ttl: 1000 } }) // 1초에 10번
  async findAll() {
    return [];
  }

  @Get('public')
  @SkipThrottle() // Rate limiting 제외
  async getPublicData() {
    return [];
  }
}
```

### 예제 7: Query Optimization with Indexing

**Prisma Schema with Indexes**
```prisma
model Product {
  id          String   @id @default(uuid())
  name        String
  description String   @db.Text
  price       Decimal  @db.Decimal(10, 2)
  categoryId  String
  published   Boolean  @default(false)
  views       Int      @default(0)
  createdAt   DateTime @default(now())

  category Category @relation(fields: [categoryId], references: [id])

  // Performance indexes
  @@index([categoryId]) // 카테고리 조회 최적화
  @@index([published, createdAt(sort: Desc)]) // 발행된 상품 최신순 조회
  @@index([views(sort: Desc)]) // 인기 상품 조회
  @@index([name]) // 상품명 검색
  @@fulltext([name, description]) // 전문 검색 (MySQL)

  @@map("products")
}
```

### 예제 8: Prometheus 모니터링 연동

**app.module.ts**
```typescript
import { Module } from '@nestjs/common';
import { PrometheusModule } from '@willsoto/nestjs-prometheus';

@Module({
  imports: [
    PrometheusModule.register({
      defaultMetrics: {
        enabled: true,
      },
      path: '/metrics',
    }),
  ],
})
export class AppModule {}
```

**Custom Metrics**
```typescript
import { Injectable } from '@nestjs/common';
import { InjectMetric } from '@willsoto/nestjs-prometheus';
import { Counter, Histogram } from 'prom-client';

@Injectable()
export class MetricsService {
  constructor(
    @InjectMetric('api_requests_total')
    private readonly requestCounter: Counter<string>,

    @InjectMetric('api_request_duration_seconds')
    private readonly requestDuration: Histogram<string>,
  ) {}

  incrementRequestCount(route: string, method: string, statusCode: number) {
    this.requestCounter.inc({ route, method, statusCode });
  }

  recordRequestDuration(route: string, duration: number) {
    this.requestDuration.observe({ route }, duration);
  }
}
```

## 설정

**.skillconfig.json**
```json
{
  "performanceOptimizer": {
    "enableProfiling": true,
    "slowQueryThreshold": 1000,
    "caching": {
      "provider": "redis",
      "ttl": 300,
      "maxSize": 100
    },
    "compression": {
      "enabled": true,
      "threshold": 1024,
      "level": 6
    },
    "rateLimiting": {
      "enabled": true,
      "ttl": 60000,
      "limit": 100
    },
    "monitoring": {
      "prometheus": true,
      "logSlowQueries": true
    }
  }
}
```

## 성능 최적화 체크리스트

### Database
- [ ] N+1 쿼리 제거 (eager loading 사용)
- [ ] 적절한 인덱스 추가
- [ ] Connection pooling 설정
- [ ] Query pagination 적용
- [ ] Soft delete 대신 archiving 고려

### Caching
- [ ] Redis 캐시 설정
- [ ] 자주 조회되는 데이터 캐싱
- [ ] Cache invalidation 전략 수립
- [ ] CDN 활용 (static assets)

### API
- [ ] Response compression 활성화
- [ ] Rate limiting 적용
- [ ] CORS 최적화
- [ ] Helmet 보안 헤더

### Monitoring
- [ ] Prometheus metrics 수집
- [ ] Slow query logging
- [ ] Error tracking (Sentry)
- [ ] APM 도구 연동 (New Relic, DataDog)

## 의존성

```json
{
  "@nestjs/cache-manager": "^2.0.0",
  "cache-manager": "^5.2.0",
  "cache-manager-redis-store": "^3.0.0",
  "redis": "^4.6.0",
  "@nestjs/throttler": "^5.0.0",
  "compression": "^1.7.4",
  "helmet": "^7.0.0",
  "@willsoto/nestjs-prometheus": "^6.0.0",
  "prom-client": "^15.0.0"
}
```

## 성능 벤치마크 (2025 기준)

### 캐싱 효과
- 읽기 전용 쿼리: **10-50배 속도 향상**
- API 응답 시간: **평균 80% 감소**
- 데이터베이스 부하: **70% 감소**

### Compression 효과
- 응답 크기: **평균 60-80% 감소**
- 대역폭 사용량: **50-70% 절감**

### Query Optimization
- N+1 제거: **5-20배 속도 향상**
- 인덱스 추가: **2-10배 속도 향상**

## 버전 이력

### 2.0.0 (2025-01-05) - Major Update
- NestJS Interceptors 기반 성능 모니터링
- Cache Manager 통합 (Redis)
- Prisma/TypeORM 최적화 가이드
- ThrottlerModule rate limiting
- Prometheus 모니터링 연동

### 1.0.5 (2024-11-01) - Legacy
- Express 기반 최적화
- 기본 Redis 캐싱

## 참고 자료

- [NestJS Performance Guide](https://docs.nestjs.com/techniques/performance)
- [NestJS Caching](https://docs.nestjs.com/techniques/caching)
- [Prisma Performance Best Practices](https://www.prisma.io/docs/guides/performance-and-optimization)
- [2025 NestJS Best Practices](../../../claudedocs/research_nestjs_best_practices_2025.md)

## 라이선스

MIT License - 조직 내부 사용 전용
