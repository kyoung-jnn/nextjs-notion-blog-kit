/**
 * comment config
 */
export const COMMENT_CONFIG = {
  repo: process.env.NEXT_PUBLIC_GISCUS_REPO ?? '',
  repoId: process.env.NEXT_PUBLIC_GISCUS_REPO_ID ?? '',
  category: process.env.NEXT_PUBLIC_GISCUS_CATEGORY ?? 'Comments',
  categoryId: process.env.NEXT_PUBLIC_GISCUS_CATEGORY_ID ?? '',
} as const;
