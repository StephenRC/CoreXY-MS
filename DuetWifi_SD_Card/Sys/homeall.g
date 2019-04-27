; homeall.g
; called to home all axes
;
; generated by RepRapFirmware Configuration Tool on Thu Oct 06 2016 12:46:23 GMT-0400 (Eastern Daylight Time)

; Relative positioning
G91

; Lift Z
G1 Z5 S2 F9000
; Move towards X and Y axis endstops (first pass)
G1 X-405 f5000 S1
G1 Y-305 F3000 S1
;G1 S1 X-405
;G1 S2 y-305
; Go back a few mm
G1 X5 Y5 F9000

; Move slowly to axis endstops once more (second pass)
G1 X-405 F360 S1
G1 Y-305 F360 S1

; Absolute positioning
G90
; home the Z axis
G1 X200 Y150 F9000
G30
