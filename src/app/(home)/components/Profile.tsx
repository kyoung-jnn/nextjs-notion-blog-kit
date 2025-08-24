import SITE_CONFIG from '@/config/siteConfig';

function Profile() {
  return (
    <section className="grid animate-[fade-up_0.5s_ease-in-out_forwards] gap-1 px-3 opacity-0">
      <h1 className="text-2xl text-gray-950">
        {SITE_CONFIG.author.enName} • {SITE_CONFIG.author.localeName}
      </h1>
      <p className="text-sm text-gray-950">{SITE_CONFIG.description}</p>
    </section>
  );
}

export default Profile;
