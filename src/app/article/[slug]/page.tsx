import { Metadata } from 'next';
import { notFound } from 'next/navigation';

import { getPost, getPosts } from '@/api/notion';
import PostLayout from '@/app/article/[slug]/components/PostLayout';
import NotionRenderer from '@/components/NotionRender';
import {
  METADATA_CONFIG,
  METADATA_TWITTER_CONFIG,
} from '@/config/metadataConfig';
import { OPEN_GRAPH_CONFIG } from '@/config/openGraphConfig';
import SITE_CONFIG from '@/config/siteConfig';

import JsonLD from './components/JsonLD';

type Params = { slug: string };

export async function generateMetadata(props: {
  params: Promise<Params>;
}): Promise<Metadata> {
  const params = await props.params;
  const currentSlug = params.slug;
  const posts = await getPosts();
  const post = posts?.find(({ slug }) => slug === currentSlug);

  if (!post) return {};

  const url = `${SITE_CONFIG.siteUrl}/article/${currentSlug}`;
  const { title, date, thumbnail, summary } = post;

  return {
    ...METADATA_CONFIG,
    title,
    description: summary,
    openGraph: {
      ...OPEN_GRAPH_CONFIG,
      url,
      title,
      description: summary,
      publishedTime: date,
      modifiedTime: date,
      type: 'article',
      ...(thumbnail && { images: thumbnail }),
    },
    twitter: {
      ...METADATA_TWITTER_CONFIG,
      title,
      description: summary,
      ...(thumbnail && { images: [thumbnail] }),
    },
  };
}

export async function generateStaticParams() {
  const posts = await getPosts();
  return posts.map(({ slug }) => ({ slug }));
}

export default async function PostDetailPage({
  params,
}: {
  params: Promise<Params>;
}) {
  const { slug } = await params;
  const posts = await getPosts();
  const post = posts?.find(({ slug: postSlug }) => postSlug === slug);

  if (!post) notFound();

  const { id, title, summary, date, thumbnail } = post;
  const recordMap = await getPost(id);

  return (
    <>
      <JsonLD
        slug={slug}
        title={title}
        description={summary}
        date={date}
        updatedAt={date}
        {...(thumbnail && { image: thumbnail })}
      />
      <PostLayout title={title} date={date} thumbnail={thumbnail}>
        <NotionRenderer recordMap={recordMap} />
      </PostLayout>
    </>
  );
}
