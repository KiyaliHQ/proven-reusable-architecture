import { getSource } from '@/lib/source';
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
  const source = getSource(lang);

  return (
    <DocsLayout
      tree={source.pageTree}
      {...baseOptions(lang)}
      sidebar={{
        // Hide nav.children in sidebar by setting banner to null
        banner: null,
        footer: (
          <div className="p-4 border-t border-gray-200">
            <LanguageSwitcher currentLang={lang} />
          </div>
        ),
      }}
    >
      {children}
    </DocsLayout>
  );
}
