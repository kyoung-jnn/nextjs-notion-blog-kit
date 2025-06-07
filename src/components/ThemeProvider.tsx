'use client';

import { ReactNode } from 'react';

import { ThemeProvider as _ThemeProvider } from 'next-themes';

function ThemeProvider({ children }: { children: ReactNode }) {
  return (
    <_ThemeProvider attribute="class" enableSystem={false} defaultTheme="light">
      {children}
    </_ThemeProvider>
  );
}

export default ThemeProvider;
