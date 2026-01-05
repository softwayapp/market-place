# Expo/Next.js 프로젝트 초기화 파이프라인 완전 가이드

> 자동화된 프로젝트 셋업 시스템 - 설계부터 실행까지 전체 분석

**작성일**: 2025-01-05
**버전**: 1.0.0
**목적**: Expo/Next.js 프로젝트 초기 셋팅 자동화 및 개발자 가이드 자동 배치

---

## 📑 목차

1. [시스템 개요](#1-시스템-개요)
2. [전체 아키텍처](#2-전체-아키텍처)
3. [워크플로우](#3-워크플로우)
4. [파일 구조 맵](#4-파일-구조-맵)
5. [핵심 컴포넌트 상세](#5-핵심-컴포넌트-상세)
6. [데이터 흐름 분석](#6-데이터-흐름-분석)
7. [템플릿 시스템](#7-템플릿-시스템)
8. [사용 예시](#8-사용-예시)
9. [확장 및 커스터마이징](#9-확장-및-커스터마이징)
10. [트러블슈팅](#10-트러블슈팅)

---

## 1. 시스템 개요

### 1.1 목적

Expo(React Native)와 Next.js 프로젝트의 초기 셋업을 완전 자동화하여:
- Atomic Design 패턴 폴더 구조 자동 생성
- 프레임워크별 CSS 라이브러리 자동 설치 (Expo: NativeWind, Next.js: Tailwind CSS)
- Pretendard 폰트 자동 다운로드
- 각 폴더별 역할 가이드(CLAUDE.md) 자동 배치
- React Query 패턴 (queries/mutations) 강제

### 1.2 핵심 기능

| 기능 | 설명 |
|------|------|
| **프로젝트 생성** | `/init:expo [이름]` 또는 `/init:next [이름]`으로 프로젝트 생성 또는 기존 프로젝트 분석 |
| **자동 셋업** | 자연어("실행해", "run it") 트리거로 전체 셋업 자동 실행 |
| **폴더 구조** | Atomic Design 패턴 + React Query 패턴 자동 생성 |
| **문서 자동 배치** | 각 폴더에 역할별 CLAUDE.md 자동 설치 |
| **프레임워크 감지** | expo/nextjs 자동 감지하여 적절한 설정 적용 |

### 1.3 기술 스택

- **셸 스크립트**: Bash (프로젝트 생성, 폴더 구조 생성, 파일 설치)
- **Node.js**: JavaScript (템플릿 파싱, JSON 처리)
- **템플릿 엔진**: sed (변수 치환)
- **프레임워크**: Expo SDK, Next.js
- **CSS**: NativeWind (Expo), Tailwind CSS (Next.js)
- **상태 관리 패턴**: React Query (TanStack Query)

---

## 2. 전체 아키텍처

### 2.1 시스템 구성도

```
┌─────────────────────────────────────────────────────────────┐
│                      Claude Code CLI                         │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    명령어 레이어                              │
│  /init:expo [PROJECT_NAME]  │  /init:next [PROJECT_NAME]    │
│  (~/.claude/commands/init/)                                  │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    템플릿 생성                                │
│  expo-setup-guide.md  │  next-setup-guide.md                │
│  → 프로젝트 루트/claude.md                                   │
└─────────────────────────────────────────────────────────────┘
                              │
                    사용자: "실행해" / "run it"
                              ▼
┌─────────────────────────────────────────────────────────────┐
│              setup-executor 스킬 (자동 트리거)               │
│  (~/.claude/skills/setup-executor/)                         │
│  - SKILL.md: 트리거 패턴 정의                                │
│  - parse-claude-md.js: 템플릿 파싱                          │
│  - execute-instructions.sh: 실행 로직                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    실행 단계                                  │
│  1. Validation        - claude.md 검증                       │
│  2. Parse             - JSON 파싱                            │
│  3. Execute Setup     - 의존성, 폴더, 폰트, 설정            │
│  4. Install Docs      - CLAUDE.md 배치                      │
│  5. Finalize          - 최종 문서 교체                       │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                프로젝트 구조 + 문서 생성                      │
│  components/atoms/CLAUDE.md                                  │
│  hooks/queries/CLAUDE.md                                     │
│  utils/CLAUDE.md                                             │
│  ... (모든 폴더)                                             │
│  claude.md (최종 프로젝트 문서)                              │
└─────────────────────────────────────────────────────────────┘
```

### 2.2 레이어 설명

#### 레이어 1: 명령어 레이어
- **위치**: `~/.claude/commands/init/`
- **파일**: `expo.md`, `next.md`
- **역할**:
  - 프로젝트 생성 또는 기존 프로젝트 분석
  - 프레임워크 버전, TypeScript, Router 감지
  - 초기 `claude.md` 생성 (setup-guide 템플릿 사용)

#### 레이어 2: 스킬 레이어
- **위치**: `~/.claude/skills/setup-executor/`
- **파일**: `SKILL.md`, `parse-claude-md.js`, `execute-instructions.sh`
- **역할**:
  - 사용자의 자연어 트리거 감지
  - claude.md 파싱 및 검증
  - 전체 셋업 프로세스 실행

#### 레이어 3: 템플릿 레이어
- **위치**: `~/.claude/templates/claude-config/`
- **파일**: setup-guide 템플릿, 최종 문서 템플릿, 폴더별 가이드
- **역할**:
  - 초기 셋업 가이드 제공
  - 최종 프로젝트 문서 제공
  - 각 폴더별 역할 가이드 제공

---

## 3. 워크플로우

### 3.1 전체 플로우 다이어그램

```
사용자 입력: /init:expo MyApp
         │
         ▼
┌────────────────────────┐
│ 1. 프로젝트 생성 또는   │
│    기존 프로젝트 분석   │
└────────────────────────┘
         │
         ▼
┌────────────────────────┐
│ 2. 프레임워크 정보 수집 │
│    - Expo 버전         │
│    - TypeScript 여부   │
│    - Router 타입       │
│    - UI 라이브러리     │
└────────────────────────┘
         │
         ▼
┌────────────────────────┐
│ 3. claude.md 생성      │
│    (setup-guide 템플릿) │
│    - 변수 치환         │
│    - 프로젝트 루트 저장 │
└────────────────────────┘
         │
         ▼
    사용자에게 표시:
    "실행해" / "run it" 입력 대기
         │
         ▼
┌────────────────────────┐
│ 4. setup-executor 트리거│
│    - 자연어 패턴 매칭   │
│    - SKILL.md 활성화   │
└────────────────────────┘
         │
         ▼
┌────────────────────────┐
│ 5. Validation          │
│    - claude.md 존재?   │
│    - setup-guide?      │
└────────────────────────┘
         │
         ▼
┌────────────────────────┐
│ 6. Parse Instructions  │
│    - parse-claude-md.js│
│    - JSON 생성         │
└────────────────────────┘
         │
         ▼
┌────────────────────────┐
│ 7. Execute Setup       │
│    ├─ 의존성 설치      │
│    ├─ 폴더 생성        │
│    ├─ Barrel exports   │
│    ├─ CLAUDE.md 설치   │
│    ├─ 폰트 다운로드    │
│    └─ 설정 파일 생성   │
└────────────────────────┘
         │
         ▼
┌────────────────────────┐
│ 8. Finalize            │
│    - claude.md 백업    │
│    - 최종 문서 교체    │
└────────────────────────┘
         │
         ▼
    셋업 완료! 🎉
```

### 3.2 단계별 상세 설명

#### Phase 1: 프로젝트 생성 (expo.md / next.md)

```bash
# 새 프로젝트 생성
if [ -n "$PROJECT_NAME" ]; then
  npx create-expo-app "$PROJECT_NAME"
  cd "$PROJECT_NAME"
# 기존 프로젝트 분석
else
  PROJECT_NAME=$(basename "$PWD")
  # Expo 프로젝트 검증
fi
```

**출력**:
- 새 프로젝트 폴더 또는 기존 폴더 진입
- 프로젝트 정보 수집

#### Phase 2: 프레임워크 분석

```bash
EXPO_VERSION=$(grep -oP '"expo":\s*"[\^~]?\K[^"]+' package.json)
TYPESCRIPT="Yes" / "No" (tsconfig.json 존재 여부)
ROUTER="Expo Router" / "React Navigation" / "Not detected"
UI_LIBRARY="NativeWind" / "React Native Paper" / "None"
```

**출력**:
- 프레임워크 메타데이터

#### Phase 3: 초기 claude.md 생성

```bash
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{EXPO_VERSION}}/$EXPO_VERSION/g" \
    -e "s/{{TYPESCRIPT}}/$TYPESCRIPT/g" \
    "$TEMPLATE" > claude.md
```

**출력**:
- `claude.md` (setup-guide)
- 변수가 실제 값으로 치환됨

#### Phase 4: 사용자 트리거 대기

**claude.md 내용 일부**:
```markdown
> **실행 방법**: 아래 중 하나를 말하면 자동으로 설정이 시작됩니다:
> - "실행해" / "설정해" / "셋업해" / "시작해"
> - "run it" / "execute" / "start setup"
```

**사용자 입력**: "실행해"

#### Phase 5: setup-executor 활성화

**SKILL.md 트리거 패턴**:
```yaml
triggers:
  - "claude.md대로 실행"
  - "실행해" / "설정해" / "셋업해"
  - "run setup" / "execute setup"
  - "run it" / "execute it"
```

**조건**:
- claude.md 파일 존재
- "Auto-generated by /init:" 문구 포함 (setup-guide 검증)

#### Phase 6: Validation

```bash
validate_setup() {
  if [ ! -f "$CLAUDE_MD" ]; then
    error "claude.md not found"
    exit 1
  fi

  if ! grep -q "Auto-generated by /init:" "$CLAUDE_MD"; then
    error "claude.md is not a setup guide"
    exit 1
  fi
}
```

**출력**:
- 검증 통과 또는 에러

#### Phase 7: Parse Instructions

```bash
node "$PARSER_SCRIPT" "$CLAUDE_MD" > "$INSTRUCTIONS_JSON"
```

**parse-claude-md.js 출력 (JSON)**:
```json
{
  "metadata": {
    "framework": "expo",
    "font_dir": "assets/fonts"
  },
  "dependencies": [
    "npx expo install nativewind",
    "npx expo install tailwindcss",
    "npm install --save-dev tailwindcss@3.3.2"
  ],
  "folders": [
    "components/atoms",
    "components/molecules",
    "hooks",
    "hooks/queries",
    "hooks/mutations",
    ...
  ],
  "fonts": [
    {
      "name": "Pretendard-Regular.woff2",
      "url": "https://..."
    }
  ]
}
```

#### Phase 8: Execute Setup

##### 8-1. 의존성 설치

```bash
install_dependencies() {
  DEPS=$(node -e "
    const data = require('$INSTRUCTIONS_JSON');
    data.dependencies.forEach(cmd => console.log(cmd));
  ")

  echo "$DEPS" | while read -r cmd; do
    eval "$cmd"
  done
}
```

**실행 예시 (Expo)**:
```bash
npx expo install nativewind
npx expo install tailwindcss
npm install --save-dev tailwindcss@3.3.2
```

**실행 예시 (Next.js)**:
```bash
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p
```

##### 8-2. 폴더 생성

```bash
create_folders() {
  FOLDERS=$(node -e "
    const data = require('$INSTRUCTIONS_JSON');
    data.folders.forEach(folder => console.log(folder));
  ")

  echo "$FOLDERS" | while read -r folder; do
    mkdir -p "$folder"
  done
}
```

**생성되는 폴더**:
```
components/
  atoms/
  molecules/
  organisms/
  templates/
hooks/
  queries/
  mutations/
utils/
types/
schema/
libs/
stores/
styles/
constants/
mock/
```

##### 8-3. Barrel Exports 생성

```bash
create_barrel_exports() {
  # components/index.ts
  cat > components/index.ts <<'EOF'
export * from './atoms';
export * from './molecules';
export * from './organisms';
export * from './templates';
EOF

  # hooks/index.ts (React Query 패턴)
  cat > hooks/index.ts <<'EOF'
export * from './queries';
export * from './mutations';
EOF

  # hooks/queries/index.ts
  cat > hooks/queries/index.ts <<'EOF'
// Export all query hooks here
// Example: export { useUsers } from './useUsers';
EOF

  # hooks/mutations/index.ts
  cat > hooks/mutations/index.ts <<'EOF'
// Export all mutation hooks here
// Example: export { useCreateUser } from './useCreateUser';
EOF

  # utils/index.ts, types/index.ts, ...
  for folder in utils types schema libs stores constants mock; do
    cat > "$folder/index.ts" <<EOF
// Export all $folder here
EOF
  done
}
```

##### 8-4. CLAUDE.md 설치

```bash
install_folder_docs() {
  FRAMEWORK=$(node -e "console.log(require('$INSTRUCTIONS_JSON').metadata.framework)")
  TEMPLATE_BASE="$HOME/.claude/templates/claude-config/folders"

  # 공통 폴더 (hooks, utils, types, ...)
  for folder in hooks utils types schema libs stores constants mock; do
    if [ -d "$folder" ]; then
      cp "$TEMPLATE_BASE/common/$folder.md" "$folder/CLAUDE.md"
    fi
  done

  # hooks 하위 폴더
  if [ -d "hooks/queries" ]; then
    cp "$TEMPLATE_BASE/common/hooks-queries.md" "hooks/queries/CLAUDE.md"
  fi

  if [ -d "hooks/mutations" ]; then
    cp "$TEMPLATE_BASE/common/hooks-mutations.md" "hooks/mutations/CLAUDE.md"
  fi

  # 프레임워크별 폴더 (components, styles)
  if [ "$FRAMEWORK" = "expo" ]; then
    cp "$TEMPLATE_BASE/expo/components-atoms.md" "components/atoms/CLAUDE.md"
    cp "$TEMPLATE_BASE/expo/components-molecules.md" "components/molecules/CLAUDE.md"
    cp "$TEMPLATE_BASE/expo/components-organisms.md" "components/organisms/CLAUDE.md"
    cp "$TEMPLATE_BASE/expo/components-templates.md" "components/templates/CLAUDE.md"
    cp "$TEMPLATE_BASE/expo/styles.md" "styles/CLAUDE.md"
  elif [ "$FRAMEWORK" = "nextjs" ]; then
    cp "$TEMPLATE_BASE/next/components-atoms.md" "components/atoms/CLAUDE.md"
    # ... (Next.js 전용 템플릿)
  fi
}
```

**설치되는 CLAUDE.md**:
```
hooks/CLAUDE.md                     # hooks 메인 가이드
hooks/queries/CLAUDE.md             # React Query - 데이터 조회
hooks/mutations/CLAUDE.md           # React Query - 데이터 변경
utils/CLAUDE.md                     # 유틸리티 함수
types/CLAUDE.md                     # TypeScript 타입
schema/CLAUDE.md                    # Validation schemas
libs/CLAUDE.md                      # 외부 라이브러리 래퍼
stores/CLAUDE.md                    # 전역 상태 관리
constants/CLAUDE.md                 # 앱 상수
mock/CLAUDE.md                      # 목 데이터
components/atoms/CLAUDE.md          # Atoms 가이드
components/molecules/CLAUDE.md      # Molecules 가이드
components/organisms/CLAUDE.md      # Organisms 가이드
components/templates/CLAUDE.md      # Templates 가이드
styles/CLAUDE.md                    # 스타일링 가이드
```

##### 8-5. 폰트 다운로드

```bash
download_fonts() {
  FONT_DIR=$(node -e "console.log(require('$INSTRUCTIONS_JSON').metadata.font_dir)")
  mkdir -p "$FONT_DIR"

  FONTS=$(node -e "
    const data = require('$INSTRUCTIONS_JSON');
    data.fonts.forEach(font => console.log(JSON.stringify(font)));
  ")

  echo "$FONTS" | while read -r font_json; do
    NAME=$(echo "$font_json" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).name)")
    URL=$(echo "$font_json" | node -e "console.log(JSON.parse(require('fs').readFileSync(0, 'utf-8')).url)")
    OUTPUT="$FONT_DIR/$NAME"

    # Retry 로직 (최대 3회)
    RETRY=0
    MAX_RETRIES=3
    while [ $RETRY -lt $MAX_RETRIES ]; do
      if curl -L -o "$OUTPUT" "$URL" 2>/dev/null; then
        break
      else
        RETRY=$((RETRY + 1))
      fi
    done
  done
}
```

**다운로드되는 폰트**:
- Pretendard-Regular.woff2
- Pretendard-Medium.woff2
- Pretendard-SemiBold.woff2
- Pretendard-Bold.woff2

**위치**:
- Expo: `assets/fonts/`
- Next.js: `public/fonts/`

##### 8-6. 설정 파일 생성

**Expo 설정 (setup_expo_configs)**:

```bash
# tailwind.config.js
cat > tailwind.config.js <<'EOF'
module.exports = {
  content: [
    "./app/**/*.{js,jsx,ts,tsx}",
    "./components/**/*.{js,jsx,ts,tsx}",
  ],
  presets: [require("nativewind/preset")],
  theme: {
    extend: {
      colors: {
        primary: "#007AFF",
        secondary: "#5856D6",
      },
      fontFamily: {
        pretendard: ["Pretendard-Regular"],
        "pretendard-medium": ["Pretendard-Medium"],
      },
    },
  },
};
EOF

# babel.config.js
cat > babel.config.js <<'EOF'
module.exports = function (api) {
  api.cache(true);
  return {
    presets: [
      ["babel-preset-expo", { jsxImportSource: "nativewind" }]
    ],
    plugins: ["nativewind/babel"],
  };
};
EOF

# metro.config.js
cat > metro.config.js <<'EOF'
const { getDefaultConfig } = require("expo/metro-config");
const { withNativeWind } = require('nativewind/metro');
const config = getDefaultConfig(__dirname);
module.exports = withNativeWind(config, { input: './styles/global.css' });
EOF

# styles/global.css
mkdir -p styles
cat > styles/global.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF
```

**Next.js 설정 (setup_nextjs_configs)**:

```bash
# tailwind.config.ts
cat > tailwind.config.ts <<'EOF'
import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#007AFF",
      },
      fontFamily: {
        pretendard: ["var(--font-pretendard)"],
      },
    },
  },
};

export default config;
EOF

# postcss.config.mjs
cat > postcss.config.mjs <<'EOF'
const config = {
  plugins: {
    tailwindcss: {},
    autoprefixer: {},
  },
};
export default config;
EOF

# styles/globals.css
mkdir -p styles
cat > styles/globals.css <<'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    --font-pretendard: "Pretendard", sans-serif;
  }
}
EOF
```

**공통 설정 (create_theme_constants)**:

```bash
# constants/theme.ts
mkdir -p constants
cat > constants/theme.ts <<'EOF'
export const colors = {
  primary: "#007AFF",
  secondary: "#5856D6",
  success: "#34C759",
  warning: "#FF9500",
  danger: "#FF3B30",
} as const;

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
  lg: 24,
  xl: 32,
} as const;
EOF

# constants/index.ts
cat > constants/index.ts <<'EOF'
export * from './theme';
EOF
```

#### Phase 9: Finalize

```bash
finalize_setup() {
  # 백업
  cp "$CLAUDE_MD" "$BACKUP_FILE"

  # 최종 문서 교체
  FRAMEWORK=$(node -e "console.log(require('$INSTRUCTIONS_JSON').metadata.framework)")
  TEMPLATE_BASE="$HOME/.claude/templates/claude-config"

  if [ "$FRAMEWORK" = "expo" ]; then
    cp "$TEMPLATE_BASE/expo.md" "$CLAUDE_MD"
  elif [ "$FRAMEWORK" = "nextjs" ]; then
    cp "$TEMPLATE_BASE/next.md" "$CLAUDE_MD"
  fi
}
```

**결과**:
- `claude.md.setup-backup` (원본 백업)
- `claude.md` (최종 프로젝트 문서로 교체)

---

## 4. 파일 구조 맵

### 4.1 Claude Code 설정 파일 구조

```
~/.claude/
├── commands/
│   └── init/
│       ├── expo.md                 # /init:expo 명령어
│       └── next.md                 # /init:next 명령어
│
├── skills/
│   └── setup-executor/
│       ├── SKILL.md                # 스킬 정의 및 트리거
│       ├── parse-claude-md.js      # 템플릿 파싱 스크립트
│       └── execute-instructions.sh # 셋업 실행 스크립트
│
└── templates/
    └── claude-config/
        ├── expo-setup-guide.md     # Expo 초기 셋업 가이드
        ├── next-setup-guide.md     # Next.js 초기 셋업 가이드
        ├── expo.md                 # Expo 최종 프로젝트 문서
        ├── next.md                 # Next.js 최종 프로젝트 문서
        │
        └── folders/                # 폴더별 가이드 템플릿
            ├── common/             # 공통 템플릿
            │   ├── hooks.md
            │   ├── hooks-queries.md
            │   ├── hooks-mutations.md
            │   ├── utils.md
            │   ├── types.md
            │   ├── schema.md
            │   ├── libs.md
            │   ├── stores.md
            │   ├── constants.md
            │   └── mock.md
            │
            ├── expo/               # Expo 전용 템플릿
            │   ├── components-atoms.md
            │   ├── components-molecules.md
            │   ├── components-organisms.md
            │   ├── components-templates.md
            │   └── styles.md
            │
            └── next/               # Next.js 전용 템플릿
                ├── components-atoms.md
                ├── components-molecules.md
                ├── components-organisms.md
                ├── components-templates.md
                └── styles.md
```

### 4.2 생성되는 프로젝트 구조

```
MyApp/                              # 프로젝트 루트
├── claude.md                       # 최종 프로젝트 문서
├── claude.md.setup-backup          # 원본 백업
├── .setup-execution.log            # 셋업 로그
│
├── app/                            # Expo Router / Next.js App Router
│
├── components/                     # Atomic Design 컴포넌트
│   ├── CLAUDE.md                   # (미래 확장)
│   ├── index.ts                    # Barrel export
│   │
│   ├── atoms/
│   │   ├── CLAUDE.md               # Atoms 가이드
│   │   └── index.ts
│   │
│   ├── molecules/
│   │   ├── CLAUDE.md               # Molecules 가이드
│   │   └── index.ts
│   │
│   ├── organisms/
│   │   ├── CLAUDE.md               # Organisms 가이드
│   │   └── index.ts
│   │
│   └── templates/
│       ├── CLAUDE.md               # Templates 가이드
│       └── index.ts
│
├── hooks/                          # React Query 훅
│   ├── CLAUDE.md                   # hooks 메인 가이드
│   ├── index.ts                    # export * from './queries'; ...
│   │
│   ├── queries/                    # 데이터 조회 (GET)
│   │   ├── CLAUDE.md               # useQuery 가이드
│   │   └── index.ts
│   │
│   ├── mutations/                  # 데이터 변경 (POST/PUT/DELETE)
│   │   ├── CLAUDE.md               # useMutation 가이드
│   │   └── index.ts
│   │
│   └── useDebounce.ts              # 일반 유틸리티 훅
│
├── utils/                          # 유틸리티 함수
│   ├── CLAUDE.md                   # utils 가이드
│   └── index.ts
│
├── types/                          # TypeScript 타입
│   ├── CLAUDE.md                   # types 가이드
│   └── index.ts
│
├── schema/                         # Validation schemas (Zod)
│   ├── CLAUDE.md                   # schema 가이드
│   └── index.ts
│
├── libs/                           # 외부 라이브러리 래퍼
│   ├── CLAUDE.md                   # libs 가이드
│   └── index.ts
│
├── stores/                         # 전역 상태 관리 (Zustand)
│   ├── CLAUDE.md                   # stores 가이드
│   └── index.ts
│
├── styles/                         # 전역 스타일
│   ├── CLAUDE.md                   # 스타일링 가이드
│   ├── global.css                  # Tailwind directives
│   └── index.ts
│
├── constants/                      # 앱 상수
│   ├── CLAUDE.md                   # constants 가이드
│   ├── theme.ts                    # 색상, 간격, 폰트 상수
│   └── index.ts
│
├── mock/                           # 목 데이터
│   ├── CLAUDE.md                   # mock 가이드
│   └── index.ts
│
├── assets/fonts/                   # Expo 폰트 (또는 public/fonts/)
│   ├── Pretendard-Regular.woff2
│   ├── Pretendard-Medium.woff2
│   ├── Pretendard-SemiBold.woff2
│   └── Pretendard-Bold.woff2
│
├── tailwind.config.js              # Tailwind 설정 (Expo)
├── tailwind.config.ts              # Tailwind 설정 (Next.js)
├── babel.config.js                 # Babel 설정 (Expo)
├── metro.config.js                 # Metro 설정 (Expo)
├── postcss.config.mjs              # PostCSS 설정 (Next.js)
│
├── package.json
├── tsconfig.json
└── ...
```

---

## 5. 핵심 컴포넌트 상세

### 5.1 명령어 파일 (expo.md / next.md)

**위치**: `~/.claude/commands/init/expo.md`

**역할**:
1. 프로젝트 생성 또는 기존 프로젝트 분석
2. 프레임워크 메타데이터 수집
3. setup-guide 템플릿 생성

**주요 로직**:

```bash
#!/bin/bash

PROJECT_NAME="${ARGUMENTS}"

# 1. 프로젝트 생성 또는 기존 사용
if [ -n "$PROJECT_NAME" ]; then
  npx create-expo-app "$PROJECT_NAME"
  cd "$PROJECT_NAME"
else
  PROJECT_NAME=$(basename "$PWD")
  # Expo 프로젝트 검증
  if [ ! -f "package.json" ] || ! grep -q '"expo"' package.json; then
    echo "Not an Expo project"
    exit 1
  fi
fi

# 2. 프로젝트 분석
EXPO_VERSION=$(grep -oP '"expo":\s*"[\^~]?\K[^"]+' package.json)
TYPESCRIPT="Yes" # or "No"
ROUTER="Expo Router" # or "React Navigation" or "Not detected"
UI_LIBRARY="NativeWind" # or ...

# 3. 템플릿 생성
TEMPLATE="$HOME/.claude/templates/claude-config/expo-setup-guide.md"

sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{EXPO_VERSION}}/$EXPO_VERSION/g" \
    -e "s/{{TYPESCRIPT}}/$TYPESCRIPT/g" \
    -e "s/{{ROUTER}}/$ROUTER/g" \
    -e "s/{{UI_LIBRARY}}/$UI_LIBRARY/g" \
    "$TEMPLATE" > claude.md

echo "Setup guide created!"
echo "Say: 실행해 / run it / execute"
```

**변수 치환 예시**:
- `{{PROJECT_NAME}}` → `MyApp`
- `{{EXPO_VERSION}}` → `51.0.0`
- `{{TYPESCRIPT}}` → `Yes`

### 5.2 스킬 정의 (SKILL.md)

**위치**: `~/.claude/skills/setup-executor/SKILL.md`

**역할**: 사용자 입력을 감지하고 셋업 스크립트 실행

**트리거 패턴**:

```yaml
triggers:
  korean:
    - "실행해" / "실행해줘"
    - "설정해" / "설정해줘"
    - "셋업해" / "셋업해줘"
    - "시작해" / "시작해줘"
    - "진행해" / "진행해줘"

  english:
    - "run it" / "run setup"
    - "execute" / "execute setup"
    - "start" / "start setup"
    - "go" / "proceed"

  explicit:
    - "claude.md대로 실행"
    - "claude.md대로 실행시켜줘"
```

**조건**:
```yaml
conditions:
  - claude.md exists in current directory
  - claude.md contains "Auto-generated by /init:"
```

**실행 명령**:
```bash
bash ~/.claude/skills/setup-executor/execute-instructions.sh
```

### 5.3 파싱 스크립트 (parse-claude-md.js)

**위치**: `~/.claude/skills/setup-executor/parse-claude-md.js`

**입력**: `claude.md` (setup-guide)

**출력**: `/tmp/setup-instructions.json`

**주요 로직**:

```javascript
const fs = require('fs');
const content = fs.readFileSync(process.argv[2], 'utf-8');

// Framework 감지
function detectFramework(content) {
  if (content.includes('Expo') || content.includes('expo')) {
    return 'expo';
  } else if (content.includes('Next.js') || content.includes('nextjs')) {
    return 'nextjs';
  }
  return 'unknown';
}

// 폰트 디렉토리 결정
function extractFontDir(content) {
  const framework = detectFramework(content);
  return framework === 'expo' ? 'assets/fonts' : 'public/fonts';
}

// 의존성 추출 (### 1. Dependencies to Install 섹션)
function extractDependencies(content) {
  // 코드 블록에서 npm/npx 명령어 추출
  // 예: npx expo install nativewind
  return [
    'npx expo install nativewind',
    'npx expo install tailwindcss',
    'npm install --save-dev tailwindcss@3.3.2'
  ];
}

// 폴더 목록 생성 (### 2. Folder Structure 섹션 참고)
function extractFolders() {
  return [
    'components/atoms',
    'components/molecules',
    'components/organisms',
    'components/templates',
    'hooks',
    'hooks/queries',
    'hooks/mutations',
    'utils',
    'types',
    'schema',
    'libs',
    'stores',
    'styles',
    'constants',
    'mock'
  ];
}

// 폰트 목록 생성
function extractFonts() {
  return [
    {
      name: 'Pretendard-Regular.woff2',
      url: 'https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/woff2/Pretendard-Regular.woff2'
    },
    {
      name: 'Pretendard-Medium.woff2',
      url: 'https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/woff2/Pretendard-Medium.woff2'
    },
    {
      name: 'Pretendard-SemiBold.woff2',
      url: 'https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/woff2/Pretendard-SemiBold.woff2'
    },
    {
      name: 'Pretendard-Bold.woff2',
      url: 'https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/static/woff2/Pretendard-Bold.woff2'
    }
  ];
}

// JSON 출력
const result = {
  metadata: {
    framework: detectFramework(content),
    font_dir: extractFontDir(content)
  },
  dependencies: extractDependencies(content),
  folders: extractFolders(),
  fonts: extractFonts()
};

console.log(JSON.stringify(result, null, 2));
```

### 5.4 실행 스크립트 (execute-instructions.sh)

**위치**: `~/.claude/skills/setup-executor/execute-instructions.sh`

**구조**:

```bash
#!/bin/bash
set -e

# 전역 변수
CLAUDE_MD="claude.md"
BACKUP_FILE="claude.md.setup-backup"
LOG_FILE=".setup-execution.log"
INSTRUCTIONS_JSON="/tmp/setup-instructions.json"

# 유틸리티 함수
log() { echo "[$(date)] $1" | tee -a "$LOG_FILE"; }
success() { echo "✓ $1" | tee -a "$LOG_FILE"; }
error() { echo "✗ $1" | tee -a "$LOG_FILE"; }
warn() { echo "⚠ $1" | tee -a "$LOG_FILE"; }

# Phase 1: 검증
validate_setup() { ... }

# Phase 2: 파싱
parse_instructions() { ... }

# Phase 3: 실행
execute_setup() {
  install_dependencies
  create_folders
  download_fonts
  setup_configs
}

# 각 단계별 함수
install_dependencies() { ... }
create_folders() { ... }
create_barrel_exports() { ... }
install_folder_docs() { ... }
download_fonts() { ... }
setup_configs() { ... }
setup_expo_configs() { ... }
setup_nextjs_configs() { ... }
create_theme_constants() { ... }

# Phase 4: 최종화
finalize_setup() { ... }

# 메인 실행
main() {
  validate_setup
  parse_instructions
  execute_setup
  finalize_setup

  echo "✅ Setup Complete!"
}

main "$@"
```

---

## 6. 데이터 흐름 분석

### 6.1 변수 흐름

```
사용자 입력: PROJECT_NAME="MyApp"
         │
         ▼
expo.md / next.md
         │
         ├─ package.json 분석
         │  └─ EXPO_VERSION="51.0.0"
         │
         ├─ tsconfig.json 검사
         │  └─ TYPESCRIPT="Yes"
         │
         ├─ package.json 분석
         │  └─ ROUTER="Expo Router"
         │
         └─ package.json 분석
            └─ UI_LIBRARY="NativeWind"
         │
         ▼
템플릿 변수 치환
         │
         ▼
claude.md (setup-guide)
         │
PROJECT_NAME: MyApp
EXPO_VERSION: 51.0.0
TYPESCRIPT: Yes
ROUTER: Expo Router
UI_LIBRARY: NativeWind
         │
         ▼
parse-claude-md.js
         │
         ▼
JSON 출력
{
  "metadata": {
    "framework": "expo",
    "font_dir": "assets/fonts"
  },
  "dependencies": [...],
  "folders": [...],
  "fonts": [...]
}
         │
         ▼
execute-instructions.sh
         │
         ├─ FRAMEWORK="expo"
         ├─ FONT_DIR="assets/fonts"
         ├─ DEPS=[...]
         ├─ FOLDERS=[...]
         └─ FONTS=[...]
         │
         ▼
각 단계별 실행
```

### 6.2 파일 흐름

```
템플릿 레이어                      프로젝트 레이어
━━━━━━━━━━━━━━━━                  ━━━━━━━━━━━━━━━

expo-setup-guide.md   ─sed─►   claude.md (초기)
                                     │
                                     │ parse
                                     ▼
                                /tmp/setup-
                                instructions.json
                                     │
                                     │ execute
                                     ▼
folders/common/hooks.md  ─cp─►  hooks/CLAUDE.md
folders/common/                 hooks/queries/CLAUDE.md
hooks-queries.md        ─cp─►
folders/common/                 hooks/mutations/CLAUDE.md
hooks-mutations.md      ─cp─►
folders/common/utils.md  ─cp─►  utils/CLAUDE.md
... (모든 템플릿)       ─cp─►  ... (모든 폴더)
                                     │
                                     │ finalize
                                     ▼
expo.md                  ─cp─►  claude.md (최종)
```

### 6.3 의존성 흐름

```
프레임워크 감지
     │
     ▼
┌────────────┬────────────┐
│   Expo     │  Next.js   │
└────────────┴────────────┘
     │             │
     ▼             ▼
NativeWind    Tailwind CSS
     │             │
     ▼             ▼
npx expo      npm install -D
install       tailwindcss
nativewind    postcss
              autoprefixer
     │             │
     ▼             ▼
tailwind.     tailwind.
config.js     config.ts
babel.config  postcss.
metro.config  config.mjs
     │             │
     └─────┬───────┘
           ▼
    설정 파일 생성 완료
```

---

## 7. 템플릿 시스템

### 7.1 템플릿 계층 구조

```
Templates
├── Setup Guides (초기 셋업)
│   ├── expo-setup-guide.md
│   └── next-setup-guide.md
│
├── Final Docs (최종 문서)
│   ├── expo.md
│   └── next.md
│
└── Folder Guides (폴더별 가이드)
    ├── Common (공통)
    │   ├── hooks.md
    │   ├── hooks-queries.md
    │   ├── hooks-mutations.md
    │   ├── utils.md
    │   ├── types.md
    │   ├── schema.md
    │   ├── libs.md
    │   ├── stores.md
    │   ├── constants.md
    │   └── mock.md
    │
    ├── Expo (Expo 전용)
    │   ├── components-atoms.md
    │   ├── components-molecules.md
    │   ├── components-organisms.md
    │   ├── components-templates.md
    │   └── styles.md
    │
    └── Next.js (Next.js 전용)
        ├── components-atoms.md
        ├── components-molecules.md
        ├── components-organisms.md
        ├── components-templates.md
        └── styles.md
```

### 7.2 템플릿 내용 구조

**모든 폴더 가이드 템플릿은 다음 구조를 따름**:

```markdown
# [폴더명]/

> [폴더 한 줄 설명]

## 📌 목적과 역할

[폴더의 목적과 책임 설명]

## 📂 폴더 구조 예시

```
[폴더]/
├── index.ts
├── [파일1].ts
└── [파일2].ts
```

## 🎯 네이밍 컨벤션

**파일명**: [규칙]
- ✅ [좋은 예]
- ❌ [나쁜 예]

**함수명**: [규칙]
- ✅ [좋은 예]
- ❌ [나쁜 예]

## 💡 코드 예제와 사용 패턴

### 1. [예제 1]

```typescript
// 코드 예제
```

**사용법**:
```typescript
// 사용 예시
```

### 2. [예제 2]

...

## ✅ 베스트 프랙티스

1. [원칙 1]
2. [원칙 2]
3. [원칙 3]

## 🚫 안티 패턴

```typescript
// ❌ Bad: [나쁜 예]

// ✅ Good: [좋은 예]
```

## 📚 추천 리소스

- [리소스 1](링크)
- [리소스 2](링크)
```

### 7.3 주요 템플릿 특징

#### hooks/CLAUDE.md
- **특징**: React Query 패턴 강조
- **구조**: queries/mutations 폴더 분리 설명
- **내용**: useQuery/useMutation 기본 개념, QueryKey 일관성, Invalidation 전략

#### hooks/queries/CLAUDE.md
- **특징**: useQuery 전용 가이드
- **구조**: 단일 조회, 목록 조회, 관계 데이터 조회 패턴
- **내용**: enabled 옵션, 캐싱 전략, 의존성 있는 쿼리

#### hooks/mutations/CLAUDE.md
- **특징**: useMutation 전용 가이드
- **구조**: CREATE, UPDATE, DELETE 패턴
- **내용**: Optimistic Updates, Invalidation 전략, mutate vs mutateAsync

#### components/atoms/CLAUDE.md (Expo)
- **특징**: NativeWind 기반 예제
- **구조**: Button, Input, Text 등 기본 UI
- **내용**: React Native 컴포넌트 + className 스타일링

#### components/atoms/CLAUDE.md (Next.js)
- **특징**: Tailwind CSS 기반 예제
- **구조**: Button, Input 등 기본 UI
- **내용**: HTML 요소 + extends HTMLAttributes 패턴

### 7.4 변수 치환 시스템

**Setup Guide 템플릿 변수**:

```markdown
# {{PROJECT_NAME}}

## 📊 프로젝트 정보

- **Framework**: Expo SDK {{EXPO_VERSION}}
- **언어**: TypeScript
- **Router**: {{ROUTER}}
- **UI Library**: {{UI_LIBRARY}}
```

**sed 치환**:
```bash
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    -e "s/{{EXPO_VERSION}}/$EXPO_VERSION/g" \
    -e "s/{{ROUTER}}/$ROUTER/g" \
    -e "s/{{UI_LIBRARY}}/$UI_LIBRARY/g" \
    "$TEMPLATE" > claude.md
```

**결과**:
```markdown
# MyApp

## 📊 프로젝트 정보

- **Framework**: Expo SDK 51.0.0
- **언어**: TypeScript
- **Router**: Expo Router
- **UI Library**: NativeWind
```

---

## 8. 사용 예시

### 8.1 시나리오 1: 새 Expo 프로젝트 생성

```bash
# 1. 프로젝트 초기화
$ /init:expo MyExpoApp

📦 Creating new Expo project: MyExpoApp
✓ Project created
✓ Expo project detected
✓ Expo SDK: 51.0.0
✓ TypeScript: Yes
✓ Router: Expo Router
✓ UI Library: NativeWind

📝 Generating setup guide...
✓ claude.md created

📄 Next step:
   Just say: 실행해 / run it / execute

# 2. 셋업 실행
$ 실행해

🚀 Setup Executor
━━━━━━━━━━━━━━━━━━━

✓ Validation passed
✓ Instructions parsed successfully
✓ Installing dependencies...
  - npx expo install nativewind
  - npx expo install tailwindcss
  - npm install --save-dev tailwindcss@3.3.2
✓ Dependencies installed

✓ Creating Atomic Design folder structure...
  ✓ Created: components/atoms
  ✓ Created: components/molecules
  ✓ Created: hooks
  ✓ Created: hooks/queries
  ✓ Created: hooks/mutations
  ... (모든 폴더)

✓ Installing folder documentation...
  ✓ Installed: hooks/CLAUDE.md
  ✓ Installed: hooks/queries/CLAUDE.md
  ✓ Installed: hooks/mutations/CLAUDE.md
  ... (모든 CLAUDE.md)

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

✓ Backed up claude.md → claude.md.setup-backup
✓ Installed Expo project documentation → claude.md

✅ Setup Complete!
━━━━━━━━━━━━━━━━━━━

📄 Original setup guide backed up: claude.md.setup-backup
📝 Execution log: .setup-execution.log
```

### 8.2 시나리오 2: 기존 Next.js 프로젝트 셋업

```bash
# 1. 기존 프로젝트 디렉토리로 이동
$ cd my-existing-nextjs-app

# 2. 프로젝트 분석 및 셋업 가이드 생성
$ /init:next

📦 Using existing project: my-existing-nextjs-app
✓ Next.js project detected
✓ Next.js Version: 14.0.0
✓ TypeScript: Yes
✓ App Router: Yes (app directory)
✓ UI Library: None

📝 Generating setup guide...
✓ claude.md created

📄 Next step:
   Just say: 실행해 / run it

# 3. 셋업 실행
$ run it

🚀 Setup Executor
━━━━━━━━━━━━━━━━━━━

... (동일한 프로세스)

✅ Setup Complete!
```

### 8.3 시나리오 3: 개발 중 가이드 참조

```bash
# hooks 폴더에서 Query Hook 작성 시
$ cd hooks/queries
$ cat CLAUDE.md

# hooks/queries/ 가이드 읽기
# - QueryKey 일관성 확인
# - enabled 옵션 사용법 확인
# - 코드 예제 참조

$ vim useUsers.ts
# useQuery 작성...

# mutations 폴더로 이동
$ cd ../mutations
$ cat CLAUDE.md

# hooks/mutations/ 가이드 읽기
# - Invalidation 전략 확인
# - Optimistic Updates 패턴 확인
# - 코드 예제 참조

$ vim useCreateUser.ts
# useMutation 작성...
```

---

## 9. 확장 및 커스터마이징

### 9.1 새로운 폴더 가이드 추가

**1단계: 템플릿 작성**

```bash
# 새로운 가이드 템플릿 생성
$ vim ~/.claude/templates/claude-config/folders/common/services.md
```

```markdown
# services/

> API 통신 및 비즈니스 로직 레이어

## 📌 목적과 역할

API 엔드포인트별 서비스 함수를 관리합니다. ...

## 💡 코드 예제

```typescript
// services/userService.ts
export const userService = {
  getUsers: () => api.get<User[]>('/users'),
  getUser: (id: string) => api.get<User>(`/users/${id}`),
};
```

...
```

**2단계: execute-instructions.sh 수정**

```bash
# install_folder_docs() 함수에 추가
for folder in hooks utils types schema libs stores constants mock services; do
  if [ -d "$folder" ]; then
    cp "$TEMPLATE_BASE/common/$folder.md" "$folder/CLAUDE.md"
  fi
done
```

**3단계: create_folders() 또는 parse-claude-md.js 수정**

```javascript
// parse-claude-md.js
function extractFolders() {
  return [
    ...
    'services'  // 추가
  ];
}
```

### 9.2 새로운 프레임워크 지원 (예: React)

**1단계: 명령어 추가**

```bash
$ vim ~/.claude/commands/init/react.md
```

```bash
#!/bin/bash
PROJECT_NAME="${ARGUMENTS}"

if [ -n "$PROJECT_NAME" ]; then
  npx create-react-app "$PROJECT_NAME" --template typescript
  cd "$PROJECT_NAME"
else
  PROJECT_NAME=$(basename "$PWD")
fi

# React 프로젝트 분석...
REACT_VERSION=$(grep -oP '"react":\s*"[\^~]?\K[^"]+' package.json)

# 템플릿 생성
TEMPLATE="$HOME/.claude/templates/claude-config/react-setup-guide.md"
sed -e "s/{{PROJECT_NAME}}/$PROJECT_NAME/g" \
    "$TEMPLATE" > claude.md
```

**2단계: 템플릿 생성**

```bash
$ vim ~/.claude/templates/claude-config/react-setup-guide.md
$ vim ~/.claude/templates/claude-config/react.md
$ vim ~/.claude/templates/claude-config/folders/react/
```

**3단계: execute-instructions.sh에 React 설정 추가**

```bash
setup_react_configs() {
  # CRA + Tailwind CSS 설정
  npm install -D tailwindcss postcss autoprefixer
  npx tailwindcss init -p

  cat > tailwind.config.js <<'EOF'
module.exports = {
  content: ["./src/**/*.{js,jsx,ts,tsx}"],
  ...
};
EOF
}
```

### 9.3 커스텀 폴더 구조

**시나리오**: MST (MobX State Tree) 사용

**1단계: 폴더 가이드 작성**

```bash
$ vim ~/.claude/templates/claude-config/folders/common/models.md
```

**2단계: parse-claude-md.js 수정**

```javascript
function extractFolders() {
  return [
    ...
    'models'  // MST models
  ];
}
```

**3단계: create_barrel_exports() 수정**

```bash
for folder in hooks utils types schema libs stores constants mock models; do
  cat > "$folder/index.ts" <<EOF
// Export all $folder here
EOF
done
```

### 9.4 폰트 변경

**시나리오**: Pretendard → Inter 폰트 사용

**1단계: parse-claude-md.js 수정**

```javascript
function extractFonts() {
  return [
    {
      name: 'Inter-Regular.woff2',
      url: 'https://fonts.googleapis.com/css2?family=Inter:wght@400&display=swap'
    },
    {
      name: 'Inter-Medium.woff2',
      url: 'https://...'
    }
  ];
}
```

**2단계: setup_expo_configs() / setup_nextjs_configs() 수정**

```bash
# tailwind.config 수정
fontFamily: {
  inter: ["Inter-Regular"],
  "inter-medium": ["Inter-Medium"],
}
```

---

## 10. 트러블슈팅

### 10.1 일반적인 문제

#### 문제 1: "claude.md not found"

**원인**: 프로젝트 루트에 claude.md가 없음

**해결**:
```bash
# 1. 올바른 디렉토리에 있는지 확인
$ pwd
/path/to/project

# 2. /init:expo 또는 /init:next 실행
$ /init:expo

# 3. claude.md 생성 확인
$ ls claude.md
```

#### 문제 2: "claude.md is not a setup guide"

**원인**: claude.md가 이미 최종 프로젝트 문서로 교체됨

**해결**:
```bash
# 백업에서 복원하거나 새로 생성
$ rm claude.md
$ /init:expo

# 또는 백업 확인
$ cat claude.md.setup-backup
```

#### 문제 3: "Template not found"

**원인**: 템플릿 파일이 누락됨

**해결**:
```bash
# 템플릿 파일 확인
$ ls ~/.claude/templates/claude-config/folders/common/

# 누락된 템플릿 재생성
# (이 문서의 5장 참고)
```

### 10.2 프레임워크별 문제

#### Expo 문제: NativeWind 설치 실패

**원인**: Expo SDK 버전 불일치

**해결**:
```bash
# Expo SDK 업데이트
$ npx expo install expo@latest

# NativeWind 재설치
$ npx expo install nativewind tailwindcss

# babel.config.js 확인
$ cat babel.config.js
# nativewind/babel 플러그인 있는지 확인
```

#### Next.js 문제: Tailwind CSS 적용 안 됨

**원인**: globals.css import 누락

**해결**:
```typescript
// app/layout.tsx 또는 _app.tsx에 추가
import '@/styles/globals.css';
```

### 10.3 디버깅 가이드

#### 로그 파일 확인

```bash
# 셋업 실행 로그 확인
$ cat .setup-execution.log

[2025-01-05 10:30:00] Validating setup...
✓ Validation passed
[2025-01-05 10:30:01] Parsing instructions...
✓ Instructions parsed successfully
...
```

#### JSON 파싱 결과 확인

```bash
# 파싱된 JSON 확인
$ cat /tmp/setup-instructions.json

{
  "metadata": {
    "framework": "expo",
    "font_dir": "assets/fonts"
  },
  "dependencies": [...],
  ...
}
```

#### 수동 스크립트 실행

```bash
# 파싱만 실행
$ node ~/.claude/skills/setup-executor/parse-claude-md.js claude.md

# 셋업 스크립트 직접 실행
$ bash ~/.claude/skills/setup-executor/execute-instructions.sh
```

---

## 부록 A: 파일 참조 테이블

| 파일 경로 | 역할 | 주요 기능 |
|----------|------|----------|
| `~/.claude/commands/init/expo.md` | Expo 프로젝트 초기화 | 프로젝트 생성, 분석, setup-guide 생성 |
| `~/.claude/commands/init/next.md` | Next.js 프로젝트 초기화 | 프로젝트 생성, 분석, setup-guide 생성 |
| `~/.claude/skills/setup-executor/SKILL.md` | 스킬 정의 | 트리거 패턴 정의, 조건 검증 |
| `~/.claude/skills/setup-executor/parse-claude-md.js` | 파싱 스크립트 | claude.md → JSON 변환 |
| `~/.claude/skills/setup-executor/execute-instructions.sh` | 실행 스크립트 | 전체 셋업 프로세스 실행 |
| `~/.claude/templates/claude-config/expo-setup-guide.md` | Expo 초기 가이드 | 변수 템플릿, 셋업 지침 |
| `~/.claude/templates/claude-config/next-setup-guide.md` | Next.js 초기 가이드 | 변수 템플릿, 셋업 지침 |
| `~/.claude/templates/claude-config/expo.md` | Expo 최종 문서 | 프로젝트 문서, 사용법 |
| `~/.claude/templates/claude-config/next.md` | Next.js 최종 문서 | 프로젝트 문서, 사용법 |
| `~/.claude/templates/claude-config/folders/common/*.md` | 공통 폴더 가이드 | 폴더별 역할, 예제, 베스트 프랙티스 |
| `~/.claude/templates/claude-config/folders/expo/*.md` | Expo 폴더 가이드 | NativeWind 예제, RN 컴포넌트 |
| `~/.claude/templates/claude-config/folders/next/*.md` | Next.js 폴더 가이드 | Tailwind 예제, HTML 요소 |

## 부록 B: 명령어 레퍼런스

### 사용자 명령어

| 명령어 | 설명 | 예시 |
|--------|------|------|
| `/init:expo [이름]` | Expo 프로젝트 초기화 | `/init:expo MyApp` |
| `/init:next [이름]` | Next.js 프로젝트 초기화 | `/init:next MyWebApp` |
| `실행해` / `run it` | 셋업 실행 트리거 | 자연어 입력 |

### 시스템 내부 명령어

| 명령어 | 위치 | 설명 |
|--------|------|------|
| `npx create-expo-app` | expo.md | Expo 프로젝트 생성 |
| `npx create-next-app@latest` | next.md | Next.js 프로젝트 생성 |
| `node parse-claude-md.js` | execute-instructions.sh | 템플릿 파싱 |
| `bash execute-instructions.sh` | SKILL.md | 셋업 실행 |
| `sed -e "s/{{VAR}}/$VAR/g"` | expo.md, next.md | 변수 치환 |
| `cp template.md CLAUDE.md` | execute-instructions.sh | 문서 설치 |
| `curl -L -o font.woff2` | execute-instructions.sh | 폰트 다운로드 |

## 부록 C: 환경 변수 및 경로

### 중요 경로

| 변수명 | 값 | 설명 |
|--------|---|------|
| `$HOME` | 사용자 홈 디렉토리 | `~/.claude/` 기준 경로 |
| `CLAUDE_MD` | `claude.md` | 프로젝트 루트 설정 파일 |
| `BACKUP_FILE` | `claude.md.setup-backup` | 원본 백업 파일 |
| `LOG_FILE` | `.setup-execution.log` | 실행 로그 |
| `INSTRUCTIONS_JSON` | `/tmp/setup-instructions.json` | 파싱 결과 JSON |
| `TEMPLATE_BASE` | `$HOME/.claude/templates/claude-config` | 템플릿 기본 경로 |
| `PARSER_SCRIPT` | `$HOME/.claude/skills/setup-executor/parse-claude-md.js` | 파싱 스크립트 |

---

## 결론

이 시스템은 Expo와 Next.js 프로젝트의 초기 셋업을 완전 자동화하여:

1. **개발자 생산성 향상**: 수동 폴더 생성 및 설정 파일 작성 시간 절약
2. **일관성 보장**: Atomic Design 패턴과 React Query 패턴 강제로 코드베이스 일관성 유지
3. **학습 곡선 완화**: 각 폴더별 CLAUDE.md로 즉시 참조 가능한 가이드 제공
4. **확장 가능성**: 새로운 프레임워크, 폴더, 패턴 쉽게 추가 가능

**핵심 가치**:
- 자동화된 프로젝트 셋업
- 문서화 자동 배치
- 프레임워크별 최적화
- 개발자 경험 최적화

**다음 단계**:
- 더 많은 프레임워크 지원 (Remix, Vite + React, etc.)
- CI/CD 통합
- 팀별 커스텀 템플릿 지원
- 프로젝트 업그레이드 자동화

---

**작성**: Claude Code with Claude Sonnet 4.5
**문서 버전**: 1.0.0
**최종 수정**: 2025-01-05
