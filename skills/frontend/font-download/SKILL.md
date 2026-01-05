---
name: font-download
description: Download Pretendard font variants (Regular, Medium, SemiBold, Bold) to specified directory with parallel download optimization
version: 1.0.0
author: Frontend Team <frontend@company.com>
category: frontend
tags: [fonts, pretendard, typography, assets, optimization]
status: stable
allowed-tools: [Bash, Read, Write]
triggers:
  - "폰트 다운로드"
  - "Pretendard 폰트"
  - "font download"
  - "download pretendard"
  - "폰트 설치"
dependencies: []
---

# Font Downloader (Pretendard)

## 목적

Pretendard 폰트 파일을 jsDelivr CDN에서 지정된 디렉토리로 다운로드합니다. Next.js와 Expo 프로젝트 구조를 자동으로 감지하며, 병렬 다운로드를 통해 빠른 설치를 제공합니다.

Pretendard는 한글과 영문을 아름답게 표현하는 오픈소스 폰트로, 다양한 두께(weight)를 제공하여 일관된 타이포그래피를 구현할 수 있습니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 새로운 프로젝트에 Pretendard 폰트를 추가할 때
- 일관된 한글 타이포그래피가 필요한 프로젝트를 시작할 때
- 로컬 폰트 호스팅으로 성능을 최적화하고 싶을 때
- Next.js 또는 Expo 프로젝트에서 커스텀 폰트가 필요할 때
- CDN 의존성 없이 폰트를 번들링하고 싶을 때

### ❌ 이 스킬을 사용하지 않을 때

- 다른 폰트 패밀리가 필요할 때 (Noto Sans, Roboto 등)
- Google Fonts CDN을 사용하고 싶을 때
- 이미 Pretendard 폰트가 설치되어 있을 때
- 시스템 기본 폰트만 사용하는 프로젝트일 때

## 작동 방식

### 1. 대상 경로 결정

**자동 감지:**
- `package.json`에 `next` 의존성 → `app/fonts/`
- `package.json`에 `expo` 의존성 → `assets/fonts/`
- 기타 프로젝트 → `public/fonts/`

**수동 지정:**
```bash
/font-download custom/path/to/fonts
```

### 2. 디렉토리 생성

```bash
mkdir -p {target_path}
```

존재하지 않는 경로의 경우 자동으로 부모 디렉토리까지 생성합니다.

### 3. 병렬 다운로드 실행

```bash
# 4개 폰트를 동시에 다운로드 (백그라운드 작업)
curl -L -o {target_path}/Pretendard-Regular.woff2 \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-Regular.woff2 &

curl -L -o {target_path}/Pretendard-Medium.woff2 \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-Medium.woff2 &

curl -L -o {target_path}/Pretendard-SemiBold.woff2 \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-SemiBold.woff2 &

curl -L -o {target_path}/Pretendard-Bold.woff2 \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-Bold.woff2 &

wait  # 모든 다운로드 완료 대기
```

**성능 최적화:**
- 병렬 다운로드로 순차 다운로드 대비 ~75% 시간 단축
- woff2 포맷 사용으로 파일 크기 최소화
- jsDelivr CDN으로 빠른 다운로드 속도 보장

### 4. 다운로드 검증

```bash
ls -lh {target_path}/Pretendard-*.woff2
```

각 파일의 존재 여부와 크기를 확인하여 다운로드 성공 여부를 검증합니다.

### 5. 결과 보고

- ✅ 성공한 파일 개수 및 이름
- ❌ 실패한 파일 및 에러 메시지
- 📊 각 파일의 크기 정보
- 📝 프로젝트 타입별 설정 가이드

## 예제

### 예제 1: Next.js 프로젝트 (자동 감지)

**사용자 입력:**
```
"Pretendard 폰트 다운로드해줘"
```

**스킬 동작:**

1. `package.json` 분석 → Next.js 프로젝트 감지
2. `app/fonts/` 디렉토리 생성
3. 4개 폰트 파일 병렬 다운로드
4. 다운로드 결과 검증 및 보고

**결과:**
```
✅ Pretendard fonts downloaded successfully!

📁 Location: app/fonts/
📦 Files:
  - Pretendard-Regular.woff2 (45.2 KB)
  - Pretendard-Medium.woff2 (45.8 KB)
  - Pretendard-SemiBold.woff2 (46.1 KB)
  - Pretendard-Bold.woff2 (46.5 KB)

📝 Next.js Setup Guide:
```

### 예제 2: 커스텀 경로 지정

**사용자 입력:**
```
"src/assets/fonts 경로에 Pretendard 폰트 설치해줘"
```

**스킬 동작:**

1. 사용자 지정 경로 사용: `src/assets/fonts/`
2. 디렉토리 생성 (부모 경로 포함)
3. 폰트 다운로드 및 검증

**결과:**
```
✅ Pretendard fonts downloaded to custom path!

📁 Location: src/assets/fonts/
📦 Files: 4 files downloaded successfully
```

### 예제 3: Expo 프로젝트 (자동 감지)

**사용자 입력:**
```
"/font-download"
```

**스킬 동작:**

1. `package.json` 분석 → Expo 프로젝트 감지
2. `assets/fonts/` 디렉토리에 다운로드
3. Expo 설정 가이드 제공

## 설치 후 설정 가이드

### Next.js App Router 설정

**app/layout.tsx**
```typescript
import localFont from 'next/font/local'

const pretendard = localFont({
  src: [
    {
      path: './fonts/Pretendard-Regular.woff2',
      weight: '400',
      style: 'normal',
    },
    {
      path: './fonts/Pretendard-Medium.woff2',
      weight: '500',
      style: 'normal',
    },
    {
      path: './fonts/Pretendard-SemiBold.woff2',
      weight: '600',
      style: 'normal',
    },
    {
      path: './fonts/Pretendard-Bold.woff2',
      weight: '700',
      style: 'normal',
    },
  ],
  variable: '--font-pretendard',
  display: 'swap',
})

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="ko" className={pretendard.variable}>
      <body className="font-pretendard">{children}</body>
    </html>
  )
}
```

**tailwind.config.js**
```javascript
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        pretendard: ['var(--font-pretendard)'],
      },
    },
  },
}
```

### Next.js Pages Router 설정

**pages/_app.tsx**
```typescript
import localFont from 'next/font/local'
import type { AppProps } from 'next/app'

const pretendard = localFont({
  src: [
    {
      path: '../public/fonts/Pretendard-Regular.woff2',
      weight: '400',
    },
    {
      path: '../public/fonts/Pretendard-Medium.woff2',
      weight: '500',
    },
    {
      path: '../public/fonts/Pretendard-SemiBold.woff2',
      weight: '600',
    },
    {
      path: '../public/fonts/Pretendard-Bold.woff2',
      weight: '700',
    },
  ],
  variable: '--font-pretendard',
})

export default function App({ Component, pageProps }: AppProps) {
  return (
    <div className={pretendard.variable}>
      <Component {...pageProps} />
    </div>
  )
}
```

### Expo / React Native 설정

**App.tsx**
```typescript
import { useFonts } from 'expo-font'
import * as SplashScreen from 'expo-splash-screen'
import { useEffect } from 'react'

SplashScreen.preventAutoHideAsync()

export default function App() {
  const [fontsLoaded] = useFonts({
    'Pretendard-Regular': require('./assets/fonts/Pretendard-Regular.woff2'),
    'Pretendard-Medium': require('./assets/fonts/Pretendard-Medium.woff2'),
    'Pretendard-SemiBold': require('./assets/fonts/Pretendard-SemiBold.woff2'),
    'Pretendard-Bold': require('./assets/fonts/Pretendard-Bold.woff2'),
  })

  useEffect(() => {
    if (fontsLoaded) {
      SplashScreen.hideAsync()
    }
  }, [fontsLoaded])

  if (!fontsLoaded) return null

  return <YourApp />
}
```

**사용 예:**
```typescript
import { Text } from 'react-native'

<Text style={{ fontFamily: 'Pretendard-Regular' }}>안녕하세요</Text>
<Text style={{ fontFamily: 'Pretendard-Bold' }}>굵은 텍스트</Text>
```

### 일반 React / HTML 설정

**CSS**
```css
@font-face {
  font-family: 'Pretendard';
  font-weight: 400;
  font-style: normal;
  src: url('/fonts/Pretendard-Regular.woff2') format('woff2');
  font-display: swap;
}

@font-face {
  font-family: 'Pretendard';
  font-weight: 500;
  src: url('/fonts/Pretendard-Medium.woff2') format('woff2');
  font-display: swap;
}

@font-face {
  font-family: 'Pretendard';
  font-weight: 600;
  src: url('/fonts/Pretendard-SemiBold.woff2') format('woff2');
  font-display: swap;
}

@font-face {
  font-family: 'Pretendard';
  font-weight: 700;
  src: url('/fonts/Pretendard-Bold.woff2') format('woff2');
  font-display: swap;
}

body {
  font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}
```

## 폰트 사양

| Variant | Weight | File Size | 용도 |
|---------|--------|-----------|------|
| Regular | 400 | ~45 KB | 본문, 일반 텍스트 |
| Medium | 500 | ~46 KB | 강조, 부제목 |
| SemiBold | 600 | ~46 KB | 제목, 버튼 |
| Bold | 700 | ~47 KB | 강한 강조, 타이틀 |

**특징:**
- 포맷: WOFF2 (최신 브라우저 지원)
- 인코딩: Unicode
- 언어: 한글, 영문, 숫자, 특수문자
- 라이선스: SIL Open Font License 1.1

## 에러 처리

### 네트워크 실패
```bash
❌ Error downloading Pretendard-Regular.woff2
   Curl error code: 6 (Couldn't resolve host)

💡 Solution: Check internet connection and retry
```

### 권한 오류
```bash
❌ Error: Permission denied
   Cannot write to /app/fonts/

💡 Solution: Run with appropriate permissions or choose different path
```

### 부분 다운로드
```bash
⚠️  Partial download completed

✅ Success:
   - Pretendard-Regular.woff2
   - Pretendard-Medium.woff2

❌ Failed:
   - Pretendard-SemiBold.woff2 (Network timeout)
   - Pretendard-Bold.woff2 (Network timeout)

💡 Solution: Retry download for failed files
```

### 잘못된 경로
```bash
✅ Path does not exist. Creating parent directories...
✅ Directory created: custom/deep/nested/fonts/
✅ Proceeding with download...
```

## 가이드라인

### 파일 관리
- **버전 관리**: 폰트 파일은 git에 커밋 권장 (CDN 의존성 제거)
- **경로 일관성**: 프로젝트 타입에 맞는 표준 경로 사용
- **중복 방지**: 다운로드 전 기존 파일 확인

### 성능 최적화
- **포맷 선택**: WOFF2는 WOFF 대비 ~30% 작은 파일 크기
- **Font Display**: `swap` 사용으로 FOIT(Flash of Invisible Text) 방지
- **Preload**: 중요한 폰트는 HTML에서 preload 고려

```html
<link
  rel="preload"
  href="/fonts/Pretendard-Regular.woff2"
  as="font"
  type="font/woff2"
  crossorigin
/>
```

### 접근성
- **대체 폰트**: 시스템 폰트를 fallback으로 지정
- **크기 조절**: rem 단위 사용으로 사용자 설정 존중
- **대비 확인**: 충분한 색상 대비 유지

## 출력 형식

**성공 시:**
```
✅ Pretendard fonts downloaded successfully!

📁 Location: {target_path}
📦 Files:
  ✓ Pretendard-Regular.woff2 (45.2 KB)
  ✓ Pretendard-Medium.woff2 (45.8 KB)
  ✓ Pretendard-SemiBold.woff2 (46.1 KB)
  ✓ Pretendard-Bold.woff2 (46.5 KB)

⏱️  Download time: 2.3 seconds (parallel)

📝 Next Steps:
   [프로젝트 타입별 설정 가이드]
```

**실패 시:**
```
❌ Font download failed

📁 Target: {target_path}
⚠️  Errors:
   - File 1: [error message]
   - File 2: [error message]

💡 Troubleshooting:
   1. Check internet connection
   2. Verify write permissions
   3. Try alternative path
   4. Contact frontend@company.com
```

## 의존성

### 필수 도구
- `curl`: HTTP 다운로드 (대부분의 시스템에 기본 설치)
- `mkdir`: 디렉토리 생성
- `ls`: 파일 검증

### 프로젝트 의존성
**Next.js:**
```json
{
  "next": "^14.0.0"
}
```

**Expo:**
```json
{
  "expo": "^50.0.0",
  "expo-font": "^11.10.0"
}
```

## 제한사항

- **폰트 제한**: Pretendard만 지원 (다른 폰트는 별도 스킬 필요)
- **포맷 제한**: WOFF2만 제공 (TTF, OTF는 미지원)
- **Weight 제한**: 4개 weight만 포함 (Light, ExtraBold 등 제외)
- **플랫폼**: Windows, macOS, Linux 지원 (curl 필요)

## 버전 이력

### 1.0.0 (2025-01-05)
- 초기 릴리스
- Pretendard Regular, Medium, SemiBold, Bold 지원
- Next.js, Expo 자동 경로 감지
- 병렬 다운로드 구현
- 상세한 설정 가이드 제공

## 기여자

- Frontend Team (frontend@company.com) - 초기 개발 및 유지보수

## 지원

문제가 발생하거나 질문이 있으면:
- **Slack**: #frontend-support
- **Email**: frontend@company.com
- **이슈**: GitHub Issues

## 라이선스

MIT License - 조직 내부 사용 전용

---

## 추가 리소스

- [Pretendard GitHub](https://github.com/orioncactus/pretendard)
- [Next.js Font Optimization](https://nextjs.org/docs/app/building-your-application/optimizing/fonts)
- [Expo Custom Fonts](https://docs.expo.dev/develop/user-interface/fonts/)
- [Web Font Best Practices](https://web.dev/font-best-practices/)
