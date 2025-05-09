import { globalStyle } from '@vanilla-extract/css';

import { vars } from './theme.css';

globalStyle(':root', {
  scrollBehavior: 'smooth',
  scrollbarWidth: 'thin',
  scrollbarColor: `${vars.colors.gray5} transparent`,
});

globalStyle('body', {
  fontFamily:
    "'Pretendard Variable', Pretendard, -apple-system, BlinkMacSystemFont, system-ui, Roboto, 'Helvetica Neue', 'Segoe UI', 'Apple SD Gothic Neo', 'Noto Sans KR', 'Malgun Gothic', 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', sans-serif",
  fontWeight: 400,
  letterSpacing: '-0.2px',
  color: vars.colors.gray12,
  backgroundColor: vars.colors.gray3,
});

globalStyle('*, *:before, *:after', {
  boxSizing: 'border-box',
});

globalStyle('a', {
  textDecoration: 'none',
  color: vars.colors.gray12,
});

globalStyle('p', {
  margin: 0,
});

globalStyle('ul, li', {
  listStyle: 'none',
  padding: 0,
});

globalStyle('button', {
  all: 'unset',
});

globalStyle('hr', {
  border: 'none',
  borderTop: `1px solid ${vars.colors.gray10}`,
});

globalStyle('h1, h2, h3, h4, h5, h6', {
  margin: '0 0 5px 0',
});
