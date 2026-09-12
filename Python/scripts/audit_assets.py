"""QA audit: sizes, durations, clipping check for WAVs + PNG sizes.
Usage: uv run scripts/audit_assets.py
"""
from __future__ import annotations
from pathlib import Path
import wave

ROOT = Path(__file__).resolve().parent.parent
CANDIDATES = [
    ROOT / "out",
    Path("/home/ottafa/Devolpments/Astro Wars/Flutter/assets/audio"),
    Path("/home/ottafa/Devolpments/Astro Wars/Flutter/assets/images"),
]


def audit_wav(p: Path):
    try:
        with wave.open(str(p), "rb") as w:
            n, fr = w.getnframes(), w.getframerate()
            raw = w.readframes(n)
            import audioop

            peak = audioop.max(raw, w.getsampwidth())
            print(f"  {p.name}: {n/fr:.2f}s, {fr}Hz, peak={peak}/32767")
            if peak >= 32760:
                print("    WARN: possible clipping")
    except Exception as e:
        print(f"  {p.name}: ERROR {e}")


def main():
    for d in CANDIDATES:
        if not d.exists():
            continue
        print(f"== {d} ==")
        for f in sorted(d.iterdir()):
            if f.suffix.lower() == ".wav":
                audit_wav(f)
            elif f.suffix.lower() in (".png", ".jpg"):
                print(f"  {f.name}: {f.stat().st_size/1024:.0f} KB")


if __name__ == "__main__":
    main()
