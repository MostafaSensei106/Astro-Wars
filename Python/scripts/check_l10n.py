"""Compare l10n ARB keys across locales, report missing/untranslated entries.
Usage: uv run scripts/check_l10n.py
"""
from __future__ import annotations
import json
from pathlib import Path

L10N = Path("/home/ottafa/Devolpments/Astro Wars/Flutter/lib/l10n")


def main():
    arbs = sorted(L10N.glob("app_*.arb"))
    if not arbs:
        print("no .arb files found")
        return
    base = json.loads(arbs[0].read_text(encoding="utf-8"))
    base_keys = {k for k in base if not k.startswith("@")}
    print(f"base {arbs[0].name}: {len(base_keys)} keys")
    for arb in arbs[1:]:
        data = json.loads(arb.read_text(encoding="utf-8"))
        keys = {k for k in data if not k.startswith("@")}
        missing = sorted(base_keys - keys)
        print(f"{arb.name}: {len(keys)} keys, missing {len(missing)}")
        for k in missing[:30]:
            print(f"  - {k}")


if __name__ == "__main__":
    main()
