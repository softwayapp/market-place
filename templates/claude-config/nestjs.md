# {{PROJECT_NAME}} - Backend

> {{PROJECT_DESCRIPTION}}

## 프로젝트 개요

### 목적
{{PROJECT_PURPOSE}}

### 주요 기능
{{MAIN_FEATURES}}

### 서비스 아키텍처
{{SERVICE_ARCHITECTURE}}

## 기술 스택

### 런타임 & 프레임워크
- **런타임**: {{RUNTIME}} (예: Node.js 20, Deno, Bun)
- **프레임워크**: {{FRAMEWORK}} (예: NestJS, Express, Fastify, Hono)
- **버전**: {{VERSION}}
- **타입시스템**: {{TYPESCRIPT_VERSION}}

### 데이터베이스
- **메인 DB**: {{MAIN_DATABASE}} (예: PostgreSQL, MySQL, MongoDB)
- **ORM/ODM**: {{ORM}} (예: Prisma, TypeORM, Drizzle, Mongoose)
- **캐시**: {{CACHE}} (예: Redis, Memcached)
- **검색 엔진** (해당 시): {{SEARCH_ENGINE}} (예: Elasticsearch)

### 인증 & 보안
- **인증 방식**: {{AUTH_METHOD}} (예: JWT, Session, OAuth2)
- **인증 라이브러리**: {{AUTH_LIBRARY}} (예: Passport.js, NextAuth)
- **암호화**: {{ENCRYPTION}} (예: bcrypt, argon2)
- **보안 헤더**: {{SECURITY_HEADERS}} (예: Helmet)

### 메시징 & 큐
- **메시지 브로커**: {{MESSAGE_BROKER}} (예: RabbitMQ, Kafka, Redis Pub/Sub)
- **작업 큐**: {{JOB_QUEUE}} (예: Bull, BullMQ)

### 파일 스토리지
- **스토리지**: {{STORAGE}} (예: AWS S3, MinIO, Local File System)
- **파일 업로드**: {{FILE_UPLOAD}} (예: Multer, Formidable)

### API 설계
- **API 타입**: {{API_TYPE}} (예: REST, GraphQL, gRPC)
- **문서화**: {{API_DOCS}} (예: Swagger/OpenAPI, GraphQL Playground)
- **버전 관리**: {{API_VERSIONING}}

### 모니터링 & 로깅
- **로깅**: {{LOGGING}} (예: Winston, Pino, Bunyan)
- **APM**: {{APM}} (예: New Relic, Datadog, Elastic APM)
- **에러 트래킹**: {{ERROR_TRACKING}} (예: Sentry)

### 테스팅
- **단위 테스트**: {{UNIT_TEST}} (예: Jest, Vitest)
- **통합 테스트**: {{INTEGRATION_TEST}}
- **E2E 테스트**: {{E2E_TEST}} (예: Supertest)
- **모킹**: {{MOCKING}} (예: Jest mocks, Sinon)

### 개발 도구
- **패키지 매니저**: {{PACKAGE_MANAGER}} (예: pnpm, yarn, npm)
- **린터**: {{LINTER}} (예: ESLint)
- **포맷터**: {{FORMATTER}} (예: Prettier)
- **타입 체커**: {{TYPE_CHECKER}} (예: TypeScript)
- **프로세스 매니저**: {{PROCESS_MANAGER}} (예: PM2, Nodemon)

## 프로젝트 구조

```
{{PROJECT_STRUCTURE}}
```

### 디렉토리 설명
- **`/src`**: {{SRC_DIR_DESC}}
- **`/src/modules` 또는 `/src/features`**: {{MODULES_DIR_DESC}}
- **`/src/common` 또는 `/src/shared`**: {{COMMON_DIR_DESC}}
- **`/src/config`**: {{CONFIG_DIR_DESC}}
- **`/src/database`**: {{DATABASE_DIR_DESC}}
- **`/src/middlewares`**: {{MIDDLEWARE_DIR_DESC}}
- **`/src/utils`**: {{UTILS_DIR_DESC}}
- **`/src/types`**: {{TYPES_DIR_DESC}}
- **`/tests`**: {{TESTS_DIR_DESC}}
- **`/prisma` 또는 `/migrations`**: {{MIGRATIONS_DIR_DESC}}

## 아키텍처 패턴

### 전체 아키텍처
{{ARCHITECTURE_PATTERN}} (예: Layered, Clean Architecture, Hexagonal)

### 모듈 구조
{{MODULE_STRUCTURE}}

### 의존성 주입
{{DEPENDENCY_INJECTION}}

### 레이어 분리
- **Controller/Handler**: {{CONTROLLER_LAYER}}
- **Service/Use Case**: {{SERVICE_LAYER}}
- **Repository/Data Access**: {{REPOSITORY_LAYER}}
- **Entity/Model**: {{ENTITY_LAYER}}

## 코딩 규칙

### 네이밍 컨벤션
- **파일명**: {{FILE_NAMING}} (예: kebab-case.service.ts)
- **클래스**: {{CLASS_NAMING}} (예: PascalCase)
- **함수/메서드**: {{FUNCTION_NAMING}} (예: camelCase)
- **상수**: {{CONSTANT_NAMING}} (예: UPPER_SNAKE_CASE)
- **인터페이스**: {{INTERFACE_NAMING}} (예: IPascalCase)
- **타입**: {{TYPE_NAMING}} (예: PascalCase)
- **Enum**: {{ENUM_NAMING}} (예: PascalCase)

### TypeScript 규칙
- **`any` 사용**: {{ANY_USAGE}} (절대 금지/최소화)
- **타입 vs 인터페이스**: {{TYPE_VS_INTERFACE}}
- **제네릭 활용**: {{GENERICS_USAGE}}
- **Strict 모드**: {{STRICT_MODE}}
- **데코레이터** (NestJS 등): {{DECORATOR_USAGE}}

### 코드 스타일
- **들여쓰기**: {{INDENTATION}}
- **세미콜론**: {{SEMICOLON}}
- **따옴표**: {{QUOTES}}
- **최대 라인 길이**: {{MAX_LINE_LENGTH}}

## API 설계 가이드

### RESTful API 규칙
```
{{REST_API_RULES}}
```

### 엔드포인트 네이밍
{{ENDPOINT_NAMING}}

### HTTP 메서드 사용
{{HTTP_METHODS_USAGE}}

### 응답 형식
```typescript
{{RESPONSE_FORMAT}}
```

### 페이지네이션
{{PAGINATION_STRATEGY}}

### 필터링 & 정렬
{{FILTERING_SORTING}}

### API 버전 관리
{{API_VERSION_STRATEGY}}

## 데이터베이스 설계

### 스키마 설계 원칙
{{SCHEMA_DESIGN_PRINCIPLES}}

### 네이밍 규칙
- **테이블/컬렉션**: {{TABLE_NAMING}}
- **컬럼/필드**: {{COLUMN_NAMING}}
- **인덱스**: {{INDEX_NAMING}}
- **외래 키**: {{FK_NAMING}}

### 마이그레이션 전략
{{MIGRATION_STRATEGY}}

### 시딩
{{SEEDING_STRATEGY}}

### 쿼리 최적화
{{QUERY_OPTIMIZATION}}

## 인증 & 인가

### 인증 플로우
{{AUTH_FLOW}}

### 토큰 관리
- **액세스 토큰**: {{ACCESS_TOKEN}}
- **리프레시 토큰**: {{REFRESH_TOKEN}}
- **토큰 만료**: {{TOKEN_EXPIRATION}}

### 권한 관리 (RBAC/ABAC)
{{AUTHORIZATION_STRATEGY}}

### 비밀번호 정책
{{PASSWORD_POLICY}}

### OAuth/소셜 로그인
{{OAUTH_INTEGRATION}}

## 에러 처리

### 에러 클래스 구조
```typescript
{{ERROR_CLASS_STRUCTURE}}
```

### HTTP 상태 코드 사용
{{HTTP_STATUS_CODES}}

### 에러 응답 형식
```typescript
{{ERROR_RESPONSE_FORMAT}}
```

### 에러 로깅
{{ERROR_LOGGING}}

### 예외 처리 전략
{{EXCEPTION_HANDLING}}

## 보안

### 입력 검증
- **DTO 검증**: {{DTO_VALIDATION}} (예: class-validator, Zod)
- **SQL Injection 방지**: {{SQL_INJECTION_PREVENTION}}
- **XSS 방지**: {{XSS_PREVENTION}}
- **CSRF 방지**: {{CSRF_PREVENTION}}

### 민감 정보 관리
- **환경 변수**: {{ENV_MANAGEMENT}}
- **시크릿 관리**: {{SECRET_MANAGEMENT}}
- **API 키 관리**: {{API_KEY_MANAGEMENT}}

### Rate Limiting
{{RATE_LIMITING}}

### CORS 설정
{{CORS_CONFIGURATION}}

### 보안 헤더
{{SECURITY_HEADERS}}

### 데이터 암호화
{{DATA_ENCRYPTION}}

## 로깅 전략

### 로그 레벨
{{LOG_LEVELS}}

### 로그 형식
```
{{LOG_FORMAT}}
```

### 구조화된 로깅
{{STRUCTURED_LOGGING}}

### 로그 저장소
{{LOG_STORAGE}}

### 민감 정보 마스킹
{{LOG_MASKING}}

## 성능 최적화

### 데이터베이스 최적화
- **인덱싱 전략**: {{INDEXING_STRATEGY}}
- **쿼리 최적화**: {{QUERY_OPTIMIZATION}}
- **N+1 문제 해결**: {{N_PLUS_ONE_SOLUTION}}
- **커넥션 풀링**: {{CONNECTION_POOLING}}

### 캐싱 전략
{{CACHING_STRATEGY}}

### 비동기 처리
{{ASYNC_PROCESSING}}

### 부하 분산
{{LOAD_BALANCING}}

## 테스트 전략

### 단위 테스트
- **커버리지 목표**: {{UNIT_TEST_COVERAGE}}
- **모킹 전략**: {{MOCKING_STRATEGY}}
- **테스트 파일 위치**: {{TEST_FILE_LOCATION}}

### 통합 테스트
{{INTEGRATION_TEST_STRATEGY}}

### E2E 테스트
{{E2E_TEST_STRATEGY}}

### 테스트 데이터 관리
{{TEST_DATA_MANAGEMENT}}

### CI/CD 테스트
{{CI_CD_TESTING}}

## 환경 설정

### 환경 변수
```bash
{{ENV_VARIABLES}}
```

### 환경별 설정
- **Development**: {{DEV_CONFIG}}
- **Staging**: {{STAGING_CONFIG}}
- **Production**: {{PROD_CONFIG}}

### 로컬 개발 설정
```bash
# 설치
{{INSTALL_COMMAND}}

# 데이터베이스 설정
{{DB_SETUP_COMMAND}}

# 마이그레이션
{{MIGRATION_COMMAND}}

# 시딩
{{SEED_COMMAND}}

# 개발 서버
{{DEV_COMMAND}}

# 빌드
{{BUILD_COMMAND}}

# 프로덕션 실행
{{PROD_COMMAND}}
```

## Git 워크플로우

### 브랜치 전략
{{GIT_STRATEGY}}

### 커밋 메시지
{{COMMIT_CONVENTION}}

### PR 규칙
{{PR_RULES}}

### 코드 리뷰 체크리스트
- [ ] 비즈니스 로직 검증
- [ ] 보안 취약점 확인
- [ ] 성능 영향 평가
- [ ] 테스트 커버리지 확인
- [ ] API 문서 업데이트
- [ ] 에러 처리 적절성
- [ ] 로깅 누락 확인

## 배포

### 빌드 프로세스
{{BUILD_PROCESS}}

### 배포 환경
{{DEPLOY_ENVIRONMENT}}

### CI/CD 파이프라인
{{CI_CD_PIPELINE}}

### 환경 변수 관리
{{ENV_VAR_DEPLOYMENT}}

### 헬스 체크
{{HEALTH_CHECK}}

### 롤백 전략
{{ROLLBACK_STRATEGY}}

## 모니터링

### 메트릭 수집
{{METRICS_COLLECTION}}

### 성능 모니터링
{{PERFORMANCE_MONITORING}}

### 알림 설정
{{ALERTING}}

### 로그 모니터링
{{LOG_MONITORING}}

## 문서화

### API 문서 자동 생성
{{API_DOC_GENERATION}}

### 코드 주석 규칙
{{COMMENT_RULES}}

### README 업데이트
{{README_UPDATE}}

### Changelog 관리
{{CHANGELOG_MANAGEMENT}}

## Claude Code 특별 지침

### API 엔드포인트 생성 시
{{API_GENERATION_RULES}}

### 데이터베이스 스키마 변경 시
{{SCHEMA_CHANGE_RULES}}

### 금지 사항
{{PROHIBITED_ACTIONS}}

### 우선 사항
{{PRIORITY_RULES}}

### 자동화 워크플로우
{{AUTOMATION_WORKFLOWS}}

## 알려진 이슈

### 현재 제한사항
{{KNOWN_LIMITATIONS}}

### 기술 부채
{{TECH_DEBT}}

### 향후 개선 사항
{{FUTURE_IMPROVEMENTS}}

## 의존성 관리

### 주요 의존성
{{MAIN_DEPENDENCIES}}

### 업데이트 정책
{{UPDATE_POLICY}}

### 보안 패치
{{SECURITY_PATCHES}}

## 리소스

### 프레임워크 문서
{{FRAMEWORK_DOCS}}

### 데이터베이스 문서
{{DATABASE_DOCS}}

### API 문서
{{API_DOCS}}

### 팀 가이드
{{TEAM_GUIDES}}

### 참고 자료
{{REFERENCES}}

---

**프로젝트 타입**: Backend
**프레임워크**: {{FRAMEWORK}}
**데이터베이스**: {{MAIN_DATABASE}}
**버전**: {{VERSION}}
**마지막 업데이트**: {{LAST_UPDATED}}
**메인테이너**: {{MAINTAINER}}
