import { getSource } from '@/lib/source';
import { DocsLayout } from 'fumadocs-ui/layouts/docs';
import { baseOptions } from '@/lib/layout.shared';
import { type Language } from '@/lib/i18n';

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
    <DocsLayout tree={source.pageTree} {...baseOptions(lang)}>
      {children}
    </DocsLayout>
  );
}
