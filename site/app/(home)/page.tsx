import Link from 'next/link';
import { getPRAStats } from '@/lib/source';

export default function HomePage() {
  const stats = getPRAStats();

  return (
    <main className="min-h-screen bg-white">
      {/* Hero Section */}
      <div className="bg-white border-b border-gray-200">
        <div className="container mx-auto px-4 py-16 md:py-24">
          <div className="text-center max-w-4xl mx-auto">
            <h1 className="text-4xl md:text-5xl font-semibold mb-4 text-gray-900">
              Registre PRA
            </h1>
            <h2 className="text-xl md:text-2xl text-gray-700 mb-6">
              Banque Nationale du Canada
            </h2>
            <p className="text-lg text-gray-600 mb-3">
              Proven Reusable Architecture
            </p>
            <p className="text-base text-gray-600 mb-8 max-w-3xl mx-auto leading-relaxed">
              Bibliothèque d'architectures validées en production pour accélérer vos projets avec qualité et cohérence
            </p>

            <div className="flex gap-4 justify-center flex-wrap">
              <Link
                href="/registre"
                className="inline-flex items-center justify-center rounded border border-gray-900 bg-gray-900 px-8 py-3 text-sm font-medium text-white transition-colors hover:bg-gray-800"
              >
                Explorer le Registre
              </Link>
              <Link
                href="/registre/01-getting-started"
                className="inline-flex items-center justify-center rounded border border-gray-300 bg-white px-8 py-3 text-sm font-medium text-gray-900 transition-colors hover:bg-gray-50"
              >
                Guide de Démarrage
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
              <div className="text-gray-700 font-medium text-sm">PRAs Approuvés</div>
              <div className="text-gray-500 text-xs mt-1">Validés en production (3+ implémentations)</div>
            </div>
            <div className="bg-white rounded border border-gray-300 p-6">
              <div className="text-3xl font-semibold mb-2 text-gray-900">{stats.candidates}</div>
              <div className="text-gray-700 font-medium text-sm">PRAs Candidats</div>
              <div className="text-gray-500 text-xs mt-1">En cours de validation (1+ implémentation)</div>
            </div>
            <div className="bg-white rounded border border-gray-300 p-6">
              <div className="text-3xl font-semibold mb-2 text-gray-900">40+</div>
              <div className="text-gray-700 font-medium text-sm">PRAs Validés</div>
              <div className="text-gray-500 text-xs mt-1">Patterns éprouvés en production</div>
            </div>
          </div>
        </div>
      </div>

      {/* Quick Start by Persona Section */}
      <div className="bg-white py-16 border-b border-gray-200">
        <div className="container mx-auto px-4">
          <h2 className="text-2xl font-semibold mb-2 text-center text-gray-900">Démarrage rapide</h2>
          <p className="text-center text-gray-600 mb-10 text-sm">
            Trouvez votre point d'entrée selon votre profil
          </p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 max-w-5xl mx-auto">
            <PersonaCard
              title="Développeur"
              need="Implémenter une solution technique"
              steps={[
                { text: 'Parcourir le catalogue par catégorie', link: '/catalogue' },
                { text: 'Consulter la documentation du PRA', link: null },
                { text: 'Suivre le guide d\'implémentation', link: null },
              ]}
            />
            <PersonaCard
              title="Architecte"
              need="Contribuer une architecture validée"
              steps={[
                { text: 'Consulter les standards de qualité', link: '/registre/05-standards' },
                { text: 'Préparer la documentation (ADR, exemples)', link: null },
                { text: 'Soumettre le PRA à la gouvernance', link: '/registre/06-contributing' },
              ]}
            />
            <PersonaCard
              title="Nouveau"
              need="Comprendre le système PRA"
              steps={[
                { text: 'Suivre le parcours guidé en 8 étapes', link: '/registre/01-getting-started' },
                { text: 'Comprendre l\'anatomie d\'un PRA', link: '/registre/02-understanding-pra' },
                { text: 'Explorer le catalogue', link: '/catalogue' },
              ]}
            />
          </div>
        </div>
      </div>

      {/* Why Use PRAs Section */}
      <div className="bg-gray-50 py-16 border-b border-gray-200">
        <div className="container mx-auto px-4">
          <h2 className="text-2xl font-semibold mb-2 text-center text-gray-900">Bénéfices</h2>
          <p className="text-center text-gray-600 mb-10 text-sm">
            Impact mesurable sur vos projets
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 max-w-5xl mx-auto">
            <BenefitCard
              title="Gain de Temps"
              description="Solutions prêtes à l'emploi avec exemples de code"
              example="CI/CD en 2 jours au lieu de 2 semaines"
            />
            <BenefitCard
              title="Qualité"
              description="Patterns validés en production réelle"
              example="Best practices intégrées, pièges documentés"
            />
            <BenefitCard
              title="Cohérence"
              description="Alignement architectural entre équipes"
              example="Standards partagés, onboarding rapide"
            />
            <BenefitCard
              title="ROI Mesurable"
              description="Impact quantifiable sur les projets"
              example="-40-60% temps conception, -50% incidents"
            />
          </div>
        </div>
      </div>

      {/* Categories Section */}
      <div className="bg-white py-16 border-b border-gray-200">
        <div className="container mx-auto px-4">
          <h2 className="text-2xl font-semibold mb-2 text-center text-gray-900">Catégories</h2>
          <p className="text-center text-gray-600 mb-10 text-sm">
            Patrons organisés en 4 domaines d'expertise
          </p>
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 max-w-5xl mx-auto">
            <CategoryCard
              title="Tech"
              description="Infrastructure et plateformes"
              examples={['CI/CD & GitOps', 'Observabilité', 'Infrastructure as Code', 'Orchestration']}
            />
            <CategoryCard
              title="Integration"
              description="Intégration inter-systèmes"
              examples={['API Gateway', 'Message Broker', 'Event-Driven', 'Data Sync']}
            />
            <CategoryCard
              title="Security"
              description="Sécurité et conformité"
              examples={['RBAC/ABAC', 'Secrets Management', 'Network Security', 'Audit']}
            />
            <CategoryCard
              title="Business"
              description="Patterns métier réutilisables"
              examples={['Onboarding', 'Payment', 'Notifications', 'Workflow']}
            />
          </div>
        </div>
      </div>

      {/* How It Works Section */}
      <div className="bg-gray-50 py-16 border-b border-gray-200">
        <div className="container mx-auto px-4">
          <h2 className="text-2xl font-semibold mb-2 text-center text-gray-900">Processus</h2>
          <p className="text-center text-gray-600 mb-10 text-sm">
            Trois étapes pour capitaliser sur l'expérience collective
          </p>
          <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
            <StepCard
              step="1"
              title="Rechercher"
              description="Trouvez un PRA correspondant à votre besoin. Utilisez les filtres par catégorie ou statut."
            />
            <StepCard
              step="2"
              title="Implémenter"
              description="Suivez la documentation : contexte, architecture, exemples de code et retours d'expérience."
            />
            <StepCard
              step="3"
              title="Contribuer"
              description="Partagez votre retour d'expérience et enrichissez le PRA avec vos learnings."
            />
          </div>
        </div>
      </div>

      {/* FAQ Section */}
      <div className="bg-white py-16 border-b border-gray-200">
        <div className="container mx-auto px-4">
          <h2 className="text-2xl font-semibold mb-2 text-center text-gray-900">Questions fréquentes</h2>
          <p className="text-center text-gray-600 mb-10 text-sm">
            Réponses aux questions courantes
          </p>
          <div className="max-w-3xl mx-auto space-y-4">
            <FAQCard
              question="L'utilisation d'un PRA est-elle obligatoire ?"
              answer="Non. Les PRAs sont des recommandations. Cependant, si un PRA applicable existe, vous devrez justifier votre choix lors des revues d'architecture."
            />
            <FAQCard
              question="Puis-je adapter un PRA à mon contexte ?"
              answer="Oui. Les PRAs sont des patrons adaptables. Documentez vos modifications et partagez vos retours pour enrichir le PRA."
            />
            <FAQCard
              question="Comment sont validés les PRAs ?"
              answer="Processus rigoureux : Soumission → Candidate (1+ implémentation) → Approved (3+ implémentations de différentes équipes)."
            />
          </div>
          <div className="text-center mt-8">
            <Link
              href="/registre/01-getting-started"
              className="inline-flex items-center text-gray-900 text-sm font-medium hover:underline"
            >
              Voir toutes les questions →
            </Link>
          </div>
        </div>
      </div>

      {/* CTA Section */}
      <div className="bg-gray-900 py-16">
        <div className="container mx-auto px-4 text-center">
          <h2 className="text-3xl font-semibold mb-4 text-white">Contribuez au Registre</h2>
          <p className="text-base text-gray-300 mb-2 max-w-2xl mx-auto">
            Vous avez une architecture validée en production ? Partagez-la avec la communauté.
          </p>
          <p className="text-sm text-gray-400 mb-8 max-w-xl mx-auto">
            Rejoignez 45+ architectes contributeurs
          </p>
          <div className="flex gap-4 justify-center flex-wrap">
            <Link
              href="/registre/06-contributing"
              className="inline-flex items-center justify-center rounded border border-white bg-white px-8 py-3 text-sm font-medium text-gray-900 transition-colors hover:bg-gray-100"
            >
              Guide de Contribution
            </Link>
            <Link
              href="/registre/08-governance"
              className="inline-flex items-center justify-center rounded border border-gray-400 bg-transparent px-8 py-3 text-sm font-medium text-white transition-colors hover:bg-gray-800"
            >
              Gouvernance
            </Link>
          </div>
        </div>
      </div>

      {/* Stats Footer */}
      <div className="bg-gray-800 py-10 border-t border-gray-700">
        <div className="container mx-auto px-4">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-center text-white max-w-3xl mx-auto">
            <div>
              <div className="text-2xl font-semibold mb-1">45+</div>
              <div className="text-gray-400 text-sm">Architectes contributeurs</div>
            </div>
            <div>
              <div className="text-2xl font-semibold mb-1">40+</div>
              <div className="text-gray-400 text-sm">PRAs validés</div>
            </div>
            <div>
              <div className="text-2xl font-semibold mb-1">3</div>
              <div className="text-gray-400 text-sm">Scopes (Transversal, Sectoriel, Promotion)</div>
            </div>
          </div>
        </div>
      </div>
    </main>
  );
}

function CategoryCard({
  title,
  description,
  examples,
}: {
  title: string;
  description: string;
  examples: string[];
}) {
  return (
    <div className="bg-white border border-gray-300 rounded p-5 hover:border-gray-400 transition-colors">
      <h3 className="text-base font-semibold mb-2 text-gray-900">{title}</h3>
      <p className="text-gray-600 mb-4 text-sm">{description}</p>
      <ul className="text-xs space-y-1.5">
        {examples.map((example, i) => (
          <li key={i} className="text-gray-500 flex items-start">
            <span className="text-gray-400 mr-2 flex-shrink-0">•</span>
            <span>{example}</span>
          </li>
        ))}
      </ul>
    </div>
  );
}

function StepCard({
  step,
  title,
  description,
}: {
  step: string;
  title: string;
  description: string;
}) {
  return (
    <div className="text-center">
      <div className="inline-flex items-center justify-center w-12 h-12 rounded-full bg-gray-900 text-white text-lg font-semibold mb-4">
        {step}
      </div>
      <h3 className="text-base font-semibold mb-2 text-gray-900">{title}</h3>
      <p className="text-gray-600 text-sm leading-relaxed">{description}</p>
    </div>
  );
}

function PersonaCard({
  title,
  need,
  steps,
}: {
  title: string;
  need: string;
  steps: { text: string; link: string | null }[];
}) {
  return (
    <div className="bg-white border border-gray-300 rounded p-5 hover:border-gray-400 transition-colors">
      <h3 className="text-base font-semibold mb-1 text-gray-900">{title}</h3>
      <p className="text-xs text-gray-500 mb-4 italic">{need}</p>
      <ol className="space-y-2.5">
        {steps.map((step, i) => (
          <li key={i} className="flex items-start text-sm">
            <span className="flex-shrink-0 w-5 h-5 rounded-full bg-gray-900 text-white flex items-center justify-center font-medium text-xs mr-2.5 mt-0.5">
              {i + 1}
            </span>
            {step.link ? (
              <Link href={step.link} className="text-gray-700 hover:text-gray-900 hover:underline text-xs">
                {step.text}
              </Link>
            ) : (
              <span className="text-gray-700 text-xs">{step.text}</span>
            )}
          </li>
        ))}
      </ol>
    </div>
  );
}

function BenefitCard({
  title,
  description,
  example,
}: {
  title: string;
  description: string;
  example: string;
}) {
  return (
    <div className="bg-white border border-gray-300 rounded p-5 hover:border-gray-400 transition-colors">
      <h3 className="text-base font-semibold mb-2 text-gray-900">{title}</h3>
      <p className="text-gray-600 mb-3 text-sm">{description}</p>
      <p className="text-xs text-gray-500 bg-gray-50 p-2 rounded border border-gray-200">
        {example}
      </p>
    </div>
  );
}

function FAQCard({ question, answer }: { question: string; answer: string }) {
  return (
    <div className="bg-white border border-gray-300 rounded p-5 hover:border-gray-400 transition-colors">
      <h3 className="text-sm font-semibold mb-2 text-gray-900">{question}</h3>
      <p className="text-gray-600 text-sm leading-relaxed">{answer}</p>
    </div>
  );
}
