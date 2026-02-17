import { PropsWithChildren } from 'react';

import Image from 'next/image';

import Sidebar from '@/components/Sidebar';
import { dateToStringWithDash } from '@/utils';

import PostActions from './PostActions';
import PostFooter from './PostFooter';
import TOC from './TOC';

interface Props {
  title: string;
  date: string;
  thumbnail?: string;
}

function PostLayout({ title, date, thumbnail, children }: PropsWithChildren<Props>) {
  const updatedAt = dateToStringWithDash(date);

  return (
    <div className="tablet:grid tablet:grid-cols-[192px_640px_192px] tablet:items-start tablet:justify-center relative mt-[60px] flex flex-col gap-2.5">
      {/* TOC sidebar */}
      <Sidebar>
        <TOC />
        <PostActions />
      </Sidebar>

      {/* post content */}
      <div className="tablet:col-start-2 tablet:col-end-3 animate-[fade-up_0.5s_forwards]">
        <header className="mb-5 text-left">
          <h1 className="text-[30px] font-bold">{title}</h1>
          <time dateTime={updatedAt} className="text-gray-9 dark:text-gray-11 block text-base">
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
      <PostFooter />
    </div>
  );
}

export default PostLayout;
