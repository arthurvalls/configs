#!/usr/bin/env python3
"""Generate gruvbox-topo.png — a topographic contour-map wallpaper for the
gruvbox-ish kitty theme. Builds a smooth fractal height field (value noise +
a few concentric peaks/basins), quantises it into elevation bands, and draws
the band boundaries as contour lines coloured aqua->orange by elevation over
dark0_hard. Mostly-dark so terminal text stays readable. Deterministic (seed).
Re-tune SEED / N_LEVELS / LINE_ALPHA / TINT and re-run:

    python3 make-gruvbox-topo.py
"""

import numpy as np
from PIL import Image, ImageFilter

W, H = 2560, 1440
SEED = 7
N_LEVELS = 15        # number of elevation bands (more = denser contours)
LINE_ALPHA = 0.9     # contour line opacity over the background

BG = np.array([29, 32, 33], np.float32)       # #1d2021 dark0_hard
AQUA = np.array([104, 157, 106], np.float32)   # #689d6a (low elevation)
ORANGE = np.array([231, 138, 78], np.float32)  # #e78a4e (high elevation)

rng = np.random.default_rng(SEED)

# fractal value noise: low-res random grids upscaled (bicubic) and summed
field = np.zeros((H, W), np.float32)
for res, amp in [(6, 1.0), (12, 0.5), (24, 0.25), (48, 0.12)]:
    g = (rng.random((res, res)) * 255).astype(np.uint8)
    up = np.asarray(Image.fromarray(g).resize((W, H), Image.BICUBIC), np.float32) / 255.0
    field += up * amp

# concentric peaks/basins so the contours form map-like rings
yy, xx = np.mgrid[0:H, 0:W]
for _ in range(6):
    cx, cy = int(rng.integers(0, W)), int(rng.integers(0, H))
    sig = int(rng.integers(350, 750))
    amp = float(rng.choice([1.0, -1.0]) * rng.uniform(0.5, 1.0))
    d2 = (xx - cx) ** 2 + (yy - cy) ** 2
    field += amp * np.exp(-d2 / (2.0 * sig * sig)).astype(np.float32)

field -= field.min()
field /= field.max()

# quantise into bands and find the band boundaries (contour lines)
levels = np.floor(field * N_LEVELS)
edges = (levels != np.roll(levels, 1, axis=0)) | (levels != np.roll(levels, 1, axis=1))

# thicken the 1px contours slightly
m = Image.fromarray((edges * 255).astype(np.uint8)).filter(ImageFilter.MaxFilter(3))
edges = np.asarray(m) > 127

# compose: faint elevation tint between lines, aqua->orange contours over it
t = field[..., None]
line = AQUA * (1 - t) + ORANGE * t
out = np.empty((H, W, 3), np.float32)
out[:] = BG
out += field[..., None] * np.array([8, 7, 3], np.float32)  # subtle depth tint
out = np.where(edges[..., None], BG * (1 - LINE_ALPHA) + line * LINE_ALPHA, out)

# gentle vignette
nx, ny = (xx / W - 0.5), (yy / H - 0.5)
dist = np.sqrt(nx * nx + ny * ny) / 0.7071
vig = np.clip(1.0 - 0.55 * dist * dist, 0.35, 1.0)[..., None]
out *= vig

out = np.clip(out, 0, 255).astype(np.uint8)
path = __file__.rsplit("/", 1)[0] + "/gruvbox-topo.png"
Image.fromarray(out, "RGB").save(path)
print("wrote", path, (W, H))
