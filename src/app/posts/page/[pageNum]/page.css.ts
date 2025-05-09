import { style } from '@vanilla-extract/css';

import { media } from '@/styles/media.css';

export const wrapper = style([
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
    gridTemplateColumns: '180px 664px 180px',
  }),
]);

export const title = style({ padding: '0 12px', margin: 0, fontSize: 26 });

export const content = style({
  gridColumn: '2/3',
});

export const list = style({ display: 'grid', gap: 10 });
