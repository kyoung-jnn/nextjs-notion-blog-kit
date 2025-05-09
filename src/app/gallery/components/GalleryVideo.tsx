import GalleryCaption from './GalleryCaption';

import * as styles from './GalleryVideo.css';

interface Props {
  src: string;
  alt: string;
}

function GalleryVideo({ src, alt }: Props) {
  return (
    <div>
      <video loop autoPlay muted playsInline className={styles.video}>
        <source src={src} type="video/mp4" />
      </video>
      <GalleryCaption>{alt}</GalleryCaption>
    </div>
  );
}

export default GalleryVideo;
