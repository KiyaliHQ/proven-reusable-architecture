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

      // Extraire le scope, le domaine, la catégorie et le statut depuis le slug
      // Nouvelle structure: bank-wide/<category>/<status>/<pra-name>
      // ou: domain-wide/<domain>/<category>/<status>/<pra-name>
      const slugParts = page.slugs;
      let scope: 'bank-wide' | 'domaines' = 'bank-wide';
      let domaine: string | undefined;
      let categoryFromPath: string | undefined;
      let statusFromPath: string | undefined;

      if (slugParts.includes('bank-wide')) {
        scope = 'bank-wide';
        const bankWideIndex = slugParts.indexOf('bank-wide');
        // Nouvelle structure: bank-wide/<category>/<status>/<pra>
        // La catégorie est 1 position après 'bank-wide'
        if (bankWideIndex + 1 < slugParts.length) {
          categoryFromPath = slugParts[bankWideIndex + 1];
        }
        // Le statut est 2 positions après 'bank-wide'
        if (bankWideIndex + 2 < slugParts.length) {
          statusFromPath = slugParts[bankWideIndex + 2];
        }
      } else if (slugParts.includes('domain-wide')) {
        scope = 'domaines';
        const domainWideIndex = slugParts.indexOf('domain-wide');
        // Nouvelle structure: domain-wide/<domain>/<category>/<status>/<pra>
        // Le domaine est 1 position après 'domain-wide'
        if (domainWideIndex + 1 < slugParts.length) {
          domaine = slugParts[domainWideIndex + 1];
        }
        // La catégorie est 2 positions après 'domain-wide'
        if (domainWideIndex + 2 < slugParts.length) {
          categoryFromPath = slugParts[domainWideIndex + 2];
        }
        // Le statut est 3 positions après 'domain-wide'
        if (domainWideIndex + 3 < slugParts.length) {
          statusFromPath = slugParts[domainWideIndex + 3];
        }
      }

      // Utiliser les valeurs extraites du chemin si disponibles (plus fiables)
      // sinon utiliser les métadonnées du frontmatter
      const finalCategory = categoryFromPath || metadata.category || 'technology';
      const finalStatus = statusFromPath || metadata.status || 'operationalizing';

      return {
        slug: page.slugs.join('/'),
        name: metadata.name || page.data.title || 'Sans titre',
        description: page.data.description || '',
        category: finalCategory,
        status: finalStatus,
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
