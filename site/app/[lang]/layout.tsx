import { RootProvider } from 'fumadocs-ui/provider/next';
import '../global.css';
import { Inter } from 'next/font/google';
import { isValidLanguage, type Language } from '@/lib/i18n';
import { notFound } from 'next/navigation';

const inter = Inter({
  subsets: ['latin'],
});

export default async function Layout({
  children,
  params,
}: {
  children: React.ReactNode;
  params: Promise<{ lang: string }>;
}) {
  const { lang } = await params;

  // Validate language parameter
  if (!isValidLanguage(lang)) {
    notFound();
  }

  return (
    <html lang={lang} className={`${inter.className} light`} suppressHydrationWarning>
      <body className="flex flex-col min-h-screen">
        <RootProvider theme={{ forcedTheme: 'light', enabled: false }}>
          {children}
        </RootProvider>
      </body>
    </html>
  );
}

// Generate static params for both languages
export function generateStaticParams() {
  return [{ lang: 'fr' }, { lang: 'en' }];
}
