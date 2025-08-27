import Link from 'next/link';

import ArticleCard from '@/components/ArticleCard';
import { PostProperty } from '@/types/notion';

interface Props {
  posts: PostProperty[];
}

function ArticleCardList({ posts }: Props) {
  return (
    <ul className="mt-4 mb-4 grid gap-[10px]">
      {!posts.length && '포스팅이 존재하지 않습니다. 🥹'}
      {posts.map(({ title, date, slug }) => {
        return (
          <li key={slug}>
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
