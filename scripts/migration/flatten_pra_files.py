#!/usr/bin/env python3
"""Flatten page.md files to parent directory level"""
from pathlib import Path
import shutil

CONTENT_ROOT = Path('/Users/amarafofana/Projects/proven-reusable-architecture/content')

for pras_dir in [CONTENT_ROOT / 'pras-fr', CONTENT_ROOT / 'pras-en']:
    # Find all page.md files first (collect before modifying)
    page_files = list(pras_dir.rglob('page.md'))

    for page_md in page_files:
        # Get parent directory name (the PRA name)
        pra_name = page_md.parent.name
        # New filename: move page.md up one level and rename to pra_name.md
        new_file = page_md.parent.parent / f"{pra_name}.md"

        print(f"Moving: {page_md.relative_to(CONTENT_ROOT)}")
        print(f"    To: {new_file.relative_to(CONTENT_ROOT)}")

        # Move the file
        shutil.move(str(page_md), str(new_file))

        # Remove the now-empty directory
        page_md.parent.rmdir()
        print(f"✅ Done")

print("\n✅ All files flattened!")
