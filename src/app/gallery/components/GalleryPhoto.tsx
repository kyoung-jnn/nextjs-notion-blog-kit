import Image, { StaticImageData } from 'next/image';

import GalleryCaption from './GalleryCaption';

import * as styles from './GalleryPhoto.css';

interface Props {
  src: StaticImageData;
  alt: string;
}

function GalleryPhoto({ src, alt }: Props) {
  return (
    <figure className={styles.figure}>
      <article className={styles.photo}>
        <Image
          src={src}
          fill
          alt={alt}
          style={{ objectFit: 'cover' }}
          placeholder="blur"
          sizes="(max-width: 768px) 100vw, (max-width: 1200px) 50vw, 33vw"
        />
      </article>
      <GalleryCaption>{alt}</GalleryCaption>
    </figure>
  );
}

export default GalleryPhoto;
