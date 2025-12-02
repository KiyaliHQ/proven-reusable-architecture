import Link from 'next/link';
import Image from 'next/image';

export function Footer() {
  return (
    <footer className="bg-bnc-dark text-white py-12 border-t-4 border-bnc-red">
      <div className="container mx-auto px-4">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8 mb-8">
          {/* Logo et description */}
          <div className="md:col-span-2">
            <div className="mb-4">
              <Image
                src="/logo-bnc-white.svg"
                alt="Banque Nationale"
                width={155}
                height={50}
                className="h-8 w-auto"
              />
            </div>
            <p className="text-white/70 text-sm mb-4">
              Registre PRA - Proven Reusable Architecture
            </p>
            <p className="text-white/60 text-sm">
              Capitaliser sur l'expérience collective pour accélérer le développement et standardiser nos architectures.
            </p>
          </div>

          {/* Navigation */}
          <div>
            <h3 className="text-white font-semibold mb-4">Navigation</h3>
            <ul className="space-y-2 text-sm">
              <li>
                <Link href="/" className="text-white/70 hover:text-bnc-red transition-colors">
                  Accueil
                </Link>
              </li>
              <li>
                <Link href="/registre" className="text-white/70 hover:text-bnc-red transition-colors">
                  Registre
                </Link>
              </li>
              <li>
                <Link href="/registre/contributing" className="text-white/70 hover:text-bnc-red transition-colors">
                  Contribuer
                </Link>
              </li>
            </ul>
          </div>

          {/* Catégories */}
          <div>
            <h3 className="text-white font-semibold mb-4">Catégories</h3>
            <ul className="space-y-2 text-sm">
              <li>
                <Link href="/registre/tech" className="text-white/70 hover:text-bnc-red transition-colors">
                  Tech
                </Link>
              </li>
              <li>
                <Link href="/registre/integration" className="text-white/70 hover:text-bnc-red transition-colors">
                  Integration
                </Link>
              </li>
              <li>
                <Link href="/registre/security" className="text-white/70 hover:text-bnc-red transition-colors">
                  Security
                </Link>
              </li>
              <li>
                <Link href="/registre/business" className="text-white/70 hover:text-bnc-red transition-colors">
                  Business
                </Link>
              </li>
            </ul>
          </div>
        </div>

        {/* Copyright */}
        <div className="pt-8 border-t border-white/10 text-center">
          <p className="text-white/60 text-sm">
            © {new Date().getFullYear()} Banque Nationale du Canada. Tous droits réservés.
          </p>
        </div>
      </div>
    </footer>
  );
}
