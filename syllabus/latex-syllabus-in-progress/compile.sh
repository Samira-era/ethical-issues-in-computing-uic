#!/bin/bash
set -e
DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

# Convert SVG logo to PDF (regenerate if SVG is newer)
if [ ! -f uic-logo.pdf ] || [ CAMP.CIRC.SM.BLK.RGB.SVG -nt uic-logo.pdf ]; then
    rsvg-convert -f pdf CAMP.CIRC.SM.BLK.RGB.SVG -o uic-logo.pdf
fi

mkdir -p generated

# Write compile timestamp
TIMESTAMP=$(date "+%m/%d/%Y at %H:%M")
printf '\\renewcommand{\\compileTimestamp}{%s}\n' "$TIMESTAMP" > generated/compile-timestamp.tex

# Convert markdown content files to LaTeX
for md in content/*.md; do
    name=$(basename "$md" .md)
    pandoc -f markdown+raw_tex -t latex --wrap=none "$md" -o "generated/${name}.tex"
done

xelatex SP26_CS377_jxb.tex
xelatex SP26_CS377_jxb.tex  # second pass for cross-references
