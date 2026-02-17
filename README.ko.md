![nextjs notion blog kit](https://github.com/user-attachments/assets/dbfdd093-6637-4fa2-b4ea-9201ad8c2c49)

# Next.js Notion Blog Kit

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Next.js](https://img.shields.io/badge/Next.js-16.0-black)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19.2-61DAFB)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-3178C6)](https://www.typescriptlang.org/)

[English](README.md) | 한국어

> Notion에서 글쓰기. 자유로운 커스터마이징. 몇 분 만에 배포.

## 주요 기능

- **Notion CMS** — Notion에서 바로 포스트 작성 및 관리
- **원클릭 배포** — 명령어 하나로 설정, 하나로 배포
- **퍼포먼스 최적화** — 정적 생성, 코드 스플리팅, 이미지 최적화
- **SEO Full 지원** — Sitemap, RSS 피드, JSON-LD 구조화 데이터, Open Graph
- **라이트/다크 모드** — Radix Colors 기반 테마, 콘텐츠와 댓글까지 연동

## 시작하기

### 1. Notion CMS 만들기

1. [Notion 블로그 데이터베이스 템플릿](https://kyoung-jnn.notion.site/256d55b883778070ab14e9ca4b56f037) 열기
2. **"복제"** 버튼을 클릭하여 데이터베이스를 내 워크스페이스에 복사
3. **"공유"** → **"웹에서 공유"** 토글 켜기
4. URL에서 Page ID 복사 (`?v=` 앞 문자열)

> **Tip:** `⌘+L` (Mac) 또는 `Ctrl+L` (Windows)을 누르면 URL을 바로 선택할 수 있습니다.
>
> **예시 URL:** `https://notion.site/256d55b883778070ab14e9ca4b56f037?v=...` → Page ID: `256d55b883778070ab14e9ca4b56f037`

### 2. 템플릿으로 저장소 생성

이 페이지 상단의 **"Use this template"** 버튼을 클릭하여 저장소를 생성하세요.

### 3. 설정 마법사 실행

```bash
git clone https://github.com/yourusername/your-blog-repo.git
cd your-blog-repo
pnpm blog:setup
```

마법사가 환경 변수, 사이트 설정, 댓글 시스템, Vercel 연결을 안내합니다.

### 4. 배포

```bash
pnpm blog:deploy
```

### 5. Revalidate 버튼 설정

Notion 블로그 템플릿에서 **Revalidate** 버튼 클릭 → URL 편집 → 아래 주소 입력:

```
https://yourdomain.com/article/api?token=YOUR_TOKEN
```

이제 Notion에서 직접 블로그를 업데이트할 수 있습니다 — 글을 작성하고 버튼을 클릭하세요.

## 스크립트

| 명령어                     | 설명               |
| -------------------------- | ------------------ |
| `pnpm dev`                 | 개발 서버 시작     |
| `pnpm build`               | 프로덕션 빌드      |
| `pnpm blog:setup`          | 대화형 설정 마법사 |
| `pnpm blog:deploy`         | 프로덕션 배포      |
| `pnpm blog:deploy:preview` | 프리뷰 배포        |

## 설정

| 파일                          | 용도                                                                |
| ----------------------------- | ------------------------------------------------------------------- |
| `.env`                        | `NOTION_PAGE` (필수), `TOKEN_FOR_REVALIDATE` (선택)                 |
| `src/config/siteConfig.ts`    | 제목, 작성자, URL, 소셜 링크                                        |
| `src/config/commentConfig.ts` | Giscus 댓글 ID ([giscus.app](https://giscus.app/))                  |
| `src/styles/global.css`       | 테마 색상 ([Radix UI Gray](https://www.radix-ui.com/colors) 스케일) |

## Notion 데이터베이스 스키마

| 속성          | 타입      | 필수 | 설명                 |
| ------------- | --------- | ---- | -------------------- |
| **title**     | 제목      | Yes  | 포스트 제목          |
| **slug**      | 텍스트    | No   | 커스텀 URL 슬러그 (비어있으면 제목에서 자동 생성) |
| **date**      | 날짜      | Yes  | 게시 날짜            |
| **status**    | 선택      | Yes  | `publish` or `draft` |
| **thumbnail** | 파일      | No   | 대표 이미지          |
| **tags**      | 다중 선택 | No   | 포스트 카테고리/태그 |

## 배포

**CLI (권장):**

```bash
pnpm blog:deploy          # 프로덕션
pnpm blog:deploy:preview  # 프리뷰
```

**Vercel 대시보드:** GitHub에 푸시 → [Vercel](https://vercel.com)에서 임포트 → 환경 변수 추가 → 배포

**온디맨드 Revalidation:** Notion 대시보드에서 **Revalidate** 버튼 클릭, 또는:

```bash
curl "https://yourdomain.com/article/api?token=YOUR_TOKEN"
```

## 기여하기

기여는 언제나 환영합니다! Pull Request를 자유롭게 제출해주세요. 큰 변경사항의 경우, 먼저 이슈를 열어 논의해주세요.

## 라이선스

이 프로젝트는 MIT 라이선스로 배포됩니다 - 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.
