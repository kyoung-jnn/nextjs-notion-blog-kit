import { gray, grayDark } from '@radix-ui/colors';
import { createGlobalThemeContract, createTheme } from '@vanilla-extract/css';


export const vars = createGlobalThemeContract({
  colors: {
    gray1: 'gray1',
    gray2: 'gray2',
    gray3: 'gray3',
    gray4: 'gray4',
    gray5: 'gray5',
    gray6: 'gray6',
    gray7: 'gray7',
    gray8: 'gray8',
    gray9: 'gray9',
    gray10: 'gray10',
    gray11: 'gray11',
    gray12: 'gray12',
  },
});

export const lightTheme = createTheme(vars, {
  colors: {
    ...gray,
  },
});

export const darkTheme = createTheme(vars, {
  colors: {
    ...grayDark,
  },
});
