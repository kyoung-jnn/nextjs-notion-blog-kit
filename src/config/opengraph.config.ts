import { OpenGraph } from 'next/dist/lib/metadata/types/opengraph-types';

import blogConfig from '@/config/blog.config';

export const OPEN_GRAPH_CONFIG: OpenGraph = {
  siteName: blogConfig.title,
  title: blogConfig.title,
  description: blogConfig.description,
  images: blogConfig.siteBanner,
  url: blogConfig.siteUrl,
  locale: blogConfig.locale,
  type: 'website',
};
