---
cssclasses: [dashboard]
---

# Blog Dashboard

> [!info] Dataview 플러그인 필요
> 아래 테이블은 **Dataview** 커뮤니티 플러그인이 필요합니다.
> Settings → Community Plugins → Browse → `Dataview` 설치 후 활성화하세요.

## 전체 글 목록

```dataview
TABLE WITHOUT ID
  file.link AS "title",
  thumbnail AS "thumbnail",
  date AS "date",
  choice(status = "publish", "🟢 publish", "🟡 draft") AS "status"
FROM "blog/📝 posts"
SORT date DESC
```

## 발행된 글

```dataview
TABLE WITHOUT ID
  file.link AS "title",
  thumbnail AS "thumbnail",
  date AS "date",
  join(tags, ", ") AS "tags"
FROM "blog/📝 posts"
WHERE status = "publish"
SORT date DESC
```

## 작성 중 (Draft)

```dataview
TABLE WITHOUT ID
  file.link AS "title",
  date AS "date",
  join(tags, ", ") AS "tags"
FROM "blog/📝 posts"
WHERE status = "draft"
SORT date DESC
```

## 통계

```dataview
LIST WITHOUT ID "총 " + length(rows) + "개 글"
FROM "blog/📝 posts"
GROUP BY true
```

```dataview
LIST WITHOUT ID status + ": " + length(rows) + "개"
FROM "blog/📝 posts"
GROUP BY status
```

```dataview
LIST WITHOUT ID tag + " (" + length(rows) + ")"
FROM "blog/📝 posts"
FLATTEN tags AS tag
GROUP BY tag
SORT length(rows) DESC
```
