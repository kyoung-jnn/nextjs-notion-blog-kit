import { Metadata } from 'next';
import { Twitter } from 'next/dist/lib/metadata/types/twitter-types';

import SITE_CONFIG from '@/config/siteConfig';

export const METADATA_CONFIG: Metadata = {
  robots: { index: true, follow: true },
  title: SITE_CONFIG.title,
  description: SITE_CONFIG.description,
  applicationName: SITE_CONFIG.title,
  keywords: SITE_CONFIG.keywords,
  publisher: SITE_CONFIG.author.localeName,
  creator: SITE_CONFIG.author.localeName,
  authors: [{ name: SITE_CONFIG.author.localeName, url: SITE_CONFIG.siteUrl }],
  category: 'technology',
};

export const METADATA_TWITTER_CONFIG: Twitter = {
  card: 'summary_large_image',
  site: SITE_CONFIG.title,
  creator: SITE_CONFIG.author.localeName,
};
