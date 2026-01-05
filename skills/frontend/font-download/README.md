# Font Downloader - Pretendard

빠르고 쉬운 Pretendard 폰트 설치 스킬

## 🚀 빠른 시작

### 기본 사용

```bash
/font-download
```

프로젝트 타입을 자동으로 감지하여 적절한 위치에 폰트를 다운로드합니다.

### 커스텀 경로

```bash
/font-download src/assets/fonts
```

원하는 경로를 지정하여 폰트를 다운로드할 수 있습니다.

## 📦 다운로드되는 폰트

| Weight | 파일명 | 용도 |
|--------|-------|------|
| 400 (Regular) | Pretendard-Regular.woff2 | 본문 텍스트 |
| 500 (Medium) | Pretendard-Medium.woff2 | 강조 텍스트 |
| 600 (SemiBold) | Pretendard-SemiBold.woff2 | 제목 |
| 700 (Bold) | Pretendard-Bold.woff2 | 강한 강조 |

**총 용량**: ~184 KB (4개 파일)
**포맷**: WOFF2 (최신 브라우저 최적화)
**다운로드 시간**: ~2-3초 (병렬 다운로드)

## 🎯 자동 경로 감지

- **Next.js 프로젝트** → `app/fonts/`
- **Expo 프로젝트** → `assets/fonts/`
- **기타 프로젝트** → `public/fonts/`

## 💻 설정 예제

### Next.js (App Router)

```typescript
// app/layout.tsx
import localFont from 'next/font/local'

const pretendard = localFont({
  src: [
    { path: './fonts/Pretendard-Regular.woff2', weight: '400' },
    { path: './fonts/Pretendard-Medium.woff2', weight: '500' },
    { path: './fonts/Pretendard-SemiBold.woff2', weight: '600' },
    { path: './fonts/Pretendard-Bold.woff2', weight: '700' },
  ],
  variable: '--font-pretendard',
})

export default function RootLayout({ children }) {
  return (
    <html className={pretendard.variable}>
      <body className="font-pretendard">{children}</body>
    </html>
  )
}
```

### Tailwind CSS

```javascript
// tailwind.config.js
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

```tsx
// 사용 예
<h1 className="font-pretendard font-bold">안녕하세요</h1>
<p className="font-pretendard font-medium">반갑습니다</p>
```

### Expo / React Native

```typescript
// App.tsx
import { useFonts } from 'expo-font'

export default function App() {
  const [loaded] = useFonts({
    'Pretendard-Regular': require('./assets/fonts/Pretendard-Regular.woff2'),
    'Pretendard-Medium': require('./assets/fonts/Pretendard-Medium.woff2'),
    'Pretendard-SemiBold': require('./assets/fonts/Pretendard-SemiBold.woff2'),
    'Pretendard-Bold': require('./assets/fonts/Pretendard-Bold.woff2'),
  })

  if (!loaded) return null

  return <YourApp />
}
```

```tsx
// 사용 예
<Text style={{ fontFamily: 'Pretendard-Regular' }}>일반 텍스트</Text>
<Text style={{ fontFamily: 'Pretendard-Bold' }}>굵은 텍스트</Text>
```

### CSS (일반 웹)

```css
@font-face {
  font-family: 'Pretendard';
  font-weight: 400;
  src: url('/fonts/Pretendard-Regular.woff2') format('woff2');
}

@font-face {
  font-family: 'Pretendard';
  font-weight: 500;
  src: url('/fonts/Pretendard-Medium.woff2') format('woff2');
}

@font-face {
  font-family: 'Pretendard';
  font-weight: 600;
  src: url('/fonts/Pretendard-SemiBold.woff2') format('woff2');
}

@font-face {
  font-family: 'Pretendard';
  font-weight: 700;
  src: url('/fonts/Pretendard-Bold.woff2') format('woff2');
}

body {
  font-family: 'Pretendard', -apple-system, sans-serif;
}
```

## ⚡ 성능 최적화 팁

### Font Preloading

```html
<link
  rel="preload"
  href="/fonts/Pretendard-Regular.woff2"
  as="font"
  type="font/woff2"
  crossorigin
/>
```

### Font Display Strategy

```css
@font-face {
  font-family: 'Pretendard';
  src: url('/fonts/Pretendard-Regular.woff2') format('woff2');
  font-display: swap; /* FOIT 방지 */
}
```

### Subset Fonts (선택적)

필요한 문자만 포함하여 파일 크기를 더 줄일 수 있습니다:

```javascript
// next.config.js
module.exports = {
  experimental: {
    optimizeFonts: true,
  },
}
```

## 🎨 타이포그래피 가이드

### Weight 선택 기준

```tsx
// 제목
<h1 className="font-bold">      {/* 700 - Bold */}
<h2 className="font-semibold">  {/* 600 - SemiBold */}
<h3 className="font-medium">    {/* 500 - Medium */}

// 본문
<p className="font-normal">     {/* 400 - Regular */}

// 강조
<strong className="font-semibold">  {/* 600 */}
<em className="font-medium">        {/* 500 */}
```

### 폰트 크기 조합 (Tailwind)

```tsx
<h1 className="text-5xl font-bold">타이틀</h1>
<h2 className="text-3xl font-semibold">서브타이틀</h2>
<h3 className="text-xl font-medium">섹션 제목</h3>
<p className="text-base font-normal">본문 텍스트</p>
<small className="text-sm font-normal">작은 텍스트</small>
```

## 🔧 문제 해결

### 폰트가 로드되지 않을 때

1. **경로 확인**
   ```bash
   ls app/fonts/Pretendard-*.woff2
   # 또는
   ls public/fonts/Pretendard-*.woff2
   ```

2. **브라우저 캐시 삭제**
   - Chrome: Ctrl+Shift+R (강력 새로고침)
   - Firefox: Ctrl+F5

3. **CORS 설정 (필요시)**
   ```javascript
   // next.config.js
   module.exports = {
     async headers() {
       return [
         {
           source: '/fonts/:path*',
           headers: [
             {
               key: 'Access-Control-Allow-Origin',
               value: '*',
             },
           ],
         },
       ]
     },
   }
   ```

### 다운로드 실패 시

```bash
# 인터넷 연결 확인
ping cdn.jsdelivr.net

# 수동 다운로드 (단일 파일)
curl -L -o app/fonts/Pretendard-Regular.woff2 \
  https://cdn.jsdelivr.net/gh/fonts-archive/Pretendard/Pretendard-Regular.woff2

# 권한 오류 시
sudo /font-download
# 또는 다른 경로 사용
/font-download ~/Downloads/fonts
```

## 📚 추가 리소스

- [Pretendard 공식 GitHub](https://github.com/orioncactus/pretendard)
- [Next.js 폰트 최적화 가이드](https://nextjs.org/docs/app/building-your-application/optimizing/fonts)
- [Expo 커스텀 폰트 사용법](https://docs.expo.dev/develop/user-interface/fonts/)
- [웹 폰트 성능 최적화](https://web.dev/font-best-practices/)

## 💬 지원

문제가 발생하거나 질문이 있으면:
- **Slack**: #frontend-support
- **Email**: frontend@company.com

## 📄 라이선스

- **이 스킬**: MIT License (내부 사용)
- **Pretendard 폰트**: SIL Open Font License 1.1

---

**Made with ❤️ by Frontend Team**
