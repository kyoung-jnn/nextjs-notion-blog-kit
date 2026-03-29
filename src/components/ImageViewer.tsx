'use client';

import { useEffect } from 'react';

import PhotoSwipeLightbox from 'photoswipe/lightbox';
import 'photoswipe/style.css';

export default function ImageViewer() {
  // --- Image lightbox ---
  useEffect(() => {
    const lightbox = new PhotoSwipeLightbox({
      gallery: '.markdown-render',
      children: 'img',
      pswpModule: () => import('photoswipe'),
      showHideAnimationType: 'zoom',
      bgOpacity: 0.85,
    });

    lightbox.addFilter('domItemData', (itemData, element) => {
      const img = element as HTMLImageElement;
      return {
        ...itemData,
        src: img.src,
        msrc: img.src,
        w: img.naturalWidth || 1200,
        h: img.naturalHeight || 800,
      };
    });

    lightbox.init();
    return () => lightbox.destroy();
  }, []);

  // --- Code copy button (rehype-pretty-code transformer injects button HTML, sanitize strips onclick) ---
  useEffect(() => {
    const handleClick = (e: MouseEvent) => {
      const button = (e.target as HTMLElement).closest('button.rehype-pretty-copy');
      if (!button) return;

      const code = button.getAttribute('data') || '';
      navigator.clipboard.writeText(code);

      button.classList.add('rehype-pretty-copied');
      setTimeout(() => button.classList.remove('rehype-pretty-copied'), 2000);
    };

    document.addEventListener('click', handleClick);
    return () => document.removeEventListener('click', handleClick);
  }, []);

  return null;
}
