# styles/

> 전역 스타일 및 테마 디렉토리 (Next.js + Tailwind CSS)

## 📌 목적과 역할

Tailwind CSS를 위한 전역 스타일, 커스텀 유틸리티 클래스, CSS 변수, 테마 설정을 관리합니다.

## 💡 설정 파일

### globals.css

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### tailwind.config.ts

```typescript
import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      colors: {
        primary: '#007AFF',
      },
    },
  },
};

export default config;
```

## ✅ 베스트 프랙티스

1. **Tailwind 활용**: className으로 대부분 스타일링
2. **테마 확장**: tailwind.config.ts에서 커스텀 색상/폰트 정의

## 📚 추천 리소스

- [Tailwind CSS](https://tailwindcss.com/)
- [Next.js Styling](https://nextjs.org/docs/app/building-your-application/styling)
