#!/usr/bin/env python3
"""Turn a black-on-white technical drawing into a dim, blurred, greyscale
terminal background (light linework glowing on near-black).

Source: GE J85-GE-7 jet engine cutaway, public domain (Wikimedia Commons).
Re-run after tweaking the PARAMS below to re-tune the look:
    python3 make-blueprint-bg.py
"""
from PIL import Image, ImageOps, ImageFilter, ImageEnhance

# --- tunables -------------------------------------------------------------
SRC = "blueprint-src.png"
DST = "blueprint-blur.png"
TARGET = (1920, 1080)   # match display; kitty layout=scaled also rescales
BLUR_RADIUS = 5.0       # higher = softer / less distracting
BRIGHTNESS = 0.45       # <1 dims the linework; lower = fainter over text
# -------------------------------------------------------------------------

img = Image.open(SRC).convert("L")        # greyscale
img = ImageOps.invert(img)                 # black-on-white -> white-on-black
img = ImageOps.fit(img, TARGET, Image.LANCZOS)  # cover-crop to display ratio
img = img.filter(ImageFilter.GaussianBlur(BLUR_RADIUS))
img = ImageEnhance.Brightness(img).enhance(BRIGHTNESS)
img.convert("RGB").save(DST, "PNG")
print(f"wrote {DST} {img.size} blur={BLUR_RADIUS} brightness={BRIGHTNESS}")
