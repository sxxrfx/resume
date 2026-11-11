#!/bin/sh
# Print index.html to Sagar-Negi-Resume.pdf with a Chromium-based browser and
# fail unless the result is exactly one page. CI runs this on every push, so the
# PDF always matches the page.
#
#   scripts/build-pdf.sh                      # finds Chrome or Chromium
#   BROWSER=/path/to/browser scripts/build-pdf.sh
set -eu

cd "$(dirname "$0")/.."
out="Sagar-Negi-Resume.pdf"

if [ -z "${BROWSER:-}" ]; then
  for candidate in google-chrome google-chrome-stable chromium chromium-browser \
    "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
    "/Applications/Chromium.app/Contents/MacOS/Chromium" \
    "/Applications/Helium.app/Contents/MacOS/Helium"; do
    if command -v "$candidate" >/dev/null 2>&1; then
      BROWSER="$candidate"
      break
    fi
  done
fi
if [ -z "${BROWSER:-}" ]; then
  echo "No Chromium-based browser found. Set BROWSER to one." >&2
  exit 1
fi

profile="$(mktemp -d)"
trap 'rm -rf "$profile"' EXIT

rm -f "$out"
"$BROWSER" --headless --disable-gpu --no-sandbox --user-data-dir="$profile" \
  --no-pdf-header-footer --virtual-time-budget=5000 \
  --print-to-pdf="$PWD/$out" "file://$PWD/index.html" >/dev/null 2>&1

if [ ! -s "$out" ]; then
  echo "The browser did not write $out." >&2
  exit 1
fi

# Chromium writes one uncompressed "/Type /Page" object per page.
pages="$(LC_ALL=C grep -a -c '/Type */Page$' "$out" || true)"
if command -v pdfinfo >/dev/null 2>&1; then
  pages="$(pdfinfo "$out" | awk '/^Pages:/ {print $2}')"
fi
if [ "$pages" != "1" ]; then
  echo "$out has $pages pages; the resume must fit on one A4 page." >&2
  exit 1
fi
echo "Wrote $out (1 page)."
