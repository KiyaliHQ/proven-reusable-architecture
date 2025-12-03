# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## 📚 Project Overview

**Proven Reusable Architecture (PRA) Registry** is a comprehensive documentation platform built with Fumadocs that catalogs and organizes proven architectural patterns for Banque Nationale du Canada.

### What is a PRA?

A **PRA (Proven Reusable Architecture)** is a proven solution validated in real production projects at Banque Nationale. Think of it as a battle-tested recipe that has been successfully used multiple times across different contexts.

### Key Principles

- **Proven in Production**: Validated in at least 3 real implementations at BNC
- **Reusable**: Generalizable across different contexts and projects
- **Documented**: With context, ADRs, code examples, and lessons learned
- **Maintained**: Versioned and supported by the BNC architecture community

---

## 🏗️ Repository Structure

```
proven-reusable-architecture/
├── site/                           # 📱 FUMADOCS SITE (Main Application)
│   ├── app/                        # Next.js App Router
│   │   ├── [lang]/                 # Language-based routes (fr/en)
│   │   │   ├── guides/             # Documentation guides
│   │   │   │   └── [[...slug]]/page.tsx
│   │   │   └── registre/           # Registry (PRA catalogue)
│   │   │       └── [[...slug]]/page.tsx
│   │   ├── layout.tsx              # Root layout
│   │   └── global.css              # Global styles
│   ├── lib/                        # Utilities
│   │   ├── source.ts               # Fumadocs source loaders
│   │   └── layout.shared.tsx       # Shared layout configuration
│   ├── components/                 # React components
│   ├── public/                     # Static assets (logos, images)
│   ├── source.config.ts            # Fumadocs collections definition
│   ├── package.json                # Site dependencies
│   └── next.config.mjs             # Next.js configuration
├── content/                        # 📝 CONTENT (MDX Documentation)
│   ├── guides/                     # User guides
│   │   ├── fr/                     # French guides
│   │   └── en/                     # English guides
│   ├── pras-fr/                    # French PRAs (physically separated)
│   │   ├── bank-wide/              # Cross-cutting (all sectors)
│   │   │   ├── approved/           # Approved PRAs
│   │   │   │   ├── tech/
│   │   │   │   ├── integration/
│   │   │   │   ├── security/
│   │   │   │   └── business/
│   │   │   └── candidate/          # Candidate PRAs
│   │   │       ├── tech/
│   │   │       ├── integration/
│   │   │       ├── security/
│   │   │       └── business/
│   │   └── domain-wide/            # Domain-specific
│   │       ├── particuliers/       # Retail banking
│   │       ├── entreprises/        # Corporate banking
│   │       └── gestion-patrimoine/ # Wealth management
│   └── pras-en/                    # English PRAs (same structure)
│       ├── bank-wide/
│       └── domain-wide/
├── docs/                           # 📖 DOCUMENTATION
│   ├── DEVELOPER_GUIDE.md          # Comprehensive developer guide
│   ├── QUICK_START.md              # 5-minute quick start
│   ├── CONTRIBUTING.md             # Contribution guidelines
│   ├── GOVERNANCE.md               # Governance structure
│   ├── LIFECYCLE.md                # PRA lifecycle
│   └── STANDARDS.md                # Quality standards
├── templates/                      # 📋 TEMPLATES
│   ├── pra-template.md             # PRA documentation template
│   ├── adr-template.md             # ADR template
│   └── metadata-template.yml       # PRA metadata template
├── scripts/                        # 🛠️ UTILITY SCRIPTS
│   └── migration/                  # Migration scripts (archived)
│       ├── README.md               # Migration documentation
│       ├── split_pras_by_lang_fixed.py
│       └── flatten_pra_files.py
├── .github/                        # GitHub configuration
│   └── workflows/                  # CI/CD workflows
├── CHANGELOG.md                    # Project changelog
├── package.json                    # Root package.json (workspace)
├── pnpm-workspace.yaml             # PNPM workspace configuration
└── README.md                       # Project README
```

---

## 🎯 Key Features

### 1. Interactive Catalogue (`/catalogue`)

The catalogue is the heart of the application, featuring:

**Search (Orama Full-Text Search)**:
- Fuzzy matching with typo tolerance (tolerance: 1)
- Multi-field search (name x2 boost, tags x1.5 boost, description x1)
- Real-time filtering as you type
- Examples:
  - "api" → finds "API Gateway"
  - "salesforse" (typo) → finds "Salesforce FSC"
  - "onboarding digital" → finds relevant PRAs

**Filters (Collapsible)**:
- **Scope**: All, Transversal, Secteurs, En Promotion
- **Category**: All, Tech, Integration, Security, Business
- **Status**: All, Approved, Candidate, Deprecated
- **Secteur**: (Dynamic - appears only when Scope = "Secteurs")
  - All, Particuliers, Entreprises, Gestion de Patrimoine

**Table Display**:
- Columns: Name, Scope, Secteur, Category, Status, Proven Count, Updated
- Color-coded status badges:
  - **Approved** (green): 3+ proven implementations
  - **Candidate** (blue): 1+ proven implementation
  - **Deprecated** (red): No longer recommended
- Sortable by: Name, Updated date
- Pagination: 20 items per page
- Click row to view full PRA documentation

**Technical Implementation**:
- `site/app/catalogue/page.tsx`: Server component for data fetching
- `site/app/catalogue/catalogue-client.tsx`: Client component with Orama search
- Search index built client-side with Orama SDK
- Filtering logic combines search results + active filters

### 2. Registry Documentation (`/[lang]/registre`)

Bilingual documentation (FR/EN) with comprehensive guides:

1. **Getting Started** - Introduction and first steps
2. **Understanding PRAs** - Detailed anatomy
3. **Roles & Responsibilities** - Who does what
4. **Lifecycle** - From Candidate to Approved
5. **Standards** - Quality criteria
6. **Contributing** - Submission process
7. **Promotion Process** - Domain → Bank-Wide
8. **Governance** - Decision-making structure

**PRA Scopes**:
- **Bank-Wide** (`bank-wide/`): Cross-cutting, validated for all sectors
- **Domain-Wide** (`domain-wide/`): Domain-specific (Particuliers, Entreprises, Gestion de Patrimoine)

**PRA Status**:
- **Candidate**: 1+ proven-in-use implementation
- **Approved**: 3+ proven-in-use for Bank-Wide, 1+ for Domain-Wide
- **Deprecated**: Obsolete, archived

### 3. Homepage (`/`)

Landing page featuring:
- Hero section with tagline
- Statistics dashboard (Approved/Candidate counts)
- Quick start guides by persona (Developer, Architect, Newcomer)
- Benefits section (Time savings, Quality, Consistency, ROI)
- Categories overview (Tech, Integration, Security, Business)
- Process workflow (Search → Implement → Contribute)
- FAQ section
- Contribution CTA

### 4. Branding

**Banque Nationale branding**:
- Logo with tagline: "PROVEN REUSABLE ARCHITECTURE"
- Clean, professional design (light mode only)
- Navigation: Home, Catalogue, Librairie (Registry)

---

## 🔧 Tech Stack

### Core Technologies

- **Framework**: Next.js 16.0.1 (App Router)
- **Bundler**: Turbopack (next dev --turbo)
- **React**: 19.0.0
- **TypeScript**: 5.x
- **Styling**: Tailwind CSS 3.4.1
- **Documentation**: Fumadocs 14.8.1
  - `fumadocs-core`: Core documentation features
  - `fumadocs-ui`: Pre-built UI components
  - `fumadocs-mdx`: MDX processing
- **Search**: Orama 3.0.2 (client-side full-text search)
- **Content**: MDX with frontmatter metadata
- **Package Manager**: PNPM (workspace monorepo)

### Key Dependencies

```json
{
  "next": "^16.0.1",
  "react": "^19.0.0",
  "fumadocs-core": "^14.8.1",
  "fumadocs-ui": "^14.8.1",
  "fumadocs-mdx": "^10.4.1",
  "@orama/orama": "^3.0.2",
  "tailwindcss": "^3.4.1"
}
```

---

## 🚀 Development Workflow

### Setup

```bash
# Navigate to project
cd /Users/amarafofana/Projects/proven-reusable-architecture

# Install dependencies (from site/ directory)
cd site
pnpm install

# Start development server
pnpm dev

# Server runs on http://localhost:3000
```

### Available Commands

```bash
# Development
pnpm dev              # Start dev server with Turbopack
pnpm build            # Build for production
pnpm start            # Start production server

# Utilities
pnpm lint             # Run ESLint
pnpm type-check       # TypeScript type checking
```

### Project Conventions

**File Naming**:
- Components: PascalCase (e.g., `PRAFilters.tsx`)
- Pages: kebab-case (e.g., `getting-started.md`)
- Utilities: camelCase (e.g., `source.ts`)

**Import Aliases**:
- `@/` → `site/` directory root
- Example: `import { source } from '@/lib/source'`

---

## 📝 Content Management

### Adding a New PRA

1. **Choose the correct scope, status, and category**:
   ```
   content/
   ├── pras-fr/                    # French PRAs
   │   ├── bank-wide/              # Cross-cutting (all sectors)
   │   │   ├── approved/           # 3+ proven-in-use
   │   │   │   ├── tech/
   │   │   │   ├── integration/
   │   │   │   ├── security/
   │   │   │   └── business/
   │   │   └── candidate/          # 1+ proven-in-use
   │   │       ├── tech/
   │   │       ├── integration/
   │   │       ├── security/
   │   │       └── business/
   │   └── domain-wide/            # Domain-specific
   │       ├── particuliers/       # Retail banking
   │       ├── entreprises/        # Corporate banking
   │       └── gestion-patrimoine/ # Wealth management
   └── pras-en/                    # English PRAs (same structure)
   ```

   **IMPORTANT**: Use flat file structure
   - ✅ Correct: `pras-fr/bank-wide/candidate/tech/my-pra.md`
   - ❌ Incorrect: `pras-fr/bank-wide/candidate/tech/my-pra/page.md`

2. **Create MDX file** with frontmatter:
   ```mdx
   ---
   title: Your PRA Title
   description: Brief description of the PRA
   pra:
     name: Display name
     category: tech|integration|security|business
     status: candidate|approved|deprecated
     tags: [tag1, tag2, tag3]
     created_at: YYYY-MM-DD
     updated_at: YYYY-MM-DD
     proven_in_use:
       - project: Project Name
         team: Team Name
         date: YYYY-MM-DD
         feedback: Lessons learned
   ---

   # Your PRA Content

   [Your detailed documentation in Markdown/MDX]
   ```

3. **Create bilingual versions** (FR and EN):
   - `content/pras-fr/bank-wide/candidate/tech/api-gateway.md`
   - `content/pras-en/bank-wide/candidate/tech/api-gateway.md`

4. **The PRA will automatically appear** in:
   - Fumadocs navigation sidebar
   - Search results (if indexed)
   - Both `/fr/registre/` and `/en/registre/` routes

### PRA Metadata Schema

```yaml
pra:
  name: string                    # Display name
  category: enum                  # tech|integration|security|business
  status: enum                    # candidate|approved|deprecated
  tags: array<string>            # Keywords for search
  created_at: date               # Creation date (YYYY-MM-DD)
  updated_at: date               # Last update (YYYY-MM-DD)
  proven_in_use: array<object>   # Production implementations
    - project: string
      team: string
      date: date
      feedback: string
```

### Content Guidelines

**Do**:
- Use clear, descriptive titles
- Include context and problem statement
- Document architectural decisions (ADRs)
- Provide code examples
- Share lessons learned
- Update `updated_at` when making changes

**Don't**:
- Use generic or vague titles
- Skip the "why" (rationale)
- Forget to document trade-offs
- Leave proven_in_use empty for approved PRAs

---

## 🎨 Design System

### Color Palette

**Status Colors**:
- Approved: Green (`text-green-700 bg-green-50 border-green-300`)
- Candidate: Blue (`text-blue-700 bg-blue-50 border-blue-300`)
- Deprecated: Red (`text-red-700 bg-red-50 border-red-300`)

**Neutral Colors**:
- Gray scale for general UI (`gray-50` to `gray-900`)

**Badge Pattern**:
```tsx
<span className="px-2.5 py-1 text-xs font-medium text-{color}-700 bg-{color}-50 border border-{color}-300 rounded whitespace-nowrap">
  Label
</span>
```

### Typography

- **Headings**: `font-semibold` with appropriate sizes
- **Body**: `text-gray-600` for secondary text, `text-gray-900` for primary
- **Small text**: `text-xs` for badges, `text-sm` for secondary info

### Spacing

- Consistent padding: `px-4`, `py-6`, etc.
- Container max-width: `max-w-5xl mx-auto` (centered content)

---

## 🔍 Search Implementation

### Orama Configuration

Located in `site/lib/search.ts`:

```typescript
import { create, insertMultiple, search } from '@orama/orama';

// Schema
const schema = {
  slug: 'string',
  name: 'string',
  description: 'string',
  category: 'string',
  status: 'string',
  tags: 'string[]',
  scope: 'string',
  secteur: 'string',
};

// Index creation
const db = await create({ schema });
await insertMultiple(db, praData);

// Search with fuzzy matching
const results = await search(db, {
  term: searchQuery,
  tolerance: 1,              // Typo tolerance
  boost: {
    name: 2,                 // Boost name matches
    tags: 1.5,               // Boost tag matches
    description: 1,          // Normal weight for description
  },
});
```

### Search Flow

1. User types in search bar
2. `catalogue-client.tsx` debounces input (300ms)
3. Orama searches indexed PRAs
4. Results filtered by active filters (scope, category, status, secteur)
5. Table updates with matching PRAs

---

## 🧪 Testing Strategy

### Manual Testing Checklist

**Catalogue**:
- [ ] Search with exact match
- [ ] Search with typo (fuzzy)
- [ ] Search multi-word query
- [ ] Filter by Scope
- [ ] Filter by Category
- [ ] Filter by Status
- [ ] Filter by Secteur (when scope = Secteurs)
- [ ] Combine search + filters
- [ ] Sort by Name
- [ ] Sort by Updated
- [ ] Pagination (next/previous)
- [ ] Click row to view PRA

**Navigation**:
- [ ] Home → Catalogue
- [ ] Home → Librairie
- [ ] Catalogue → PRA detail
- [ ] Registry sidebar navigation

**Responsive Design**:
- [ ] Desktop (1920px)
- [ ] Tablet (768px)
- [ ] Mobile (375px)

### Common Issues

**Search not working**:
- Check Orama index is built correctly in `catalogue-client.tsx`
- Verify PRA metadata includes searchable fields (name, description, tags)

**PRA not appearing in catalogue**:
- Check frontmatter has `pra:` metadata
- Verify file is not filtered out (guide pages with `01-`, `02-` prefixes are excluded)
- Check `meta.json` includes the file slug

**Badge text wrapping**:
- Ensure `whitespace-nowrap` class is present on badge spans

---

## 📦 Deployment

### Vercel Deployment (Recommended)

1. **Connect GitHub repo** to Vercel
2. **Configure build settings**:
   - Framework Preset: `Next.js`
   - Root Directory: `site`
   - Build Command: `pnpm build`
   - Output Directory: `.next`
3. **Environment Variables**: (None required for now)
4. **Deploy**: Automatic on push to `main`

### Build Locally

```bash
cd site
pnpm build
pnpm start
```

---

## 🤝 Contribution Workflow

### For New PRAs

1. **Verify PRA Readiness**:
   - Proven in production (1+ for Candidate, 3+ for Approved)
   - Complete documentation
   - ADRs documented
   - Code examples provided

2. **Create Content**:
   - Use `templates/pra-template.md` as starting point
   - Follow metadata schema
   - Include all required sections

3. **Submit for Review**:
   - Create PR with PRA content
   - Tag architecture governance team
   - Wait for review and approval

4. **Post-Approval**:
   - PRA appears in catalogue
   - Automatically indexed for search
   - Available to all teams

### For Updates

1. Update the MDX file
2. Change `updated_at` date
3. Add entry to `proven_in_use` if new implementation
4. Create PR with changes
5. Update automatically reflects in catalogue

---

## 🐛 Troubleshooting

### Common Development Issues

**Port already in use (3000)**:
```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9

# Or use different port
pnpm dev --port 3001
```

**PNPM issues**:
```bash
# Clear cache and reinstall
rm -rf node_modules
pnpm store prune
pnpm install
```

**Build errors**:
```bash
# Clear Next.js cache
rm -rf site/.next
pnpm build
```

**Search not indexing new PRAs**:
- Restart dev server (Orama index built on page load)
- Check browser console for errors
- Verify PRA metadata format

---

## 📚 References

### Documentation

- **Fumadocs**: https://fumadocs.vercel.app/docs
- **Next.js App Router**: https://nextjs.org/docs
- **Orama Search**: https://docs.oramasearch.com/
- **Tailwind CSS**: https://tailwindcss.com/docs

### Internal Resources

- `/docs/DEVELOPER_GUIDE.md` - Comprehensive developer guide (architecture, ADRs, best practices)
- `/docs/QUICK_START.md` - 5-minute quick start guide
- `/docs/CONTRIBUTING.md` - Contribution guidelines
- `/docs/GOVERNANCE.md` - Governance structure
- `/docs/LIFECYCLE.md` - PRA lifecycle
- `/docs/STANDARDS.md` - Quality standards
- `/templates/` - Templates for PRAs and ADRs
- `/CHANGELOG.md` - Project changelog and version history
- `/scripts/migration/README.md` - Migration scripts documentation

---

## ⚠️ Important Notes

### Rules for AI Assistants

1. **Always check current content structure** before making changes
2. **Preserve existing PRA metadata** when updating
3. **Update `updated_at`** when modifying PRAs
4. **Follow Fumadocs conventions** for MDX content
5. **Use flat file structure** (`pra-name.md`, NOT `pra-name/page.md`)
6. **Physical FR/EN separation** (pras-fr/, pras-en/, NOT fr/ and en/ subdirectories)
7. **Git workflow**:
   - Always work on feature branches
   - Never commit directly to `main`
   - Use descriptive commit messages
8. **Consult ADRs** in `/docs/DEVELOPER_GUIDE.md` for architectural decisions
9. **Refer to documentation** before making structural changes:
   - `/docs/DEVELOPER_GUIDE.md` for architecture
   - `/docs/QUICK_START.md` for quick reference
   - `/CHANGELOG.md` for version history

### Content Rules

- **Never delete proven_in_use** entries (historical record)
- **Always document status changes** (e.g., Approved → Deprecated)
- **Keep ADRs immutable** (add new ones instead of modifying)
- **Tag PRAs accurately** for better search results
- **Create bilingual content** (FR and EN) for new PRAs
- **Respect scope hierarchy**: Bank-Wide vs Domain-Wide

### Architecture Rules (ADRs)

**ADR-001: Physical FR/EN Separation**
- Content MUST be in separate `pras-fr/` and `pras-en/` directories
- NO glob patterns like `**/fr/**` or `**/en/**`

**ADR-002: Simplified Collections**
- 2 PRA collections total: `pras_fr` and `pras_en`
- Each collection covers ALL scopes, statuses, categories
- NO map() operations on collections

**ADR-003: Flat File Structure**
- Files MUST be `pra-name.md` at category level
- NOT nested in `pra-name/page.md` subdirectories

**ADR-004: Bank-Wide vs Domain-Wide**
- `bank-wide/`: Cross-cutting (all sectors)
- `domain-wide/`: Domain-specific (particuliers, entreprises, gestion-patrimoine)
- Promotion = moving file from domain-wide/ to bank-wide/

---

## 🎯 Next Steps / Roadmap

**Planned Features**:
- [ ] Advanced search (multi-select filters, AND/OR logic)
- [ ] PRA comparison view (side-by-side)
- [ ] Export catalogue to CSV/PDF
- [ ] Comments/feedback system on PRAs
- [ ] Analytics dashboard (most viewed, most proven, etc.)
- [ ] RSS feed for new PRAs
- [ ] Integration with CI/CD (auto-validate metadata)

**Content Expansion**:
- [ ] Add more transversal PRAs (target: 20+)
- [ ] Complete sectorial PRAs for all 3 sectors
- [ ] Document promotion process with real examples
- [ ] Add video tutorials for key PRAs

---

## 📞 Support

**For questions or issues**:
- **GitHub Issues**: https://github.com/FofanaAmara/proven-reusable-architecture/issues
- **Internal Slack**: #pra-registry
- **Email**: pra-support@company.com
- **Governance Table**: pra-governance@company.com

---

**Last Updated**: 2025-12-03
**Version**: 1.0.0 (MVP)
**Maintained By**: Architecture Team, Banque Nationale du Canada
**Repository**: https://github.com/KiyaliHQ/proven-reusable-architecture

---

## 📋 Architecture Decision Records (ADRs)

For complete ADR documentation with context, rationale, and consequences, see `/docs/DEVELOPER_GUIDE.md`.

### ADR Summary

1. **ADR-001: Physical FR/EN Separation** - Separate `pras-fr/` and `pras-en/` directories
2. **ADR-002: Simplified Collections** - 2 PRA collections instead of 24
3. **ADR-003: Flat File Structure** - `pra-name.md` instead of `pra-name/page.md`
4. **ADR-004: Bank-Wide vs Domain-Wide** - Scope-based organization reflecting governance
