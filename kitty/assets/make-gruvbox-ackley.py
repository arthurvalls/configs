#!/usr/bin/env python3
"""Generate gruvbox-ackley.png — a contour map of the Ackley function (a classic
global-optimization test function) for the gruvbox-ish kitty theme. Ackley has a
deep central funnel (global min at origin) surrounded by a lattice of local
minima, so its contours read as concentric rings + a faint ripple grid.

Readability is baked into the IMAGE (not kitty's background_tint, which does
nothing in this setup): a dark base, thin (1px) sparse light contour lines, and
a strong vignette — so terminal text stays legible with kitty background_tint 0.
Re-tune N_LEVELS / LINE_ALPHA / BASE / R and re-run:

    python3 make-gruvbox-ackley.py
"""

import numpy as np
from PIL import Image, ImageFilter

W, H = 2560, 1440
N_LEVELS = 12        # contour bands (more = denser contours)
LINE_ALPHA = 0.9     # line opacity over the dark base (higher = lines more visible)
BLUR = 3.5           # gaussian blur radius — softens contours into a glow
R = 6.0              # y half-range in function units; x scaled for undistorted aspect

BASE = np.array([18, 20, 23], np.float32)     # very dark, darker than the theme bg
LINE_LO = np.array([135, 175, 135], np.float32)   # #87af87 light aqua (funnel center)
LINE_HI = np.array([213, 196, 161], np.float32)   # #d5c4a1 light cream (outer plateau)

# Ackley over an undistorted grid filling 16:9
ar = R * W / H
X, Y = np.meshgrid(
    np.linspace(-ar, ar, W).astype(np.float32),
    np.linspace(-R, R, H).astype(np.float32),
)
Z = (
    -20.0 * np.exp(-0.2 * np.sqrt(0.5 * (X * X + Y * Y)))
    - np.exp(0.5 * (np.cos(2 * np.pi * X) + np.cos(2 * np.pi * Y)))
    + np.e + 20.0
).astype(np.float32)
field = (Z - Z.min()) / (Z.max() - Z.min())

# quantise into bands, draw band-boundary iso-contours (thickened for visibility)
levels = np.floor(field * N_LEVELS)
edges = (levels != np.roll(levels, 1, axis=0)) | (levels != np.roll(levels, 1, axis=1))
edges = np.asarray(
    Image.fromarray((edges * 255).astype(np.uint8)).filter(ImageFilter.MaxFilter(3))
) > 127

t = field[..., None]
line = LINE_LO * (1 - t) + LINE_HI * t
out = np.empty((H, W, 3), np.float32)
out[:] = BASE
out = np.where(edges[..., None], BASE * (1 - LINE_ALPHA) + line * LINE_ALPHA, out)

# strong vignette so edges fall off dark
yy, xx = np.mgrid[0:H, 0:W]
nx, ny = (xx / W - 0.5), (yy / H - 0.5)
dist = np.sqrt(nx * nx + ny * ny) / 0.7071
vig = np.clip(1.0 - 0.85 * dist * dist, 0.4, 1.0)[..., None]
out *= vig

out = np.clip(out, 0, 255).astype(np.uint8)
img = Image.fromarray(out, "RGB").filter(ImageFilter.GaussianBlur(BLUR))
path = __file__.rsplit("/", 1)[0] + "/gruvbox-ackley.png"
img.save(path)
print("wrote", path, (W, H))
