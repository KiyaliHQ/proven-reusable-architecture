import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';
import { defaultLanguage, isValidLanguage } from './lib/i18n';

export function middleware(request: NextRequest) {
  const pathname = request.nextUrl.pathname;

  // Check if pathname starts with a language
  const pathnameHasLang = pathname.startsWith('/en/') || pathname.startsWith('/fr/');

  // Redirect root to default language
  if (pathname === '/') {
    return NextResponse.redirect(new URL(`/${defaultLanguage}`, request.url));
  }

  // Redirect old routes (without language prefix) to default language
  if (!pathnameHasLang && !pathname.startsWith('/_next') && !pathname.startsWith('/api')) {
    return NextResponse.redirect(new URL(`/${defaultLanguage}${pathname}`, request.url));
  }

  return NextResponse.next();
}

export const config = {
  matcher: [
    // Match all paths except static files and API routes
    '/((?!_next/static|_next/image|favicon.ico|.*\\..*|api).*)',
  ],
};
