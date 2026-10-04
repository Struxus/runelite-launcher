"""Package the unchanged Augment artwork at native launcher icon sizes.
Requires Pillow; run from any directory. No generated artwork or recolouring.
"""
from pathlib import Path
from PIL import Image, ImageDraw
import shutil, subprocess, tempfile
ROOT = Path(__file__).resolve().parents[1]
source = Image.open(ROOT/'branding/augment-master.png').convert('RGBA')
SIZES = [16, 20, 24, 32, 40, 48, 64, 96, 128, 256]
def icon(size):
    canvas = Image.new('RGBA', (size,size))
    edge = max(1, round(size * .03))
    art = source.resize((size-2*edge,size-2*edge), Image.Resampling.LANCZOS)
    canvas.alpha_composite(art,(edge,edge))
    return canvas
resources = ROOT/'src/main/resources/net/runelite/launcher'
for size in SIZES: icon(size).save(resources/f'runelite_{size}.png')
for size,suffix in [(200,''),(400,'@2x'),(600,'@3x')]:
    icon(size).save(resources/f'runelite_splash{suffix}.png')
icon(256).save(ROOT/'innosetup/runelite.ico', sizes=[(s,s) for s in SIZES], append_images=[icon(s) for s in SIZES if s != 256])
shutil.copyfile(ROOT/'innosetup/runelite.ico', ROOT/'native/src/win32/runelite.ico')
for size in [55,64,83,110,128,166]:
    frame = Image.new('RGB',(size,size),'white')
    frame.paste(icon(size),mask=icon(size).getchannel('A'))
    frame.save(ROOT/f'innosetup/runelite_small_{size}.bmp')
shutil.copyfile(ROOT/'innosetup/runelite_small_128.bmp',ROOT/'innosetup/runelite_small.bmp')
icon(512).save(ROOT/'appimage/runelite.png')
# ICNS includes native Retina representations through 1024px.
icon(1024).save(ROOT/'osx/runelite.icns',format='ICNS')
preview=Image.new('RGB',(780,350),'#15111e');draw=ImageDraw.Draw(preview)
draw.text((24,18),'AUGMENT / LAUNCHER BRANDING',fill='#eee6f7')
x=24
for size in [16,24,32,48,64,128,256]:
    preview.paste(icon(size),(x,70+(256-size)//2),icon(size))
    draw.text((x,330),f'{size}px',fill='#d4c5e8');x+=size+18
preview.save(ROOT/'branding/preview.png')
print('Generated Windows ICO, DPI-aware installer BMPs, Java PNGs, macOS ICNS and Linux PNG.')
