import { defineConfig } from 'eslint/config';

import globals from 'globals';
import js from '@eslint/js';

import tsParser from '@typescript-eslint/parser';
import tseslint from '@typescript-eslint/eslint-plugin';
import reactPlugin from 'eslint-plugin-react';
import reactHooksPlugin from 'eslint-plugin-react-hooks';
import importPlugin from 'eslint-plugin-import';
import prettier from 'eslint-config-prettier';
import nextPlugin from '@next/eslint-plugin-next';

const STATUS = {
  OFF: 'off',
  WARNING: 'warn',
  ERROR: 'error',
};

export default defineConfig([
  { ignores: ['node_modules', '.next'] },
  js.configs.recommended,
  {
    files: ['**/*.{js,jsx,ts,tsx}'],
    languageOptions: {
      ecmaVersion: 'latest',
      sourceType: 'module',
      parser: tsParser,
      parserOptions: {
        ecmaFeatures: { jsx: true },
      },
      globals: {
        ...globals.browser,
        ...globals.node,
      },
    },
    settings: {
      react: { version: 'detect' },
    },
    plugins: {
      '@typescript-eslint': tseslint,
      react: reactPlugin,
      'react-hooks': reactHooksPlugin,
      import: importPlugin,
      '@next': nextPlugin,
    },
    rules: {
      'react/react-in-jsx-scope': STATUS.OFF,
      'react-hooks/exhaustive-deps': STATUS.ERROR,
      'import/order': [
        STATUS.WARNING,
        {
          groups: ['builtin', 'external', 'internal', 'index'],
          pathGroups: [
            {
              pattern: '{react*,react/**,}',
              group: 'builtin',
              position: 'before',
            },
            {
              pattern: '{next*,next/**,}',
              group: 'builtin',
            },
            {
              pattern: '@**',
              group: 'external',
              position: 'before',
            },
            {
              pattern: '@/**/*',
              group: 'external',
              position: 'after',
            },
            {
              pattern: './**/*.css',
              group: 'index',
              position: 'after',
            },
            {
              pattern: './**/*',
              group: 'internal',
              position: 'before',
            },
          ],
          pathGroupsExcludedImportTypes: [],
          'newlines-between': 'always',
          alphabetize: { order: 'asc', caseInsensitive: true },
        },
      ],
    },
  },
  prettier,
]);
