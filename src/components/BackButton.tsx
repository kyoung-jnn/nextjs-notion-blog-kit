'use client';

import { useRouter } from 'next/navigation';

import IconButton from './IconButton';

function BackButton() {
  const router = useRouter();

  return <IconButton name="ArrowUpLeft" onClick={() => router.back()} />;
}

export default BackButton;
