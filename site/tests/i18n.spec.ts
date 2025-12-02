import { test, expect } from '@playwright/test';

test.describe('Internationalization (i18n)', () => {
  test('should redirect root "/" to "/fr" (default language)', async ({ page }) => {
    await page.goto('/');
    await expect(page).toHaveURL('/fr');
  });

  test('should display French homepage at /fr', async ({ page }) => {
    await page.goto('/fr');

    // Check French content
    await expect(page.locator('h1').first()).toContainText('Registre PRA');
    await expect(page.locator('h2').first()).toContainText('Banque Nationale du Canada');

    // Check French navigation
    await expect(page.getByRole('link', { name: 'Accueil' })).toBeVisible();
    await expect(page.getByRole('link', { name: 'Catalogue' })).toBeVisible();
    await expect(page.getByRole('link', { name: 'Librairie' })).toBeVisible();
  });

  test('should display English homepage at /en', async ({ page }) => {
    await page.goto('/en');

    // Check English content
    await expect(page.locator('h1').first()).toContainText('PRA Registry');
    await expect(page.locator('h2').first()).toContainText('Banque Nationale du Canada');

    // Check English navigation
    await expect(page.getByRole('link', { name: 'Home' })).toBeVisible();
    await expect(page.getByRole('link', { name: 'Catalogue' })).toBeVisible();
    await expect(page.getByRole('link', { name: 'Library' })).toBeVisible();
  });

  test('should have language switcher visible', async ({ page }) => {
    await page.goto('/fr/registre');

    // Check for FR and EN buttons in sidebar footer (last visible ones)
    const frButton = page.getByRole('link', { name: /Switch to Français/i }).or(
      page.locator('a[href*="/fr"]').filter({ hasText: 'FR' })
    );
    const enButton = page.getByRole('link', { name: /Switch to English/i }).or(
      page.locator('a[href*="/en"]').filter({ hasText: 'EN' })
    );

    await expect(frButton.last()).toBeVisible();
    await expect(enButton.last()).toBeVisible();
  });

  test('should switch from French to English using language switcher', async ({ page }) => {
    await page.goto('/fr/registre');

    // Click English button - use the link with aria-label
    await page.getByRole('link', { name: 'Switch to English' }).click();

    // Should redirect to /en/registre
    await expect(page).toHaveURL('/en/registre');

    // Check English content is displayed
    await expect(page.getByRole('link', { name: 'Library' })).toBeVisible();
  });

  test('should switch from English to French using language switcher', async ({ page }) => {
    await page.goto('/en/registre');

    // Click French button - use the link with aria-label
    await page.getByRole('link', { name: 'Switch to Français' }).click();

    // Should redirect to /fr/registre
    await expect(page).toHaveURL('/fr/registre');

    // Check French content is displayed
    await expect(page.getByRole('link', { name: 'Librairie' })).toBeVisible();
  });

  test('should preserve page path when switching languages', async ({ page }) => {
    // Start on French registre
    await page.goto('/fr/registre');
    await expect(page).toHaveURL('/fr/registre');

    // Switch to English
    await page.getByRole('link', { name: 'Switch to English' }).click();

    // Should be on English registre
    await expect(page).toHaveURL('/en/registre');
  });

  test('should access French catalogue at /fr/catalogue', async ({ page }) => {
    await page.goto('/fr/catalogue');

    // Check for catalogue content (search bar, filters)
    await expect(page.locator('input[placeholder*="Rechercher"]').or(page.locator('input[type="search"]'))).toBeVisible();
  });

  test('should access English catalogue at /en/catalogue', async ({ page }) => {
    await page.goto('/en/catalogue');

    // Check for catalogue content
    await expect(page.locator('input[type="search"]').or(page.locator('input[placeholder*="Search"]'))).toBeVisible();
  });

  test('should access French registry at /fr/registre', async ({ page }) => {
    await page.goto('/fr/registre');

    // Should load registry page
    await expect(page).toHaveURL(/\/fr\/registre/);
  });

  test('should access English registry at /en/registre', async ({ page }) => {
    await page.goto('/en/registre');

    // Should load registry page
    await expect(page).toHaveURL(/\/en\/registre/);
  });

  test('should redirect old routes without language prefix to /fr', async ({ page }) => {
    await page.goto('/catalogue');
    await expect(page).toHaveURL('/fr/catalogue');
  });

  test('should maintain language across navigation', async ({ page }) => {
    await page.goto('/en');

    // Navigate to catalogue
    await page.click('text=Catalogue');
    await expect(page).toHaveURL('/en/catalogue');

    // Navigate to library
    await page.click('text=Library');
    await expect(page).toHaveURL(/\/en\/registre/);
  });

  test('should show stats in both languages', async ({ page }) => {
    // French stats
    await page.goto('/fr');
    await expect(page.locator('text=PRAs Approuvés').or(page.locator('text=Approved'))).toBeVisible();

    // English stats
    await page.goto('/en');
    await expect(page.locator('text=Approved PRAs').or(page.locator('text=Approved'))).toBeVisible();
  });

  test('should display correct language attribute in HTML', async ({ page }) => {
    // French
    await page.goto('/fr');
    const htmlFr = await page.locator('html').getAttribute('lang');
    expect(htmlFr).toBe('fr');

    // English
    await page.goto('/en');
    const htmlEn = await page.locator('html').getAttribute('lang');
    expect(htmlEn).toBe('en');
  });
});
