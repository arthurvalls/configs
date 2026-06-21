#!/usr/bin/env python3
"""Blur the circuit-schematic wallpaper into a kitty background. It's already
white-on-black linework (matches the monochrome base); just soften + lightly
dim so the neon accent + text read on top. Re-run after tweaking PARAMS:
    python3 make-circuit-bg.py
"""
from PIL import Image, ImageFilter, ImageEnhance, ImageOps

# --- tunables -------------------------------------------------------------
SRC = "921530.jpg"
DST = "circuit-blur.png"
TARGET = (1920, 1080)
BLUR_RADIUS = 4.0       # higher = softer / more abstract
BRIGHTNESS = 0.85       # <1 dims slightly so terminal text stays readable
# -------------------------------------------------------------------------

img = Image.open(SRC).convert("RGB")
if img.size != TARGET:
    img = ImageOps.fit(img, TARGET, Image.LANCZOS)
img = img.filter(ImageFilter.GaussianBlur(BLUR_RADIUS))
img = ImageEnhance.Brightness(img).enhance(BRIGHTNESS)
img.save(DST, "PNG")
print(f"wrote {DST} {img.size} blur={BLUR_RADIUS} brightness={BRIGHTNESS}")
