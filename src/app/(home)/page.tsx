import { Metadata } from 'next';

import { METADATA_CONFIG } from '@/config/metadataConfig';
import { OPEN_GRAPH_CONFIG } from '@/config/openGraphConfig';
import SITE_CONFIG from '@/config/siteConfig';

import HomeArticleCardList from './components/HomeArticleCardList';
import Menu from './components/Menu';
import Profile from './components/Profile';

export const metadata: Metadata = {
  ...METADATA_CONFIG,
  title: `Home • ${SITE_CONFIG.author.enName}`,
  openGraph: OPEN_GRAPH_CONFIG,
};

export default function HomePage() {
  return (
    <>
      <Profile />
      <Menu />
      <HomeArticleCardList />
    </>
  );
}
