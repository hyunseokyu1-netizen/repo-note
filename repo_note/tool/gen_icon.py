"""RepoNote 앱 아이콘 생성 스크립트.

보라색 그라데이션 배경 + 모서리가 접힌 흰 노트 카드 + Markdown 'M↓' 모티브.
출력: assets/icon/icon.png (기본), icon_fg.png (adaptive foreground),
      icon_bg.png (adaptive background)
"""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

SIZE = 1024
PURPLE_TOP = (124, 103, 196)  # #7C67C4
PURPLE_BOTTOM = (79, 61, 139)  # #4F3D8B
ACCENT = (103, 80, 164)  # #6750A4 (Material seed)
FOLD = (217, 208, 240)  # #D9D0F0
LINE_GRAY = (203, 196, 222)

OUT_DIR = Path(__file__).resolve().parent.parent / "assets" / "icon"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def gradient_bg() -> Image.Image:
    img = Image.new("RGB", (SIZE, SIZE))
    d = ImageDraw.Draw(img)
    for y in range(SIZE):
        t = y / (SIZE - 1)
        color = tuple(
            round(a + (b - a) * t) for a, b in zip(PURPLE_TOP, PURPLE_BOTTOM)
        )
        d.line([(0, y), (SIZE, y)], fill=color)
    return img


def load_font(size: int) -> ImageFont.FreeTypeFont | None:
    candidates = [
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/System/Library/Fonts/Supplemental/Verdana Bold.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/System/Library/Fonts/SFNS.ttf",
    ]
    for path in candidates:
        try:
            return ImageFont.truetype(path, size)
        except OSError:
            continue
    return None


def note_card(scale: float = 1.0) -> Image.Image:
    """투명 배경 위에 접힌 노트 카드를 그린 RGBA 레이어."""
    layer = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)

    w, h = 470 * scale, 580 * scale
    x0, y0 = (SIZE - w) / 2, (SIZE - h) / 2
    x1, y1 = x0 + w, y0 + h
    radius = 52 * scale
    fold = 132 * scale

    # 카드 본체
    d.rounded_rectangle([x0, y0, x1, y1], radius=radius, fill=(255, 255, 255, 255))
    # 오른쪽 위 모서리를 투명하게 잘라내기 (ImageDraw는 픽셀을 그대로 대체함)
    d.polygon(
        [(x1 - fold, y0 - 1), (x1 + 1, y0 - 1), (x1 + 1, y0 + fold)],
        fill=(0, 0, 0, 0),
    )
    # 접힌 플랩
    d.polygon(
        [(x1 - fold, y0), (x1, y0 + fold), (x1 - fold, y0 + fold)],
        fill=FOLD + (255,),
    )

    # Markdown 'M↓' 모티브
    font = load_font(int(300 * scale))
    cx = (x0 + x1) / 2
    if font is not None:
        m_cx = cx - 60 * scale
        m_cy = y0 + h * 0.44
        d.text((m_cx, m_cy), "M", font=font, fill=ACCENT + (255,), anchor="mm")
        # 아래 화살표
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

    # 하단 텍스트 라인 두 줄
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
    bg = gradient_bg()

    # 기본 아이콘 (legacy Android / iOS)
    icon = bg.copy()
    icon.paste(note_card(1.0), (0, 0), note_card(1.0))
    icon.save(OUT_DIR / "icon.png")

    # Adaptive foreground: 안전 영역(중앙 66%)에 맞게 축소
    fg = note_card(0.72)
    fg.save(OUT_DIR / "icon_fg.png")

    # Adaptive background
    bg.save(OUT_DIR / "icon_bg.png")
    print("generated:", sorted(p.name for p in OUT_DIR.iterdir()))


if __name__ == "__main__":
    main()
