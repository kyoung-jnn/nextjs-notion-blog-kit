'use client';

import { PropsWithChildren, memo } from 'react';

import { useRouter } from 'next/navigation';

import IconButton from './IconButton';

import * as styles from './Sidebar.css';

function Sidebar({ children }: PropsWithChildren) {
  const router = useRouter();

  return (
    <aside className={styles.wrapper}>
      <IconButton name="ArrowUpLeft" onClick={() => router.back()} />
      {children}
    </aside>
  );
}

export default memo(Sidebar);
