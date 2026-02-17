import { Metadata } from 'next';

import { OPEN_GRAPH_CONFIG } from '@/config';

import HomeArticleCardList from './components/HomeArticleCardList';
import Menu from './components/Menu';
import Profile from './components/Profile';

export const metadata: Metadata = {
  alternates: { canonical: '/' },
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
