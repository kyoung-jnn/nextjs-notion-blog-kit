import SITE_CONFIG from '@/config/siteConfig';

function Footer() {
  return (
    <footer className="flex justify-center py-[40px] text-[14px] text-gray-950">
      {SITE_CONFIG.author.enName + ` © 2025`}
    </footer>
  );
}

export default Footer;
