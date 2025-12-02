'use client';

import { usePathname } from 'next/navigation';
import Link from 'next/link';
import { languages, languageNames, type Language } from '@/lib/i18n';

export function LanguageSwitcher({ currentLang }: { currentLang: Language }) {
  const pathname = usePathname();

  // Generate URL for switching language
  const getSwitchUrl = (newLang: Language) => {
    // Remove current language from pathname
    const pathWithoutLang = pathname.replace(/^\/(en|fr)/, '');
    return `/${newLang}${pathWithoutLang || ''}`;
  };

  return (
    <div className="flex items-center gap-2 border border-gray-300 rounded px-2 py-1">
      {languages.map((lang) => (
        <Link
          key={lang}
          href={getSwitchUrl(lang)}
          className={`text-xs font-medium px-2 py-1 rounded transition-colors ${
            currentLang === lang
              ? 'bg-gray-900 text-white'
              : 'text-gray-600 hover:text-gray-900 hover:bg-gray-100'
          }`}
          aria-label={`Switch to ${languageNames[lang]}`}
        >
          {lang.toUpperCase()}
        </Link>
      ))}
    </div>
  );
}
