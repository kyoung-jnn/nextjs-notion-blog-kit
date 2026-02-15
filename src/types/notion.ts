import { ExtendedRecordMap } from 'notion-types';

export type Status = 'publish' | 'draft';

export interface PostProperty {
  id: string;
  date: string;
  slug: string;
  status: Status;
  summary: string;
  tags?: string;
  thumbnail?: string;
  title: string;
}

export interface Post extends PostProperty {
  body: ExtendedRecordMap;
}
