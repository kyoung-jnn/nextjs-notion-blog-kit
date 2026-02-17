import { Block, ExtendedRecordMap } from 'notion-types';
import { getBlockValue, getTextContent } from 'notion-utils';

const TEXT_BLOCK_TYPES = new Set([
  'text',
  'header',
  'sub_header',
  'sub_sub_header',
  'bulleted_list',
  'numbered_list',
  'callout',
  'quote',
  'to_do',
]);

export function extractDescription(recordMap: ExtendedRecordMap, maxLength = 160): string {
  const pageBlock = Object.values(recordMap.block)
    .map((entry) => getBlockValue<Block>(entry))
    .find((block) => block?.type === 'page');

  if (!pageBlock?.content) return '';

  const textParts: string[] = [];

  for (const blockId of pageBlock.content) {
    const block = getBlockValue<Block>(recordMap.block[blockId]);
    if (!block || !TEXT_BLOCK_TYPES.has(block.type)) continue;

    const text = getTextContent(block.properties?.title);
    if (text) textParts.push(text);

    if (textParts.join(' ').length >= maxLength) break;
  }

  const fullText = textParts.join(' ').trim();
  if (!fullText) return '';
  if (fullText.length <= maxLength) return fullText;

  const truncated = fullText.slice(0, maxLength);
  const lastSpace = truncated.lastIndexOf(' ');
  return (lastSpace > maxLength * 0.7 ? truncated.slice(0, lastSpace) : truncated) + '...';
}
