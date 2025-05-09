import { ReactNode } from 'react';

import { section } from './layout.css';

export default function Layout({ children }: { children: ReactNode }) {
  return <section className={section}>{children}</section>;
}
