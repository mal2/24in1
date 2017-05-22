!c::
Process, close, strip.exe
WinWait, Ahk2Exe for AutoHotkey v1.1.07.03 -- Script to EXE Converter, 
IfWinNotActive, Ahk2Exe for AutoHotkey v1.1.07.03 -- Script to EXE Converter, , WinActivate, Ahk2Exe for AutoHotkey v1.1.07.03 -- Script to EXE Converter, 
WinWaitActive, Ahk2Exe for AutoHotkey v1.1.07.03 -- Script to EXE Converter, 
Send, {Enter}
WinWait, Ahk2Exe, 
IfWinNotActive, Ahk2Exe, , WinActivate, Ahk2Exe, 
WinWaitActive, Ahk2Exe, 
Send, {Enter}
Run, strip.exe, C:\Users\xandir\Downloads\24in1ahk\
return