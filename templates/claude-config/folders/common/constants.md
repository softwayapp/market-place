# constants/

> 앱 상수 디렉토리

## 📌 목적과 역할

애플리케이션 전역에서 사용되는 상수 값을 관리합니다. 색상, 크기, API 엔드포인트, 설정 값 등을 중앙 집중식으로 관리하여 일관성을 유지합니다.
함수 네이밍 및 파일 네이밍은 최대한 간결하게 작성
## 📂 폴더 구조 예시

```
constants/
├── index.ts              # Barrel export
├── theme.ts              # 테마 관련 상수
├── api.ts                # API 엔드포인트
└── routes.ts             # 라우트 경로
```

## 💡 코드 예제

```typescript
// constants/theme.ts
export const colors = {
  primary: '#007AFF',
  secondary: '#5856D6',
} as const;

export const spacing = {
  xs: 4,
  sm: 8,
  md: 16,
} as const;
```

## ✅ 베스트 프랙티스

1. **as const 사용**: TypeScript에서 리터럴 타입 보존
2. **그룹화**: 관련된 상수는 객체로 그룹화
3. **환경 변수 우선**: 환경 변수가 있으면 사용, 없으면 기본값
