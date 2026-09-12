"""Shared synth kit for Astro Wars: warm, cartoon, non-arcade sounds.

Design rules (anti-harsh):
  - Every sound gets a soft ATTACK (5-30ms fade-in) — no instant onsets.
  - Prefer sine/triangle layers; square/saw only blended quietly + lowpassed.
  - Loudness-normalized by RMS (not peak) so all SFX sit evenly in the mix.
  - audit helpers: rms_db + spectral centroid (brightness) warnings.
"""
from __future__ import annotations
from pathlib import Path
import numpy as np
from scipy.io import wavfile
from scipy import signal as scipy_signal

SR = 44100


# ---------------------------------------------------------------- envelopes
def adsr(n: int, attack: float = 0.008, decay: float = 0.05,
         sustain: float = 0.6, release: float = 0.05) -> np.ndarray:
    """ADSR envelope, times in seconds."""
    a = max(1, int(n * attack / (n / SR)))
    d = max(1, int(n * decay / (n / SR)))
    r = max(1, int(n * release / (n / SR)))
    a = min(a, n // 4)
    d = min(d, n // 4)
    r = min(r, n // 4)
    e = np.ones(n) * sustain
    e[:a] = np.linspace(0, 1, a)
    e[a:a + d] = np.linspace(1, sustain, d)
    e[-r:] = np.linspace(e[-r - 1] if n - r - 1 >= 0 else sustain, 0, r)
    return e


def percussive(n: int, attack: float = 0.008, decay_pow: float = 3.0) -> np.ndarray:
    t = np.arange(n) / SR
    dur = n / SR
    e = np.exp(-decay_pow * t / max(dur, 1e-6) * 2.0)
    a = max(1, int(SR * attack))
    e[:a] *= np.linspace(0, 1, a)
    return e


# ------------------------------------------------------------------- tones
def tone(freq: float, dur: float, wave: str = "sine", phase0: float = 0.0) -> np.ndarray:
    n = int(SR * dur)
    t = np.arange(n) / SR
    if wave == "sine":
        return np.sin(2 * np.pi * freq * t + phase0)
    if wave == "triangle":
        return 2 * np.abs(2 * ((freq * t + phase0 / (2 * np.pi)) % 1.0) - 1.0) - 1.0
    if wave == "square":
        return np.sign(np.sin(2 * np.pi * freq * t + phase0) + 1e-9)
    if wave == "saw":
        return 2 * ((freq * t + phase0 / (2 * np.pi)) % 1.0) - 1.0
    raise ValueError(wave)


def sweep(f0: float, f1: float, dur: float, wave: str = "sine",
          curve: float = 1.0) -> np.ndarray:
    """Frequency glide with exponential-ish curve."""
    n = int(SR * dur)
    k = np.linspace(0, 1, n) ** curve
    freq = f0 + (f1 - f0) * k
    phase = 2 * np.pi * np.cumsum(freq) / SR
    t = np.arange(n) / SR
    if wave == "sine":
        return np.sin(phase)
    if wave == "triangle":
        return 2 * np.abs(2 * (np.cumsum(freq) / SR % 1.0) - 1.0) - 1.0
    if wave == "softsquare":
        s = np.sign(np.sin(phase) + 1e-9)
        b, a = scipy_signal.butter(3, 2500 / (SR / 2), btype="low")
        return scipy_signal.lfilter(b, a, s)
    raise ValueError(wave)


def fm_chirp(f0: float, f1: float, dur: float, mod_freq: float = 30.0,
             mod_depth: float = 80.0) -> np.ndarray:
    """Vibrato-ish chirp — the basis of cartoon clucks."""
    n = int(SR * dur)
    t = np.arange(n) / SR
    glide = np.linspace(f0, f1, n)
    vib = mod_depth * np.sin(2 * np.pi * mod_freq * t)
    phase = 2 * np.pi * np.cumsum(glide + vib) / SR
    return np.sin(phase)


def noise(dur: float, seed: int = 0) -> np.ndarray:
    rng = np.random.default_rng(seed)
    return rng.standard_normal(int(SR * dur))


def lowpass(x: np.ndarray, cutoff: float, order: int = 2) -> np.ndarray:
    b, a = scipy_signal.butter(order, cutoff / (SR / 2), btype="low")
    return scipy_signal.lfilter(b, a, x)


def highpass(x: np.ndarray, cutoff: float, order: int = 2) -> np.ndarray:
    b, a = scipy_signal.butter(order, cutoff / (SR / 2), btype="high")
    return scipy_signal.lfilter(b, a, x)


# ------------------------------------------------------------------- loudness
def normalize_rms(x: np.ndarray, target_db: float = -14.0,
                  peak_ceiling: float = 0.89) -> np.ndarray:
    rms = np.sqrt(np.mean(x ** 2)) + 1e-9
    target = 10 ** (target_db / 20)
    y = x * (target / rms)
    peak = np.abs(y).max() + 1e-9
    if peak > peak_ceiling:
        y = y * (peak_ceiling / peak)
    return y


def brightness(x: np.ndarray) -> float:
    """Spectral centroid in Hz — high values sound harsh/thin."""
    n = len(x)
    spec = np.abs(np.fft.rfft(x * np.hanning(n)))
    freqs = np.fft.rfftfreq(n, 1 / SR)
    return float(np.sum(freqs * spec) / (np.sum(spec) + 1e-9))


def write_wav(path: Path, data: np.ndarray, target_db: float = -14.0):
    y = normalize_rms(np.clip(data, -1.5, 1.5), target_db)
    wavfile.write(str(path), SR, (y * 32767).astype(np.int16))
    print(f"wrote {path.name} ({len(y)/SR:.2f}s, "
          f"centroid={brightness(y):.0f}Hz)")
