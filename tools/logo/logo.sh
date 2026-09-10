#!/bin/bash

set -euo pipefail

LOGO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$(cd "$LOGO_DIR/../.." && pwd)"
TEXT_SVG="$LOGO_DIR/logo-text.svg"
OUTPUT_PNG="$PACKAGE_ROOT/man/figures/logo.png"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

if [[ "$OSTYPE" == "darwin"* ]]; then
    CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
elif [[ "$OSTYPE" == msys* || "$OSTYPE" == cygwin* || "$OSTYPE" == win32* ]]; then
    CHROME_BIN="/c/Program Files/Google/Chrome/Application/chrome.exe"
else
    CHROME_BIN="/usr/bin/google-chrome"
fi

# Draw at 4x the final 553 x 640 resolution for smooth edges
CANVAS="2212x2560"
TEAL="#00857C"
CHARCOAL="#424242"
HEXAGON="276.5,13 541.5,166 541.5,474 276.5,627 11.5,474 11.5,166"
TRAPEZOID="0,169.5 553,240 553,400 0,470.5"

# Charcoal background with a teal border
magick -size "$CANVAS" xc:none \
    -fill "$CHARCOAL" -stroke "$TEAL" -strokewidth 22 \
    -draw "scale 4,4 polygon $HEXAGON" "$WORK_DIR/background.png"

# Offset a soft shadow downward: faint above, broader and darker below
magick -size "$CANVAS" xc:black -fill white \
    -draw "scale 4,4 polygon $TRAPEZOID" -blur 0x32 -roll +0+40 \
    -evaluate multiply 0.55 \
    -alpha copy -channel RGB -evaluate set 0 +channel "$WORK_DIR/shadow.png"

# Add the shadow and teal trapezoid, keeping both inside the hexagon
magick -size "$CANVAS" xc:none -fill "$TEAL" \
    -draw "scale 4,4 polygon $TRAPEZOID" "$WORK_DIR/trapezoid.png"
magick "$WORK_DIR/background.png" "$WORK_DIR/shadow.png" \
    -compose SrcAtop -composite "$WORK_DIR/trapezoid.png" \
    -compose SrcAtop -composite -resize 553x640! "$WORK_DIR/background.png"

# Render the wordmark using Chrome, then crop the PDF
"$CHROME_BIN" --headless \
    --disable-gpu \
    --no-margins \
    --no-pdf-header-footer \
    --print-to-pdf="$WORK_DIR/text.pdf" \
    "$TEXT_SVG"

pdfcrop --quiet "$WORK_DIR/text.pdf" "$WORK_DIR/text-cropped.pdf"

# Convert black ink into white lettering with transparent antialiased edges
magick -density 600 "$WORK_DIR/text-cropped.pdf" \
    -background white -alpha remove -alpha off -trim +repage \
    -resize 370x -negate -alpha copy \
    -channel RGB -evaluate set 100% +channel "$WORK_DIR/text.png"

# Center the wordmark on the trapezoid and optimize the PNG
magick "$WORK_DIR/background.png" "$WORK_DIR/text.png" \
    -gravity center -compose Over -composite -strip "$OUTPUT_PNG"
pngquant --force --speed 1 --strip --output "$OUTPUT_PNG" "$OUTPUT_PNG"
