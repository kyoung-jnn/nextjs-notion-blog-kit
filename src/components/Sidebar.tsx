'use client';

import { PropsWithChildren, memo } from 'react';

import { useRouter } from 'next/navigation';

import IconButton from './IconButton';

function Sidebar({ children }: PropsWithChildren) {
  const router = useRouter();

  return (
    <aside className="desktop:sticky desktop:grid desktop:gap-[20px] desktop:top-[90px] hidden">
      <IconButton name="ArrowUpLeft" onClick={() => router.back()} />
      {children}
    </aside>
  );
}

export default memo(Sidebar);
