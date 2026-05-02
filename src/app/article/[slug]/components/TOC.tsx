'use client';

import { useEffect, useState } from 'react';

const DEPTH_STYLE: Record<string, string> = {
  H1: '',
  H2: 'ml-1',
  H3: 'ml-1.5',
  H4: 'ml-2',
};

interface Heading {
  id: string;
  text: string;
  tag: string;
}

function TOC() {
  const [headings, setHeadings] = useState<Heading[]>([]);
  const [activeId, setActiveId] = useState<string | null>(null);

  useEffect(() => {
    const elements = document.querySelectorAll<HTMLElement>(
      '.markdown-render h1, .markdown-render h2, .markdown-render h3, .markdown-render h4',
    );

    const collected: Heading[] = [];
    elements.forEach((el) => {
      const id = el.id;
      const text = el.textContent?.trim() ?? '';
      if (!text || !id) return;
      collected.push({ id, text, tag: el.tagName });
    });

    setHeadings(collected);

    if (collected.length === 0) return;

    // Highlight the heading that sits in the top 30% of the viewport
    // (after the sticky header at 80px). When multiple headings overlap
    // that band, the topmost one wins.
    const observer = new IntersectionObserver(
      (entries) => {
        const visible = entries.filter((e) => e.isIntersecting);
        if (visible.length === 0) return;
        const topmost = visible.reduce((acc, cur) =>
          cur.target.getBoundingClientRect().top < acc.target.getBoundingClientRect().top
            ? cur
            : acc,
        );
        setActiveId(topmost.target.id);
      },
      { rootMargin: '-80px 0px -70% 0px', threshold: 0 },
    );

    elements.forEach((el) => observer.observe(el));
    return () => observer.disconnect();
  }, []);

  if (headings.length === 0) return null;

  return (
    <nav className="border-gray-9 dark:border-gray-7 grid animate-[fade-left_0.4s_forwards] gap-2.5 border-l py-1 pl-1.5">
      {headings.map(({ id, text, tag }) => {
        const isActive = id === activeId;
        return (
          <a
            key={id}
            href={`#${id}`}
            className={`text-xs transition-colors duration-200 ${
              isActive
                ? 'text-gray-12 dark:text-gray-12'
                : 'text-gray-9 dark:text-gray-11 hover:text-gray-12'
            } ${DEPTH_STYLE[tag] ?? ''}`}
          >
            {text}
          </a>
        );
      })}
    </nav>
  );
}

export default TOC;
