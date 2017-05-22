Winactivate force
DetectHiddenWindows, Off
SetBatchLines, -1
SetWinDelay, 0
SetControlDelay, 0
SetTitleMatchMode,1
z := 0

ScriptName         = ZDB
ScriptVersion      = 1.0

Menu, Tray, Tip, %ScriptName% %ScriptVersion%
Menu, Tray, Add, Tastaturkürzel, ShowReadme
return

ShowReadme:
   Gui, 1:Font,S7 bold, Arial
   Gui, 1:Add, Text,, <ALT>+C `n     - Sucht einen zuvor markierten Text in ZDB OPAC.      
   Gui, 1:Add, Text,, <WIN>+C `n     - Sucht einen zuvor markierten Text in Indexsuche.    
   
   Gui, 1:Font
   Gui, 1:Add, Button, X285 W50 Default g1GuiClose, &OK
   GuiControl, 1:Focus, &OK
   GuiControl, +HScroll50, MyScrollBar
   Gui, 1:Show,,Tastaturkürzel
Return

1GuiClose:
1GuiExit:
1GuiCancel:
   Gui, 1:Destroy
Return


!c::
	; markierten Text im OGND suchen
	Gosub, ZSD_search
Return

#c::
	; markierten Text im OGND suchen
	Gosub, IND_search
Return

ZSD_search:
IfWinExist, Startseite | Zeitschriftendatenbank, 
{
	z = 1
	goto, Z_search
	return
}
else
{
	IfWinExist, ZDB OPAC, 
	{
		z = 0
		goto, Z_search
		return
	}
	Else
	{
	MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein ZDB-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return
	}
}

z_search:
	clipboard = 
	Send, ^c
	ClipWait

	if z = 1
	{
		WinActivate, Startseite | Zeitschriftendatenbank,
		WinWaitActive, Startseite | Zeitschriftendatenbank,
	}
	else
	{
	WinActivate, ZDB OPAC,
	WinWaitActive, ZDB OPAC,
	}
	
	
	;MsgBox, %clipboard%
	clipboard = http://dispatch.opac.d-nb.de/DB=1.1/SET=2/TTL=1/CMD?ACT=SRCHA&IKT=8506&SRT=LST_ty&TRM=%clipboard%
	SetKeyDelay, -1
	
	;MsgBox, %clipboard%
	Sleep, 100
	Send, ^l
	Sleep, 100
	SendRaw, %clipboard%
	Sleep, 100
	Send, {Enter}
	
	return
return

IND_search:
; in die Indexsuche springen
IfWinExist, ahk_class Catalog500.20.2
{
	Send, ^c
	WinActivate, ahk_class Catalog500.20.2,
	WinWaitActive, ahk_class Catalog500.20.2,
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}
	Sleep, 100
	Send, z
	Sleep, 100
	Send, {TAB}
	Send, ^v
	Send, {ENTER}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return
