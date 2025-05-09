import { ReactNode } from 'react';

import { wrapper } from './layout.css';

export default function Layout({ children }: { children: ReactNode }) {
  return <section className={wrapper}>{children}</section>;
}
