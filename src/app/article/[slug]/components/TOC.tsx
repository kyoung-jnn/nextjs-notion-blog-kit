'use client';

import { useEffect, useState } from 'react';

const DEPTH_STYLE: Record<string, string> = {
  H3: 'ml-2.5',
  H4: 'ml-5',
};

interface Heading {
  id: string;
  text: string;
  tag: string;
}

function TOC() {
  const [headings, setHeadings] = useState<Heading[]>([]);

  useEffect(() => {
    const elements = document.querySelectorAll<HTMLElement>(
      '.notion-render-parent h2, .notion-render-parent h3, .notion-render-parent h4',
    );

    const collected: Heading[] = [];
    elements.forEach((el) => {
      const text = el.textContent?.trim() ?? '';
      if (!text) return;
      const id = text.replace(/\s+/g, '-');
      el.id = id;
      collected.push({ id, text, tag: el.tagName });
    });

    setHeadings(collected);
  }, []);

  if (headings.length === 0) return null;

  return (
    <nav className="border-gray-9 dark:border-gray-7 grid animate-[fade-left_0.4s_forwards] gap-2.5 border-l py-1 pl-2.5">
      {headings.map(({ id, text, tag }) => (
        <a
          key={id}
          href={`#${id}`}
          className={`text-gray-9 dark:text-gray-11 hover:text-gray-12 text-xs transition-colors duration-200 ${DEPTH_STYLE[tag] ?? ''}`}
        >
          {text}
        </a>
      ))}
    </nav>
  );
}

export default TOC;
