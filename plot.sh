#!/bin/bash
# https://vpype.readthedocs.io/en/latest/reference.html

# Show usage function
usage() {
    echo "Usage: $0 <input.svg> [--fit]"
    echo "  <input.svg>    Input SVG file"
    echo "  --fit          Optional flag to fit drawing to 5mm margins"
    exit 1
}

# Validate input or show help
if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

INPUT=$1

if [[ ! -f "$INPUT" ]]; then
    echo "Error: File '$INPUT' does not exist."
    exit 1
fi

if [[ "${INPUT##*.}" != "svg" ]]; then
    echo "Error: File '$INPUT' is not an SVG."
    exit 1
fi

FIT_TO_MARGINS_FLAG=""
if [[ "$2" == "--fit" ]]; then
    FIT_TO_MARGINS_FLAG="--fit-to-margins 10mm"
    echo "Using $FIT_TO_MARGINS_FLAG"
else
    echo "NOT FITTING"
fi

OUTPUT_P=${INPUT%.svg}-preview.svg
OUTPUT_G=${INPUT%.svg}.gcode

printf "%-24s %s\n" "Processing Input:" "$INPUT"
vpype --config "${PWD}/vpype.toml" read "$INPUT" translate 0mm 63mm layout --landscape $FIT_TO_MARGINS_FLAG --valign center --align center 160mmx190mm linemerge linesort write "$OUTPUT_P"

printf "%-24s %s\n" "Writing gcode:" "$OUTPUT_G"
vpype --config "${PWD}/vpype.toml" read "$OUTPUT_P" gwrite "$OUTPUT_G"

printf "%-24s %s\n" "Writing preview:" "$OUTPUT_P"
vpype --config "${PWD}/vpype.toml" read "$OUTPUT_P" rect 0mm 0mm 190mm 160mm pagesize a4 translate 10mm 69mm rect 0mm 0mm 210mm 297mm write "$OUTPUT_P"

printf "%-24s %s\n" "Generating thumbnails:" "$OUTPUT_G"
python3 thumbnail.py "$INPUT" "$OUTPUT_G"

echo "DONE"
