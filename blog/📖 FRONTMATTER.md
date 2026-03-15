# Frontmatter Reference

Blog post `.md` 파일의 YAML frontmatter 필드 참조입니다.

## 필수 필드

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `title` | string | 포스트 제목 | `"Hello World"` |
| `date` | string | 발행일 (YYYY-MM-DD) | `2026-03-10` |
| `status` | string | 발행 상태 | `publish` 또는 `draft` |

## 선택 필드

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `slug` | string | URL 경로 (비어있으면 파일명 사용) | `hello-world` |
| `thumbnail` | string | 썸네일 이미지 경로 | `/images/cover.jpg` |
| `description` | string | SEO 설명 (비어있으면 본문에서 추출) | `"첫 번째 포스트"` |
| `tags` | list | 태그 목록 | `[blog, nextjs]` |

## 예시

```yaml
---
title: "Next.js로 블로그 만들기"
date: 2026-03-10
slug: nextjs-blog
status: publish
thumbnail: /images/cover.jpg
description: "Next.js와 Obsidian을 활용한 블로그 구축기"
tags: [nextjs, blog, obsidian]
---
```

## 주의사항

- `status: draft`인 글은 개발 환경에서만 표시됩니다
- `slug`을 비우면 파일명에서 자동 생성됩니다 (예: `my-post.md` → `my-post`)
- `description`을 비우면 본문 첫 160자에서 자동 추출됩니다
- 이미지는 Obsidian에서 붙여넣기 시 `public/images/`에 자동 저장됩니다
