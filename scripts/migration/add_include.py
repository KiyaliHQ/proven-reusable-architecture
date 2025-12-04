import re

with open('/Users/amarafofana/Projects/proven-reusable-architecture/site/source.config.ts', 'r') as f:
    content = f.read()

# Pattern pour trouver les définitions de PRAs français (après dir, avant docs)
pattern_fr = r"(export const pras_\w+_fr = defineDocs\(\{\s*dir: '[^']+',)"
replacement_fr = r"\1\n  include: ['**/fr.md'],"

# Pattern pour les PRAs anglais
pattern_en = r"(export const pras_\w+_en = defineDocs\(\{\s*dir: '[^']+',)"
replacement_en = r"\1\n  include: ['**/en.md'],"

# Appliquer les remplacements
content = re.sub(pattern_fr, replacement_fr, content)
content = re.sub(pattern_en, replacement_en, content)

with open('/Users/amarafofana/Projects/proven-reusable-architecture/site/source.config.ts', 'w') as f:
    f.write(content)

print("✅ Added include patterns to all PRA sources")
