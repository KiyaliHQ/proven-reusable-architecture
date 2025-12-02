import { getGuideSource } from '@/lib/source';
import { DocsLayout } from 'fumadocs-ui/layouts/docs';
import { baseOptions } from '@/lib/layout.shared';
import { type Language } from '@/lib/i18n';
import { LanguageSwitcher } from '@/components/LanguageSwitcher';

export default async function Layout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ lang: Language }>;
}) {
  const { lang } = await params;
  const source = getGuideSource(lang);

  return (
    <DocsLayout
      tree={source.pageTree}
      {...baseOptions(lang)}
      sidebar={{
        banner: null,
        footer: (
          <div className="flex justify-center py-3 border-t border-gray-200">
            <LanguageSwitcher currentLang={lang} />
          </div>
        ),
      }}
    >
      {children}
    </DocsLayout>
  );
}
