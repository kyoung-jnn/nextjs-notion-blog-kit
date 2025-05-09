import { style } from '@vanilla-extract/css';

import { fadeLeft } from '@/styles/animation.css';
import { vars } from '@/styles/theme.css';

export const wrapper = style({
  position: 'relative',
  maxWidth: '640px',
  padding: '36px 12px',
});

export const contactSection = style({
  display: 'flex',
  gap: '10px',
  animation: `${fadeLeft} 1s forwards`,
});

export const menuSection = style({
  display: 'grid',
  gridTemplateColumns: 'repeat(3, 1fr)',
  marginTop: '36px',
  opacity: 0,
  animation: `${fadeLeft} 1s 0.2s forwards`,
});

export const menuLink = style({
  textDecoration: 'underline',
  textDecorationColor: vars.colors.gray7,
  textUnderlineOffset: '5px',
  transition: 'text-decoration-color 0.4s',
  selectors: {
    '&:hover': {
      textDecorationColor: vars.colors.gray11,
    },
  },
});

export const menuDescription = style({
  fontSize: '13px',
  marginTop: '10px',
});
