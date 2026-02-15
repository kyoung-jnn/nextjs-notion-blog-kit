import SITE_CONFIG from '@/config/siteConfig';

function Profile() {
  return (
    <section className="grid animate-[fade-up_0.6s_forwards] gap-1 px-3 opacity-0">
      <h1 className="text-gray-12 dark:text-gray-12 text-2xl font-bold">
        {SITE_CONFIG.author.enName} • {SITE_CONFIG.author.localeName}
      </h1>
      <p className="text-gray-9 dark:text-gray-11 text-sm font-medium">
        {SITE_CONFIG.description}
      </p>
    </section>
  );
}

export default Profile;
