import { getPosts } from '@/api/notion';
import ArticleCardList from '@/components/ArticleCardList';


import * as styles from './HomeArticleCardList.css';

const TOTAL_POST = 7;

async function HomeArticleCardList() {
  const posts = await getPosts();
  const latestPosts = posts.slice(0, TOTAL_POST);

  return (
    <div className={styles.wrapper}>
      <ArticleCardList posts={latestPosts} />
    </div>
  );
}

export default HomeArticleCardList;
