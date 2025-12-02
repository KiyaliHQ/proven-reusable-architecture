import type { BaseLayoutProps } from 'fumadocs-ui/layouts/shared';
import Image from 'next/image';
import { type Language, t } from './i18n';
import { CustomNav } from '@/components/CustomNav';

export function baseOptions(lang: Language = 'fr'): BaseLayoutProps {
  return {
    nav: {
      title: (
        <div className="flex flex-col">
          <Image
            src="/logo-bnc.svg"
            alt="Banque Nationale"
            width={155}
            height={50}
            className="h-8 w-auto"
          />
          <span className="text-[9px] font-medium text-gray-600 tracking-wider mt-0.5">
            PROVEN REUSABLE ARCHITECTURE
          </span>
        </div>
      ),
      url: `/${lang}`,
      transparentMode: 'none',
      // Language switcher after search bar in header
      children: <CustomNav lang={lang} />,
    },
    links: [
      {
        text: t(lang, 'nav.home'),
        url: `/${lang}`,
      },
      {
        text: t(lang, 'nav.catalogue'),
        url: `/${lang}/catalogue`,
      },
      {
        text: t(lang, 'nav.library'),
        url: `/${lang}/registre`,
      },
    ],
    // Disable dark mode - BNC branding is light mode only
    themeSwitch: {
      enabled: false,
    },
  };
}
