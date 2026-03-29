---
sticker: emoji//1f4cb
---

> [!note]- Write & Deploy
>
> ### Write
>
> 1. `Ctrl/Cmd+N` to create a new post (template auto-applied)
> 2. Toggle `published` checkbox when ready
>
> ### Deploy
>
> - **From Obsidian** — `Ctrl+P` → `Obsidian Git: Commit` → `Obsidian Git: Push`
> - **From terminal** — `git add . && git commit -m "publish" && git push`
> - Vercel rebuilds automatically on every push to `main`

```dataview
TABLE WITHOUT ID
  file.link AS "title",
  dateformat(date, "yyyy-MM-dd") AS "date",
  choice(published, "🟢", "🟡") AS "status"
FROM "posts" AND -"posts/templates"
SORT date DESC
```
