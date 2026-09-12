"""Generate 3 translucent parallax layers (stars far/mid/near + nebula tint).
Usage: uv run scripts/generate_bg_layers.py --out out --w 1024 --h 2048
Outputs: parallax_far.png, parallax_mid.png, parallax_near.png
"""
from __future__ import annotations
import argparse
from pathlib import Path
import numpy as np
from PIL import Image

LAYERS = [
    ("parallax_far.png", 220, 1.2, (120, 140, 255), 0.55),
    ("parallax_mid.png", 120, 1.8, (170, 200, 255), 0.75),
    ("parallax_near.png", 60, 2.6, (255, 255, 255), 1.0),
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="out")
    ap.add_argument("--w", type=int, default=1024)
    ap.add_argument("--h", type=int, default=2048)
    args = ap.parse_args()
    out = Path(__file__).resolve().parent.parent / args.out
    out.mkdir(parents=True, exist_ok=True)
    rng = np.random.default_rng(42)

    # Shared nebula gradient (very subtle, drawn only on far layer)
    yy, xx = np.mgrid[0 : args.h, 0 : args.w]
    neb = (
        np.sin(xx / 300.0) * np.cos(yy / 400.0) * 0.5 + 0.5
    ) * 22  # 0..22 alpha lift

    for name, count, radius, color, alpha in LAYERS:
        img = Image.new("RGBA", (args.w, args.h), (0, 0, 0, 0))
        px = img.load()
        xs = rng.integers(0, args.w, count * 6)
        ys = rng.integers(0, args.h, count * 6)
        for x, y in zip(xs, ys):
            glow = rng.random()
            r = max(1, int(radius * (0.5 + glow)))
            a = int(255 * alpha * (0.35 + 0.65 * glow))
            for dy in range(-r, r + 1):
                for dx in range(-r, r + 1):
                    if dx * dx + dy * dy <= r * r:
                        X, Y = x + dx, y + dy
                        if 0 <= X < args.w and 0 <= Y < args.h:
                            px[X, Y] = (*color, max(px[X, Y][3], a // (1 + abs(dx) + abs(dy))))
        if name == "parallax_far.png":
            arr = np.array(img).astype(np.float32)
            arr[..., 0] += neb * 0.4
            arr[..., 1] += neb * 0.2
            arr[..., 2] += neb * 0.8
            arr[..., 3] = np.maximum(arr[..., 3], neb * 2)
            img = Image.fromarray(np.clip(arr, 0, 255).astype(np.uint8))
        img.save(out / name)
        print(f"wrote {out/name}")


if __name__ == "__main__":
    main()
