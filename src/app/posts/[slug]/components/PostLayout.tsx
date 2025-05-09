'use client';

import { PropsWithChildren, useRef } from 'react';

import Image from 'next/image';

import Comment from '@/app/posts/[slug]/components/Comment';
import IconButton from '@/components/IconButton';
import Sidebar from '@/components/Sidebar';
import { dateToFormat } from '@/utils/time';

import TOC from './TOC';

import * as styles from './PostLayout.css';

interface Props {
  title: string;
  date: string;
  thumbnail?: string;
}

function PostLayout({
  title,
  date,
  thumbnail,
  children,
}: PropsWithChildren<Props>) {
  const updatedAt = dateToFormat(date);
  const commentContainerRef = useRef<HTMLDivElement>(null);

  const handleScrollToTop = () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  };

  const handleScrollToComment = () => {
    if (commentContainerRef.current)
      commentContainerRef.current.scrollIntoView({
        behavior: 'smooth',
        block: 'end',
      });
  };

  return (
    <div className={styles.mainFrame}>
      {/* TOC sidebar */}
      <Sidebar>
        <TOC />
        <div className={styles.buttonContainer}>
          <IconButton name="ArrowUp" onClick={handleScrollToTop} />
          <IconButton name="Messages" onClick={handleScrollToComment} />
        </div>
      </Sidebar>

      {/* post content */}
      <div className={styles.postFrame}>
        <header className={styles.postHeader}>
          <h1 className={styles.postTitle}>{title}</h1>
          <time dateTime={updatedAt} className={styles.postTime}>
            {updatedAt}
          </time>
          {thumbnail && (
            <figure className={styles.postThumbnail}>
              <Image src={thumbnail} alt="post thumbnail" fill priority />
            </figure>
          )}
        </header>
        {children}
      </div>

      {/* post footer */}
      <footer className={styles.postFooter} ref={commentContainerRef}>
        <Comment />
      </footer>
    </div>
  );
}

export default PostLayout;
