import { style } from '@vanilla-extract/css';

export const video = style({
  position: 'relative',
  width: '100%',
  height: 600,
  objectFit: 'cover',
  borderRadius: 1,
  overflow: 'hidden',
});
