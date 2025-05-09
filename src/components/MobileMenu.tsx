'use client';

import { useState, MouseEvent } from 'react';

import Link from 'next/link';

import { MENU_LIST } from '@/app/(home)/components/Menu';

import IconButton from './IconButton';

import * as styles from './MobileMenu.css';

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
    <div className={styles.wrapper}>
      <IconButton
        name="Menu"
        aria-label="Toggle Menu Button"
        onClick={handleClick}
      />

      {hasNav && (
        <div className={styles.navContainer}>
          <div className={styles.background} />
          <section className={styles.menuContainer} onClick={handleClick}>
            {MENU_LIST.map(({ name, href }) => (
              <Link key={name} href={href}>
                <button className={styles.menuItem}>{name}</button>
              </Link>
            ))}
          </section>
        </div>
      )}
    </div>
  );
}

export default MobileMenu;
