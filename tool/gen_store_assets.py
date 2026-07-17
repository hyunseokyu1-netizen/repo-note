"""Play Store 등록용 그래픽 자산 생성.

- store_icon_512.png : 스토어 아이콘 (512x512, 알파 없음)
- feature_graphic_1024x500.png : 그래픽 이미지 (1024x500)

실행: python3 tool/gen_store_assets.py <출력 폴더>
"""

import sys
from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

PURPLE_TOP = (124, 103, 196)
PURPLE_BOTTOM = (79, 61, 139)
ACCENT = (103, 80, 164)
FOLD = (217, 208, 240)
LINE_GRAY = (203, 196, 222)

ICON_SRC = Path(__file__).resolve().parent.parent / "assets" / "icon" / "icon.png"


def gradient(width: int, height: int) -> Image.Image:
    img = Image.new("RGB", (width, height))
    d = ImageDraw.Draw(img)
    for y in range(height):
        t = y / (height - 1)
        color = tuple(
            round(a + (b - a) * t) for a, b in zip(PURPLE_TOP, PURPLE_BOTTOM)
        )
        d.line([(0, y), (width, y)], fill=color)
    return img


def load_font(size: int, bold: bool = True) -> ImageFont.FreeTypeFont:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf" if bold else "/System/Library/Fonts/Supplemental/Arial.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    raise RuntimeError("사용할 폰트를 찾지 못했습니다")


def note_card(size: int, scale: float) -> Image.Image:
    """gen_icon.py와 같은 노트 카드 모티브 (정사각 캔버스)."""
    layer = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    w, h = 470 * scale, 580 * scale
    x0, y0 = (size - w) / 2, (size - h) / 2
    x1, y1 = x0 + w, y0 + h
    radius = 52 * scale
    fold = 132 * scale

    d.rounded_rectangle([x0, y0, x1, y1], radius=radius, fill=(255, 255, 255, 255))
    d.polygon(
        [(x1 - fold, y0 - 1), (x1 + 1, y0 - 1), (x1 + 1, y0 + fold)],
        fill=(0, 0, 0, 0),
    )
    d.polygon(
        [(x1 - fold, y0), (x1, y0 + fold), (x1 - fold, y0 + fold)],
        fill=FOLD + (255,),
    )

    font = load_font(int(300 * scale))
    cx = (x0 + x1) / 2
    m_cx = cx - 60 * scale
    m_cy = y0 + h * 0.44
    d.text((m_cx, m_cy), "M", font=font, fill=ACCENT + (255,), anchor="mm")
    ax = cx + 130 * scale
    top = m_cy - 90 * scale
    bottom = m_cy + 88 * scale
    shaft = 34 * scale
    head = 66 * scale
    d.rectangle(
        [ax - shaft / 2, top, ax + shaft / 2, bottom - head * 0.55],
        fill=ACCENT + (255,),
    )
    d.polygon(
        [
            (ax - head, bottom - head),
            (ax + head, bottom - head),
            (ax, bottom + 6 * scale),
        ],
        fill=ACCENT + (255,),
    )

    line_x0 = x0 + 70 * scale
    line_h = 30 * scale
    y_line = y1 - 150 * scale
    d.rounded_rectangle(
        [line_x0, y_line, x1 - 70 * scale, y_line + line_h],
        radius=line_h / 2,
        fill=LINE_GRAY + (255,),
    )
    y_line += 62 * scale
    d.rounded_rectangle(
        [line_x0, y_line, x1 - 190 * scale, y_line + line_h],
        radius=line_h / 2,
        fill=LINE_GRAY + (255,),
    )
    return layer


def main() -> None:
    out_dir = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(".")
    out_dir.mkdir(parents=True, exist_ok=True)

    # 1) 스토어 아이콘 512x512 (알파 채널 제거)
    icon = Image.open(ICON_SRC).convert("RGB").resize((512, 512), Image.LANCZOS)
    icon.save(out_dir / "store_icon_512.png")

    # 2) 그래픽 이미지 1024x500
    fg = gradient(1024, 500)
    # 왼쪽에 노트 카드
    card = note_card(1024, 0.62)
    card_crop = card.crop((150, 190, 874, 834))  # 카드 주변 여백 절사
    card_small = card_crop.resize(
        (int(card_crop.width * 0.62), int(card_crop.height * 0.62)), Image.LANCZOS
    )
    fg.paste(card_small, (72, (500 - card_small.height) // 2), card_small)

    # 오른쪽에 텍스트
    d = ImageDraw.Draw(fg)
    title_font = load_font(88)
    sub_font = load_font(34, bold=False)
    tx = 560
    d.text((tx, 195), "RepoNote", font=title_font, fill=(255, 255, 255), anchor="lm")
    d.text(
        (tx, 278),
        "GitHub Markdown Notes",
        font=sub_font,
        fill=(224, 218, 245),
        anchor="lm",
    )
    d.text(
        (tx, 326),
        "Write. It commits itself.",
        font=sub_font,
        fill=(200, 191, 235),
        anchor="lm",
    )
    fg.save(out_dir / "feature_graphic_1024x500.png")
    print("generated:", sorted(p.name for p in out_dir.iterdir()))


if __name__ == "__main__":
    main()
