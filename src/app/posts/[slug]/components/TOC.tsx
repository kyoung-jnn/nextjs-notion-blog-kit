'use client';

import {
  Dispatch,
  SetStateAction,
  useCallback,
  useEffect,
  useState,
} from 'react';

function TOC() {
  const [currentTable, setCurrentTable] = useState<string>('');
  const [tables, setTables] = useState<
    {
      tableElement: Element;
      highlightTag: string;
    }[]
  >([]);

  const getObserver = useCallback(
    (setCurrentTable: Dispatch<SetStateAction<string>>) => {
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
    },
    [],
  );

  useEffect(() => {
    const observer = getObserver(setCurrentTable);

    // 본문의 h 태그를 가져온다
    const elements = Array.from(
      document.querySelectorAll('h2 span span, h3 span span, h4 span span'),
    ).map((tableElement) => {
      tableElement['id'] = tableElement.innerHTML.replace(/\s/g, '-');
      return {
        tableElement,
        highlightTag: tableElement.parentNode?.parentNode?.nodeName as string,
      };
    });

    setTables(elements);

    for (const { tableElement } of elements) {
      observer.observe(tableElement);
    }

    return () => observer.disconnect();
  }, [getObserver, setCurrentTable]);

  if (!tables.length) return <></>;

  return (
    <nav className="grid animate-[fadeLeft_0.4s_forwards] gap-2.5 border-l border-gray-800 py-1 pl-2.5">
      {tables.map(({ tableElement, highlightTag }, index) => {
        const isActive =
          currentTable === tableElement.innerHTML.replace(/\s/g, '-');
        const getDepthStyle = () => {
          if (highlightTag === 'H3') return 'ml-2.5';
          if (highlightTag === 'H4') return 'ml-5';
          return '';
        };

        return (
          <a
            href={'#' + tableElement.innerHTML.replace(/\s/g, '-')}
            key={index}
            className={`text-xs transition-colors duration-200 ${isActive ? 'font-semibold text-gray-950' : 'text-gray-800'} ${getDepthStyle()}`}
          >
            {tableElement.innerHTML}
          </a>
        );
      })}
    </nav>
  );
}

export default TOC;
