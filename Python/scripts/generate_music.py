"""Dual warm BGM: mission groove (100bpm) + boss drive (132bpm). Seamless loops.

Warmer than the old synthwave: round sine bass, soft pads with slow
attacks, brushed hats. Game crossfades between them.

Usage: uv run scripts/generate_music.py --out out
"""
from __future__ import annotations
import argparse
from pathlib import Path
import numpy as np
import synth_kit as K

CHORDS = [  # Am F C G
    (110.0, 130.81, 164.81),
    (87.31, 110.0, 130.81),
    (130.81, 164.81, 196.0),
    (98.0, 123.47, 146.83),
]
ROOTS = [55.0, 43.65, 65.41, 49.0]


def _bass_line(total_bars: int, bpm: float, pattern: list[int]) -> np.ndarray:
    beat = 60.0 / bpm
    eighth = beat / 2
    total = int(K.SR * beat * 4 * total_bars)
    mix = np.zeros(total)
    steps = total_bars * 8
    for i in range(steps):
        bar = i // 8
        f = ROOTS[bar % 4] * pattern[i % len(pattern)]
        s = int(i * eighth * K.SR)
        n = int(eighth * K.SR * 0.95)
        if s + n > total:
            break
        note = (K.tone(f, n / K.SR, "sine") * 0.5
                + K.tone(f * 2, n / K.SR, "triangle") * 0.12)
        m = len(note)
        fade = max(1, int(m * 0.15))
        note[:fade] *= np.linspace(0, 1, fade)
        note[-fade:] *= np.linspace(1, 0, fade)
        mix[s:s + m] += note
    return mix


def _pads(total_bars: int, bpm: float) -> np.ndarray:
    bar = 60.0 / bpm * 4
    total = int(K.SR * bar * total_bars)
    mix = np.zeros(total)
    for b in range(total_bars):
        chord = CHORDS[b % 4]
        s = int(b * bar * K.SR)
        n = int(bar * K.SR)
        pad = sum(K.tone(f, n / K.SR, "sine") * 0.05
                  + K.tone(f * 2.001, n / K.SR, "sine") * 0.015
                  for f in chord)
        fade = int(n * 0.25)
        pad[:fade] *= np.linspace(0, 1, fade)
        pad[-fade:] *= np.linspace(1, 0, fade)
        mix[s:s + n] += pad
    return mix


def _hats(total_bars: int, bpm: float, gain: float) -> np.ndarray:
    beat = 60.0 / bpm
    eighth = beat / 2
    total = int(K.SR * beat * 4 * total_bars)
    mix = np.zeros(total)
    rng = np.random.default_rng(11)
    for i in range(total_bars * 8):
        if i % 2 == 1:
            s = int(i * eighth * K.SR)
            n = int(0.03 * K.SR)
            if s + n <= total:
                tick = rng.standard_normal(n)
                tick = K.highpass(tick, 7000) * gain
                tick *= np.exp(-np.arange(n) / (0.008 * K.SR))
                mix[s:s + n] += tick
    return mix


def _kick(total_bars: int, bpm: float, gain: float) -> np.ndarray:
    beat = 60.0 / bpm
    total = int(K.SR * beat * 4 * total_bars)
    mix = np.zeros(total)
    for b in range(total_bars * 4):
        s = int(b * beat * K.SR)
        n = int(0.12 * K.SR)
        if s + n > total:
            break
        kick = K.sweep(120, 45, 0.12, "sine") * gain
        kick *= K.percussive(len(kick), attack=0.003, decay_pow=2.5)
        mix[s:s + n] += kick
    return mix


def _seamless(mix: np.ndarray) -> np.ndarray:
    x = int(0.08 * K.SR)
    mix[:x] = mix[:x] * np.linspace(0, 1, x) + mix[-x:] * np.linspace(1, 0, x)
    mix = mix[:-x]
    return mix / max(1e-6, np.abs(mix).max()) * 0.85


def mission() -> np.ndarray:
    bars, bpm = 8, 100.0
    mix = (_bass_line(bars, bpm, [1, 1, 2, 1, 1, 1, 2, 1])
           + _pads(bars, bpm)
           + _hats(bars, bpm, 0.05)
           + _kick(bars, bpm, 0.35))
    return _seamless(mix)


def boss() -> np.ndarray:
    bars, bpm = 8, 132.0
    mix = (_bass_line(bars, bpm, [1, 1, 1, 2, 1, 1, 2, 2])
           + _pads(bars, bpm)
           + _hats(bars, bpm, 0.08)
           + _kick(bars, bpm, 0.5))
    # Extra octave sparkle on top for urgency.
    beat = 60.0 / bpm
    bar = beat * 4
    total = int(K.SR * bar * bars)
    spark = np.zeros(total)
    for b in range(bars):
        f = CHORDS[b % 4][2] * 4
        s = int(b * bar * K.SR)
        n = int(bar * K.SR)
        arp = K.sweep(f, f * 1.5, n / K.SR, "sine") * 0.02
        arp *= np.sin(np.pi * np.linspace(0, 1, n)) ** 0.5
        spark[s:s + n] += arp
    return _seamless(mix + spark)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="out")
    args = ap.parse_args()
    out = Path(__file__).resolve().parent.parent / args.out
    out.mkdir(parents=True, exist_ok=True)
    from scipy.io import wavfile
    for name, fn in (("bgm_mission", mission), ("bgm_boss", boss)):
        data = fn()
        wavfile.write(str(out / f"{name}.wav"), K.SR, (data * 32767).astype(np.int16))
        print(f"wrote {name}.wav ({len(data)/K.SR:.1f}s loop)")


if __name__ == "__main__":
    main()
