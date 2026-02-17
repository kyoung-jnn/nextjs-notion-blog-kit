import { SITE_CONFIG } from '@/config';

function Footer() {
  return (
    <footer className="text-gray-12 dark:text-gray-11 flex justify-center py-[40px] text-[14px]">
      {`${SITE_CONFIG.author.enName} © ${new Date().getFullYear()}`}
    </footer>
  );
}

export default Footer;
