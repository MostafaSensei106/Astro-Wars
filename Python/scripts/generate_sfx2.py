"""Warm cartoon SFX set for Astro Wars (CI-inspired, non-arcade).

Replaces the harsh square-wave set with soft-attack layered sounds.
Same filenames where the game already references them, so Dart code keeps
working; new names are wired in later phases.

Usage: uv run scripts/generate_sfx2.py --out out
"""
from __future__ import annotations
import argparse
from pathlib import Path
import numpy as np
import synth_kit as K


# ------------------------------------------------------------- player weapons
def laser_soft() -> np.ndarray:
    # Triangle glide down + quiet sine octave, soft 8ms attack.
    body = K.sweep(1250, 320, 0.16, "triangle")
    sub = np.sin(2 * np.pi * np.cumsum(np.linspace(625, 160, len(body))) / K.SR) * 0.3
    n = len(body)
    return (body * 0.55 + sub) * K.percussive(n, attack=0.008, decay_pow=2.2)


def laser_enemy() -> np.ndarray:
    # Round descending "pew" — sine only, gentle.
    body = K.sweep(520, 240, 0.22, "sine")
    return body * 0.6 * K.percussive(len(body), attack=0.01, decay_pow=2.0)


# ------------------------------------------------------------------- impacts
def explosion() -> np.ndarray:
    # Warm boom: lowpassed noise (slow 12ms attack) + round sub thump.
    nse = K.lowpass(K.noise(0.7, seed=7), 900) * 0.8
    t = np.arange(len(nse)) / K.SR
    sub = np.sin(2 * np.pi * 52 * t) * np.exp(-5 * t) * 0.9
    out = (nse * np.exp(-3.5 * t) + sub)
    return out * K.percussive(len(out), attack=0.012, decay_pow=1.0)


def hit() -> np.ndarray:
    # Soft thud, not a click.
    body = K.sweep(300, 120, 0.12, "sine")
    return body * 0.7 * K.percussive(len(body), attack=0.006, decay_pow=3.0)


def egg_splat() -> np.ndarray:
    # Wet splat: short filtered noise burst + low pop.
    n = K.lowpass(K.noise(0.18, seed=21), 1400)
    t = np.arange(len(n)) / K.SR
    pop = np.sin(2 * np.pi * 180 * t) * np.exp(-25 * t) * 0.5
    return (n * np.exp(-18 * t) * 0.7 + pop) * K.percussive(len(n), attack=0.004)


def feather_pop() -> np.ndarray:
    # Cottony pop for chicken kills.
    body = K.sweep(700, 900, 0.09, "sine")
    air = K.highpass(K.noise(0.09, seed=22), 4000) * 0.12
    return (body * 0.5 + air) * K.percussive(len(body), attack=0.006, decay_pow=3.5)


# ------------------------------------------------------------------- cartoon
def cluck() -> np.ndarray:
    # Two-syllable cartoon cluck: FM chirps "buh-BWAK".
    a = K.fm_chirp(500, 300, 0.09, mod_freq=45, mod_depth=120)
    b = K.fm_chirp(900, 450, 0.14, mod_freq=60, mod_depth=160)
    gap = np.zeros(int(K.SR * 0.03))
    out = np.concatenate([a * 0.5, gap, b * 0.65])
    return out * K.percussive(len(out), attack=0.008, decay_pow=1.6)


def boss_roar() -> np.ndarray:
    # Low FM growl with slow 30ms attack — comedic menace, not metal.
    n = int(K.SR * 0.9)
    t = np.arange(n) / K.SR
    glide = np.linspace(140, 70, n)
    growl = np.sin(2 * np.pi * np.cumsum(glide + 25 * np.sin(2 * np.pi * 9 * t)) / K.SR)
    sub = np.sin(2 * np.pi * 45 * t) * 0.5
    out = K.lowpass(growl * 0.6 + sub, 500)
    return out * K.adsr(n, attack=0.03, decay=0.2, sustain=0.7, release=0.15)


# ------------------------------------------------------------------- pickups
def _music_box(freqs: list[float], note_dur: float = 0.12) -> np.ndarray:
    parts = []
    for f in freqs:
        tone = (K.tone(f, note_dur, "sine") * 0.55
                + K.tone(f * 3.0, note_dur, "sine") * 0.12
                + K.tone(f * 8.0, note_dur, "sine") * 0.03)
        n = len(tone)
        parts.append(tone * K.percussive(n, attack=0.004, decay_pow=2.5))
        parts.append(np.zeros(int(K.SR * 0.015)))
    return np.concatenate(parts)


def powerup() -> np.ndarray:
    return _music_box([523.25, 659.25, 783.99, 1046.5])


def gift_pickup() -> np.ndarray:
    # Brighter music-box run for weapon gifts.
    return _music_box([659.25, 783.99, 987.77, 1318.5, 1568.0], note_dur=0.1)


def coolant() -> np.ndarray:
    # Icy shimmer: high sine gliss up + sparkle.
    body = K.sweep(1500, 3200, 0.25, "sine")
    return body * 0.45 * K.percussive(len(body), attack=0.02, decay_pow=1.8)


# ------------------------------------------------------------------- system
def overheat_warn() -> np.ndarray:
    # Rising two-beep warning.
    a = K.tone(880, 0.09, "sine") * 0.5
    b = K.tone(1174.7, 0.12, "sine") * 0.5
    out = np.concatenate([a, np.zeros(int(K.SR * 0.03)), b])
    return out * K.percussive(len(out), attack=0.006, decay_pow=2.0)


def overheat_lock() -> np.ndarray:
    # Steam hiss: band-ish noise with slow decay.
    nse = K.highpass(K.lowpass(K.noise(1.1, seed=33), 6000), 1200)
    n = len(nse)
    return nse * 0.5 * K.percussive(n, attack=0.05, decay_pow=1.2)


def missile_launch() -> np.ndarray:
    # Airy whoosh up.
    nse = K.lowpass(K.noise(0.6, seed=44), 2500)
    t = np.arange(len(nse)) / K.SR
    swell = np.sin(np.pi * np.clip(t / 0.6, 0, 1)) ** 0.7
    whistle = K.sweep(400, 1400, 0.6, "sine") * 0.2 * swell
    return (nse * 0.4 * swell + whistle) * K.percussive(len(nse), attack=0.05)


def levelup() -> np.ndarray:
    # Warm brass-ish fanfare: soft-saw chords, slow attack.
    def chord(freqs, dur):
        n = int(K.SR * dur)
        out = np.zeros(n)
        for f in freqs:
            out += K.sweep(f, f, dur, "softsquare") * 0.22
            out += K.tone(f, dur, "sine") * 0.3
        return out * K.adsr(n, attack=0.03, decay=0.1, sustain=0.8, release=0.1)
    c = np.concatenate([
        chord([392.0, 523.25], 0.16),
        chord([523.25, 659.25], 0.16),
        chord([659.25, 783.99, 1046.5], 0.4),
    ])
    return c


def wave_clear() -> np.ndarray:
    return _music_box([783.99, 987.77, 1174.7], note_dur=0.11)


def gameover() -> np.ndarray:
    # Warm descending triangle lullaby, not a dirge.
    parts = []
    for f in (440.0, 349.23, 293.66, 220.0):
        tone = K.tone(f, 0.24, "triangle") * 0.55
        n = len(tone)
        parts.append(tone * K.percussive(n, attack=0.01, decay_pow=1.8))
        parts.append(np.zeros(int(K.SR * 0.03)))
    return np.concatenate(parts)


def main():
    import argparse
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="out")
    args = ap.parse_args()
    out = Path(__file__).resolve().parent.parent / args.out
    out.mkdir(parents=True, exist_ok=True)
    sounds = {
        "laser": (laser_soft, -13.0),
        "laser_enemy": (laser_enemy, -15.0),
        "explosion": (explosion, -12.0),
        "hit": (hit, -15.0),
        "egg_splat": (egg_splat, -14.0),
        "feather_pop": (feather_pop, -14.0),
        "cluck": (cluck, -13.0),
        "boss_roar": (boss_roar, -12.0),
        "powerup": (powerup, -14.0),
        "gift_pickup": (gift_pickup, -14.0),
        "coolant": (coolant, -15.0),
        "overheat_warn": (overheat_warn, -15.0),
        "overheat_lock": (overheat_lock, -16.0),
        "missile_launch": (missile_launch, -13.0),
        "levelup": (levelup, -13.0),
        "wave_clear": (wave_clear, -14.0),
        "gameover": (gameover, -14.0),
    }
    for name, (fn, db) in sounds.items():
        K.write_wav(out / f"{name}.wav", fn(), db)


if __name__ == "__main__":
    main()
