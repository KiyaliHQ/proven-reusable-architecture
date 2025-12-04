import {
  defineConfig,
  defineDocs,
  frontmatterSchema,
  metaSchema,
} from 'fumadocs-mdx/config';
import { remarkMdxMermaid } from 'fumadocs-core/mdx-plugins';

// =========================================
// GUIDES (French and English)
// =========================================

export const guides_fr = defineDocs({
  dir: '../content/guides/fr',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

export const guides_en = defineDocs({
  dir: '../content/guides/en',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

// =========================================
// PRAs (All scopes and statuses)
// =========================================

// All PRAs - French
export const pras_fr = defineDocs({
  dir: '../content/pras-fr',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

// All PRAs - English
export const pras_en = defineDocs({
  dir: '../content/pras-en',
  docs: {
    schema: frontmatterSchema,
    postprocess: {
      includeProcessedMarkdown: true,
    },
  },
  meta: {
    schema: metaSchema,
  },
});

// =========================================
// BACKWARD COMPATIBILITY ALIASES
// =========================================

export const docs_fr = guides_fr;
export const docs_en = guides_en;
export const docs = docs_fr;

// Main registre aliases (pointing to PRAs)
export const registre_fr = pras_fr;
export const registre_en = pras_en;

export default defineConfig({
  mdxOptions: {
    remarkPlugins: [remarkMdxMermaid],
  },
});
