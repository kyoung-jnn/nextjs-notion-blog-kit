import { cache } from 'react';

import fs from 'fs';
import path from 'path';

import matter from 'gray-matter';
import rehypeAutolinkHeadings from 'rehype-autolink-headings';
import rehypeKatex from 'rehype-katex';
import rehypePrettyCode from 'rehype-pretty-code';
import rehypeSlug from 'rehype-slug';
import rehypeStringify from 'rehype-stringify';
import remarkGfm from 'remark-gfm';
import remarkMath from 'remark-math';
import remarkParse from 'remark-parse';
import remarkRehype from 'remark-rehype';
import { unified } from 'unified';

import { Post, PostMeta } from '@/types/post';
import { slugify } from '@/utils';

const POSTS_DIR = path.join(process.cwd(), 'posts');

function transformImagePaths(content: string): string {
  return content.replace(
    /(?:\.\.\/)+public\/images\/([^\s"')]+)/g,
    (_, filename) => `/images/${path.basename(filename)}`,
  );
}

function extractDescription(content: string, maxLength = 160): string {
  const plainText = content
    .replace(/```[\s\S]*?```/g, '')
    .replace(/!\[.*?\]\(.*?\)/g, '')
    .replace(/\[([^\]]*)\]\(.*?\)/g, '$1')
    .replace(/#{1,6}\s+/g, '')
    .replace(/[*_~`]/g, '')
    .replace(/\$\$[\s\S]*?\$\$/g, '')
    .replace(/\$[^$]+\$/g, '')
    .replace(/\n+/g, ' ')
    .trim();

  if (!plainText) return '';
  if (plainText.length <= maxLength) return plainText;

  const truncated = plainText.slice(0, maxLength);
  const lastSpace = truncated.lastIndexOf(' ');
  return (lastSpace > maxLength * 0.7 ? truncated.slice(0, lastSpace) : truncated) + '...';
}

// Processor is stateless — safe to reuse across calls (Shiki initializes once)
const processor = unified()
  .use(remarkParse)
  .use(remarkGfm)
  .use(remarkMath)
  .use(remarkRehype, { allowDangerousHtml: true })
  .use(rehypeKatex)
  .use(rehypePrettyCode, { theme: 'github-dark' })
  .use(rehypeSlug)
  .use(rehypeAutolinkHeadings, { behavior: 'wrap' })
  .use(rehypeStringify, { allowDangerousHtml: true });

function getPostFiles(): string[] {
  if (!fs.existsSync(POSTS_DIR)) return [];
  return fs.readdirSync(POSTS_DIR).filter((file) => file.endsWith('.md'));
}

interface PostFrontmatter {
  title?: string;
  date?: string | Date;
  slug?: string;
  published?: boolean;
  thumbnail?: string;
  description?: string;
  tags?: string[];
}

function formatDate(date: string | Date | undefined): string {
  if (!date) return new Date().toISOString().split('T')[0];
  if (date instanceof Date) return date.toISOString().split('T')[0];
  return date.toString();
}

function parseFrontmatter(data: PostFrontmatter, content: string, fileSlug: string): PostMeta {
  return {
    title: data.title || fileSlug,
    date: formatDate(data.date),
    slug: data.slug || slugify(data.title || '') || fileSlug,
    published: data.published === true,
    thumbnail: data.thumbnail,
    description: data.description || extractDescription(content),
    tags: data.tags || [],
  };
}

const _getAllPosts = async (): Promise<PostMeta[]> => {
  const files = getPostFiles();

  const posts = files.map((fileName) => {
    const filePath = path.join(POSTS_DIR, fileName);
    const raw = fs.readFileSync(filePath, 'utf-8');
    const { data, content } = matter(raw);
    const fileSlug = path.basename(fileName, '.md');
    return parseFrontmatter(data as PostFrontmatter, content, fileSlug);
  });

  const filtered = posts.filter((post) =>
    process.env.NODE_ENV === 'production' ? post.published : true,
  );

  return filtered.sort((a, b) => new Date(b.date).getTime() - new Date(a.date).getTime());
};

export const getAllPosts = cache(_getAllPosts);

const _getPostBySlug = async (slug: string): Promise<Post | null> => {
  const files = getPostFiles();

  for (const fileName of files) {
    const filePath = path.join(POSTS_DIR, fileName);
    const raw = fs.readFileSync(filePath, 'utf-8');
    const { data, content } = matter(raw);
    const fileSlug = path.basename(fileName, '.md');
    const meta = parseFrontmatter(data as PostFrontmatter, content, fileSlug);

    if (meta.slug !== slug) continue;

    const transformed = transformImagePaths(content);
    const result = await processor.process(transformed);

    return {
      ...meta,
      html: String(result),
    };
  }

  return null;
};

export const getPostBySlug = cache(_getPostBySlug);
