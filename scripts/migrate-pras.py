#!/usr/bin/env python3
"""
Script to migrate PRAs from old structure to new structure.
Old: content/fr/registre/[scope]/[category]/[pra-name].md
New: content/pras/[bank-wide|domain-wide]/[domain]/[status]/[category]/[pra-name]/[en|fr].md
"""

import os
import re
import shutil
from pathlib import Path
from typing import Optional

# Project root
PROJECT_ROOT = Path(__file__).parent.parent
CONTENT_ROOT = PROJECT_ROOT / "content"

# Old structure paths
OLD_FR = CONTENT_ROOT / "fr" / "registre"
OLD_EN = CONTENT_ROOT / "en" / "registre"

# New structure paths
NEW_PRAS = CONTENT_ROOT / "pras"

# Mapping of old scope to new scope
# transversal -> bank-wide
# secteurs/[domain] -> domain-wide/[domain]
# en-promotion -> will be discussed (skip for now or put in candidate?)

# Default status mapping (can be customized per PRA)
DEFAULT_STATUS = "candidate"  # Most PRAs seem to be candidate status


def extract_pra_info(file_path: Path) -> dict:
    """Extract PRA information from the file path and metadata."""
    rel_path = file_path.relative_to(OLD_FR)
    parts = rel_path.parts

    info = {
        "original_path": file_path,
        "filename": file_path.stem,  # Without .md extension
    }

    # Determine scope and domain
    if parts[0] == "transversal":
        info["scope"] = "bank-wide"
        info["domain"] = None
        info["category"] = parts[1] if len(parts) > 1 else "tech"
    elif parts[0] == "secteurs":
        info["scope"] = "domain-wide"
        info["domain"] = parts[1] if len(parts) > 1 else "particuliers"
        info["category"] = parts[2] if len(parts) > 2 else "tech"
    elif parts[0] == "en-promotion":
        # For now, treat as bank-wide candidate
        # User can decide later if they want a separate "promotion" status
        info["scope"] = "bank-wide"
        info["domain"] = None
        info["category"] = "business"  # Default, can be customized
        info["is_promotion"] = True
    else:
        info["scope"] = "bank-wide"
        info["domain"] = None
        info["category"] = "tech"

    # Try to read frontmatter to determine actual status
    try:
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
            # Extract status from pra.status in frontmatter
            status_match = re.search(r"status:\s*([a-z]+)", content)
            if status_match:
                info["status"] = status_match.group(1)
            else:
                info["status"] = DEFAULT_STATUS
    except:
        info["status"] = DEFAULT_STATUS

    return info


def find_english_version(fr_path: Path) -> Optional[Path]:
    """Find the English version of a French PRA."""
    # Convert fr path to en path
    rel_path = fr_path.relative_to(OLD_FR)
    en_path = OLD_EN / rel_path

    if en_path.exists():
        return en_path
    return None


def migrate_pra(fr_path: Path, en_path: Optional[Path]):
    """Migrate a PRA from old structure to new structure."""
    info = extract_pra_info(fr_path)

    # Skip index files and meta.json
    if info["filename"] in ["index", "meta"]:
        return

    # Build new path
    if info["scope"] == "bank-wide":
        new_dir = NEW_PRAS / "bank-wide" / info["status"] / info["category"] / info["filename"]
    else:  # domain-wide
        new_dir = NEW_PRAS / "domain-wide" / info["domain"] / info["status"] / info["category"] / info["filename"]

    # Create directory
    new_dir.mkdir(parents=True, exist_ok=True)

    # Copy French version
    shutil.copy2(fr_path, new_dir / "fr.md")
    print(f"✅ Migrated FR: {fr_path.relative_to(CONTENT_ROOT)} -> {new_dir.relative_to(CONTENT_ROOT)}/fr.md")

    # Copy English version if exists
    if en_path and en_path.exists():
        shutil.copy2(en_path, new_dir / "en.md")
        print(f"✅ Migrated EN: {en_path.relative_to(CONTENT_ROOT)} -> {new_dir.relative_to(CONTENT_ROOT)}/en.md")
    else:
        print(f"⚠️  No English version found for: {info['filename']}")
        # Create a placeholder or copy FR as EN (to be translated later)
        # For now, we'll just note it's missing


def main():
    """Main migration function."""
    print("🚀 Starting PRA migration...")
    print(f"📁 Project root: {PROJECT_ROOT}")
    print(f"📁 Content root: {CONTENT_ROOT}")
    print(f"📁 Old FR path: {OLD_FR}")
    print(f"📁 New PRA path: {NEW_PRAS}")
    print()

    # Find all French PRAs
    fr_pras = list(OLD_FR.rglob("*.md"))
    print(f"Found {len(fr_pras)} French PRA files")
    print()

    # Migrate each PRA
    for fr_path in fr_pras:
        # Skip if not a file
        if not fr_path.is_file():
            continue

        # Find English version
        en_path = find_english_version(fr_path)

        # Migrate
        try:
            migrate_pra(fr_path, en_path)
        except Exception as e:
            print(f"❌ Error migrating {fr_path}: {e}")

    print()
    print("✅ Migration complete!")
    print()
    print("📝 Next steps:")
    print("1. Review migrated PRAs in content/pras/")
    print("2. Translate missing English versions")
    print("3. Update source.config.ts to use new structure")
    print("4. Create validate-bilingual.yml workflow")
    print("5. Test site with new structure")


if __name__ == "__main__":
    main()
