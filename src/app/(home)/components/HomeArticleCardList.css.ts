import { style } from '@vanilla-extract/css';

import { fadeLeft } from '@/styles/animation.css';

export const wrapper = style({
  opacity: 0,
  animation: `${fadeLeft} 1s 0.4s forwards`,
});
