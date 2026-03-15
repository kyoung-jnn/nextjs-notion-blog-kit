---
title: "Hello World"
date: 2026-03-10
slug: hello-world
status: publish
thumbnail:
description: "Obsidian으로 작성한 첫 번째 블로그 포스트입니다."
tags: [blog, obsidian]
---

# Hello World

Obsidian 블로그 키트에 오신 것을 환영합니다!

## 시작하기

이 블로그는 **Obsidian**에서 작성한 마크다운 파일을 Next.js가 빌드 시 읽어 정적 페이지로 생성합니다.

### 글 작성 방법

1. Obsidian에서 `Ctrl/Cmd+N`으로 새 노트 생성
2. `Ctrl/Cmd+T`로 **blog-post** 템플릿 적용
3. `posts/` 폴더에 저장
4. frontmatter의 `status`를 `publish`로 변경하면 배포됩니다

### 지원되는 마크다운 기능

**굵게**, *기울임*, ~~취소선~~, `인라인 코드`

> 인용문도 지원됩니다.

```typescript
function greet(name: string): string {
  return "Hello, " + name + "!"
}
```

| 기능 | 지원 |
|------|------|
| 제목 (h1-h6) | O |
| 코드 블록 | O |
| 테이블 | O |
| 이미지 | O |
| 수식 (KaTeX) | O |

### 수식

인라인 수식: $E = mc^2$

블록 수식:

$$
\sum_{i=1}^{n} x_i = x_1 + x_2 + \cdots + x_n
$$

---

이 샘플 포스트를 수정하거나 삭제하고, 자신만의 글을 작성해보세요!
