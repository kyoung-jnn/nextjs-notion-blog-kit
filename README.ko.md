![nextjs notion blog kit](https://github.com/user-attachments/assets/dbfdd093-6637-4fa2-b4ea-9201ad8c2c49)

# Nextjs Notion Blog Kit · ![mit](https://img.shields.io/badge/license-MIT-FF0000)

[English](README.md) | 한국어

Next.js와 Notion API를 활용한 블로그 키트입니다. Notion을 CMS로 사용하여 콘텐츠를 관리하고 Next.js와 Vercel로 서빙하는 간편한 블로그 솔루션입니다.

## 주요 기능

- 🚀 **Next.js App Router** 기반 설계
- 📝 **Notion**을 CMS(콘텐츠 관리 시스템)으로 활용
- 🔍 **SEO** 최적화 (메타데이터, 사이트맵, RSS 피드)
- 🎨 **반응형 디자인** 지원
- 🌓 **다크 모드** 지원
- 💬 **댓글 시스템** (Giscus) 통합
- 📊 **Vercel Analytics** 지원
- 📱 **모바일 친화적** 인터페이스

## 시작하기

### 사전 요구사항

- [Node.js](https://nodejs.org/) (18.x 이상)
- [pnpm](https://pnpm.io/) (10.x 이상)
- Notion 계정 및 통합 설정

### Notion 설정하기

1. Notion 블로그 템플릿 페이지 방문하기: [Nextjs Notion Blog Kit 템플릿](https://kyoung-jnn.notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=1f4d55b8837781328546000cc33d2d96)
2. 우측 상단의 "복제" 버튼을 클릭하여 템플릿을 자신의 Notion 워크스페이스에 복제합니다.
3. 복제 후, URL에서 Notion 페이지 ID를 확인합니다:
   - 복제된 페이지의 URL을 확인합니다.
   - 페이지 ID는 "?v=" 부분 앞에 있는 문자열입니다.
   - 예시: `https://your-workspace.notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=1f4d55b8837781328546000cc33d2d96`에서 페이지 ID는 `1f4d55b8837780519a27c4f1f7e4b1a9`입니다.
4. 이 페이지 ID를 `.env` 파일의 `NOTION_PAGE` 환경변수로 설정합니다.

### 설치 방법

1. 저장소 Fork하기:

   - [GitHub 저장소](https://github.com/kyoung-jnn/nextjs-notion-blog-kit)를 방문합니다
   - 우측 상단의 "Fork" 버튼을 클릭합니다
   - 이렇게 하면 자신의 GitHub 계정에 저장소의 복사본이 생성됩니다

2. Fork한 저장소 클론하기:

   ```bash
   git clone https://github.com/yourusername/nextjs-notion-blog-kit.git
   cd nextjs-notion-blog-kit
   ```

3. 의존성 설치:

   ```bash
   pnpm install
   ```

4. 환경 변수 설정:
   `.env` 파일을 루트 디렉토리에 생성하고 다음 내용을 추가합니다:

   ```
   NOTION_PAGE=your_notion_page_id
   ```

5. 개발 서버 실행:
   ```bash
   pnpm dev
   ```

## 배포하기

### Vercel에 배포하기

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fyourusername%2Fnextjs-notion-blog-kit)

1. 위 버튼을 클릭하거나 Vercel 대시보드에서 새 프로젝트를 생성합니다.
2. GitHub 레포지토리를 연결합니다.
3. 환경 변수 `NOTION_PAGE`를 설정합니다.
4. 배포!

## 사용자 정의하기

### 사이트 구성 수정

`database/config.ts` 파일을 수정하여 사이트 제목, 설명, 저자 정보 등을 변경할 수 있습니다:

```typescript
const SITE_CONFIG = {
  title: '당신의 블로그 이름',
  description: '블로그 설명',
  author: {
    name: '당신의 이름',
    // ...기타 정보
  },
  // ...기타 구성
};
```

### 디자인 커스터마이징

스타일은 `styles` 디렉토리에서 관리됩니다. Vanilla Extract CSS를 사용하여 스타일을 커스터마이징할 수 있습니다.

## 구조

```
nextjs-notion-blog-kit/
├── app/                  # Next.js App Router
│   ├── (home)/           # 홈페이지
│   ├── posts/            # 블로그 포스트
│   └── ...
├── components/           # 리액트 컴포넌트
├── database/             # 사이트 설정 및 메타데이터
├── api/                   # Notion API 통합
├── styles/               # 스타일 정의
├── types/                # TypeScript 타입 정의
└── ...
```

## 기술 스택

- [Next.js](https://nextjs.org/) (14.x)
- [React](https://reactjs.org/) (18.x)
- [TypeScript](https://www.typescriptlang.org/)
- [notion-client](https://github.com/NotionX/react-notion-x)
- [Vanilla Extract CSS](https://vanilla-extract.style/)

## 라이선스

MIT © [kyoung-jnn](https://github.com/kyoung-jnn)

## 참고 및 감사

이 프로젝트는 다음 오픈 소스 프로젝트들에 영감을 받았습니다:

- [react-notion-x](https://github.com/NotionX/react-notion-x)
