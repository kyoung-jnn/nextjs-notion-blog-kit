import { readFileSync } from 'fs';

// Warn if siteUrl is empty (affects SEO, sitemap, RSS)
try {
  const configContent = readFileSync('./src/config/blog.config.ts', 'utf-8');
  if (/siteUrl:\s*['"](['"])/m.test(configContent)) {
    console.warn(
      '\x1b[33m⚠ blog.config.ts: siteUrl is empty — sitemap, RSS, and SEO metadata will be incomplete.\x1b[0m',
    );
  }
} catch {
  // blog.config.ts may not exist yet (before setup)
}

/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'avatars.githubusercontent.com',
      },
    ],
  },
  turbopack: {
    rules: {
      '*.svg': {
        as: '*.js',
        loaders: ['@svgr/webpack'],
      },
    },
  },
};

export default nextConfig;
