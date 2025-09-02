![nextjs notion blog kit](https://github.com/user-attachments/assets/dbfdd093-6637-4fa2-b4ea-9201ad8c2c49)

# Nextjs Notion Blog Kit · ![mit](https://img.shields.io/badge/license-MIT-FF0000)

English | [한국어](README.ko.md)

A blog kit utilizing Next.js and Notion API. This simple blog solution uses Notion as a CMS to manage content and serves it with Next.js and Vercel.

## Key Features

- 🚀 **Next.js App Router** based design
- 📝 **Notion** as CMS (Content Management System)
- 🔍 **SEO** optimization (metadata, sitemap, RSS feed)
- 🎨 **Responsive design** support
- 🌓 **Dark mode** support
- 💬 **Comment system** (Giscus) integration
- 📊 **Vercel Analytics** support
- 📱 **Mobile-friendly** interface

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (18.x or higher)
- [pnpm](https://pnpm.io/) (10.x or higher)
- Notion account and integration setup

### Notion Setup

1. Visit the Notion blog template page: [Nextjs Notion Blog Kit Template](https://kyoung-jnn.notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=1f4d55b8837781328546000cc33d2d96)
2. Click the "Duplicate" button in the top-right corner to copy the template to your own Notion workspace.
3. Once duplicated, get your Notion page ID from the URL:
   - Look at the URL of your duplicated page.
   - The page ID is the string before the "?v=" part.
   - Example: In `https://your-workspace.notion.site/1f4d55b8837780519a27c4f1f7e4b1a9?v=1f4d55b8837781328546000cc33d2d96`, the page ID is `1f4d55b8837780519a27c4f1f7e4b1a9`.
4. Set this page ID as the `NOTION_PAGE` environment variable in your `.env` file.

### Installation

1. Fork the repository:

   - Visit the [GitHub repository](https://github.com/kyoung-jnn/nextjs-notion-blog-kit)
   - Click the "Fork" button in the top-right corner
   - This will create a copy of the repository in your GitHub account

2. Clone your forked repository:

   ```bash
   git clone https://github.com/yourusername/nextjs-notion-blog-kit.git
   cd nextjs-notion-blog-kit
   ```

3. Install dependencies:

   ```bash
   pnpm install
   ```

4. Set up environment variables:
   Create a `.env` file in the root directory and add the following:

   ```
   NOTION_PAGE=your_notion_page_id
   ```

5. Run the development server:
   ```bash
   pnpm dev
   ```

## Deployment

### Deploy to Vercel

[![Deploy with Vercel](https://vercel.com/button)](https://vercel.com/new/clone?repository-url=https%3A%2F%2Fgithub.com%2Fyourusername%2Fnextjs-notion-blog-kit)

1. Click the button above or create a new project in the Vercel dashboard.
2. Connect your GitHub repository.
3. Set the environment variable `NOTION_PAGE`.
4. Deploy!

## Customization

### Modify Site Configuration

Edit the `database/config.ts` file to change site title, description, author information, etc.:

```typescript
const SITE_CONFIG = {
  title: 'Your Blog Name',
  description: 'Blog description',
  author: {
    name: 'Your Name',
    // ...other information
  },
  // ...other configurations
};
```

### Customize Design

Styles are managed in the `styles` directory. You can customize styles using Vanilla Extract CSS.

## Structure

```
nextjs-notion-blog-kit/
├── app/                  # Next.js App Router
│   ├── (home)/           # Homepage
│   ├── posts/            # Blog posts
│   └── ...
├── components/           # React components
├── database/             # Site configuration and metadata
├── api/                  # Notion API integration
├── styles/               # Style definitions
├── types/                # TypeScript type definitions
└── ...
```

## Tech Stack

- [Next.js](https://nextjs.org/) (14.x)
- [React](https://reactjs.org/) (18.x)
- [TypeScript](https://www.typescriptlang.org/)
- [notion-client](https://github.com/NotionX/react-notion-x)

## License

MIT © [kyoung-jnn](https://github.com/kyoung-jnn)

## References and Acknowledgements

This project was inspired by the following open source projects:

- [react-notion-x](https://github.com/NotionX/react-notion-x)
