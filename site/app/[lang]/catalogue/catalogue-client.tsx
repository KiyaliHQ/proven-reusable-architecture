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
    resetFilters: 'Réinitialiser',
    scope: 'Scope',
    domaine: 'Domaine',
    category: 'Catégorie',
    status: 'Statut',
    all: 'Tous',
    allFeminine: 'Toutes',
    bankWide: 'Bank-Wide',
    domaines: 'Domaines',
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
    updated: 'Mis à jour',
    noResults: 'Aucun PRA trouvé avec ces critères',
    page: 'Page',
    of: 'sur',
    results: (count: number) => `${count} résultat${count > 1 ? 's' : ''}`,
    previous: 'Précédent',
    next: 'Suivant',
    helpTitle: 'Aide',
    helpFilter: 'Utilisez les filtres pour affiner votre recherche par scope, domaine, catégorie ou statut',
    helpSort: 'Cliquez sur les en-têtes de colonnes pour trier les résultats',
    helpClick: 'Cliquez sur une ligne pour accéder à la documentation complète du PRA',
  },
  en: {
    title: 'PRA Catalogue',
    found: (count: number) => `${count} PRA${count > 1 ? 's' : ''} found`,
    searchPlaceholder: 'Search by name, description, tags...',
    showFilters: 'Show filters',
    hideFilters: 'Hide filters',
    resetFilters: 'Reset',
    scope: 'Scope',
    domaine: 'Domain',
    category: 'Category',
    status: 'Status',
    all: 'All',
    allFeminine: 'All',
    bankWide: 'Bank-Wide',
    domaines: 'Domains',
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
    updated: 'Updated',
    noResults: 'No PRA found with these criteria',
    page: 'Page',
    of: 'of',
    results: (count: number) => `${count} result${count > 1 ? 's' : ''}`,
    previous: 'Previous',
    next: 'Next',
    helpTitle: 'Help',
    helpFilter: 'Use filters to refine your search by scope, domain, category or status',
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
  scope: 'bank-wide' | 'domaines';
  domaine?: string;
}

type Category = 'all' | 'tech' | 'integration' | 'security' | 'business';
type Status = 'all' | 'approved' | 'candidate' | 'deprecated';
type Scope = 'all' | 'bank-wide' | 'domaines';
type Domaine = 'all' | 'particuliers' | 'entreprises' | 'gestion-patrimoine';
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
  'bank-wide': 'Bank-Wide',
  domaines: 'Domaines',
};

const DOMAINE_LABELS: Record<Exclude<Domaine, 'all'>, string> = {
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
  const [domaineFilter, setDomaineFilter] = useState<Domaine>('all');
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

  // Extraire les domaines uniques des données
  const availableDomaines = useMemo(() => {
    const domaines = new Set<string>();
    pras.forEach((pra) => {
      if (pra.domaine) domaines.add(pra.domaine);
    });
    return Array.from(domaines).sort();
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

    // Filtre par domaine (seulement si scope = domaines)
    if (domaineFilter !== 'all' && scopeFilter === 'domaines') {
      result = result.filter((pra) => pra.domaine === domaineFilter);
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
  }, [pras, searchQuery, searchResults, categoryFilter, statusFilter, scopeFilter, domaineFilter, sortKey, sortDirection]);

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
      <span className="px-3 py-1.5 text-xs font-medium text-gray-700 bg-gray-100 rounded-full shadow-sm whitespace-nowrap">
        {CATEGORY_LABELS[category as Exclude<Category, 'all'>] || category}
      </span>
    );
  };

  const getStatusBadge = (status: string) => {
    const styles: Record<string, string> = {
      approved: 'text-green-700 bg-green-50 shadow-green-200/50',
      candidate: 'text-blue-700 bg-blue-50 shadow-blue-200/50',
      deprecated: 'text-red-700 bg-red-50 shadow-red-200/50',
    };
    return (
      <span className={`px-3 py-1.5 text-xs font-medium rounded-full shadow-sm whitespace-nowrap ${styles[status] || 'text-gray-700 bg-gray-100 shadow-gray-200/50'}`}>
        {STATUS_LABELS[status as Exclude<Status, 'all'>] || status}
      </span>
    );
  };

  const getScopeBadge = (scope: string) => {
    return (
      <span className="px-3 py-1.5 text-xs font-medium text-gray-700 bg-gray-100 rounded-full shadow-sm whitespace-nowrap">
        {SCOPE_LABELS[scope as Exclude<Scope, 'all'>] || scope}
      </span>
    );
  };

  const getDomaineBadge = (domaine?: string) => {
    if (!domaine) return <span className="text-xs text-gray-400">-</span>;
    return (
      <span className="px-3 py-1.5 text-xs font-medium text-blue-700 bg-blue-50 rounded-full shadow-sm whitespace-nowrap">
        {DOMAINE_LABELS[domaine as Exclude<Domaine, 'all'>] || domaine}
      </span>
    );
  };

  return (
    <div className="min-h-screen bg-gradient-to-b from-gray-50 to-white pt-16 pb-12 px-4">
      <div className="max-w-7xl mx-auto">
        {/* Header */}
        <div className="mb-6 pb-6">
          <h1 className="text-3xl font-semibold text-gray-900 mb-2">{t.title}</h1>
          <p className="text-base text-[#de161d] font-medium">
            {t.found(filteredAndSortedPRAs.length)}
          </p>
        </div>

        {/* Search Bar - Central */}
        <div className="max-w-2xl mx-auto mb-6">
          <input
            type="search"
            placeholder={t.searchPlaceholder}
            value={searchQuery}
            onChange={(e) => {
              setSearchQuery(e.target.value);
              handleFilterChange();
            }}
            className="w-full px-4 py-3 rounded-lg shadow-sm border border-gray-200 text-sm focus:outline-none focus:ring-2 focus:ring-[#de161d]/20 focus:border-[#de161d]/50 transition-all duration-300"
          />
        </div>

        {/* Filters Toggle Button */}
        <div className="flex justify-center mb-6">
          <button
            onClick={() => setShowFilters(!showFilters)}
            className="px-6 py-2.5 text-sm font-medium text-gray-700 bg-white shadow-sm hover:shadow-md rounded-lg hover:bg-gray-50 transition-all duration-300 flex items-center gap-2"
          >
            {showFilters ? t.hideFilters : t.showFilters}
            <span className="text-[#de161d]">{showFilters ? '▲' : '▼'}</span>
          </button>
        </div>

        {/* Collapsible Filters */}
        {showFilters && (
          <div className="bg-white rounded-lg shadow-md p-6 mb-6">
            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-5 gap-4">
              {/* Scope Filter */}
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-2">{t.scope}</label>
              <select
                value={scopeFilter}
                onChange={(e) => {
                  setScopeFilter(e.target.value as Scope);
                  setDomaineFilter('all'); // Reset domaine quand on change de scope
                  handleFilterChange();
                }}
                className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#de161d]/20 focus:border-[#de161d]/50 transition-all duration-300"
              >
                <option value="all">{t.all}</option>
                <option value="bank-wide">{t.bankWide}</option>
                <option value="domaines">{t.domaines}</option>
              </select>
            </div>

            {/* Domaine Filter (only if scope = domaines) */}
            {scopeFilter === 'domaines' && (
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">{t.domaine}</label>
                <select
                  value={domaineFilter}
                  onChange={(e) => {
                    setDomaineFilter(e.target.value as Domaine);
                    handleFilterChange();
                  }}
                  className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#de161d]/20 focus:border-[#de161d]/50 transition-all duration-300"
                >
                  <option value="all">{t.all}</option>
                  {availableDomaines.map((domaine) => (
                    <option key={domaine} value={domaine}>
                      {t[domaine as keyof typeof t] || domaine}
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
                className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#de161d]/20 focus:border-[#de161d]/50 transition-all duration-300"
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
                className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-[#de161d]/20 focus:border-[#de161d]/50 transition-all duration-300"
              >
                <option value="all">{t.all}</option>
                <option value="approved">{t.approved}</option>
                <option value="candidate">{t.candidate}</option>
                <option value="deprecated">{t.deprecated}</option>
              </select>
            </div>

            {/* Reset Filters Button */}
            <div className="flex items-end">
              <button
                onClick={() => {
                  setSearchQuery('');
                  setScopeFilter('all');
                  setDomaineFilter('all');
                  setCategoryFilter('all');
                  setStatusFilter('all');
                  setCurrentPage(1);
                }}
                className="px-3 py-2 text-sm font-medium text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-lg transition-all duration-300 whitespace-nowrap"
              >
                {t.resetFilters}
              </button>
            </div>
            </div>
          </div>
        )}

        {/* Table */}
        <div className="bg-white rounded-lg shadow-md overflow-hidden mb-6">
          <div className="overflow-x-auto">
            <table className="w-full">
              <thead className="bg-gradient-to-r from-gray-50 to-gray-100">
                <tr>
                  <th
                    className="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors duration-200"
                    onClick={() => handleSort('name')}
                  >
                    <div className="flex items-center gap-1">
                      {t.name}
                      {sortKey === 'name' && <span className="text-[#de161d]">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    {t.description}
                  </th>
                  <th
                    className="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors duration-200"
                    onClick={() => handleSort('scope')}
                  >
                    <div className="flex items-center gap-1">
                      {t.scope}
                      {sortKey === 'scope' && <span className="text-[#de161d]">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    {t.domaine}
                  </th>
                  <th
                    className="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors duration-200"
                    onClick={() => handleSort('category')}
                  >
                    <div className="flex items-center gap-1">
                      {t.category}
                      {sortKey === 'category' && <span className="text-[#de161d]">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th
                    className="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors duration-200"
                    onClick={() => handleSort('status')}
                  >
                    <div className="flex items-center gap-1">
                      {t.status}
                      {sortKey === 'status' && <span className="text-[#de161d]">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                  <th className="px-6 py-4 text-center text-xs font-semibold text-gray-700 uppercase tracking-wider">
                    {t.proven}
                  </th>
                  <th
                    className="px-6 py-4 text-left text-xs font-semibold text-gray-700 uppercase tracking-wider cursor-pointer hover:bg-gray-200 transition-colors duration-200"
                    onClick={() => handleSort('updated')}
                  >
                    <div className="flex items-center gap-1">
                      {t.updated}
                      {sortKey === 'updated' && <span className="text-[#de161d]">{sortDirection === 'asc' ? '↑' : '↓'}</span>}
                    </div>
                  </th>
                </tr>
              </thead>
              <tbody className="divide-y divide-gray-100 bg-white">
                {paginatedPRAs.length === 0 ? (
                  <tr>
                    <td colSpan={8} className="px-6 py-12 text-center text-gray-500 text-sm">
                      {t.noResults}
                    </td>
                  </tr>
                ) : (
                  paginatedPRAs.map((pra) => (
                    <tr
                      key={pra.slug}
                      className="hover:bg-gray-50 cursor-pointer transition-all duration-200 group"
                      onClick={() => (window.location.href = pra.url)}
                    >
                      <td className="px-6 py-4">
                        <Link href={pra.url} className="text-gray-900 hover:text-[#de161d] font-medium text-sm transition-colors duration-200">
                          {pra.name}
                        </Link>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-600 max-w-md truncate">{pra.description}</td>
                      <td className="px-6 py-4">{getScopeBadge(pra.scope)}</td>
                      <td className="px-6 py-4">{getDomaineBadge(pra.domaine)}</td>
                      <td className="px-6 py-4">{getCategoryBadge(pra.category)}</td>
                      <td className="px-6 py-4">{getStatusBadge(pra.status)}</td>
                      <td className="px-6 py-4 text-center">
                        <span className="text-sm font-semibold text-[#de161d]">{pra.provenCount}</span>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-600 whitespace-nowrap">{pra.updated}</td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </div>

        {/* Pagination */}
        {totalPages > 1 && (
          <div className="flex items-center justify-between bg-white shadow-sm rounded-lg px-6 py-4">
            <div className="text-sm text-gray-600">
              {t.page} <span className="font-semibold text-[#de161d]">{currentPage}</span> {t.of} {totalPages} · {t.results(filteredAndSortedPRAs.length)}
            </div>
            <div className="flex gap-2">
              <button
                onClick={() => setCurrentPage((p) => Math.max(1, p - 1))}
                disabled={currentPage === 1}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white shadow-sm rounded-lg hover:shadow-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300"
              >
                {t.previous}
              </button>
              <button
                onClick={() => setCurrentPage((p) => Math.min(totalPages, p + 1))}
                disabled={currentPage === totalPages}
                className="px-4 py-2 text-sm font-medium text-gray-700 bg-white shadow-sm rounded-lg hover:shadow-md hover:bg-gray-50 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-300"
              >
                {t.next}
              </button>
            </div>
          </div>
        )}

        {/* Help Section */}
        <div className="mt-8 bg-gradient-to-br from-white to-gray-50 rounded-lg shadow-sm p-6">
          <h3 className="text-sm font-semibold text-gray-900 mb-3">{t.helpTitle}</h3>
          <ul className="text-sm text-gray-600 space-y-2">
            <li className="flex items-start gap-2">
              <span className="text-[#de161d] font-bold mt-0.5">•</span>
              <span>{t.helpFilter}</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-[#de161d] font-bold mt-0.5">•</span>
              <span>{t.helpSort}</span>
            </li>
            <li className="flex items-start gap-2">
              <span className="text-[#de161d] font-bold mt-0.5">•</span>
              <span>{t.helpClick}</span>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}
