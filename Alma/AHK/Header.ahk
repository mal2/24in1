;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         Kenny <k.b@fu-berlin.de>
;
; -----------------------------------------------------------------------------
; === Global Settings =========================================================
; -----------------------------------------------------------------------------

#singleinstance force
Winactivate force
DetectHiddenWindows, Off
SetBatchLines, -1
SetWinDelay, 0
SetControlDelay, 0
SetTitleMatchMode,1

; -----------------------------------------------------------------------------
; === Initialisation ========================================================
; -----------------------------------------------------------------------------

ScriptName         = AlmaAHK
ScriptNameClean    = Alma Shortcuts
ScriptVersion      = 0.1

; #NoTrayIcon ;  ExitApp muss dann aktiv sein