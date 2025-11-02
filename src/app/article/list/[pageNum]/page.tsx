import { Metadata } from 'next';
import { notFound } from 'next/navigation';

import { getPosts } from '@/api/notion';
import ArticleCardList from '@/components/ArticleCardList';
import Pagination from '@/components/Pagination';
import Sidebar from '@/components/Sidebar';
import {
  METADATA,
  METADATA_TWITTER,
  OPEN_GRAPH,
} from '@/config/metadataConfig';
import SITE_CONFIG from '@/config/siteConfig';
import { POSTS_PER_PAGE } from '@/constants';

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
      url: `${SITE_CONFIG.siteUrl}/article/list/${pageNum}`,
    },
    twitter: { ...METADATA_TWITTER },
  };
}

export async function generateStaticParams() {
  const posts = await getPosts();

  const totalPages = Math.ceil(posts.length / POSTS_PER_PAGE);
  const paths = Array.from({ length: totalPages }, (_, index) => ({
    pageNum: (index + 1).toString(),
  }));

  return paths.length > 0 ? paths : [{ pageNum: '1' }];
}

export default async function PostListPage({
  params,
}: {
  params: Promise<Params>;
}) {
  const { pageNum } = await params;
  const allPosts = await getPosts();

  const totalPage = Math.ceil(allPosts.length / POSTS_PER_PAGE);
  const currentPage = parseInt(pageNum);

  if (isNaN(currentPage) || currentPage <= 0 || currentPage > totalPage) {
    notFound();
  }

  const pagePosts = allPosts.slice(
    POSTS_PER_PAGE * (currentPage - 1),
    POSTS_PER_PAGE * currentPage,
  );

  return (
    <div className="tablet:grid tablet:grid-cols-[180px_664px_180px] tablet:items-start tablet:justify-center relative mt-[60px] flex flex-col gap-2.5">
      <Sidebar />
      <div className="tablet:col-start-2 tablet:col-end-3">
        <h1 className="m-0 px-3 text-2xl font-bold">Articles</h1>
        <ArticleCardList posts={pagePosts} />
      </div>
      <Pagination totalPage={totalPage} currentPage={currentPage} />
    </div>
  );
}
