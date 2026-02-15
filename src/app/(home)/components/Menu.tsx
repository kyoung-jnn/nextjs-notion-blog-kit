import Link from 'next/link';

import IconButton from '@/components/IconButton';
import { MENU_LIST } from '@/config/navigationConfig';
import SITE_CONFIG from '@/config/siteConfig';

function Menu() {
  return (
    <div className="relative max-w-[640px] px-3 py-9">
      <section className="flex animate-[fade-left_0.8s_0.2s_forwards] gap-2.5 opacity-0">
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

      <nav className="mt-9 grid animate-[fade-left_0.8s_0.3s_forwards] grid-cols-3 opacity-0">
        {MENU_LIST.map(({ href, name, description }) => (
          <div key={href}>
            <Link href={href}>
              <p className="decoration-gray-7 hover:decoration-gray-9 dark:decoration-gray-7 dark:hover:decoration-gray-11 underline underline-offset-[5px] transition-colors duration-400">
                {name}
              </p>
            </Link>
            <p className="mt-2.5 text-xs">{description}</p>
          </div>
        ))}
      </nav>
    </div>
  );
}

export default Menu;
