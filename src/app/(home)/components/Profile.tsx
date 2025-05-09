import SITE_CONFIG from '@/config/siteConfig';

import * as styles from './Profile.css';

function Profile() {
  return (
    <section className={styles.wrapper}>
      <h1 className={styles.name}>
        {SITE_CONFIG.author.enName} • {SITE_CONFIG.author.localeName}
      </h1>
      <p className={styles.desciption}>{SITE_CONFIG.description}</p>
    </section>
  );
}

export default Profile;
