import { style } from '@vanilla-extract/css';

import { fadeUp } from '@/styles/animation.css';
import { vars } from '@/styles/theme.css';

export const wrapper = style({
  display: 'grid',
  gap: 4,
  opacity: 0,
  animation: `${fadeUp} 1s forwards`,
  padding: '0 12px',
});

export const name = style({
  fontSize: 26,
});

export const desciption = style({
  color: vars.colors.gray12,
  fontSize: 15,
});
