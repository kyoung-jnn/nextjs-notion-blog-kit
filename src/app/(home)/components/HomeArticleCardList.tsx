import { getPosts } from '@/api/notion';
import ArticleCardList from '@/components/ArticleCardList';
import { HOME_POSTS } from '@/constants';

async function HomeArticleCardList() {
  const posts = await getPosts();
  const latestPosts = posts.slice(0, HOME_POSTS);

  return (
    <div className="animate-fade-left-more-delayed opacity-0">
      <ArticleCardList posts={latestPosts} />
    </div>
  );
}

export default HomeArticleCardList;
