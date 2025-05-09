import Link from 'next/link';

import ArticleCard from '@/components/ArticleCard';
import { PostProperty } from '@/types/notion';

import * as styles from './ArticleCardList.css';

interface Props {
  posts: PostProperty[];
}

function ArticleCardList({ posts }: Props) {
  return (
    <ul className={styles.list}>
      {!posts.length && '포스팅이 존재하지 않습니다. 🥹'}
      {posts.map(({ title, date, slug }) => {
        return (
          <li key={slug}>
            <Link href={`/posts/${slug}`}>
              <ArticleCard title={title} date={date} />
            </Link>
          </li>
        );
      })}
    </ul>
  );
}

export default ArticleCardList;
