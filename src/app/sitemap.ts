import { MetadataRoute } from 'next';

import { getPosts } from '@/api/notion';
import SITE_CONFIG from '@/config/siteConfig';
import { POSTS_PER_PAGE } from '@/constants';

const DEFAULT_PATH = ['', 'gallery'] as const;

export default async function sitemap(): Promise<MetadataRoute.Sitemap> {
  const posts = await getPosts();
  const totalPageCount = Math.ceil(posts.length / POSTS_PER_PAGE);

  const defaultSitemap: MetadataRoute.Sitemap = DEFAULT_PATH.map((slug) => ({
    url: `${SITE_CONFIG.siteUrl}/${slug}`,
    lastModified: new Date(),
    changeFrequency: 'weekly',
    priority: 1,
  }));

  const pageSitemap: MetadataRoute.Sitemap = Array.from(
    { length: totalPageCount },
    (_, index) => ({
      url: `${SITE_CONFIG.siteUrl}/article/list/${index + 1}`,
      lastModified: new Date(),
      changeFrequency: 'weekly',
      priority: 0.8,
    }),
  );

  const postSitemap: MetadataRoute.Sitemap = posts.map(({ slug, date }) => ({
    url: `${SITE_CONFIG.siteUrl}/article/${slug}`,
    lastModified: new Date(date),
    changeFrequency: 'weekly',
    priority: 1,
  }));

  return [...defaultSitemap, ...pageSitemap, ...postSitemap];
}
