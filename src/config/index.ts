import blogConfig from '@/config/blog.config';

export { COMMENT_CONFIG } from '@/config/comment.config';
export { METADATA_CONFIG, METADATA_TWITTER_CONFIG } from '@/config/metadata.config';
export { MENU_LIST } from '@/config/navigation.config';
export { OPEN_GRAPH_CONFIG } from '@/config/opengraph.config';

export const SITE_CONFIG = {
  title: blogConfig.title,
  description: blogConfig.description,
  locale: blogConfig.locale,
  siteUrl: blogConfig.siteUrl,
  siteLogo: blogConfig.siteLogo,
  siteBanner: blogConfig.siteBanner,
  author: blogConfig.author,
};
