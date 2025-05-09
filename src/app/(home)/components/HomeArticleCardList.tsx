import { getPosts } from '@/api/notion';
import ArticleCardList from '@/components/ArticleCardList';
import { HOME_POSTS } from '@/constants';

import * as styles from './HomeArticleCardList.css';

async function HomeArticleCardList() {
  const posts = await getPosts();
  const latestPosts = posts.slice(0, HOME_POSTS);

  return (
    <div className={styles.wrapper}>
      <ArticleCardList posts={latestPosts} />
    </div>
  );
}

export default HomeArticleCardList;
