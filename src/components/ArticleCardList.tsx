import Link from 'next/link';

import ArticleCard from '@/components/ArticleCard';
import { PostProperty } from '@/types/notion';

interface Props {
  posts: PostProperty[];
}

function ArticleCardList({ posts }: Props) {
  return (
    <ul className="mt-4 mb-4 grid gap-[10px]">
      {!posts.length && 'No posts found.'}
      {posts.map(({ title, date, slug }, index) => {
        return (
          <li key={`${slug}-${index}`}>
            <Link href={`/article/${slug}`}>
              <ArticleCard title={title} date={date} />
            </Link>
          </li>
        );
      })}
    </ul>
  );
}

export default ArticleCardList;
