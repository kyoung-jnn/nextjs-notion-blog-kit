import { cache } from 'react';

import { NotionAPI } from 'notion-client';
import {
  Block,
  BlockMap,
  Collection,
  CollectionPropertySchemaMap,
  ExtendedRecordMap,
  ID,
} from 'notion-types';
import { getBlockValue, getDateValue, getTextContent } from 'notion-utils';

import { PostProperty, Status } from '@/types/notion';

const notionAPI = new NotionAPI();

const DEFAULT_POST_PROPERTY: PostProperty = {
  id: '',
  date: '',
  slug: '',
  status: 'draft',
  summary: '',
  title: '',
};

export const getPageIds = (response: ExtendedRecordMap): ID[] => {
  const results: ID[] = [];

  const collectionQuery = Object.values(response.collection_query)[0];
  if (!collectionQuery) return results;

  Object.values(collectionQuery).forEach((view) => {
    view?.collection_group_results?.blockIds?.forEach((id: ID) =>
      results.push(id),
    );
  });

  return results;
};

const VALID_STATUSES: Status[] = ['publish', 'draft'];

export const getPageProperty = (
  id: string,
  blockMap: BlockMap,
  schema: CollectionPropertySchemaMap,
): PostProperty => {
  const block = getBlockValue<Block>(blockMap[id]);
  const properties = block?.properties;

  if (!properties) {
    return { ...DEFAULT_POST_PROPERTY, id };
  }

  const result: PostProperty = { ...DEFAULT_POST_PROPERTY, id };

  Object.entries(properties).forEach(([key, value]) => {
    const schemaItem = schema[key];
    if (!schemaItem) return;

    const { type, name } = schemaItem;

    switch (type) {
      case 'file': {
        break;
      }
      case 'date': {
        const dateProperty = getDateValue(
          value as Parameters<typeof getDateValue>[0],
        );
        if (name === 'date') {
          result.date = dateProperty?.start_date ?? '';
        }
        break;
      }
      default: {
        const textContent = getTextContent(
          value as Parameters<typeof getTextContent>[0],
        );
        if (name === 'slug') {
          result.slug = textContent.trim().replace(/\s+/g, '-');
        } else if (name === 'status') {
          result.status = VALID_STATUSES.includes(textContent as Status)
            ? (textContent as Status)
            : 'draft';
        } else if (name === 'summary') {
          result.summary = textContent;
        } else if (name === 'title') {
          result.title = textContent;
        } else if (name === 'tags') {
          result.tags = textContent;
        } else if (name === 'thumbnail') {
          result.thumbnail = textContent;
        }
        break;
      }
    }
  });

  return result;
};

const _getPosts = async (): Promise<PostProperty[]> => {
  const notionPageId = process.env.NOTION_PAGE;
  if (!notionPageId) {
    console.warn('NOTION_PAGE environment variable is not configured');
    return [];
  }

  try {
    const response = await notionAPI.getPage(notionPageId);

    const blockMap = response.block;
    const collection = getBlockValue<Collection>(
      Object.values(response.collection)[0],
    );
    const schema = collection?.schema;

    if (!schema) {
      console.warn('Failed to retrieve Notion database schema');
      return [];
    }

    const pageIds = getPageIds(response);
    const properties = pageIds.map((id) => {
      return getPageProperty(id, blockMap, schema);
    });

    const publishedPosts = properties.filter((page) =>
      process.env.NODE_ENV === 'production' ? page.status === 'publish' : true,
    );
    return publishedPosts;
  } catch (error) {
    console.error(
      `Failed to fetch posts from Notion: ${error instanceof Error ? error.message : 'Unknown error'}`,
    );
    return [];
  }
};

export const getPosts = cache(_getPosts);

export const getPost = async (pageId: ID): Promise<ExtendedRecordMap> => {
  try {
    const recordMap = await notionAPI.getPage(pageId);
    return recordMap;
  } catch (error) {
    throw new Error(
      `Failed to fetch post "${pageId}": ${error instanceof Error ? error.message : 'Unknown error'}`,
    );
  }
};
