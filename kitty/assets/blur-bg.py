#!/usr/bin/env python3
"""Bake a kitty background image: crop-to-fill 2560x1440, Gaussian-blur, darken.

Usage:
    blur-bg.py [SOURCE_IMAGE] [OUTPUT_PNG]

If SOURCE_IMAGE is omitted or cannot be opened, a procedural neon "cyberpunk"
gradient is generated instead, so this always produces a usable output. Tuning
knobs are the constants below. Requires only Pillow (no ImageMagick).
"""
import sys
import random

from PIL import Image, ImageFilter, ImageEnhance, ImageDraw

WIDTH, HEIGHT = 2560, 1440
BLUR_RADIUS = 14
BRIGHTNESS = 0.70  # <1 darkens so terminal text stays readable
DEFAULT_OUT = f"{__import__('os').path.expanduser('~')}/.config/kitty/assets/cyberpunk-blur.png"

# tokyonight-night accents, for the procedural fallback
NEON = [(122, 162, 247), (187, 154, 247), (125, 207, 255), (247, 118, 142)]
BASE = (10, 10, 22)


def cover_crop(im):
    """Scale to fill WIDTHxHEIGHT then center-crop (CSS background-size: cover)."""
    im = im.convert("RGB")
    sw, sh = im.size
    scale = max(WIDTH / sw, HEIGHT / sh)
    new = (max(1, round(sw * scale)), max(1, round(sh * scale)))
    im = im.resize(new, Image.Resampling.LANCZOS)
    left = (im.width - WIDTH) // 2
    top = (im.height - HEIGHT) // 2
    return im.crop((left, top, left + WIDTH, top + HEIGHT))


def generate_procedural():
    """Dark base with blurred neon vertical light streaks -> cyberpunk bokeh."""
    rng = random.Random(1989)  # fixed seed => reproducible
    im = Image.new("RGB", (WIDTH, HEIGHT), BASE)  # type: ignore[arg-type]
    # vertical gradient: slightly lighter toward the bottom (city glow)
    top_c, bot_c = (8, 8, 18), (22, 18, 38)
    for y in range(HEIGHT):
        t = y / HEIGHT
        row = tuple(round(top_c[i] + (bot_c[i] - top_c[i]) * t) for i in range(3))
        ImageDraw.Draw(im).line([(0, y), (WIDTH, y)], fill=row)
    draw = ImageDraw.Draw(im, "RGBA")
    for _ in range(70):
        x = rng.randint(0, WIDTH)
        w = rng.randint(4, 26)
        h = rng.randint(120, HEIGHT)
        y = rng.randint(0, HEIGHT - 60)
        r, g, b = rng.choice(NEON)
        draw.rectangle([x, y, x + w, y + h], fill=(r, g, b, rng.randint(60, 150)))
    # soft round "signage" glows
    for _ in range(40):
        x, y = rng.randint(0, WIDTH), rng.randint(0, HEIGHT)
        rad = rng.randint(8, 40)
        r, g, b = rng.choice(NEON)
        draw.ellipse([x - rad, y - rad, x + rad, y + rad], fill=(r, g, b, rng.randint(40, 110)))
    return im.filter(ImageFilter.GaussianBlur(28))


def main():
    src = sys.argv[1] if len(sys.argv) > 1 else None
    out = sys.argv[2] if len(sys.argv) > 2 else DEFAULT_OUT
    im = None
    if src:
        try:
            im = cover_crop(Image.open(src))
        except Exception as exc:  # noqa: BLE001 - any failure -> procedural
            print(f"source unusable ({exc}); generating procedurally", file=sys.stderr)
    if im is None:
        im = generate_procedural()
    im = im.filter(ImageFilter.GaussianBlur(BLUR_RADIUS))
    im = ImageEnhance.Brightness(im).enhance(BRIGHTNESS)
    im.save(out, "PNG")
    print(f"WROTE {out} ({im.width}x{im.height})")


if __name__ == "__main__":
    main()
