'use client';

import { useState, MouseEvent } from 'react';

import Link from 'next/link';

import { MENU_LIST } from '@/app/(home)/components/Menu';

import IconButton from './IconButton';

function MobileMenu() {
  const [hasNav, setHasNav] = useState(false);

  const handleClick = (e: MouseEvent) => {
    e.stopPropagation();

    setHasNav((status) => {
      if (status) {
        document.body.style.overflow = 'auto';
      } else {
        // Nav 뒤 화면 스크롤 기능 정지
        document.body.style.overflow = 'hidden';
      }
      return !status;
    });
  };

  return (
    <div className="block tablet:hidden">
      <IconButton
        name="Menu"
        aria-label="Toggle Menu Button"
        onClick={handleClick}
      />

      {hasNav && (
        <div className="fixed top-0 left-0 z-[100] animate-[fade-left_0.5s_ease-in-out]">
          <div className="absolute top-0 left-0 h-dvh w-dvw bg-gray-400 opacity-80" />
          <section
            className="absolute z-[10] flex h-dvh w-dvw flex-col items-center justify-center"
            onClick={handleClick}
          >
            {MENU_LIST.map(({ name, href }) => (
              <Link key={name} href={href}>
                <button className="font-size-[24px] w-full cursor-pointer p-[30px] text-center font-bold text-gray-950">
                  {name}
                </button>
              </Link>
            ))}
          </section>
        </div>
      )}
    </div>
  );
}

export default MobileMenu;
