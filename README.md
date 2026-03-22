# Next.js Obsidian Blog Kit

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Next.js](https://img.shields.io/badge/Next.js-16.0-black)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19.2-61DAFB)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-3178C6)](https://www.typescriptlang.org/)

English | [한국어](README.ko.md)

<img width="1200" height="627" alt="nextjs obsidian blog kit" src="https://github.com/user-attachments/assets/97d27f51-35fd-4e8c-ac64-a3e627109ec7" />

> Write in Obsidian. Push to GitHub. Blog is live.

## Features

- **Obsidian as CMS** — Write markdown locally, manage posts with a Notion-like dashboard
- **Zero-Config Setup** — `pnpm blog:setup` auto-detects everything, no questions asked
- **Performance Optimized** — Static generation, code splitting, Shiki syntax highlighting
- **Full SEO** — Sitemap, RSS feed, JSON-LD structured data, Open Graph
- **Light/Dark Mode** — Radix Colors based theme across content and comments

## Get Started

### 1. Create Your Repo

Click **"Use this template"** at the top of this repo, then:

```bash
git clone https://github.com/yourusername/your-blog.git
cd your-blog
pnpm blog:setup
```

That's it. Setup auto-detects your Git config (author, email, GitHub URL, Giscus) and initializes the Obsidian vault.

### 2. Open in Obsidian

Open this project folder as an Obsidian vault. Install two community plugins:

- **Dataview** — Notion-like table view for managing posts
- **Obsidian Git** — Push to GitHub directly from Obsidian

### 3. Write & Publish

1. Open **📊 Dashboard.md** to see all posts
2. Create a new note → Insert **blog-post** template (`Ctrl/Cmd+T`)
3. Write your post in **blog/📝 posts/**
4. Set `status: publish` in frontmatter
5. Push to GitHub → Vercel auto-builds your site

### 4. Deploy

Setup will ask to deploy at the end. Or deploy anytime with:

```bash
pnpm blog:deploy
```

First run auto-links your project to Vercel and pushes env vars. After that, every push to `main` triggers a rebuild automatically.

## Project Structure

```
<project-root>/              ← Obsidian Vault
├── .obsidian/                # Vault settings (auto-configured)
├── blog/
│   ├── 📝 posts/             # Your blog posts (.md)
│   ├── 📋 templates/         # Post template
│   ├── 📊 Dashboard.md       # Post management dashboard
│   └── 📖 FRONTMATTER.md     # Frontmatter reference
├── public/images/            # Image attachments (auto-saved by Obsidian)
├── src/                      # Next.js source code
└── .env                      # Site configuration
```

## Frontmatter Schema

```yaml
---
title: "My Post Title"
date: 2026-03-14
slug: my-post-title          # Optional — auto-generated from filename
status: publish               # publish or draft
thumbnail: /images/cover.jpg  # Optional
description: "SEO description" # Optional — auto-extracted from content
tags: [nextjs, blog]          # Optional
---
```

| Field         | Type   | Required | Description                                          |
| ------------- | ------ | -------- | ---------------------------------------------------- |
| **title**     | string | Yes      | Post title                                           |
| **date**      | date   | Yes      | Publication date (YYYY-MM-DD)                        |
| **status**    | string | Yes      | `publish` or `draft`                                 |
| **slug**      | string | No       | URL path (auto-generated from filename if empty)     |
| **thumbnail** | string | No       | Image path (e.g., `/images/cover.jpg`)               |
| **description** | string | No    | SEO description (auto-extracted from content if empty) |
| **tags**      | list   | No       | Post tags                                            |

## Scripts

| Command                  | Description                |
| ------------------------ | -------------------------- |
| `pnpm dev`               | Start development server   |
| `pnpm build`             | Production build           |
| `pnpm blog:setup`        | Zero-config setup          |
| `pnpm blog:deploy`       | Deploy to Vercel           |
| `pnpm blog:doctor`       | Diagnostics & health check |

## Configuration

All settings are in `blog.config.ts`. Edit after running `pnpm blog:setup`:

```ts
// blog.config.ts
const config = {
  title: 'My Blog',
  url: 'https://myblog.vercel.app',
  author: { name: 'Your Name', ... },
  giscus: { repo: 'user/repo', ... },
  navigation: [{ href: '/article/list/1', name: 'articles', description: 'all posts' }],
}
```

One file. Type-safe. No environment variables needed.

## How It Works

```
Obsidian (write) → Git push → Vercel (auto-build) → Static site
```

1. **Write** — Create `.md` files in `blog/📝 posts/` with YAML frontmatter
2. **Push** — Use Obsidian Git plugin or `git push` from terminal
3. **Build** — Vercel detects the push and runs `next build`
4. **Serve** — Next.js reads markdown via `fs`, generates static HTML with Shiki + KaTeX

Images pasted in Obsidian are auto-saved to `public/images/` and path-transformed at build time.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first.

## License

MIT License - see [LICENSE](LICENSE) for details.
