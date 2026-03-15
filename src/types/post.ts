export type Status = 'publish' | 'draft';

export interface PostMeta {
  title: string;
  date: string;
  slug: string;
  status: Status;
  thumbnail?: string;
  description: string;
  tags: string[];
}

export interface Post extends PostMeta {
  html: string;
}
