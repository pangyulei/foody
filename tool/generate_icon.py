"""Generate the Foody launcher icon: a tomato on a pure white background.

Run from the project root:
    python tool/generate_icon.py
"""

from __future__ import annotations

import math
import os

from PIL import Image, ImageChops, ImageDraw, ImageFilter

SIZE = 4096
OUT_SIZE = 1024
OUT_DIR = os.path.join("assets", "icon")

WHITE = (255, 255, 255)
TOMATO = (220, 38, 38)
TOMATO_LIGHT = (248, 113, 113)
TOMATO_DARK = (153, 27, 27)
TOMATO_HIGHLIGHT = (255, 228, 220)
LEAF_LIGHT = (74, 222, 128)
LEAF_MID = (22, 163, 74)
LEAF_DARK = (21, 128, 61)
STEM = (20, 83, 45)


def _rotate(point, angle_deg: float, origin):
    x, y = point
    ox, oy = origin
    rad = math.radians(angle_deg)
    cos_a, sin_a = math.cos(rad), math.sin(rad)
    dx, dy = x - ox, y - oy
    return (
        ox + dx * cos_a - dy * sin_a,
        oy + dx * sin_a + dy * cos_a,
    )


def _leaf_polygon(base, length, width, angle, steps=110):
    bx, by = base
    left = []
    right = []
    for i in range(steps + 1):
        t = i / steps
        half = width * (math.sin(math.pi * t) ** 0.82) * (1 - 0.12 * t)
        y = -length * t
        left.append((bx - half, by + y))
        right.append((bx + half, by + y))
    points = left + list(reversed(right))
    return [_rotate(p, angle, base) for p in points]


def _gradient_rect(size, top_color, bottom_color):
    gradient = Image.new("RGBA", (1, size[1]))
    for y in range(size[1]):
        t = y / max(1, size[1] - 1)
        color = tuple(
            int(top_color[i] + (bottom_color[i] - top_color[i]) * t) for i in range(3)
        ) + (255,)
        gradient.putpixel((0, y), color)
    return gradient.resize(size, Image.Resampling.BILINEAR)


def draw_sepal(
    layer: Image.Image,
    base,
    length,
    width,
    angle,
    color_top,
    color_bottom,
    veins: bool = False,
):
    polygon = _leaf_polygon(base, length, width, angle)
    mask = Image.new("L", layer.size, 0)
    ImageDraw.Draw(mask).polygon(polygon, fill=255)

    leaf = Image.new("RGBA", layer.size, (0, 0, 0, 0))
    gradient = _gradient_rect(layer.size, color_top, color_bottom)
    leaf.paste(gradient, (0, 0), mask)

    if veins:
        draw = ImageDraw.Draw(leaf)
        tip = _rotate((base[0], base[1] - length), angle, base)
        base_pt = _rotate(base, angle, base)
        draw.line([base_pt, tip], fill=(209, 250, 229, 170), width=12)
        for t in (0.28, 0.5, 0.72):
            half = width * (math.sin(math.pi * t) ** 0.82) * (1 - 0.12 * t)
            center = _rotate((base[0], base[1] - length * t), angle, base)
            edge = _rotate(
                (base[0] + half * 0.72, base[1] - length * (t + 0.06)),
                angle,
                base,
            )
            edge_l = _rotate(
                (base[0] - half * 0.72, base[1] - length * (t + 0.06)),
                angle,
                base,
            )
            draw.line([center, edge], fill=(209, 250, 229, 120), width=7)
            draw.line([center, edge_l], fill=(209, 250, 229, 120), width=7)

    layer.alpha_composite(leaf)


def make_background() -> Image.Image:
    return Image.new("RGB", (SIZE, SIZE), WHITE)


def make_foreground(scale: float = 1.0) -> Image.Image:
    layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    cx, cy = SIZE / 2, SIZE * 0.55
    body_w, body_h = 2660, 2460

    # Soft shadow under the tomato.
    shadow = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    sd = ImageDraw.Draw(shadow)
    sd.ellipse(
        (
            cx - body_w * 0.38,
            cy + body_h * 0.30,
            cx + body_w * 0.38,
            cy + body_h * 0.56,
        ),
        fill=(0, 0, 0, 34),
    )
    layer.alpha_composite(shadow.filter(ImageFilter.GaussianBlur(90)))

    # Tomato silhouette: a slightly lobed, flattened round shape.
    body_mask = Image.new("L", (SIZE, SIZE), 0)
    md = ImageDraw.Draw(body_mask)
    md.ellipse(
        (
            cx - body_w / 2,
            cy - body_h / 2,
            cx + body_w / 2,
            cy + body_h / 2,
        ),
        fill=255,
    )
    md.ellipse(
        (
            cx - body_w * 0.52,
            cy - body_h * 0.40,
            cx + body_w * 0.12,
            cy + body_h * 0.46,
        ),
        fill=255,
    )
    md.ellipse(
        (
            cx - body_w * 0.12,
            cy - body_h * 0.40,
            cx + body_w * 0.52,
            cy + body_h * 0.46,
        ),
        fill=255,
    )

    body = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    bd = ImageDraw.Draw(body)
    bd.ellipse(
        (
            cx - body_w * 0.56,
            cy - body_h * 0.56,
            cx + body_w * 0.56,
            cy + body_h * 0.56,
        ),
        fill=TOMATO + (255,),
    )

    # Light from the upper-left.
    light = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    ld = ImageDraw.Draw(light)
    ld.ellipse(
        (
            cx - body_w * 0.55,
            cy - body_h * 0.58,
            cx + body_w * 0.05,
            cy + body_h * 0.02,
        ),
        fill=TOMATO_LIGHT + (85,),
    )
    body.alpha_composite(light.filter(ImageFilter.GaussianBlur(320)))

    # Darker lower-right shading.
    dark = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    dd = ImageDraw.Draw(dark)
    dd.ellipse(
        (
            cx - body_w * 0.10,
            cy + body_h * 0.02,
            cx + body_w * 0.66,
            cy + body_h * 0.70,
        ),
        fill=TOMATO_DARK + (170,),
    )
    body.alpha_composite(dark.filter(ImageFilter.GaussianBlur(240)))

    # Specular highlight.
    spec = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    spd = ImageDraw.Draw(spec)
    spd.ellipse(
        (
            cx - body_w * 0.32,
            cy - body_h * 0.43,
            cx - body_w * 0.12,
            cy - body_h * 0.24,
        ),
        fill=TOMATO_HIGHLIGHT + (125,),
    )
    body.alpha_composite(spec.filter(ImageFilter.GaussianBlur(48)))

    # Clip the shading to the tomato silhouette.
    r, g, b, a = body.split()
    a = ImageChops.multiply(a, body_mask)
    body = Image.merge("RGBA", (r, g, b, a))
    layer.alpha_composite(body)

    # Stem.
    stem = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    stem_draw = ImageDraw.Draw(stem)
    stem_top = (cx, cy - body_h * 0.63)
    stem_bottom = (cx, cy - body_h * 0.30)
    stem_draw.line([stem_top, stem_bottom], fill=STEM + (255,), width=86)
    stem_draw.ellipse(
        (
            stem_top[0] - 43,
            stem_top[1] - 43,
            stem_top[0] + 43,
            stem_top[1] + 43,
        ),
        fill=STEM + (255,),
    )
    layer.alpha_composite(stem)

    # Calyx: five green sepals radiating from the stem base.
    calyx_base = (cx, cy - body_h * 0.31)
    sepals = [
        (-104, 610, 220),
        (-55, 700, 235),
        (0, 650, 225),
        (55, 700, 235),
        (104, 610, 220),
    ]
    for angle, length, width in sepals:
        draw_sepal(
            layer,
            base=calyx_base,
            length=length,
            width=width,
            angle=angle,
            color_top=LEAF_LIGHT,
            color_bottom=LEAF_DARK,
        )

    # Small leaf-star center.
    center = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    cd = ImageDraw.Draw(center)
    cd.ellipse(
        (
            calyx_base[0] - 72,
            calyx_base[1] - 66,
            calyx_base[0] + 72,
            calyx_base[1] + 78,
        ),
        fill=STEM + (255,),
    )
    layer.alpha_composite(center.filter(ImageFilter.GaussianBlur(1)))

    if scale != 1.0:
        scaled = layer.resize(
            (int(SIZE * scale), int(SIZE * scale)),
            Image.Resampling.LANCZOS,
        )
        layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
        layer.alpha_composite(
            scaled,
            (
                (SIZE - scaled.width) // 2,
                (SIZE - scaled.height) // 2,
            ),
        )
    return layer


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    background = make_background()
    foreground = make_foreground()
    adaptive_foreground = make_foreground(scale=0.9)

    full = Image.alpha_composite(background.convert("RGBA"), foreground)
    full.convert("RGB").resize((OUT_SIZE, OUT_SIZE), Image.Resampling.LANCZOS).save(
        os.path.join(OUT_DIR, "app_icon.png")
    )
    background.resize((OUT_SIZE, OUT_SIZE), Image.Resampling.LANCZOS).save(
        os.path.join(OUT_DIR, "app_icon_background.png")
    )
    adaptive_foreground.resize((OUT_SIZE, OUT_SIZE), Image.Resampling.LANCZOS).save(
        os.path.join(OUT_DIR, "app_icon_foreground.png")
    )

    full.convert("RGB").resize((OUT_SIZE, OUT_SIZE), Image.Resampling.LANCZOS).save(
        os.path.join(OUT_DIR, "app_icon_preview.png")
    )

    print("Wrote icon assets to", OUT_DIR)


if __name__ == "__main__":
    main()
