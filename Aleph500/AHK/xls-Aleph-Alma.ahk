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

ScriptName         = xls-Aleph-Alma
ScriptNameClean    = Aleph Shortcuts
ScriptVersion      = 0.1

!r::
	GoSub, edit_holding
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

WinMoveMsgBox:
	SetTimer WinMoveMsgBox, OFF
	ID:=WinExist("700g")
	SysGet, Width, 78
	SysGet, Height, 79
	;WinMove ahk_id %ID%, , Width - 500, Height - 800 
Return

edit_holding:
IfWinExist, ahk_class Catalog500.22.0
{
    excel := ComObjActive("Excel.Application")
	workBook  := excel.ActiveWorkbook
	currentSheet := excel.ActiveSheet
	bvb := excel.ActiveCell.Value
	excel.ActiveCell.Offset(rowOffset:=0, columnOffset:=1).Activate
	rvk := excel.ActiveCell.Value
	excel.ActiveCell.Offset(rowOffset:=0, columnOffset:=-1).Activate

	Send, ^#{Numpad2}
	Sleep, 5000
	SetTimer WinMoveMsgBox, 200
	MsgBox, 262148,700g, Soll das Feld 700g belegt werden?
	IfMsgBox Yes
	{
		Send, ^3
		Sleep, 200
		Send, !+k
		Sleep, 200
		Send, {F6}
		Sleep, 500
		Send, 700
		Sleep, 200
		Send, g
		Sleep, 200
		Send, {TAB 2}
		Sleep, 200
		Send, %rvk%
		Sleep, 200
		Send, ^l
		Sleep, 200
		Send, {Enter}
		Sleep, 500
		IfWinExist, ahk_class #32770
		{ 
		MsgBox, 262148,Fortfahren, Soll fortgefahren werden?
		IfMsgBox Yes
			{
				Send, ^#{Numpad1}
			}
		}
		
	}
	excel.ActiveCell.Interior.Color := 15773696
	excel.ActiveCell.Offset(rowOffset:=0, columnOffset:=1).Interior.Color := 15773696
	excel.ActiveCell.Offset(rowOffset:=1, columnOffset:=0).Activate
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return