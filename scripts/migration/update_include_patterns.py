import re

with open('/Users/amarafofana/Projects/proven-reusable-architecture/site/source.config.ts', 'r') as f:
    content = f.read()

# Replace all include: ['**/fr.md'] with include: ['**/fr/**']
content = content.replace("include: ['**/fr.md']", "include: ['**/fr/**']")

# Replace all include: ['**/en.md'] with include: ['**/en/**']
content = content.replace("include: ['**/en.md']", "include: ['**/en/**']")

with open('/Users/amarafofana/Projects/proven-reusable-architecture/site/source.config.ts', 'w') as f:
    f.write(content)

print("✅ Updated all include patterns to use **/fr/** and **/en/**")
