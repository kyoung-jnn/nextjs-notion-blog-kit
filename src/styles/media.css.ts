import { type StyleRule, style } from '@vanilla-extract/css';

const BREAK_POINT = {
  moblie: 480,
  tablet: 768,
  desktop: 1024,
} as const;

export const media = {
  tablet: (mediaRule: StyleRule) =>
    style({
      '@media': {
        [`screen and (min-width: ${BREAK_POINT.tablet}px)`]: {
          ...mediaRule,
        },
      },
    }),
  desktop: (mediaRule: StyleRule) =>
    style({
      '@media': {
        [`screen and (min-width: ${BREAK_POINT.desktop}px)`]: {
          ...mediaRule,
        },
      },
    }),
};
