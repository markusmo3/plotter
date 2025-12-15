#!/bin/bash
# https://vpype.readthedocs.io/en/latest/reference.html

# Show usage function
usage() {
    echo "Usage: $0 <input.svg> [--fit [MARGIN]]"
    echo "  <input.svg>      Input SVG file"
    echo "  --fit [MARGIN]   Optional flag to fit drawing to margins (default 10mm)"
    echo "  --vpype 'EXTRA ...'  Extra options appended to VPYPE_FLAGS"
    exit 1
}

# Validate input or show help
if [[ -z "$1" || "$1" == "-h" || "$1" == "--help" ]]; then
    usage
fi

INPUT=$1
shift

if [[ ! -f "$INPUT" ]]; then
    echo "Error: File '$INPUT' does not exist."
    exit 1
fi

if [[ "${INPUT##*.}" != "svg" ]]; then
    echo "Error: File '$INPUT' is not an SVG."
    exit 1
fi

VPYPE_FLAGS=""
MARGIN=""   # empty means: not fitting / no margin

# Parse remaining args: --fit [MARGIN] and --vpype "EXTRA FLAGS"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --fit)
            shift  # past --fit
            # If next arg exists and looks like a margin (ends with mm), use it
            if [[ -n "$1" && "$1" == *mm ]]; then
                MARGIN="$1"
                shift
            else
                # default margin if no value provided
                MARGIN="10mm"
            fi
            ;;
        --vpype)
            shift
            if [[ -z "$1" ]]; then
                echo "Error: --vpype requires an argument (e.g. '--vpype \"linemerge linesort\"')"
                exit 1
            fi
            # Append extra flags (keep a space before to separate)
            VPYPE_FLAGS="$VPYPE_FLAGS $1"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            usage
            ;;
    esac
done

# Add fit-to-margins (if requested) in front of any extra flags
if [[ -n "$MARGIN" ]]; then
    VPYPE_FLAGS="--fit-to-margins $MARGIN $VPYPE_FLAGS"
    echo "Fitting to margins: $MARGIN"
else
    echo "NOT FITTING"
fi

OUTPUT_P=${INPUT%.svg}-preview.svg
OUTPUT_G=${INPUT%.svg}.gcode

printf "%-24s %s\n" "Processing Input:" "$INPUT"
#vpype --config "${PWD}/vpype.toml" read "$INPUT" translate 0mm 63mm layout --landscape $VPYPE_FLAGS --valign center --align center 160mmx190mm linemerge linesort translate -- -5mm 0mm write "$OUTPUT_P"
vpype --config "${PWD}/vpype.toml" read "$INPUT" translate 0mm 63mm layout --landscape $VPYPE_FLAGS --valign center --align center 160mmx190mm linemerge linesort write "$OUTPUT_P"

printf "%-24s %s\n" "Writing gcode:" "$OUTPUT_G"
vpype --config "${PWD}/vpype.toml" read "$OUTPUT_P" gwrite "$OUTPUT_G"

printf "%-24s %s\n" "Writing preview:" "$OUTPUT_P"
vpype --config "${PWD}/vpype.toml" read "$OUTPUT_P" rect 0mm 0mm 190mm 160mm pagesize a4 translate 10mm 69mm \
    rect --layer 1 31mm 43.5mm 148mm 210mm \
    rect --layer 1 0mm 0mm 210mm 297mm \
    line --layer 1 105mm 0mm 105mm 297mm \
    line --layer 1 0mm 148.5mm 210mm 148.5mm \
    write "$OUTPUT_P"
python3 postprocess_preview.py "$OUTPUT_P"

printf "%-24s %s\n" "Generating thumbnails:" "$OUTPUT_G"
python3 thumbnail.py "$INPUT" "$OUTPUT_G"

echo "DONE"
