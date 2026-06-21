#!/usr/bin/env python3
"""Generate yorha-scanlines.png — a tiny tile of faint horizontal scanlines for
the YoRHa (NieR:Automata) kitty theme. kitty draws it with
`background_image_layout tiled`, so the 1px bone line repeats every PERIOD
device-pixels over an otherwise transparent background (the desktop shows
through via `background_opacity`). Tune PERIOD / ALPHA / LINE_RGB and re-run:

    python3 make-scanlines.py
"""

from PIL import Image

WIDTH = 64          # tile width (purely cosmetic; line spans full width)
PERIOD = 4          # vertical gap between scanlines, in device pixels
ALPHA = 22          # line opacity 0-255 (higher = more visible scanlines)
LINE_RGB = (205, 200, 174)  # bone / khaki — matches theme foreground #cdc8ae

img = Image.new("RGBA", (WIDTH, PERIOD), (0, 0, 0, 0))
for x in range(WIDTH):
    img.putpixel((x, 0), (*LINE_RGB, ALPHA))

out = __file__.rsplit("/", 1)[0] + "/yorha-scanlines.png"
img.save(out)
print("wrote", out, img.size)
