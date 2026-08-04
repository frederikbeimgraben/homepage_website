#!/usr/bin/env bash
# Make the Open Graph preview card in static/brand/ from the site logo.
#
# A shared link shows this picture. Open Graph asks for 1200x630. The card puts
# the wordmark from static/brand/beimgraben-logo.svg on the brand background,
# so it follows any change to the logo.
#
# Run this again after you change the logo. The output is committed, so a
# normal build needs neither python nor resvg.
set -euo pipefail
cd "$(dirname "$0")/.."

readonly LOGO="static/brand/beimgraben-logo.svg"
readonly SVG="static/brand/og-card.svg"
readonly PNG="static/brand/og-card.png"
readonly WIDTH=1200
readonly HEIGHT=630

python3 - "$LOGO" "$SVG" "$WIDTH" "$HEIGHT" <<'PY'
import re
import sys

logo_path, out_path, width, height = sys.argv[1], sys.argv[2], int(sys.argv[3]), int(sys.argv[4])

with open(logo_path) as handle:
    source = handle.read()

# Keep the wordmark groups: drop the <svg> tag and the logo's own background.
inner = source.split("/>", 1)[1].split("</svg>")[0]
inner = re.sub(r"^\s*<rect[^>]*/>", "", inner).strip()

# The logo canvas is 1600x320. Put it on the card at 1000 px wide, centred.
logo_width, logo_height, target = 1600, 320, 1000
scale = target / logo_width
x = (width - target) / 2
y = (height - logo_height * scale) / 2

with open(out_path, "w") as handle:
    handle.write(
        f'<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" '
        f'viewBox="0 0 {width} {height}">'
        f'<rect width="{width}" height="{height}" fill="#1e1839"/>'
        f'<g transform="translate({x:g} {y:g}) scale({scale:g})">{inner}</g>'
        "</svg>\n"
    )
PY

nix shell nixpkgs#resvg --command resvg --width "$WIDTH" --height "$HEIGHT" "$SVG" "$PNG"

printf "  %s  %.1f KB  %dx%d\n" "$PNG" "$(echo "$(stat -c%s "$PNG")/1024" | bc -l)" "$WIDTH" "$HEIGHT"
