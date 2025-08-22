#!/bin/bash
# can be used to clean up a svg
# need to play around with parameters yourself though
# https://vpype.readthedocs.io/en/latest/reference.html

INPUT=$1
OUTPUT=${INPUT%.svg}-cleaned.svg

echo $INPUT -> $OUTPUT
#vpype read "$INPUT" linemerge --tolerance 0.01mm linemerge --tolerance 0.05mm linemerge --tolerance 0.1mm linesimplify linesimplify --tolerance 0.1mm linesort write ${OUTPUT}
vpype read "$INPUT" snap 0.1mm linemerge --tolerance 0.1mm linesort write ${OUTPUT}
#vpype read "$INPUT" snap 0.5mm write ${OUTPUT}
