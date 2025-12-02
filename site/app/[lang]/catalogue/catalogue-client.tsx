'use client';

import { useState, useMemo, useEffect } from 'react';
import Link from 'next/link';
import { create, search, insertMultiple } from '@orama/orama';
import { type Language } from '@/lib/i18n';

// Translation helper
const translations = {
  fr: {
    title: 'Catalogue des PRAs',
    found: (count: number) => `${count} PRA${count > 1 ? 's' : ''} trouvé${count > 1 ? 's' : ''}`,
    searchPlaceholder: 'Rechercher par nom, description, tags...',
    showFilters: 'Afficher les filtres',
    hideFilters: 'Masquer les filtres',
    scope: 'Scope',
    secteur: 'Secteur',
    category: 'Catégorie',
    status: 'Statut',
    all: 'Tous',
    allFeminine: 'Toutes',
    transversal: 'Transversal',
    secteurs: 'Secteurs',
    enPromotion: 'En Promotion',
    particuliers: 'Particuliers',
    entreprises: 'Entreprises',
    gestionPatrimoine: 'Gestion de Patrimoine',
    tech: 'Tech',
    integration: 'Integration',
    security: 'Security',
    business: 'Business',
    approved: 'Approved',
    candidate: 'Candidate',
    deprecated: 'Deprecated',
    name: 'Nom',
    description: 'Description',
    proven: 'Proven',
    noResults: 'Aucun PRA trouvé avec ces critères',
    page: 'Page',
    of: 'sur',
    results: (count: number) => `${count} résultat${count > 1 ? 's' : ''}`,
    previous: 'Précédent',
    next: 'Suivant',
    helpTitle: 'Aide',
    helpFilter: 'Utilisez les filtres pour affiner votre recherche par scope, secteur, catégorie ou statut',
    helpSort: 'Cliquez sur les en-têtes de colonnes pour trier les résultats',
    helpClick: 'Cliquez sur une ligne pour accéder à la documentation complète du PRA',
  },
  en: {
    title: 'PRA Catalogue',
    found: (count: number) => `${count} PRA${count > 1 ? 's' : ''} found`,
    searchPlaceholder: 'Search by name, description, tags...',
    showFilters: 'Show filters',
    hideFilters: 'Hide filters',
    scope: 'Scope',
    secteur: 'Sector',
    category: 'Category',
    status: 'Status',
    all: 'All',
    allFeminine: 'All',
    transversal: 'Transversal',
    secteurs: 'Sectors',
    enPromotion: 'In Promotion',
    particuliers: 'Retail',
    entreprises: 'Corporate',
    gestionPatrimoine: 'Wealth Management',
    tech: 'Tech',
    integration: 'Integration',
    security: 'Security',
    business: 'Business',
    approved: 'Approved',
    candidate: 'Candidate',
    deprecated: 'Deprecated',
    name: 'Name',
    description: 'Description',
    proven: 'Proven',
    noResults: 'No PRA found with these criteria',
    page: 'Page',
    of: 'of',
    results: (count: number) => `${count} result${count > 1 ? 's' : ''}`,
    previous: 'Previous',
    next: 'Next',
    helpTitle: 'Help',
    helpFilter: 'Use filters to refine your search by scope, sector, category or status',
    helpSort: 'Click on column headers to sort results',
    helpClick: 'Click on a row to access the complete PRA documentation',
  },
};

interface PRARow {
  slug: string;
  name: string;
  description: string;
  category: string;
  status: string;
  tags: string[];
  provenCount: number;
  updated: string;
  url: string;
  scope: 'transversal' | 'secteurs' | 'en-promotion';
  secteur?: string;
}

type Category = 'all' | 'tech' | 'integration' | 'security' | 'business';
type Status = 'all' | 'approved' | 'candidate' | 'deprecated';
type Scope = 'all' | 'transversal' | 'secteurs' | 'en-promotion';
type Secteur = 'all' | 'particuliers' | 'entreprises' | 'gestion-patrimoine';
type SortKey = 'name' | 'category' | 'status' | 'updated' | 'scope';
type SortDirection = 'asc' | 'desc';

const ITEMS_PER_PAGE = 20;

const CATEGORY_LABELS: Record<Exclude<Category, 'all'>, string> = {
  tech: 'Tech',
  integration: 'Integration',
  security: 'Security',
  business: 'Business',
};

const STATUS_LABELS: Record<Exclude<Status, 'all'>, string> = {
  approved: 'Approved',
  candidate: 'Candidate',
  deprecated: 'Deprecated',
};

const SCOPE_LABELS: Record<Exclude<Scope, 'all'>, string> = {
  transversal: 'Transversal',
  secteurs: 'Secteurs',
  'en-promotion': 'En Promotion',
};

const SECTEUR_LABELS: Record<Exclude<Secteur, 'all'>, string> = {
  particuliers: 'Particuliers',
  entreprises: 'Entreprises',
  'gestion-patrimoine': 'Gestion de Patrimoine',
};

export default function CatalogueClient({ pras, lang }: { pras: PRARow[]; lang: Language }) {
  const t = translations[lang];
  const [searchQuery, setSearchQuery] = useState('');
  const [categoryFilter, setCategoryFilter] = useState<Category>('all');
  const [statusFilter, setStatusFilter] = useState<Status>('all');
  const [scopeFilter, setScopeFilter] = useState<Scope>('all');
  const [secteurFilter, setSecteurFilter] = useState<Secteur>('all');
  const [sortKey, setSortKey] = useState<SortKey>('name');
  const [sortDirection, setSortDirection] = useState<SortDirection>('asc');
  const [currentPage, setCurrentPage] = useState(1);
  const [showFilters, setShowFilters] = useState(false);
  const [oramaDB, setOramaDB] = useState<any>(null);
  const [searchResults, setSearchResults] = useState<string[]>([]);

  // Initialize Orama database
  useEffect(() => {
    async function initOrama() {
      const db = await create({
        schema: {
          slug: 'string',
          name: 'string',
          description: 'string',
          tags: 'string[]',
        },
      });

      await insertMultiple(
        db,
        pras.map((pra) => ({
          slug: pra.slug,
          name: pra.name,
          description: pra.description,
          tags: pra.tags,
        }))
      );

      setOramaDB(db);
    }

    initOrama();
  }, [pras]);

  // Perform Orama search when query changes
  useEffect(() => {
    async function performSearch() {
      if (!oramaDB || !searchQuery.trim()) {
        setSearchResults([]);
        return;
      }

      const results = await search(oramaDB, {
        term: searchQuery,
        properties: ['name', 'description', 'tags'],
        tolerance: 1,
        boost: {
          name: 2,
          description: 1,
          tags: 1.5,
        },
      });

      setSearchResults(results.hits.map((hit: any) => hit.document.slug));
    }

    performSearch();
  }, [searchQuery, oramaDB]);

  // Extraire les secteurs uniques des données
  const availableSecteurs = useMemo(() => {
    const secteurs = new Set<string>();
    pras.forEach((pra) => {
      if (pra.secteur) secteurs.add(pra.secteur);
    });
    return Array.from(secteurs).sort();
  }, [pras]);

  // Filtrage et tri
  const filteredAndSortedPRAs = useMemo(() => {
    let result = [...pras];

    // Filtre par recherche Orama
    if (searchQuery.trim()) {
      // Si on a une requête de recherche, filtrer les résultats
      // Si searchResults est vide, aucun PRA ne matchera (comportement attendu)
      result = result.filter((pra) => searchResults.includes(pra.slug));
    }

    // Filtre par scope
    if (scopeFilter !== 'all') {
      result = result.filter((pra) => pra.scope === scopeFilter);
    }

    // Filtre par secteur (seulement si scope = secteurs)
    if (secteurFilter !== 'all' && scopeFilter === 'secteurs') {
      result = result.filter((pra) => pra.secteur === secteurFilter);
    }

    // Filtre par catégorie
    if (categoryFilter !== 'all') {
      result = result.filter((pra) => pra.category === categoryFilter);
    }

    // Filtre par statut
    if (statusFilter !== 'all') {
      result = result.filter((pra) => pra.status === statusFilter);
    }

    // Tri
    result.sort((a, b) => {
      let comparison = 0;
      switch (sortKey) {
        case 'name':
          comparison = a.name.localeCompare(b.name);
          break;
        case 'category':
          comparison = a.category.localeCompare(b.category);
          break;
        case 'status':
          comparison = a.status.localeCompare(b.status);
          break;
        case 'scope':
          comparison = a.scope.localeCompare(b.scope);
          break;
        case 'updated':
          comparison = (a.updated || '').localeCompare(b.updated || '');
          break;
      }
      return sortDirection === 'asc' ? comparison : -comparison;
    });

    return result;
  }, [pras, searchQuery, searchResults, categoryFilter, statusFilter, scopeFilter, secteurFilter, sortKey, sortDirection]);

  // Pagination
  const totalPages = Math.ceil(filteredAndSortedPRAs.length / ITEMS_PER_PAGE);
  const paginatedPRAs = filteredAndSortedPRAs.slice(
    (currentPage - 1) * ITEMS_PER_PAGE,
    currentPage * ITEMS_PER_PAGE
  );

  // Reset page quand les filtres changent
  const handleFilterChange = () => {
    setCurrentPage(1);
  };

  // Toggle sort
  const handleSort = (key: SortKey) => {
    if (sortKey === key) {
      setSortDirection(sortDirection === 'asc' ? 'desc' : 'asc');
    } else {
      setSortKey(key);
      setSortDirection('asc');
    }
  };

  // Badge helpers
  const getCategoryBadge = (category: string) => {
    return (
      <span className="px-2.5 py-1 text-xs font-medium text-gray-700 bg-gray-100 border border-gray-300 rounded whitespace-nowrap">
        {CATEGORY_LABELS[category as Exclude<Category, 'all'>] || category}
      </span>
    );
  };

  const getStatusBadge = (status: string) => {
    const styles: Record<string, string> = {
      approved: 'text-green-700 bg-green-50 border-green-300',
      candidate: 'text-blue-700 bg-blue-50 border-blue-300',
      deprecated: 'text-red-700 bg-red-50 border-red-300',
    };
    return (
      <span className={`px-2.5 py-1 text-xs font-medium border rounded whitespace-nowrap ${styles[status] || 'text-gray-700 bg-gray-100 border-gray-300'}`}>
        {STATUS_LABELS[status as Exclude<Status, 'all'>] || status}
      </span>
    );
  };

  const getScopeBadge = (scope: string) => {
    return (
      <span className="px-2.5 py-1 text-xs font-medium text-gray-700 bg-gray-100 border border-gray-300 rounded whitespace-nowrap">
        {SCOPE_LABELS[scope as Exclude<Scope, 'all'>] || scope}
      </span>
    );
  };

  const getSecteurBadge = (secteur?: string) => {
    if (!secteur) return <span className="text-xs text-gray-400">-</span>;
    return (
      <span className="px-2.5 py-1 text-xs font-medium text-gray-700 bg-blue-50 border border-blue-300 rounded whitespace-nowrap">
        {SECTEUR_LABELS[secteur as Exclude<Secteur, 'all'>] || secteur}
      </span>
    );
  };

  return (
    <div className="min-h-screen bg-white pt-16 pb-12 px-4">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-4 pb-4 border-b border-gray-200">
          <h1 className="text-2xl font-semibold text-gray-900 mb-1">{t.title}</h1>
          <p className="text-sm text-gray-600">
            {t.found(filteredAndSortedPRAs.length)}
          </p>
        </div>

        {/* Search Bar - Central */}
        <div className="max-w-2xl mx-auto mb-4">
          <input
            type="search"
            placeholder={t.searchPlaceholder}
            value={searchQuery}
            onChange={(e) => {
              setSearchQuery(e.target.value);
              handleFilterChange();
            }}
            className="w-full px-4 py-2.5 border border-gray-300 rounded text-sm focus:outline-none focus:ring-2 focus:ring-gray-400 focus:border-gray-400"
          />
        </div>

        {/* Filters Toggle Button */}
        <div className="flex justify-center mb-4">
          <button
            onClick={() => setShowFilters(!showFilters)}
            className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50 flex items-center gap-2"
          >
            {showFilters ? t.hideFilters : t.showFilters}
            <span className="text-gray-500">{showFilters ? '▲' : '▼'}</span>
          </button>
        </div>

        {/* Collapsible Filters */}
        {showFilters && (
          <div className="bg-gray-50 border border-gray-300 rounded p-6 mb-4">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
              {/* Scope Filter */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">{t.scope}</label>
              <select
                value={scopeFilter}
                onChange={(e) => {
                  setScopeFilter(e.target.value as Scope);
                  setSecteurFilter('all'); // Reset secteur quand on change de scope
                  handleFilterChange();
                }}
                className="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-gray-400 focus:border-gray-400"
              >
                <option value="all">{t.all}</option>
                <option value="transversal">{t.transversal}</option>
                <option value="secteurs">{t.secteurs}</option>
                <option value="en-promotion">{t.enPromotion}</option>
              </select>
            </div>

            {/* Secteur Filter (only if scope = secteurs) */}
            {scopeFilter === 'secteurs' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">{t.secteur}</label>
                <select
                  value={secteurFilter}
                  onChange={(e) => {
                    setSecteurFilter(e.target.value as Secteur);
                    handleFilterChange();
                  }}
                  className="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-gray-400 focus:border-gray-400"
                >
                  <option value="all">{t.all}</option>
                  {availableSecteurs.map((secteur) => (
                    <option key={secteur} value={secteur}>
                      {t[secteur as keyof typeof t] || secteur}
                    </option>
                  ))}
                </select>
              </div>
            )}

            {/* Category Filter */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">{t.category}</label>
              <select
                value={categoryFilter}
                onChange={(e) => {
                  setCategoryFilter(e.target.value as Category);
                  handleFilterChange();
                }}
                className="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-gray-400 focus:border-gray-400"
              >
                <option value="all">{t.allFeminine}</option>
                <option value="tech">{t.tech}</option>
                <option value="integration">{t.integration}</option>
                <option value="security">{t.security}</option>
                <option value="business">{t.business}</option>
              </select>
            </div>

            {/* Status Filter */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">{t.status}</label>
              <select
                value={statusFilter}
                onChange={(e) => {
                  setStatusFilter(e.target.value as Status);
                  handleFilterChange();
                }}
                className="w-full px-3 py-2 border border-gray-300 rounded text-sm focus:outline-none focus:ring-1 focus:ring-gray-400 focus:border-gray-400"
              >
                <option value="all">{t.all}</option>
                <option value="approved">{t.approved}</option>
                <option value="candidate">{t.candidate}</option>
                <option value="deprecated">{t.deprecated}</option>
              </select>
            </div>
            </div>
          </div>
        )}

        {/* Table */}
        <div className="bg-white border border-gray-300 rounded overflow-hidden mb-4">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gray-50 border-b border-gray-300">
                <tr>
                  <th
                    className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                    onClick={() => handleSort('name')}
                  >
                    <div className="flex items-center gap-1">
                      {t.name}
                      {sortKey === 'name' && <span className="text-gray-500">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    {t.description}
                  </th>
                  <th
                    className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                    onClick={() => handleSort('scope')}
                  >
                    <div className="flex items-center gap-1">
                      {t.scope}
                      {sortKey === 'scope' && <span className="text-gray-500">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    {t.secteur}
                  </th>
                  <th
                    className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                    onClick={() => handleSort('category')}
                  >
                    <div className="flex items-center gap-1">
                      {t.category}
                      {sortKey === 'category' && <span className="text-gray-500">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th
                    className="px-6 py-3 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-100"
                    onClick={() => handleSort('status')}
                  >
                    <div className="flex items-center gap-1">
                      {t.status}
                      {sortKey === 'status' && <span className="text-gray-500">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th className="px-6 py-3 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    {t.proven}
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-200 bg-white">
                {paginatedPRAs.length === 0 ? (
                  <tr>
                    <td colSpan={7} className="px-6 py-12 text-center text-gray-500 text-sm">
                      {t.noResults}
                    </td>
                  </tr>
                ) : (
                  paginatedPRAs.map((pra) => (
                    <tr
                      key={pra.slug}
                      className="hover:bg-gray-50 cursor-pointer transition-colors"
                      onClick={() => (window.location.href = pra.url)}
                    >
                      <td className="px-6 py-4">
                        <Link href={pra.url} className="text-gray-900 hover:text-bnc-red font-medium text-sm">
                          {pra.name}
                        </Link>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-600 max-w-md truncate">{pra.description}</td>
                      <td className="px-6 py-4">{getScopeBadge(pra.scope)}</td>
                      <td className="px-6 py-4">{getSecteurBadge(pra.secteur)}</td>
                      <td className="px-6 py-4">{getCategoryBadge(pra.category)}</td>
                      <td className="px-6 py-4">{getStatusBadge(pra.status)}</td>
                      <td className="px-6 py-4 text-center">
                        <span className="text-sm font-medium text-gray-700">{pra.provenCount}</span>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="flex items-center justify-between border-t border-gray-300 bg-white px-6 py-4 rounded">
            <div className="text-sm text-gray-600">
              {t.page} {currentPage} {t.of} {totalPages} · {t.results(filteredAndSortedPRAs.length)}
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                disabled={currentPage === 1}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {t.previous}
              </button>
              <button
                onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                disabled={currentPage === totalPages}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                {t.next}
              </button>
            </div>
          </div>
        )}

        {/* Help Section */}
        <div className="mt-8 bg-gray-50 border border-gray-300 rounded p-6">
          <h3 className="text-sm font-semibold text-gray-900 mb-3">{t.helpTitle}</h3>
          <ul className="text-sm text-gray-600 space-y-1.5">
            <li>{t.helpFilter}</li>
            <li>{t.helpSort}</li>
            <li>{t.helpClick}</li>
          </ul>
        </div>
      </div>
    </div>
  );
}
