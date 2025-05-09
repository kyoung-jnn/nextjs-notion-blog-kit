'use client';

import { ReactNode } from 'react';

import { ThemeProvider as _ThemeProvider } from 'next-themes';

import { lightTheme, darkTheme } from '@/styles/theme.css';

function ThemeProvider({ children }: { children: ReactNode }) {
  return (
    <_ThemeProvider
      attribute="class"
      enableSystem={false}
      defaultTheme="light"
      value={{
        light: lightTheme,
        dark: darkTheme,
      }}
    >
      {children}
    </_ThemeProvider>
  );
}

export default ThemeProvider;
