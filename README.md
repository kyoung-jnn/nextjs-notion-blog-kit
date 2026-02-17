![nextjs notion blog kit](https://github.com/user-attachments/assets/dbfdd093-6637-4fa2-b4ea-9201ad8c2c49)

# Next.js Notion Blog Kit

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Next.js](https://img.shields.io/badge/Next.js-16.0-black)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19.2-61DAFB)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-3178C6)](https://www.typescriptlang.org/)

English | [한국어](README.ko.md)

> Write in Notion. Customize everything. Deploy in minutes.

## Features

- **Notion as CMS** — Write and manage posts directly in Notion
- **Zero-Config Deploy** — One command to setup, one command to deploy
- **Performance Optimized** — Static generation, code splitting, and image optimization
- **Full SEO** — Sitemap, RSS feed, JSON-LD structured data, and Open Graph
- **Light/Dark Mode** — Radix Colors based theme across content and comments

## Get Started

### 1. Create Your Notion CMS

1. Open the [Notion Blog Database Template](https://kyoung-jnn.notion.site/256d55b883778070ab14e9ca4b56f037)
2. Click **"Duplicate"** to copy the database to your workspace
3. Click **"Share"** → Toggle **"Share to web"** ON
4. Copy the Page ID from the URL (the string before `?v=`)

> **Tip:** Press `⌘+L` (Mac) or `Ctrl+L` (Windows) to quickly select the URL.
>
> **Example URL:** `https://notion.site/256d55b883778070ab14e9ca4b56f037?v=...` → Page ID: `256d55b883778070ab14e9ca4b56f037`

### 2. Use This Template

Click **"Use this template"** at the top of this repo to create your own repository.

### 3. Run the Setup Wizard

```bash
git clone https://github.com/yourusername/your-blog-repo.git
cd your-blog-repo
pnpm blog:setup
```

The wizard configures environment variables, site settings, comments, and Vercel linking.

### 4. Deploy

```bash
pnpm blog:deploy
```

### 5. Set Up Revalidate Button

In your Notion Blog Template, click the **Revalidate** button → Edit URL → Set it to:

```
https://yourdomain.com/article/api?token=YOUR_TOKEN
```

Now you can update your blog directly from Notion — write a post, then click the button.

## Scripts

| Command                    | Description              |
| -------------------------- | ------------------------ |
| `pnpm dev`                 | Start development server |
| `pnpm build`               | Production build         |
| `pnpm blog:setup`          | Interactive setup wizard |
| `pnpm blog:deploy`         | Deploy to production     |
| `pnpm blog:deploy:preview` | Preview deployment       |

## Configuration

| File                          | Purpose                                                               |
| ----------------------------- | --------------------------------------------------------------------- |
| `.env`                        | `NOTION_PAGE` (required), `TOKEN_FOR_REVALIDATE` (optional)           |
| `src/config/siteConfig.ts`    | Title, author, URL, social links                                      |
| `src/config/commentConfig.ts` | Giscus comment IDs ([giscus.app](https://giscus.app/))                |
| `src/styles/global.css`       | Theme colors ([Radix UI Gray](https://www.radix-ui.com/colors) scale) |

## Notion Database Schema

| Property      | Type         | Required | Description          |
| ------------- | ------------ | -------- | -------------------- |
| **title**     | Title        | Yes      | Post title           |
| **slug**      | Text         | No       | Custom URL slug (auto-generated from title if empty) |
| **date**      | Date         | Yes      | Publication date     |
| **status**    | Select       | Yes      | `publish` or `draft` |
| **thumbnail** | Files        | No       | Featured image       |
| **tags**      | Multi-select | No       | Post categories/tags |

## Deployment

**CLI (Recommended):**

```bash
pnpm blog:deploy          # Production
pnpm blog:deploy:preview  # Preview
```

**Vercel Dashboard:** Push to GitHub → Import on [Vercel](https://vercel.com) → Add env variables → Deploy

**On-Demand Revalidation:** Click the **Revalidate** button in your Notion Dashboard, or:

```bash
curl "https://yourdomain.com/article/api?token=YOUR_TOKEN"
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
