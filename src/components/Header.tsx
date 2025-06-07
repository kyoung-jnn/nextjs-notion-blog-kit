'use client';

import { memo } from 'react';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

import MobileMenu from '@/components/MobileMenu';
import ThemeSwitch from '@/components/ThemeSwitch';
import SITE_CONFIG from '@/config/siteConfig';

function Header() {
  const pathname = usePathname();

  return (
    <header className="sticky top-0 h-[44px] z-[100] backdrop-blur-[3px]">
      <nav className="flex justify-between items-center max-w-[664px] mx-auto py-[10px] px-[12px]">
        <Link href="/" aria-label="home link">
          <p className="flex justify-between items-center font-normal text-[14px]">
            {pathname !== '/' && SITE_CONFIG.author.enName}
          </p>
        </Link>
        <div className="flex items-center text-[16px] font-semibold gap-[6px]">
          <ThemeSwitch />
          <MobileMenu />
        </div>
      </nav>
    </header>
  );
}

export default memo(Header);
