import SITE_CONFIG from '@/config/siteConfig';

import * as styles from './Footer.css';

function Footer() {
  return (
    <footer className={styles.wrapper}>
      {SITE_CONFIG.author.enName + ` © 2025`}
    </footer>
  );
}

export default Footer;
