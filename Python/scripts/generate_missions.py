"""Generate CI-style mission JSON for sectors 1..3.

Each sector: typed wave list (formation/swoop/meteor/bonus) + boss finale.
The game falls back to a procedural generator for higher sectors.

Usage: uv run scripts/generate_missions.py --out "../Flutter/assets/missions"
"""
from __future__ import annotations
import argparse
import json
from pathlib import Path


def sector(idx: int) -> dict:
    waves: list[dict] = []
    n = 6 + idx  # 7..9 waves + boss
    for i in range(n):
        roll = i % 5
        if roll == 3:
            waves.append({"type": "meteor", "speedMult": round(1.0 + idx * 0.1, 2)})
        elif roll == 4:
            waves.append({"type": "bonus", "rows": 2, "cols": 4, "giftShower": 3})
        elif roll == 2:
            waves.append({"type": "swoop", "rows": 2 + idx // 2, "cols": 5,
                          "speedMult": round(1.0 + idx * 0.1, 2)})
        else:
            waves.append({"type": "formation",
                          "rows": min(2 + idx // 2, 4),
                          "cols": min(5 + idx // 2, 8),
                          "speedMult": round(1.0 + idx * 0.1, 2)})
    return {"sector": idx, "boss": True, "waves": waves}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="../../Flutter/assets/missions")
    ap.add_argument("--sectors", type=int, default=3)
    args = ap.parse_args()
    out = (Path(__file__).resolve().parent / args.out).resolve()
    out.mkdir(parents=True, exist_ok=True)
    for s in range(1, args.sectors + 1):
        p = out / f"sector_{s}.json"
        p.write_text(json.dumps(sector(s), indent=2), encoding="utf-8")
        print(f"wrote {p} ({len(sector(s)['waves'])} waves + boss)")


if __name__ == "__main__":
    main()
