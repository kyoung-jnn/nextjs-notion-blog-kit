import { Metadata } from 'next';
import { notFound } from 'next/navigation';

import { getPost, getPosts } from '@/api/notion';
import PostLayout from '@/app/article/[slug]/components/PostLayout';
import NotionRenderer from '@/components/NotionRender';
import { METADATA_CONFIG, METADATA_TWITTER_CONFIG, OPEN_GRAPH_CONFIG, SITE_CONFIG } from '@/config';
import { extractDescription } from '@/utils';

import JsonLD from './components/JsonLD';

type Params = { slug: string };

export async function generateMetadata(props: { params: Promise<Params> }): Promise<Metadata> {
  const params = await props.params;
  const currentSlug = decodeURIComponent(params.slug);
  const posts = await getPosts();
  const post = posts?.find(({ slug }) => slug === currentSlug);

  if (!post) return {};

  const { title, date, thumbnail } = post;
  const recordMap = await getPost(post.id);
  const description = extractDescription(recordMap) || SITE_CONFIG.description;
  const url = `${SITE_CONFIG.siteUrl}/article/${currentSlug}`;

  return {
    ...METADATA_CONFIG,
    title,
    description,
    alternates: { canonical: `/article/${currentSlug}` },
    openGraph: {
      ...OPEN_GRAPH_CONFIG,
      url,
      title,
      description,
      publishedTime: date,
      modifiedTime: date,
      type: 'article',
      ...(thumbnail && { images: thumbnail }),
    },
    twitter: {
      ...METADATA_TWITTER_CONFIG,
      title,
      description,
      ...(thumbnail && { images: [thumbnail] }),
    },
  };
}

export async function generateStaticParams() {
  const posts = await getPosts();
  return posts.map(({ slug }) => ({ slug }));
}

export default async function PostDetailPage({ params }: { params: Promise<Params> }) {
  const slug = decodeURIComponent((await params).slug);
  const posts = await getPosts();
  const post = posts?.find(({ slug: postSlug }) => postSlug === slug);

  if (!post) notFound();

  const { id, title, date, thumbnail } = post;
  const recordMap = await getPost(id);
  const description = extractDescription(recordMap) || SITE_CONFIG.description;

  return (
    <>
      <JsonLD
        slug={slug}
        title={title}
        description={description}
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
