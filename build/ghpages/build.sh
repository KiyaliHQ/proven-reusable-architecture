#!/bin/bash
# =============================================================================
# build.sh — Build GitHub Pages site from AsciiDoc content
# =============================================================================
# Faithfully reproduces the BNC mockup design:
#   - 3-level sidebar with archetype grouping + empty archetypes
#   - Landing page with hero pill, search bar, 6-card grid, recent cards
#   - Dashboard with 8-column DataTable + dedicated filter dropdowns
#   - PRA pages with metadata card, breadcrumb, TOC, prev/next
#   - Guide pages with breadcrumb, TOC, prev/next
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SITE_DIR="$ROOT_DIR/_site"
CONTENT_DIR="$ROOT_DIR/content"
TMPL_DIR="$SCRIPT_DIR/templates"
ASSETS_SRC="$SCRIPT_DIR/assets"
BUILD_TMP="$ROOT_DIR/_build"

# 7 archetypes (always displayed, even if empty)
ARCHETYPES="integration application devops technology business data security"

# SVG constants
SVG_CATALOGUE='<svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><rect x="3" y="3" width="7" height="7"/><rect x="14" y="3" width="7" height="7"/><rect x="3" y="14" width="7" height="7"/><rect x="14" y="14" width="7" height="7"/></svg>'
SVG_SEARCH='<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>'
SVG_SEARCH_LG='<svg width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="11" cy="11" r="8"/><path d="M21 21l-4.35-4.35"/></svg>'
SVG_BC_SEP='<svg class="bc-sep" width="12" height="12" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7"/></svg>'
SVG_PREV='<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M15 19l-7-7 7-7"/></svg>'
SVG_NEXT='<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7"/></svg>'
SVG_CARD_ARROW='<svg width="16" height="16" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path d="M9 5l7 7-7 7"/></svg>'

# --- Check for Asciidoctor ---
if command -v asciidoctor &>/dev/null; then
    ASCIIDOCTOR="asciidoctor"
elif command -v docker &>/dev/null; then
    ASCIIDOCTOR="docker run --rm -v $ROOT_DIR:/workspace asciidoctor/docker-asciidoctor asciidoctor"
else
    echo "ERROR: asciidoctor not found. Install: brew install asciidoctor"
    exit 1
fi

# --- Check for asciidoctor-diagram ---
if $ASCIIDOCTOR -r asciidoctor-diagram --version &>/dev/null; then
    ASCIIDOCTOR="$ASCIIDOCTOR -r asciidoctor-diagram"
else
    echo "  [WARN] asciidoctor-diagram not found. PlantUML diagrams will not render."
    echo "         Install: gem install asciidoctor-diagram"
fi

# --- Check for Java (required by PlantUML) ---
if ! command -v java &>/dev/null; then
    echo "  [WARN] Java not found. PlantUML diagrams require Java to render."
fi

echo "=== Building PRA Registry site ==="
echo "  Asciidoctor: $ASCIIDOCTOR"
echo ""

# --- Clean ---
rm -rf "$SITE_DIR" "$BUILD_TMP"
mkdir -p "$SITE_DIR/assets" "$BUILD_TMP"

# --- Copy assets ---
cp "$ASSETS_SRC/style.css" "$SITE_DIR/assets/style.css"
cp "$ASSETS_SRC/nav.js" "$SITE_DIR/assets/nav.js"
if [ -f "$ASSETS_SRC/logo-bnc.svg" ]; then
    cp "$ASSETS_SRC/logo-bnc.svg" "$SITE_DIR/assets/logo-bnc.svg"
fi

# =============================================================================
# HELPERS
# =============================================================================
extract_attr() {
    local file="$1" attr="$2"
    grep -m1 "^:${attr}:" "$file" 2>/dev/null | sed "s/^:${attr}: *//" || echo ""
}

extract_title() {
    grep -m1 "^= " "$1" 2>/dev/null | sed 's/^= //' || echo "Untitled"
}

depth_prefix() {
    local rel="$1"
    local depth
    depth=$(echo "$rel" | tr -cd '/' | wc -c | tr -d ' ')
    local prefix=""
    for ((i=0; i<depth; i++)); do prefix="../${prefix}"; done
    echo "$prefix"
}

# Capitalize display name: devops→DevOps, gestion-patrimoine→Gestion Patrimoine
pretty_name() {
    local raw="$1"
    case "$raw" in
        devops|DevOps) echo "DevOps" ;;
        *)
            echo "$raw" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2)}1'
            ;;
    esac
}

# =============================================================================
# STEP 1: Build PRA index (sorted list per language for prev/next)
# =============================================================================
# Rewrite legacy absolute links (/guides/NN-slug, /registre/...) to relative paths
fix_internal_links() {
    local body="$1" lang="$2" assets_prefix="$3"
    local guides_base="${assets_prefix}guides/${lang}"
    local cat_base="${assets_prefix}${lang}/pras/index.html"

    echo "$body" | sed \
        -e "s|href=\"/guides/01-getting-started\"|href=\"${guides_base}/getting-started.html\"|g" \
        -e "s|href=\"/guides/02-understanding-pra\"|href=\"${guides_base}/understanding-pra.html\"|g" \
        -e "s|href=\"/guides/03-roles-responsibilities\"|href=\"${guides_base}/roles-responsibilities.html\"|g" \
        -e "s|href=\"/guides/04-lifecycle\"|href=\"${guides_base}/lifecycle.html\"|g" \
        -e "s|href=\"/guides/05-standards\"|href=\"${guides_base}/standards.html\"|g" \
        -e "s|href=\"/guides/06-contributing\"|href=\"${guides_base}/contributing.html\"|g" \
        -e "s|href=\"/guides/07-promotion-process\"|href=\"${guides_base}/promotion-process.html\"|g" \
        -e "s|href=\"/guides/08-governance\"|href=\"${guides_base}/governance.html\"|g" \
        -e "s|href=\"/registre/transversal\"|href=\"${cat_base}\"|g" \
        -e "s|href=\"/registre/[^\"]*\"|href=\"${cat_base}\"|g" \
        -e "s|href=\"/templates/[^\"]*\"|href=\"#\"|g"
}

echo "  [1/6] Building PRA & guide indexes ..."

build_pra_index() {
    local lang="$1"
    local pras_dir="$CONTENT_DIR/pras/$lang"
    local idx_file="$BUILD_TMP/pra-index-${lang}.tsv"
    > "$idx_file"

    find "$pras_dir" -name "*.adoc" -not -name "index.adoc" -not -name "overview.adoc" 2>/dev/null | sort | while read -r f; do
        local name
        name=$(extract_title "$f")
        [ -z "$name" ] && continue
        local rel="${f#$CONTENT_DIR/}"
        local html_rel="${rel%.adoc}.html"
        echo -e "${name}\t${html_rel}\t${f}"
    done | sort -t$'\t' -k1,1 > "$idx_file"
}

build_guide_index() {
    local lang="$1"
    local guides_dir="$CONTENT_DIR/guides/$lang"
    local idx_file="$BUILD_TMP/guide-index-${lang}.tsv"
    > "$idx_file"

    find "$guides_dir" -maxdepth 1 -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        local title
        title=$(extract_title "$f")
        local rel="${f#$CONTENT_DIR/}"
        local html_rel="${rel%.adoc}.html"
        echo -e "${title}\t${html_rel}\t${f}"
    done > "$idx_file"
}

for lang in fr en; do
    build_pra_index "$lang"
    build_guide_index "$lang"
done

# Get prev/next from index
get_prev_next() {
    local idx_file="$1" current_html_rel="$2"
    local prev_name="" prev_url="" next_name="" next_url=""
    local found=0 last_name="" last_url=""

    while IFS=$'\t' read -r name html_rel _adoc; do
        if [ "$found" -eq 1 ]; then
            next_name="$name"
            next_url="$html_rel"
            break
        fi
        if [ "$html_rel" = "$current_html_rel" ]; then
            found=1
            prev_name="$last_name"
            prev_url="$last_url"
        fi
        last_name="$name"
        last_url="$html_rel"
    done < "$idx_file"

    echo "${prev_name}|${prev_url}|${next_name}|${next_url}"
}

# =============================================================================
# STEP 2: Generate sidebar HTML (3-level tree matching mockups)
# =============================================================================
echo "  [2/6] Generating sidebars ..."

generate_sidebar() {
    local lang="$1"
    local pras_dir="$CONTENT_DIR/pras/$lang"
    local guides_dir="$CONTENT_DIR/guides/$lang"
    local out="$BUILD_TMP/sidebar-${lang}.html"

    # Count total PRAs
    local total_pras
    total_pras=$(find "$pras_dir" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | wc -l | tr -d ' ')

    # Catalogue label
    local cat_label="Catalogue"

    cat > "$out" <<'EOF'
<aside class="sidebar">
  <div class="sidebar-inner">
EOF

    # --- Catalogue top link ---
    cat >> "$out" <<EOF
    <a href="${lang}/pras/index.html" class="sidebar-catalogue">
      <span class="cat-icon">${SVG_CATALOGUE} ${cat_label}</span>
      <span class="sidebar-count">${total_pras}</span>
    </a>
    <div class="sidebar-divider"></div>
EOF

    # --- Overview link (if overview.adoc exists) ---
    if [ -f "$pras_dir/overview.adoc" ]; then
        local overview_label="Vue d'ensemble"
        [ "$lang" = "en" ] && overview_label="Overview"
        cat >> "$out" <<EOF
    <a href="pras/${lang}/overview.html" class="sidebar-guide" style="display:block;padding:6px 12px;font-weight:600;">📐 ${overview_label}</a>
    <div class="sidebar-divider"></div>
EOF
    fi

    # === BANK-WIDE ===
    cat >> "$out" <<'EOF'
    <div class="sidebar-section-title" onclick="toggleSection(this)"><span class="arrow"></span>Bank-Wide</div>
    <div class="tree-children collapsed">
EOF

    # Build per-archetype data for bank-wide
    for arch in $ARCHETYPES; do
        local display_name
        display_name=$(pretty_name "$arch")
        # Find bank-wide PRAs with this archetype
        local count=0
        local leaves=""
        while IFS=$'\t' read -r name html_rel adoc_file; do
            local scope file_arch
            scope=$(extract_attr "$adoc_file" "pra-scope")
            file_arch=$(extract_attr "$adoc_file" "pra-archetype")
            if [ "$scope" = "bank-wide" ] && [ "$file_arch" = "$arch" ]; then
                count=$((count + 1))
                leaves="${leaves}<a href=\"${html_rel}\" class=\"tree-leaf\">${name}</a>\n"
            fi
        done < "$BUILD_TMP/pra-index-${lang}.tsv"

        if [ "$count" -eq 0 ]; then
            echo "      <div class=\"tree-node empty\"><span class=\"arrow\"></span><span class=\"tree-label\">${display_name}</span><span class=\"tree-count\">0</span></div>" >> "$out"
        else
            echo "      <div class=\"tree-node\" onclick=\"toggleNode(this)\"><span class=\"arrow\"></span><span class=\"tree-label\">${display_name}</span><span class=\"tree-count\">${count}</span></div>" >> "$out"
            echo '      <div class="tree-children collapsed">' >> "$out"
            echo -e "$leaves" >> "$out"
            echo '      </div>' >> "$out"
        fi
    done

    cat >> "$out" <<'EOF'
    </div>
    <div class="sidebar-divider"></div>
EOF

    # === DOMAIN-WIDE ===
    cat >> "$out" <<'EOF'
    <div class="sidebar-section-title" onclick="toggleSection(this)"><span class="arrow"></span>Domain-Wide</div>
    <div class="tree-children collapsed">
EOF

    # Get list of domains from directory structure
    local domains=""
    if [ -d "$pras_dir/domain-wide" ]; then
        domains=$(find "$pras_dir/domain-wide" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort | while read -r d; do basename "$d"; done)
    fi

    for domain in $domains; do
        local domain_display
        domain_display=$(pretty_name "$domain")
        # Count PRAs in this domain
        local domain_count=0
        while IFS=$'\t' read -r name html_rel adoc_file; do
            local scope file_domain
            scope=$(extract_attr "$adoc_file" "pra-scope")
            file_domain=$(extract_attr "$adoc_file" "pra-domain")
            [ -z "$file_domain" ] && file_domain=$(echo "$adoc_file" | sed -n 's|.*domain-wide/\([^/]*\).*|\1|p')
            if [ "$scope" = "domain-wide" ] && [ "$file_domain" = "$domain" ]; then
                domain_count=$((domain_count + 1))
            fi
        done < "$BUILD_TMP/pra-index-${lang}.tsv"

        if [ "$domain_count" -eq 0 ]; then
            echo "      <div class=\"tree-node empty\"><span class=\"arrow\"></span><span class=\"tree-label\">${domain_display}</span><span class=\"tree-count\">0</span></div>" >> "$out"
            continue
        fi

        echo "      <div class=\"tree-node\" onclick=\"toggleNode(this)\"><span class=\"arrow\"></span><span class=\"tree-label\">${domain_display}</span><span class=\"tree-count\">${domain_count}</span></div>" >> "$out"
        echo '      <div class="tree-children collapsed">' >> "$out"

        # Sub-archetypes under this domain
        for arch in $ARCHETYPES; do
            local arch_display
            arch_display=$(pretty_name "$arch")
            local arch_count=0
            local deep_leaves=""
            while IFS=$'\t' read -r name html_rel adoc_file; do
                local scope file_domain file_arch
                scope=$(extract_attr "$adoc_file" "pra-scope")
                file_domain=$(extract_attr "$adoc_file" "pra-domain")
                [ -z "$file_domain" ] && file_domain=$(echo "$adoc_file" | sed -n 's|.*domain-wide/\([^/]*\).*|\1|p')
                file_arch=$(extract_attr "$adoc_file" "pra-archetype")
                if [ "$scope" = "domain-wide" ] && [ "$file_domain" = "$domain" ] && [ "$file_arch" = "$arch" ]; then
                    arch_count=$((arch_count + 1))
                    deep_leaves="${deep_leaves}<a href=\"${html_rel}\" class=\"tree-leaf-deep\">${name}</a>\n"
                fi
            done < "$BUILD_TMP/pra-index-${lang}.tsv"

            if [ "$arch_count" -eq 0 ]; then
                echo "        <div class=\"tree-subnode empty\"><span class=\"arrow\"></span><span class=\"tree-label\">${arch_display}</span><span class=\"tree-count\">0</span></div>" >> "$out"
            else
                echo "        <div class=\"tree-subnode\" onclick=\"toggleNode(this)\"><span class=\"arrow\"></span><span class=\"tree-label\">${arch_display}</span><span class=\"tree-count\">${arch_count}</span></div>" >> "$out"
                echo '        <div class="tree-children collapsed">' >> "$out"
                echo -e "$deep_leaves" >> "$out"
                echo '        </div>' >> "$out"
            fi
        done

        echo '      </div>' >> "$out"
    done

    cat >> "$out" <<'EOF'
    </div>
    <div class="sidebar-divider"></div>
EOF

    # === GUIDES ===
    cat >> "$out" <<'EOF'
    <div class="sidebar-section-title" onclick="toggleSection(this)"><span class="arrow"></span>Guides</div>
    <div class="tree-children collapsed">
EOF

    if [ -d "$guides_dir" ]; then
        while IFS=$'\t' read -r title html_rel _f; do
            echo "      <a href=\"${html_rel}\" class=\"sidebar-guide\">${title}</a>" >> "$out"
        done < "$BUILD_TMP/guide-index-${lang}.tsv"
    fi

    cat >> "$out" <<'EOF'
    </div>
  </div>
</aside>
EOF
}

for lang in fr en; do
    if [ -d "$CONTENT_DIR/pras/$lang" ]; then
        generate_sidebar "$lang"
    fi
done

# =============================================================================
# HELPER: fill template placeholders for header and footer
# =============================================================================
fill_templates() {
    local lang="$1"
    local assets_prefix="$2"
    local active_nav="${3:-}"  # home|catalogue|guides|""

    local other_lang="en"
    local nav_home="Accueil" nav_catalogue="Catalogue" nav_guides="Guides"
    local footer_contribute="Contribuer" footer_governance="Gouvernance"
    if [ "$lang" = "en" ]; then
        other_lang="fr"
        nav_home="Home"
        footer_contribute="Contribute" footer_governance="Governance"
    fi

    local home_url="${assets_prefix}${lang}/index.html"
    local catalogue_url="${assets_prefix}${lang}/pras/index.html"
    local guides_url="${assets_prefix}${lang}/guides/index.html"
    local lang_fr_url="${assets_prefix}fr/index.html"
    local lang_en_url="${assets_prefix}en/index.html"
    local lang_fr_active="" lang_en_active=""
    [ "$lang" = "fr" ] && lang_fr_active="active"
    [ "$lang" = "en" ] && lang_en_active="active"

    local nav_home_active="" nav_catalogue_active="" nav_guides_active=""
    case "$active_nav" in
        home) nav_home_active='class="active"' ;;
        catalogue) nav_catalogue_active='class="active"' ;;
        guides) nav_guides_active='class="active"' ;;
    esac

    local guide_contrib_url="${assets_prefix}guides/${lang}/contributing.html"
    local guide_gov_url="${assets_prefix}guides/${lang}/governance.html"

    # Read and fill header template
    local header_html
    header_html=$(cat "$TMPL_DIR/header.html")
    header_html=$(echo "$header_html" | sed \
        -e "s|{{HOME_URL}}|${home_url}|g" \
        -e "s|{{CATALOGUE_URL}}|${catalogue_url}|g" \
        -e "s|{{GUIDES_URL}}|${guides_url}|g" \
        -e "s|{{ASSETS_PREFIX}}|${assets_prefix}|g" \
        -e "s|{{NAV_HOME}}|${nav_home}|g" \
        -e "s|{{NAV_CATALOGUE}}|${nav_catalogue}|g" \
        -e "s|{{NAV_GUIDES}}|${nav_guides}|g" \
        -e "s|{{NAV_HOME_ACTIVE}}|${nav_home_active}|g" \
        -e "s|{{NAV_CATALOGUE_ACTIVE}}|${nav_catalogue_active}|g" \
        -e "s|{{NAV_GUIDES_ACTIVE}}|${nav_guides_active}|g" \
        -e "s|{{LANG_FR_URL}}|${lang_fr_url}|g" \
        -e "s|{{LANG_EN_URL}}|${lang_en_url}|g" \
        -e "s|{{LANG_FR_ACTIVE}}|${lang_fr_active}|g" \
        -e "s|{{LANG_EN_ACTIVE}}|${lang_en_active}|g")

    # Read and fill footer template
    local footer_html
    footer_html=$(cat "$TMPL_DIR/footer.html")
    footer_html=$(echo "$footer_html" | sed \
        -e "s|{{GUIDE_CONTRIB_URL}}|${guide_contrib_url}|g" \
        -e "s|{{GUIDE_GOV_URL}}|${guide_gov_url}|g" \
        -e "s|{{FOOTER_CONTRIBUTE}}|${footer_contribute}|g" \
        -e "s|{{FOOTER_GOVERNANCE}}|${footer_governance}|g")

    # Read and fill head template
    local head_html
    head_html=$(cat "$TMPL_DIR/head.html")
    head_html=$(echo "$head_html" | sed "s|{{ASSETS_PREFIX}}|${assets_prefix}|g")

    # Store in temp files for caller to read
    echo "$head_html" > "$BUILD_TMP/_head.html"
    echo "$header_html" > "$BUILD_TMP/_header.html"
    echo "$footer_html" > "$BUILD_TMP/_footer.html"
}

# =============================================================================
# HELPER: prepare sidebar with correct prefix and optional active link
# =============================================================================
prepare_sidebar() {
    local lang="$1"
    local assets_prefix="$2"
    local active_href="${3:-}"  # html_rel to mark active (no prefix)

    local sidebar_html
    sidebar_html=$(cat "$BUILD_TMP/sidebar-${lang}.html")
    # Prepend assets_prefix to all href
    sidebar_html=$(echo "$sidebar_html" | sed "s|href=\"|href=\"${assets_prefix}|g")
    # Mark active link if specified
    if [ -n "$active_href" ]; then
        local full_href="${assets_prefix}${active_href}"
        # Escape slashes for sed
        local escaped
        escaped=$(echo "$full_href" | sed 's/[\/&]/\\&/g')
        # Add active class: if the link already has class="...", insert "active " into it
        if echo "$sidebar_html" | grep -q "href=\"${full_href}\" class=\""; then
            sidebar_html=$(echo "$sidebar_html" | sed "s|href=\"${escaped}\" class=\"|href=\"${escaped}\" class=\"active |")
        else
            sidebar_html=$(echo "$sidebar_html" | sed "s|href=\"${escaped}\"|href=\"${escaped}\" class=\"active\"|")
        fi
    fi
    echo "$sidebar_html"
}

# =============================================================================
# HELPER: generate TOC from h2 headings in Asciidoctor HTML
# =============================================================================
generate_toc() {
    local html_file="$1"
    local lang="$2"
    local toc_title="Sur cette page"
    [ "$lang" = "en" ] && toc_title="On this page"

    local headings
    headings=$(grep -oE '<h[23] id="[^"]*">[^<]+' "$html_file" 2>/dev/null | sed 's/<h[23] id="\([^"]*\)">\(.*\)/\1|\2/' || echo "")

    if [ -z "$headings" ]; then
        echo ""
        return
    fi

    local toc_html="<div class=\"toc-title\">${toc_title}</div><nav class=\"toc-nav\">"
    while IFS='|' read -r id text; do
        [ -z "$id" ] && continue
        toc_html="${toc_html}<a href=\"#${id}\">${text}</a>"
    done <<< "$headings"
    toc_html="${toc_html}</nav>"
    echo "$toc_html"
}

# =============================================================================
# HELPER: Generate metadata card HTML for PRA pages
# =============================================================================
generate_meta_card() {
    local adoc_file="$1" lang="$2"

    local name arch subcat status scope domain tags version author maintainer created updated proven
    arch=$(extract_attr "$adoc_file" "pra-archetype")
    subcat=$(extract_attr "$adoc_file" "pra-subcategory")
    status=$(extract_attr "$adoc_file" "pra-status")
    scope=$(extract_attr "$adoc_file" "pra-scope")
    domain=$(extract_attr "$adoc_file" "pra-domain")
    tags=$(extract_attr "$adoc_file" "pra-tags")
    version=$(extract_attr "$adoc_file" "pra-version")
    [ -z "$version" ] && version="1.0.0"
    author=$(extract_attr "$adoc_file" "pra-author")
    [ -z "$author" ] && author="TBD"
    maintainer=$(extract_attr "$adoc_file" "pra-maintainer")
    [ -z "$maintainer" ] && maintainer="TBD"
    created=$(extract_attr "$adoc_file" "pra-created")
    updated=$(extract_attr "$adoc_file" "pra-updated")
    proven=$(extract_attr "$adoc_file" "pra-proven-count")
    [ -z "$proven" ] && proven="0"

    # Origin display
    local origin=""
    if [ "$scope" = "domain-wide" ]; then
        origin="$domain"
    else
        origin="$subcat"
    fi
    [ -z "$origin" ] && origin="—"

    # Status badge
    local status_html="<span class=\"badge badge-${status}\">${status}</span>"
    # Scope badge
    local scope_html="<span class=\"badge badge-scope\">${scope}</span>"
    # Origin badge
    local origin_html="<span class=\"badge badge-scope\">${origin}</span>"

    # Tags as clickable pills
    local tags_html=""
    if [ -n "$tags" ]; then
        IFS=',' read -ra tag_arr <<< "$tags"
        for tag in "${tag_arr[@]}"; do
            tag=$(echo "$tag" | sed 's/^ *//;s/ *$//')
            tags_html="${tags_html}<span class=\"tag-pill\">${tag}</span> "
        done
    fi

    # Labels
    local lbl_arch="Archetype" lbl_subcat="Sous-categorie" lbl_status="Statut" lbl_scope="Scope"
    local lbl_origin="Origine" lbl_proven="Proven-in-use" lbl_tags="Tags" lbl_version="Version"
    local lbl_author="Auteur" lbl_maint="Maintainer" lbl_created="Cree" lbl_updated="Derniere MAJ"
    if [ "$lang" = "en" ]; then
        lbl_subcat="Subcategory" lbl_status="Status" lbl_origin="Origin"
        lbl_proven="Proven-in-use" lbl_created="Created" lbl_updated="Last Updated"
        lbl_author="Author"
    fi

    # Author/maintainer class
    local author_cls=' class="meta-value"' maint_cls=' class="meta-value"'
    [ "$author" = "TBD" ] && author_cls=' class="meta-value muted"'
    [ "$maintainer" = "TBD" ] && maint_cls=' class="meta-value muted"'

    cat <<METAEOF
<div class="pra-meta-card">
  <table>
    <tr><td class="meta-label">${lbl_arch}</td><td class="meta-value">${arch}</td></tr>
    <tr><td class="meta-label">${lbl_subcat}</td><td class="meta-value">${subcat:-—}</td></tr>
    <tr><td class="meta-label">${lbl_status}</td><td class="meta-value">${status_html}</td></tr>
    <tr><td class="meta-label">${lbl_scope}</td><td class="meta-value">${scope_html}</td></tr>
    <tr><td class="meta-label">${lbl_origin}</td><td class="meta-value">${origin_html}</td></tr>
    <tr><td class="meta-label">${lbl_proven}</td><td class="meta-value" style="font-weight:600">${proven}</td></tr>
    <tr><td class="meta-label">${lbl_tags}</td><td class="meta-value">${tags_html:-—}</td></tr>
    <tr><td class="meta-label">${lbl_version}</td><td class="meta-value">${version}</td></tr>
    <tr><td class="meta-label">${lbl_author}</td><td${author_cls}>${author}</td></tr>
    <tr><td class="meta-label">${lbl_maint}</td><td${maint_cls}>${maintainer}</td></tr>
    <tr><td class="meta-label">${lbl_created}</td><td class="meta-value">${created:-—}</td></tr>
    <tr><td class="meta-label">${lbl_updated}</td><td class="meta-value">${updated:-—}</td></tr>
  </table>
</div>
METAEOF
}

# =============================================================================
# STEP 3: Convert PRA pages
# =============================================================================
echo "  [3/6] Converting PRA pages ..."

convert_pra_page() {
    local adoc_file="$1" lang="$2"

    local rel_path="${adoc_file#$CONTENT_DIR/}"
    local html_rel="${rel_path%.adoc}.html"
    local dest_file="$SITE_DIR/${html_rel}"
    mkdir -p "$(dirname "$dest_file")"

    local assets_prefix
    assets_prefix=$(depth_prefix "$html_rel")

    # Convert with Asciidoctor
    local tmp_html="$BUILD_TMP/tmp_pra_$(basename "${adoc_file%.adoc}").html"
    local dest_dir
    dest_dir="$(dirname "$dest_file")"
    $ASCIIDOCTOR -a stylesheet! -a linkcss -a source-highlighter=rouge \
        -a imagesoutdir="$dest_dir" -a imagesdir=. \
        -o "$tmp_html" "$adoc_file" 2>/dev/null || {
        echo "    [WARN] Failed: $adoc_file"
        return
    }

    local title
    title=$(extract_title "$adoc_file")

    # Extract body content
    local body
    body=$(sed -n '/<div id="content">/,/<div id="footer/{ /<div id="footer/d; p; }' "$tmp_html")
    if [ -z "$body" ]; then
        body=$(sed -n '/<div id="content">/,$ p' "$tmp_html" | head -n -3)
    fi

    # Strip the "Fiche signalétique" sidebarblock (duplicate of generated meta card)
    body=$(echo "$body" | awk '
        /<div class="sidebarblock">/ { skip=1; depth=0 }
        skip { depth += gsub(/<div[ >]/, "&"); depth -= gsub(/<\/div>/, "&"); if (depth <= 0) { skip=0 }; next }
        { print }
    ')

    # Fix internal links (legacy absolute paths → correct relative paths)
    body=$(fix_internal_links "$body" "$lang" "$assets_prefix")

    # Generate TOC
    local toc_html
    toc_html=$(generate_toc "$tmp_html" "$lang")

    # Generate metadata card (skip for overview pages)
    local meta_card=""
    local hide_meta
    hide_meta=$(extract_attr "$adoc_file" "pra-hide-meta")
    if [ "$hide_meta" != "true" ]; then
        meta_card=$(generate_meta_card "$adoc_file" "$lang")
    fi

    # Breadcrumb
    local bc_home="Accueil" bc_catalogue="Catalogue"
    [ "$lang" = "en" ] && bc_home="Home" && bc_catalogue="Catalogue"
    local home_url="${assets_prefix}${lang}/index.html"
    local cat_url="${assets_prefix}${lang}/pras/index.html"

    local breadcrumb="<nav class=\"breadcrumb\"><a href=\"${home_url}\">${bc_home}</a>${SVG_BC_SEP}<a href=\"${cat_url}\">${bc_catalogue}</a>${SVG_BC_SEP}<span class=\"bc-current\">${title}</span></nav>"

    # Prev/Next
    local prev_next
    prev_next=$(get_prev_next "$BUILD_TMP/pra-index-${lang}.tsv" "$html_rel")
    local prev_name prev_url next_name next_url
    IFS='|' read -r prev_name prev_url next_name next_url <<< "$prev_next"

    local nav_html="<div class=\"page-nav\">"
    if [ -n "$prev_name" ] && [ -n "$prev_url" ]; then
        nav_html="${nav_html}<a href=\"${assets_prefix}${prev_url}\">${SVG_PREV} ${prev_name}</a>"
    else
        nav_html="${nav_html}<span></span>"
    fi
    if [ -n "$next_name" ] && [ -n "$next_url" ]; then
        nav_html="${nav_html}<a href=\"${assets_prefix}${next_url}\">${next_name} ${SVG_NEXT}</a>"
    else
        nav_html="${nav_html}<span></span>"
    fi
    nav_html="${nav_html}</div>"

    # Fill templates
    fill_templates "$lang" "$assets_prefix" "catalogue"
    local head_html header_html footer_html
    head_html=$(cat "$BUILD_TMP/_head.html")
    header_html=$(cat "$BUILD_TMP/_header.html")
    footer_html=$(cat "$BUILD_TMP/_footer.html")

    # Prepare sidebar with active link
    local sidebar_html
    sidebar_html=$(prepare_sidebar "$lang" "$assets_prefix" "$html_rel")

    # TOC aside
    local toc_aside=""
    if [ -n "$toc_html" ]; then
        toc_aside="<aside class=\"toc-aside\"><div class=\"toc-sticky\">${toc_html}</div></aside>"
    fi

    # Write page
    cat > "$dest_file" <<HTMLEOF
<!DOCTYPE html>
<html lang="${lang}">
<head>
${head_html}
<title>${title} — Registre PRA</title>
</head>
<body>
${header_html}
<div class="page-layout">
${sidebar_html}
<main class="main-content">
<div class="content-wrapper">
<div class="content-article content">
${breadcrumb}
<h1>${title}</h1>
${meta_card}
${body}
${nav_html}
</div>
${toc_aside}
</div>
</main>
</div>
${footer_html}
<script src="${assets_prefix}assets/nav.js"></script>
</body>
</html>
HTMLEOF

    rm -f "$tmp_html"
}

for lang in fr en; do
    find "$CONTENT_DIR/pras/$lang" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        convert_pra_page "$f" "$lang"
    done
done

# =============================================================================
# STEP 3b: Convert guide pages
# =============================================================================
echo "  [3b/6] Converting guide pages ..."

convert_guide_page() {
    local adoc_file="$1" lang="$2"

    local rel_path="${adoc_file#$CONTENT_DIR/}"
    local html_rel="${rel_path%.adoc}.html"
    local dest_file="$SITE_DIR/${html_rel}"
    mkdir -p "$(dirname "$dest_file")"

    local assets_prefix
    assets_prefix=$(depth_prefix "$html_rel")

    # Convert with Asciidoctor
    local tmp_html="$BUILD_TMP/tmp_guide_$(basename "${adoc_file%.adoc}").html"
    local dest_dir
    dest_dir="$(dirname "$dest_file")"
    $ASCIIDOCTOR -a stylesheet! -a linkcss -a source-highlighter=rouge \
        -a imagesoutdir="$dest_dir" -a imagesdir=. \
        -o "$tmp_html" "$adoc_file" 2>/dev/null || {
        echo "    [WARN] Failed: $adoc_file"
        return
    }

    local title
    title=$(extract_title "$adoc_file")

    # Extract body
    local body
    body=$(sed -n '/<div id="content">/,/<div id="footer/{ /<div id="footer/d; p; }' "$tmp_html")
    if [ -z "$body" ]; then
        body=$(sed -n '/<div id="content">/,$ p' "$tmp_html" | head -n -3)
    fi

    # Fix internal links (legacy absolute paths → correct relative paths)
    body=$(fix_internal_links "$body" "$lang" "$assets_prefix")

    # Generate TOC
    local toc_html
    toc_html=$(generate_toc "$tmp_html" "$lang")

    # Breadcrumb
    local bc_home="Accueil" bc_guides="Guides"
    [ "$lang" = "en" ] && bc_home="Home" && bc_guides="Guides"
    local home_url="${assets_prefix}${lang}/index.html"
    local guides_url="${assets_prefix}${lang}/guides/index.html"

    local breadcrumb="<nav class=\"breadcrumb\"><a href=\"${home_url}\">${bc_home}</a>${SVG_BC_SEP}<a href=\"${guides_url}\">${bc_guides}</a>${SVG_BC_SEP}<span class=\"bc-current\">${title}</span></nav>"

    # Prev/Next
    local prev_next
    prev_next=$(get_prev_next "$BUILD_TMP/guide-index-${lang}.tsv" "$html_rel")
    local prev_name prev_url next_name next_url
    IFS='|' read -r prev_name prev_url next_name next_url <<< "$prev_next"

    local nav_html="<div class=\"page-nav\">"
    if [ -n "$prev_name" ] && [ -n "$prev_url" ]; then
        nav_html="${nav_html}<a href=\"${assets_prefix}${prev_url}\">${SVG_PREV} ${prev_name}</a>"
    else
        nav_html="${nav_html}<span></span>"
    fi
    if [ -n "$next_name" ] && [ -n "$next_url" ]; then
        nav_html="${nav_html}<a href=\"${assets_prefix}${next_url}\">${next_name} ${SVG_NEXT}</a>"
    else
        nav_html="${nav_html}<span></span>"
    fi
    nav_html="${nav_html}</div>"

    # Fill templates
    fill_templates "$lang" "$assets_prefix" "guides"
    local head_html header_html footer_html
    head_html=$(cat "$BUILD_TMP/_head.html")
    header_html=$(cat "$BUILD_TMP/_header.html")
    footer_html=$(cat "$BUILD_TMP/_footer.html")

    # Prepare sidebar with active link
    local sidebar_html
    sidebar_html=$(prepare_sidebar "$lang" "$assets_prefix" "$html_rel")

    # TOC aside
    local toc_aside=""
    if [ -n "$toc_html" ]; then
        toc_aside="<aside class=\"toc-aside\"><div class=\"toc-sticky\">${toc_html}</div></aside>"
    fi

    # Write page
    cat > "$dest_file" <<HTMLEOF
<!DOCTYPE html>
<html lang="${lang}">
<head>
${head_html}
<title>${title} — Registre PRA</title>
</head>
<body>
${header_html}
<div class="page-layout">
${sidebar_html}
<main class="main-content">
<div class="content-wrapper">
<div class="content-article content">
${breadcrumb}
<h1>${title}</h1>
${body}
${nav_html}
</div>
${toc_aside}
</div>
</main>
</div>
${footer_html}
<script src="${assets_prefix}assets/nav.js"></script>
</body>
</html>
HTMLEOF

    rm -f "$tmp_html"
}

for lang in fr en; do
    find "$CONTENT_DIR/guides/$lang" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        convert_guide_page "$f" "$lang"
    done
done

# =============================================================================
# STEP 4: Generate dashboard pages (8-column table + dedicated filters)
# =============================================================================
echo "  [4/6] Generating dashboards ..."

generate_dashboard() {
    local lang="$1"
    local pras_dir="$CONTENT_DIR/pras/$lang"
    local dest="$SITE_DIR/$lang/pras/index.html"
    mkdir -p "$(dirname "$dest")"

    local assets_prefix="../../"

    # Labels
    local title="Catalogue des PRA"
    local desc="Explorez l'ensemble des Proven Reusable Architectures du registre. Utilisez les filtres et la recherche pour trouver le pattern adapte a votre contexte."
    local bc_home="Accueil"
    local col_name="Nom" col_arch="Archetype" col_subcat="Sous-categorie" col_status="Statut"
    local col_scope="Scope" col_origin="Origine" col_proven="Proven" col_updated="MAJ"
    local lbl_all_arch="Tous les archetypes" lbl_all_status="Tous les statuts"
    local lbl_all_scope="Tous les scopes" lbl_all_origin="Toutes les origines"
    local lbl_reset="Reinitialiser" lbl_search="Rechercher..."
    if [ "$lang" = "en" ]; then
        title="PRA Catalogue"
        desc="Explore the full set of Proven Reusable Architectures in the registry. Use filters and search to find the right pattern for your context."
        bc_home="Home"
        col_name="Name" col_subcat="Subcategory" col_status="Status" col_origin="Origin"
        col_updated="Updated"
        lbl_all_arch="All archetypes" lbl_all_status="All statuses"
        lbl_all_scope="All scopes" lbl_all_origin="All origins"
        lbl_reset="Reset" lbl_search="Search..."
    fi

    # Build table rows
    > "$BUILD_TMP/dashboard-rows-${lang}.html"
    find "$pras_dir" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        local name arch subcat status scope domain proven updated
        name=$(extract_title "$f")
        [ -z "$name" ] && continue
        arch=$(extract_attr "$f" "pra-archetype")
        subcat=$(extract_attr "$f" "pra-subcategory")
        status=$(extract_attr "$f" "pra-status")
        scope=$(extract_attr "$f" "pra-scope")
        domain=$(extract_attr "$f" "pra-domain")
        proven=$(extract_attr "$f" "pra-proven-count")
        updated=$(extract_attr "$f" "pra-updated")

        # Origin: domain for domain-wide, subcategory for bank-wide
        local origin="$domain"
        [ -z "$origin" ] && origin="$subcat"

        local rel="${f#$CONTENT_DIR/pras/$lang/}"
        rel="${rel%.adoc}.html"
        local link="${assets_prefix}pras/${lang}/${rel}"

        echo "<tr><td><a href=\"${link}\" class=\"pra-link\">${name}</a></td><td>${arch}</td><td>${subcat}</td><td><span class=\"badge badge-${status}\">${status}</span></td><td><span class=\"badge badge-scope\">${scope}</span></td><td><span class=\"badge badge-scope\">${origin}</span></td><td style=\"text-align:center;font-weight:500\">${proven}</td><td style=\"color:var(--gray-500)\">${updated}</td></tr>"
    done >> "$BUILD_TMP/dashboard-rows-${lang}.html"

    local table_rows
    table_rows=$(cat "$BUILD_TMP/dashboard-rows-${lang}.html")

    # Fill templates
    fill_templates "$lang" "$assets_prefix" "catalogue"
    local head_html header_html footer_html
    head_html=$(cat "$BUILD_TMP/_head.html")
    header_html=$(cat "$BUILD_TMP/_header.html")
    footer_html=$(cat "$BUILD_TMP/_footer.html")

    # Prepare sidebar (catalogue link active)
    local sidebar_html
    sidebar_html=$(prepare_sidebar "$lang" "$assets_prefix" "")
    # Mark catalogue link as active
    sidebar_html=$(echo "$sidebar_html" | sed 's|class="sidebar-catalogue"|class="sidebar-catalogue active"|')

    local home_url="${assets_prefix}${lang}/index.html"

    cat > "$dest" <<HTMLEOF
<!DOCTYPE html>
<html lang="${lang}">
<head>
${head_html}
<title>${title} — Registre PRA</title>
</head>
<body>
${header_html}
<div class="page-layout">
${sidebar_html}
<main class="main-content">

<nav class="breadcrumb"><a href="${home_url}">${bc_home}</a>${SVG_BC_SEP}<span class="bc-current">${title}</span></nav>

<h1 style="font-size:1.5rem;font-weight:700;color:var(--gray-900);margin-bottom:0.5rem">${title}</h1>
<p class="dashboard-desc">${desc}</p>

<!-- Filters -->
<div class="filter-bar">
  <div class="filter-search-wrap">
    <div class="filter-search-icon">${SVG_SEARCH}</div>
    <input id="global-search" type="text" placeholder="${lbl_search}" class="filter-search" oninput="filterTable()">
  </div>
  <select id="filter-archetype" class="filter-select" onchange="filterTable()">
    <option value="">${lbl_all_arch}</option>
    <option value="technology">Technology</option>
    <option value="integration">Integration</option>
    <option value="business">Business</option>
    <option value="application">Application</option>
    <option value="devops">DevOps</option>
    <option value="data">Data</option>
    <option value="security">Security</option>
  </select>
  <select id="filter-status" class="filter-select" onchange="filterTable()">
    <option value="">${lbl_all_status}</option>
    <option value="operationalizing">Operationalizing</option>
    <option value="operationalized">Operationalized</option>
    <option value="deprecated">Deprecated</option>
  </select>
  <select id="filter-scope" class="filter-select" onchange="filterTable()">
    <option value="">${lbl_all_scope}</option>
    <option value="bank-wide">Bank-Wide</option>
    <option value="domain-wide">Domain-Wide</option>
  </select>
  <select id="filter-origin" class="filter-select" onchange="filterTable()">
    <option value="">${lbl_all_origin}</option>
  </select>
  <button onclick="clearFilters()" class="filter-reset">${lbl_reset}</button>
</div>

<!-- Table -->
<div class="dashboard-table-wrap">
  <table id="pra-table" style="width:100%">
    <thead>
      <tr>
        <th>${col_name}</th>
        <th>${col_arch}</th>
        <th>${col_subcat}</th>
        <th>${col_status}</th>
        <th>${col_scope}</th>
        <th>${col_origin}</th>
        <th>${col_proven}</th>
        <th>${col_updated}</th>
      </tr>
    </thead>
    <tbody>
${table_rows}
    </tbody>
  </table>
</div>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script>
var table;
\$(document).ready(function() {
    table = \$('#pra-table').DataTable({
        pageLength: 20,
        dom: '<"dataTables-info-bar"ip>t',
        language: {
            info: "_START_ - _END_ / _TOTAL_ PRAs",
            infoEmpty: "Aucun PRA",
            infoFiltered: "(filtre de _MAX_ total)",
            zeroRecords: "Aucun PRA trouve",
            paginate: { previous: "\u2190", next: "\u2192" }
        },
        order: [[7, 'desc']],
        columnDefs: [
            { targets: [6], className: 'text-center' }
        ]
    });

    // Populate origin filter dynamically
    var originSelect = \$('#filter-origin');
    var origins = [];
    table.column(5).data().each(function(d) {
        var text = \$('<div>').html(d).text().trim();
        if (text && origins.indexOf(text) === -1) origins.push(text);
    });
    origins.sort().forEach(function(o) {
        originSelect.append('<option value="' + o + '">' + o + '</option>');
    });

    // Read ?q= param from URL
    var urlParams = new URLSearchParams(window.location.search);
    var q = urlParams.get('q');
    if (q) {
        \$('#global-search').val(q);
        table.search(q).draw();
    }
});

function filterTable() {
    var globalSearch = \$('#global-search').val();
    var archetype = \$('#filter-archetype').val();
    var status = \$('#filter-status').val();
    var scope = \$('#filter-scope').val();
    var origin = \$('#filter-origin').val();

    table.search(globalSearch);
    table.column(1).search(archetype);
    table.column(3).search(status);
    table.column(4).search(scope);
    table.column(5).search(origin);
    table.draw();
}

function clearFilters() {
    \$('#global-search').val('');
    \$('#filter-archetype').val('');
    \$('#filter-status').val('');
    \$('#filter-scope').val('');
    \$('#filter-origin').val('');
    table.search('').columns().search('').draw();
    if (window.history.replaceState) {
        window.history.replaceState({}, '', window.location.pathname);
    }
}
</script>

</main>
</div>
${footer_html}
<script src="${assets_prefix}assets/nav.js"></script>
</body>
</html>
HTMLEOF

    echo "    $dest"
}

generate_dashboard "fr"
generate_dashboard "en"

# =============================================================================
# STEP 5: Generate landing pages (hero pill + search + 6 cards + recent cards)
# =============================================================================
echo "  [5/6] Generating landing pages ..."

generate_landing() {
    local lang="$1"
    local pras_dir="$CONTENT_DIR/pras/$lang"
    local dest="$SITE_DIR/$lang/index.html"
    mkdir -p "$(dirname "$dest")"

    local assets_prefix="../"

    # Count PRAs
    local total_pras bw_count dw_count
    total_pras=$(find "$pras_dir" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | wc -l | tr -d ' ')
    bw_count=$(find "$pras_dir/bank-wide" -name "*.adoc" 2>/dev/null | wc -l | tr -d ' ')
    dw_count=$(find "$pras_dir/domain-wide" -name "*.adoc" 2>/dev/null | wc -l | tr -d ' ')

    # Labels
    local hero_pill="Registre officiel — Architecture d'entreprise"
    local hero_sub="Capitalisez sur les architectures eprouvees en production. Trouvez, reutilisez et contribuez aux patterns valides de la Banque Nationale."
    local search_placeholder="Rechercher un PRA, un pattern, une technologie..."
    local stat_total="PRAs au registre" stat_bw="Bank-Wide" stat_dw="Domain-Wide"
    local section_explore="Explorer le registre" section_recent="Dernieres mises a jour"
    local card1_title="Bank-Wide" card1_desc="Patterns transversaux applicables a tous les domaines d'affaires. Valides pour l'ensemble de la banque."
    local card2_title="Domain-Wide" card2_desc="Patterns specifiques par domaine d'affaires : Particuliers, Entreprises, Gestion de Patrimoine."
    local card3_title="Catalogue complet" card3_desc="Tableau filtrable de tous les PRAs du registre. Recherche, tri et filtres par archetype, statut, scope."
    local card4_title="Guides" card4_desc="Contribuer un PRA, gouvernance, standards de qualite, cycle de vie, processus de promotion."
    local card5_title="Demarrage rapide" card5_desc="Nouveau dans le registre? Comprenez ce qu'est un PRA, comment en trouver un et comment l'utiliser."
    local card6_title="Agents IA" card6_desc="PRA Explorer et PRA Guide : deux agents IA pour vous assister dans la recherche et la comprehension des PRAs."
    local card1_action="${bw_count} PRAs" card2_action="${dw_count} PRAs" card3_action="Explorer"
    local card4_action="Lire les guides" card5_action="Commencer"
    local card6_sub="Disponible dans Claude Code"

    if [ "$lang" = "en" ]; then
        hero_pill="Official Registry — Enterprise Architecture"
        hero_sub="Leverage proven production architectures. Find, reuse and contribute to validated patterns at Banque Nationale."
        search_placeholder="Search for a PRA, pattern, technology..."
        stat_total="PRAs in registry" stat_bw="Bank-Wide" stat_dw="Domain-Wide"
        section_explore="Explore the registry" section_recent="Latest updates"
        card1_desc="Cross-cutting patterns for all business domains. Validated for the entire bank."
        card2_desc="Domain-specific patterns: Retail, Corporate, Wealth Management."
        card3_title="Full Catalogue" card3_desc="Filterable table of all PRAs. Search, sort and filter by archetype, status, scope."
        card4_desc="Contributing a PRA, governance, quality standards, lifecycle, promotion process."
        card5_title="Quick Start" card5_desc="New to the registry? Understand what a PRA is, how to find one and how to use it."
        card6_title="AI Agents" card6_desc="PRA Explorer and PRA Guide: two AI agents to help you search and understand PRAs."
        card3_action="Explore" card4_action="Read guides" card5_action="Get started"
        card6_sub="Available in Claude Code"
    fi

    local cat_url="${assets_prefix}${lang}/pras/index.html"
    local guides_url="${assets_prefix}${lang}/guides/index.html"

    # Recent PRAs (top 3 by updated date)
    > "$BUILD_TMP/recent-${lang}.txt"
    find "$pras_dir" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | while read -r f; do
        local name updated status desc_text
        name=$(extract_title "$f")
        updated=$(extract_attr "$f" "pra-updated")
        status=$(extract_attr "$f" "pra-status")
        [ -z "$name" ] && continue
        local rel="${assets_prefix}pras/${lang}/${f#$pras_dir/}"
        rel="${rel%.adoc}.html"
        echo "${updated}|${name}|${rel}|${status}"
    done | sort -r | head -3 > "$BUILD_TMP/recent-${lang}.txt"

    local recent_cards=""
    while IFS='|' read -r date name url status; do
        [ -z "$name" ] && continue
        recent_cards="${recent_cards}
        <a href=\"${url}\" class=\"recent-card\">
          <div class=\"recent-card-top\">
            <span class=\"badge badge-${status}\">${status}</span>
            <span class=\"recent-card-date\">${date}</span>
          </div>
          <h3>${name}</h3>
        </a>"
    done < "$BUILD_TMP/recent-${lang}.txt"

    # Fill templates
    fill_templates "$lang" "$assets_prefix" "home"
    local head_html header_html footer_html
    head_html=$(cat "$BUILD_TMP/_head.html")
    header_html=$(cat "$BUILD_TMP/_header.html")
    footer_html=$(cat "$BUILD_TMP/_footer.html")

    cat > "$dest" <<HTMLEOF
<!DOCTYPE html>
<html lang="${lang}">
<head>
${head_html}
<title>Registre PRA — Banque Nationale du Canada</title>
</head>
<body>
${header_html}

<!-- Hero Section -->
<section class="landing-hero">
  <div class="hero-pill">
    <span class="hero-pill-dot"></span>
    ${hero_pill}
  </div>
  <h1>Proven Reusable Architecture</h1>
  <p class="hero-sub">${hero_sub}</p>

  <form class="hero-search" onsubmit="window.location.href='${cat_url}?q='+encodeURIComponent(this.querySelector('input').value); return false;">
    <div class="hero-search-icon">${SVG_SEARCH_LG}</div>
    <input type="text" placeholder="${search_placeholder}">
  </form>

  <div class="hero-stats">
    <div class="hero-stat">
      <div class="hero-stat-number">${total_pras}</div>
      <div class="hero-stat-label">${stat_total}</div>
    </div>
    <div class="hero-stat-sep"></div>
    <div class="hero-stat">
      <div class="hero-stat-number accent">${bw_count}</div>
      <div class="hero-stat-label">${stat_bw}</div>
    </div>
    <div class="hero-stat-sep"></div>
    <div class="hero-stat">
      <div class="hero-stat-number">${dw_count}</div>
      <div class="hero-stat-label">${stat_dw}</div>
    </div>
  </div>
</section>

<!-- Card Grid -->
<section class="landing-section">
  <div class="landing-section-title">${section_explore}</div>
  <div class="card-grid">
    <a href="${cat_url}?q=bank-wide" class="landing-card">
      <div class="card-icon red">&#127963;&#65039;</div>
      <h3>${card1_title}</h3>
      <p>${card1_desc}</p>
      <div class="card-action">${card1_action} ${SVG_CARD_ARROW}</div>
    </a>
    <a href="${cat_url}?q=domain-wide" class="landing-card">
      <div class="card-icon blue">&#127970;</div>
      <h3>${card2_title}</h3>
      <p>${card2_desc}</p>
      <div class="card-action">${card2_action} ${SVG_CARD_ARROW}</div>
    </a>
    <a href="${cat_url}" class="landing-card">
      <div class="card-icon purple">&#128202;</div>
      <h3>${card3_title}</h3>
      <p>${card3_desc}</p>
      <div class="card-action">${card3_action} ${SVG_CARD_ARROW}</div>
    </a>
    <a href="${guides_url}" class="landing-card">
      <div class="card-icon green">&#128218;</div>
      <h3>${card4_title}</h3>
      <p>${card4_desc}</p>
      <div class="card-action">${card4_action} ${SVG_CARD_ARROW}</div>
    </a>
    <a href="${assets_prefix}guides/${lang}/getting-started.html" class="landing-card">
      <div class="card-icon orange">&#128640;</div>
      <h3>${card5_title}</h3>
      <p>${card5_desc}</p>
      <div class="card-action">${card5_action} ${SVG_CARD_ARROW}</div>
    </a>
    <div class="landing-card" style="cursor:default">
      <span class="card-badge-new">Nouveau</span>
      <div class="card-icon gray">&#129302;</div>
      <h3>${card6_title}</h3>
      <p>${card6_desc}</p>
      <div class="card-action-text">${card6_sub}</div>
    </div>
  </div>
</section>

<!-- Recent Updates -->
<section class="recent-section">
  <div class="recent-inner">
    <div class="landing-section-title">${section_recent}</div>
    <div class="recent-grid">
      ${recent_cards}
    </div>
  </div>
</section>

${footer_html}
<script src="${assets_prefix}assets/nav.js"></script>
</body>
</html>
HTMLEOF

    echo "    $dest"
}

generate_landing "fr"
generate_landing "en"

# =============================================================================
# Root landing (language chooser)
# =============================================================================
cat > "$SITE_DIR/index.html" <<'ROOTEOF'
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="assets/style.css">
<title>PRA Registry — Banque Nationale du Canada</title>
</head>
<body>
<div class="top-bar"></div>
<section class="landing-hero" style="min-height:100vh;display:flex;flex-direction:column;align-items:center;justify-content:center">
  <div style="text-align:center">
    <img src="assets/logo-bnc.svg" alt="Banque Nationale" style="height:40px;margin-bottom:2rem">
    <h1 style="font-size:2.5rem;font-weight:700;color:var(--gray-900);margin-bottom:0.5rem;letter-spacing:-0.025em">Proven Reusable Architecture</h1>
    <p class="hero-sub">Banque Nationale du Canada &mdash; PRA Registry</p>
    <div style="margin-top:2.5rem;display:flex;justify-content:center;gap:1rem;">
      <a href="fr/index.html" style="display:inline-block;padding:0.7rem 2rem;background:var(--bnc);color:white;border-radius:8px;font-weight:600;font-size:0.95rem;text-decoration:none;">Fran&ccedil;ais</a>
      <a href="en/index.html" style="display:inline-block;padding:0.7rem 2rem;background:var(--gray-100);color:var(--gray-700);border:1px solid var(--gray-200);border-radius:8px;font-weight:600;font-size:0.95rem;text-decoration:none;">English</a>
    </div>
  </div>
</section>
<footer class="site-footer"><div class="footer-inner"><span class="footer-copy">&copy; 2026 Banque Nationale du Canada &mdash; Architecture d'entreprise</span></div></footer>
</body>
</html>
ROOTEOF

# =============================================================================
# Guide index pages
# =============================================================================
for lang in fr en; do
    guides_dir="$CONTENT_DIR/guides/$lang"
    dest="$SITE_DIR/$lang/guides/index.html"
    mkdir -p "$(dirname "$dest")"
    assets_prefix="../../"

    title="Guides du registre"
    [ "$lang" = "en" ] && title="Registry Guides"

    bc_home="Accueil"
    [ "$lang" = "en" ] && bc_home="Home"

    home_url="${assets_prefix}${lang}/index.html"

    # Build guide list
    guide_items=""
    while IFS=$'\t' read -r gtitle ghtml_rel _gf; do
        guide_items="${guide_items}<a href=\"${assets_prefix}${ghtml_rel}\" class=\"sidebar-guide\" style=\"display:flex;padding:0.75rem 1rem;font-size:0.9375rem;border-left:none\">${gtitle}</a>"
    done < "$BUILD_TMP/guide-index-${lang}.tsv"

    # Fill templates
    fill_templates "$lang" "$assets_prefix" "guides"
    head_html=$(cat "$BUILD_TMP/_head.html")
    header_html=$(cat "$BUILD_TMP/_header.html")
    footer_html=$(cat "$BUILD_TMP/_footer.html")

    sidebar_html=$(prepare_sidebar "$lang" "$assets_prefix" "")

    cat > "$dest" <<HTMLEOF
<!DOCTYPE html>
<html lang="${lang}">
<head>
${head_html}
<title>${title} — Registre PRA</title>
</head>
<body>
${header_html}
<div class="page-layout">
${sidebar_html}
<main class="main-content">
<nav class="breadcrumb"><a href="${home_url}">${bc_home}</a>${SVG_BC_SEP}<span class="bc-current">${title}</span></nav>
<h1 style="font-size:1.5rem;font-weight:700;color:var(--gray-900);margin-bottom:1.5rem">${title}</h1>
<div style="display:flex;flex-direction:column;gap:0.125rem;border:1px solid var(--gray-200);border-radius:0.75rem;overflow:hidden">
${guide_items}
</div>
</main>
</div>
${footer_html}
<script src="${assets_prefix}assets/nav.js"></script>
</body>
</html>
HTMLEOF
done

# =============================================================================
# STEP 6: Cleanup
# =============================================================================
echo "  [6/6] Cleanup ..."
rm -rf "$BUILD_TMP"

echo ""
echo "=== Build complete ==="
echo "  Site: $SITE_DIR"
echo "  Files: $(find "$SITE_DIR" -name "*.html" | wc -l | tr -d ' ') HTML pages"
