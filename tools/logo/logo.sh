#!/bin/bash

set -euo pipefail

LOGO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGE_ROOT="$(cd "$LOGO_DIR/../.." && pwd)"
TEXT_SVG="$LOGO_DIR/logo-text.svg"
OUTPUT_PNG="$PACKAGE_ROOT/man/figures/logo.png"
WORK_DIR="$(mktemp -d)"
trap 'rm -rf "$WORK_DIR"' EXIT

has_executable() {
    [[ -x "$1" ]] || command -v "$1" >/dev/null 2>&1
}

resolve_bin() {
    local current="$1"
    local invalid_override_message="$2"
    local autodetect_failure_message="$3"
    shift 3

    if [[ -n "$current" ]]; then
        if has_executable "$current"; then
            printf '%s\n' "$current"
            return 0
        fi

        echo "$invalid_override_message" >&2
        return 1
    fi

    local candidate
    for candidate in "$@"; do
        if [[ -n "$candidate" ]] && has_executable "$candidate"; then
            printf '%s\n' "$candidate"
            return 0
        fi
    done

    echo "$autodetect_failure_message" >&2
    return 1
}

chrome_candidates=(
    "/c/Program Files/Google/Chrome/Application/chrome.exe"
    "/c/Program Files (x86)/Google/Chrome/Application/chrome.exe"
    "${LOCALAPPDATA:-}/Google/Chrome/Application/chrome.exe"
    "/usr/bin/google-chrome"
    "/usr/bin/chromium"
    "/usr/bin/chromium-browser"
)

if [[ "$OSTYPE" == "darwin"* ]]; then
    chrome_candidates=(
        "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
        "${chrome_candidates[@]}"
    )
fi

CHROME_BIN="$(resolve_bin "${CHROME_BIN:-}" \
    "Set CHROME_BIN to a valid Chrome executable path." \
    "Failed to auto-detect Chrome; set CHROME_BIN to a valid Chrome executable path." \
    "${chrome_candidates[@]}")" || exit 1

PYTHON_BIN="$(resolve_bin "${PYTHON_BIN:-}" \
    "Set PYTHON_BIN to a valid Python executable path." \
    "Failed to auto-detect Python; set PYTHON_BIN to a valid Python executable path." \
    python3 \
    python)" || exit 1

# Draw at 4x the final 553 x 640 resolution for smooth edges
FINAL_WIDTH=553
FINAL_HEIGHT=640
SCALE=4
CANVAS="$((FINAL_WIDTH * SCALE))x$((FINAL_HEIGHT * SCALE))"
TEAL="#00857C"
CHARCOAL="#424242"
HEXAGON="276.5,13 541.5,166 541.5,474 276.5,627 11.5,474 11.5,166"
TRAPEZOID="0,169.5 553,240 553,400 0,470.5"
DRAW_SCALE="scale $SCALE,$SCALE"

# Charcoal background with a teal border
magick -size "$CANVAS" xc:none \
    -fill "$CHARCOAL" -stroke "$TEAL" -strokewidth 22 \
    -draw "$DRAW_SCALE polygon $HEXAGON" "$WORK_DIR/background.png"

# Offset a soft shadow downward: faint above, broader and darker below
magick -size "$CANVAS" xc:black -fill white \
    -draw "$DRAW_SCALE polygon $TRAPEZOID" -blur 0x32 -roll +0+40 \
    -evaluate multiply 0.55 \
    -alpha copy -channel RGB -evaluate set 0 +channel "$WORK_DIR/shadow.png"

# Add the shadow and teal trapezoid, keeping both inside the hexagon
magick -size "$CANVAS" xc:none -fill "$TEAL" \
    -draw "$DRAW_SCALE polygon $TRAPEZOID" "$WORK_DIR/trapezoid.png"
magick "$WORK_DIR/background.png" "$WORK_DIR/shadow.png" \
    -compose SrcAtop -composite "$WORK_DIR/trapezoid.png" \
    -compose SrcAtop -composite -resize "${FINAL_WIDTH}x${FINAL_HEIGHT}!" "$WORK_DIR/background.png"

# Render the wordmark through a minimal HTML wrapper, then crop the PDF
cp "$TEXT_SVG" "$WORK_DIR/logo-text.svg"
cat >"$WORK_DIR/logo-text.html" <<'EOF'
<!DOCTYPE html>
<html>
  <body style="margin: 0">
    <img src="logo-text.svg" alt="" style="display: block; width: 600px; height: 200px;">
  </body>
</html>
EOF
TEXT_HTML_URL="$("$PYTHON_BIN" -c 'from pathlib import Path; import sys; print(Path(sys.argv[1]).resolve().as_uri())' "$WORK_DIR/logo-text.html")"
if ! (
    cd "$WORK_DIR"
    "$CHROME_BIN" --headless \
        --allow-file-access-from-files \
        --disable-gpu \
        --no-pdf-header-footer \
        --print-to-pdf="$WORK_DIR/text.pdf" \
        "$TEXT_HTML_URL"
); then
    echo "Failed to render wordmark with Chrome." >&2
    exit 1
fi

if ! pdfcrop --quiet "$WORK_DIR/text.pdf" "$WORK_DIR/text-cropped.pdf"; then
    echo "Failed to crop wordmark PDF with pdfcrop." >&2
    exit 1
fi

# Convert black ink into white lettering with transparent antialiased edges
if ! magick -density 600 "$WORK_DIR/text-cropped.pdf" \
    -background white -alpha remove -alpha off -trim +repage \
    -resize 370x -negate -alpha copy \
    -channel RGB -evaluate set 100% +channel "$WORK_DIR/text.png"; then
    echo "Failed to convert cropped wordmark PDF with ImageMagick." >&2
    exit 1
fi

# Center the wordmark on the trapezoid and optimize the PNG
magick "$WORK_DIR/background.png" "$WORK_DIR/text.png" \
    -gravity center -compose Over -composite -strip "$OUTPUT_PNG"
pngquant --force --speed 1 --strip --output "$OUTPUT_PNG" "$OUTPUT_PNG"
