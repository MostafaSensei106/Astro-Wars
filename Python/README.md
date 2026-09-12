# Astro Tooling (Python + uv)

Asset generation & QA for Astro Wars. Managed with [`uv`](https://docs.astral.sh/uv/).

## Setup

```bash
cd Python
uv sync
```

## Generate

```bash
uv run scripts/generate_sfx.py --out out        # legacy arcade set (reference)
uv run scripts/generate_sfx2.py --out out       # warm cartoon set (used)
uv run scripts/generate_bgm.py --out out        # legacy synthwave (reference)
uv run scripts/generate_music.py --out out      # mission + boss loops (used)
uv run scripts/generate_bg_layers.py --out out
uv run scripts/generate_missions.py             # sector_1..3.json missions
uv run scripts/audit_assets.py
uv run scripts/check_l10n.py
```

## Install into Flutter

```bash
cp out/*.wav "../Flutter/assets/audio/"
cp out/parallax_*.png "../Flutter/assets/images/"
```

Keep filenames stable (`laser.wav`, `bgm.wav`, ...) so Dart code doesn't break.
