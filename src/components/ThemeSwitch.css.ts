import { keyframes, style } from '@vanilla-extract/css';

export const button = style({
  width: 24,
  height: 24,
  cursor: 'pointer',
});

const rotateSun = keyframes({
  '0%': {
    opacity: 0,
    transform: 'rotate(-45deg)',
  },
  '60%': {
    opacity: 1,
    transform: 'rotate(20deg)',
  },
  '100%': {
    opacity: 1,
    transform: 'rotate(0)',
  },
});

const rotateMoon = keyframes({
  '0%': {
    opacity: 0,
    transform: 'rotate(45deg)',
  },
  '60%': {
    opacity: 1,
    transform: 'rotate(-20deg)',
  },
  '100%': {
    opacity: 1,
    transform: 'rotate(0)',
  },
});

export const lightTheme = style({
  animation: `${rotateSun} 1s`,
});

export const darkTheme = style({
  animation: `${rotateMoon} 1s`,
});
