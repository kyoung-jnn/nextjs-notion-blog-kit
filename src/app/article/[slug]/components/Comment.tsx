'use client';

import { useTheme } from 'next-themes';

import Giscus, { Theme } from '@giscus/react';

import { COMMENT_CONFIG } from '@/config/commentConfig';

function Comment() {
  const { theme } = useTheme();

  const commentTheme: Theme =
    theme === 'dark' ? 'noborder_dark' : 'noborder_light';

  return (
    <Giscus
      id="comments"
      repo={COMMENT_CONFIG.repo}
      repoId={COMMENT_CONFIG.repoId}
      category={COMMENT_CONFIG.category}
      categoryId={COMMENT_CONFIG.categoryId}
      term="comments"
      theme={commentTheme}
      inputPosition="bottom"
      mapping="pathname"
      reactionsEnabled="1"
      emitMetadata="0"
      lang="en"
      loading="lazy"
    />
  );
}

export default Comment;
