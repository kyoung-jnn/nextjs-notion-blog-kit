#!/bin/bash
# ─── Obsidian Blog Vault Initializer ─────────────────────────────────
# Sets up the project root as an Obsidian vault with blog content
# structure, templates, and a sample post.
# Optimized for Make.md plugin (Notion-like experience).
#
# Usage:
#   bash scripts/content.sh
#   Called by: pnpm blog:setup

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/common.sh"

POSTS_DIR="posts"
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

mkdir -p "$POSTS_DIR"
mkdir -p "$POSTS_DIR/templates"
mkdir -p "public/images"
mkdir -p ".obsidian/plugins/dataview"
mkdir -p ".obsidian/plugins/obsidian-git"
mkdir -p ".obsidian/plugins/make-md"

success "Directory structure created"

# ─── 2. Obsidian App Settings ────────────────────────────────────────

cat > ".obsidian/app.json" << 'OBSIDIAN_EOF'
{
  "attachmentFolderPath": "public/images",
  "newFileLocation": "folder",
  "newFileFolderPath": "posts",
  "useMarkdownLinks": true,
  "showLineCount": true,
  "strictLineBreaks": true,
  "propertiesInDocument": "visible",
  "livePreview": true
}
OBSIDIAN_EOF

success "Obsidian app settings"

# ─── 3. Core Plugins ─────────────────────────────────────────────────
# Disable file-explorer — Make.md Navigator replaces it

cat > ".obsidian/core-plugins.json" << 'OBSIDIAN_EOF'
{
  "file-explorer": false,
  "global-search": true,
  "switcher": false,
  "graph": false,
  "backlink": false,
  "outgoing-link": false,
  "tag-pane": true,
  "page-preview": false,
  "daily-notes": false,
  "templates": true,
  "note-composer": false,
  "command-palette": true,
  "slash-command": false,
  "editor-status": true,
  "markdown-importer": false,
  "zk-prefixer": false,
  "random-note": false,
  "outline": true,
  "word-count": true,
  "slides": false,
  "audio-recorder": false,
  "workspaces": false,
  "file-recovery": false,
  "publish": false,
  "sync": false,
  "canvas": false,
  "footnotes": false,
  "properties": true,
  "bookmarks": true,
  "bases": false,
  "webviewer": false
}
OBSIDIAN_EOF

success "Core plugins configured (file-explorer disabled → Make.md Navigator)"

# ─── 4. Community Plugins ────────────────────────────────────────────

cat > ".obsidian/community-plugins.json" << 'OBSIDIAN_EOF'
[
  "dataview",
  "obsidian-git",
  "make-md"
]
OBSIDIAN_EOF

success "Community plugins registered"

# ─── 5. Templates Plugin Settings ────────────────────────────────────

cat > ".obsidian/templates.json" << 'OBSIDIAN_EOF'
{
  "folder": "posts/templates",
  "dateFormat": "YYYY-MM-DD",
  "timeFormat": "HH:mm"
}
OBSIDIAN_EOF

success "Templates plugin configured"

# ─── 6. Appearance ───────────────────────────────────────────────────

cat > ".obsidian/appearance.json" << 'OBSIDIAN_EOF'
{
  "accentColor": "#808080",
  "baseFontSize": 16,
  "translucency": true
}
OBSIDIAN_EOF

success "Appearance settings"

# ─── 7. Obsidian Git Plugin ──────────────────────────────────────────

cat > ".obsidian/plugins/obsidian-git/data.json" << 'OBSIDIAN_EOF'
{
  "autoSaveInterval": 0,
  "autoPushInterval": 0,
  "autoPullInterval": 0,
  "commitMessage": "📝 publish: {{numFiles}} file(s) — {{date}}",
  "autoCommitMessage": "✏️ draft: {{numFiles}} file(s) — {{date}}",
  "listChangedFilesInMessageBody": true,
  "pushOnBackup": true,
  "pullBeforePush": true,
  "disablePush": false,
  "syncMethod": "merge",
  "showStatusBar": true,
  "updateSubmodules": false,
  "changedFilesInStatusBar": true,
  "showedMobileNotice": true,
  "autoBackupAfterFileChange": false,
  "basePath": "",
  "differentIntervalCommitAndPush": false,
  "autoPullOnBoot": true
}
OBSIDIAN_EOF

success "Obsidian Git plugin settings"

# ─── 8. Dataview Plugin ──────────────────────────────────────────────

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

# ─── 9. Make.md Plugin ───────────────────────────────────────────────
# Notion-like experience: Navigator, Flow editor, folder notes, banners

cat > ".obsidian/plugins/make-md/data.json" << 'MAKEMD_EOF'
{
  "newNotePlaceholder": "Untitled",
  "defaultInitialization": false,
  "navigatorEnabled": true,
  "filePreviewOnHover": false,
  "blinkEnabled": true,
  "datePickerTime": false,
  "imageThumbnails": false,
  "noteThumbnails": false,
  "spacesMDBInHidden": true,
  "cacheIndex": true,
  "spacesRightSplit": false,
  "contextEnabled": true,
  "spaceViewEnabled": true,
  "saveAllContextToFrontmatter": false,
  "autoOpenFileContext": false,
  "activeView": "posts",
  "hideFrontmatter": false,
  "activeSpace": "",
  "defaultDateFormat": "YYYY-MM-DD",
  "defaultTimeFormat": "HH:mm",
  "spacesEnabled": true,
  "syncFormulaToFrontmatter": true,
  "spacesPerformance": false,
  "currentWaypoint": 0,
  "enableFolderNote": false,
  "folderIndentationLines": true,
  "revealActiveFile": false,
  "spacesStickers": true,
  "spaceRowHeight": 29,
  "mobileSpaceRowHeight": 40,
  "bannerHeight": 200,
  "spacesDisablePatch": false,
  "folderNoteInsideFolder": true,
  "folderNoteName": "",
  "sidebarTabs": true,
  "showRibbon": true,
  "vaultSelector": true,
  "deleteFileOption": "system-trash",
  "expandedSpaces": [
    "/",
    "posts"
  ],
  "expandFolderOnClick": true,
  "spacesFolder": ".spaces",
  "suppressedWarnings": [],
  "spaceSubFolder": ".space",
  "hiddenFiles": [
    "node_modules",
    ".next",
    "src",
    ".git",
    "scripts",
    "public",
    ".env",
    ".env.example",
    ".gitignore",
    ".claude",
    ".husky",
    ".obsidian",
    ".obsidianignore",
    ".makemd",
    ".space",
    ".spaces",
    ".vscode",
    ".nvmrc",
    "Tags",
    "eslint.config.mjs",
    "next-env.d.ts",
    "next-sitemap.config.js",
    "next.config.mjs",
    "postcss.config.mjs",
    "prettier.config.mjs",
    "package.json",
    "pnpm-lock.yaml",
    "tsconfig.json",
    "LICENSE",
    "README.md",
    "README.ko.md",
    "posts/templates",
    "tsconfig.tsbuildinfo"
  ],
  "hiddenExtensions": [
    ".mdb",
    "_assets",
    "_blocks",
    ".base",
    ".gitkeep"
  ],
  "newFileLocation": "folder",
  "newFileFolderPath": "posts",
  "inlineBacklinks": false,
  "inlineContext": true,
  "inlineBacklinksExpanded": false,
  "inlineContextExpanded": true,
  "inlineContextProperties": false,
  "inlineContextSectionsExpanded": true,
  "banners": true,
  "inlineContextNameLayout": "vertical",
  "spacesUseAlias": false,
  "fmKeyAlias": "aliases",
  "fmKeyBanner": "banner",
  "fmKeyColor": "color",
  "fmKeyBannerOffset": "banner_y",
  "fmKeySticker": "sticker",
  "openSpacesOnLaunch": true,
  "indexSVG": false,
  "readableLineWidth": true,
  "autoAddContextsToSubtags": true,
  "releaseNotesPrompt": 0,
  "enableDefaultSpaces": true,
  "showSpacePinIcon": true,
  "experimental": false,
  "systemName": "Blog",
  "defaultSpaceTemplate": "",
  "selectedKit": "default",
  "actionMaxSteps": 100,
  "contextPagination": 25,
  "skipFolders": [
    "node_modules",
    ".next",
    "src",
    ".git",
    "scripts",
    ".claude",
    ".husky",
    ".vscode"
  ],
  "skipFolderNames": [],
  "enhancedLogs": false,
  "basics": true,
  "basicsSettings": {
    "flowMenuEnabled": true,
    "markSans": false,
    "makeMenuPlaceholder": true,
    "mobileMakeBar": false,
    "mobileSidepanel": false,
    "inlineStyler": true,
    "inlineStylerColors": true,
    "inlineStylerSelectedPalette": "",
    "editorFlow": true,
    "internalLinkClickFlow": true,
    "internalLinkSticker": true,
    "editorFlowStyle": "minimal",
    "menuTriggerChar": "/",
    "inlineStickerMenu": true,
    "emojiTriggerChar": ":",
    "flowState": false
  },
  "firstLaunch": false,
  "notesPreview": false,
  "editStickerInSidebar": true,
  "overrideNativeMenu": false,
  "onboardingCompleted": true,
  "contextCreateUseModal": false,
  "homepagePath": "",
  "mobileMakeHeader": false
}
MAKEMD_EOF

success "Make.md plugin (Notion-like: Navigator, Flow, folder notes)"

# ─── 10. Blog Post Template ──────────────────────────────────────────

cat > "$POSTS_DIR/templates/blog-post.md" << 'TEMPLATE_EOF'
---
title: "{{title}}"
date: {{date}}
slug:
published: false
thumbnail:
tags: []
---

TEMPLATE_EOF

success "Blog post template"

# ─── 11. Sample Post ─────────────────────────────────────────────────

if [ ! -f "$POSTS_DIR/hello-world.md" ]; then
    if [ "$LOCALE" = "ko" ]; then
        cat > "$POSTS_DIR/hello-world.md" << SAMPLE_EOF
---
title: "Hello World"
date: $TODAY
slug: hello-world
published: true
thumbnail:
tags: [blog, obsidian]
---

# Hello World

Obsidian 블로그 키트에 오신 것을 환영합니다!

## 시작하기

이 블로그는 **Obsidian**에서 작성한 마크다운 파일을 Next.js가 빌드 시 읽어 정적 페이지로 생성합니다.

### 글 작성 방법

1. Obsidian에서 \`Ctrl/Cmd+N\`으로 새 노트 생성
2. \`Ctrl/Cmd+T\`로 **blog-post** 템플릿 적용
3. \`posts/\` 폴더에 저장
4. frontmatter의 \`published\` 토글 켜기
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
        cat > "$POSTS_DIR/hello-world.md" << SAMPLE_EOF
---
title: "Hello World"
date: $TODAY
slug: hello-world
published: true
thumbnail:
tags: [blog, obsidian]
---

# Hello World

Welcome to the Obsidian Blog Kit!

## Getting Started

This blog turns **markdown files** written in Obsidian into static pages built by Next.js.

### How to Write a Post

1. Create a new note in Obsidian (\`Ctrl/Cmd+N\`)
2. Insert the **blog-post** template (\`Ctrl/Cmd+T\`)
3. Save to the \`posts/\` folder
4. Toggle \`published\` on in frontmatter
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
    success "Sample post (posts/hello-world.md)"
else
    success "Sample post already exists (skipped)"
fi

# ─── 12. Dashboard (project root) ────────────────────────────────────
# Dashboard — opens on Obsidian launch via homepagePath

if [ "$LOCALE" = "ko" ]; then
    DASH_ALL="전체 글 목록"
    DASH_DRAFT="작성 중"
    DASH_STATS="통계"
    DASH_COUNT="length(rows) + \"개 글\""
    DASH_QUICK="빠른 시작"
    DASH_QUICK_1="새 노트 생성 → \`Ctrl/Cmd+N\`"
    DASH_QUICK_2="템플릿 적용 → \`Ctrl/Cmd+T\` → **blog-post**"
    DASH_QUICK_3="\`published\` 토글 켜기 → Git Push"
else
    DASH_ALL="All Posts"
    DASH_DRAFT="Drafts"
    DASH_STATS="Stats"
    DASH_COUNT="length(rows) + \" post(s)\""
    DASH_QUICK="Quick Start"
    DASH_QUICK_1="Create new note → \`Ctrl/Cmd+N\`"
    DASH_QUICK_2="Apply template → \`Ctrl/Cmd+T\` → **blog-post**"
    DASH_QUICK_3="Toggle \`published\` on → Git Push"
fi

cat > "dashboard.md" << DASHBOARD_EOF
---
sticker: lucide//layout-dashboard
---

## $DASH_QUICK

- $DASH_QUICK_1
- $DASH_QUICK_2
- $DASH_QUICK_3

## $DASH_ALL

\`\`\`dataview
TABLE WITHOUT ID
  file.link AS "title",
  dateformat(date, "yyyy-MM-dd") AS "date",
  choice(published, "🟢 published", "🟡 draft") AS "status",
  join(tags, ", ") AS "tags"
FROM "posts" AND -"posts/templates"
SORT date DESC
\`\`\`

## $DASH_DRAFT

\`\`\`dataview
TABLE WITHOUT ID
  file.link AS "title",
  dateformat(date, "yyyy-MM-dd") AS "date",
  join(tags, ", ") AS "tags"
FROM "posts" AND -"posts/templates"
WHERE !published
SORT date DESC
\`\`\`

## $DASH_STATS

\`\`\`dataview
LIST WITHOUT ID $DASH_COUNT
FROM "posts" AND -"posts/templates"
GROUP BY true
\`\`\`

\`\`\`dataview
LIST WITHOUT ID choice(published, "published", "draft") + ": " + length(rows)
FROM "posts" AND -"posts/templates"
GROUP BY published
\`\`\`

\`\`\`dataview
LIST WITHOUT ID tag + " (" + length(rows) + ")"
FROM "posts" AND -"posts/templates"
FLATTEN tags AS tag
GROUP BY tag
SORT length(rows) DESC
\`\`\`
DASHBOARD_EOF

success "Dashboard (dashboard.md)"

# ─── 13. public/images/.gitkeep ──────────────────────────────────────

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
    echo -e "  ${BLUE}Open in Obsidian${NC}     This folder → Make.md Navigator"
    echo -e "  ${BLUE}dashboard.md${NC}         Click to open Dashboard"
    echo ""
fi
