import { Metadata } from 'next';
import { notFound } from 'next/navigation';

import ArticleCardList from '@/components/ArticleCardList';
import Pagination from '@/components/Pagination';
import Sidebar from '@/components/Sidebar';
import { METADATA_CONFIG, METADATA_TWITTER_CONFIG, OPEN_GRAPH_CONFIG, SITE_CONFIG } from '@/config';
import { POSTS_PER_PAGE } from '@/constants';
import { getAllPosts } from '@/lib/content';

type Params = { pageNum: string };

export async function generateMetadata(props: { params: Promise<Params> }): Promise<Metadata> {
  const params = await props.params;
  const { pageNum } = params;

  return {
    ...METADATA_CONFIG,
    title: 'Articles',
    alternates: { canonical: `/article/list/${pageNum}` },
    openGraph: {
      ...OPEN_GRAPH_CONFIG,
      url: `${SITE_CONFIG.siteUrl}/article/list/${pageNum}`,
    },
    twitter: { ...METADATA_TWITTER_CONFIG },
  };
}

export async function generateStaticParams() {
  const posts = await getAllPosts();

  const totalPages = Math.ceil(posts.length / POSTS_PER_PAGE);
  const paths = Array.from({ length: totalPages }, (_, index) => ({
    pageNum: (index + 1).toString(),
  }));

  return paths.length > 0 ? paths : [{ pageNum: '1' }];
}

export default async function PostListPage({ params }: { params: Promise<Params> }) {
  const { pageNum } = await params;
  const allPosts = await getAllPosts();

  const totalPage = Math.ceil(allPosts.length / POSTS_PER_PAGE);
  const currentPage = parseInt(pageNum);

  if (allPosts.length === 0) {
    return (
      <div className="desktop:grid desktop:grid-cols-[180px_664px_180px] desktop:items-start desktop:justify-center desktop:max-w-none relative mx-auto mt-[60px] flex w-full max-w-[664px] flex-col gap-2.5">
        <Sidebar />
        <div className="desktop:col-start-2 desktop:col-end-3">
          <h1 className="m-0 animate-[fade-up_0.6s_forwards] p-3 text-2xl font-bold opacity-0">
            Articles
          </h1>
          <div className="animate-[fade-left_0.8s_0.2s_forwards] opacity-0">
            <ArticleCardList posts={[]} />
          </div>
        </div>
      </div>
    );
  }

  if (isNaN(currentPage) || currentPage <= 0 || currentPage > totalPage) {
    notFound();
  }

  const pagePosts = allPosts.slice(
    POSTS_PER_PAGE * (currentPage - 1),
    POSTS_PER_PAGE * currentPage,
  );

  return (
    <div className="desktop:grid desktop:grid-cols-[180px_664px_180px] desktop:items-start desktop:justify-center desktop:max-w-none desktop:px-0 relative mx-auto mt-[60px] flex w-full max-w-[664px] flex-col gap-2.5">
      <Sidebar />
      <div className="desktop:col-start-2 desktop:col-end-3">
        <h1 className="m-0 animate-[fade-up_0.6s_forwards] p-3 text-2xl font-bold opacity-0">
          Articles
        </h1>
        <div className="animate-[fade-left_0.8s_0.2s_forwards] opacity-0">
          <ArticleCardList posts={pagePosts} />
        </div>
      </div>
      <Pagination totalPage={totalPage} currentPage={currentPage} />
    </div>
  );
}
