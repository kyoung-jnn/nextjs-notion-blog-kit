import { style } from '@vanilla-extract/css';

import { media } from '@/styles/media.css';

export const wrapper = style([
  {
    position: 'relative',
    display: 'none',
  },
  media.desktop({
    position: 'sticky',
    display: 'grid',
    gap: 20,
    top: 90,
  }),
]);
