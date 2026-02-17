import RSS from 'rss';

import { getPost, getPosts } from '@/api/notion';
import { SITE_CONFIG } from '@/config';
import { extractDescription } from '@/utils';

export const dynamic = 'force-dynamic';

export async function GET() {
  const posts = await getPosts();

  const feed = new RSS({
    title: SITE_CONFIG.title,
    description: SITE_CONFIG.description,
    feed_url: `${SITE_CONFIG.siteUrl}/rss.xml`,
    site_url: SITE_CONFIG.siteUrl,
    image_url: `${SITE_CONFIG.siteBanner}`,
    language: SITE_CONFIG.locale,
    categories: ['Technologies'],
    copyright: `All rights reserved ${new Date().getFullYear()} ${SITE_CONFIG.author.localeName}`,
    generator: 'nextjs-notion-blog-rss-generate',
    pubDate: new Date(),
  });

  const postDescriptions = await Promise.all(
    posts.map(async (post) => {
      const recordMap = await getPost(post.id);
      return extractDescription(recordMap) || post.title;
    }),
  );

  posts.forEach((post, index) => {
    feed.item({
      title: post.title,
      description: postDescriptions[index],
      url: `${SITE_CONFIG.siteUrl}/article/${post.slug}`,
      author: SITE_CONFIG.author.localeName,
      date: new Date(post.date),
    });
  });

  const rss = feed.xml({ indent: true });

  return new Response(rss, {
    headers: { 'Content-Type': 'application/rss+xml; charset=utf-8;' },
  });
}
