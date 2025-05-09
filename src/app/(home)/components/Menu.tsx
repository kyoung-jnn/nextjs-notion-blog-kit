import Link from 'next/link';

import IconButton from '@/components/IconButton';
import SITE_CONFIG from '@/config/siteConfig';

import * as styles from './Menu.css';

export const MENU_LIST = [
  {
    href: '/posts/page/1',
    name: 'articles',
    description: 'menu description',
  },
] as const;

function Menu() {
  return (
    <div className={styles.wrapper}>
      <section className={styles.contactSection}>
        <Link href={`mailto:${SITE_CONFIG.author.contacts.email}`}>
          <IconButton name="Mail" />
        </Link>
        <Link href={SITE_CONFIG.author.contacts.github} target="_blank">
          <IconButton name="BrandGithub" />
        </Link>
        <Link href={SITE_CONFIG.author.contacts.linkedin} target="_blank">
          <IconButton name="BrandLinkedIn" />
        </Link>
      </section>
      <nav className={styles.menuSection}>
        {MENU_LIST.map(({ href, name, description }) => (
          <div key={href}>
            <Link href={href}>
              <p className={styles.menuLink}>{name}</p>
            </Link>
            <p className={styles.menuDescription}>{description}</p>
          </div>
        ))}
      </nav>
    </div>
  );
}

export default Menu;
