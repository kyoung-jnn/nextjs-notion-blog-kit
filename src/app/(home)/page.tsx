import { Metadata } from 'next';

import { METADATA, OPEN_GRAPH } from '@/config/metadataConfig';
import SITE_CONFIG from '@/config/siteConfig';

import HomeArticleCardList from './components/HomeArticleCardList';
import Menu from './components/Menu';
import Profile from './components/Profile';

export const metadata: Metadata = {
  ...METADATA,
  title: `Home • ${SITE_CONFIG.author.enName}`,
  openGraph: OPEN_GRAPH,
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
