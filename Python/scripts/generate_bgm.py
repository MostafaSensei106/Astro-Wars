"""Synthwave BGM loop generator: 8 bars @120bpm, Am-F-C-G, seamless loop.
Usage: uv run scripts/generate_bgm.py --out out --bpm 120 --bars 8
"""
from __future__ import annotations
import argparse
from pathlib import Path
import numpy as np
from scipy.io import wavfile

SR = 44100


def _saw(f: float, n: int) -> np.ndarray:
    t = np.arange(n) / SR
    return 2 * ((f * t) % 1.0) - 1.0


def _tone(f: float, n: int, wave: str = "sine") -> np.ndarray:
    t = np.arange(n) / SR
    if wave == "saw":
        return _saw(f, n)
    if wave == "square":
        return np.sign(np.sin(2 * np.pi * f * t))
    return np.sin(2 * np.pi * f * t)


CHORDS = [  # Am F C G (roots + thirds+fifths)
    (110.0, 130.81, 164.81),
    (87.31, 110.0, 130.81),
    (130.81, 164.81, 196.0),
    (98.0, 123.47, 146.83),
]


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="out")
    ap.add_argument("--bpm", type=float, default=120)
    ap.add_argument("--bars", type=int, default=8)
    args = ap.parse_args()

    beat = 60.0 / args.bpm
    bar = beat * 4
    total = int(SR * bar * args.bars)
    mix = np.zeros(total)
    rng = np.random.default_rng(11)

    # Bass: root eighth-notes, saw-ish, low volume
    eighth = beat / 2
    ne = int(total / (SR * eighth))
    for i in range(ne):
        chord = CHORDS[(i // 8) % 4]
        s = int(i * eighth * SR)
        n = int(eighth * SR)
        if s + n > total:
            break
        bass = _tone(chord[0] / 2, n, "saw") * 0.16
        fade = int(n * 0.1)
        bass[:fade] *= np.linspace(0, 1, fade)
        bass[-fade:] *= np.linspace(1, 0, fade)
        mix[s : s + n] += bass

    # Pad: one chord per bar, soft sine stack
    for b in range(args.bars):
        chord = CHORDS[b % 4]
        s = int(b * bar * SR)
        n = int(bar * SR)
        pad = sum(_tone(f, n) for f in chord) * 0.05
        fade = int(n * 0.15)
        pad[:fade] *= np.linspace(0, 1, fade)
        pad[-fade:] *= np.linspace(1, 0, fade)
        mix[s : s + n] += pad

    # Hats: noise ticks on off-beats
    for i in range(ne):
        if i % 2 == 1:
            s = int(i * eighth * SR)
            n = int(0.03 * SR)
            if s + n <= total:
                mix[s : s + n] += rng.standard_normal(n) * 0.05 * np.exp(
                    -np.arange(n) / (0.008 * SR)
                )

    # Seamless loop: short crossfade of last 50ms with start
    x = int(0.05 * SR)
    mix[:x] = mix[:x] * np.linspace(0, 1, x) + mix[-x:] * np.linspace(1, 0, x)
    mix = mix[:-x]
    mix = mix / max(1e-6, np.abs(mix).max()) * 0.85

    out = Path(__file__).resolve().parent.parent / args.out
    out.mkdir(parents=True, exist_ok=True)
    wavfile.write(str(out / "bgm.wav"), SR, (mix * 32767).astype(np.int16))
    print(f"wrote {out/'bgm.wav'} ({len(mix)/SR:.1f}s loop)")


if __name__ == "__main__":
    main()
