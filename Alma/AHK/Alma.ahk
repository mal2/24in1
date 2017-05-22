; -----------------------------------------------------------------------------
; === Include =================================================================
; -----------------------------------------------------------------------------

#Include Header.ahk
#Include GUI.ahk

; -----------------------------------------------------------------------------
; === Globale Variablen =======================================================
; -----------------------------------------------------------------------------

global status
global loca

; -----------------------------------------------------------------------------
; === Definition der Hotkeys ==================================================
; -----------------------------------------------------------------------------

!g::
	status:="01"
    GoSub, add_call_ex
	Return

!w::
    status:="07"
    GoSub, add_call_ex
	Return

!r::
	status:="05"
    GoSub, add_call_ex
	Return

^!g::
    status:="09"
    GoSub, add_call_ex
	Return
    
!e::
    GoSub, open_editors_search
    Return    
    
^!e::
    GoSub, open_editors_full_search
    Return

!q::
    GoSub, go_search
    Return

!b::
    GoSub, add_call_gg
    Return
    
; -----------------------------------------------------------------------------
; === Helper Functions ========================================================
; -----------------------------------------------------------------------------

location:
	StringSplit, array, clipboard, %A_Space%  ; Omits periods.
	; array1 - RVK Buchstaben
	; array2 - RVK Nummer
	
	if array1 between AA and BB 
	{
			loca:="AB/0"
	}
	
	if array1 = BC and array2 < 6500
	{
			loca:="AB/0"
	}
	
	if array1 = "BC" and array2 >= 6500
	{
			loca:="AB/1"	
	}
	
	if array1 between BD and BN 
	{
			loca:="AB/1"
	}
	
	if array1 between BO and CR 
	{
			loca:="AB/2"
	}
	
	if array1 between CS and DL 
	{
			loca:="AB/4"
	}
	
	if array1 between DM and DR 
	{
			loca:="AB/5"
	}
	
	if array1 = "DS" and array2 < 4000
	{
			loca:="AB/5"
	}
	
	if array1 = "DS" and array2 >= 4000
	{
			loca:="AB/6"
	}
	
	if array1 between DT and DZ 
	{
			loca:="AB/6"
	}
	
	if array1 between E and KZ 
	{
			loca:="NB/OG"
	}
	
	if array1 between L and NZ
    {
			loca:="NB/EG"
	}
	
	if array1 between P and ZZ 
    {
			loca:="NB/UG"
	}
    
    if status == "09"
    {
            loca:="LBS"
    }
return

; -----------------------------------------------------------------------------
; === Subroutinen =============================================================
; -----------------------------------------------------------------------------

add_call_ex:
IfWinExist, Laufzettel.xlsx - Excel, 
{
	
    Send, ^c
	
    GoSub, location
    
	excel := ComObjActive("Excel.Application")
    
	StringGetPos, a, clipboard, %A_Space%, L2
	StringLeft, rvk, clipboard, %a%
	a := a+1
	StringTrimLeft, cutter, clipboard, %a%
	
    excel.ActiveSheet.Range("D8").Value := loca
	excel.ActiveSheet.Range("D10").Value := rvk . "`n" . cutter

	if (status="09"){
		excel.ActiveSheet.Range("E5").Value := "komplett grün"
        excel.ActiveSheet.Range("D8").Value := "LBS"
	}
	if (status="01"){
		excel.ActiveSheet.Range("E5").Value := "grün"
	}
	if (status="07"){
		excel.ActiveSheet.Range("E5").Value := "weiß"
	}
	if (status="05"){
		excel.ActiveSheet.Range("E5").Value := "rot"
	}

	Sleep, 100
	
	excel.ActiveWorkbook.PrintOut()
	
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das entspechende Excel-Tabellenblatt geöffnet wurde
	Return

open_editors_search:
IfWinExist, Bestandssuche - Google Chrome, 
{
    WinActivate, Bestandssuche - Google Chrome, 

    Sleep, 400
    Send, {Tab 13}
    Sleep, 200
    Send, ^c
    Sleep, 400

    IfWinExist, MD-Editor, 
    {
        WinWait, MD-Editor, 
        IfWinNotActive, MD-Editor, , WinActivate, MD-Editor, 
        WinWaitActive, MD-Editor, 

        Sleep, 400
        Send, ^!f
        Sleep, 100
        Send, ^v
        Sleep, 100
        Send, {Enter}

        Sleep, 1500

        Loop, 20 {
            Send, +{Tab}
            Sleep, 100
        }
        Sleep, 100
        Send, {Enter}
    }
    
    IfWinExist, Liste, 
    {
        WinWait, Liste, 
        IfWinNotActive, Liste, , WinActivate, Liste, 
        WinWaitActive, Liste, 

        Sleep, 400
        Send, ^!f
        Sleep, 100
        Send, ^v
        Sleep, 100
        Send, {Enter}

        Sleep, 1500

        Loop, 19 {
            Send, +{Tab}
            Sleep, 100
        }
        Sleep, 100
        Send, {Enter}
    }
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn die Bestandssuche geöffnet wurde
	Return

open_editors_full_search:
IfWinExist, Bestandssuche - Google Chrome, 
{
    WinActivate, Bestandssuche - Google Chrome, 

    Sleep, 200
    Send, {Tab 13}
    Sleep, 100
    Send, ^c
    Sleep, 200

    IfWinExist, MD-Editor, 
    {
        WinWait, MD-Editor, 
        IfWinNotActive, MD-Editor, , WinActivate, MD-Editor, 
        WinWaitActive, MD-Editor, 

        Sleep, 400
        Send, ^!f
        Sleep, 100
        Send, ^v
        Sleep, 100
        Send, {Enter}

        Sleep, 1500

        Loop, 20 {
            Send, +{Tab}
            Sleep, 100
        }
        Sleep, 100
        Send, {Enter}

        Sleep, 2000

        Send, +{Tab}
        Sleep, 100
        Send, +{Tab}
        Sleep, 100
        Send, {Enter}
        Sleep, 100
        Send, {Tab 2}
        Sleep, 100
        Send, {Enter}
        Sleep, 100
    }
    
    IfWinExist, Liste, 
    {
        WinWait, Liste, 
        IfWinNotActive, Liste, , WinActivate, Liste, 
        WinWaitActive, Liste, 

        Sleep, 400
        Send, ^!f
        Sleep, 100
        Send, ^v
        Sleep, 100
        Send, {Enter}

        Sleep, 1500
        Loop, 19 {
            Send, +{Tab}
            Sleep, 100
        }
        Sleep, 100
        Send, {Enter}

        Sleep, 2000

        Send, +{Tab}
        Sleep, 100
        Send, +{Tab}
        Sleep, 100
        Send, {Enter}
        Sleep, 100
        Send, {Tab 2}
        Sleep, 100
        Send, {Enter}
        Sleep, 100
    }

}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn die Bestandssuche geöffnet wurde.
	Return
    
go_search:
IfWinExist, Bestandssuche - Google Chrome, 
{

    WinActivate, Bestandssuche - Google Chrome,
    
    Sleep, 200
    Send, ^!f
    
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn die Bestandssuche geöffnet wurde.
	Return
    
add_call_gg:
IfWinExist, Editor, 
{

    
    Send, {Tab 30}
    Sleep, 100
    Send, {Down 2}
    Sleep, 100
    Send, {Tab}
    Sleep, 600
    Loop, 36 {
        Send, +{Tab}
        Sleep, 100
    }
    Send, {Tab}
    Sleep, 100
    Send,  Medienbearbeitung
    
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn der Editor für physische Exemplare geöffnet wurde.
	Return