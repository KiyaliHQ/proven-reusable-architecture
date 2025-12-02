export const languages = ['en', 'fr'] as const;
export type Language = (typeof languages)[number];

export const defaultLanguage: Language = 'fr';

export function isValidLanguage(lang: unknown): lang is Language {
  return languages.includes(lang as Language);
}

export const languageNames: Record<Language, string> = {
  en: 'English',
  fr: 'Français',
};

export const translations: Record<Language, Record<string, string>> = {
  en: {
    'nav.home': 'Home',
    'nav.catalogue': 'Browse',
    'nav.registry': 'Registry',
    'nav.library': 'Registry',
    'footer.copyright': '© 2024 Banque Nationale du Canada. All rights reserved.',
    'home.title': 'PRA Registry',
    'home.subtitle': 'Banque Nationale du Canada',
    'home.tagline': 'Proven Reusable Architecture',
    'home.description':
      'Library of production-validated architectures to accelerate your projects with quality and consistency',
    'home.browse': 'Browse PRAs',
    'home.browse.desc': 'Quick search and filtering',
    'home.registry': 'Explore Registry',
    'home.registry.desc': 'Complete documentation and guides',
    'home.getStarted': 'Getting Started Guide',
    'stats.approved': 'Approved PRAs',
    'stats.approved.desc': 'Validated in production (3+ implementations)',
    'stats.candidates': 'Candidate PRAs',
    'stats.candidates.desc': 'Under validation (1+ implementation)',
  },
  fr: {
    'nav.home': 'Accueil',
    'nav.catalogue': 'Parcourir',
    'nav.registry': 'Registre',
    'nav.library': 'Registre',
    'footer.copyright': '© 2024 Banque Nationale du Canada. Tous droits réservés.',
    'home.title': 'Registre PRA',
    'home.subtitle': 'Banque Nationale du Canada',
    'home.tagline': 'Proven Reusable Architecture',
    'home.description':
      "Bibliothèque d'architectures validées en production pour accélérer vos projets avec qualité et cohérence",
    'home.browse': 'Parcourir les PRAs',
    'home.browse.desc': 'Recherche et filtrage rapides',
    'home.registry': 'Explorer le Registre',
    'home.registry.desc': 'Documentation complète et guides',
    'home.getStarted': 'Guide de Démarrage',
    'stats.approved': 'PRAs Approuvés',
    'stats.approved.desc': 'Validés en production (3+ implémentations)',
    'stats.candidates': 'PRAs Candidats',
    'stats.candidates.desc': 'En cours de validation (1+ implémentation)',
  },
};

export function t(lang: Language, key: string): string {
  return translations[lang]?.[key] || key;
}
