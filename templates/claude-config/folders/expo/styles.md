# styles/

> 전역 스타일 및 테마 디렉토리 (Expo + NativeWind)

## 📌 목적과 역할

NativeWind(Tailwind CSS for React Native)를 위한 전역 스타일, 커스텀 유틸리티 클래스, 테마 설정을 관리합니다.

## 📂 폴더 구조

```
styles/
├── global.css            # Tailwind directives
└── index.ts              # Style exports
```

## 💡 설정 파일

### global.css

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```

### tailwind.config.js (프로젝트 루트)

```javascript
module.exports = {
  content: [
    './app/**/*.{js,jsx,ts,tsx}',
    './components/**/*.{js,jsx,ts,tsx}',
  ],
  presets: [require('nativewind/preset')],
  theme: {
    extend: {
      colors: {
        primary: '#007AFF',
        secondary: '#5856D6',
        success: '#34C759',
        warning: '#FF9500',
        danger: '#FF3B30',
      },
      fontFamily: {
        pretendard: ['Pretendard-Regular'],
        'pretendard-medium': ['Pretendard-Medium'],
        'pretendard-semibold': ['Pretendard-SemiBold'],
        'pretendard-bold': ['Pretendard-Bold'],
      },
    },
  },
};
```

## ✅ 베스트 프랙티스

1. **Tailwind 활용**: NativeWind의 className으로 대부분 스타일링
2. **테마 확장**: tailwind.config.js에서 커스텀 색상/폰트 정의
3. **일관성**: constants/theme.ts와 동기화 유지

## 📚 추천 리소스

- [NativeWind Documentation](https://www.nativewind.dev/)
- [Tailwind CSS](https://tailwindcss.com/)
