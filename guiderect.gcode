G21                             ; units are millimeters
G90                             ; absolute mode
G28 O                           ; home all without mesh bed level
G0 Z30 F720                     ; raise pen for travel
G0 X0 Y63 Z10 F10000
BASE_PAUSE                      ; pause for calibration
                                ; -- start layer --
G0 X185.0001 Y218.0001 F10000
G0 Z7 F10000                    ; pen down height

; --- Bounding box ---
G1 X5.0000   Y218.0001 F10000   ; top edge to top-left
G1 X5.0000   Y68.0000  F10000   ; left edge down
G1 X185.0001 Y68.0000  F10000   ; bottom edge right
G1 X185.0001 Y218.0001 F10000   ; right edge up (close box)

; --- A5 side markers (centered horizontally in the box) ---
; A5 width centered: X = 21 to X = 169
; Marker length: 10 mm, around Y = 143 (138..148)

; Left side marker
G0 Z10 F10000                   ; pen up
G0 X21.0 Y138.0 F10000          ; start of left marker
G0 Z7 F10000                    ; pen down
G1 X21.0 Y148.0 F10000          ; draw left vertical tick

; Right side marker
G0 Z10 F10000                   ; pen up
G0 X169.0 Y138.0 F10000         ; start of right marker
G0 Z7 F10000                    ; pen down
G1 X169.0 Y148.0 F10000         ; draw right vertical tick

; --- Center guides (short crosshair at box center) ---
; Box center: Xc = 95, Yc = 143

; Vertical center guide (20 mm tall: 133..153)
G0 Z10 F10000                   ; pen up
G0 X95.0 Y68.0 F10000          ; bottom of vertical center guide
G0 Z7 F10000                    ; pen down
G1 X95.0 Y218.0 F10000          ; draw vertical center tick

; Horizontal center guide (20 mm long: 85..105)
G0 Z10 F10000                   ; pen up
G0 X5.0 Y143.0 F10000          ; left of horizontal center guide
G0 Z7 F10000                    ; pen down
G1 X185.0 Y143.0 F10000         ; draw horizontal center tick

; --- end drawing ---

G0 Z10 F10000                   ; pen up
                                ; -- shutdown
G0 Z30 F10000                   ; raise pen for travel
G0 X100 Y223 F10000             ; move head out of the way
M84                             ; disable motors
CONDITIONAL_BEEP I=2 DUR=30 FREQ=8500