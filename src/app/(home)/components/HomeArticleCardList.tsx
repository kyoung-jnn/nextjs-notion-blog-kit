import ArticleCardList from '@/components/ArticleCardList';
import { HOME_POSTS } from '@/constants';
import { getAllPosts } from '@/lib/content';

async function HomeArticleCardList() {
  const posts = await getAllPosts();
  const latestPosts = posts.slice(0, HOME_POSTS);

  return (
    <div className="animate-[fade-left_0.8s_0.4s_forwards] opacity-0">
      <ArticleCardList posts={latestPosts} />
    </div>
  );
}

export default HomeArticleCardList;
