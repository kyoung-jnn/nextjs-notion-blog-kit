import { PropsWithChildren } from 'react';

import * as styles from './GalleryCaption.css';

function GalleryCaption({ children }: PropsWithChildren) {
  return <figcaption className={styles.wrapper}>{children}</figcaption>;
}

export default GalleryCaption;
