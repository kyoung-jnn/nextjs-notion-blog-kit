'use client';

import { useCallback, useEffect, useRef, useState } from 'react';

import { useTheme } from 'next-themes';

import Giscus, { Theme } from '@giscus/react';

import { COMMENT_CONFIG } from '@/config';

const isConfigured = Boolean(COMMENT_CONFIG.repoId && COMMENT_CONFIG.categoryId);

function Comment() {
  const { theme } = useTheme();
  const [error, setError] = useState(false);
  const containerRef = useRef<HTMLDivElement>(null);

  const handleMessage = useCallback((event: MessageEvent) => {
    if (event.origin !== 'https://giscus.app') return;

    const data = typeof event.data === 'string' ? JSON.parse(event.data) : event.data;
    if (data?.giscus?.error) {
      setError(true);
    }
  }, []);

  useEffect(() => {
    window.addEventListener('message', handleMessage);
    return () => window.removeEventListener('message', handleMessage);
  }, [handleMessage]);

  if (!isConfigured) return null;

  if (error) {
    return (
      <p className="text-gray-9 py-8 text-center text-sm">
        Failed to load comments. Please try again later.
      </p>
    );
  }

  const commentTheme: Theme = theme === 'dark' ? 'noborder_dark' : 'noborder_light';

  return (
    <div ref={containerRef}>
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
    </div>
  );
}

export default Comment;
