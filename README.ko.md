![nextjs notion blog kit](https://github.com/user-attachments/assets/dbfdd093-6637-4fa2-b4ea-9201ad8c2c49)

# Next.js Notion Blog Kit

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Next.js](https://img.shields.io/badge/Next.js-16.0-black)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19.2-61DAFB)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-3178C6)](https://www.typescriptlang.org/)

[English](README.md) | 한국어

글쓰기에 집중하세요. Notion으로 관리하고, 내 손으로 직접 만들고 서빙하는 블로그. 완전히 내 것인 블로그!

## ✨ 주요 기능

- 📝 **Notion CMS** - Notion에서 작성하고 즉시 게시. 새로운 CMS를 배울 필요 없음
- 🎨 **아름다운 UI** - 모든 기기에서 멋지게 보이는 깔끔하고 반응형 디자인
- 🌓 **다크 모드** - 시스템 설정에 따른 자동 테마 전환 지원
- 🔍 **SEO 최적화** - 자동 사이트맵, RSS 피드, 구조화된 데이터(JSON-LD)
- ⚡ **빠른 성능** - ISR을 통한 정적 생성으로 최적의 로딩 속도
- 💬 **댓글 시스템** - GitHub 기반 댓글을 위한 Giscus 통합
- 📊 **분석 준비 완료** - Vercel Analytics 즉시 지원
- 🎯 **TypeScript** - 더 나은 개발자 경험을 위한 완전한 타입 지원
- 🎨 **Tailwind CSS 4** - 빠른 스타일링을 위한 최신 Tailwind
- 🚀 **Next.js 16 App Router** - React Server Components를 활용한 최신 Next.js 기능

## 🚀 시작하기

몇 분 안에 블로그를 런칭할 준비가 되셨나요? 간단한 단계를 따라오세요:

### 1단계: Notion CMS 만들기 📝

먼저 Notion에서 콘텐츠 관리 시스템을 설정하세요:

1. **템플릿 방문**: [Notion 블로그 템플릿](https://kyoung-jnn.notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=1f4d55b8837781328546000cc33d2d96)
2. **복제하기**: 우측 상단의 **"복제"** 버튼 클릭
3. **공개로 설정**:
   - 우측 상단의 **"공유"** 클릭
   - **"웹에서 공유"** 토글 켜기
4. **페이지 ID 저장**:
   - 브라우저 주소창에서 URL 복사 (Mac: ⌘+L, Windows: Ctrl+L)
   - 예시 URL: `https://notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=...`
   - `?v=` 앞 부분이 페이지 ID: `1f4d55b8837780519a27c4f1f7e4b1a9`

> 💡 이 페이지 ID를 잘 보관하세요—3단계에서 필요합니다!

### 2단계: 템플릿 사용하기 🎨

이 템플릿으로 자신만의 저장소를 만드세요:

1. 페이지 상단의 **"Use this template"** 버튼 클릭
2. 저장소 이름 선택
3. public 또는 private 선택
4. **"Create repository"** 클릭

### 3단계: 설정 CLI 실행 🔲

새 저장소를 클론하고 마법의 설정 스크립트를 실행하세요:

```bash
# 저장소 클론
git clone https://github.com/yourusername/your-blog-repo.git
cd your-blog-repo

# 설정 마법사 실행 🧙‍♂️
pnpm deploy:setup
```

설정 마법사가:

- ✅ 환경 변수 구성 (Notion 페이지 ID 포함)
- ✅ 모든 의존성 설치
- ✅ Vercel 계정에 연결
- ✅ GitHub 저장소를 Vercel에 연결

프롬프트를 따라 몇 가지 질문에 답하기만 하면 됩니다!

### 4단계: 배포! 🚀

설정이 완료되면, 출시할 준비가 되었습니다:

```bash
pnpm deploy
```

끝! 블로그가 이제 Vercel에서 라이브로 운영됩니다. 🔲🎉

---

### 먼저 커스터마이징하고 싶으신가요?

배포하기 전에 블로그를 개인화하고 싶다면:

**`src/config/siteConfig.ts` 편집**:

```typescript
const SITE_CONFIG = {
  title: '블로그 제목',
  description: '블로그 설명',
  siteUrl: 'https://yourdomain.com',
  author: {
    localeName: '이름',
    bio: '자신에 대한 간단한 소개',
    contacts: {
      email: 'your-email@example.com',
      github: 'https://github.com/yourusername',
    },
  },
};
```

**로컬에서 테스트**:

```bash
pnpm dev
```

[http://localhost:3000](http://localhost:3000)에서 블로그를 미리 볼 수 있습니다!

## 📊 Notion 데이터베이스 스키마

Notion 데이터베이스는 다음 속성들을 가져야 합니다:

| 속성          | 타입      | 필수 | 설명                                                         |
| ------------- | --------- | ---- | ------------------------------------------------------------ |
| **title**     | 제목      | ✅   | 포스트 제목                                                  |
| **slug**      | 텍스트    | ✅   | URL 슬러그 (자동으로 소문자 및 하이픈 형식으로 변환)         |
| **date**      | 날짜      | ✅   | 게시 날짜                                                    |
| **status**    | 선택      | ✅   | `publish` 또는 `draft` (프로덕션에서는 게시된 포스트만 표시) |
| **summary**   | 텍스트    | ✅   | SEO 및 미리보기를 위한 짧은 설명                             |
| **thumbnail** | 파일      | ❌   | 대표 이미지                                                  |
| **tags**      | 다중 선택 | ❌   | 포스트 카테고리/태그                                         |

> **참고**: slug 필드는 자동으로 공백을 하이픈으로 변환하고 소문자로 변환합니다.

## 🎨 커스터마이징

### 테마 및 스타일링

- **색상**: `src/styles/global.css`에서 CSS 변수 편집
- **컴포넌트**: 모든 React 컴포넌트는 `src/components/`에 있습니다
- **레이아웃**: `src/app/`에서 페이지 레이아웃 수정

### 댓글 (Giscus)

댓글을 활성화하려면 `src/config/giscusConfig.ts`를 업데이트하세요:

```typescript
export const GISCUS_CONFIG = {
  repo: 'yourusername/your-repo',
  repoId: 'your_repo_id',
  category: 'General',
  categoryId: 'your_category_id',
};
```

[Giscus](https://giscus.app/)에서 ID를 가져오세요.

### 분석

Vercel Analytics를 활성화하려면 `src/app/layout.tsx`에 추가하세요:

```tsx
import { Analytics } from '@vercel/analytics/react';

// 레이아웃 컴포넌트에서:
<Analytics />;
```

## 🚢 배포

### 옵션 1: Vercel CLI로 배포하기 (권장)

Vercel 계정에 자동으로 연결되는 Vercel CLI를 사용하는 것이 가장 쉬운 방법입니다:

1. **Vercel CLI 설치** (아직 설치하지 않았다면):

   ```bash
   npm install -g vercel
   ```

2. **프로젝트를 Vercel에 연결**:

   ```bash
   vercel link
   ```

   이 명령은:

   - Vercel 계정으로 인증
   - 프로젝트를 새 또는 기존 Vercel 프로젝트에 연결
   - 배포 구성 설정

3. **환경 변수 추가**:

   ```bash
   vercel env add NOTION_PAGE
   ```

   프롬프트가 나타나면 Notion 페이지 ID를 입력하세요. 변수가 자동으로 Vercel 프로젝트에 추가됩니다.

4. **프로덕션에 배포**:

   ```bash
   pnpm deploy
   ```

   또는 프리뷰 배포의 경우:

   ```bash
   pnpm deploy:preview
   ```

> **참고**: `pnpm setup`을 실행했다면 1-2단계를 이미 완료했을 수 있습니다!

### 옵션 2: Vercel 대시보드로 배포하기

1. GitHub에 코드 푸시
2. [Vercel](https://vercel.com)에서 저장소 임포트
3. 환경 변수 추가:
   - `NOTION_PAGE`: Notion 페이지 ID
   - `TOKEN_FOR_REVALIDATE`: (선택사항) 온디맨드 재검증을 위한 비밀 토큰
4. 배포!

### 온디맨드 재검증

배포 후, 블로그 콘텐츠를 재검증할 수 있습니다:

```bash
curl -X POST https://yourdomain.com/article/api?token=YOUR_TOKEN_FOR_REVALIDATE
```

이렇게 하면 재배포 없이 Notion에서 최신 콘텐츠를 가져옵니다.

## 📁 프로젝트 구조

```
nextjs-notion-blog-kit/
├── src/
│   ├── api/                    # Notion API 통합
│   │   └── notion.ts          # Notion에서 포스트 및 페이지 가져오기
│   ├── app/                   # Next.js App Router
│   │   ├── (home)/           # 아티클 목록이 있는 홈페이지
│   │   ├── article/          # 아티클 상세 페이지
│   │   │   ├── [slug]/       # 동적 아티클 라우트
│   │   │   └── api/          # 재검증 API 라우트
│   │   ├── gallery/          # 갤러리 페이지
│   │   ├── layout.tsx        # 루트 레이아웃
│   │   └── sitemap.ts        # 자동 생성 사이트맵
│   ├── components/           # 재사용 가능한 React 컴포넌트
│   │   ├── ArticleCard/     # 아티클 미리보기 카드
│   │   ├── Header/          # 사이트 헤더 및 네비게이션
│   │   ├── NotionRender/    # Notion 콘텐츠 렌더러
│   │   └── ...
│   ├── config/              # 설정 파일
│   │   ├── siteConfig.ts   # 메인 사이트 설정
│   │   ├── giscusConfig.ts # 댓글 설정
│   │   └── ...
│   ├── constants/           # 앱 상수
│   ├── styles/             # 전역 스타일
│   ├── types/              # TypeScript 타입 정의
│   └── utils/              # 유틸리티 함수
├── public/                 # 정적 에셋
├── .env.example           # 환경 변수 템플릿
├── next.config.mjs        # Next.js 설정
├── tailwind.config.ts     # Tailwind CSS 설정
└── tsconfig.json          # TypeScript 설정
```

## 🛠 기술 스택

- **프레임워크**: [Next.js 16](https://nextjs.org/) (App Router)
- **UI 라이브러리**: [React 19](https://react.dev/)
- **언어**: [TypeScript 5](https://www.typescriptlang.org/)
- **스타일링**: [Tailwind CSS 4](https://tailwindcss.com/)
- **CMS**: [Notion API](https://developers.notion.com/)
- **Notion 렌더러**: [react-notion-x](https://github.com/NotionX/react-notion-x)
- **댓글**: [Giscus](https://giscus.app/)
- **배포**: [Vercel](https://vercel.com/)

## 🐛 문제 해결

### 포스트가 표시되지 않나요?

1. Notion 데이터베이스가 **웹에 공유**되어 있는지 확인하세요
2. `NOTION_PAGE` 환경 변수가 올바른지 확인하세요
3. 프로덕션에서 포스트가 `status: publish`로 설정되어 있는지 확인하세요
4. 브라우저 콘솔에서 에러를 확인하세요

### slug에 공백이 포함되나요?

slug 필드는 자동으로 URL 친화적으로 포맷됩니다:

- 공백은 하이픈으로 변환
- 텍스트는 소문자로 변환

### 이미지가 로드되지 않나요?

`next.config.mjs`에 이미지 도메인을 추가하세요:

```javascript
images: {
  domains: ['your-image-domain.com'],
}
```

## 🤝 기여하기

기여는 언제나 환영합니다! Pull Request를 자유롭게 제출해주세요. 큰 변경사항의 경우, 먼저 이슈를 열어 논의해주세요.

1. 저장소 Fork하기
2. 기능 브랜치 생성하기 (`git checkout -b feature/AmazingFeature`)
3. 변경사항 커밋하기 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시하기 (`git push origin feature/AmazingFeature`)
5. Pull Request 열기

## 📄 라이선스

이 프로젝트는 MIT 라이선스로 배포됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 🙏 감사의 말

이 프로젝트는 다음 프로젝트들에 영감을 받아 제작되었습니다:

- [react-notion-x](https://github.com/NotionX/react-notion-x) - Notion 렌더러
- [Next.js](https://nextjs.org/) - React 프레임워크
- [Vercel](https://vercel.com/) - 배포 플랫폼
