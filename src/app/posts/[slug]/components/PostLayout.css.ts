import { style } from '@vanilla-extract/css';

import { fadeLeft, fadeUp } from '@/styles/animation.css';
import { media } from '@/styles/media.css';
import { vars } from '@/styles/theme.css';

export const mainFrame = style([
  {
    position: 'relative',
    display: 'flex',
    flexDirection: 'column',
    gap: '10px',
    marginTop: '60px',
  },
  media.tablet({
    display: 'grid',
    justifyContent: 'center',
    alignItems: 'flex-start',
    gridTemplateColumns: '192px 640px 192px',
  }),
]);

export const buttonContainer = style({
  display: 'flex',
  gap: '6px',
  opacity: 0,
  animation: `${fadeLeft} 0.4s 0.2s forwards`,
});

export const postFrame = style({
  animation: `${fadeUp} 0.5s forwards`,
  gridColumn: '2/3',
});

export const postHeader = style({
  marginBottom: '20px',
  textAlign: 'left',
});

export const postTitle = style({
  fontSize: '30px',
});

export const postTime = style({
  display: 'block',
  fontSize: '16px',
  marginTop: '8px',
  color: vars.colors.gray10,
});

export const postFooter = style({
  gridColumn: '2/3',
  marginTop: '24px',
  paddingTop: '24px',
  fontSize: '18px',
  borderTop: `1px solid ${vars.colors.gray9}`,
});

export const postThumbnail = style({
  margin: 0,
  marginTop: '10px',
});
