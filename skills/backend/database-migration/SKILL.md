---
name: database-migration
description: Generate database migrations for NestJS with Prisma, TypeORM, and automated rollback support
version: 2.0.0
author: Backend Team <backend@company.com>
category: backend
tags: [database, migration, schema, prisma, typeorm, nestjs]
status: stable
allowed-tools: [Read, Write, Edit, Grep, Bash]
triggers:
  - "마이그레이션 생성"
  - "데이터베이스 마이그레이션"
  - "스키마 변경"
  - "Prisma 마이그레이션"
  - "create migration"
  - "generate migration"
  - "database schema change"
dependencies: []
---

# NestJS Database Migration Generator (2025 Edition)

## 목적

NestJS 프로젝트에서 데이터베이스 스키마 변경사항을 안전하게 관리합니다. Prisma와 TypeORM을 지원하며, 자동 롤백 기능과 버전 관리를 제공합니다.

## 🎯 2025 Best Practices 반영

- ✅ **Prisma 우선**: 현대적인 Type-Safe ORM
- ✅ **Automated Migrations**: 스키마 diff 자동 감지
- ✅ **Rollback Support**: 안전한 down migration
- ✅ **Zero-Downtime**: 단계적 migration 지원
- ✅ **Seed Data**: 초기 데이터 자동 생성
- ✅ **Multi-Environment**: dev, staging, production 분리

## 사용 시기

### ✅ 이 스킬을 사용할 때

- Prisma 스키마 변경 후 마이그레이션 생성
- TypeORM Entity 변경 후 마이그레이션 필요
- 프로덕션 배포 전 스키마 동기화
- 테이블 구조 변경 (컬럼 추가/수정/삭제)
- 인덱스, 제약조건, 관계 변경
- 롤백 시나리오 준비

### ❌ 이 스킬을 사용하지 않을 때

- NoSQL 데이터베이스 (MongoDB - 스키마리스)
- 데이터 마이그레이션만 필요 (스키마 변경 없음)
- Raw SQL로 직접 관리하는 프로젝트

## 작동 방식

### Prisma Workflow

1. **스키마 수정**: `prisma/schema.prisma` 파일 편집
2. **Diff 생성**: 현재 DB와 스키마 비교
3. **Migration 생성**: SQL 파일 자동 생성
4. **적용**: 데이터베이스에 migration 실행
5. **Client 생성**: Prisma Client 재생성

### TypeORM Workflow

1. **Entity 수정**: TypeORM Entity 클래스 변경
2. **Migration 생성**: 변경사항 기반 migration 파일 생성
3. **검증**: Migration SQL 검증
4. **적용**: Migration 실행

## 예제

### 예제 1: Prisma Migration (권장)

#### Step 1: Prisma Schema 정의

**prisma/schema.prisma**
```prisma
generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id        String   @id @default(uuid())
  email     String   @unique
  name      String
  role      Role     @default(USER)
  posts     Post[]
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([email])
  @@map("users")
}

model Post {
  id        String   @id @default(uuid())
  title     String
  content   String   @db.Text
  published Boolean  @default(false)
  author    User     @relation(fields: [authorId], references: [id], onDelete: Cascade)
  authorId  String
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt

  @@index([authorId])
  @@index([published])
  @@map("posts")
}

enum Role {
  USER
  ADMIN
}
```

#### Step 2: Migration 생성 및 적용

**사용자 입력:**
```bash
"User 모델에 email 컬럼 추가 후 마이그레이션 생성"
```

**실행 명령:**
```bash
# Development 환경
npx prisma migrate dev --name add_user_email

# Production 환경
npx prisma migrate deploy
```

**생성되는 Migration 파일:**

**prisma/migrations/20250105120000_add_user_email/migration.sql**
```sql
-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "role" TEXT NOT NULL DEFAULT 'USER',
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "posts" (
    "id" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "published" BOOLEAN NOT NULL DEFAULT false,
    "authorId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "posts_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_email_idx" ON "users"("email");

-- CreateIndex
CREATE INDEX "posts_authorId_idx" ON "posts"("authorId");

-- CreateIndex
CREATE INDEX "posts_published_idx" ON "posts"("published");

-- AddForeignKey
ALTER TABLE "posts" ADD CONSTRAINT "posts_authorId_fkey"
  FOREIGN KEY ("authorId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
```

#### Step 3: NestJS에서 Prisma 사용

**infrastructure/database/prisma.service.ts**
```typescript
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }

  // Soft Delete 지원
  async softDelete<T>(model: string, id: string): Promise<T> {
    return this[model].update({
      where: { id },
      data: { deletedAt: new Date() },
    });
  }

  // Transaction Helper
  async transaction<T>(fn: (prisma: PrismaClient) => Promise<T>): Promise<T> {
    return this.$transaction(fn);
  }
}
```

**app.module.ts**
```typescript
import { Module } from '@nestjs/common';
import { PrismaService } from './infrastructure/database/prisma.service';

@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class AppModule {}
```

### 예제 2: TypeORM Migration

#### Step 1: Entity 정의

**infrastructure/database/entity/user.entity.ts**
```typescript
import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, Index } from 'typeorm';

@Entity('users')
@Index(['email'])
export class UserEntity {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column()
  name: string;

  @Column({ default: 'user' })
  role: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

#### Step 2: Migration 생성

**사용자 입력:**
```bash
"TypeORM migration 생성"
```

**실행 명령:**
```bash
# Migration 생성
npm run typeorm migration:generate -- -n AddUserEmail

# Migration 실행
npm run typeorm migration:run

# Rollback
npm run typeorm migration:revert
```

**생성되는 Migration:**

**migrations/1704427200000-AddUserEmail.ts**
```typescript
import { MigrationInterface, QueryRunner, Table, TableIndex, TableForeignKey } from 'typeorm';

export class AddUserEmail1704427200000 implements MigrationInterface {
  name = 'AddUserEmail1704427200000';

  public async up(queryRunner: QueryRunner): Promise<void> {
    // Create users table
    await queryRunner.createTable(
      new Table({
        name: 'users',
        columns: [
          {
            name: 'id',
            type: 'uuid',
            isPrimary: true,
            generationStrategy: 'uuid',
            default: 'uuid_generate_v4()',
          },
          {
            name: 'email',
            type: 'varchar',
            isUnique: true,
          },
          {
            name: 'name',
            type: 'varchar',
          },
          {
            name: 'role',
            type: 'varchar',
            default: "'user'",
          },
          {
            name: 'createdAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
          {
            name: 'updatedAt',
            type: 'timestamp',
            default: 'CURRENT_TIMESTAMP',
          },
        ],
      }),
      true,
    );

    // Create index
    await queryRunner.createIndex(
      'users',
      new TableIndex({
        name: 'IDX_USER_EMAIL',
        columnNames: ['email'],
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropIndex('users', 'IDX_USER_EMAIL');
    await queryRunner.dropTable('users');
  }
}
```

### 예제 3: Seed Data 생성

**prisma/seed.ts**
```typescript
import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🌱 Seeding database...');

  // Admin User
  const admin = await prisma.user.upsert({
    where: { email: 'admin@example.com' },
    update: {},
    create: {
      email: 'admin@example.com',
      name: 'Admin User',
      role: 'ADMIN',
    },
  });

  console.log('✅ Admin user created:', admin.id);

  // Sample Posts
  const post1 = await prisma.post.create({
    data: {
      title: 'Getting Started with NestJS',
      content: 'NestJS is a progressive Node.js framework...',
      published: true,
      authorId: admin.id,
    },
  });

  console.log('✅ Post created:', post1.id);

  console.log('🎉 Seed completed!');
}

main()
  .catch((e) => {
    console.error('❌ Seed error:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
```

**package.json**
```json
{
  "scripts": {
    "prisma:migrate": "prisma migrate dev",
    "prisma:deploy": "prisma migrate deploy",
    "prisma:seed": "ts-node prisma/seed.ts",
    "prisma:studio": "prisma studio",
    "prisma:reset": "prisma migrate reset"
  },
  "prisma": {
    "seed": "ts-node prisma/seed.ts"
  }
}
```

### 예제 4: Zero-Downtime Migration

**단계적 Migration 전략:**

```typescript
// Step 1: 새 컬럼 추가 (nullable)
// migration: add_phone_column.sql
ALTER TABLE users ADD COLUMN phone VARCHAR(20) NULL;

// Step 2: 데이터 마이그레이션 (backfill)
// migration: backfill_phone_data.sql
UPDATE users SET phone = '000-0000-0000' WHERE phone IS NULL;

// Step 3: NOT NULL 제약조건 추가
// migration: make_phone_not_null.sql
ALTER TABLE users ALTER COLUMN phone SET NOT NULL;
```

## 설정

### Prisma 설정

**prisma/schema.prisma**
```prisma
generator client {
  provider = "prisma-client-js"
  output   = "../node_modules/.prisma/client"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}
```

**.env**
```env
DATABASE_URL="postgresql://user:password@localhost:5432/mydb?schema=public"
```

### TypeORM 설정

**ormconfig.ts**
```typescript
import { DataSource } from 'typeorm';
import { ConfigService } from '@nestjs/config';

const configService = new ConfigService();

export default new DataSource({
  type: 'postgres',
  host: configService.get('DB_HOST'),
  port: configService.get('DB_PORT'),
  username: configService.get('DB_USERNAME'),
  password: configService.get('DB_PASSWORD'),
  database: configService.get('DB_DATABASE'),
  entities: ['src/**/*.entity.ts'],
  migrations: ['migrations/*.ts'],
  synchronize: false, // ⚠️ Production에서는 반드시 false
  logging: true,
});
```

### .skillconfig.json

```json
{
  "databaseMigration": {
    "preferredORM": "prisma",
    "database": "postgresql",
    "migrationDirectory": "prisma/migrations",
    "safeMode": true,
    "autoBackup": true,
    "environments": {
      "development": {
        "autoApply": true,
        "seedData": true
      },
      "production": {
        "autoApply": false,
        "requireReview": true,
        "zeroDowntime": true
      }
    }
  }
}
```

## 가이드라인

### Migration Best Practices

1. **Always Reversible**: down migration 반드시 작성
2. **Small Changes**: 한 migration에 하나의 변경사항
3. **Test First**: 테스트 환경에서 먼저 검증
4. **No Data Loss**: 데이터 유실 방지 (백업 선행)
5. **Zero Downtime**: 프로덕션은 단계적 migration

### Prisma vs TypeORM 선택 가이드

**Prisma 추천:**
- Type-Safety가 중요한 경우
- 현대적인 ORM 경험 선호
- 자동 마이그레이션 선호
- GraphQL과 함께 사용

**TypeORM 추천:**
- 복잡한 Raw SQL 필요
- 기존 TypeORM 프로젝트
- Entity 중심 설계
- 더 많은 제어 필요

### Production Checklist

- [ ] 백업 완료
- [ ] Dry-run 테스트 완료
- [ ] Rollback plan 준비
- [ ] 모니터링 설정
- [ ] 피크 시간대 회피
- [ ] 팀 알림 완료

## 의존성

### Prisma
```json
{
  "@prisma/client": "^5.0.0",
  "prisma": "^5.0.0"
}
```

### TypeORM
```json
{
  "@nestjs/typeorm": "^10.0.0",
  "typeorm": "^0.3.0",
  "pg": "^8.11.0"
}
```

## 제한사항

- **Prisma**: MongoDB에서 일부 기능 제한
- **TypeORM**: Migration 자동 생성이 완벽하지 않음 (수동 검토 필요)
- **Complex Migrations**: 데이터 변환 로직은 수동 작성 필요
- **Zero-Downtime**: 모든 변경사항이 지원되는 것은 아님

## 버전 이력

### 2.0.0 (2025-01-05) - Major Update
- Prisma를 기본 ORM으로 채택
- NestJS 통합 패턴 추가
- Zero-Downtime migration 전략 추가
- Seed data 자동 생성 지원
- Multi-environment 설정 강화

### 1.1.0 (2024-12-01) - Legacy
- Sequelize 지원 추가
- PostgreSQL 최적화

## 참고 자료

- [Prisma 공식 문서](https://www.prisma.io/docs)
- [TypeORM 공식 문서](https://typeorm.io)
- [NestJS Database 가이드](https://docs.nestjs.com/techniques/database)
- [2025 NestJS Best Practices](../../../claudedocs/research_nestjs_best_practices_2025.md)

## 라이선스

MIT License - 조직 내부 사용 전용
