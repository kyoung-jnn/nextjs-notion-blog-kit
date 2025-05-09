import { style, globalStyle } from '@vanilla-extract/css';

import { vars } from '@/styles/theme.css';

export const parent = style({
  position: 'relative',
  width: '100%',
  padding: 0,
});

// Helper: Apply the same style to multiple selectors
function applyGlobalStyles(selectors: string[], styleObj: Record<string, any>) {
  selectors.forEach((selector) =>
    globalStyle(`${parent} ${selector}`, styleObj),
  );
}

// Font
globalStyle(`${parent} *`, { fontFamily: 'inherit' });

// Heading
const headingSelectors = ['h1', 'h2', 'h3', 'h4', 'h5', 'h6'];
applyGlobalStyles(headingSelectors, {
  fontWeight: 600,
  letterSpacing: '-0.2px',
});
globalStyle(`${parent} h2`, { fontSize: '28px', marginTop: '22px' });
globalStyle(`${parent} h3`, { fontSize: '25px', marginTop: '18px' });
globalStyle(`${parent} h4`, { fontSize: '22px', marginTop: '14px' });

// Paragraph
globalStyle(`${parent} div`, { lineHeight: 1.7 });

// Link
globalStyle(`${parent} a`, { transition: 'opacity 0.4s' });

// Bold text
applyGlobalStyles(['strong', 'b'], { fontWeight: 600 });

// Blockquote
globalStyle(`${parent} blockquote`, {
  fontSize: '16px',
  margin: '4px 0',
  backgroundColor: vars.colors.gray5,
});

// List
applyGlobalStyles(['ul', 'ol'], {
  paddingInlineStart: '1.2rem',
  fontSize: '15px',
});
globalStyle(`${parent} li`, { padding: '3px 0px' });
globalStyle(`${parent} ul > li`, { listStyle: 'disc' });
globalStyle(`${parent} ol > li`, { listStyle: 'number' });

// Table
globalStyle(`${parent} table`, { width: '100%' });
globalStyle(`${parent} .notion-simple-table`, {
  width: 'auto',
  margin: '10px 20px',
});
globalStyle(`${parent} .notion-simple-table td`, { padding: '6px' });

// Notion Custom Class
globalStyle(`${parent} .notion-callout`, { backgroundColor: 'transparent' });
globalStyle(`${parent} .notion-inline-code`, {
  fontSize: '0.95rem',
  borderRadius: '3px',
  color: vars.colors.gray12,
  backgroundColor: vars.colors.gray5,
  padding: '2px 4px',
});
globalStyle(`${parent} .notion-code`, {
  backgroundColor: '#202020',
  overflowY: 'hidden',
});
globalStyle(`${parent} .notion-code code`, { fontSize: '12px' });
globalStyle(`${parent} .notion-external`, { margin: '10px 0px' });
globalStyle(`${parent} .notion-asset-caption`, {
  paddingTop: '2px',
  paddingBottom: '0px',
});
globalStyle(`${parent} .notion-collection-page-properties`, {
  display: 'none !important',
});
