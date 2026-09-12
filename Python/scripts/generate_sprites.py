"""Premium sci-fi sprite set for Astro Wars.

Art direction: SERIOUS, modern vector-shooter look for university players.
Dark gunmetal hulls, vertical metal gradients, sharp angular silhouettes,
single glowing visors/cores, neon trim. No cartoon eyes, no googly faces.

Top-down, ships point UP, enemies/bosses point DOWN. Transparency inside.
Drawn at 4x supersample, downscaled with LANCZOS.

Outputs (Flutter/assets/images), same filenames as before (no code churn):
  ship_sleek / ship_heavy / ship_pixel / ship_cipher  (128px)
  enemy_bug / enemy_noodle / enemy_chick / enemy_ufo /
  enemy_crab / enemy_jelly / enemy_metal / enemy_ghost (96px)
  boss_dreadnought / boss_mothership / boss_yolk / boss_worm (256px)
  gift_* x7                                            (64px)

Usage: uv run scripts/generate_sprites.py --out out
"""
from __future__ import annotations
import argparse
import math
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

SS = 4
DARK = (12, 12, 22, 255)
WHITE = (255, 255, 255, 255)
GUN = (74, 80, 102, 255)
GUN_D = (42, 45, 62, 255)
GUN_L = (120, 128, 155, 255)
STEEL = (160, 168, 190, 255)


def canvas(px: int) -> Image.Image:
    return Image.new("RGBA", (px * SS, px * SS), (0, 0, 0, 0))


def finish(img: Image.Image, px: int) -> Image.Image:
    return img.resize((px, px), Image.LANCZOS)


def s(v: float) -> float:
    return v * SS


def mix(a: tuple, b: tuple, t: float) -> tuple:
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3)) + (255,)


def vgrad(d: ImageDraw.ImageDraw, x0, y0, x1, y1, top: tuple, bot: tuple):
    """Vertical metal gradient inside a rect (caller clips via shapes)."""
    h = max(1, int(y1 - y0))
    for i in range(h):
        c = mix(top, bot, i / h)
        d.line([x0, y0 + i, x1, y0 + i], fill=c)


def poly(d, pts, fill, outline=DARK, w=2):
    p = [s(v) for pt in pts for v in pt]
    if outline is not None:
        # rim by drawing slightly larger dark poly behind
        cx = sum(p[0::2]) / (len(p) // 2)
        cy = sum(p[1::2]) / (len(p) // 2)
        rim = []
        for x, y in zip(p[0::2], p[1::2]):
            rim += [cx + (x - cx) * 1.06, cy + (y - cy) * 1.06]
        d.polygon(rim, fill=DARK)
    d.polygon(p, fill=fill)
    if outline is not None and w:
        d.line(p + p[:2], fill=outline, width=int(SS * w), joint="curve")


def glow_under(base: Image.Image, color: tuple, blur: int = 6) -> Image.Image:
    alpha = base.split()[3].point(lambda a: a * 2 // 3)
    solid = Image.new("RGBA", base.size, color)
    solid.putalpha(alpha)
    return solid.filter(ImageFilter.GaussianBlur(max(2, blur * SS // 4)))


def visor(d, cx, cy, w, h, color=(255, 60, 70, 255)):
    """Single menacing visor slit with glow core."""
    d.rounded_rectangle([s(cx - w / 2), s(cy - h / 2),
                         s(cx + w / 2), s(cy + h / 2)],
                        radius=s(h / 2), fill=(16, 16, 26, 255),
                        outline=DARK, width=SS * 2)
    d.rounded_rectangle([s(cx - w / 2 + 2), s(cy - h / 4),
                         s(cx + w / 2 - 2), s(cy + h / 4)],
                        radius=s(h / 4), fill=color)
    d.line([s(cx - w / 4), s(cy), s(cx + w / 4), s(cy)], fill=WHITE,
           width=SS)


def canopy(d, cx, cy, w, h):
    """Glass cockpit: deep blue gradient + specular streak."""
    d.ellipse([s(cx - w / 2), s(cy - h / 2), s(cx + w / 2), s(cy + h / 2)],
              fill=(20, 60, 120, 255), outline=DARK, width=SS * 2)
    d.ellipse([s(cx - w / 2 + 2), s(cy - h / 2 + 2),
               s(cx - w / 6), s(cy)], fill=(140, 210, 255, 255))
    d.line([s(cx - w / 4), s(cy - h / 3), s(cx), s(cy - h / 3 + 2)],
           fill=WHITE, width=SS)


def thruster(d, cx, cy, r, color):
    d.ellipse([s(cx - r), s(cy - r), s(cx + r), s(cy + r)],
              fill=DARK)
    d.ellipse([s(cx - r * 0.6), s(cy - r * 0.6),
               s(cx + r * 0.6), s(cy + r * 0.6)], fill=color)
    d.ellipse([s(cx - r * 1.6), s(cy), s(cx + r * 1.6), s(cy + r * 2.2)],
              fill=color[:3] + (110,))


def panel(d, x0, y0, x1, y1, r=3):
    d.rounded_rectangle([s(x0), s(y0), s(x1), s(y1)], radius=s(r),
                        outline=(30, 32, 48, 255), width=SS)


# ------------------------------------------------------------------- ships
def ship_sleek() -> Image.Image:
    px = 128
    img = canvas(px)
    d = ImageDraw.Draw(img)
    C = (34, 230, 255, 255)
    # swept wings with cyan edge light
    poly(d, [(64, 34), (18, 92), (30, 98), (58, 54)], GUN_D)
    poly(d, [(64, 34), (110, 92), (98, 98), (70, 54)], GUN_D)
    d.line([s(64), s(36), s(20), s(90)], fill=C, width=SS * 2)
    d.line([s(64), s(36), s(108), s(90)], fill=C, width=SS * 2)
    # fuselage
    vgrad(d, s(50), s(14), s(78), s(106), GUN_L, GUN_D)
    poly(d, [(64, 10), (77, 58), (71, 104), (57, 104), (51, 58)], None)
    d.line([s(64), s(10), s(77), s(58), s(71), s(104)], fill=DARK,
           width=SS * 2, joint="curve")
    d.line([s(64), s(10), s(51), s(58), s(57), s(104)], fill=DARK,
           width=SS * 2, joint="curve")
    # spine + vents
    d.line([s(64), s(30), s(64), s(95)], fill=(30, 32, 48, 255), width=SS * 2)
    for y in (66, 76, 86):
        d.line([s(59), s(y), s(69), s(y)], fill=C, width=SS)
    canopy(d, 64, 48, 15, 24)
    thruster(d, 64, 106, 6, C)
    gl = glow_under(img, (34, 150, 255, 255))
    return finish(Image.alpha_composite(gl, img), px)


def ship_heavy() -> Image.Image:
    px = 128
    img = canvas(px)
    d = ImageDraw.Draw(img)
    O = (255, 150, 50, 255)
    # armored wings
    poly(d, [(64, 42), (12, 84), (12, 104), (50, 86)], GUN)
    poly(d, [(64, 42), (116, 84), (116, 104), (78, 86)], GUN)
    panel(d, 16, 88, 46, 100)
    panel(d, 82, 88, 112, 100)
    # hull
    vgrad(d, s(42), s(16), s(86), s(108), GUN_L, GUN_D)
    d.rounded_rectangle([s(42), s(16), s(86), s(108)], radius=s(12),
                        outline=DARK, width=SS * 3)
    # bow plate + stripe
    d.rounded_rectangle([s(48), s(22), s(80), s(46)], radius=s(6),
                        fill=(52, 56, 74, 255), outline=DARK, width=SS * 2)
    d.rectangle([s(48), s(60), s(80), s(66)], fill=O)
    # twin cockpits
    canopy(d, 64, 80, 13, 12)
    canopy(d, 64, 94, 13, 10)
    # rail cannons
    for x in (34, 94):
        d.rounded_rectangle([s(x - 5), s(58), s(x + 5), s(100)], radius=s(4),
                            fill=GUN_D, outline=DARK, width=SS * 2)
        d.rectangle([s(x - 2), s(96), s(x + 2), s(108)], fill=O)
    thruster(d, 54, 108, 5, O)
    thruster(d, 64, 110, 6, O)
    thruster(d, 74, 108, 5, O)
    gl = glow_under(img, (255, 140, 40, 255))
    return finish(Image.alpha_composite(gl, img), px)


def ship_pixel() -> Image.Image:
    # Recon scout: light frame, sensor green accents, sharp needle nose.
    px = 128
    img = canvas(px)
    d = ImageDraw.Draw(img)
    G = (61, 255, 150, 255)
    # needle fuselage
    poly(d, [(64, 8), (72, 70), (68, 106), (60, 106), (56, 70)], GUN)
    d.line([s(64), s(8), s(64), s(106)], fill=G, width=SS * 2)
    # sensor fins
    poly(d, [(60, 60), (28, 92), (40, 94), (58, 70)], GUN_D)
    poly(d, [(68, 60), (100, 92), (88, 94), (70, 70)], GUN_D)
    d.line([s(60), s(62), s(30), s(90)], fill=G, width=SS * 2)
    d.line([s(68), s(62), s(98), s(90)], fill=G, width=SS * 2)
    # sensor band + eye lens
    d.rectangle([s(57), s(40), s(71), s(46)], fill=(16, 20, 30, 255),
                outline=DARK, width=SS)
    d.ellipse([s(60), s(41), s(68), s(45)], fill=G)
    canopy(d, 64, 62, 11, 16)
    # wingtip sensors
    for x in (30, 98):
        d.ellipse([s(x - 3), s(86), s(x + 3), s(92)], fill=G,
                  outline=DARK, width=SS)
    thruster(d, 64, 108, 5, G)
    gl = glow_under(img, (50, 220, 130, 255))
    return finish(Image.alpha_composite(gl, img), px)


def ship_cipher() -> Image.Image:
    # Black-ops: near-black faceted hull, magenta photon trim.
    px = 128
    img = canvas(px)
    d = ImageDraw.Draw(img)
    M = (255, 61, 220, 255)
    HULL = (26, 24, 44, 255)
    poly(d, [(64, 10), (80, 55), (104, 80), (76, 74), (70, 108),
             (58, 108), (52, 74), (24, 80), (48, 55)], HULL)
    d.line([s(64), s(10), s(64), s(108)], fill=(48, 44, 80, 255), width=SS * 2)
    d.line([s(48), s(55), s(80), s(55)], fill=(48, 44, 80, 255), width=SS * 2)
    for x0, y0, x1, y1 in ((48, 55, 24, 80), (80, 55, 104, 80),
                           (52, 74, 58, 108), (76, 74, 70, 108)):
        d.line([s(x0), s(y0), s(x1), s(y1)], fill=M, width=SS * 2)
    # visor slit instead of canopy
    visor(d, 64, 40, 22, 7, color=M)
    # cloaking seams
    d.line([s(58), s(62), s(60), s(92)], fill=M, width=SS)
    d.line([s(70), s(62), s(68), s(92)], fill=M, width=SS)
    thruster(d, 64, 108, 5, M)
    gl = glow_under(img, (160, 50, 255, 255))
    return finish(Image.alpha_composite(gl, img), px)


# ----------------------------------------------------------------- enemies
def enemy_bug() -> Image.Image:
    # Wasp interceptor: hex armor, red visor, blade wings, nose cannon.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    # blade wings
    poly(d, [(48, 40), (14, 58), (20, 66), (46, 52)], STEEL)
    poly(d, [(48, 40), (82, 58), (76, 66), (50, 52)], STEEL)
    # hex thorax
    vgrad(d, s(30), s(28), s(66), s(76), GUN_L, GUN_D)
    poly(d, [(48, 26), (66, 38), (66, 64), (48, 78), (30, 64), (30, 38)],
         None)
    d.line([s(48), s(26), s(66), s(38), s(66), s(64), s(48), s(78),
            s(30), s(64), s(30), s(38), s(48), s(26)], fill=DARK,
           width=SS * 2, joint="curve")
    # armor seams
    d.line([s(34), s(50), s(62), s(50)], fill=(30, 32, 48, 255), width=SS * 2)
    d.line([s(36), s(60), s(60), s(60)], fill=(30, 32, 48, 255), width=SS * 2)
    # visor + cannon
    visor(d, 48, 44, 26, 9)
    d.rounded_rectangle([s(44), s(66), s(52), s(84)], radius=s(3),
                        fill=GUN_D, outline=DARK, width=SS * 2)
    d.ellipse([s(45), s(80), s(51), s(86)], fill=(255, 80, 80, 255))
    gl = glow_under(img, (255, 70, 70, 255))
    return finish(Image.alpha_composite(gl, img), px)


def enemy_noodle() -> Image.Image:
    # Coil drone: stacked torus rings around a plasma core.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    C = (255, 170, 40, 255)
    for i, (cy, rx) in enumerate(((34, 26), (48, 30), (62, 26))):
        d.ellipse([s(48 - rx), s(cy - 10), s(48 + rx), s(cy + 10)],
                  outline=mix(GUN, C, i / 3), width=SS * 3)
        d.ellipse([s(48 - rx), s(cy - 10), s(48 + rx), s(cy + 10)],
                  outline=DARK, width=SS)
    # core chamber
    d.rounded_rectangle([s(36), s(36), s(60), s(64)], radius=s(8),
                        fill=(20, 20, 32, 255), outline=DARK, width=SS * 2)
    d.ellipse([s(41), s(41), s(55), s(59)], fill=C)
    d.ellipse([s(44), s(44), s(52), s(52)], fill=WHITE)
    # emitter
    d.polygon([s(42), s(64), s(54), s(64), s(48), s(80)], fill=GUN_D,
              outline=DARK)
    d.ellipse([s(45), s(75), s(51), s(81)], fill=C)
    gl = glow_under(img, C)
    return finish(Image.alpha_composite(gl, img), px)


def enemy_chick() -> Image.Image:
    # Dart: minimal tri-blade fast interceptor, amber sensor dot.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    A = (255, 190, 60, 255)
    poly(d, [(48, 18), (56, 52), (78, 70), (56, 62), (48, 78),
             (40, 62), (18, 70), (40, 52)], GUN)
    # edge lights
    d.line([s(48), s(20), s(76), s(68)], fill=A, width=SS * 2)
    d.line([s(48), s(20), s(20), s(68)], fill=A, width=SS * 2)
    # sensor core
    d.ellipse([s(41), s(47), s(55), s(61)], fill=(18, 18, 30, 255),
              outline=DARK, width=SS * 2)
    d.ellipse([s(44), s(50), s(52), s(58)], fill=A)
    thruster(d, 48, 76, 4, A)
    gl = glow_under(img, A)
    return finish(Image.alpha_composite(gl, img), px)


def enemy_ufo() -> Image.Image:
    # Recon saucer: dark disc, glass dome, scanning array.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    vgrad(d, s(12), s(46), s(84), s(74), GUN_L, GUN_D)
    d.ellipse([s(12), s(44), s(84), s(76)], outline=DARK, width=SS * 3)
    d.ellipse([s(24), s(54), s(72), s(68)], fill=(30, 32, 50, 255),
              outline=DARK, width=SS * 2)
    # dome + operator silhouette
    d.pieslice([s(32), s(20), s(64), s(52)], start=180, end=360,
               fill=(120, 190, 240, 200), outline=DARK, width=SS * 2)
    d.ellipse([s(42), s(32), s(54), s(48)], fill=(18, 22, 36, 255))
    visor(d, 48, 41, 10, 4, color=(34, 230, 255, 255))
    # rim lights
    for i, cx in enumerate((30, 48, 66)):
        c = [(255, 80, 80, 255), (255, 210, 90, 255), (80, 255, 150, 255)][i]
        d.ellipse([s(cx - 4), s(63), s(cx + 4), s(71)], fill=c,
                  outline=DARK, width=SS)
    gl = glow_under(img, (120, 190, 240, 255))
    return finish(Image.alpha_composite(gl, img), px)


def enemy_crab() -> Image.Image:
    # Siege walker: low heavy tank, twin railguns, hazard stripes.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    # treads
    for sx in (-1, 1):
        d.rounded_rectangle([s(48 + sx * 30 - 9), s(48), s(48 + sx * 30 + 9),
                             s(76)], radius=s(7), fill=(26, 28, 42, 255),
                            outline=DARK, width=SS * 2)
        for wy in (55, 62, 69):
            d.line([s(48 + sx * 30 - 9), s(wy), s(48 + sx * 30 + 9), s(wy)],
                   fill=STEEL, width=SS)
    # hull
    vgrad(d, s(24), s(30), s(72), s(66), GUN_L, GUN_D)
    d.rounded_rectangle([s(24), s(30), s(72), s(66)], radius=s(8),
                        outline=DARK, width=SS * 3)
    # hazard chevrons
    for i in range(3):
        x = 34 + i * 12
        d.line([s(x), s(60), s(x + 6), s(54)], fill=(255, 190, 60, 255),
               width=SS * 2)
    # twin railguns pointing down
    for cx in (40, 56):
        d.rounded_rectangle([s(cx - 4), s(60), s(cx + 4), s(82)], radius=s(3),
                            fill=GUN_D, outline=DARK, width=SS * 2)
        d.rectangle([s(cx - 2), s(78), s(cx + 2), s(86)],
                    fill=(255, 90, 90, 255))
    visor(d, 48, 42, 26, 8)
    gl = glow_under(img, (255, 120, 60, 255))
    return finish(Image.alpha_composite(gl, img), px)


def enemy_jelly() -> Image.Image:
    # Aegis drone: hex energy shield + core, cyan seams.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    C = (60, 230, 255, 255)
    # shield hex
    vgrad(d, s(22), s(20), s(74), s(76), (40, 60, 110, 220),
          (22, 30, 66, 220))
    poly(d, [(48, 18), (74, 33), (74, 63), (48, 78), (22, 63), (22, 33)],
         None)
    d.line([s(48), s(18), s(74), s(33), s(74), s(63), s(48), s(78),
            s(22), s(63), s(22), s(33), s(48), s(18)], fill=C,
           width=SS * 2, joint="curve")
    # core
    d.ellipse([s(36), s(36), s(60), s(60)], fill=(14, 18, 34, 255),
              outline=DARK, width=SS * 2)
    d.ellipse([s(41), s(41), s(55), s(55)], fill=C)
    d.ellipse([s(44), s(44), s(52), s(52)], fill=WHITE)
    # pylons
    for x0, y0, x1, y1 in ((48, 60, 48, 74), (36, 52, 26, 60),
                           (60, 52, 70, 60)):
        d.line([s(x0), s(y0), s(x1), s(y1)], fill=GUN_D, width=SS * 3)
        d.ellipse([s(x1 - 3), s(y1 - 3), s(x1 + 3), s(y1 + 3)], fill=C,
                  outline=DARK, width=SS)
    gl = glow_under(img, C)
    return finish(Image.alpha_composite(gl, img), px)


def enemy_metal() -> Image.Image:
    # Bulwark: riveted heavy armor, red slit visor, shoulder plates.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    vgrad(d, s(26), s(22), s(70), s(78), GUN_L, GUN_D)
    d.rounded_rectangle([s(26), s(22), s(70), s(78)], radius=s(10),
                        outline=DARK, width=SS * 3)
    # shoulder plates
    for sx in (-1, 1):
        d.rounded_rectangle([s(48 + sx * 30 - 11), s(28),
                             s(48 + sx * 30 + 11), s(50)], radius=s(6),
                            fill=GUN, outline=DARK, width=SS * 2)
    # chest vent
    d.rounded_rectangle([s(38), s(52), s(58), s(72)], radius=s(4),
                        fill=(24, 26, 40, 255), outline=DARK, width=SS * 2)
    for vy in (57, 62, 67):
        d.line([s(41), s(vy), s(55), s(vy)], fill=(255, 120, 60, 255),
               width=SS)
    # rivets
    for rx, ry in ((30, 26), (66, 26), (30, 74), (66, 74)):
        d.ellipse([s(rx - 2), s(ry - 2), s(rx + 2), s(ry + 2)],
                  fill=(60, 64, 86, 255), outline=DARK, width=SS)
    visor(d, 48, 38, 30, 9)
    # antenna
    d.line([s(60), s(22), s(60), s(12)], fill=DARK, width=SS * 2)
    d.ellipse([s(57), s(8), s(63), s(14)], fill=(255, 60, 70, 255),
              outline=DARK, width=SS)
    gl = glow_under(img, (170, 176, 200, 255))
    return finish(Image.alpha_composite(gl, img), px)


def enemy_ghost() -> Image.Image:
    # Phantom: matte-black stealth wedge, cyan refraction seams, red eye.
    px = 96
    img = canvas(px)
    d = ImageDraw.Draw(img)
    C = (60, 230, 255, 255)
    B = (16, 16, 28, 235)
    poly(d, [(48, 16), (58, 44), (80, 60), (58, 58), (54, 80),
             (42, 80), (38, 58), (16, 60), (38, 44)], B)
    # refraction seams
    d.line([s(48), s(18), s(54), s(78)], fill=C, width=SS)
    d.line([s(40), s(44), s(18), s(59)], fill=C, width=SS)
    d.line([s(56), s(44), s(78), s(59)], fill=C, width=SS)
    # single red optic
    d.ellipse([s(42), s(36), s(54), s(48)], fill=(20, 10, 14, 255),
              outline=DARK, width=SS * 2)
    d.ellipse([s(45), s(39), s(51), s(45)], fill=(255, 50, 60, 255))
    d.ellipse([s(46), s(39), s(49), s(42)], fill=WHITE)
    gl = glow_under(img, (80, 120, 200, 255))
    return finish(Image.alpha_composite(gl, img), px)


# ------------------------------------------------------------------- bosses
def boss_dreadnought() -> Image.Image:
    # Capital ship: layered hull, turret batteries, reactor core.
    px = 256
    img = canvas(px)
    d = ImageDraw.Draw(img)
    R = (255, 60, 80, 255)
    # escort pods
    for sx in (-1, 1):
        cx = 128 + sx * 84
        vgrad(d, s(cx - 26), s(90), s(cx + 26), s(196), GUN, GUN_D)
        d.rounded_rectangle([s(cx - 26), s(90), s(cx + 26), s(196)],
                            radius=s(20), outline=DARK, width=SS * 3)
        visor(d, cx, 134, 22, 8)
        d.rounded_rectangle([s(cx - 8), s(160), s(cx + 8), s(192)],
                            radius=s(4), fill=GUN_D, outline=DARK,
                            width=SS * 2)
        d.ellipse([s(cx - 5), s(186), s(cx + 5), s(196)], fill=R)
    # main hull
    vgrad(d, s(40), s(52), s(216), s(208), GUN_L, GUN_D)
    d.ellipse([s(38), s(50), s(218), s(210)], outline=DARK, width=SS * 4)
    d.ellipse([s(60), s(72), s(196), s(188)], fill=(36, 40, 58, 255),
              outline=DARK, width=SS * 2)
    # armor ring + hazard marks
    for i in range(12):
        a = math.radians(i * 30)
        x0, y0 = 128 + 80 * math.cos(a), 130 + 64 * math.sin(a)
        x1, y1 = 128 + 90 * math.cos(a), 130 + 74 * math.sin(a)
        c = R if i % 2 == 0 else STEEL
        d.line([s(x0), s(y0), s(x1), s(y1)], fill=c, width=SS * 3)
    # triple turret battery (trained on player)
    for cx in (88, 128, 168):
        d.rounded_rectangle([s(cx - 10), s(148), s(cx + 10), s(176)],
                            radius=s(5), fill=GUN_D, outline=DARK,
                            width=SS * 2)
        d.rectangle([s(cx - 5), s(172), s(cx + 5), s(200)], fill=GUN_D,
                    outline=DARK, width=SS * 2)
        d.ellipse([s(cx - 5), s(196), s(cx + 5), s(206)], fill=R,
                  outline=DARK, width=SS)
    # reactor core
    d.ellipse([s(100), s(102), s(156), s(158)], fill=R, outline=DARK,
              width=SS * 3)
    d.ellipse([s(114), s(116), s(142), s(144)], fill=(255, 190, 190, 255))
    d.ellipse([s(122), s(124), s(134), s(136)], fill=WHITE)
    # command visor
    visor(d, 128, 84, 44, 10)
    gl = glow_under(img, (255, 70, 90, 255), blur=10)
    return finish(Image.alpha_composite(gl, img), px)


def boss_mothership() -> Image.Image:
    # Fleet carrier: long hull, launch bays, sensor spines, bridge.
    px = 256
    img = canvas(px)
    d = ImageDraw.Draw(img)
    C = (34, 230, 255, 255)
    # outer wings
    poly(d, [(128, 56), (232, 116), (210, 196), (150, 150)], GUN)
    poly(d, [(128, 56), (24, 116), (46, 196), (106, 150)], GUN)
    for sx in (-1, 1):
        x0 = 128 + sx * 60
        x1 = 128 + sx * 150
        d.line([s(x0), s(90), s(x1), s(130)], fill=C, width=SS * 2)
    # main spine
    vgrad(d, s(96), s(36), s(160), s(220), GUN_L, GUN_D)
    d.rounded_rectangle([s(96), s(36), s(160), s(220)], radius=s(24),
                        outline=DARK, width=SS * 4)
    # launch bays (dark slots with red interior light)
    for by in (110, 140, 170):
        d.rounded_rectangle([s(104), s(by), s(152), s(by + 16)],
                            radius=s(6), fill=(16, 16, 28, 255),
                            outline=DARK, width=SS * 2)
        d.line([s(110), s(by + 8), s(146), s(by + 8)],
               fill=(255, 70, 80, 255), width=SS * 2)
    # sensor spines crown
    for i in range(-2, 3):
        bx = 128 + i * 22
        poly(d, [(bx - 9, 52), (bx + 9, 52), (bx, 26)], GUN_D)
        d.ellipse([s(bx - 4), s(32), s(bx + 4), s(40)], fill=C,
                  outline=DARK, width=SS)
    # bridge
    d.rounded_rectangle([s(108), s(56), s(148), s(88)], radius=s(8),
                        fill=(24, 28, 48, 255), outline=DARK, width=SS * 3)
    visor(d, 128, 72, 30, 8, color=C)
    # engine block
    for cx in (112, 128, 144):
        thruster(d, cx, 214, 8, C)
    gl = glow_under(img, (90, 160, 255, 255), blur=10)
    return finish(Image.alpha_composite(gl, img), px)


def boss_yolk() -> Image.Image:
    # Solar reactor core: blazing ring, containment struts, white-hot eye.
    px = 256
    img = canvas(px)
    d = ImageDraw.Draw(img)
    F = (255, 150, 40, 255)
    # corona spikes
    for i in range(16):
        a = math.radians(i * 22.5)
        r0, r1 = (96, 122) if i % 2 == 0 else (96, 110)
        d.line([s(128 + r0 * math.cos(a)), s(128 + r0 * math.sin(a)),
                s(128 + r1 * math.cos(a)), s(128 + r1 * math.sin(a))],
               fill=F, width=SS * 4)
    # containment ring
    d.ellipse([s(46), s(46), s(210), s(210)], outline=GUN, width=SS * 5)
    for i in range(8):
        a = math.radians(i * 45)
        cx, cy = 128 + 82 * math.cos(a), 128 + 82 * math.sin(a)
        d.ellipse([s(cx - 7), s(cy - 7), s(cx + 7), s(cy + 7)], fill=GUN_D,
                  outline=DARK, width=SS * 2)
        d.ellipse([s(cx - 3), s(cy - 3), s(cx + 3), s(cy + 3)], fill=C_)
    # plasma body
    vgrad(d, s(62), s(62), s(194), s(194), (255, 220, 140, 255),
          (240, 130, 40, 255))
    d.ellipse([s(60), s(60), s(196), s(196)], outline=DARK, width=SS * 4)
    # convection cells
    import random
    rnd = random.Random(4)
    for _ in range(7):
        cx = 128 + rnd.uniform(-45, 45)
        cy = 128 + rnd.uniform(-45, 45)
        r = rnd.uniform(8, 14)
        d.ellipse([s(cx - r), s(cy - r), s(cx + r), s(cy + r)],
                  outline=(220, 110, 30, 255), width=SS * 2)
    # reactor eye (surveillance lens, not a face)
    d.ellipse([s(104), s(104), s(152), s(152)], fill=(18, 18, 30, 255),
              outline=DARK, width=SS * 3)
    d.ellipse([s(114), s(114), s(142), s(142)], fill=(255, 90, 60, 255))
    d.ellipse([s(121), s(121), s(135), s(135)], fill=WHITE)
    gl = glow_under(img, F, blur=10)
    return finish(Image.alpha_composite(gl, img), px)


C_ = (34, 230, 255, 255)


def boss_worm() -> Image.Image:
    # Leviathan: armored segments, dorsal blades, jaw maw, sensor visor.
    px = 256
    img = canvas(px)
    d = ImageDraw.Draw(img)
    # tail segments
    for i, (cx, cy, r) in enumerate(((64, 84, 30), (48, 140, 37), (58, 200, 43))):
        vgrad(d, s(cx - r), s(cy - r), s(cx + r), s(cy + r), GUN_L, GUN_D)
        d.ellipse([s(cx - r), s(cy - r), s(cx + r), s(cy + r)],
                  outline=DARK, width=SS * 3)
        d.arc([s(cx - r), s(cy - r), s(cx + r), s(cy + r)], start=200,
              end=340, fill=STEEL, width=SS * 3)
        # dorsal blade
        poly(d, [(cx - 12, cy - r + 6), (cx + 12, cy - r + 6),
                 (cx, cy - r - 24)], GUN_D)
    # head
    vgrad(d, s(92), s(44), s(212), s(172), GUN_L, GUN_D)
    d.ellipse([s(88), s(44), s(212), s(172)], outline=DARK, width=SS * 4)
    # crown blades
    for cx in (120, 150, 180):
        poly(d, [(cx - 10, 60), (cx + 10, 60), (cx, 32)], GUN_D)
    # maw with teeth (faces player below)
    d.ellipse([s(108), s(116), s(192), s(158)], fill=(90, 16, 24, 255),
              outline=DARK, width=SS * 3)
    for i in range(6):
        x = 118 + i * 12
        poly(d, [(x - 6, 122), (x + 6, 122), (x, 136)], WHITE, outline=DARK,
             w=1)
        poly(d, [(x - 6, 152), (x + 6, 152), (x, 138)], WHITE, outline=DARK,
             w=1)
    # sensor visor across brow
    visor(d, 150, 88, 56, 11)
    gl = glow_under(img, (140, 160, 200, 255), blur=10)
    return finish(Image.alpha_composite(gl, img), px)


# ------------------------------------------------------- supply crates
def gift_box(base: tuple, glyph: str) -> Image.Image:
    # Mil-spec supply crate: dark alloy, neon seal, holographic glyph.
    px = 64
    img = canvas(px)
    d = ImageDraw.Draw(img)
    seal = tuple(min(255, c + 70) for c in base[:3]) + (255,)
    body = (30, 33, 52, 255)
    # crate
    d.rounded_rectangle([s(12), s(22), s(52), s(54)], radius=s(4),
                        fill=body, outline=DARK, width=SS * 2)
    # corner bolts
    for bx, by in ((16, 26), (48, 26), (16, 50), (48, 50)):
        d.ellipse([s(bx - 2), s(by - 2), s(bx + 2), s(by + 2)], fill=STEEL)
    # lid + seal band
    d.rounded_rectangle([s(10), s(15), s(54), s(27)], radius=s(4),
                        fill=(42, 46, 68, 255), outline=DARK, width=SS * 2)
    d.rectangle([s(10), s(32), s(54), s(38)], fill=base)
    d.rectangle([s(29), s(15), s(35), s(54)], fill=base)
    d.line([s(10), s(35), s(54), s(35)], fill=seal, width=SS)
    d.line([s(32), s(15), s(32), s(54)], fill=seal, width=SS)
    # holographic glyph plate
    d.rounded_rectangle([s(21), s(40), s(43), s(52)], radius=s(3),
                        fill=(12, 14, 26, 255), outline=seal, width=SS)
    _glyph(d, glyph, seal)
    gl = glow_under(img, base)
    return finish(Image.alpha_composite(gl, img), px)


def _glyph(d: ImageDraw.ImageDraw, kind: str, neon: tuple):
    if kind == "bolt":
        d.polygon([s(35), s(41), s(30), s(47), s(32), s(47), s(29), s(51),
                   s(36), s(44), s(34), s(44)], fill=neon)
    elif kind == "server":
        d.rounded_rectangle([s(25), s(42), s(39), s(50)], radius=s(1),
                            fill=neon)
        for cy in (44, 47, 50):
            d.ellipse([s(36), s(cy - 1), s(38), s(cy + 1)],
                      fill=(12, 14, 26, 255))
    elif kind == "shield":
        d.polygon([s(32), s(41), s(37), s(43), s(37), s(46), s(32), s(50),
                   s(27), s(46), s(27), s(43)], fill=neon)
    elif kind == "star":
        pts = []
        for i in range(10):
            a = -math.pi / 2 + i * math.pi / 5
            r = 5.5 if i % 2 == 0 else 2.4
            pts.append((32 + r * math.cos(a), 46 + r * math.sin(a)))
        d.polygon([s(v) for p in pts for v in p], fill=neon)
    elif kind == "cross":
        d.rectangle([s(30), s(42), s(34), s(50)], fill=neon)
        d.rectangle([s(26), s(44), s(38), s(48)], fill=neon)
    elif kind == "rocket":
        d.polygon([s(32), s(41), s(36), s(47), s(28), s(47)], fill=neon)
        d.ellipse([s(30), s(44), s(34), s(48)], fill=(12, 14, 26, 255))
    elif kind == "snow":
        for ang in (0, 60, 120):
            a = math.radians(ang)
            d.line([s(32 - 5 * math.cos(a)), s(46 - 5 * math.sin(a)),
                    s(32 + 5 * math.cos(a)), s(46 + 5 * math.sin(a))],
                   fill=neon, width=SS)


SPRITES = {
    "ship_sleek": (ship_sleek, 128),
    "ship_heavy": (ship_heavy, 128),
    "ship_pixel": (ship_pixel, 128),
    "ship_cipher": (ship_cipher, 128),
    "enemy_bug": (enemy_bug, 96),
    "enemy_noodle": (enemy_noodle, 96),
    "enemy_chick": (enemy_chick, 96),
    "enemy_ufo": (enemy_ufo, 96),
    "enemy_crab": (enemy_crab, 96),
    "enemy_jelly": (enemy_jelly, 96),
    "enemy_metal": (enemy_metal, 96),
    "enemy_ghost": (enemy_ghost, 96),
    "boss_dreadnought": (boss_dreadnought, 256),
    "boss_mothership": (boss_mothership, 256),
    "boss_yolk": (boss_yolk, 256),
    "boss_worm": (boss_worm, 256),
    "gift_flutter": (lambda: gift_box((50, 140, 255, 255), "bolt"), 64),
    "gift_backend": (lambda: gift_box((255, 140, 40, 255), "server"), 64),
    "gift_shield": (lambda: gift_box((34, 230, 255, 255), "shield"), 64),
    "gift_stun": (lambda: gift_box((170, 90, 255, 255), "star"), 64),
    "gift_heal": (lambda: gift_box((61, 255, 136, 255), "cross"), 64),
    "gift_missile": (lambda: gift_box((255, 77, 109, 255), "rocket"), 64),
    "gift_coolant": (lambda: gift_box((150, 220, 255, 255), "snow"), 64),
}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--out", default="out")
    args = ap.parse_args()
    out = Path(__file__).resolve().parent.parent / args.out
    out.mkdir(parents=True, exist_ok=True)
    for name, (fn, px) in SPRITES.items():
        img = fn()
        assert img.size == (px, px), (name, img.size)
        img.save(out / f"{name}.png")
        print(f"wrote {name}.png ({px}px)")


if __name__ == "__main__":
    main()
