import React from 'react';

import { Metadata } from 'next';

import { getPosts } from '@/api/notion';
import ArticleCardList from '@/components/ArticleCardList';
import Pagination from '@/components/Pagination';
import Sidebar from '@/components/Sidebar';
import {
  METADATA,
  OPEN_GRAPH,
  METADATA_TWITTER,
} from '@/config/metadataConfig';
import SITE_CONFIG from '@/config/siteConfig';


import * as styles from './page.css';

export const POSTS_PER_PAGE = 8;

type Params = { pageNum: string };

export async function generateMetadata(props: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const params = await props.params;

  const { pageNum } = params;

  return {
    ...METADATA,
    title: `Articles | ${SITE_CONFIG.author.enName}`,
    openGraph: {
      ...OPEN_GRAPH,
      url: `${SITE_CONFIG.siteUrl}/posts/page/${pageNum}`,
    },
    twitter: { ...METADATA_TWITTER },
  };
}

export async function generateStaticParams() {
  const posts = await getPosts();

  const totalPages = Math.ceil(posts.length / POSTS_PER_PAGE);
  const paths = Array.from({ length: totalPages }, (_, index) => ({
    page: (index + 1).toString(),
  }));

  return paths;
}

export default async function PostListPage(props: { params: Promise<Params> }) {
  const params = await props.params;

  const { pageNum } = params;

  const allPosts = await getPosts();

  const totalPage = Math.ceil(allPosts.length / POSTS_PER_PAGE);
  const currentPage = parseInt(pageNum);

  if (isNaN(currentPage) || currentPage <= 0 || currentPage > totalPage) {
    return { notFound: true };
  }

  const pagePosts = allPosts.slice(
    POSTS_PER_PAGE * (currentPage - 1),
    POSTS_PER_PAGE * currentPage,
  );

  return (
    <div className={styles.wrapper}>
      <Sidebar />
      <div className={styles.content}>
        <h1 className={styles.title}>Articles</h1>
        <ArticleCardList posts={pagePosts} />
      </div>
      <Pagination totalPage={totalPage} currentPage={currentPage} />
    </div>
  );
}
