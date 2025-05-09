import { style } from '@vanilla-extract/css';

import { fadeLeft } from '@/styles/animation.css';
import { media } from '@/styles/media.css';
import { vars } from '@/styles/theme.css';

export const wrapper = style([
  {
    display: 'block',
  },
  media.tablet({
    display: 'none',
  }),
]);

export const navContainer = style({
  position: 'fixed',
  top: 0,
  left: 0,
  zIndex: 100,
  animation: `${fadeLeft} 0.5s ease-in-out`,
});

export const background = style({
  position: 'absolute',
  top: 0,
  left: 0,
  width: '100vw',
  height: '100vh',
  backgroundColor: vars.colors.gray3,
  opacity: 0.8,
});

export const menuContainer = style({
  position: 'absolute',
  display: 'flex',
  flexDirection: 'column',
  justifyContent: 'center',
  alignItems: 'center',
  width: '100vw',
  height: '100vh',
  zIndex: 10,
});

export const menuItem = style({
  width: '100vw',
  fontSize: '24px',
  fontWeight: 700,
  textAlign: 'center',
  padding: '30px',
  cursor: 'pointer',
  color: vars.colors.gray12,
});
