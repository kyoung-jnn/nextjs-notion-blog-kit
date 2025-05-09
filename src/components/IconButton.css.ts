import { style } from '@vanilla-extract/css';

import { vars } from '@/styles/theme.css';

export const wrapper = style({
  display: 'flex',
  width: 'fit-content',
  height: 'fit-content',
  padding: '3px',
  borderRadius: '3px',
  cursor: 'pointer',
  transition: 'background-color 0.4s',
  ':hover': {
    backgroundColor: vars.colors.gray5,
  },
});
