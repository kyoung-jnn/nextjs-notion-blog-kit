![nextjs notion blog kit](https://github.com/user-attachments/assets/dbfdd093-6637-4fa2-b4ea-9201ad8c2c49)

# Next.js Notion Blog Kit

[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Next.js](https://img.shields.io/badge/Next.js-16.0-black)](https://nextjs.org/)
[![React](https://img.shields.io/badge/React-19.2-61DAFB)](https://reactjs.org/)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.8-3178C6)](https://www.typescriptlang.org/)

English | [한국어](README.ko.md)

> 🔲 Write in Notion. Customize everything. Deploy in minutes.

Focus on writing. Manage with Notion. Build and serve your own blog. Experience the joy of owning something truly yours.

## ✨ Features

- 📝 **Notion as CMS** - Write in Notion, publish instantly. No need to learn a new CMS
- 🎨 **Beautiful UI** - Clean, responsive design that looks great on all devices
- 🌓 **Dark Mode** - Automatic theme switching with system preference support
- 🔍 **SEO Optimized** - Automatic sitemap, RSS feed, and structured data (JSON-LD)
- ⚡ **Fast Performance** - Static generation with ISR for optimal loading speed
- 💬 **Comments** - Built-in Giscus integration for GitHub-based comments
- 📊 **Analytics Ready** - Vercel Analytics support out of the box
- 🎯 **TypeScript** - Fully typed for better developer experience
- 🎨 **Tailwind CSS 4** - Latest Tailwind for rapid styling
- 🚀 **Next.js 16 App Router** - Leveraging the latest Next.js features with React Server Components

## 🚀 Get Started

Ready to launch your blog in minutes? Follow these simple steps:

### Step 1: Create Your Notion CMS 📝

First, set up your content management system in Notion:

1. **Visit the template**: [Notion Blog Template](https://kyoung-jnn.notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=1f4d55b8837781328546000cc33d2d96)
2. **Duplicate it**: Click **"Duplicate"** in the top-right corner
3. **Make it public**:
   - Click **"Share"** in the top-right
   - Toggle **"Share to web"** ON
4. **Save your Page ID**:
   - Copy the URL from browser address bar (⌘+L on Mac, Ctrl+L on Windows)
   - Example URL: `https://notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=...`
   - Your Page ID is the part before `?v=`: `1f4d55b8837780519a27c4f1f7e4b1a9`

> 💡 Keep this Page ID handy—you'll need it in Step 3!

### Step 2: Use This Template 🎨

Create your own repository from this template:

1. Click the **"Use this template"** button at the top of this page
2. Choose a repository name (e.g., `my-awesome-blog`)
3. Select public or private
4. Click **"Create repository"**

### Step 3: Run the Setup CLI 🔲

Clone your new repository and run our magical setup script:

```bash
# Clone your repository
git clone https://github.com/yourusername/your-blog-repo.git
cd your-blog-repo

# Run the setup wizard 🧙‍♂️
pnpm setup
```

The setup wizard will:

- ✅ Configure your environment variables (including your Notion Page ID)
- ✅ Set up your site configuration (blog title, author name, site URL)
- ✅ Install all dependencies
- ✅ Connect to your Vercel account
- ✅ Push environment variables to Vercel

Just follow the prompts and answer a few questions!

### Step 4: Deploy! 🚀

After the setup completes, you're ready to go live:

```bash
pnpm deploy:prod
```

That's it! Your blog is now live on Vercel. 🔲🎉

---

### Want to customize first?

Before deploying, you might want to personalize your blog:

**Edit `src/config/siteConfig.ts`**:

```typescript
const SITE_CONFIG = {
  title: 'Your Blog Title',
  description: 'Your blog description',
  siteUrl: 'https://yourdomain.com',
  author: {
    localeName: 'Your Name',
    bio: 'A brief introduction about yourself',
    contacts: {
      email: 'your-email@example.com',
      github: 'https://github.com/yourusername',
    },
  },
};
```

**Test locally**:

```bash
pnpm dev
```

Open [http://localhost:3000](http://localhost:3000) to preview your blog!

## 📊 Notion Database Schema

Your Notion database should have the following properties:

| Property      | Type         | Required | Description                                                      |
| ------------- | ------------ | -------- | ---------------------------------------------------------------- |
| **title**     | Title        | ✅       | Post title                                                       |
| **slug**      | Text         | ✅       | URL slug (auto-formatted to lowercase with hyphens)              |
| **date**      | Date         | ✅       | Publication date                                                 |
| **status**    | Select       | ✅       | `publish` or `draft` (only published posts appear in production) |
| **summary**   | Text         | ✅       | Short description for SEO and preview                            |
| **thumbnail** | Files        | ❌       | Featured image                                                   |
| **tags**      | Multi-select | ❌       | Post categories/tags                                             |

> **Note**: The slug field automatically converts spaces to hyphens and converts to lowercase.

## 🎨 Customization

### Theme & Styling

- **Colors**: Edit CSS variables in `src/styles/global.css`
- **Components**: All React components are in `src/components/`
- **Layouts**: Modify page layouts in `src/app/`

### Comments (Giscus)

To enable comments, update `src/config/giscusConfig.ts`:

```typescript
export const GISCUS_CONFIG = {
  repo: 'yourusername/your-repo',
  repoId: 'your_repo_id',
  category: 'General',
  categoryId: 'your_category_id',
};
```

Get your IDs from [Giscus](https://giscus.app/).

### Analytics

To enable Vercel Analytics, add to `src/app/layout.tsx`:

```tsx
import { Analytics } from '@vercel/analytics/react';

// In your layout component:
<Analytics />;
```

## 🚢 Deployment

### Option 1: Deploy with CLI (Recommended)

The deploy script automatically checks your project status before deploying:

```bash
# Production deployment
pnpm deploy:prod

# Preview deployment
pnpm deploy:preview
```

The deploy script will:

- Check that `.env` and `NOTION_PAGE` are configured
- Verify `siteUrl` is set (warns if empty)
- Ensure dependencies are installed
- Warn about uncommitted git changes
- Build the project
- Deploy to Vercel

> **Note**: Vercel CLI is not required to be installed globally. The script automatically falls back to `npx vercel` if the global CLI is not found.

### Option 2: Deploy via Vercel Dashboard

1. Push your code to GitHub
2. Import your repository on [Vercel](https://vercel.com)
3. Add environment variables:
   - `NOTION_PAGE`: Your Notion page ID
   - `TOKEN_FOR_REVALIDATE`: (Optional) Secret token for on-demand revalidation
4. Deploy!

### On-Demand Revalidation

After deploying, you can revalidate your blog content by sending a POST request:

```bash
curl -X POST "https://yourdomain.com/article/api?token=YOUR_TOKEN_FOR_REVALIDATE"
```

This will fetch the latest content from Notion without redeploying.

> **Note**: The revalidation endpoint only accepts `POST` requests. The `token` parameter must match your `TOKEN_FOR_REVALIDATE` environment variable.

## 📁 Project Structure

```
nextjs-notion-blog-kit/
├── src/
│   ├── api/                    # Notion API integration
│   │   └── notion.ts          # Fetch posts and pages from Notion
│   ├── app/                   # Next.js App Router
│   │   ├── (home)/           # Home page with article list
│   │   ├── article/          # Article detail pages
│   │   │   ├── [slug]/       # Dynamic article routes
│   │   │   └── api/          # Revalidation API route
│   │   ├── gallery/          # Gallery page
│   │   ├── layout.tsx        # Root layout
│   │   └── sitemap.ts        # Auto-generated sitemap
│   ├── components/           # Reusable React components
│   │   ├── ArticleCard/     # Article preview cards
│   │   ├── Header/          # Site header & navigation
│   │   ├── NotionRender/    # Notion content renderer
│   │   └── ...
│   ├── config/              # Configuration files
│   │   ├── siteConfig.ts   # Main site configuration
│   │   ├── giscusConfig.ts # Comments configuration
│   │   └── ...
│   ├── constants/           # App constants
│   ├── styles/             # Global styles
│   ├── types/              # TypeScript type definitions
│   └── utils/              # Utility functions
├── public/                 # Static assets
├── .env.example           # Environment variables template
├── next.config.mjs        # Next.js configuration
├── tailwind.config.ts     # Tailwind CSS configuration
└── tsconfig.json          # TypeScript configuration
```

## 🛠 Tech Stack

- **Framework**: [Next.js 16](https://nextjs.org/) (App Router)
- **UI Library**: [React 19](https://react.dev/)
- **Language**: [TypeScript 5](https://www.typescriptlang.org/)
- **Styling**: [Tailwind CSS 4](https://tailwindcss.com/)
- **CMS**: [Notion API](https://developers.notion.com/)
- **Notion Renderer**: [react-notion-x](https://github.com/NotionX/react-notion-x)
- **Comments**: [Giscus](https://giscus.app/)
- **Deployment**: [Vercel](https://vercel.com/)

## 🐛 Troubleshooting

### Posts not showing up?

1. Make sure your Notion database is **shared to web**
2. Check that your `NOTION_PAGE` environment variable is correct
3. Verify that posts have `status: publish` in production
4. Check the browser console for errors

### Slug contains spaces?

The slug field is automatically formatted to be URL-friendly:

- Spaces are converted to hyphens
- Text is converted to lowercase

### Images not loading?

Add your image domains to `next.config.mjs`:

```javascript
images: {
  domains: ['your-image-domain.com'],
}
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

This project was inspired by and built with:

- [react-notion-x](https://github.com/NotionX/react-notion-x) - Notion renderer
- [Next.js](https://nextjs.org/) - The React framework
- [Vercel](https://vercel.com/) - Deployment platform
