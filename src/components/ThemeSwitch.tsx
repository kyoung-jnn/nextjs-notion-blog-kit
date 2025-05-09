'use client';

import { useEffect, useState } from 'react';

import Image from 'next/image';
import { useTheme } from 'next-themes';

import Icon from './Icon';

import * as styles from './ThemeSwitch.css';

export const THEME = {
  light: 'light',
  dark: 'dark',
} as const;

const ThemeSwitch = () => {
  const [mounted, setMounted] = useState(false);
  const { theme, setTheme } = useTheme();

  useEffect(() => setMounted(true), []);

  const handleClick = () => {
    setTheme(theme === THEME.dark ? THEME.light : THEME.dark);
  };

  return (
    <button className={styles.button} onClick={handleClick}>
      {!mounted ? (
        <Image
          alt="theme-placeholder"
          src={
            'data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7'
          }
          width={40}
          height={40}
        />
      ) : theme === THEME.light ? (
        <Icon name="Sun" className={styles.lightTheme} />
      ) : (
        <Icon name="Moon" className={styles.darkTheme} />
      )}
    </button>
  );
};

export default ThemeSwitch;
