---
name: error-handler
description: Apply consistent error handling patterns with NestJS Exception Filters, logging, and monitoring integration
version: 2.0.0
author: Backend Team <backend@company.com>
category: backend
tags: [error-handling, logging, monitoring, exceptions, nestjs, filters]
status: stable
allowed-tools: [Read, Write, Edit]
triggers:
  - "에러 처리 추가"
  - "예외 처리"
  - "error handling"
  - "add error handler"
  - "exception filter"
dependencies: []
---

# NestJS Error Handler (2025 Edition)

## 목적

NestJS Exception Filters를 활용한 일관된 에러 처리 패턴을 자동으로 적용합니다. 구조화된 로깅, 모니터링 통합, 사용자 친화적 에러 응답을 제공합니다.

## 🎯 2025 Best Practices 반영

- ✅ **Exception Filters**: NestJS 네이티브 에러 처리
- ✅ **Custom Exceptions**: 도메인별 예외 클래스
- ✅ **Structured Logging**: Winston/Pino 통합
- ✅ **Error Monitoring**: Sentry 연동
- ✅ **Validation Pipes**: class-validator 자동 통합
- ✅ **HTTP Exception Handling**: 표준화된 에러 응답

## 사용 시기

### ✅ 이 스킬을 사용할 때

- NestJS 프로젝트에 전역 에러 처리 필요
- 커스텀 예외 클래스 생성
- 에러 로깅 및 모니터링 통합
- 일관된 에러 응답 형식 적용
- Validation 에러 처리

### ❌ 이 스킬을 사용하지 않을 때

- Express.js나 다른 프레임워크 사용
- 프론트엔드 에러 처리
- 복잡한 비즈니스 로직 에러 (도메인 이벤트로 처리)

## 작동 방식

1. **Exception Filter 생성**: 전역 또는 특정 컨트롤러용
2. **Custom Exception 정의**: 도메인별 예외 클래스
3. **로깅 설정**: Winston/Pino 통합
4. **모니터링 연동**: Sentry, DataDog 등
5. **응답 표준화**: 일관된 에러 응답 형식

## 예제

### 예제 1: Global Exception Filter

**filters/http-exception.filter.ts**
```typescript
import {
  ExceptionFilter,
  Catch,
  ArgumentsHost,
  HttpException,
  HttpStatus,
  Logger,
} from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class GlobalExceptionFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalExceptionFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse<Response>();
    const request = ctx.getRequest<Request>();

    const status =
      exception instanceof HttpException
        ? exception.getStatus()
        : HttpStatus.INTERNAL_SERVER_ERROR;

    const message =
      exception instanceof HttpException
        ? exception.getResponse()
        : 'Internal server error';

    // 에러 로깅
    this.logger.error({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      method: request.method,
      message: exception instanceof Error ? exception.message : 'Unknown error',
      stack: exception instanceof Error ? exception.stack : undefined,
    });

    // 클라이언트 응답
    response.status(status).json({
      success: false,
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: request.url,
      message: this.getErrorMessage(message),
      // Development에서만 stack trace 노출
      ...(process.env.NODE_ENV === 'development' &&
        exception instanceof Error && {
          stack: exception.stack,
        }),
    });
  }

  private getErrorMessage(response: string | object): string {
    if (typeof response === 'string') {
      return response;
    }

    if (typeof response === 'object' && 'message' in response) {
      return Array.isArray(response.message)
        ? response.message.join(', ')
        : response.message;
    }

    return 'An error occurred';
  }
}
```

**main.ts**
```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { GlobalExceptionFilter } from './filters/http-exception.filter';
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global Exception Filter
  app.useGlobalFilters(new GlobalExceptionFilter());

  // Global Validation Pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true, // DTO에 없는 속성 제거
      forbidNonWhitelisted: true, // 허용되지 않은 속성 요청 시 에러
      transform: true, // 자동 타입 변환
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );

  await app.listen(3000);
}
bootstrap();
```

### 예제 2: Custom Domain Exceptions

**exceptions/domain-exceptions.ts**
```typescript
import { HttpException, HttpStatus } from '@nestjs/common';

// Base Domain Exception
export class DomainException extends HttpException {
  constructor(
    message: string,
    statusCode: HttpStatus = HttpStatus.BAD_REQUEST,
    public readonly errorCode?: string,
  ) {
    super(
      {
        message,
        errorCode,
      },
      statusCode,
    );
  }
}

// Business Logic Exceptions
export class UserNotFoundException extends DomainException {
  constructor(userId: string) {
    super(
      `User with ID ${userId} not found`,
      HttpStatus.NOT_FOUND,
      'USER_NOT_FOUND',
    );
  }
}

export class UserAlreadyExistsException extends DomainException {
  constructor(email: string) {
    super(
      `User with email ${email} already exists`,
      HttpStatus.CONFLICT,
      'USER_ALREADY_EXISTS',
    );
  }
}

export class InsufficientPermissionException extends DomainException {
  constructor(action: string) {
    super(
      `Insufficient permission to ${action}`,
      HttpStatus.FORBIDDEN,
      'INSUFFICIENT_PERMISSION',
    );
  }
}

export class InvalidCredentialsException extends DomainException {
  constructor() {
    super(
      'Invalid email or password',
      HttpStatus.UNAUTHORIZED,
      'INVALID_CREDENTIALS',
    );
  }
}

export class ResourceNotFoundException extends DomainException {
  constructor(resource: string, id: string) {
    super(
      `${resource} with ID ${id} not found`,
      HttpStatus.NOT_FOUND,
      'RESOURCE_NOT_FOUND',
    );
  }
}

export class ValidationException extends DomainException {
  constructor(message: string, errors?: Record<string, string[]>) {
    super(
      message,
      HttpStatus.BAD_REQUEST,
      'VALIDATION_ERROR',
    );
    this.errors = errors;
  }

  public readonly errors?: Record<string, string[]>;
}
```

**사용 예제 (Command Handler):**
```typescript
import { CommandHandler, ICommandHandler, EventBus } from '@nestjs/cqrs';
import { ConflictException, Injectable } from '@nestjs/common';
import { CreateUserCommand } from './create-user.command';
import { IUserRepository } from '../../../domain/user/repository/user.repository.interface';
import { UserAlreadyExistsException } from '../../../exceptions/domain-exceptions';

@Injectable()
@CommandHandler(CreateUserCommand)
export class CreateUserHandler implements ICommandHandler<CreateUserCommand> {
  constructor(
    private readonly userRepository: IUserRepository,
    private readonly eventBus: EventBus,
  ) {}

  async execute(command: CreateUserCommand): Promise<User> {
    // 비즈니스 규칙 검증
    const existingUser = await this.userRepository.findByEmail(command.email);

    if (existingUser) {
      // Custom Exception 발생
      throw new UserAlreadyExistsException(command.email);
    }

    // ... 나머지 로직
  }
}
```

### 예제 3: Validation Error Handling

**api/user/dto/create-user.dto.ts**
```typescript
import { ApiProperty } from '@nestjs/swagger';
import { IsEmail, IsString, IsEnum, MinLength, MaxLength, Matches } from 'class-validator';

export enum UserRole {
  USER = 'user',
  ADMIN = 'admin',
}

export class CreateUserDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail({}, { message: 'Invalid email format' })
  email: string;

  @ApiProperty({ example: 'John Doe' })
  @IsString()
  @MinLength(2, { message: 'Name must be at least 2 characters' })
  @MaxLength(100, { message: 'Name must not exceed 100 characters' })
  name: string;

  @ApiProperty({ example: 'Password123!' })
  @IsString()
  @MinLength(8, { message: 'Password must be at least 8 characters' })
  @Matches(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/, {
    message: 'Password must contain uppercase, lowercase, number and special character',
  })
  password: string;

  @ApiProperty({ example: 'user', enum: UserRole })
  @IsEnum(UserRole, { message: 'Role must be either user or admin' })
  role: UserRole;
}
```

**Validation Error Response:**
```json
{
  "success": false,
  "statusCode": 400,
  "timestamp": "2025-01-05T10:30:00.000Z",
  "path": "/api/users",
  "message": "Validation failed",
  "errors": [
    {
      "property": "email",
      "constraints": {
        "isEmail": "Invalid email format"
      }
    },
    {
      "property": "password",
      "constraints": {
        "minLength": "Password must be at least 8 characters",
        "matches": "Password must contain uppercase, lowercase, number and special character"
      }
    }
  ]
}
```

### 예제 4: Winston Logger Integration

**logger/winston.config.ts**
```typescript
import { utilities as nestWinstonModuleUtilities, WinstonModule } from 'nest-winston';
import * as winston from 'winston';

export const winstonConfig = WinstonModule.createLogger({
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.ms(),
        nestWinstonModuleUtilities.format.nestLike('MyApp', {
          colors: true,
          prettyPrint: true,
        }),
      ),
    }),
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json(),
      ),
    }),
    new winston.transports.File({
      filename: 'logs/combined.log',
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json(),
      ),
    }),
  ],
});
```

**main.ts**
```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { winstonConfig } from './logger/winston.config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule, {
    logger: winstonConfig,
  });

  await app.listen(3000);
}
bootstrap();
```

### 예제 5: Sentry Error Monitoring Integration

**app.module.ts**
```typescript
import { Module } from '@nestjs/common';
import { SentryModule } from '@ntegral/nestjs-sentry';
import { ConfigModule, ConfigService } from '@nestjs/config';

@Module({
  imports: [
    SentryModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (config: ConfigService) => ({
        dsn: config.get('SENTRY_DSN'),
        environment: config.get('NODE_ENV'),
        tracesSampleRate: 1.0,
        integrations: [
          // Add tracing
        ],
      }),
      inject: [ConfigService],
    }),
  ],
})
export class AppModule {}
```

**Sentry Interceptor:**
```typescript
import { Injectable, NestInterceptor, ExecutionContext, CallHandler } from '@nestjs/common';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import * as Sentry from '@sentry/node';

@Injectable()
export class SentryInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      catchError((error) => {
        // Sentry에 에러 전송
        Sentry.captureException(error);
        return throwError(() => error);
      }),
    );
  }
}
```

### 예제 6: HTTP Exception Helper

**exceptions/http-exception.helper.ts**
```typescript
import { HttpException, HttpStatus } from '@nestjs/common';

export class HttpExceptionHelper {
  static badRequest(message: string, errorCode?: string) {
    throw new HttpException(
      { message, errorCode },
      HttpStatus.BAD_REQUEST,
    );
  }

  static unauthorized(message: string = 'Unauthorized') {
    throw new HttpException(
      { message, errorCode: 'UNAUTHORIZED' },
      HttpStatus.UNAUTHORIZED,
    );
  }

  static forbidden(message: string = 'Forbidden') {
    throw new HttpException(
      { message, errorCode: 'FORBIDDEN' },
      HttpStatus.FORBIDDEN,
    );
  }

  static notFound(resource: string, id: string) {
    throw new HttpException(
      {
        message: `${resource} with ID ${id} not found`,
        errorCode: 'NOT_FOUND',
      },
      HttpStatus.NOT_FOUND,
    );
  }

  static conflict(message: string) {
    throw new HttpException(
      { message, errorCode: 'CONFLICT' },
      HttpStatus.CONFLICT,
    );
  }

  static internalServerError(message: string = 'Internal server error') {
    throw new HttpException(
      { message, errorCode: 'INTERNAL_ERROR' },
      HttpStatus.INTERNAL_SERVER_ERROR,
    );
  }
}
```

### 예제 7: Error Response Interface

**interfaces/error-response.interface.ts**
```typescript
export interface ErrorResponse {
  success: false;
  statusCode: number;
  timestamp: string;
  path: string;
  message: string;
  errorCode?: string;
  errors?: ValidationError[];
  stack?: string; // Development only
}

export interface ValidationError {
  property: string;
  constraints: Record<string, string>;
  children?: ValidationError[];
}

export interface DomainErrorResponse extends ErrorResponse {
  errorCode: string;
  details?: Record<string, any>;
}
```

## 설정

**.skillconfig.json**
```json
{
  "errorHandler": {
    "logLevel": "error",
    "includeStackTrace": true,
    "monitoringService": "sentry",
    "logger": "winston",
    "responseFormat": {
      "includeTimestamp": true,
      "includePath": true,
      "includeErrorCode": true,
      "exposeStackInDev": true
    },
    "customExceptions": {
      "domain": true,
      "validation": true,
      "authentication": true
    }
  }
}
```

## Error Handling 체크리스트

### Setup
- [ ] Global Exception Filter 설정
- [ ] Validation Pipe 전역 등록
- [ ] Custom Exception 클래스 생성
- [ ] Logger 통합 (Winston/Pino)
- [ ] Sentry 연동 (Production)

### Best Practices
- [ ] 일관된 에러 응답 형식
- [ ] 사용자 친화적 에러 메시지
- [ ] 민감한 정보 노출 방지
- [ ] 적절한 HTTP 상태 코드 사용
- [ ] 에러 코드 정의 (errorCode)

### Monitoring
- [ ] 에러 로그 수집
- [ ] Sentry/DataDog 알림 설정
- [ ] 에러 발생 빈도 추적
- [ ] Critical 에러 즉시 알림

## 의존성

```json
{
  "@nestjs/common": "^10.0.0",
  "nest-winston": "^1.9.0",
  "winston": "^3.11.0",
  "@ntegral/nestjs-sentry": "^4.0.0",
  "@sentry/node": "^7.90.0",
  "class-validator": "^0.14.0",
  "class-transformer": "^0.5.1"
}
```

## 버전 이력

### 2.0.0 (2025-01-05) - Major Update
- NestJS Exception Filters 기반 재작성
- Custom Domain Exceptions 추가
- Winston Logger 통합
- Sentry 모니터링 연동
- Validation Pipes 자동 통합
- 표준화된 에러 응답 형식

### 0.9.0 (2024-10-01) - Beta (Legacy)
- Express 미들웨어 기반 에러 처리

## 참고 자료

- [NestJS Exception Filters](https://docs.nestjs.com/exception-filters)
- [NestJS Pipes](https://docs.nestjs.com/pipes)
- [Winston Logger](https://github.com/winstonjs/winston)
- [Sentry for NestJS](https://docs.sentry.io/platforms/node/guides/nestjs/)
- [2025 NestJS Best Practices](../../../claudedocs/research_nestjs_best_practices_2025.md)

## 라이선스

MIT License - 조직 내부 사용 전용
