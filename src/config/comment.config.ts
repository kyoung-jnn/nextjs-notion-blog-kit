import blogConfig from '@/config/blog.config';

export const COMMENT_CONFIG = {
  repo: blogConfig.giscus.repo,
  repoId: blogConfig.giscus.repoId,
  category: blogConfig.giscus.category,
  categoryId: blogConfig.giscus.categoryId,
} as const;
