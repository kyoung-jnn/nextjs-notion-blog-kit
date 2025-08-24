'use client';

import { PropsWithChildren, useRef } from 'react';

import Image from 'next/image';

import Comment from '@/app/posts/[slug]/components/Comment';
import IconButton from '@/components/IconButton';
import Sidebar from '@/components/Sidebar';
import { dateToFormat } from '@/utils/time';

import TOC from './TOC';

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
    <div className="relative mt-[60px] flex flex-col gap-2.5 tablet:grid tablet:grid-cols-[192px_640px_192px] tablet:items-start tablet:justify-center">
      {/* TOC sidebar */}
      <Sidebar>
        <TOC />
        <div className="flex animate-[fadeLeft_0.4s_0.2s_forwards] gap-1.5 opacity-0">
          <IconButton name="ArrowUp" onClick={handleScrollToTop} />
          <IconButton name="Messages" onClick={handleScrollToComment} />
        </div>
      </Sidebar>

      {/* post content */}
      <div className="animate-[fadeUp_0.5s_forwards] tablet:col-start-2 tablet:col-end-3">
        <header className="mb-5 text-left">
          <h1 className="text-[30px]">{title}</h1>
          <time
            dateTime={updatedAt}
            className="mt-2 block text-base text-gray-950"
          >
            {updatedAt}
          </time>
          {thumbnail && (
            <figure className="m-0 mt-2.5">
              <Image src={thumbnail} alt="post thumbnail" fill priority />
            </figure>
          )}
        </header>
        {children}
      </div>

      {/* post footer */}
      <footer
        className="border-gray-9 mt-6 border-t pt-6 text-lg tablet:col-start-2 tablet:col-end-3"
        ref={commentContainerRef}
      >
        <Comment />
      </footer>
    </div>
  );
}

export default PostLayout;
