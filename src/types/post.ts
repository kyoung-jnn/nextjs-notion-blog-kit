export interface PostMeta {
  title: string;
  date: string;
  slug: string;
  published: boolean;
  thumbnail?: string;
  description: string;
  tags: string[];
}

export interface Post extends PostMeta {
  html: string;
}
