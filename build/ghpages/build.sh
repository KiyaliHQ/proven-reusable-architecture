#!/bin/bash
# =============================================================================
# build.sh — Build GitHub Pages site from AsciiDoc content
# =============================================================================
#
# Converts AsciiDoc content to HTML using Asciidoctor and generates a static
# site with custom BNC styling and DataTables.js for interactive filtering.
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
ASSETS_DIR="$SCRIPT_DIR/assets"

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
mkdir -p "$SITE_DIR/fr/pras" "$SITE_DIR/en/pras" "$SITE_DIR/fr/guides" "$SITE_DIR/en/guides" "$SITE_DIR/assets"

# --- Copy assets ---
echo "  Copying assets ..."
cp "$ASSETS_DIR/style.css" "$SITE_DIR/assets/style.css"

# --- Convert function ---
convert_dir() {
    local src_dir="$1"
    local dest_dir="$2"
    local label="$3"

    echo "  Converting $label ..."
    find "$src_dir" -name "*.adoc" | while read -r file; do
        local rel_path
        rel_path="${file#$src_dir/}"
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

# --- Inject custom CSS into all HTML pages ---
echo ""
echo "  Injecting custom CSS ..."
inject_css() {
    local file="$1"
    local depth="$2"  # relative depth from file to _site root
    local css_path="${depth}assets/style.css"
    # Insert our stylesheet link before </head>
    sed -i.bak "s|</head>|<link rel=\"stylesheet\" href=\"${css_path}\"></head>|" "$file"
    rm -f "${file}.bak"
}

find "$SITE_DIR" -name "*.html" | while read -r html_file; do
    # Calculate depth relative to _site/
    local_path="${html_file#$SITE_DIR/}"
    # Count directory separators to compute relative path prefix
    depth=$(echo "$local_path" | tr -cd '/' | wc -c | tr -d ' ')
    prefix=""
    for ((i=0; i<depth; i++)); do
        prefix="../${prefix}"
    done
    inject_css "$html_file" "$prefix"
done
echo "    CSS injected into all pages"

# --- Generate landing page ---
cat > "$SITE_DIR/index.html" <<'LANDING_EOF'
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PRA Registry — Banque Nationale du Canada</title>
    <link rel="stylesheet" href="assets/style.css">
    <style>
        body { background: var(--bnc-gray); }
        .landing-header {
            background: linear-gradient(135deg, var(--bnc-dark) 0%, #2d1a1b 100%);
            color: white;
            padding: 3rem 2rem;
            text-align: center;
        }
        .landing-header h1 {
            font-size: 2rem;
            font-weight: 700;
            letter-spacing: -0.02em;
            margin-bottom: 0.5rem;
        }
        .landing-header h1 span { color: var(--bnc-red); }
        .landing-header p {
            font-size: 1rem;
            opacity: 0.7;
            font-weight: 400;
        }
        .landing-container {
            max-width: 800px;
            margin: 2.5rem auto;
            padding: 0 1.5rem;
        }
        .lang-toggle {
            display: flex;
            justify-content: center;
            gap: 0.5rem;
            margin-bottom: 2rem;
        }
        .lang-toggle a {
            display: inline-block;
            padding: 0.5rem 1.75rem;
            border: 2px solid var(--bnc-dark);
            border-radius: 6px;
            text-decoration: none;
            color: var(--bnc-dark);
            font-weight: 600;
            font-size: 0.9rem;
            transition: all 0.15s ease;
        }
        .lang-toggle a.active,
        .lang-toggle a:hover {
            background: var(--bnc-dark);
            color: white;
        }
        .card {
            background: var(--bnc-white);
            border: 1px solid var(--bnc-border);
            border-radius: 10px;
            padding: 1.5rem 1.75rem;
            margin-bottom: 1rem;
            transition: box-shadow 0.15s ease;
        }
        .card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.08);
        }
        .card h2 {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--bnc-dark);
            margin-bottom: 0.75rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        .card h2 .icon {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 0.9rem;
            flex-shrink: 0;
        }
        .icon-catalogue { background: #fee2e2; }
        .icon-guides { background: #dbeafe; }
        .card ul {
            list-style: none;
            padding: 0;
        }
        .card ul li {
            margin: 0.4rem 0;
        }
        .card ul li a {
            color: var(--bnc-red);
            text-decoration: none;
            font-size: 0.95rem;
            display: flex;
            align-items: center;
            gap: 0.4rem;
        }
        .card ul li a:hover { text-decoration: underline; }
        .card ul li a::before { content: '\2192'; color: var(--bnc-text-muted); font-size: 0.8rem; }
        .landing-footer {
            text-align: center;
            padding: 2rem;
            font-size: 0.8rem;
            color: var(--bnc-text-muted);
        }
    </style>
</head>
<body>
    <div class="landing-header">
        <h1>Proven <span>Reusable</span> Architecture</h1>
        <p>Banque Nationale du Canada — PRA Registry</p>
    </div>
    <div class="landing-container">
        <div class="lang-toggle">
            <a href="fr/pras/index.html" class="active">Fran&ccedil;ais</a>
            <a href="en/pras/index.html">English</a>
        </div>
        <div class="card">
            <h2><span class="icon icon-catalogue">&#9776;</span> Catalogue des PRA</h2>
            <ul>
                <li><a href="fr/pras/index.html">Catalogue des PRA (Fran&ccedil;ais)</a></li>
                <li><a href="en/pras/index.html">PRA Catalogue (English)</a></li>
            </ul>
        </div>
        <div class="card">
            <h2><span class="icon icon-guides">&#9998;</span> Guides</h2>
            <ul>
                <li><a href="fr/guides/index.html">Guides du registre (Fran&ccedil;ais)</a></li>
                <li><a href="en/guides/index.html">Registry Guides (English)</a></li>
            </ul>
        </div>
    </div>
    <div class="landing-footer">
        &copy; Banque Nationale du Canada — PRA Registry
    </div>
</body>
</html>
LANDING_EOF

# --- Inject DataTables.js + column filters into dashboard index pages ---
inject_datatables() {
    local file="$1"
    local depth="$2"
    if [ ! -f "$file" ]; then return; fi

    local css_path="${depth}assets/style.css"

    # Build the JS/CSS block to inject
    local dt_head="<link rel=\"stylesheet\" href=\"https://cdn.datatables.net/1.13.7/css/jquery.dataTables.min.css\">"
    local dt_body
    dt_body=$(cat <<'DTEOF'
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.datatables.net/1.13.7/js/jquery.dataTables.min.js"></script>
<script>
$(document).ready(function() {
    var table = $("table").DataTable({
        "pageLength": 20,
        "order": [[0, "asc"]],
        "dom": '<"top"lf>rt<"bottom"ip>',
        initComplete: function() {
            this.api().columns().every(function(index) {
                // Skip first column (Name) — already covered by global search
                if (index === 0) return;
                var column = this;
                var header = $(column.header());
                var select = $('<select class="column-filter"><option value="">All</option></select>');
                // Create a filter row below header
                select.appendTo(
                    header.closest('thead').find('tr.filters').length
                        ? header.closest('thead').find('tr.filters td').eq(index)
                        : (function() {
                            var filterRow = $('<tr class="filters"></tr>');
                            header.closest('thead').append(filterRow);
                            header.closest('thead').find('th').each(function(i) {
                                filterRow.append(i === 0 ? '<td></td>' : '<td></td>');
                            });
                            return filterRow.find('td').eq(index);
                        })()
                );
                column.data().unique().sort().each(function(d) {
                    if (d && d.trim()) {
                        var text = $('<div>').html(d).text().trim();
                        if (text) {
                            select.append('<option value="' + text + '">' + text + '</option>');
                        }
                    }
                });
                select.on('change', function() {
                    var val = $.fn.dataTable.util.escapeRegex($(this).val());
                    column.search(val ? '^' + val + '$' : '', true, false).draw();
                });
            });
        }
    });
});
</script>
DTEOF
)

    sed -i.bak "s|</head>|${dt_head}</head>|" "$file"
    rm -f "${file}.bak"

    # Write the JS block to a temp file, then inject before </body>
    local tmpjs
    tmpjs=$(mktemp)
    echo "$dt_body" > "$tmpjs"
    sed -i.bak "/<\/body>/r $tmpjs" "$file"
    # Now remove the </body> line duplication — the r command inserts before the line
    rm -f "${file}.bak" "$tmpjs"

    echo "    DataTables + filters injected: $file"
}

echo ""
echo "  Injecting DataTables.js + column filters ..."
inject_datatables "$SITE_DIR/fr/pras/index.html" "../../"
inject_datatables "$SITE_DIR/en/pras/index.html" "../../"

echo ""
echo "=== Build complete ==="
echo "  Site: $SITE_DIR"
echo "  Files: $(find "$SITE_DIR" -name "*.html" | wc -l | tr -d ' ') HTML pages"
