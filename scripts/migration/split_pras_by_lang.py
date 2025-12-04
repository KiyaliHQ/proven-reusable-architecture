#!/usr/bin/env python3
"""Split PRAs into separate fr/ and en/ base directories"""
from pathlib import Path
import shutil

CONTENT_ROOT = Path('/Users/amarafofana/Projects/proven-reusable-architecture/content')
PRAS_ROOT = CONTENT_ROOT / 'pras'
PRAS_FR = CONTENT_ROOT / 'pras-fr'
PRAS_EN = CONTENT_ROOT / 'pras-en'

# Create new directories
PRAS_FR.mkdir(exist_ok=True)
PRAS_EN.mkdir(exist_ok=True)

# Find all PRA directories (those containing fr/ and en/ subdirs)
for pra_dir in PRAS_ROOT.rglob('*'):
    if not pra_dir.is_dir():
        continue
    
    fr_dir = pra_dir / 'fr'
    en_dir = pra_dir / 'en'
    
    if fr_dir.exists() and en_dir.exists():
        # Get relative path from pras root
        rel_path = pra_dir.relative_to(PRAS_ROOT)
        
        # Create destination directories
        fr_dest = PRAS_FR / rel_path
        en_dest = PRAS_EN / rel_path
        
        fr_dest.parent.mkdir(parents=True, exist_ok=True)
        en_dest.parent.mkdir(parents=True, exist_ok=True)
        
        # Copy fr/page.md and en/page.md
        if (fr_dir / 'page.md').exists():
            shutil.copy2(fr_dir / 'page.md', fr_dest.parent / 'page.md')
            print(f"✅ FR: {rel_path}")
        
        if (en_dir / 'page.md').exists():
            shutil.copy2(en_dir / 'page.md', en_dest.parent / 'page.md')
            print(f"✅ EN: {rel_path}")

print("\n✅ Split complete!")
print(f"FR PRAs: {PRAS_FR}")
print(f"EN PRAs: {PRAS_EN}")
