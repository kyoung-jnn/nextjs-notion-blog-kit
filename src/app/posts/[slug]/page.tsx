import { Metadata } from 'next';
import { notFound } from 'next/navigation';

import { getPost, getPosts } from '@/api/notion';
import PostLayout from '@/app/posts/[slug]/components/PostLayout';
import NotionRenderer from '@/components/NotionRender';
import {
  METADATA,
  OPEN_GRAPH,
  METADATA_TWITTER,
} from '@/config/metadataConfig';
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

  const url = `${SITE_CONFIG.siteUrl}/posts/${currentSlug}`;
  const { title, date, thumbnail, summary } = post;

  return {
    ...METADATA,
    title,
    description: summary,
    openGraph: {
      ...OPEN_GRAPH,
      url,
      title,
      description: summary,
      publishedTime: date,
      modifiedTime: date,
      type: 'article',
      ...(thumbnail && { images: thumbnail }),
    },
    twitter: {
      ...METADATA_TWITTER,
      title,
      description: summary,
      ...(thumbnail && { images: [thumbnail] }),
    },
  };
}

export async function generateStaticParams() {
  const posts = await getPosts();
  const slugs = posts.filter(({ slug }) => {
    slug;
  });

  return slugs;
}

export default async function PostDetailPage(props: {
  params: Promise<Params>;
}) {
  const params = await props.params;
  const currentSlug = params.slug;
  const posts = await getPosts();
  const post = posts?.find(({ slug }) => slug === currentSlug);

  if (!post) notFound();

  const { id, title, summary, date, thumbnail } = post;
  const recordMap = await getPost(id);

  return (
    <>
      <JsonLD
        slug={currentSlug}
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
