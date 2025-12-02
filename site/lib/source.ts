import { guides_fr, guides_en, registre_fr, registre_en } from 'fumadocs-mdx:collections/server';
import { type InferPageType, loader } from 'fumadocs-core/source';
import { lucideIconsPlugin } from 'fumadocs-core/source/lucide-icons';
import type { Language } from './i18n';

// Guide sources
const guideSources = {
  en: loader({
    baseUrl: '/en/guides',
    source: guides_en.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
  fr: loader({
    baseUrl: '/fr/guides',
    source: guides_fr.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
};

// Registry (PRA) sources
const registreSources = {
  en: loader({
    baseUrl: '/en/registre',
    source: registre_en.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
  fr: loader({
    baseUrl: '/fr/registre',
    source: registre_fr.toFumadocsSource(),
    plugins: [lucideIconsPlugin()],
  }),
};

// Get guide source by language
export function getGuideSource(locale: Language) {
  return guideSources[locale] || guideSources.fr;
}

// Get registry source by language
export function getRegistreSource(locale: Language) {
  return registreSources[locale] || registreSources.fr;
}

// Backward compatibility - returns registry source
export function getSource(locale: Language) {
  return getRegistreSource(locale);
}

// Default source (backward compatibility)
export const source = registreSources.fr;

export function getPageImage(page: InferPageType<typeof source>) {
  const segments = [...page.slugs, 'image.png'];

  return {
    segments,
    url: `/og/registre/${segments.join('/')}`,
  };
}

export async function getLLMText(page: InferPageType<typeof source>) {
  const processed = await page.data.getText('processed');

  return `# ${page.data.title}

${processed}`;
}

// Types pour les métadonnées PRA
export interface PRAMetadata {
  id: string;
  name: string;
  category: 'tech' | 'integration' | 'security' | 'business';
  tags: string[];
  status: 'candidate' | 'approved' | 'deprecated';
  version: string;
  proven_in_use: ProvenInUse[];
  created_at?: string;
  updated_at?: string;
}

export interface ProvenInUse {
  project: string;
  team: string;
  date: string;
  feedback: string;
}

// Helper pour extraire les métadonnées d'un PRA
export function getPRAMetadata(page: any): PRAMetadata | null {
  if (!page.data) return null;

  return {
    id: page.data.id || '',
    name: page.data.name || page.data.title || '',
    category: page.data.category || 'tech',
    tags: page.data.tags || [],
    status: page.data.status || 'candidate',
    version: page.data.version || '1.0.0',
    proven_in_use: page.data.proven_in_use || [],
    created_at: page.data.created_at,
    updated_at: page.data.updated_at,
  };
}

// Helper pour filtrer les PRAs par catégorie
export function getPRAsByCategory(category: string) {
  const pages = source.getPages();
  return pages.filter((page) => {
    const metadata = getPRAMetadata(page);
    return metadata?.category === category;
  });
}

// Helper pour filtrer les PRAs par statut
export function getPRAsByStatus(status: string) {
  const pages = source.getPages();
  return pages.filter((page) => {
    const metadata = getPRAMetadata(page);
    return metadata?.status === status;
  });
}

// Helper pour obtenir tous les tags uniques
export function getAllTags(): string[] {
  const pages = source.getPages();
  const tagsSet = new Set<string>();

  pages.forEach((page) => {
    const metadata = getPRAMetadata(page);
    metadata?.tags.forEach((tag) => tagsSet.add(tag));
  });

  return Array.from(tagsSet).sort();
}

// Helper pour obtenir toutes les catégories
export function getAllCategories() {
  return ['tech', 'integration', 'security', 'business'] as const;
}

// Helper pour compter les PRAs par statut
export function getPRAStats() {
  const pages = source.getPages();
  const stats = {
    approved: 0,
    candidates: 0,
    total: pages.length,
  };

  pages.forEach((page) => {
    const metadata = getPRAMetadata(page);
    if (metadata?.status === 'approved') stats.approved++;
    if (metadata?.status === 'candidate') stats.candidates++;
  });

  return stats;
}
