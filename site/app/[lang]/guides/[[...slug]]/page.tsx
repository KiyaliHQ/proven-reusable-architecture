import { getGuideSource } from '@/lib/source';
import {
  DocsBody,
  DocsDescription,
  DocsPage,
  DocsTitle,
} from 'fumadocs-ui/page';
import { notFound } from 'next/navigation';
import { getMDXComponents } from '@/mdx-components';
import type { Metadata } from 'next';
import { createRelativeLink } from 'fumadocs-ui/mdx';
import { type Language } from '@/lib/i18n';

export default async function Page({
  params,
}: {
  params: Promise<{ lang: Language; slug?: string[] }>;
}) {
  const { lang, slug } = await params;
  const source = getGuideSource(lang);
  const page = source.getPage(slug);

  if (!page) notFound();

  const MDX = page.data.body;

  return (
    <DocsPage toc={page.data.toc} full={page.data.full}>
      <DocsTitle>{page.data.title}</DocsTitle>
      <DocsDescription>{page.data.description}</DocsDescription>
      <DocsBody>
        <MDX
          components={getMDXComponents({
            a: createRelativeLink(source, page),
          })}
        />
      </DocsBody>
    </DocsPage>
  );
}

export async function generateStaticParams() {
  const frSource = getGuideSource('fr');
  const enSource = getGuideSource('en');

  return [
    ...frSource.generateParams().map((params) => ({
      lang: 'fr' as const,
      ...params,
    })),
    ...enSource.generateParams().map((params) => ({
      lang: 'en' as const,
      ...params,
    })),
  ];
}

export async function generateMetadata({
  params,
}: {
  params: Promise<{ lang: Language; slug?: string[] }>;
}): Promise<Metadata> {
  const { lang, slug } = await params;
  const source = getGuideSource(lang);
  const page = source.getPage(slug);

  if (!page) notFound();

  return {
    title: page.data.title,
    description: page.data.description,
  };
}
