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

ScriptName         = GenderStandort
ScriptNameClean    = Aleph Shortcuts
ScriptVersion      = 0.1

!r::
	GoSub, change_location
	Return

^e::
    Gosub, item_process_status_gg
    Return

wait:
	timeout = 5000
	start = A_TickCount
	stat = ""
	DetectHiddenText, On
	;Send, {ENTER}
	StatusBarGetText, stat, 3, ahk_class Catalog500.22.0
	While (stat = "" and (A_TickCount-timeout) > start){

		StatusBarGetText, stat, 3, ahk_class Catalog500.22.0
		While (stat <>  "" and (A_TickCount-timeout) > start){ 

			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.22.0
			if (stat = ){
				goto, ex5
			}
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.22.0
			if (stat = ){
				goto, ex5
			}
		}
		Sleep, 50
	}
	ex5:
	While (stat <> "" and (A_TickCount-timeout) > start){
		StatusBarGetText, stat, 3, ahk_class Catalog500.22.0
		
		While (stat = "" and (A_TickCount-timeout) > start){ 
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.22.0
			if (stat <> ){
				goto, ex5
			}
			else {
				goto, ex25
			}
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.22.0
			if (stat <> ){
				goto, ex5
			}
			else {
				goto, ex25
			}
		}
		Sleep, 50
	}
	ex25:
	Sleep, 1000
return

location:
	global loca
	StringSplit, array, clipboard, %A_Space%  ; Omits periods.
	
	; array1 - RVK Buchstaben
	; array2 - RVK Nummer
	
	if array1 between AA and BB 
	{
			Send, AB/0
			loca:="AB/0"
	}
	
	if array1 = "BC" and array2 < 6500
	{
			Send, AB/0
			loca:="AB/0"
	}
	
	if array1 = "BC" and array2 >= 6500
	{
			Send, AB/1
			loca:="AB/1"	
	}
	
	if array1 between BD and BN 
	{
			Send, AB/1
			loca:="AB/1"
	}
	
	if array1 between BO and CQ
	{
			Send, AB/2
			loca:="AB/2"
	}
	
	if array1 between CR and DP
	{
			Send, AB/4
			loca:="AB/4"
	}
	
	if array1 between DQ and DR 
	{
			Send, AB/5
			loca:="AB/5"
	}
	
	if array1 = "DS" and array2 < 4000
	{
			Send, AB/5
			loca:="AB/5"
	}
	
	if array1 = "DS" and array2 >= 4000
	{
			Send, AB/6
			loca:="AB/6"
	}
	
	if array1 between DT and DZ 
	{
			Send, AB/6
			loca:="AB/6"
	}
	
	if array1 between E and KZ 
	{
			Send, NB/OG
			loca:="NB/OG"
	}
	
	if array1 between L and NZ 
	{
			Send, NB/EG
			loca:="NB/EG"
	}
	
	if array1 between P and ZZ 
	{
			Send, NB/UG
			loca:="NB/UG"
	}

return

; auf GG stellen
item_process_status_gg:
IfWinExist, ahk_class Catalog500.22.0
{
	WinWait, ahk_class Catalog500.22.0 
	IfWinNotActive, ahk_class Catalog500.22.0
	WinActivate, ahk_class Catalog500.22.0
	WinWaitActive, ahk_class Catalog500.22.0, 
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.22.0
	If (vis=1){
	}
	else
	{
	Send, {F8}
	GoSub, wait
	Sleep, 500
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}{TAB 14}
	Send, gg
	Send, {ENTER}
	;Sleep, 1200
	GoSub, wait
	Sleep, 200
	Send, {Down}
	;Sleep, 1000
	GoSub, wait
	Sleep, 200
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}
	Send, {CTRLDOWN}{TAB 3}{CTRLUP}
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return

change_location:
IfWinExist, ahk_class Catalog500.22.0
{


    excel := ComObjActive("Excel.Application")
	workBook  := excel.ActiveWorkbook
	currentSheet := excel.ActiveSheet
	cell := excel.ActiveCell.Value

    WinWait, ahk_class Catalog500.22.0 
	IfWinNotActive, ahk_class Catalog500.22.0
	WinActivate, ahk_class Catalog500.22.0
	WinWaitActive, ahk_class Catalog500.22.0, 	
    
    Send, {F8}
    GoSub, wait
    Sleep, 500
    ;Send, ^3
    ;Sleep, 100
    Send, ^{Tab 3}
    Sleep, 100
    Send, {Tab 2}
    
    Send, % Floor(cell)
    Sleep, 100
    Send, {Enter}
    Sleep, 1500
    Send, ^3
    Sleep 100
    Send, !2
    Sleep, 100
    Send, {Tab 9}
    Sleep, 100
    clipalt=%clipboard%
    Send, ^c
    clipwait
    Sleep, 100
    Send, +{Tab 7}
    Sleep, 100
    GoSub, location
    Sleep, 100
    clipboard=%clipalt%
    Send, {Enter}
    GoSub, wait
    Sleep, 500
    
    ;Sleep 100
    ;Send, NB/UG
    ;Sleep, 200
    ;Send, {Enter}
    ;Sleep, 750
    
    Send, ^{Tab 2}
    Send, {Tab 2}
    
    excel.ActiveCell.Offset(1).Select
    cell := excel.ActiveCell.Value
    
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return