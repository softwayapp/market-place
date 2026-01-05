---
name: responsive-design
description: Apply responsive design patterns with mobile-first approach and breakpoint management
version: 1.1.0
author: Frontend Team <frontend@company.com>
category: frontend
tags: [responsive, mobile-first, breakpoints, css, tailwind]
status: stable
allowed-tools: [Read, Write, Edit]
triggers:
  - "반응형 디자인"
  - "모바일 대응"
  - "responsive design"
  - "make responsive"
dependencies: []
---

# Responsive Design

## 목적

모바일 우선 반응형 디자인 패턴을 자동으로 적용하고 브레이크포인트를 관리합니다.

## 사용 시기

### ✅ 이 스킬을 사용할 때

- 다양한 화면 크기 지원이 필요할 때
- 모바일/태블릿/데스크탑 레이아웃 구현
- 미디어 쿼리 자동 생성

### ❌ 이 스킬을 사용하지 않을 때

- 고정 해상도 앱 (키오스크 등)
- 모바일 전용 앱

## 작동 방식

1. **브레이크포인트 정의**: 표준 화면 크기 설정
2. **Mobile-first**: 작은 화면부터 스타일 정의
3. **유연한 레이아웃**: Flexbox, Grid 활용
4. **이미지 최적화**: srcset, picture 태그

## 예제

### 예제 1: 반응형 그리드

**생성되는 코드:**
```css
.grid-container {
  display: grid;
  gap: 1rem;

  /* Mobile (default) */
  grid-template-columns: 1fr;

  /* Tablet */
  @media (min-width: 768px) {
    grid-template-columns: repeat(2, 1fr);
  }

  /* Desktop */
  @media (min-width: 1024px) {
    grid-template-columns: repeat(4, 1fr);
  }
}
```

**Tailwind CSS 버전:**
```jsx
<div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
  <div>Item 1</div>
  <div>Item 2</div>
  <div>Item 3</div>
  <div>Item 4</div>
</div>
```

### 예제 2: 반응형 내비게이션

```tsx
const Navigation = () => {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <nav>
      {/* Mobile: Hamburger */}
      <button
        className="md:hidden"
        onClick={() => setIsOpen(!isOpen)}
      >
        ☰
      </button>

      {/* Desktop: Always visible */}
      {/* Mobile: Toggle */}
      <div className={`
        ${isOpen ? 'block' : 'hidden'}
        md:block
      `}>
        <a href="/">Home</a>
        <a href="/about">About</a>
      </div>
    </nav>
  );
};
```

## 설정

`.skillconfig.json`:
```json
{
  "responsiveDesign": {
    "breakpoints": {
      "sm": "640px",
      "md": "768px",
      "lg": "1024px",
      "xl": "1280px"
    },
    "approach": "mobile-first"
  }
}
```

## 라이선스

MIT License - 조직 내부 사용 전용
