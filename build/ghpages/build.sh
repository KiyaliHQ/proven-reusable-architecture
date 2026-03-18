#!/bin/bash
# =============================================================================
# build.sh — Build GitHub Pages site from AsciiDoc content
# =============================================================================
#
# Converts AsciiDoc content to HTML using Asciidoctor and generates a static
# site with DataTables.js for interactive filtering on index pages.
#
# Usage: ./build/ghpages/build.sh
# Output: _site/ directory ready for GitHub Pages deployment
#
# Prerequisites:
#   - asciidoctor (gem install asciidoctor) OR Docker
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
SITE_DIR="$ROOT_DIR/_site"
CONTENT_DIR="$ROOT_DIR/content"

# --- Check for Asciidoctor ---
ASCIIDOCTOR=""
if command -v asciidoctor &>/dev/null; then
    ASCIIDOCTOR="asciidoctor"
elif command -v docker &>/dev/null; then
    ASCIIDOCTOR="docker run --rm -v $ROOT_DIR:/workspace asciidoctor/docker-asciidoctor asciidoctor"
else
    echo "ERROR: Neither asciidoctor nor docker is available."
    echo "Install: gem install asciidoctor"
    echo "Or use Docker: docker pull asciidoctor/docker-asciidoctor"
    exit 1
fi

echo "=== Building GitHub Pages site ==="
echo "  Using: $ASCIIDOCTOR"
echo "  Output: $SITE_DIR"
echo ""

# --- Clean output ---
rm -rf "$SITE_DIR"
mkdir -p "$SITE_DIR/fr/pras" "$SITE_DIR/en/pras" "$SITE_DIR/fr/guides" "$SITE_DIR/en/guides"

# --- Convert function ---
convert_dir() {
    local src_dir="$1"
    local dest_dir="$2"
    local label="$3"

    echo "  Converting $label ..."
    find "$src_dir" -name "*.adoc" | while read -r file; do
        local rel_path
        rel_path=$(realpath --relative-to="$src_dir" "$file")
        local dest_file="$dest_dir/${rel_path%.adoc}.html"
        local dest_parent
        dest_parent=$(dirname "$dest_file")
        mkdir -p "$dest_parent"

        $ASCIIDOCTOR \
            -a stylesheet! \
            -a linkcss \
            -a source-highlighter=rouge \
            -D "$dest_parent" \
            -o "$(basename "$dest_file")" \
            "$file" 2>/dev/null || echo "    [WARN] Failed: $file"
    done
}

# --- Convert content ---
convert_dir "$CONTENT_DIR/pras/fr" "$SITE_DIR/fr/pras" "FR PRAs"
convert_dir "$CONTENT_DIR/pras/en" "$SITE_DIR/en/pras" "EN PRAs"
convert_dir "$CONTENT_DIR/guides/fr" "$SITE_DIR/fr/guides" "FR Guides"
convert_dir "$CONTENT_DIR/guides/en" "$SITE_DIR/en/guides" "EN Guides"

# --- Generate landing page with DataTables ---
cat > "$SITE_DIR/index.html" <<'LANDING_EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PRA Registry — Banque Nationale du Canada</title>
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; color: #1a1a1a; background: #f8f9fa; }
        .header { background: #003366; color: white; padding: 2rem; text-align: center; }
        .header h1 { font-size: 1.8rem; margin-bottom: 0.5rem; }
        .header p { opacity: 0.8; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 1rem; }
        .lang-toggle { text-align: center; margin: 1.5rem 0; }
        .lang-toggle a { display: inline-block; padding: 0.5rem 1.5rem; margin: 0 0.25rem; border: 2px solid #003366; border-radius: 4px; text-decoration: none; color: #003366; font-weight: 600; }
        .lang-toggle a.active { background: #003366; color: white; }
        .section { background: white; border-radius: 8px; padding: 1.5rem; margin-bottom: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
        .section h2 { font-size: 1.3rem; margin-bottom: 1rem; color: #003366; }
        .section ul { list-style: none; padding: 0; }
        .section ul li { margin: 0.5rem 0; }
        .section ul li a { color: #0066cc; text-decoration: none; }
        .section ul li a:hover { text-decoration: underline; }
        footer { text-align: center; padding: 2rem; color: #666; font-size: 0.85rem; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Proven Reusable Architecture</h1>
        <p>Banque Nationale du Canada — PRA Registry</p>
    </div>
    <div class="container">
        <div class="lang-toggle">
            <a href="fr/pras/index.html" class="active">Fran&ccedil;ais</a>
            <a href="en/pras/index.html">English</a>
        </div>
        <div class="section">
            <h2>PRA Catalogue</h2>
            <ul>
                <li><a href="fr/pras/index.html">Catalogue des PRA (FR)</a></li>
                <li><a href="en/pras/index.html">PRA Catalogue (EN)</a></li>
            </ul>
        </div>
        <div class="section">
            <h2>Guides</h2>
            <ul>
                <li><a href="fr/guides/index.html">Guides du registre (FR)</a></li>
                <li><a href="en/guides/index.html">Registry Guides (EN)</a></li>
            </ul>
        </div>
    </div>
    <footer>
        &copy; Banque Nationale du Canada — PRA Registry
    </footer>
</body>
</html>
LANDING_EOF

# --- Inject DataTables.js into index pages ---
inject_datatables() {
    local file="$1"
    if [ -f "$file" ]; then
        # Inject DataTables CSS and JS before </head> and before </body>
        sed -i.bak '/<\/head>/i\
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css">' "$file"
        sed -i.bak '/<\/body>/i\
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>\
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>\
<script>$(document).ready(function() { $("table").DataTable({"pageLength": 20, "order": [[0, "asc"]]}); });</script>' "$file"
        rm -f "${file}.bak"
        echo "    DataTables injected: $file"
    fi
}

echo ""
echo "  Injecting DataTables.js ..."
inject_datatables "$SITE_DIR/fr/pras/index.html"
inject_datatables "$SITE_DIR/en/pras/index.html"

echo ""
echo "=== Build complete ==="
echo "  Site: $SITE_DIR"
echo "  Files: $(find "$SITE_DIR" -name "*.html" | wc -l | tr -d ' ') HTML pages"
