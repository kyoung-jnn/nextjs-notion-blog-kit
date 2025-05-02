![nextjs notion blog kit](https://github.com/user-attachments/assets/7809ed89-91c7-42b2-946d-a7781ebd8389)

# Nextjs Notion Blog Kit

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

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/yourusername/nextjs-notion-blog-kit.git
   cd nextjs-notion-blog-kit
   ```

2. Install dependencies:

   ```bash
   pnpm install
   ```

3. Set up environment variables:
   Create a `.env` file in the root directory and add the following:

   ```
   NOTION_PAGE=your_notion_page_id
   ```

4. Run the development server:
   ```bash
   pnpm dev
   ```

## Notion Setup

### Integration Configuration

1. Create a new page in Notion and set up a database.
2. Add the following properties to the database:

   - `title`: Post title
   - `slug`: URL slug
   - `date`: Publication date
   - `summary`: Summary
   - `thumbnail`: Thumbnail image URL
   - `status`: Publication status (publish, draft)

3. Set the database ID in the environment variables.

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
- [Vanilla Extract CSS](https://vanilla-extract.style/)

## License

MIT © [kyoung-jnn](https://github.com/kyoung-jnn)

## References and Acknowledgements

This project was inspired by the following open source projects:

- [react-notion-x](https://github.com/NotionX/react-notion-x)
