'use client';

import { Dispatch, SetStateAction, useCallback, useEffect, useState } from 'react';

function TOC() {
  const [currentTable, setCurrentTable] = useState<string>('');
  const [tables, setTables] = useState<
    {
      id: string;
      text: string;
      highlightTag: string;
    }[]
  >([]);

  const getObserver = useCallback((setCurrentTable: Dispatch<SetStateAction<string>>) => {
    let direction = '';
    let prevYposition = 0;

    const getScrollDirection = (prevY: number) => {
      if (window.scrollY === 0 && prevY === 0) return;
      else if (window.scrollY > prevY) direction = 'down';
      else direction = 'up';

      prevYposition = window.scrollY;
    };

    return new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          getScrollDirection(prevYposition);

          if (
            (direction === 'down' && !entry.isIntersecting) ||
            (direction === 'up' && entry.isIntersecting)
          ) {
            setCurrentTable(entry.target.id);
          }
        });
      },
      { threshold: 1 },
    );
  }, []);

  useEffect(() => {
    const observer = getObserver(setCurrentTable);

    const elements = Array.from(
      document.querySelectorAll('h2 span span, h3 span span, h4 span span'),
    ).map((tableElement) => {
      const text = tableElement.textContent ?? '';
      const id = text.replace(/\s/g, '-');
      tableElement.id = id;
      return {
        id,
        text,
        highlightTag: tableElement.parentNode?.parentNode?.nodeName ?? '',
      };
    });

    setTables(elements);

    for (const { id } of elements) {
      const el = document.getElementById(id);
      if (el) observer.observe(el);
    }

    return () => observer.disconnect();
  }, [getObserver, setCurrentTable]);

  if (!tables.length) return <></>;

  return (
    <nav className="border-gray-9 dark:border-gray-7 grid animate-[fade-left_0.4s_forwards] gap-2.5 border-l py-1 pl-2.5">
      {tables.map(({ id, text, highlightTag }) => {
        const isActive = currentTable === id;
        const getDepthStyle = () => {
          if (highlightTag === 'H3') return 'ml-2.5';
          if (highlightTag === 'H4') return 'ml-5';
          return '';
        };

        return (
          <a
            href={`#${id}`}
            key={id}
            className={`text-xs transition-colors duration-200 ${isActive ? 'text-gray-12 dark:text-gray-12 font-semibold' : 'text-gray-9 dark:text-gray-11'} ${getDepthStyle()}`}
          >
            {text}
          </a>
        );
      })}
    </nav>
  );
}

export default TOC;
