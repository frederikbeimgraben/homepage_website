#!/usr/bin/env bash
# Make the web fonts in static/fonts/ from the originals in fonts-src/.
#
# JetBrains Mono carries Cyrillic, Greek, box drawing and much more that this
# site never shows. The subset keeps about 38 % of the bytes.
#
# Run this again after you replace a file in fonts-src/. The output is
# committed, so a normal build and deploy needs neither python nor fonttools.
set -euo pipefail
cd "$(dirname "$0")/.."

# Latin, Latin-1 (German umlauts, ß), Latin Extended-A (European names),
# General Punctuation (– — ' " …), Arrows (Congo's ↑ and ↓), €, ™.
readonly UNICODES="U+0020-007E,U+00A0-00FF,U+0100-017F,U+2000-206F,U+2190-21FF,U+20AC,U+2122"

mkdir -p static/fonts

nix shell --impure --expr \
  'with import <nixpkgs> {}; python3.withPackages (ps: with ps; [ fonttools brotli ])' \
  --command bash -euc '
    total_before=0
    total_after=0
    for src in fonts-src/*.woff2; do
      name="$(basename "$src")"
      out="static/fonts/$name"
      pyftsubset "$src" \
        --flavor=woff2 \
        --unicodes="'"$UNICODES"'" \
        --layout-features="*" \
        --output-file="$out"
      before=$(stat -c%s "$src")
      after=$(stat -c%s "$out")
      total_before=$((total_before + before))
      total_after=$((total_after + after))
      printf "  %-38s %6.1f -> %5.1f KB\n" "$name" \
        "$(echo "$before/1024" | bc -l)" "$(echo "$after/1024" | bc -l)"
    done
    printf "\n  total %.1f KB -> %.1f KB (-%.0f%%)\n" \
      "$(echo "$total_before/1024" | bc -l)" \
      "$(echo "$total_after/1024" | bc -l)" \
      "$(echo "100-100*$total_after/$total_before" | bc -l)"
  '
