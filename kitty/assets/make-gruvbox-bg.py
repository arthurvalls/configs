#!/usr/bin/env python3
"""Generate gruvbox-blur.png — a soft, dark gradient-mesh wallpaper for the
gruvbox-ish kitty theme. Scatters big blobs of the gruvbox accent hues over the
dark0_hard background, heavily Gaussian-blurs them into an aurora-like mesh, then
darkens the result so terminal text stays readable. Deterministic (fixed seed).
Re-tune SEED / BLUR / BRIGHTNESS / blob count and re-run:

    python3 make-gruvbox-bg.py
"""

import random
from PIL import Image, ImageDraw, ImageFilter, ImageEnhance

W, H = 2560, 1440
BG = (29, 32, 33)          # #1d2021 dark0_hard
BLUR = 320                 # gaussian blur radius (higher = softer mesh)
BRIGHTNESS = 0.5           # <1 darkens the blurred mesh
SEED = 7

# gruvbox-ish accent hues (the blobs)
ACCENTS = [
    (215, 95, 95),    # red    #d75f5f
    (139, 149, 83),   # green  #8b9553
    (214, 150, 23),   # yellow #d69617
    (69, 133, 136),   # blue   #458588
    (211, 134, 155),  # purple #d3869b
    (104, 157, 106),  # aqua   #689d6a
    (231, 138, 78),   # orange #e78a4e
]

random.seed(SEED)
img = Image.new("RGB", (W, H), BG)
draw = ImageDraw.Draw(img)

# two passes of blobs for a layered mesh
for _ in range(14):
    cx, cy = random.randint(0, W), random.randint(0, H)
    rad = random.randint(380, 720)
    color = random.choice(ACCENTS)
    draw.ellipse([cx - rad, cy - rad, cx + rad, cy + rad], fill=color)

img = img.filter(ImageFilter.GaussianBlur(BLUR))
img = ImageEnhance.Brightness(img).enhance(BRIGHTNESS)

# gentle vignette so edges fall off darker
vig = Image.new("L", (W, H), 0)
vd = ImageDraw.Draw(vig)
vd.ellipse([-W * 0.15, -H * 0.15, W * 1.15, H * 1.15], fill=255)
vig = vig.filter(ImageFilter.GaussianBlur(300))
dark = ImageEnhance.Brightness(img).enhance(0.6)
img = Image.composite(img, dark, vig)

out = __file__.rsplit("/", 1)[0] + "/gruvbox-blur.png"
img.save(out)
print("wrote", out, img.size)
