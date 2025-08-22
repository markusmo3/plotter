Plotting with the SV06
--------------------------------

### Preview
<picture>
  <source media="(prefers-color-scheme: dark)" srcset="./svgs/icosa-medusa-preview-darkmode.svg">
  <img alt="Icosa Medusa Pattern" src="./svgs/icosa-medusa-preview.svg" style="width: 300px">
</picture>

The outermost rectangle is an A4 paper, the inner rectangle is the printable area of 190x160 and then there is the icosa medusa pattern.

### Hardware
* SV06
* [Pen Plotter Attachment](https://www.printables.com/model/63385-pen-plotter-attachment-for-prusa-mk3s)
  * Instead of the E-block holder for MK3s you need: [Mounting Piece for SV06](https://www.printables.com/model/984052-pen-plotter-attachment-for-the-sovol-sv06)
  * And then you only one way to mount your pens, so *either* narrow, wide or threaded+collet. Optionally you can use the spacer and or the calibrator
    * The fit is quite tight, be prepared to either sand your inner pieces or print them at 99%
* 2 screws M3x20 to mount the SV06 mounting piece to the extruder as my screws from the extruder were slightly too short with the mounting piece attached
* Rubber bands

### Software
* python 3
* [Some awesome designs](https://turtletoy.net/turtle/browse/newest/)
* (optional) Inkscape, GIMP, Affinity, etc.

### Setup and Calibration
1. Mount the eblock holder
2. Put paper to the top right corner of your printbed (you can use both sides of your plate for either a rough or smoother look)
3. Move your extruder around with a pen attached to find your limits (for my SV06 they are xMin=0, yMin=63, xMax=190, yMax=223)
4. Calculate your printable area size from that (for my SV06 that is 190x160)
5. Update `vpype.toml` and `plot.sh` accordingly
6. My scripts use z position 7mm as down and 10mm as up, so move your extruder head to 8mm and calibrate your pen apperature with it. (We need that extra 1mm because of the unevenness of the bed)

### Workflow
1. Clean if necessary or wanted, play around with `./clean.sh myfile.svg`
2. Plot it (while fitting to the max size - some border if you want) `./plot.sh myfile.svg --fit`
3. Check resulting preview for how it would look like on an A4 page `myfile-preview.svg`
4. Print
	1. Place paper on rough or smooth side of bed sheet
	2. Secure with magnets, tape or binder clips. (I put 4 tiny magnets in the corners)
	3. Do NOT put pen in yet (otherwise the autocalibration of XYZ axes will smear you pen into the middle)
	4. Start print `myfile.gcode`, print will be paused after calibration
	5. Now put your pen in and press resume

### Credits
* I forked the repo from here: https://github.com/brianlow/plotter/tree/main
* the examples in the `svgs` folder are from turtletoy.
  * icosa-medusa: https://turtletoy.net/turtle/fda571fea9
  * cityscape: https://turtletoy.net/turtle/789cce3829
  * waves: https://turtletoy.net/turtle/a4242cdb2b
