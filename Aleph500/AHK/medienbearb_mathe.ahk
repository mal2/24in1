ScriptName         = Medien_Mathe
ScriptNameClean    = Aleph Shortcuts
ScriptVersion      = 1.1

TrayTip , Shortcuts, <AlT>+R für Medienbearbeitung mit RFID `n<ALT>+E für Medienbearbeitung ohne RFID `n<WIN>+E für Medienbearbeitung ohne RFID mit Sofortdruck `nWenn sich das Word-Fenster öffnet`, <DRUCKEN>-Taste drücken um zu Drucken, 3
Menu, Tray, Tip,<AlT>+R mit RFID `n<ALT>+E ohne RFID `n<WIN>+E ohne RFID mit Sofortdruck `nIm Word-Fenster`, <DRUCKEN>-Taste um zu Drucken.


!r::
	rfid=1
	etikett=1
	GoSub, rfid_etikett
	Return
	
!e::
	rfid=0
	etikett=1
	GoSub, rfid_etikett
	Return
	
#e::
	rfid=0
	etikett=0
	GoSub, rfid_etikett
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

rfid_etikett:
IfWinExist, ahk_class Catalog500.22.0
{
	ifWinExist, alephsig
	{
		MsgBox, 48, Hinweis, Die Etikettdatei ist noch ge�ffnet!
		Return
	}
	Else
	WinActivate, ahk_class Catalog500.22.0
	
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.22.0
	If (vis=1){
	}
	else
	{
		Send, {F8}
		GoSub, wait
		Sleep, 200
	}
	
	If (rfid=0) { 
		Goto, transponder_ok 
	}
	
	Sleep, 100
	Send, {CTRLDOWN}2{CTRLUP}
  	Sleep, 100
	Send, {Alt Down}{Shift Down}
	Send, F
	Send, {Alt Up}{Shift Up}
	GoSub, wait
	Sleep, 500

	start:
	
	IfWinExist, RFID Lese, Der Transponder wurde erfolgreich beschrieben
		{
		WinActivate, RFID Lese, Der Transponder wurde erfolgreich beschrieben
			{
				Send, {Enter}
				goto, transponder_ok
			}
		}
		
	IfWinExist, Medienpacket, Dieser Transponder ist bereits initialisiert
		{
		WinActivate, Medienpacket, Dieser Transponder ist bereits initialisiert
			{
			loop{
				GetKeyState, state, LButton
					if state = D
						Sleep, 500
						goto, start
				GetKeyState, state, Enter
					if state = D
						Sleep, 500
						goto, start
				}
			Sleep, 500
			
			IfWinActive, RFID Lese, Der Transponder kann nicht beschrieben werden
			{
				goto, fehler
			}
			Sleep, 500
			Goto, start
			}
		}
	
	IfWinExist, Medienpacket, Es wurden
		{
		WinActivate, Medienpacket, Es wurden
			{
			loop{
			WinActivate, Medienpacket, Es wurden
			GetKeyState, state, LButton
			if state = D
				break
				;Sleep, 500
				;goto, start
			GetKeyState, state, Enter
			if state = D
				break
				;Sleep, 500
				;goto, start
			}
			
			;Sleep, 500
										
			IfWinExist, Server ist ausgelastet
				{
				WinActivate, Server ist ausgelastet
					{
						Send, {Enter}
						Sleep, 500
						Goto, start
					}
				}
				else
				{
				WinWaitActive, Server ist ausgelastet, , 3
				WinActivate, Server ist ausgelastet
					{
						Send, {Enter}
						Sleep, 500
						Goto, start
					}
				}
			
			IfWinActive, RFID Lese, Der Transponder kann nicht beschrieben werden
			{
				goto, fehler
			}
			
			Sleep, 500
			goto, start
			}
		}	
		

	Goto, start
	
	fehler:
	MsgBox, 48, Hinweis, Der Transponder konnte nicht beschrieben werden, das Makro wird abgebrochen.
	Return


	transponder_ok:
	
	WinActivate, ahk_class Catalog500.22.0 
	WinWaitActive, ahk_class Catalog500.22.0, , 10
	
	Send, {CTRLDOWN}2{CTRLUP}
	Sleep, 100
	Send, {Alt Down}{Shift Down}
	Send, E
	Send, {Alt Up}{Shift Up}
	Sleep, 1800
	
	WinWait, alephsig, , 10	
	WinActivate, alephsig
	;WinWait, alephsig, , 10	
	IfWinActive, alephsig
	{
		Sleep, 200
		;loop{
		;GetKeyState, state, PrintScreen
		;if state = D
		;	return
		;GetKeyState, state, Esc
		;if state = D
		;	break
		;Sleep, 100
		;}
		
		if (etikett = 1) then {
		KeyWait, PrintScreen, D
		}
		
		Sleep, 200
		Send, {Alt}
		Sleep, 100
		Send, d	
		Sleep, 100
		Send, u
		Sleep, 100
		Send, u	
		MsgBox,48, Hinweis, Druckauftrag abgeschlossen, 1
		Sleep, 200
		Send, {Alt}
		Sleep, 200
		Send, d
		Sleep, 200
		Send, l
		Sleep, 100
		Send, n
		Sleep, 200
		;goto, etikett_ok
	}
 	Else
	{
		MsgBox, 48, Hinweis, Word-Datei nicht mehr aktiv. Makro abgebrochen!
		Return
	}
	
	etikett_ok:
	
	WinActivate, ahk_class Catalog500.22.0
	WinWaitActive, ahk_class Catalog500.22.0, , 10
	
	Send, {CTRLDOWN}3{CTRLUP}
	Sleep, 200
	Send, {Alt Down}
	Send, 2
	Send, {Alt Up}
	Sleep, 200
	Send, {Tab 14}
	Sleep, 200
	Send, {Delete}
	Sleep, 200
	Send, {Enter}
	GoSub, wait
	Sleep, 200
	Send, ^{Tab}
	Sleep, 200
	Send, ^{Tab}
	Sleep, 200
	Send, {Tab}
	Sleep, 200
	Send, {Tab}
	;;SoundBeep
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return
