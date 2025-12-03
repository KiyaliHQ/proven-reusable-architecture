import { getSource, getPRAMetadata } from '@/lib/source';
import CatalogueClient from './catalogue-client';
import { type Language } from '@/lib/i18n';

// Types pour les données PRA
export interface PRARow {
  slug: string;
  name: string;
  description: string;
  category: string;
  status: string;
  tags: string[];
  provenCount: number;
  updated: string;
  url: string;
  scope: 'bank-wide' | 'domaines';
  domaine?: string;
}

// Fonction serveur pour récupérer les PRAs
async function getAllPRAs(lang: Language): Promise<PRARow[]> {
  const source = getSource(lang);
  const pages = source.getPages();

  return pages
    .map((page) => {
      // Filtrer les pages de guides (01-getting-started, 02-understanding-pra, etc.)
      // et les pages index qui ne sont pas des PRAs
      const slug = page.slugs.join('/');
      if (
        slug.match(/^\d{2}-/) || // Pages de guides numérotées
        slug === 'index' ||
        slug === 'transversal' ||
        slug === 'secteurs' ||
        slug === 'en-promotion' ||
        slug.endsWith('/index')
      ) {
        return null;
      }

      const metadata = getPRAMetadata(page);
      if (!metadata) return null;

      // Extraire le scope et le domaine depuis le slug
      const slugParts = page.slugs;
      let scope: 'bank-wide' | 'domaines' = 'bank-wide';
      let domaine: string | undefined;

      if (slugParts.includes('transversal')) {
        scope = 'bank-wide';
      } else if (slugParts.includes('secteurs')) {
        scope = 'domaines';
        // Le domaine est juste après 'secteurs' dans le slug
        const domaineIndex = slugParts.indexOf('secteurs') + 1;
        if (domaineIndex < slugParts.length) {
          domaine = slugParts[domaineIndex];
        }
      } else if (slugParts.includes('en-promotion')) {
        // "en-promotion" est maintenant traité comme bank-wide
        scope = 'bank-wide';
      }

      return {
        slug: page.slugs.join('/'),
        name: metadata.name || page.data.title || 'Sans titre',
        description: page.data.description || '',
        category: metadata.category || 'tech',
        status: metadata.status || 'candidate',
        tags: metadata.tags || [],
        provenCount: metadata.proven_in_use?.length || 0,
        updated: metadata.updated_at || metadata.created_at || '',
        url: page.url,
        scope,
        domaine,
      };
    })
    .filter((pra): pra is PRARow => pra !== null);
}

// Server Component
export default async function CataloguePage({
  params,
}: {
  params: Promise<{ lang: Language }>;
}) {
  const { lang } = await params;
  const pras = await getAllPRAs(lang);

  return <CatalogueClient pras={pras} lang={lang} />;
}
