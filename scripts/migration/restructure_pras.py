#!/usr/bin/env python3
"""
Restructure PRAs to have fr/ and en/ subdirectories
From: pras/.../pra-name/fr.md and en.md
To:   pras/.../pra-name/fr/page.md and en/page.md
"""
from pathlib import Path
import shutil

CONTENT_ROOT = Path('/Users/amarafofana/Projects/proven-reusable-architecture/content')
PRAS_ROOT = CONTENT_ROOT / 'pras'

def restructure_pra_folder(pra_folder: Path):
    """Restructure a single PRA folder"""
    fr_file = pra_folder / 'fr.md'
    en_file = pra_folder / 'en.md'
    
    if not fr_file.exists() or not en_file.exists():
        return False
    
    # Create fr/ and en/ subdirectories
    fr_dir = pra_folder / 'fr'
    en_dir = pra_folder / 'en'
    fr_dir.mkdir(exist_ok=True)
    en_dir.mkdir(exist_ok=True)
    
    # Move files
    shutil.move(str(fr_file), str(fr_dir / 'page.md'))
    shutil.move(str(en_file), str(en_dir / 'page.md'))
    
    print(f"✅ Restructured: {pra_folder.relative_to(CONTENT_ROOT)}")
    return True

def main():
    count = 0
    # Find all PRA folders (depth 5: pras/scope/status/category/pra-name/)
    for pra_folder in PRAS_ROOT.rglob('*'):
        if pra_folder.is_dir() and (pra_folder / 'fr.md').exists():
            if restructure_pra_folder(pra_folder):
                count += 1
    
    print(f"\n✅ Restructured {count} PRAs")

if __name__ == '__main__':
    main()
