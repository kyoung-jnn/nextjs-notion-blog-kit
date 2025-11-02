import { OpenGraph } from 'next/dist/lib/metadata/types/opengraph-types';

import SITE_CONFIG from '@/config/siteConfig';

export const OPEN_GRAPH_CONFIG: OpenGraph = {
  siteName: SITE_CONFIG.title,
  title: SITE_CONFIG.title,
  description: SITE_CONFIG.description,
  images: SITE_CONFIG.siteBanner,
  url: SITE_CONFIG.siteUrl,
  locale: SITE_CONFIG.locale,
  type: 'website',
};
