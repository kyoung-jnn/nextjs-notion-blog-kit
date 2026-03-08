const env = (key: string, fallback: string = ''): string => process.env[key] ?? fallback;

/**
 * site configuration
 *
 * All values are read from NEXT_PUBLIC_* environment variables.
 * Edit `.env` (or Vercel Dashboard) to customize — no code changes needed.
 */
const SITE_CONFIG = {
  title: env('NEXT_PUBLIC_SITE_TITLE', 'blog title'),
  description: env('NEXT_PUBLIC_SITE_DESCRIPTION', 'blog description'),
  locale: env('NEXT_PUBLIC_SITE_LOCALE', 'ko'),
  siteUrl: env('NEXT_PUBLIC_SITE_URL'),
  siteLogo: env('NEXT_PUBLIC_SITE_LOGO'),
  siteBanner: env('NEXT_PUBLIC_SITE_BANNER'),
  author: {
    localeName: env('NEXT_PUBLIC_AUTHOR_LOCALE_NAME', 'Author Locale Name'),
    enName: env('NEXT_PUBLIC_AUTHOR_EN_NAME', 'Author En Name'),
    bio: env('NEXT_PUBLIC_AUTHOR_BIO', 'Write a brief introduction about yourself'),
    contacts: {
      email: env('NEXT_PUBLIC_AUTHOR_EMAIL', 'your-email@example.com'),
      github: env('NEXT_PUBLIC_AUTHOR_GITHUB', 'https://github.com/your-username'),
      rss: env('NEXT_PUBLIC_AUTHOR_RSS'),
      linkedin: env('NEXT_PUBLIC_AUTHOR_LINKEDIN'),
      twitter: env('NEXT_PUBLIC_AUTHOR_TWITTER'),
    },
  },
};

export default SITE_CONFIG;
