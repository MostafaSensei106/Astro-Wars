"""Procedural SFX synthesizer for Astro Wars.
Generates clean 44.1kHz 16-bit WAVs with no clicks (fade in/out envelopes).
Usage: uv run scripts/generate_sfx.py --out out
"""
from __future__ import annotations
import argparse
from pathlib import Path
import numpy as np
from scipy.io import wavfile
from scipy import signal as scipy_signal

SR = 44100


def _env(n: int, fade: float = 0.01) -> np.ndarray:
    e = np.ones(n)
    f = max(1, int(n * fade))
    ramp = np.linspace(0, 1, f)
    e[:f] *= ramp
    e[-f:] *= ramp[::-1]
    return e


def _write(path: Path, data: np.ndarray):
    data = np.clip(data, -1.0, 1.0)
    wavfile.write(str(path), SR, (data * 32767).astype(np.int16))
    print(f"wrote {path} ({len(data)/SR:.2f}s)")


def laser() -> np.ndarray:
    n = int(SR * 0.16)
    t = np.arange(n) / SR
    f0, f1 = 1400.0, 240.0
    freq = np.linspace(f0, f1, n)
    phase = 2 * np.pi * np.cumsum(freq) / SR
    tone = np.sign(np.sin(phase)) * 0.35 + np.sin(phase) * 0.25
    return tone * _env(n) * np.exp(-3 * t)


def laser_enemy() -> np.ndarray:
    n = int(SR * 0.2)
    t = np.arange(n) / SR
    f0, f1 = 300.0, 900.0
    freq = np.linspace(f0, f1, n)
    phase = 2 * np.pi * np.cumsum(freq) / SR
    tone = np.sin(phase) * 0.5 + np.sin(2 * phase) * 0.15
    return tone * _env(n) * np.exp(-2.5 * t)


def explosion() -> np.ndarray:
    n = int(SR * 0.7)
    rng = np.random.default_rng(7)
    noise = rng.standard_normal(n)
    b, a = scipy_signal.butter(2, 1200 / (SR / 2), btype="low")
    low = scipy_signal.lfilter(b, a, noise)
    sweep = np.linspace(1.0, 0.15, n)
    t = np.arange(n) / SR
    sub = np.sin(2 * np.pi * 55 * t) * np.exp(-6 * t) * 0.9
    out = low * sweep * 0.7 * np.exp(-4 * t) + sub
    return out * _env(n, 0.02)


def hit() -> np.ndarray:
    n = int(SR * 0.1)
    rng = np.random.default_rng(3)
    noise = rng.standard_normal(n) * 0.4
    t = np.arange(n) / SR
    click = np.sin(2 * np.pi * 220 * t) * np.exp(-40 * t)
    return (noise * np.exp(-30 * t) + click) * _env(n, 0.05)


def _arp(freqs, note_dur=0.09, gap=0.01) -> np.ndarray:
    parts = []
    for f in freqs:
        n = int(SR * note_dur)
        t = np.arange(n) / SR
        tone = np.sin(2 * np.pi * f * t) * 0.5 + np.sin(4 * np.pi * f * t) * 0.12
        parts.append(tone * _env(n, 0.08))
        parts.append(np.zeros(int(SR * gap)))
    return np.concatenate(parts)


def powerup() -> np.ndarray:
    return _arp([523.25, 659.25, 783.99, 1046.5])


def levelup() -> np.ndarray:
    return _arp([392.0, 523.25, 659.25, 783.99, 1046.5], note_dur=0.1)


def gameover() -> np.ndarray:
    return _arp([440.0, 349.23, 293.66, 220.0], note_dur=0.22, gap=0.03)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="out")
    args = ap.parse_args()
    out = Path(__file__).resolve().parent.parent / args.out
    out.mkdir(parents=True, exist_ok=True)
    _write(out / "laser.wav", laser())
    _write(out / "laser_enemy.wav", laser_enemy())
    _write(out / "explosion.wav", explosion())
    _write(out / "hit.wav", hit())
    _write(out / "powerup.wav", powerup())
    _write(out / "levelup.wav", levelup())
    _write(out / "gameover.wav", gameover())


if __name__ == "__main__":
    main()
