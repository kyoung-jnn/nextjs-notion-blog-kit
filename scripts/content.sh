#!/bin/bash
# ─── Obsidian Blog Vault Initializer ─────────────────────────────────
# Sets up the project root as an Obsidian vault with blog content
# structure, templates, and a sample post.
#
# Usage:
#   bash scripts/init-content.sh
#   pnpm blog:content:init

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

BLOG_DIR="blog"
TODAY=$(date +%Y-%m-%d)
QUIET=${QUIET:-false}
LOCALE=${LOCALE:-en}

# Suppress output in quiet mode (called from setup.sh)
if [ "$QUIET" = true ]; then
    success() { :; }
fi

if [ "$QUIET" != true ]; then
    banner "Obsidian Blog Vault Setup"

    if [ ! -f "package.json" ]; then
        fail "package.json not found! Are you in the project root?"
        exit 1
    fi

    if [ -d ".obsidian" ]; then
        echo -e "  ${YELLOW}Project root${NC} already has an Obsidian vault."
        if ! confirm "Re-initialize? (existing posts will be preserved)"; then
            echo ""
            echo "  Aborted."
            exit 0
        fi
        echo ""
    fi

    echo -e "${BOLD}Creating Obsidian blog vault...${NC}"
    echo ""
fi

# ─── 1. Directory Structure ──────────────────────────────────────────

mkdir -p "$BLOG_DIR/📝 posts"
mkdir -p "$BLOG_DIR/📋 templates"
mkdir -p "public/images"
mkdir -p ".obsidian/plugins/dataview"
mkdir -p ".obsidian/plugins/obsidian-git"

success "Directory structure created"

# ─── 2. Obsidian App Settings ────────────────────────────────────────
# Vault is project root; images go to public/images/ for Next.js

cat > ".obsidian/app.json" << 'OBSIDIAN_EOF'
{
  "attachmentFolderPath": "public/images",
  "newFileLocation": "folder",
  "newFileFolderPath": "blog/📝 posts",
  "useMarkdownLinks": true,
  "showLineCount": true,
  "strictLineBreaks": true,
  "propertiesInDocument": "visible",
  "livePreview": true,
  "userIgnoreFilters": [
    "node_modules/",
    ".next/",
    "src/",
    ".git/",
    "scripts/",
    ".env*",
    "*.config.*",
    "tsconfig.json",
    "pnpm-lock.yaml",
    "package.json"
  ]
}
OBSIDIAN_EOF

success "Obsidian app settings (images → public/images/)"

# ─── 3. Core Plugins ─────────────────────────────────────────────────

cat > ".obsidian/core-plugins.json" << 'OBSIDIAN_EOF'
[
  "file-explorer",
  "global-search",
  "tag-pane",
  "properties",
  "editor-status",
  "word-count",
  "outline",
  "templates"
]
OBSIDIAN_EOF

success "Core plugins configured"

# ─── 4. Templates Plugin Settings ────────────────────────────────────

cat > ".obsidian/templates.json" << 'OBSIDIAN_EOF'
{
  "folder": "blog/📋 templates",
  "dateFormat": "YYYY-MM-DD",
  "timeFormat": "HH:mm"
}
OBSIDIAN_EOF

success "Templates plugin configured"

# ─── 5. Appearance ───────────────────────────────────────────────────

cat > ".obsidian/appearance.json" << 'OBSIDIAN_EOF'
{
  "accentColor": "",
  "interfaceFontSize": 16,
  "textFontSize": 16,
  "baseFontSize": 16
}
OBSIDIAN_EOF

success "Appearance settings"

# ─── 6. Obsidian Git Plugin Settings ─────────────────────────────────
# Pre-configure so users just need to install the plugin

cat > ".obsidian/plugins/obsidian-git/data.json" << 'OBSIDIAN_EOF'
{
  "autoSaveInterval": 0,
  "autoPushInterval": 0,
  "autoPullInterval": 0,
  "commitMessage": "publish: {{date}}",
  "autoCommitMessage": "auto: {{date}}",
  "pushOnBackup": true,
  "pullBeforePush": true,
  "disablePush": false,
  "syncMethod": "merge",
  "showStatusBar": true,
  "updateSubmodules": false,
  "changedFilesInStatusBar": true
}
OBSIDIAN_EOF

success "Obsidian Git plugin settings"

# ─── 7. Dataview Plugin Settings ─────────────────────────────────────

cat > ".obsidian/plugins/dataview/data.json" << 'OBSIDIAN_EOF'
{
  "renderNullAs": "-",
  "taskCompletionTracking": false,
  "warnOnEmptyResult": true,
  "refreshEnabled": true,
  "refreshInterval": 2500,
  "defaultDateFormat": "YYYY-MM-DD",
  "defaultDateTimeFormat": "YYYY-MM-DD HH:mm",
  "maxRecursiveRenderDepth": 4,
  "showResultCount": true,
  "enableDataviewJs": false,
  "enableInlineDataview": true,
  "enableInlineDataviewJs": false,
  "prettyRenderInlineFields": true,
  "prettyRenderInlineFieldsInLivePreview": true
}
OBSIDIAN_EOF

success "Dataview plugin settings"

# ─── 8. Blog Post Template ───────────────────────────────────────────

cat > "$BLOG_DIR/📋 templates/blog-post.md" << 'TEMPLATE_EOF'
---
title: "{{title}}"
date: {{date}}
slug:
status: draft
thumbnail:
description:
tags: []
---

TEMPLATE_EOF

success "Blog post template"

# ─── 9. Sample Post ──────────────────────────────────────────────────

if [ ! -f "$BLOG_DIR/📝 posts/hello-world.md" ]; then
    if [ "$LOCALE" = "ko" ]; then
        cat > "$BLOG_DIR/📝 posts/hello-world.md" << SAMPLE_EOF
---
title: "Hello World"
date: $TODAY
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

1. Obsidian에서 \`Ctrl/Cmd+N\`으로 새 노트 생성
2. \`Ctrl/Cmd+T\`로 **blog-post** 템플릿 적용
3. \`📝 posts/\` 폴더에 저장
4. frontmatter의 \`status\`를 \`publish\`로 변경
5. GitHub에 Push하면 사이트가 자동으로 빌드됩니다

### 지원되는 마크다운 기능

**굵게**, *기울임*, ~~취소선~~, \`인라인 코드\`

> 인용문도 지원됩니다.

\`\`\`typescript
function greet(name: string): string {
  return "Hello, " + name + "!"
}
\`\`\`

| 기능 | 지원 |
|------|------|
| 제목 (h1-h6) | O |
| 코드 블록 (Shiki) | O |
| 테이블 (GFM) | O |
| 이미지 | O |
| 수식 (KaTeX) | O |

### 수식

인라인 수식: \$E = mc^2\$

블록 수식:

\$\$
\\sum_{i=1}^{n} x_i = x_1 + x_2 + \\cdots + x_n
\$\$

---

이 샘플 포스트를 수정하거나 삭제하고, 자신만의 글을 작성해보세요!
SAMPLE_EOF
    else
        cat > "$BLOG_DIR/📝 posts/hello-world.md" << SAMPLE_EOF
---
title: "Hello World"
date: $TODAY
slug: hello-world
status: publish
thumbnail:
description: "Your first blog post, written in Obsidian and powered by Next.js."
tags: [blog, obsidian]
---

# Hello World

Welcome to the Obsidian Blog Kit!

## Getting Started

This blog turns **markdown files** written in Obsidian into static pages built by Next.js.

### How to Write a Post

1. Create a new note in Obsidian (\`Ctrl/Cmd+N\`)
2. Insert the **blog-post** template (\`Ctrl/Cmd+T\`)
3. Save to the \`📝 posts/\` folder
4. Set \`status: publish\` in frontmatter
5. Push to GitHub — your site rebuilds automatically

### Supported Markdown Features

**Bold**, *italic*, ~~strikethrough~~, \`inline code\`

> Blockquotes are supported too.

\`\`\`typescript
function greet(name: string): string {
  return "Hello, " + name + "!"
}
\`\`\`

| Feature | Supported |
|---------|-----------|
| Headings (h1-h6) | Yes |
| Code blocks (Shiki) | Yes |
| Tables (GFM) | Yes |
| Images | Yes |
| Math (KaTeX) | Yes |

### Math

Inline math: \$E = mc^2\$

Block math:

\$\$
\\sum_{i=1}^{n} x_i = x_1 + x_2 + \\cdots + x_n
\$\$

---

Edit or delete this sample post, and start writing your own!
SAMPLE_EOF
    fi
    success "Sample post (📝 posts/hello-world.md)"
else
    success "Sample post already exists (skipped)"
fi

# ─── 10. Blog Dashboard ──────────────────────────────────────────────
# Dataview queries are language-agnostic (column headers stay English for consistency)

if [ "$LOCALE" = "ko" ]; then
    DASH_INFO="> [!info] Dataview 플러그인 필요\n> 아래 테이블은 **Dataview** 커뮤니티 플러그인이 필요합니다.\n> Settings → Community Plugins → Browse → \`Dataview\` 설치 후 활성화하세요."
    DASH_ALL="전체 글 목록"
    DASH_PUB="발행된 글"
    DASH_DRAFT="작성 중 (Draft)"
    DASH_STATS="통계"
    DASH_COUNT="length(rows) + \"개 글\""
else
    DASH_INFO="> [!info] Dataview plugin required\n> The tables below require the **Dataview** community plugin.\n> Settings → Community Plugins → Browse → Install \`Dataview\` and enable it."
    DASH_ALL="All Posts"
    DASH_PUB="Published"
    DASH_DRAFT="Drafts"
    DASH_STATS="Stats"
    DASH_COUNT="length(rows) + \" post(s)\""
fi

cat > "$BLOG_DIR/📊 Dashboard.md" << DASHBOARD_EOF
---
cssclasses: [dashboard]
---

# Blog Dashboard

$(echo -e "$DASH_INFO")

## $DASH_ALL

\`\`\`dataview
TABLE WITHOUT ID
  file.link AS "title",
  thumbnail AS "thumbnail",
  date AS "date",
  choice(status = "publish", "🟢 publish", "🟡 draft") AS "status"
FROM "blog/📝 posts"
SORT date DESC
\`\`\`

## $DASH_PUB

\`\`\`dataview
TABLE WITHOUT ID
  file.link AS "title",
  thumbnail AS "thumbnail",
  date AS "date",
  join(tags, ", ") AS "tags"
FROM "blog/📝 posts"
WHERE status = "publish"
SORT date DESC
\`\`\`

## $DASH_DRAFT

\`\`\`dataview
TABLE WITHOUT ID
  file.link AS "title",
  date AS "date",
  join(tags, ", ") AS "tags"
FROM "blog/📝 posts"
WHERE status = "draft"
SORT date DESC
\`\`\`

## $DASH_STATS

\`\`\`dataview
LIST WITHOUT ID $DASH_COUNT
FROM "blog/📝 posts"
GROUP BY true
\`\`\`

\`\`\`dataview
LIST WITHOUT ID status + ": " + length(rows)
FROM "blog/📝 posts"
GROUP BY status
\`\`\`

\`\`\`dataview
LIST WITHOUT ID tag + " (" + length(rows) + ")"
FROM "blog/📝 posts"
FLATTEN tags AS tag
GROUP BY tag
SORT length(rows) DESC
\`\`\`
DASHBOARD_EOF

success "Blog dashboard (📊 Dashboard.md)"

# ─── 11. Frontmatter Reference ───────────────────────────────────────

if [ "$LOCALE" = "ko" ]; then
    cat > "$BLOG_DIR/📖 FRONTMATTER.md" << 'REF_EOF'
# Frontmatter Reference

Blog post `.md` 파일의 YAML frontmatter 필드 참조입니다.

## 필수 필드

| 필드 | 타입 | 설명 | 예시 |
|------|------|------|------|
| `title` | string | 포스트 제목 | `"Hello World"` |
| `date` | string | 발행일 (YYYY-MM-DD) | `2026-03-16` |
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
date: 2026-03-16
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
REF_EOF
else
    cat > "$BLOG_DIR/📖 FRONTMATTER.md" << 'REF_EOF'
# Frontmatter Reference

YAML frontmatter fields for blog post `.md` files.

## Required Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `title` | string | Post title | `"Hello World"` |
| `date` | string | Publication date (YYYY-MM-DD) | `2026-03-16` |
| `status` | string | Publish state | `publish` or `draft` |

## Optional Fields

| Field | Type | Description | Example |
|-------|------|-------------|---------|
| `slug` | string | URL path (auto-generated from filename if empty) | `hello-world` |
| `thumbnail` | string | Thumbnail image path | `/images/cover.jpg` |
| `description` | string | SEO description (auto-extracted from content if empty) | `"My first post"` |
| `tags` | list | Post tags | `[blog, nextjs]` |

## Example

```yaml
---
title: "Building a Blog with Next.js"
date: 2026-03-16
slug: nextjs-blog
status: publish
thumbnail: /images/cover.jpg
description: "How I built a blog with Next.js and Obsidian"
tags: [nextjs, blog, obsidian]
---
```

## Notes

- Posts with `status: draft` are only visible in development
- Empty `slug` is auto-generated from filename (e.g., `my-post.md` → `my-post`)
- Empty `description` is auto-extracted from the first 160 characters
- Images pasted in Obsidian auto-save to `public/images/`
REF_EOF
fi

success "Frontmatter reference (📖 FRONTMATTER.md)"

# ─── 12. public/images/.gitkeep ──────────────────────────────────────

touch public/images/.gitkeep
success "public/images/ directory"

# ─── Summary ──────────────────────────────────────────────────────────

if [ "$QUIET" != true ]; then
    echo ""
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}  ✓ Obsidian Blog Vault Created!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo -e "  ${BLUE}pnpm dev${NC}             Start dev server"
    echo -e "  ${BLUE}Open in Obsidian${NC}     This folder → install Dataview & Obsidian Git"
    echo -e "  ${BLUE}📊 Dashboard.md${NC}      Manage posts"
    echo ""
fi
