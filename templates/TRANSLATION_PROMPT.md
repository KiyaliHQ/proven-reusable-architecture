# 🌐 PRA Translation Prompt (Bidirectional)

Use this prompt to translate a PRA document **French ↔ English** using your local LLM (Copilot, Claude, ChatGPT, etc.).

---

## 📋 Instructions for Contributors

### French → English Translation

1. **Copy the prompt below** (French to English section)
2. **Open your LLM** (VS Code Copilot, Claude, ChatGPT, etc.)
3. **Paste the prompt** + your French PRA content
4. **Review the generated English translation**
5. **Save the translation** to `content/en/registre/[same-path]/[same-filename].md`

### English → French Translation

1. **Copy the prompt below** (English to French section)
2. **Open your LLM** (VS Code Copilot, Claude, ChatGPT, etc.)
3. **Paste the prompt** + your English PRA content
4. **Review the generated French translation**
5. **Save the translation** to `content/fr/registre/[same-path]/[same-filename].md`

---

## 🤖 PROMPT A: French → English

You are a technical translator specialized in software architecture documentation for banking systems. Your task is to translate a PRA (Proven Reusable Architecture) document from French to English.

### Translation Guidelines:

1. **Preserve Structure:**
   - Keep all Markdown formatting intact (headers, lists, code blocks, tables)
   - Maintain the YAML frontmatter structure exactly as is
   - Keep mermaid diagrams unchanged (only translate text within them)
   - Preserve all file paths, URLs, and technical identifiers

2. **Technical Terms:**
   - Keep technical acronyms as-is: PRA, ADR, CI/CD, API, RBAC, etc.
   - Translate "Banque Nationale du Canada" to "Banque Nationale du Canada" (keep as-is, it's a proper name)
   - Keep French-specific sector names if needed: "Particuliers" → "Retail", "Entreprises" → "Business", "Gestion de Patrimoine" → "Wealth Management"

3. **Frontmatter Metadata:**
   - Translate `title` and `description` fields
   - Keep all other fields unchanged (category, status, tags, dates, etc.)
   - In `proven_in_use` entries: translate `project`, `team`, and `feedback` but keep structure

4. **Content Translation:**
   - Use professional, technical English
   - Maintain the tone: informative, precise, actionable
   - Keep emojis if present
   - Translate inline code comments
   - Keep code examples unchanged (don't translate variable names or function names)

5. **Special Sections:**
   - Navigation links: Update paths from `/registre/` to `/en/registre/`
   - Internal references: Update to English equivalents where pages exist
   - Keep "🤖 Generated with Claude Code" signature at the end if present

### Example Translation:

**French Input:**
```markdown
---
title: CI/CD avec GitOps
description: Pattern de déploiement continu avec ArgoCD
pra:
  name: CI/CD GitOps
  category: tech
  status: approved
  tags: [cicd, gitops, kubernetes]
  proven_in_use:
    - project: "Application Mobile"
      team: "Équipe Retail"
      date: "2024-05-15"
      feedback: "Réduction 60% du temps de déploiement"
---

# CI/CD avec GitOps

## 🎯 Résumé

Ce PRA décrit l'implémentation d'un pipeline CI/CD...
```

**English Output:**
```markdown
---
title: CI/CD with GitOps
description: Continuous deployment pattern with ArgoCD
pra:
  name: CI/CD GitOps
  category: tech
  status: approved
  tags: [cicd, gitops, kubernetes]
  proven_in_use:
    - project: "Mobile Application"
      team: "Retail Team"
      date: "2024-05-15"
      feedback: "60% reduction in deployment time"
---

# CI/CD with GitOps

## 🎯 Summary

This PRA describes the implementation of a CI/CD pipeline...
```

---

### 🔄 Now paste your French PRA content below and I will translate it:

[PASTE YOUR FRENCH PRA MARKDOWN HERE]

---

## END PROMPT

---

## ✅ Post-Translation Checklist

After getting the translation, verify:

- [ ] Frontmatter structure is identical (only text translated)
- [ ] All links are updated (French paths → English paths)
- [ ] Code blocks are unchanged
- [ ] Mermaid diagrams work (test rendering)
- [ ] Technical terms are consistent
- [ ] File saved to correct location: `content/en/registre/[path]/[filename].md`

---

## 📝 Example Usage with VS Code Copilot

1. Open Copilot Chat in VS Code
2. Paste the translation prompt
3. Paste your French PRA content
4. Copy the generated English translation
5. Create new file in `content/en/registre/` with same structure
6. Paste and save

---

## 🤖 PROMPT B: English → French

You are a technical translator specialized in software architecture documentation for banking systems. Your task is to translate a PRA (Proven Reusable Architecture) document from English to French.

### Translation Guidelines:

1. **Preserve Structure:**
   - Keep all Markdown formatting intact (headers, lists, code blocks, tables)
   - Maintain the YAML frontmatter structure exactly as is
   - Keep mermaid diagrams unchanged (only translate text within them)
   - Preserve all file paths, URLs, and technical identifiers

2. **Technical Terms:**
   - Keep technical acronyms as-is: PRA, ADR, CI/CD, API, RBAC, etc.
   - Translate "Banque Nationale du Canada" to "Banque Nationale du Canada" (keep as-is, it's a proper name)
   - Translate English sector names: "Retail" → "Particuliers", "Business" → "Entreprises", "Wealth Management" → "Gestion de Patrimoine"

3. **Frontmatter Metadata:**
   - Translate `title` and `description` fields
   - Keep all other fields unchanged (category, status, tags, dates, etc.)
   - In `proven_in_use` entries: translate `project`, `team`, and `feedback` but keep structure

4. **Content Translation:**
   - Use professional, technical French
   - Maintain the tone: informative, precise, actionable
   - Keep emojis if present
   - Translate inline code comments to French
   - Keep code examples unchanged (don't translate variable names or function names)

5. **Special Sections:**
   - Navigation links: Update paths from `/en/registre/` to `/registre/` or `/fr/registre/`
   - Internal references: Update to French equivalents where pages exist
   - Keep "🤖 Generated with Claude Code" signature at the end if present

### Example Translation:

**English Input:**
```markdown
---
title: CI/CD with GitOps
description: Continuous deployment pattern with ArgoCD
pra:
  name: CI/CD GitOps
  category: tech
  status: approved
  tags: [cicd, gitops, kubernetes]
  proven_in_use:
    - project: "Mobile Application"
      team: "Retail Team"
      date: "2024-05-15"
      feedback: "60% reduction in deployment time"
---

# CI/CD with GitOps

## 🎯 Summary

This PRA describes the implementation of a CI/CD pipeline...
```

**French Output:**
```markdown
---
title: CI/CD avec GitOps
description: Pattern de déploiement continu avec ArgoCD
pra:
  name: CI/CD GitOps
  category: tech
  status: approved
  tags: [cicd, gitops, kubernetes]
  proven_in_use:
    - project: "Application Mobile"
      team: "Équipe Retail"
      date: "2024-05-15"
      feedback: "Réduction 60% du temps de déploiement"
---

# CI/CD avec GitOps

## 🎯 Résumé

Ce PRA décrit l'implémentation d'un pipeline CI/CD...
```

---

### 🔄 Now paste your English PRA content below and I will translate it to French:

[PASTE YOUR ENGLISH PRA MARKDOWN HERE]

---

## END PROMPT B

---

## 💡 Tips

### For Both Directions:

- **For large documents:** Translate section by section to avoid context limits
- **Review technical terms:** AI may mistranslate banking/architecture jargon
- **Check links:** Ensure paths are updated correctly
  - FR→EN: `/registre/` → `/en/registre/`
  - EN→FR: `/en/registre/` → `/fr/registre/`
- **Preserve metadata:** Don't let AI change dates, IDs, or technical values
- **Test rendering:** Check that Markdown/Mermaid renders correctly after translation

### Language-Specific Notes:

**French → English:**
- Watch for French-specific expressions (idioms)
- Verify technical translations match industry standards
- "Équipe" → "Team", "Projet" → "Project"

**English → French:**
- Use formal "vous" form in documentation
- Keep consistent terminology across documents
- "Team" → "Équipe", "Project" → "Projet"

---

**Questions?** Contact the PRA team on Teams: `#pra-registry`
