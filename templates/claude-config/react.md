# {{PROJECT_NAME}} - React

> {{PROJECT_DESCRIPTION}}

## 프로젝트 개요

### 목적
{{PROJECT_PURPOSE}}

### 주요 기능
{{MAIN_FEATURES}}

### 타겟 사용자
{{TARGET_USERS}}

## 기술 스택

### 프레임워크 & 빌드 도구
- **React**: {{REACT_VERSION}} (예: 18.3.0)
- **빌드 툴**: {{BUILD_TOOL}} (예: Vite, Create React App, Webpack)
- **TypeScript**: {{TYPESCRIPT_VERSION}}
- **Node.js**: {{NODE_VERSION}}

### 라우팅
- **라우터**: {{ROUTER}} (예: React Router v6, TanStack Router, Wouter)
- **라우팅 전략**: {{ROUTING_STRATEGY}}

### UI & 스타일링
- **컴포넌트 라이브러리**: {{COMPONENT_LIBRARY}} (예: shadcn/ui, MUI, Ant Design, Chakra UI)
- **스타일링**: {{STYLING}} (예: Tailwind CSS, CSS Modules, styled-components, emotion)
- **아이콘**: {{ICONS}} (예: Lucide React, React Icons, Heroicons)
- **애니메이션**: {{ANIMATION}} (예: Framer Motion, React Spring)

### 상태 관리
- **전역 상태**: {{STATE_MANAGEMENT}} (예: Zustand, Redux Toolkit, Jotai, Recoil)
- **서버 상태**: {{SERVER_STATE}} (예: TanStack Query, SWR, RTK Query)
- **폼 관리**: {{FORM_LIBRARY}} (예: React Hook Form + Zod, Formik)

### 데이터 페칭
- **HTTP 클라이언트**: {{HTTP_CLIENT}} (예: Axios, Fetch API, ky)
- **GraphQL** (해당 시): {{GRAPHQL_CLIENT}} (예: Apollo Client, urql)
- **WebSocket** (해당 시): {{WEBSOCKET}} (예: Socket.io-client)

### 인증
- **인증 방식**: {{AUTH_METHOD}} (예: JWT, OAuth2)
- **인증 라이브러리**: {{AUTH_LIBRARY}}
- **토큰 관리**: {{TOKEN_MANAGEMENT}}

### 개발 도구
- **패키지 매니저**: {{PACKAGE_MANAGER}} (예: pnpm, yarn, npm)
- **린터**: ESLint
- **포맷터**: Prettier
- **타입 체커**: TypeScript
- **개발 서버**: {{DEV_SERVER}}

## 프로젝트 구조

```
{{PROJECT_STRUCTURE}}
```

### 디렉토리 설명
- **`/src`**: 소스 코드 루트
- **`/src/pages` 또는 `/src/routes`**: 페이지/라우트 컴포넌트 ({{PAGES_DIR_DESC}})
- **`/src/components`**: 재사용 가능한 컴포넌트 ({{COMPONENTS_DIR_DESC}})
- **`/src/features`**: 기능별 모듈 ({{FEATURES_DIR_DESC}})
- **`/src/hooks`**: 커스텀 React 훅 ({{HOOKS_DIR_DESC}})
- **`/src/store` 또는 `/src/state`**: 전역 상태 관리 ({{STORE_DIR_DESC}})
- **`/src/lib` 또는 `/src/utils`**: 유틸리티 함수 ({{LIB_DIR_DESC}})
- **`/src/types`**: TypeScript 타입 정의 ({{TYPES_DIR_DESC}})
- **`/src/api` 또는 `/src/services`**: API 호출 로직 ({{API_DIR_DESC}})
- **`/src/assets`**: 이미지, 폰트 등 정적 리소스
- **`/public`**: 빌드 시 복사되는 정적 파일

## 코딩 규칙

### 컴포넌트 작성
- **함수형 컴포넌트**: {{COMPONENT_STYLE}} (예: FC 타입 사용/미사용)
- **컴포넌트 구조**: {{COMPONENT_STRUCTURE}}
```typescript
// 컴포넌트 템플릿
{{COMPONENT_TEMPLATE}}
```

### 네이밍 컨벤션
- **컴포넌트 파일**: {{COMPONENT_NAMING}} (예: PascalCase.tsx)
- **페이지 컴포넌트**: {{PAGE_NAMING}}
- **훅**: {{HOOK_NAMING}} (예: useCamelCase.ts)
- **유틸리티**: {{UTIL_NAMING}} (예: camelCase.ts)
- **상수**: {{CONSTANT_NAMING}} (예: UPPER_SNAKE_CASE)
- **타입/인터페이스**: {{TYPE_NAMING}} (예: PascalCase, IPascalCase)

### Props 정의
```typescript
// Props 작성 규칙
{{PROPS_DEFINITION_RULES}}

// 예시
interface ButtonProps {
  children: React.ReactNode
  variant?: 'primary' | 'secondary'
  onClick?: () => void
}
```

### TypeScript 규칙
- **`any` 사용**: 절대 금지
- **타입 vs 인터페이스**: {{TYPE_VS_INTERFACE}}
- **제네릭 활용**: {{GENERICS_USAGE}}
- **유틸리티 타입**: {{UTILITY_TYPES}} (Partial, Pick, Omit 등)
- **Strict 모드**: 활성화

### 스타일링 규칙
- **스타일 작성 방법**: {{STYLING_METHOD}}
- **컬러 시스템**: {{COLOR_SYSTEM}}
- **타이포그래피**: {{TYPOGRAPHY}}
- **간격 시스템**: {{SPACING_SYSTEM}}
- **반응형 브레이크포인트**: {{BREAKPOINTS}}
- **다크모드**: {{DARK_MODE}}

## 상태 관리 전략

### 전역 상태
{{GLOBAL_STATE_STRATEGY}}

### 로컬 상태
{{LOCAL_STATE_STRATEGY}}

### 서버 상태 캐싱
{{SERVER_STATE_CACHING}}

### URL 상태
{{URL_STATE_STRATEGY}}

### 폼 상태
{{FORM_STATE_STRATEGY}}

## 커스텀 훅 작성

### 훅 작성 규칙
```typescript
// 커스텀 훅 템플릿
{{CUSTOM_HOOK_TEMPLATE}}
```

### 공통 훅 패턴
- **데이터 페칭 훅**: {{DATA_FETCHING_HOOK}}
- **로컬 스토리지 훅**: {{LOCAL_STORAGE_HOOK}}
- **미디어 쿼리 훅**: {{MEDIA_QUERY_HOOK}}
- **디바운스/쓰로틀 훅**: {{DEBOUNCE_THROTTLE_HOOK}}

## 라우팅

### 라우트 정의
```typescript
// 라우트 설정
{{ROUTE_CONFIGURATION}}
```

### 중첩 라우팅
{{NESTED_ROUTING}}

### 보호된 라우트
{{PROTECTED_ROUTES}}

### 레이지 로딩
{{LAZY_LOADING}}

## API 통신

### API 클라이언트 설정
```typescript
// API 클라이언트 구성
{{API_CLIENT_SETUP}}
```

### 엔드포인트 관리
{{ENDPOINT_MANAGEMENT}}

### 에러 핸들링
{{API_ERROR_HANDLING}}

### 인터셉터
{{INTERCEPTORS}}

### 재시도 전략
{{RETRY_STRATEGY}}

## 성능 최적화

### 렌더링 최적화
- **React.memo**: {{MEMO_USAGE}}
- **useMemo**: {{USE_MEMO_USAGE}}
- **useCallback**: {{USE_CALLBACK_USAGE}}
- **가상화**: {{VIRTUALIZATION}} (예: react-window, TanStack Virtual)

### 코드 스플리팅
```typescript
// 동적 임포트
{{CODE_SPLITTING_STRATEGY}}
```

### 번들 최적화
{{BUNDLE_OPTIMIZATION}}

### 이미지 최적화
{{IMAGE_OPTIMIZATION}}

### 성능 측정
{{PERFORMANCE_MEASUREMENT}}

## 접근성 (a11y)

### ARIA 속성
{{ARIA_USAGE}}

### 키보드 네비게이션
{{KEYBOARD_NAV}}

### 포커스 관리
{{FOCUS_MANAGEMENT}}

### 접근성 테스팅
{{A11Y_TESTING}} (예: axe-core, jest-axe)

## 테스트 전략

### 단위 테스트
- **프레임워크**: {{UNIT_TEST_FRAMEWORK}} (예: Vitest, Jest)
- **React 테스팅**: React Testing Library
- **테스트 작성 규칙**: {{TEST_WRITING_RULES}}
- **커버리지 목표**: {{COVERAGE_TARGET}}

### 컴포넌트 테스트 패턴
```typescript
// 컴포넌트 테스트 템플릿
{{COMPONENT_TEST_TEMPLATE}}
```

### 훅 테스트
{{HOOK_TESTING}} (예: @testing-library/react-hooks)

### E2E 테스트
- **도구**: {{E2E_TOOL}} (예: Playwright, Cypress)
- **테스트 시나리오**: {{E2E_SCENARIOS}}

### Visual Regression
{{VISUAL_REGRESSION}}

## 환경 설정

### 환경 변수
```bash
# Vite 환경 변수
VITE_API_URL={{API_URL}}
VITE_APP_NAME={{APP_NAME}}

# CRA 환경 변수
REACT_APP_API_URL={{API_URL}}
REACT_APP_NAME={{APP_NAME}}

{{ADDITIONAL_ENV_VARS}}
```

### 환경별 설정
- **Development**: {{DEV_CONFIG}}
- **Staging**: {{STAGING_CONFIG}}
- **Production**: {{PROD_CONFIG}}

### 로컬 개발
```bash
# 설치
{{INSTALL_COMMAND}}

# 개발 서버
{{DEV_COMMAND}}

# 빌드
{{BUILD_COMMAND}}

# 프리뷰 (Vite)
{{PREVIEW_COMMAND}}

# 테스트
{{TEST_COMMAND}}

# 린트
{{LINT_COMMAND}}
```

## 에러 처리

### Error Boundary
```typescript
// Error Boundary 구현
{{ERROR_BOUNDARY_IMPLEMENTATION}}
```

### 전역 에러 핸들링
{{GLOBAL_ERROR_HANDLING}}

### 에러 로깅
{{ERROR_LOGGING}}

## 보안

### XSS 방지
{{XSS_PREVENTION}}

### CSRF 보호
{{CSRF_PROTECTION}}

### Content Security Policy
{{CSP}}

### 민감 정보 관리
{{SENSITIVE_DATA}}

## 국제화 (i18n)

### i18n 라이브러리
{{I18N_LIBRARY}} (예: react-i18next, react-intl)

### 번역 파일 관리
{{TRANSLATION_MANAGEMENT}}

### 언어 전환
{{LANGUAGE_SWITCHING}}

## 빌드 & 배포

### 빌드 설정
```javascript
// vite.config.ts 또는 webpack.config.js
{{BUILD_CONFIG}}
```

### 배포 플랫폼
{{DEPLOY_PLATFORM}} (예: Vercel, Netlify, AWS S3 + CloudFront)

### CI/CD
{{CI_CD_PIPELINE}}

### 환경별 빌드
{{ENV_BUILD_STRATEGY}}

## 모니터링

### Analytics
{{ANALYTICS}}

### 성능 모니터링
{{PERFORMANCE_MONITORING}}

### 에러 트래킹
{{ERROR_TRACKING}} (예: Sentry, LogRocket)

### 사용자 행동 분석
{{USER_BEHAVIOR_TRACKING}}

## Git 워크플로우

### 브랜치 전략
{{GIT_STRATEGY}}

### 커밋 메시지
{{COMMIT_CONVENTION}}

### PR 규칙
{{PR_RULES}}

## Claude Code 특별 지침

### 컴포넌트 생성 시
{{COMPONENT_GENERATION_RULES}}

### 상태 관리 선택
{{STATE_MANAGEMENT_DECISION}}

### 금지 사항
- 클래스 컴포넌트 사용 금지
- 인라인 함수 정의 (렌더링 내) 최소화
- any 타입 사용 금지
- {{ADDITIONAL_PROHIBITIONS}}

### 우선 사항
- 함수형 컴포넌트 + 훅 사용
- TypeScript strict 모드 준수
- 접근성 고려 (ARIA, 시맨틱 HTML)
- {{ADDITIONAL_PRIORITIES}}

### 자동화 워크플로우
{{AUTOMATION_WORKFLOWS}}

## 알려진 이슈

### 브라우저 호환성
{{BROWSER_COMPATIBILITY}}

### 현재 제한사항
{{KNOWN_LIMITATIONS}}

### 기술 부채
{{TECH_DEBT}}

## 디자인 시스템

### 컴포넌트 라이브러리
{{COMPONENT_LIBRARY_DOCS}}

### 디자인 토큰
{{DESIGN_TOKENS}}

### Storybook (해당 시)
{{STORYBOOK_USAGE}}

## 리소스

### React 문서
- 공식 문서: https://react.dev
- React Patterns: {{REACT_PATTERNS}}
- {{ADDITIONAL_REACT_RESOURCES}}

### 빌드 툴 문서
{{BUILD_TOOL_DOCS}}

### 라우터 문서
{{ROUTER_DOCS}}

### 상태 관리 문서
{{STATE_MANAGEMENT_DOCS}}

### API 문서
{{API_DOCS}}

### 팀 가이드
{{TEAM_GUIDES}}

---

**프로젝트 타입**: React SPA
**React 버전**: {{REACT_VERSION}}
**빌드 툴**: {{BUILD_TOOL}}
**마지막 업데이트**: {{LAST_UPDATED}}
**메인테이너**: {{MAINTAINER}}
