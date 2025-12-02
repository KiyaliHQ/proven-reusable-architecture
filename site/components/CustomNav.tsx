'use client';

import { LanguageSwitcher } from './LanguageSwitcher';
import { type Language } from '@/lib/i18n';

export function CustomNav({ lang }: { lang: Language }) {
  return (
    <div className="flex items-center gap-4 order-last ml-auto fd-not-sidebar">
      <LanguageSwitcher currentLang={lang} />
    </div>
  );
}
