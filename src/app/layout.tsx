import { ReactNode } from 'react';

import { Analytics } from '@vercel/analytics/next';

import Footer from '@/components/Footer';
import Header from '@/components/Header';
import ProgressBar from '@/components/ProgressBar';
import ThemeProvider from '@/components/ThemeProvider';
import SITE_CONFIG from '@/config/siteConfig';

import '@/styles/global.css';
import '@/styles/normalize.css';
import '@/styles/theme.css';

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
        {/* Naver */}
        <meta
          name="naver-site-verification"
          content="90fde3e7dfdfe8af10193837b23f5a11239155ba"
        />
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

        <Analytics mode="production" />
      </body>
    </html>
  );
}

export default RootLayout;
