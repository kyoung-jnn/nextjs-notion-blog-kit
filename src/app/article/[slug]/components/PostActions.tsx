'use client';

import { useCallback } from 'react';

import IconButton from '@/components/IconButton';

function PostActions() {
  const handleScrollToTop = useCallback(() => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  const handleScrollToComment = useCallback(() => {
    document.getElementById('comments-footer')?.scrollIntoView({
      behavior: 'smooth',
      block: 'end',
    });
  }, []);

  return (
    <div className="flex animate-[fade-left_0.4s_0.2s_forwards] gap-1.5 opacity-0">
      <IconButton name="ArrowUp" onClick={handleScrollToTop} />
      <IconButton name="Messages" onClick={handleScrollToComment} />
    </div>
  );
}

export default PostActions;
