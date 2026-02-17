import { SITE_CONFIG } from '@/config';

type Props = {
  slug: string;
  title: string;
  description: string;
  image?: string;
  date: string;
  updatedAt: string;
};

function JsonLD({ slug, title, description, image, date, updatedAt }: Props) {
  const url = `${SITE_CONFIG.siteUrl}/article/${slug}`;
  const publishedAt = new Date(date).toISOString();
  const modifiedAt = new Date(updatedAt || date).toISOString();

  const articleJsonLd = {
    '@context': 'https://schema.org',
    '@type': 'BlogPosting',
    mainEntityOfPage: { '@type': 'WebPage', '@id': url },
    headline: title,
    description,
    ...(image && { image }),
    datePublished: publishedAt,
    dateModified: modifiedAt,

    author: [{ '@type': 'Person', name: SITE_CONFIG.author.localeName }],
    publisher: {
      '@type': 'Organization',
      name: SITE_CONFIG.author.localeName,
      ...(SITE_CONFIG.siteLogo && {
        logo: { '@type': 'ImageObject', url: SITE_CONFIG.siteLogo },
      }),
    },
  };

  const breadcrumbJsonLd = {
    '@context': 'https://schema.org',
    '@type': 'BreadcrumbList',
    itemListElement: [
      {
        '@type': 'ListItem',
        position: 1,
        name: 'Home',
        item: SITE_CONFIG.siteUrl || undefined,
      },
      {
        '@type': 'ListItem',
        position: 2,
        name: 'Articles',
        item: SITE_CONFIG.siteUrl ? `${SITE_CONFIG.siteUrl}/article/list/1` : undefined,
      },
      {
        '@type': 'ListItem',
        position: 3,
        name: title,
        item: url,
      },
    ],
  };

  return (
    <>
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(articleJsonLd) }}
      />
      <script
        type="application/ld+json"
        dangerouslySetInnerHTML={{ __html: JSON.stringify(breadcrumbJsonLd) }}
      />
    </>
  );
}

export default JsonLD;
