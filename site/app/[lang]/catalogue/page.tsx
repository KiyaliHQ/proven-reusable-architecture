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

      // Extraire le scope, le domaine et la catégorie depuis le slug
      // Structure: bank-wide/candidate/<category>/<pra-name>
      // ou: domain-wide/<domain>/candidate/<category>/<pra-name>
      const slugParts = page.slugs;
      let scope: 'bank-wide' | 'domaines' = 'bank-wide';
      let domaine: string | undefined;
      let categoryFromPath: string | undefined;

      if (slugParts.includes('bank-wide')) {
        scope = 'bank-wide';
        // Extraire la catégorie: bank-wide/candidate/<category>/...
        const bankWideIndex = slugParts.indexOf('bank-wide');
        // La catégorie est 2 positions après 'bank-wide' (après candidate/approved)
        if (bankWideIndex + 2 < slugParts.length) {
          categoryFromPath = slugParts[bankWideIndex + 2];
        }
      } else if (slugParts.includes('domain-wide')) {
        scope = 'domaines';
        // Le domaine est juste après 'domain-wide' dans le slug
        const domainWideIndex = slugParts.indexOf('domain-wide');
        if (domainWideIndex + 1 < slugParts.length) {
          domaine = slugParts[domainWideIndex + 1];
        }
        // La catégorie est 3 positions après 'domain-wide' (après <domain>/candidate)
        if (domainWideIndex + 3 < slugParts.length) {
          categoryFromPath = slugParts[domainWideIndex + 3];
        }
      }

      // Utiliser categoryFromPath si disponible (plus fiable car extrait du chemin)
      // sinon utiliser metadata.category (du frontmatter)
      const finalCategory = categoryFromPath || metadata.category || 'technology';

      return {
        slug: page.slugs.join('/'),
        name: metadata.name || page.data.title || 'Sans titre',
        description: page.data.description || '',
        category: finalCategory,
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
