---
name: project-init-pipeline
description: Automated project initialization pipeline for Expo and Next.js with Atomic Design structure, dependency management, and folder documentation
version: 1.0.0
author: DevOps Team <devops@company.com>
category: devops
tags: [automation, expo, nextjs, init, atomic-design, pipeline]
status: stable
allowed-tools: [Read, Write, Bash, Grep, Edit]
triggers:
  - "프로젝트 초기화"
  - "Expo 프로젝트 생성"
  - "Next.js 프로젝트 생성"
  - "초기 셋업 자동화"
  - "initialize project"
  - "setup expo project"
  - "setup nextjs project"
  - "project scaffold"
dependencies: []
---

# Project Initialization Pipeline

## 목적

Expo(React Native)와 Next.js 프로젝트의 초기 셋업을 완전 자동화하여 개발 시작 시간을 단축하고 일관된 프로젝트 구조를 보장합니다.

### 자동화되는 작업

- **Atomic Design 패턴** 폴더 구조 자동 생성
- **CSS 라이브러리** 자동 설치 (Expo: NativeWind, Next.js: Tailwind CSS)
- **Pretendard 폰트** 자동 다운로드
- **폴더별 역할 가이드** (CLAUDE.md) 자동 배치
- **React Query 패턴** (queries/mutations) 강제
- **설정 파일** 자동 생성 (tailwind.config, babel.config 등)

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새로운 Expo 또는 Next.js 프로젝트를 시작할 때
- 기존 프로젝트에 표준 폴더 구조를 적용하고 싶을 때
- Atomic Design 패턴을 프로젝트에 도입하고 싶을 때
- 팀 전체가 동일한 프로젝트 구조를 사용하도록 강제하고 싶을 때
- 각 폴더의 역할과 베스트 프랙티스를 문서화하고 싶을 때

### ❌ 이 스킬을 사용하지 않을 때

- 백엔드 프로젝트 (Node.js, Python, Java 등)
- 다른 프론트엔드 프레임워크 (Vue, Angular, Svelte)
- 이미 완성된 프로젝트 구조가 있는 경우
- 커스텀 폴더 구조가 필요한 특수한 프로젝트

## 작동 방식

### 전체 프로세스

```
1. 명령어 입력 → /init:expo [이름] 또는 /init:next [이름]
   ↓
2. 프로젝트 생성 또는 기존 프로젝트 분석
   - 프레임워크 버전 감지
   - TypeScript 사용 여부 확인
   - Router 타입 감지
   ↓
3. claude.md 생성 (setup-guide 템플릿)
   ↓
4. 사용자 트리거 → "실행해" / "run it"
   ↓
5. setup-executor 스킬 자동 활성화
   ↓
6. 자동화된 셋업 실행
   - 의존성 설치
   - 폴더 구조 생성
   - CLAUDE.md 문서 배치
   - 폰트 다운로드
   - 설정 파일 생성
   ↓
7. 완료! ✨
```

### 생성되는 폴더 구조

```
프로젝트/
├── components/          # Atomic Design 컴포넌트
│   ├── atoms/          # 기본 UI 요소
│   │   └── CLAUDE.md
│   ├── molecules/      # atoms 조합
│   │   └── CLAUDE.md
│   ├── organisms/      # molecules 조합
│   │   └── CLAUDE.md
│   └── templates/      # 페이지 레이아웃
│       └── CLAUDE.md
│
├── hooks/              # React Query 훅
│   ├── CLAUDE.md
│   ├── queries/        # 데이터 조회 (GET)
│   │   └── CLAUDE.md
│   └── mutations/      # 데이터 변경 (POST/PUT/DELETE)
│       └── CLAUDE.md
│
├── utils/              # 유틸리티 함수
│   └── CLAUDE.md
├── types/              # TypeScript 타입
│   └── CLAUDE.md
├── schema/             # Validation schemas
│   └── CLAUDE.md
├── libs/               # 외부 라이브러리 래퍼
│   └── CLAUDE.md
├── stores/             # 전역 상태 관리
│   └── CLAUDE.md
├── styles/             # 전역 스타일
│   └── CLAUDE.md
├── constants/          # 앱 상수
│   └── CLAUDE.md
└── mock/               # 목 데이터
    └── CLAUDE.md
```

## 예제

### 예제 1: 새 Expo 프로젝트 생성

**사용자 입력:**
```
"/init:expo MyAwesomeApp"
```

**스킬 동작:**

1. **프로젝트 생성**
```bash
npx create-expo-app MyAwesomeApp
cd MyAwesomeApp
```

2. **프로젝트 분석**
```
✓ Expo SDK: 51.0.0
✓ TypeScript: Yes
✓ Router: Expo Router
✓ UI Library: NativeWind
```

3. **claude.md 생성**
```
📝 Setup guide created!
📄 Next step: Just say "실행해" or "run it"
```

4. **사용자가 "실행해" 입력**

5. **자동화 실행**
```
🚀 Setup Executor
━━━━━━━━━━━━━━━━━━━

✓ Installing dependencies...
  - npx expo install nativewind
  - npx expo install tailwindcss

✓ Creating Atomic Design folder structure...
  ✓ Created: components/atoms
  ✓ Created: components/molecules
  ✓ Created: hooks/queries
  ✓ Created: hooks/mutations
  ... (15개 폴더)

✓ Installing folder documentation...
  ✓ Installed: hooks/CLAUDE.md
  ✓ Installed: hooks/queries/CLAUDE.md
  ... (15개 CLAUDE.md 파일)

✓ Downloading Pretendard fonts...
  ✓ Downloaded: Pretendard-Regular.woff2 (52KB)
  ✓ Downloaded: Pretendard-Medium.woff2 (53KB)
  ✓ Downloaded: Pretendard-SemiBold.woff2 (54KB)
  ✓ Downloaded: Pretendard-Bold.woff2 (55KB)

✓ Setting up configuration files...
  ✓ tailwind.config.js created
  ✓ babel.config.js updated
  ✓ metro.config.js created
  ✓ styles/global.css created
  ✓ constants/theme.ts created

✅ Setup Complete!
```

### 예제 2: 기존 Next.js 프로젝트 셋업

**사용자 입력:**
```
# 기존 프로젝트 디렉토리에서
"/init:next"
```

**스킬 동작:**

1. **기존 프로젝트 분석**
```
📦 Using existing project: my-nextjs-app
✓ Next.js Version: 14.0.0
✓ TypeScript: Yes
✓ App Router: Yes
```

2. **claude.md 생성 및 실행**
```
사용자: "run it"

🚀 Setup Executor
... (동일한 프로세스)

✅ Setup Complete!
```

### 예제 3: 생성된 CLAUDE.md 가이드 활용

**hooks/queries/CLAUDE.md 내용 예시:**

```markdown
# hooks/queries/

> React Query를 사용한 데이터 조회 훅

## 📌 목적과 역할

서버에서 데이터를 조회(GET)하는 useQuery 훅을 관리합니다.

## 💡 코드 예제

### 사용자 목록 조회

\`\`\`typescript
// hooks/queries/useUsers.ts
import { useQuery } from '@tanstack/react-query';

export function useUsers() {
  return useQuery({
    queryKey: ['users'],
    queryFn: async () => {
      const res = await fetch('/api/users');
      return res.json();
    }
  });
}
\`\`\`

**사용법**:
\`\`\`typescript
function UserList() {
  const { data, isLoading } = useUsers();

  if (isLoading) return <div>Loading...</div>;

  return (
    <div>
      {data.map(user => (
        <div key={user.id}>{user.name}</div>
      ))}
    </div>
  );
}
\`\`\`

## ✅ 베스트 프랙티스

1. **QueryKey 일관성**: 항상 배열 형태로 정의
2. **enabled 옵션**: 조건부 쿼리 실행 시 사용
3. **staleTime**: 데이터 신선도 관리

## 🚫 안티 패턴

\`\`\`typescript
// ❌ Bad: queryKey가 문자열
useQuery('users', fetchUsers)

// ✅ Good: queryKey가 배열
useQuery({ queryKey: ['users'], queryFn: fetchUsers })
\`\`\`
```

## 설정

### 시스템 요구사항

- **Node.js**: 16.0 이상
- **npm** 또는 **yarn**
- **Git**
- **Claude Code CLI**: v1.0.0 이상

### 스킬 설치

이 스킬은 Claude Code 내부 명령어 시스템을 사용하므로 별도 설치가 필요합니다.

**파일 구조**:
```
~/.claude/
├── commands/
│   └── init/
│       ├── expo.md     # /init:expo 명령어
│       └── next.md     # /init:next 명령어
│
├── skills/
│   └── setup-executor/
│       ├── SKILL.md
│       ├── parse-claude-md.js
│       └── execute-instructions.sh
│
└── templates/
    └── claude-config/
        ├── expo-setup-guide.md
        ├── next-setup-guide.md
        ├── expo.md
        ├── next.md
        └── folders/
            ├── common/
            └── expo/next/
```

### 프로젝트별 커스터마이징

`.skillconfig.json` (선택사항):

```json
{
  "projectInitPipeline": {
    "framework": "expo",
    "cssLibrary": "nativewind",
    "fontFamily": "pretendard",
    "includeTests": true,
    "folders": [
      "components/atoms",
      "components/molecules",
      "components/organisms",
      "components/templates",
      "hooks/queries",
      "hooks/mutations"
    ]
  }
}
```

## 가이드라인

### 명령어 사용

**Expo 프로젝트**:
```bash
# 새 프로젝트
/init:expo MyApp

# 기존 프로젝트
cd my-expo-app
/init:expo
```

**Next.js 프로젝트**:
```bash
# 새 프로젝트
/init:next MyWebApp

# 기존 프로젝트
cd my-nextjs-app
/init:next
```

### 자동 트리거 키워드

setup-executor 스킬이 감지하는 키워드:

**한국어**:
- "실행해" / "실행해줘"
- "설정해" / "설정해줘"
- "셋업해" / "셋업해줘"
- "시작해" / "시작해줘"

**English**:
- "run it" / "run setup"
- "execute" / "execute setup"
- "start" / "start setup"

### 생성되는 설정 파일

**Expo (NativeWind)**:
- `tailwind.config.js` - Tailwind 설정
- `babel.config.js` - Babel + NativeWind 플러그인
- `metro.config.js` - Metro + NativeWind 통합
- `styles/global.css` - Tailwind directives

**Next.js (Tailwind CSS)**:
- `tailwind.config.ts` - Tailwind 설정
- `postcss.config.mjs` - PostCSS 설정
- `styles/globals.css` - Tailwind + 커스텀 스타일

**공통**:
- `constants/theme.ts` - 색상, 간격, 폰트 상수

## 출력 형식

### 성공 시

```
✅ Setup Complete!
━━━━━━━━━━━━━━━━━━━

📁 Folder structure created (15 folders)
📄 Documentation installed (15 CLAUDE.md files)
🎨 Fonts downloaded (4 variants)
⚙️  Configuration files created

📄 Original setup guide backed up: claude.md.setup-backup
📝 Execution log: .setup-execution.log
```

### 실패 시

```
✗ Error: claude.md not found
Please run /init:expo or /init:next first

✗ Error: claude.md is not a setup guide
This file has already been processed
```

## 의존성

### Expo 프로젝트

필수:
```json
{
  "expo": "^51.0.0",
  "nativewind": "^4.0.0",
  "tailwindcss": "^3.3.2"
}
```

선택:
```json
{
  "expo-font": "^12.0.0",
  "@tanstack/react-query": "^5.0.0"
}
```

### Next.js 프로젝트

필수:
```json
{
  "next": "^14.0.0",
  "tailwindcss": "^3.4.0",
  "postcss": "^8.4.0",
  "autoprefixer": "^10.4.0"
}
```

선택:
```json
{
  "@tanstack/react-query": "^5.0.0"
}
```

## 제한사항

- **프레임워크**: Expo와 Next.js만 지원 (React, Vue, Angular 등은 미지원)
- **Node.js 버전**: 16.0 이상 필요
- **인터넷 연결**: 폰트 다운로드 및 의존성 설치 시 필요
- **파일 시스템**: 프로젝트 루트에 쓰기 권한 필요
- **기존 파일**: claude.md가 이미 존재하면 덮어씁니다

### 알려진 이슈

1. **NativeWind 버전 충돌**: Expo SDK 버전에 따라 NativeWind 호환성 문제 발생 가능
2. **폰트 다운로드 실패**: 네트워크 문제 시 재시도 필요
3. **Windows 경로**: Windows에서 경로 구분자 문제 발생 가능

## 확장 및 커스터마이징

### 새로운 폴더 추가

1. **템플릿 작성**
```bash
vim ~/.claude/templates/claude-config/folders/common/services.md
```

2. **execute-instructions.sh 수정**
```bash
# install_folder_docs() 함수에 추가
for folder in hooks utils types schema libs services; do
  cp "$TEMPLATE_BASE/common/$folder.md" "$folder/CLAUDE.md"
done
```

### 다른 프레임워크 지원

1. **명령어 추가**: `~/.claude/commands/init/react.md`
2. **템플릿 생성**: `react-setup-guide.md`, `react.md`
3. **실행 스크립트 수정**: `setup_react_configs()` 함수 추가

## 버전 이력

### 1.0.0 (2025-01-05)
- 초기 릴리스
- Expo 및 Next.js 지원
- Atomic Design 패턴 폴더 구조
- React Query 패턴 강제 (queries/mutations)
- Pretendard 폰트 자동 다운로드
- 15개 폴더별 CLAUDE.md 자동 배치
- NativeWind (Expo) 및 Tailwind CSS (Next.js) 자동 설정

## 기여자

- DevOps Team (devops@company.com) - 초기 개발 및 유지보수
- Backend Team - 문서 템플릿 작성
- Frontend Team - Atomic Design 패턴 설계

## 지원

문제가 발생하거나 질문이 있으면:
- **Slack**: #devops-support
- **Email**: devops@company.com
- **이슈**: GitHub Issues
- **문서**: [완전 가이드](../../docs/project-init-pipeline-guide.md)

## 관련 스킬

- **ci-cd-setup**: CI/CD 파이프라인 자동 구성
- **docker-optimizer**: Docker 이미지 최적화
- **test-generator**: 테스트 자동 생성

## 참고 자료

### 공식 문서
- [Expo Documentation](https://docs.expo.dev)
- [Next.js Documentation](https://nextjs.org/docs)
- [NativeWind](https://www.nativewind.dev)
- [Tailwind CSS](https://tailwindcss.com)
- [TanStack Query](https://tanstack.com/query/latest)

### Atomic Design
- [Atomic Design Methodology](https://bradfrost.com/blog/post/atomic-web-design)
- [Atomic Design Pattern](https://atomicdesign.bradfrost.com)

## 라이선스

MIT License - 조직 내부 사용 전용

---

**완전 가이드 문서**: `docs/project-init-pipeline-guide.md`에서 시스템 아키텍처, 데이터 흐름, 템플릿 시스템, 트러블슈팅 등 상세한 내용을 확인하세요.
