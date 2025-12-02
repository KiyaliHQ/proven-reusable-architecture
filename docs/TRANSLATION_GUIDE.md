# 🌐 Translation Guide for PRAs

This guide explains how to create multilingual PRAs (French + English).

---

## 📚 Overview

All PRAs in the registry should be available in both French and English:
- **French**: Primary language for BNC teams
- **English**: For broader accessibility and documentation sharing

---

## 🚀 Quick Start

### Step 1: Create Your PRA in French

Create your PRA documentation in French at:
```
content/fr/registre/[scope]/[category]/[your-pra].md
```

**Example:**
```
content/fr/registre/transversal/tech/kubernetes-deployment.md
```

### Step 2: Translate to English

Use your preferred LLM tool (Copilot, Claude, ChatGPT) with this prompt:

```
Translate this PRA document from French to English.
Preserve all Markdown formatting, keep technical terms unchanged,
translate only human-readable text in frontmatter and content.
Update internal links from /registre/ to /en/registre/.

[PASTE YOUR FRENCH PRA CONTENT HERE]
```

### Step 3: Save English Version

Save the translated content to the same path under `/en/`:
```
content/en/registre/[scope]/[category]/[your-pra].md
```

**Example:**
```
content/en/registre/transversal/tech/kubernetes-deployment.md
```

---

## 📋 Translation Checklist

When translating, ensure:

- [ ] ✅ Frontmatter structure is identical
- [ ] ✅ Technical terms preserved (PRA, ADR, CI/CD, API, etc.)
- [ ] ✅ Code blocks unchanged
- [ ] ✅ Internal links updated (`/registre/` → `/en/registre/`)
- [ ] ✅ Mermaid diagrams translated (text only)
- [ ] ✅ Emojis preserved
- [ ] ✅ File saved in correct location

---

## 🎯 What to Translate

### ✅ DO Translate:
- Page titles and descriptions
- All prose/documentation text
- Section headings
- Table content
- Comments in code examples
- Feedback in `proven_in_use` entries

### ❌ DON'T Translate:
- Technical acronyms (PRA, ADR, API, CI/CD, RBAC, etc.)
- Code (variable names, function names, commands)
- File paths and URLs
- Dates and version numbers
- Status values (`candidate`, `approved`, `deprecated`)
- Category values (`tech`, `integration`, `security`, `business`)
- Company name: "Banque Nationale du Canada"

---

## 📝 Translation Tools

### Option 1: VS Code Copilot (Recommended)
1. Open Copilot Chat
2. Paste translation prompt + your PRA
3. Copy result to new English file

### Option 2: Claude/ChatGPT
1. Open web interface
2. Paste translation prompt + your PRA
3. Copy result to new English file

### Option 3: Full Prompt Template
See: [`templates/TRANSLATION_PROMPT.md`](../templates/TRANSLATION_PROMPT.md)

---

## 🔄 Example Translation

### French Version (`content/fr/registre/transversal/tech/cicd-gitops.md`)

```markdown
---
title: CI/CD avec GitOps
description: Pattern de déploiement continu avec ArgoCD et Kubernetes
pra:
  name: CI/CD GitOps
  category: tech
  status: approved
  tags: [cicd, gitops, kubernetes, argocd]
  proven_in_use:
    - project: "Application Mobile Banking"
      team: "Équipe Retail"
      date: "2024-05-15"
      feedback: "Réduction 60% temps déploiement, zéro downtime"
---

# CI/CD avec GitOps

## 🎯 Résumé

Ce PRA décrit l'implémentation d'un pipeline CI/CD moderne...
```

### English Version (`content/en/registre/transversal/tech/cicd-gitops.md`)

```markdown
---
title: CI/CD with GitOps
description: Continuous deployment pattern with ArgoCD and Kubernetes
pra:
  name: CI/CD GitOps
  category: tech
  status: approved
  tags: [cicd, gitops, kubernetes, argocd]
  proven_in_use:
    - project: "Mobile Banking Application"
      team: "Retail Team"
      date: "2024-05-15"
      feedback: "60% reduction in deployment time, zero downtime"
---

# CI/CD with GitOps

## 🎯 Summary

This PRA describes the implementation of a modern CI/CD pipeline...
```

---

## ⚠️ Common Mistakes to Avoid

### ❌ Wrong: Translating technical terms
```markdown
# Mauvais / Wrong
category: technique  # ❌ Should be 'tech'
status: approuvé     # ❌ Should be 'approved'
```

### ✅ Correct: Keeping technical values
```markdown
# Bon / Correct
category: tech       # ✅
status: approved     # ✅
```

### ❌ Wrong: Forgetting to update links
```markdown
[Guide de démarrage](/registre/01-getting-started)  # ❌ French link in English doc
```

### ✅ Correct: Updated links
```markdown
[Getting Started Guide](/en/registre/01-getting-started)  # ✅
```

---

## 🤝 Getting Help

- **Detailed prompt**: See [`templates/TRANSLATION_PROMPT.md`](../templates/TRANSLATION_PROMPT.md)
- **Questions**: Teams channel `#pra-registry`
- **Issues**: [GitHub Issues](https://github.com/org/pra-registry/issues)

---

## 🎯 Why Bilingual?

1. **Internal teams**: Most comfortable in French
2. **External sharing**: English for broader audience
3. **Documentation standards**: Align with industry practices
4. **Future growth**: Ready for international collaboration

---

**Happy translating! 🌐**
