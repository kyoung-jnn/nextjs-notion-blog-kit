import { style } from '@vanilla-extract/css';

import { vars } from '@/styles/theme.css';

export const wrapper = style({
  display: 'flex',
  justifyContent: 'space-between',
  alignContent: 'center',
  padding: '10px 12px',
  transition: 'all 0.4s',
  borderRadius: 6,
  cursor: 'pointer',

  ':hover': { backgroundColor: vars.colors.gray4 },
});

export const h1 = style({
  fontSize: 15,
  fontWeight: 400,
  margin: 0,
});

export const time = style({
  fontSize: 13,
  fontWeight: 300,
});
