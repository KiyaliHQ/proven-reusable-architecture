#!/bin/bash
# =============================================================================
# generate-dashboard.sh — Generate PRA index/dashboard from .adoc metadata
# =============================================================================
#
# Scans all .adoc files in content/pras/{lang}/ and extracts :pra-*: attributes
# to generate an index.adoc table (dashboard) for each language.
#
# Usage: ./scripts/generate-dashboard.sh
# Idempotent: can be re-run at any time without side effects.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CONTENT_DIR="$ROOT_DIR/content/pras"

# Extract a single AsciiDoc attribute value from a file
# Usage: extract_attr <file> <attribute-name>
extract_attr() {
    local file="$1"
    local attr="$2"
    grep -m1 "^:${attr}:" "$file" 2>/dev/null | sed "s/^:${attr}: *//" || echo ""
}

# Generate index.adoc for a given language
generate_index() {
    local lang="$1"
    local lang_dir="$CONTENT_DIR/$lang"
    local index_file="$lang_dir/index.adoc"

    if [ ! -d "$lang_dir" ]; then
        echo "  [SKIP] $lang_dir does not exist"
        return
    fi

    # Determine labels based on language
    local title description col_name col_archetype col_subcategory col_status col_scope col_proven col_updated
    if [ "$lang" = "fr" ]; then
        title="Catalogue des PRA"
        description="Tableau de bord des Proven Reusable Architectures du registre."
        col_name="Nom"
        col_archetype="Archétype"
        col_subcategory="Sous-catégorie"
        col_status="Statut"
        col_scope="Scope"
        col_proven="Proven"
        col_updated="Dernière MAJ"
    else
        title="PRA Catalogue"
        description="Dashboard of Proven Reusable Architectures in the registry."
        col_name="Name"
        col_archetype="Archetype"
        col_subcategory="Subcategory"
        col_status="Status"
        col_scope="Scope"
        col_proven="Proven"
        col_updated="Last Updated"
    fi

    echo "  Generating $index_file ..."

    # Write header
    cat > "$index_file" <<EOF
= $title
:page-title: $title
:keywords: pra, catalogue, dashboard, registry

$description

[cols="3,1,1,1,1,1,1", options="header"]
|===
| $col_name | $col_archetype | $col_subcategory | $col_status | $col_scope | $col_proven | $col_updated

EOF

    # Find all .adoc PRA files (exclude index.adoc itself)
    local count=0
    find "$lang_dir" -name "*.adoc" -not -name "index.adoc" | sort | while read -r file; do
        local name archetype subcategory status scope proven_count updated
        name=$(extract_attr "$file" "pra-name")
        archetype=$(extract_attr "$file" "pra-archetype")
        subcategory=$(extract_attr "$file" "pra-subcategory")
        status=$(extract_attr "$file" "pra-status")
        scope=$(extract_attr "$file" "pra-scope")
        proven_count=$(extract_attr "$file" "pra-proven-count")
        updated=$(extract_attr "$file" "pra-updated")

        # Skip files without PRA metadata
        if [ -z "$name" ]; then
            continue
        fi

        # Compute relative path for link
        local rel_path
        rel_path="${file#$lang_dir/}"

        # Write table row
        echo "| link:${rel_path}[${name}] | ${archetype} | ${subcategory} | ${status} | ${scope} | ${proven_count} | ${updated}" >> "$index_file"
        count=$((count + 1))
    done

    # Close table
    echo "|===" >> "$index_file"
    echo "" >> "$index_file"

    echo "  Done: $index_file"
}

echo "=== Generating PRA dashboards ==="
echo ""

# Generate for each language
for lang_dir in "$CONTENT_DIR"/*/; do
    lang=$(basename "$lang_dir")
    # Only process language directories (fr, en)
    if [ -d "$lang_dir/bank-wide" ] || [ -d "$lang_dir/domain-wide" ]; then
        echo "[$lang]"
        generate_index "$lang"
        echo ""
    fi
done

echo "=== Dashboard generation complete ==="
