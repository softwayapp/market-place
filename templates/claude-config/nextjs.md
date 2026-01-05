# {{PROJECT_NAME}} - Next.js

> {{PROJECT_DESCRIPTION}}

## 프로젝트 개요

### 목적
{{PROJECT_PURPOSE}}

### 주요 기능
{{MAIN_FEATURES}}

### 타겟 사용자
{{TARGET_USERS}}

## 기술 스택

### 프레임워크
- **Next.js**: {{NEXTJS_VERSION}} (예: 14.2.0)
- **React**: {{REACT_VERSION}}
- **TypeScript**: {{TYPESCRIPT_VERSION}}
- **Node.js**: {{NODE_VERSION}}

### 라우팅
- **App Router** 또는 **Pages Router**: {{ROUTER_TYPE}}
- **라우팅 전략**: {{ROUTING_STRATEGY}}
- **미들웨어 사용**: {{MIDDLEWARE_USAGE}}

### UI & 스타일링
- **컴포넌트 라이브러리**: {{COMPONENT_LIBRARY}} (예: shadcn/ui, Radix UI, MUI)
- **스타일링**: {{STYLING}} (예: Tailwind CSS, CSS Modules, styled-components)
- **아이콘**: {{ICONS}} (예: Lucide React, Heroicons)
- **폰트**: {{FONTS}} (예: next/font로 최적화된 Pretendard, Inter)

### 상태 관리
- **전역 상태**: {{STATE_MANAGEMENT}} (예: Zustand, Jotai, Redux Toolkit)
- **서버 상태**: {{SERVER_STATE}} (예: TanStack Query, SWR)
- **폼 관리**: {{FORM_LIBRARY}} (예: React Hook Form, Zod)

### 데이터 페칭
- **서버 컴포넌트**: {{SERVER_COMPONENTS_USAGE}}
- **클라이언트 페칭**: {{CLIENT_FETCHING}} (예: fetch, Axios, TanStack Query)
- **API Routes** 또는 **Route Handlers**: {{API_ROUTES_USAGE}}
- **tRPC** (해당 시): {{TRPC_USAGE}}

### 인증
- **인증 방식**: {{AUTH_METHOD}} (예: NextAuth.js, Clerk, Auth0)
- **세션 관리**: {{SESSION_MANAGEMENT}}
- **보호된 라우트**: {{PROTECTED_ROUTES}}

### 데이터베이스 & ORM (풀스택 시)
- **데이터베이스**: {{DATABASE}} (예: PostgreSQL, MongoDB, Supabase)
- **ORM**: {{ORM}} (예: Prisma, Drizzle)

### 개발 도구
- **패키지 매니저**: {{PACKAGE_MANAGER}} (예: pnpm, yarn, npm)
- **린터**: ESLint with Next.js config
- **포맷터**: Prettier
- **타입 체커**: TypeScript
- **번들러**: Turbopack 또는 Webpack

## 프로젝트 구조 (App Router)

```
{{PROJECT_STRUCTURE}}
```

### 디렉토리 설명
- **`/app`**: App Router 페이지 및 레이아웃 ({{APP_DIR_DESC}})
- **`/app/api`**: API Route Handlers ({{API_DIR_DESC}})
- **`/components`**: 재사용 가능한 React 컴포넌트 ({{COMPONENTS_DIR_DESC}})
- **`/lib`**: 유틸리티 함수 및 헬퍼 ({{LIB_DIR_DESC}})
- **`/hooks`**: 커스텀 React 훅 ({{HOOKS_DIR_DESC}})
- **`/store`**: 전역 상태 관리 ({{STORE_DIR_DESC}})
- **`/types`**: TypeScript 타입 정의 ({{TYPES_DIR_DESC}})
- **`/public`**: 정적 파일 (이미지, 폰트 등)
- **`/prisma`** 또는 `/drizzle`: 데이터베이스 스키마 ({{DB_DIR_DESC}})

## 코딩 규칙

### 컴포넌트 작성
- **서버 컴포넌트 기본**: {{SERVER_COMPONENT_DEFAULT}}
- **클라이언트 컴포넌트**: 'use client' 지시어 사용 ({{CLIENT_COMPONENT_USAGE}})
- **Server Actions**: {{SERVER_ACTIONS_USAGE}}
- **컴포넌트 분리**: {{COMPONENT_SEPARATION}}

### 네이밍 컨벤션
- **페이지 파일**: `page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`
- **컴포넌트 파일**: {{COMPONENT_NAMING}} (예: PascalCase.tsx)
- **API 라우트**: `route.ts`
- **서버 액션**: {{SERVER_ACTION_NAMING}} (예: actions.ts)
- **훅**: {{HOOK_NAMING}} (예: useCamelCase.ts)
- **유틸**: {{UTIL_NAMING}} (예: camelCase.ts)

### TypeScript 규칙
- **`any` 사용**: 절대 금지
- **타입 임포트**: `import type { ... }` 사용
- **Props 타입**: interface 사용 ({{PROPS_INTERFACE}})
- **제네릭 활용**: {{GENERICS_USAGE}}
- **Strict 모드**: 활성화

### 스타일링 규칙
- **스타일 작성**: {{STYLING_METHOD}} (예: Tailwind 유틸리티 클래스)
- **컬러 팔레트**: {{COLOR_PALETTE}}
- **다크모드**: {{DARK_MODE_IMPLEMENTATION}}
- **반응형 디자인**: {{RESPONSIVE_BREAKPOINTS}}
- **CSS 변수**: {{CSS_VARIABLES}}

## Next.js 특화 규칙

### 메타데이터
```typescript
// app/layout.tsx 또는 page.tsx
export const metadata = {
  title: '{{TITLE}}',
  description: '{{DESCRIPTION}}',
}
```

### 라우팅
- **동적 라우트**: `[id]` 폴더 사용
- **병렬 라우트**: `@folder` 사용 ({{PARALLEL_ROUTES_USAGE}})
- **인터셉팅 라우트**: `(.)folder` 사용 ({{INTERCEPTING_ROUTES_USAGE}})
- **라우트 그룹**: `(folder)` 사용 ({{ROUTE_GROUPS_USAGE}})

### 데이터 페칭 전략
- **서버 컴포넌트**: async/await로 직접 페칭 ({{SERVER_FETCH_STRATEGY}})
- **캐싱**: fetch cache 옵션 활용 ({{CACHE_STRATEGY}})
- **재검증**: revalidate, revalidateTag, revalidatePath ({{REVALIDATION_STRATEGY}})
- **스트리밍**: Suspense와 loading.tsx 활용 ({{STREAMING_USAGE}})

### 이미지 최적화
```typescript
import Image from 'next/image'

// 사용 규칙: {{IMAGE_USAGE_RULES}}
// 우선순위: {{IMAGE_PRIORITY_RULES}}
// 크기 지정: {{IMAGE_SIZE_RULES}}
```

### 폰트 최적화
```typescript
import { {{FONT_IMPORT}} } from 'next/font/google'
// 또는
import localFont from 'next/font/local'

// 사용: {{FONT_USAGE}}
```

### Server Actions
```typescript
'use server'

export async function actionName(formData: FormData) {
  // {{SERVER_ACTION_RULES}}
}
```

### API Routes
```typescript
// app/api/[route]/route.ts
export async function GET(request: Request) {
  // {{API_ROUTE_RULES}}
}
```

## 상태 관리 전략

### 서버 상태
{{SERVER_STATE_STRATEGY}}

### 클라이언트 상태
{{CLIENT_STATE_STRATEGY}}

### URL 상태 (검색 파라미터)
{{URL_STATE_STRATEGY}}

### 폼 상태
{{FORM_STATE_STRATEGY}}

## 성능 최적화

### 번들 크기 최적화
- **동적 임포트**: {{DYNAMIC_IMPORT_USAGE}}
- **Tree Shaking**: {{TREE_SHAKING}}
- **번들 분석**: {{BUNDLE_ANALYZER}}

### 렌더링 최적화
- **서버 컴포넌트 우선**: {{SERVER_FIRST_STRATEGY}}
- **메모이제이션**: React.memo, useMemo, useCallback
- **스트리밍 SSR**: Suspense 활용
- **부분 프리렌더링** (PPR): {{PPR_USAGE}}

### 캐싱 전략
- **전체 라우트 캐시**: {{FULL_ROUTE_CACHE}}
- **데이터 캐시**: {{DATA_CACHE}}
- **요청 메모이제이션**: {{REQUEST_MEMOIZATION}}
- **라우터 캐시**: {{ROUTER_CACHE}}

### Core Web Vitals 목표
- **LCP**: {{LCP_TARGET}}
- **FID**: {{FID_TARGET}}
- **CLS**: {{CLS_TARGET}}

## 접근성 (a11y)

### ARIA 속성
{{ARIA_USAGE}}

### 키보드 네비게이션
{{KEYBOARD_NAV}}

### 시맨틱 HTML
{{SEMANTIC_HTML}}

### 접근성 테스트
{{A11Y_TESTING}}

## SEO 최적화

### 메타데이터 전략
{{METADATA_STRATEGY}}

### Open Graph
{{OG_STRATEGY}}

### 구조화된 데이터
{{STRUCTURED_DATA}}

### Sitemap & Robots
{{SITEMAP_ROBOTS}}

## 환경 설정

### 환경 변수
```bash
# Public 변수 (클라이언트 노출)
NEXT_PUBLIC_API_URL={{API_URL}}
NEXT_PUBLIC_SITE_URL={{SITE_URL}}

# Private 변수 (서버 전용)
DATABASE_URL={{DATABASE_URL}}
API_SECRET_KEY={{API_SECRET}}

{{ADDITIONAL_ENV_VARS}}
```

### 로컬 개발
```bash
# 설치
{{INSTALL_COMMAND}}

# 개발 서버
{{DEV_COMMAND}}

# 빌드
{{BUILD_COMMAND}}

# 프로덕션 실행
{{START_COMMAND}}

# 린트
{{LINT_COMMAND}}
```

## 테스트 전략

### 단위 테스트
- **프레임워크**: {{UNIT_TEST_FRAMEWORK}} (예: Vitest, Jest)
- **컴포넌트 테스팅**: React Testing Library
- **커버리지 목표**: {{COVERAGE_TARGET}}

### E2E 테스트
- **도구**: {{E2E_TOOL}} (예: Playwright, Cypress)
- **테스트 시나리오**: {{E2E_SCENARIOS}}

### Visual Regression
{{VISUAL_REGRESSION}}

## 에러 처리

### Error Boundary
```typescript
// app/error.tsx
'use client'

export default function Error({ error, reset }: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  // {{ERROR_HANDLING_RULES}}
}
```

### Global Error
```typescript
// app/global-error.tsx
// {{GLOBAL_ERROR_RULES}}
```

### Not Found
```typescript
// app/not-found.tsx
// {{NOT_FOUND_RULES}}
```

## 보안

### XSS 방지
{{XSS_PREVENTION}}

### CSRF 보호
{{CSRF_PROTECTION}}

### Content Security Policy
{{CSP_CONFIGURATION}}

### 환경 변수 보안
{{ENV_SECURITY}}

## 국제화 (i18n)

### 다국어 지원
{{I18N_STRATEGY}}

### 번역 관리
{{TRANSLATION_MANAGEMENT}}

### 로케일 라우팅
{{LOCALE_ROUTING}}

## 배포

### 배포 플랫폼
{{DEPLOY_PLATFORM}} (예: Vercel, Netlify, AWS)

### 빌드 설정
```javascript
// next.config.js
{{NEXT_CONFIG}}
```

### CI/CD
{{CI_CD_PIPELINE}}

### 환경별 설정
- **Development**: {{DEV_CONFIG}}
- **Staging**: {{STAGING_CONFIG}}
- **Production**: {{PROD_CONFIG}}

## 모니터링

### Analytics
{{ANALYTICS}} (예: Vercel Analytics, Google Analytics)

### 성능 모니터링
{{PERFORMANCE_MONITORING}}

### 에러 트래킹
{{ERROR_TRACKING}} (예: Sentry)

## Git 워크플로우

### 브랜치 전략
{{GIT_STRATEGY}}

### 커밋 메시지
{{COMMIT_CONVENTION}}

### PR 규칙
{{PR_RULES}}

## Claude Code 특별 지침

### 페이지 생성 시
{{PAGE_GENERATION_RULES}}

### 서버 컴포넌트 vs 클라이언트 컴포넌트
{{COMPONENT_TYPE_DECISION}}

### Server Actions 사용 시
{{SERVER_ACTION_GUIDELINES}}

### 금지 사항
- Pages Router와 App Router 혼용 금지
- 클라이언트 컴포넌트에서 서버 전용 코드 사용 금지
- 불필요한 'use client' 지시어 사용 금지
- {{ADDITIONAL_PROHIBITIONS}}

### 우선 사항
- 서버 컴포넌트 우선 사용
- 이미지는 반드시 next/image 사용
- 폰트는 next/font로 최적화
- {{ADDITIONAL_PRIORITIES}}

## 알려진 이슈

### 현재 제한사항
{{KNOWN_LIMITATIONS}}

### 브라우저 호환성
{{BROWSER_COMPATIBILITY}}

### 기술 부채
{{TECH_DEBT}}

## 리소스

### Next.js 문서
- 공식 문서: https://nextjs.org/docs
- Learn Next.js: https://nextjs.org/learn
- {{ADDITIONAL_NEXTJS_RESOURCES}}

### 디자인 시스템
{{DESIGN_SYSTEM_DOCS}}

### API 문서
{{API_DOCS}}

### 팀 가이드
{{TEAM_GUIDES}}

---

**프로젝트 타입**: Next.js {{ROUTER_TYPE}}
**Next.js 버전**: {{NEXTJS_VERSION}}
**React 버전**: {{REACT_VERSION}}
**마지막 업데이트**: {{LAST_UPDATED}}
**메인테이너**: {{MAINTAINER}}
