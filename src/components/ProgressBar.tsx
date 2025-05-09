'use client';

import _ProgressBar from 'nextjs-progressbar';

import { vars } from '@/styles/theme.css';

function ProgressBar() {
  return (
    <_ProgressBar
      startPosition={0.15}
      stopDelayMs={200}
      height={2}
      showOnShallow={true}
      options={{ showSpinner: false }}
      transformCSS={() => {
        return (
          <style>
            {`#nprogress .bar { background: ${vars.colors.gray8}; position: fixed; z-index: 9999; top: 0; left: 0; width: 100%; height: 2px; }`}
          </style>
        );
      }}
    />
  );
}

export default ProgressBar;
