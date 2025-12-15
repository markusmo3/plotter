#!/usr/bin/env python3
import sys
from pathlib import Path
import xml.etree.ElementTree as ET

import cairosvg

SVG_NS = "http://www.w3.org/2000/svg"
ET.register_namespace("", SVG_NS)


def get_all_elements(root):
    """Return all elements in document order."""
    return list(root.iter())


def find_parent(root, child):
    """Find parent of 'child' under 'root' (ElementTree has no getparent)."""
    for el in root.iter():
        if child in list(el):
            return el
    return None


def main():
    if len(sys.argv) < 2:
        print("Usage: postprocess_preview.py <input.svg> [output.png|pdf|ps|svg]")
        sys.exit(1)

    svg_path = Path(sys.argv[1])
    if not svg_path.is_file():
        print(f"Error: '{svg_path}' does not exist or is not a file.")
        sys.exit(1)

    output_path = Path(sys.argv[2]) if len(sys.argv) > 2 else None

    tree = ET.parse(svg_path)
    root = tree.getroot()

    all_elems = get_all_elements(root)

    if len(all_elems) < 5:
        print(f"Found only {len(all_elems)} elements, nothing to restyle.")
    else:
        guides = all_elems[-5:]  # last 5 elements: 3 polygons + 2 lines

        guide_group = ET.Element(f"{{{SVG_NS}}}g", attrib={"stroke": "#000000", "fill": "none", "stroke-opacity": "0.3" })

        for el in guides:
            parent = find_parent(root, el)
            if parent is not None:
                parent.remove(el)
            guide_group.append(el)

        root.append(guide_group)
        tree.write(svg_path, encoding="utf-8", xml_declaration=True)
        print(f"Updated SVG with gray guides: {svg_path}")

    if output_path:
        svg_bytes = svg_path.read_bytes()
        ext = output_path.suffix.lower()

        if ext == ".png":
            cairosvg.svg2png(bytestring=svg_bytes, write_to=str(output_path))
        elif ext == ".pdf":
            cairosvg.svg2pdf(bytestring=svg_bytes, write_to=str(output_path))
        elif ext == ".ps":
            cairosvg.svg2ps(bytestring=svg_bytes, write_to=str(output_path))
        elif ext == ".svg":
            output_path.write_bytes(svg_bytes)
        else:
            print(f"Unsupported output format '{ext}'. Use .png, .pdf, .ps, or .svg.")
            sys.exit(1)

        print(f"Rendered with CairoSVG: {output_path}")


if __name__ == "__main__":
    main()
