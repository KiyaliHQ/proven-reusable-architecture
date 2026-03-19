#!/bin/bash
# =============================================================================
# build.sh — Build GitHub Pages site from AsciiDoc content
# =============================================================================
# Converts .adoc to HTML, wraps in BNC corporate layout with sidebar navigation,
# generates dashboard with DataTables, and landing page with live stats.
#
# Usage: ./build/ghpages/build.sh
# Output: _site/ directory ready for GitHub Pages deployment
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SITE_DIR="$ROOT_DIR/_site"
CONTENT_DIR="$ROOT_DIR/content"
TMPL_DIR="$SCRIPT_DIR/templates"
ASSETS_SRC="$SCRIPT_DIR/assets"
BUILD_TMP="$ROOT_DIR/_build"

# --- Check for Asciidoctor ---
if command -v asciidoctor &>/dev/null; then
    ASCIIDOCTOR="asciidoctor"
elif command -v docker &>/dev/null; then
    ASCIIDOCTOR="docker run --rm -v $ROOT_DIR:/workspace asciidoctor/docker-asciidoctor asciidoctor"
else
    echo "ERROR: asciidoctor not found. Install: brew install asciidoctor"
    exit 1
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

# =============================================================================
# HELPER: extract AsciiDoc attribute
# =============================================================================
extract_attr() {
    local file="$1" attr="$2"
    grep -m1 "^:${attr}:" "$file" 2>/dev/null | sed "s/^:${attr}: *//" || echo ""
}

# =============================================================================
# HELPER: extract title from AsciiDoc (= Title line)
# =============================================================================
extract_title() {
    grep -m1 "^= " "$1" 2>/dev/null | sed 's/^= //' || echo "Untitled"
}

# =============================================================================
# HELPER: compute relative path prefix from a file path to _site root
# =============================================================================
depth_prefix() {
    local rel="$1"
    local depth
    depth=$(echo "$rel" | tr -cd '/' | wc -c | tr -d ' ')
    local prefix=""
    for ((i=0; i<depth; i++)); do prefix="../${prefix}"; done
    echo "$prefix"
}

# =============================================================================
# HELPER: SVG arrow for tree nodes
# =============================================================================
ARROW_SVG='<svg class="tree-arrow" viewBox="0 0 16 16" fill="currentColor"><path d="M6 3l5 5-5 5z"/></svg>'

# =============================================================================
# 3a. GENERATE SIDEBAR HTML
# =============================================================================
generate_sidebar() {
    local lang="$1"
    local pras_dir="$CONTENT_DIR/pras/$lang"
    local guides_dir="$CONTENT_DIR/guides/$lang"
    local base_prefix="$2"  # relative path from page to site root
    local out="$BUILD_TMP/sidebar-${lang}.html"

    cat > "$out" <<SIDEBAR_TOP
<aside class="sidebar">
SIDEBAR_TOP

    # --- PRAs section ---
    echo '  <div class="sidebar-section">' >> "$out"
    echo '    <div class="sidebar-title">PRA Catalogue</div>' >> "$out"
    echo '    <ul class="tree-node">' >> "$out"

    # Bank-Wide
    if [ -d "$pras_dir/bank-wide" ]; then
        local bw_count=0
        for arch_dir in "$pras_dir/bank-wide"/*/; do
            [ -d "$arch_dir" ] || continue
            bw_count=$((bw_count + $(find "$arch_dir" -maxdepth 1 -name "*.adoc" | wc -l | tr -d ' ')))
        done
        echo "      <li>" >> "$out"
        echo "        <span class=\"tree-label\" data-toggle>${ARROW_SVG} Bank-Wide <span class=\"tree-count\">${bw_count}</span></span>" >> "$out"
        echo '        <ul class="tree-children">' >> "$out"
        for arch_dir in "$pras_dir/bank-wide"/*/; do
            [ -d "$arch_dir" ] || continue
            local arch_name
            arch_name=$(basename "$arch_dir")
            local arch_files
            arch_files=$(find "$arch_dir" -maxdepth 1 -name "*.adoc" | sort)
            local arch_count
            arch_count=$(echo "$arch_files" | grep -c "\.adoc$" || echo "0")
            [ "$arch_count" -eq 0 ] && continue
            echo "          <li>" >> "$out"
            echo "            <span class=\"tree-label\" data-toggle>${ARROW_SVG} ${arch_name} <span class=\"tree-count\">${arch_count}</span></span>" >> "$out"
            echo '            <ul class="tree-children">' >> "$out"
            echo "$arch_files" | while read -r f; do
                [ -z "$f" ] && continue
                local title
                title=$(extract_title "$f")
                local rel
                rel="${f#$CONTENT_DIR/}"
                rel="${rel%.adoc}.html"
                echo "              <li class=\"tree-leaf\"><a href=\"${base_prefix}${rel}\">${title}</a></li>" >> "$out"
            done
            echo '            </ul>' >> "$out"
            echo '          </li>' >> "$out"
        done
        echo '        </ul>' >> "$out"
        echo '      </li>' >> "$out"
    fi

    # Domain-Wide
    if [ -d "$pras_dir/domain-wide" ]; then
        local dw_count=0
        dw_count=$(find "$pras_dir/domain-wide" -name "*.adoc" | wc -l | tr -d ' ')
        echo "      <li>" >> "$out"
        echo "        <span class=\"tree-label\" data-toggle>${ARROW_SVG} Domain-Wide <span class=\"tree-count\">${dw_count}</span></span>" >> "$out"
        echo '        <ul class="tree-children">' >> "$out"
        for domain_dir in "$pras_dir/domain-wide"/*/; do
            [ -d "$domain_dir" ] || continue
            local domain_name
            domain_name=$(basename "$domain_dir")
            local domain_files
            domain_files=$(find "$domain_dir" -maxdepth 1 -name "*.adoc" | sort)
            local domain_count
            domain_count=$(echo "$domain_files" | grep -c "\.adoc$" || echo "0")
            [ "$domain_count" -eq 0 ] && continue
            echo "          <li>" >> "$out"
            echo "            <span class=\"tree-label\" data-toggle>${ARROW_SVG} ${domain_name} <span class=\"tree-count\">${domain_count}</span></span>" >> "$out"
            echo '            <ul class="tree-children">' >> "$out"
            echo "$domain_files" | while read -r f; do
                [ -z "$f" ] && continue
                local title
                title=$(extract_title "$f")
                local rel
                rel="${f#$CONTENT_DIR/}"
                rel="${rel%.adoc}.html"
                echo "              <li class=\"tree-leaf\"><a href=\"${base_prefix}${rel}\">${title}</a></li>" >> "$out"
            done
            echo '            </ul>' >> "$out"
            echo '          </li>' >> "$out"
        done
        echo '        </ul>' >> "$out"
        echo '      </li>' >> "$out"
    fi

    echo '    </ul>' >> "$out"
    echo '  </div>' >> "$out"

    # --- Guides section ---
    if [ -d "$guides_dir" ]; then
        local guide_count
        guide_count=$(find "$guides_dir" -maxdepth 1 -name "*.adoc" -not -name "index.adoc" | wc -l | tr -d ' ')
        echo '  <div class="sidebar-section">' >> "$out"
        echo '    <div class="sidebar-title">Guides</div>' >> "$out"
        echo '    <ul class="tree-node">' >> "$out"
        find "$guides_dir" -maxdepth 1 -name "*.adoc" -not -name "index.adoc" | sort | while read -r f; do
            local title
            title=$(extract_title "$f")
            local rel
            rel="${f#$CONTENT_DIR/}"
            rel="${rel%.adoc}.html"
            echo "      <li class=\"tree-leaf\"><a href=\"${base_prefix}${rel}\">${title}</a></li>" >> "$out"
        done
        echo '    </ul>' >> "$out"
        echo '  </div>' >> "$out"
    fi

    echo '</aside>' >> "$out"
}

# =============================================================================
# HELPER: wrap Asciidoctor body in full page layout
# =============================================================================
wrap_page() {
    local title="$1"
    local body_html="$2"
    local sidebar_file="$3"
    local assets_prefix="$4"
    local lang="$5"
    local toc_html="${6:-}"
    local page_type="${7:-content}"  # content | dashboard | landing

    # Language switch
    local other_lang="en"
    local switch_label="EN"
    local nav_home="Accueil" nav_catalogue="Catalogue" nav_guides="Guides"
    if [ "$lang" = "en" ]; then
        other_lang="fr"
        switch_label="FR"
        nav_home="Home"
        nav_catalogue="Catalogue"
        nav_guides="Guides"
    fi

    # Read templates
    local head_tmpl header_tmpl footer_tmpl sidebar_html
    head_tmpl=$(cat "$TMPL_DIR/head.html")
    header_tmpl=$(cat "$TMPL_DIR/header.html")
    footer_tmpl=$(cat "$TMPL_DIR/footer.html")
    sidebar_html=$(cat "$sidebar_file")

    # Replace placeholders in header
    header_tmpl=$(echo "$header_tmpl" | sed \
        -e "s|{{ASSETS_PREFIX}}|${assets_prefix}|g" \
        -e "s|{{LANG}}|${lang}|g" \
        -e "s|{{LANG_SWITCH_URL}}|${assets_prefix}${other_lang}/index.html|g" \
        -e "s|{{LANG_SWITCH_LABEL}}|${switch_label}|g" \
        -e "s|{{NAV_HOME}}|${nav_home}|g" \
        -e "s|{{NAV_CATALOGUE}}|${nav_catalogue}|g" \
        -e "s|{{NAV_GUIDES}}|${nav_guides}|g")

    # Replace in head
    head_tmpl=$(echo "$head_tmpl" | sed "s|{{ASSETS_PREFIX}}|${assets_prefix}|g")

    # Build page
    local toc_section=""
    if [ -n "$toc_html" ]; then
        toc_section="<aside class=\"toc-right\">${toc_html}</aside>"
    fi

    cat <<HTMLEOF
<!DOCTYPE html>
<html lang="${lang}">
<head>
${head_tmpl}
<title>${title}</title>
</head>
<body>
${header_tmpl}
<div class="page-layout">
${sidebar_html}
<main class="main-content">
${body_html}
</main>
${toc_section}
</div>
${footer_tmpl}
<script src="${assets_prefix}assets/nav.js"></script>
</body>
</html>
HTMLEOF
}

# =============================================================================
# HELPER: generate TOC from h2 headings in HTML
# =============================================================================
generate_toc() {
    local html_file="$1"
    local lang="$2"
    local toc_title="Sur cette page"
    [ "$lang" = "en" ] && toc_title="On this page"

    local headings
    headings=$(grep -oE '<h2 id="[^"]*">[^<]+' "$html_file" 2>/dev/null | sed 's/<h2 id="\([^"]*\)">\(.*\)/\1|\2/' || echo "")

    if [ -z "$headings" ]; then
        echo ""
        return
    fi

    local toc="<div class=\"toc-right-title\">${toc_title}</div><ul>"
    echo "$headings" | while IFS='|' read -r id text; do
        echo "<li><a href=\"#${id}\">${text}</a></li>"
    done | {
        echo "<div class=\"toc-right-title\">${toc_title}</div><ul>"
        cat
        echo "</ul>"
    }
}

# =============================================================================
# 3a. Generate sidebars for both languages
# =============================================================================
echo "  [1/5] Generating sidebars ..."
for lang in fr en; do
    if [ -d "$CONTENT_DIR/pras/$lang" ]; then
        generate_sidebar "$lang" ""
    fi
done

# =============================================================================
# 3b. Convert .adoc pages (PRAs + guides) with full layout
# =============================================================================
echo "  [2/5] Converting .adoc pages ..."

convert_page() {
    local adoc_file="$1"
    local lang="$2"
    local section="$3"  # pras or guides

    # Destination path
    local rel_path="${adoc_file#$CONTENT_DIR/}"
    local html_rel="${rel_path%.adoc}.html"
    local dest_file="$SITE_DIR/${html_rel}"
    local dest_dir
    dest_dir=$(dirname "$dest_file")
    mkdir -p "$dest_dir"

    # Compute assets prefix
    local assets_prefix
    assets_prefix=$(depth_prefix "$html_rel")

    # Convert with Asciidoctor to a temp file (body only fragment not supported easily, use full then extract)
    local tmp_html="$BUILD_TMP/tmp_$(basename "${adoc_file%.adoc}").html"
    $ASCIIDOCTOR -a stylesheet! -a linkcss -a source-highlighter=rouge \
        -o "$tmp_html" "$adoc_file" 2>/dev/null || {
        echo "    [WARN] Failed: $adoc_file"
        return
    }

    # Extract title
    local title
    title=$(extract_title "$adoc_file")

    # Extract body content (between <div id="content"> and </div> before footer)
    local body
    body=$(sed -n '/<div id="content">/,/<div id="footer/{ /<div id="footer/d; p; }' "$tmp_html")
    # If no footer div, take everything after content div
    if [ -z "$body" ]; then
        body=$(sed -n '/<div id="content">/,$ p' "$tmp_html" | head -n -3)
    fi

    # Generate TOC for PRA pages
    local toc_html=""
    if [ "$section" = "pras" ]; then
        toc_html=$(generate_toc "$tmp_html" "$lang")
    fi

    # Fix sidebar path: sidebar needs paths relative to this page
    local sidebar_tmp="$BUILD_TMP/sidebar-${lang}-${section}-$(basename "${adoc_file%.adoc}").html"
    sed "s|href=\"|href=\"${assets_prefix}|g" "$BUILD_TMP/sidebar-${lang}.html" > "$sidebar_tmp"

    # Wrap in layout
    wrap_page "$title" "$body" "$sidebar_tmp" "$assets_prefix" "$lang" "$toc_html" > "$dest_file"

    # Copy rouge CSS if generated
    local rouge_css="${dest_dir}/rouge-github.css"
    if [ -f "$BUILD_TMP/rouge-github.css" ]; then
        cp "$BUILD_TMP/rouge-github.css" "$rouge_css" 2>/dev/null || true
    fi

    rm -f "$tmp_html" "$sidebar_tmp"
}

# Convert PRAs
for lang in fr en; do
    find "$CONTENT_DIR/pras/$lang" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        convert_page "$f" "$lang" "pras"
    done
done

# Convert Guides
for lang in fr en; do
    find "$CONTENT_DIR/guides/$lang" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        convert_page "$f" "$lang" "guides"
    done
done

# =============================================================================
# 3c. Generate dashboard pages
# =============================================================================
echo "  [3/5] Generating dashboards ..."

generate_dashboard() {
    local lang="$1"
    local pras_dir="$CONTENT_DIR/pras/$lang"
    local dest="$SITE_DIR/$lang/pras/index.html"
    mkdir -p "$(dirname "$dest")"

    local assets_prefix="../../"

    # Dashboard title
    local title="Catalogue des PRA"
    local col_name="Nom" col_arch="Archetype" col_status="Statut" col_scope="Scope" col_proven="Proven" col_updated="Derniere MAJ"
    if [ "$lang" = "en" ]; then
        title="PRA Catalogue"
        col_name="Name" col_arch="Archetype" col_status="Status" col_scope="Scope" col_proven="Proven" col_updated="Last Updated"
    fi

    # Build table rows
    local rows=""
    find "$pras_dir" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        local name arch status scope proven updated
        name=$(extract_attr "$f" "pra-name")
        [ -z "$name" ] && continue
        arch=$(extract_attr "$f" "pra-archetype")
        status=$(extract_attr "$f" "pra-status")
        scope=$(extract_attr "$f" "pra-scope")
        proven=$(extract_attr "$f" "pra-proven-count")
        updated=$(extract_attr "$f" "pra-updated")

        local rel="${f#$CONTENT_DIR/pras/$lang/}"
        rel="${rel%.adoc}.html"
        # Dashboard is at {lang}/pras/index.html, PRA files at pras/{lang}/...
        local link="../../pras/${lang}/${rel}"

        local status_badge="<span class=\"badge badge-${status}\">${status}</span>"
        local scope_badge="<span class=\"badge badge-${scope}\">${scope}</span>"

        echo "<tr onclick=\"window.location='${link}'\"><td><a href=\"${link}\">${name}</a></td><td>${arch}</td><td>${status_badge}</td><td>${scope_badge}</td><td>${proven}</td><td>${updated}</td></tr>"
    done > "$BUILD_TMP/dashboard-rows-${lang}.html"

    local table_rows
    table_rows=$(cat "$BUILD_TMP/dashboard-rows-${lang}.html")

    local dashboard_body
    dashboard_body=$(cat <<DASHEOF
<h1>${title}</h1>
<table id="pra-table" class="dashboard-table display" style="width:100%">
<thead>
<tr>
<th>${col_name}</th>
<th>${col_arch}</th>
<th>${col_status}</th>
<th>${col_scope}</th>
<th>${col_proven}</th>
<th>${col_updated}</th>
</tr>
</thead>
<tbody>
${table_rows}
</tbody>
</table>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script>
\$(document).ready(function() {
    \$('#pra-table').DataTable({
        pageLength: 20,
        order: [[0, 'asc']],
        initComplete: function() {
            this.api().columns().every(function(idx) {
                if (idx === 0 || idx === 4 || idx === 5) return;
                var column = this;
                var header = \$(column.header());
                var cell = header.closest('thead').find('tr.filters').length
                    ? header.closest('thead').find('tr.filters th').eq(idx)
                    : (function() {
                        var row = \$('<tr class="filters"></tr>');
                        header.closest('thead').append(row);
                        header.closest('thead').find('tr').first().find('th').each(function(i) {
                            row.append('<th></th>');
                        });
                        return row.find('th').eq(idx);
                    })();
                var select = \$('<select class="column-filter"><option value="">All</option></select>');
                column.data().unique().sort().each(function(d) {
                    var text = \$('<div>').html(d).text().trim();
                    if (text) select.append('<option value="'+text+'">'+text+'</option>');
                });
                select.appendTo(cell);
                select.on('change', function() {
                    var val = \$.fn.dataTable.util.escapeRegex(\$(this).val());
                    column.search(val ? '^'+val+'\$' : '', true, false).draw();
                });
            });
        }
    });
});
</script>
DASHEOF
)

    # Build sidebar with correct prefix for dashboard depth
    local sidebar_tmp="$BUILD_TMP/sidebar-${lang}-dashboard.html"
    sed "s|href=\"|href=\"${assets_prefix}|g" "$BUILD_TMP/sidebar-${lang}.html" > "$sidebar_tmp"

    wrap_page "$title" "$dashboard_body" "$sidebar_tmp" "$assets_prefix" "$lang" "" "dashboard" > "$dest"
    rm -f "$sidebar_tmp"
    echo "    $dest"
}

generate_dashboard "fr"
generate_dashboard "en"

# =============================================================================
# 3d. Generate landing pages per language
# =============================================================================
echo "  [4/5] Generating landing pages ..."

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

    # Recent PRAs (by :pra-updated:)
    local recent_html=""
    find "$pras_dir" -name "*.adoc" -not -name "index.adoc" 2>/dev/null | while read -r f; do
        local name updated
        name=$(extract_attr "$f" "pra-name")
        updated=$(extract_attr "$f" "pra-updated")
        local scope
        scope=$(extract_attr "$f" "pra-scope")
        [ -z "$name" ] && continue
        # Landing is at {lang}/index.html, PRA files at pras/{lang}/...
        local rel="../pras/${lang}/${f#$pras_dir/}"
        rel="${rel%.adoc}.html"
        echo "${updated}|${name}|${rel}|${scope}"
    done | sort -r | head -3 > "$BUILD_TMP/recent-${lang}.txt"

    local recent_items=""
    while IFS='|' read -r date name url scope; do
        local scope_badge="<span class=\"badge badge-${scope}\">${scope}</span>"
        recent_items="${recent_items}<div class=\"recent-item\"><span class=\"recent-name\"><a href=\"${url}\">${name}</a></span>${scope_badge}<span class=\"recent-meta\">${date}</span></div>"
    done < "$BUILD_TMP/recent-${lang}.txt"

    # Labels
    local hero_title="Proven <span>Reusable</span> Architecture"
    local hero_sub="Banque Nationale du Canada — Registre PRA"
    local stat_total="PRAs Total" stat_bw="Bank-Wide" stat_dw="Domain-Wide"
    local section_catalogue="Catalogue" section_guides="Guides" section_recent="Mis a jour recemment"
    local link_catalogue="Voir le catalogue" link_guides="Voir les guides"
    if [ "$lang" = "en" ]; then
        hero_sub="Banque Nationale du Canada — PRA Registry"
        stat_total="Total PRAs" stat_bw="Bank-Wide" stat_dw="Domain-Wide"
        section_catalogue="Catalogue" section_guides="Guides" section_recent="Recently Updated"
        link_catalogue="Browse catalogue" link_guides="Browse guides"
    fi

    local landing_body
    landing_body=$(cat <<LANDEOF
<div class="landing-hero">
  <h1>${hero_title}</h1>
  <p>${hero_sub}</p>
  <div class="landing-stats">
    <div class="stat-card"><div class="stat-number">${total_pras}</div><div class="stat-label">${stat_total}</div></div>
    <div class="stat-card"><div class="stat-number">${bw_count}</div><div class="stat-label">${stat_bw}</div></div>
    <div class="stat-card"><div class="stat-number">${dw_count}</div><div class="stat-label">${stat_dw}</div></div>
  </div>
</div>
<div class="landing-container">
  <div class="landing-grid">
    <div class="card">
      <div class="card-title">${section_catalogue}</div>
      <ul class="card-list"><li><a href="pras/index.html">${link_catalogue} &rarr;</a></li></ul>
    </div>
    <div class="card">
      <div class="card-title">${section_guides}</div>
      <ul class="card-list"><li><a href="guides/index.html">${link_guides} &rarr;</a></li></ul>
    </div>
  </div>
  <div class="recent-section">
    <div class="recent-title">${section_recent}</div>
    ${recent_items}
  </div>
</div>
LANDEOF
)

    # Landing uses a simpler layout (no sidebar)
    local other_lang="en" switch_label="EN"
    local nav_home="Accueil" nav_catalogue="Catalogue" nav_guides="Guides"
    if [ "$lang" = "en" ]; then
        other_lang="fr"; switch_label="FR"
        nav_home="Home"; nav_catalogue="Catalogue"; nav_guides="Guides"
    fi

    local head_tmpl header_tmpl footer_tmpl
    head_tmpl=$(cat "$TMPL_DIR/head.html" | sed "s|{{ASSETS_PREFIX}}|${assets_prefix}|g")
    header_tmpl=$(cat "$TMPL_DIR/header.html" | sed \
        -e "s|{{ASSETS_PREFIX}}|${assets_prefix}|g" \
        -e "s|{{LANG}}|${lang}|g" \
        -e "s|{{LANG_SWITCH_URL}}|${assets_prefix}${other_lang}/index.html|g" \
        -e "s|{{LANG_SWITCH_LABEL}}|${switch_label}|g" \
        -e "s|{{NAV_HOME}}|${nav_home}|g" \
        -e "s|{{NAV_CATALOGUE}}|${nav_catalogue}|g" \
        -e "s|{{NAV_GUIDES}}|${nav_guides}|g")
    footer_tmpl=$(cat "$TMPL_DIR/footer.html")

    cat > "$dest" <<HTMLEOF
<!DOCTYPE html>
<html lang="${lang}">
<head>
${head_tmpl}
<title>PRA Registry</title>
</head>
<body>
${header_tmpl}
${landing_body}
${footer_tmpl}
<script src="${assets_prefix}assets/nav.js"></script>
</body>
</html>
HTMLEOF

    echo "    $dest"
}

generate_landing "fr"
generate_landing "en"

# =============================================================================
# 3e. Generate root landing (language chooser)
# =============================================================================
cat > "$SITE_DIR/index.html" <<'ROOTEOF'
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="assets/style.css">
<title>PRA Registry</title>
</head>
<body>
<div class="topbar"><div class="topbar-inner"><span class="topbar-brand">BANQUE NATIONALE DU CANADA</span></div></div>
<div class="landing-hero">
  <h1>Proven <span>Reusable</span> Architecture</h1>
  <p>Banque Nationale du Canada — PRA Registry</p>
  <div style="margin-top:2.5rem;display:flex;justify-content:center;gap:1rem;">
    <a href="fr/index.html" style="display:inline-block;padding:0.7rem 2rem;background:var(--bnc-red);color:white;border-radius:8px;font-weight:600;font-size:0.95rem;text-decoration:none;">Fran&ccedil;ais</a>
    <a href="en/index.html" style="display:inline-block;padding:0.7rem 2rem;background:rgba(255,255,255,0.15);color:white;border:1px solid rgba(255,255,255,0.3);border-radius:8px;font-weight:600;font-size:0.95rem;text-decoration:none;">English</a>
  </div>
</div>
<footer class="site-footer"><div class="footer-inner"><p>&copy; Banque Nationale du Canada &mdash; PRA Registry</p></div></footer>
</body>
</html>
ROOTEOF

# =============================================================================
# 3f. Generate guide index pages
# =============================================================================
for lang in fr en; do
    guides_dir="$CONTENT_DIR/guides/$lang"
    dest="$SITE_DIR/$lang/guides/index.html"
    mkdir -p "$(dirname "$dest")"
    assets_prefix="../../"

    title="Guides du registre"
    [ "$lang" = "en" ] && title="Registry Guides"

    guide_list=""
    find "$guides_dir" -maxdepth 1 -name "*.adoc" -not -name "index.adoc" 2>/dev/null | sort | while read -r f; do
        t=$(extract_title "$f")
        # Guide index is at {lang}/guides/index.html, guide files at guides/{lang}/...
        rel="../../guides/${lang}/$(basename "${f%.adoc}.html")"
        echo "<li style=\"margin:0.5rem 0\"><a href=\"${rel}\">${t}</a></li>"
    done > "$BUILD_TMP/guide-list-${lang}.html"

    guide_items=$(cat "$BUILD_TMP/guide-list-${lang}.html")
    body="<h1>${title}</h1><ul style=\"list-style:none;padding:0\">${guide_items}</ul>"

    sidebar_tmp="$BUILD_TMP/sidebar-${lang}-guides-idx.html"
    sed "s|href=\"|href=\"${assets_prefix}|g" "$BUILD_TMP/sidebar-${lang}.html" > "$sidebar_tmp"
    wrap_page "$title" "$body" "$sidebar_tmp" "$assets_prefix" "$lang" "" > "$dest"
    rm -f "$sidebar_tmp"
done

# =============================================================================
# Cleanup
# =============================================================================
echo "  [5/5] Cleanup ..."
rm -rf "$BUILD_TMP"

echo ""
echo "=== Build complete ==="
echo "  Site: $SITE_DIR"
echo "  Files: $(find "$SITE_DIR" -name "*.html" | wc -l | tr -d ' ') HTML pages"
