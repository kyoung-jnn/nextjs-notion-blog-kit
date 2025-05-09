import { Metadata } from 'next';
import { StaticImageData } from 'next/image';

import { METADATA, OPEN_GRAPH } from '@/config/metadataConfig';
import SITE_CONFIG from '@/config/siteConfig';

import GalleryPhoto from './components/GalleryPhoto';
import GalleryVideo from './components/GalleryVideo';
import GALLERY_LIST from './database';

export const metadata: Metadata = {
  ...METADATA,
  title: `Gallery • ${SITE_CONFIG.title}`,
  description: `일상 및 여행 사진 • ${SITE_CONFIG.description}`,
  openGraph: OPEN_GRAPH,
};

export default function GalleryPage() {
  return (
    <>
      {GALLERY_LIST?.map(({ type, src, alt }, index) => {
        if (type === 'image') {
          return (
            <GalleryPhoto key={index} src={src as StaticImageData} alt={alt} />
          );
        }
        return <GalleryVideo key={index} src={src as string} alt={alt} />;
      })}
    </>
  );
}
