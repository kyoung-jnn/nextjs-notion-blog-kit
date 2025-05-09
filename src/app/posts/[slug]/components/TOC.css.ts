import { style } from '@vanilla-extract/css';

import { fadeLeft } from '@/styles/animation.css';
import { vars } from '@/styles/theme.css';

export const wrapper = style({
  display: 'grid',
  gap: '10px',
  padding: '4px 0 4px 10px',
  borderLeft: `1px solid ${vars.colors.gray9}`,
  animation: `${fadeLeft} 0.4s forwards`,
});

export const baseTableItem = style({
  fontSize: '13px',
  transition: 'color 0.2s',
});

export const activeTableItem = style({
  fontWeight: 600,
  color: vars.colors.gray12,
});

export const inactiveTableItem = style({
  color: vars.colors.gray9,
});

export const depthH2 = style({});

export const depthH3 = style({
  marginLeft: '10px',
});

export const depthH4 = style({
  marginLeft: '20px',
});
