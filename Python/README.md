# Astro Tooling (Python + uv)

Asset generation & QA for Astro Wars. Managed with [`uv`](https://docs.astral.sh/uv/).

## Setup

```bash
cd Python
uv sync
```

## Generate

```bash
uv run scripts/generate_sfx.py --out out
uv run scripts/generate_bgm.py --out out
uv run scripts/generate_bg_layers.py --out out
uv run scripts/audit_assets.py
```

## Install into Flutter

```bash
cp out/*.wav "../Flutter/assets/audio/"
cp out/parallax_*.png "../Flutter/assets/images/"
```

Keep filenames stable (`laser.wav`, `bgm.wav`, ...) so Dart code doesn't break.
