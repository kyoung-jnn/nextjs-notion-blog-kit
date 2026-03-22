---
sticker: emoji//1f4ca
---
## 빠른 시작

- 새 노트 생성 → `Ctrl/Cmd+N`
- 템플릿 적용 → `Ctrl/Cmd+T` → **blog-post**
- `published` 토글 켜기 → Git Push

## Frontmatter 참조

| 필드        | 타입    | 필수 | 설명                              |
| ----------- | ------- | ---- | --------------------------------- |
| `title`     | string  | Yes  | 포스트 제목                       |
| `date`      | string  | Yes  | 발행일 (YYYY-MM-DD)              |
| `published` | boolean | Yes  | 발행 토글                         |
| `slug`      | string  | No   | URL 경로 (비어있으면 파일명 사용) |
| `thumbnail` | string  | No   | 썸네일 이미지 경로                |
| `tags`      | list    | No   | 태그 목록                         |

> [!tip] 자동 처리
> - `description` meta tag는 본문 첫 160자에서 자동 추출
> - `slug` 비우면 파일명에서 자동 생성
> - 이미지 붙여넣기 시 `public/images/`에 자동 저장

## 전체 글 목록

```dataview
TABLE WITHOUT ID
  file.link AS "title",
  dateformat(date, "yyyy-MM-dd") AS "date",
  choice(published, "🟢 published", "🟡 draft") AS "status",
  join(tags, ", ") AS "tags"
FROM "posts" AND -"posts/templates"
SORT date DESC
```

## 작성 중

```dataview
TABLE WITHOUT ID
  file.link AS "title",
  dateformat(date, "yyyy-MM-dd") AS "date",
  join(tags, ", ") AS "tags"
FROM "posts" AND -"posts/templates"
WHERE !published
SORT date DESC
```

## 통계

```dataview
LIST WITHOUT ID length(rows) + "개 글"
FROM "posts" AND -"posts/templates"
GROUP BY true
```

```dataview
LIST WITHOUT ID choice(published, "published", "draft") + ": " + length(rows)
FROM "posts" AND -"posts/templates"
GROUP BY published
```

```dataview
LIST WITHOUT ID tag + " (" + length(rows) + ")"
FROM "posts" AND -"posts/templates"
FLATTEN tags AS tag
GROUP BY tag
SORT length(rows) DESC
```
