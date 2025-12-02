import Link from 'next/link';
import { getPRAStats } from '@/lib/source';
import { type Language, t } from '@/lib/i18n';

export default async function HomePage({
  params,
}: {
  params: Promise<{ lang: Language }>;
}) {
  const { lang } = await params;
  const stats = getPRAStats();

  return (
    <main className="min-h-screen bg-white">
      {/* Hero Section */}
      <div className="bg-white border-b border-gray-200">
        <div className="container mx-auto px-4 py-16 md:py-24">
          <div className="text-center max-w-4xl mx-auto">
            <h1 className="text-4xl md:text-5xl font-semibold mb-4 text-gray-900">
              {t(lang, 'home.title')}
            </h1>
            <h2 className="text-xl md:text-2xl text-gray-700 mb-6">
              {t(lang, 'home.subtitle')}
            </h2>
            <p className="text-lg text-gray-600 mb-3">
              {t(lang, 'home.tagline')}
            </p>
            <p className="text-base text-gray-600 mb-8 max-w-3xl mx-auto leading-relaxed">
              {t(lang, 'home.description')}
            </p>

            <div className="flex gap-4 justify-center flex-wrap">
              <Link
                href={`/${lang}/registre`}
                className="inline-flex items-center justify-center rounded border border-gray-900 bg-gray-900 px-8 py-3 text-sm font-medium text-white transition-colors hover:bg-gray-800"
              >
                {t(lang, 'home.explore')}
              </Link>
              <Link
                href={`/${lang}/registre/01-getting-started`}
                className="inline-flex items-center justify-center rounded border border-gray-300 bg-white px-8 py-3 text-sm font-medium text-gray-900 transition-colors hover:bg-gray-50"
              >
                {t(lang, 'home.getStarted')}
              </Link>
            </div>
          </div>
        </div>
      </div>

      {/* Stats Section */}
      <div className="bg-gray-50 py-12 border-b border-gray-200">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-center max-w-4xl mx-auto">
            <div className="bg-white rounded border border-gray-300 p-6">
              <div className="text-3xl font-semibold mb-2 text-gray-900">{stats.approved}</div>
              <div className="text-gray-700 font-medium text-sm">{t(lang, 'stats.approved')}</div>
              <div className="text-gray-500 text-xs mt-1">{t(lang, 'stats.approved.desc')}</div>
            </div>
            <div className="bg-white rounded border border-gray-300 p-6">
              <div className="text-3xl font-semibold mb-2 text-gray-900">{stats.candidates}</div>
              <div className="text-gray-700 font-medium text-sm">{t(lang, 'stats.candidates')}</div>
              <div className="text-gray-500 text-xs mt-1">{t(lang, 'stats.candidates.desc')}</div>
            </div>
            <div className="bg-white rounded border border-gray-300 p-6">
              <div className="text-3xl font-semibold mb-2 text-gray-900">40+</div>
              <div className="text-gray-700 font-medium text-sm">{t(lang, 'stats.validated')}</div>
              <div className="text-gray-500 text-xs mt-1">{t(lang, 'stats.validated.desc')}</div>
            </div>
          </div>
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-gray-900 py-16">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-semibold mb-4 text-white">
            {lang === 'fr' ? 'Contribuez au Registre' : 'Contribute to the Registry'}
          </h2>
          <p className="text-base text-gray-300 mb-2 max-w-2xl mx-auto">
            {lang === 'fr'
              ? 'Vous avez une architecture validée en production ? Partagez-la avec la communauté.'
              : 'Do you have a production-validated architecture? Share it with the community.'}
          </p>
          <p className="text-sm text-gray-400 mb-8 max-w-xl mx-auto">
            {lang === 'fr' ? 'Rejoignez 45+ architectes contributeurs' : 'Join 45+ contributing architects'}
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <Link
              href={`/${lang}/registre/06-contributing`}
              className="inline-flex items-center justify-center rounded border border-white bg-white px-8 py-3 text-sm font-medium text-gray-900 transition-colors hover:bg-gray-100"
            >
              {lang === 'fr' ? 'Guide de Contribution' : 'Contributing Guide'}
            </Link>
            <Link
              href={`/${lang}/registre/08-governance`}
              className="inline-flex items-center justify-center rounded border border-gray-400 bg-transparent px-8 py-3 text-sm font-medium text-white transition-colors hover:bg-gray-800"
            >
              {lang === 'fr' ? 'Gouvernance' : 'Governance'}
            </Link>
          </div>
        </div>
      </div>
    </main>
  );
}
