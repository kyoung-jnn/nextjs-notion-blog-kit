import { ReactNode } from 'react';

import Footer from '@/components/Footer';
import Header from '@/components/Header';
import ProgressBar from '@/components/ProgressBar';
import ThemeProvider from '@/components/ThemeProvider';
import SITE_CONFIG from '@/config/siteConfig';

import '@/styles/global.css';

function RootLayout({ children }: { children: ReactNode }) {
  return (
    <html lang={SITE_CONFIG.locale} suppressHydrationWarning>
      <head>
        <meta content="width=device-width, initial-scale=1" name="viewport" />
        {/* Font */}
        <link rel="preconnect" href="https://cdnjs.cloudflare.com" />
        <link
          rel="stylesheet"
          as="style"
          crossOrigin="anonymous"
          href="https://cdnjs.cloudflare.com/ajax/libs/pretendard/1.3.9/variable/pretendardvariable-dynamic-subset.min.css"
        />
        {/* Search Engine Verification - Replace with your own verification code */}
        {/* <meta name="naver-site-verification" content="your-verification-code" /> */}
        {/* RSS */}
        <link
          rel="alternate"
          type="application/rss+xml"
          href={`${SITE_CONFIG.siteUrl}/rss.xml`}
          title="rss"
        />
      </head>
      <body>
        <ThemeProvider>
          <ProgressBar />
          <Header />
          {children}
          <Footer />
        </ThemeProvider>
      </body>
    </html>
  );
}

export default RootLayout;
