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
; === Initialisation ======================================================cd==
; -----------------------------------------------------------------------------

ScriptName         = 24in1
ScriptNameClean    = Aleph Shortcuts
ScriptVersion      = 2.1

; #NoTrayIcon ;  ExitApp muss dann aktiv sein


StringRight, Lng, A_Language, 2
if Lng = 07  ; = Deutsch (0407, 0807, 0c07 ...)
{
   lng_Info       = Information
   tut_Info		  = Anleitung
   lng_deactivate = Deaktivieren
   lng_exit       = Beenden
}
else        ; = other languages (english)
{
   lng_Info       = Information
   tut_Info		  = Instruction
   lng_activate   = activate
   lng_deactivate = deactivate
   lng_exit       = Exit
}


Menu, Tray, Tip, %ScriptName% %ScriptVersion%
; Menu, Tray, NoStandard ; Zum Bearbeiten deaktivieren
Menu, Tray, Add, %lng_Info%, ShowReadme
Menu, Tray, Add, %tut_Info%, ShowTut

Loop
{
   actFunct := Function[%A_Index%]
   actEnable = Enable_%actFunct%

   If actFunct =
      Break

   IniRead, %actEnable%, %ConfigFile%, %ScriptNameClean%, %actEnable%
   If %actEnable% = ERROR
      %actEnable% = yes

   Gosub, init_%actFunct% ; cd_
   ScriptMenu[%A_Index%] = %MenuName%
   Gosub, MenuCreate

   if A_Index = 2
      if %actEnable% <> yes
      {
        Hotkey, $MButton, Off
        Hotkey, $MButton Up, Off
      }

}


Menu, Tray, Add
Menu, Tray, Add, %lng_deactivate%, MenuSuspend
Menu, Tray, Default, %lng_deactivate%
Menu, Tray, Add
Menu, Tray, Add, %lng_exit% , MenuExit


Loop, Read, %ScriptName% Readme.txt
{
   Readme = %Readme%%A_LoopReadLine%`n
}


Return

; ---Tray-Menu-----------------------------------------------------------------
MenuCreate:

   Menu, Tray, add, %MenuName%, MenuCall
   if (Enable_%actFunct% = "yes")
      Menu, Tray, Check, %MenuName%
   Else
      Menu, Tray, UnCheck, %MenuName%

Return


MenuCall:

   MenuID := A_ThisMenuItemPos -2
   MenuItem := Function[%MenuID%]

   ; Menupunkt de/aktivieren
   if (Enable_%MenuItem% = "yes")
   {
      Menu, Tray, UnCheck, %A_ThisMenuItem%
      Enable_%MenuItem% = no
      if %MenuID% = 2
      {
         Hotkey, $MButton, Off
         Hotkey, $MButton Up, Off
      }
   }
   Else
   {
      Menu, Tray, Check, %A_ThisMenuItem%
      Enable_%MenuItem% = yes
      if MenuID = 2
      {
         Hotkey, $MButton, On
         Hotkey, $MButton Up, On
      }
   }

   ; Einstellung speichern
   Loop
   {
      actFunct := Function[%A_Index%]
      actEnable = Enable_%actFunct%

      If actFunct =
         Break

      IniWrite, % %actEnable%, %ConfigFile%, %ScriptNameClean%, %actEnable%
   }

Return

MenuSuspend:
   Suspend, Toggle
   Menu, Tray, ToggleCheck, %lng_deactivate%
;   Menu, Tray, ToggleEnable, Lokale Einstellungen zeigen
	
   Loop
   {
      actFunct := Function[%A_Index%]

      If actFunct =
         Break

      Menu, Tray, ToggleEnable, % ScriptMenu[%A_Index%]
   }

Return



ShowReadme:
   Gui, 1:Font,S7 bold, Arial
   Gui, 1:Add, Text,, <ALT>+C `n     - Sucht einen zuvor markierten Text mit Cutter Jo.    
   Gui, 1:Add, Text,, <ALT>+D `n     - Springt zur Indexsuche in Aleph.    
   Gui, 1:Add, Text,, <ALT>+E `n     - Schreibt GG als Geschäftsgangstatus im Exemplarsatz und springt zu Strichcode.    
   Gui, 1:Add, Text,, <ALT>+F `n     - Kopiert den Text der Indexsuche in das Signaturfeld, `n       schreibt GG als Geschäftsgangstatus in den Exemplarsatz und springt zu Strichcode.
   Gui, 1:Add, Text,, <ALT>+G `n     - Trägt 700g in die Interne Notiz des Exemplarsatzes ein.    
   Gui, 1:Add, Text,, <ALT>+O `n     - Sucht einen zuvor markierten Text in der OGND.   
   Gui, 1:Add, Text,, <ALT>+W `n     - Sucht in der Indexsuche nach der vergebenen Signatur. 
   Gui, 1:Add, Text,, <ALT>+Q `n     - Aktiviert Exemplaranzeige.    
   Gui, 1:Add, Text,, <ALT>+R `n     - RFID beschreiben, Etikett erstellen und Status auf Verfügbar stellen.`n        Word wartet mit dem Etikettdruck bis die Druck-Taste (Print) gedrückt wird.
   Gui, 1:Add, Text,, <ALT>+S `n     - Sucht einen zuvor markierten Text über die "Einfache Suche". 
   Gui, 1:Add, Text,, <ALT>+B `n     - Kopiert den Text der Indexsuche in das Signaturfeld, schreibt GG als Geschäftsgangstatus `n       in den Exemplarsatz, ändert Standort zu LBS und springt zu Strichcode.
   Gui, 1:Add, Text,, --------------------------------------------------------------------------------------------------------------
   Gui, 1:Add, Text,, <STRG>+<WIN>+6: `n     - Lädt einen Exemplarsatz in der Exemplarverwaltung der Katalogisierung anhand `n       des zuvor in einem anderen Programm markierten Barcodes.
   Gui, 1:Add, Text,, <STRG>+<WIN>+l: `n     - Lädt über die Systemnummer einen FUB01-Datensatz in der Katalogisierung, lokalisiert `n       ihn im B3Kat und öffnet abschliessend den BVB01-Satz. 
   Gui, 1:Add, Text,, <STRG>+<WIN>+o: `n     - Lädt über die Bestellnummer einen Bestellsatz im Erwerbungsmodul. 
   Gui, 1:Add, Text,, <ALT>+<WIN>+b in Aleph-Dienstrecherche: `n     - Lokalisieren in BVB01
   Gui, 1:Add, Text,, <ALT>+<WIN>+f in Aleph-Dienstrecherche: `n     - Lokalisieren in FUB01 
   Gui, 1:Add, Text,, --------------------------------------------------------------------------------------------------------------
   Gui, 1:Add, Text,, <STRG>+<WIN>+b: `n     - Firefox-Fenster stets im Vordergrund (an / aus) 
   Gui, 1:Add, Text,, <STRG>+<WIN>+e: `n     - Excel-Fenster stets im Vordergrund (an / aus)
   Gui, 1:Add, Text,, <STRG>+<Pfeil unten>: `n     -  verkleinert aktives Aleph-Fenster`
   Gui, 1:Add, Text,, <WIN>+z: `n     -  erzwingt verkleinertes Aleph-Fenster (beim Navigieren zwischen Modulen) `n        bzw. hebt den Zwang auf.
   
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

ShowTut:
   Gui, 2:Font,S7 bold, Arial
   Gui, 2:Add, Text,, 1. Blick    
   Gui, 2:Add, Text,, Strichcode einscannen, Autor markieren und <ALT>+C drücken um den markierten Text in Cutter Joe einzufügen. Dazu muss Cutter Joe in einem Firefox Fenster geöffnet und der Cutter Joe Tab muss aktiv sein.`n Am besten ist es Cutter Joe in einen separaten Fenster zu öffnen, dieses wird dann Automatisch vom Makro aktiviert.`nDa das Makro danach direkt wieder zu Aleph springt bietet es sich an das Katalog-Fenster so zu verkleinern, dass am linken Rand etwas Platz ist um das Firefox-Fenster sehen zu können, wenn es sich im Hintergrund befindet.`nMit <ALT>+S such man dann einen einen markierten text, z.B. Autor oder Titel, in der einfachen Suche. Der markierte Text wird in das oberste der drei Suchfelder eingefügt.`nIst für das Buch noch keine RVK vergeben wird mit <ALT>+g "700g" in die Interne Notiz geschrieben. Nachdem man den Dublettencheck usw. durchgeführt hat, kann man mit <ALT>+D zur Indexsuche wechseln und nach der zu`nvergebenden Signatur suchen. Es ist nicht notwendig Großbuchstaben zu verwenden die Signatur kann auch etwa so aussehen us 1000 o91. Ist die Signatur nur einmal vorhanden wird sie mit <ALT>+F aus dem Indexsuchenfeld`nkopiert und in das Signaturfeld eigefügt. Danach wird der Exemplarstatus auf GG gestellt und gewartet bis Sie entweder ENTER oder ESC zum Bestätigen bzw. Abbrechen drücken. Nachdem ENTER gedrückt wurde sprigt das Makro`nin das Strichcodefeld.

   Gui, 2:Add, Text,, 2. Blick
   Gui, 2:Add, Text,, Um den Cutter zu prüfen geht man wie im 1. Blick vor. Nach dem Buch oder dem Autor wird ebenso gesucht. Um die im 1. Blick vergebene Signatur zu prüfen wird <ALT>+W benutzt. Die Signatur wird kopiert und`ndie Indexsuche ausgeführt. Ist alles in Ordnung kann der 2. Blick mit <ALT>+E beendet werden. Der Status wird auf GG gesetzt und das Makro spring in das Strichcodefeld.
   
   Gui, 2:Add, Text,, Medienbearbeitung
   Gui, 2:Add, Text,, Nachdem man das Buch eingescannt hat, legt man einen RFID-Tag auf das Lesegerät und startet mit <ALT>+R das Makro. Der Tag wird beschrieben und der Etikettdruck ausgeführt. Das Word-Fenster öffnet sich.`nDas Makro wartet so lange bis von Ihnen die DRUCK bzw. PRINT SCREEN gedrückt wird. Das Etikett wird dann gedruckt, der Status auf Verfügbar gestellt und in das Strichcodefeld gesprungen.
   
   Gui, 2:Font
   Gui, 2:Add, Button, X285 W50 Default g2GuiClose, &OK
   GuiControl, 2:Focus, &OK
   GuiControl, +HScroll50, MyScrollBar
   Gui, 2:Show,,Anleitung
   Return

2GuiClose:
2GuiExit:
2GuiCancel:
   Gui, 2:Destroy
Return

MenuExit:
   ExitApp
Return

MenuHandlerInfo:
	FileRead, ServicePackLevel, ..\tab\version.txt
	IniRead, VC, ..\tab\alephcom.ini, VersionControl, Type
	IniRead, MailServer, ..\tab\alephcom.ini, Mail, MailServer
	IniRead, FromAddress, ..\tab\alephcom.ini, Mail, FromAddress
	IniRead, Targets, ..\tab\alephcom.ini, General, Targets
	IniRead, OrderGroup, ..\..\acq\tab\acq.ini, OrderNumber, PrefixString
	MsgBox,64,Client Info, %ServicePackLevel%`nWerte aus der alephcom.ini:`nVersionCheck:`t%VC%`nMailServer:`t%MailServer%`nFromAddress:`t%FromAddress%`nPrintTargets:`t%Targets%`n`nWerte aus der acq.ini:`nBestellnummernkreis:`t%OrderGroup%
Return

ResizeWin(Width = 0,Height = 0)
{
    WinGetPos,X,Y,W,H,A
    If %Width% = 0
    Width := W

    If %Height% = 0
    Height := H

    WinMove,A,,%X%,%Y%,%Width%,%Height%
}


; -----------------------------------------------------------------------------
; === Definition der Hotkeys ==================================================
; -----------------------------------------------------------------------------



!r::
	Gosub, rfid_etikett
	Return
	
!s::
	Gosub, find_search
	Return

!q::
	; zu Exemplaranzeige springen
	Gosub, show_item
	Return

!c::
	; Cutter Jo Suchanfrage
	Gosub, CutterJo
	Return

!d::
	; zur Indexsuche springen
	Gosub, show_index_search
	Return

!e::
	; auf GG stellen
	Gosub, item_process_status_gg
	Return

!f::
	; auf GG stellen
	Gosub, add_call_no_gg
	Return

!g::
    ; 700g eintragen
	Gosub, internal_note_700g
	Return

!o::
	; markierten Text im OGND suchen
	Gosub, OGND_search
	Return

!w::
	; vergebene Signatur in Indexsuche kopieren und suchen
	GoSub, sig_search
	Return
	
!b::
	; auf GG stellen und Standort in LBS ändern
	Gosub, add_call_no_gg_lbs
	Return
	
#^6::
	Gosub, push2_cat_items
	Return

	
#^l::
	Gosub, push2_cat_b3kat
	Return

#^o::
	Gosub, push2_acq
	Return	


#^b::
	Gosub, top_mozilla
	Return

#^e::
	Gosub, top_excel
	Return
	
#!b::
	Gosub, locate_bv
	Return
	; funktioniert nur bei Einzelplatzinstallation unter C:\Al500_20

#!f::
	Gosub, locate_fu
	Return
	; funktioniert nur bei Einzelplatzinstallation unter C:\Al500_20	
	
^Down::
 	Gosub, resize_cat_window
 	Return
 	

#MaxThreadsPerHotkey 3
#z::  ; Win+Z hotkey (change this hotkey to suit your preferences).
#MaxThreadsPerHotkey 1
if KeepWinZRunning  ; This means an underlying thread is already running the loop below.
{
    KeepWinZRunning := false  ; Signal that thread's loop to stop.
    return  ; End this thread so that the one underneath will resume and see the change made by the line above.
}
; Otherwise:
KeepWinZRunning := true
   IfWinNotExist, Erwerbung
   {
   		MsgBox,48,Hinweis,Das Erwerbungsmodul ist nicht geöffnet!
   		Return
   }		
   
   IfWinNotExist, Katalog
   {
   		MsgBox,48,Hinweis,Das Katalogsierungsmodul ist nicht geöffnet!
   		Return
   }		

Loop
{
	If (A_TimeIdle > 10) ;60k milliseconds = 1 minute
		WinRestore, Katalog
		WinRestore, Erwerbung
		Sleep, 10
    ; But leave the rest below unchanged.
    if not KeepWinZRunning  ; The user signaled the loop to stop by pressing Win-Z again.
        break  ; Break out of this loop.
}
KeepWinZRunning := false  ; Reset in preparation for the next press of this hotkey.
return



	





; -----------------------------------------------------------------------------
; === Subfunctions ============================================================
; -----------------------------------------------------------------------------





rfid_etikett:
IfWinExist, ahk_class Catalog500.20.2
{
	ifWinExist, alephsig
	{
		MsgBox, 48, Hinweis, Die Etikettdatei ist noch geöffnet!
		Return
	}
	Else
	WinActivate, ahk_class Catalog500.20.2
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.20.2
	If (vis=1){
	}
	else
	{
	Send, {F8}
	Sleep, 900
	}
	Sleep, 100
	Send, {CTRLDOWN}2{CTRLUP}
  	Sleep, 100
	Send, {Alt Down}{Shift Down}
	Send, F
	Send, {Alt Up}{Shift Up}
	Sleep, 800

	start:
	IfWinActive, RFID Lese, Der Transponder wurde erfolgreich beschrieben
	{
		Send, {Enter}
		goto, transponder_ok
	}

	IfWinActive, Medienpacket, Dieser Transponder ist bereits initialisiert
	{
		loop{
		GetKeyState, state, LButton
		if state = D
			break
		GetKeyState, state, Enter
		if state = D
			break
		}
		Sleep, 500
		IfWinActive, RFID Lese, Der Transponder kann nicht beschrieben werden
		{
			goto, fehler
		}
		Sleep, 500
		goto, start

	}
		
	
	IfWinActive, Medienpacket, Es wurden mehrere Transponder gefunden
	{
		loop{
		GetKeyState, state, LButton
		if state = D
			break
		GetKeyState, state, Enter
		if state = D
			break
		}

		sleep, 500

		IfWinActive, RFID Lese, Der Transponder kann nicht beschrieben werden
		{
			goto, fehler
		}
		Else
		{
		WinWaitActive, Medienpacket

			loop{
			GetKeyState, state, LButton
			if state = D
				break
			GetKeyState, state, Enter
			if state = D
				break
			}
			IfWinActive, RFID Lese, Der Transponder kann nicht beschrieben werden
			{
				goto, fehler
			}
			Sleep, 500
			goto, start
		}
	}


	fehler:
	MsgBox, 48, Hinweis, Irgendetwas stimmt nicht!
	Return


	transponder_ok:
	WinActivate, ahk_class Catalog500.20.2 
	Send, {CTRLDOWN}2{CTRLUP}
	Sleep, 100
	Send, {Alt Down}{Shift Down}
	Send, E
	Send, {Alt Up}{Shift Up}
	Sleep, 2000
	WinWait, alephsig, , 10	
	WinActivate, alephsig
	WinWait, alephsig, , 10	
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
		KeyWait, PrintScreen, D
		Sleep, 500
		Send, {Alt}
		Send, d	
		Sleep, 100
		Send, d
		Sleep, 800
		Send, {Enter}
		MsgBox,48, Hinweis, Druckauftrag abgeschlossen, 2
		Send, {Alt}
		Sleep, 100
		Send, d
		Sleep, 800
		Send, c
		Send, n
		goto, etikett_ok
	}
 	Else
	{
		MsgBox, 48, Hinweis, Word-Datei nicht mehr aktiv. Makro abgebrochen!
		Return
	}
	etikett_ok:
	WinActivate, ahk_class Catalog500.20.2 
	Send, {CTRLDOWN}3{CTRLUP}
	Sleep, 100
	Send, {Alt Down}
	Send, 2
	Send, {Alt Up}
	Send, {Tab 14}
	Send, {Delete}
	Sleep, 100
	Send, {Enter}
	Sleep, 1200
	Send, ^{Tab}
	Sleep, 100
	Send, ^{Tab}
	Sleep, 100
	Send, {Tab}
	Sleep, 100
	Send, {Tab}
	;;SoundBeep
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return


show_item:
; zu Exemplaranzeige springen
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.20.2
	If (vis=1){
	}
	else
	{
	Send, {F8}
	Sleep, 1000
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}1{ALTUP}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return



; Nach markierten Text suchen
find_search:
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	Send, {CTRLDOWN}c{CTRLUP}
	Send, {F9}
	Sleep, 200
	Send, {UP}{UP}
	Sleep, 600
	Send, {CTRLDOWN}2{CTRLUP}{ALTDOWN}1{ALTUP}{TAB 3}
	Send, {CTRLDOWN}v{CTRLUP}
	Sleep, 100
	Send, {ENTER}
	Sleep, 800
	ControlGet, vis, Visible, , &Ansicht, ahk_class Catalog500.20.2
	If (vis=1){
	Send, !a
	}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return


internal_note_700g:
; 700g eintragen
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.20.2
	If (vis=1){
	}
	else
	{
	Send, {F8}
	Sleep, 1000
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}{TAB 6}
	Send, {END}
	GetKeyState, state, CapsLock
	if state = D
			Send, 700{SHIFTDOWN}g{SHIFTUP}
		else
		Send, 700g

	Send, {ENTER}
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return

show_index_search:
; in die Indexsuche springen
IfWinExist, ahk_class Catalog500.20.2
{
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}{TAB}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return


; auf GG stellen
item_process_status_gg:
IfWinExist, ahk_class Catalog500.20.2
{
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.20.2
	If (vis=1){
	}
	else
	{
	Send, {F8}
	Sleep, 1000
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}{TAB 14}
	Send, gg
	Send, {ENTER}
	Sleep, 1200
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}
	Send, {CTRLDOWN}{TAB 3}{CTRLUP}
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return


add_call_no_gg:
IfWinExist, ahk_class Catalog500.20.2
{
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}{TAB}
	Send, ^c
	StringUpper ,clipboard, clipboard
;    MsgBox, 4,, Soll der Text `n`t`t %clipboard% `n`n als Signatur und GG als Geschäftsgangstatus in das aktive Exemplar geschrieben werden?
	IfMsgBox No
	    return
	Send, {F8}
	Sleep, 1000
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	SLEEP, 100
	SEND, {TAB 9}{CTRLDOWN}v{CTRLUP}
	Send, {TAB 5}
	Send, gg
	loop {
		if getKeyState("ESC")
		return
		if getKeystate("ENTER")
	break
	}
	Sleep, 1200
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}
	Sleep, 100
	Send, {CTRLDOWN}{TAB 3}{CTRLUP}
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return
	
add_call_no_gg_lbs:
IfWinExist, ahk_class Catalog500.20.2
{
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}{TAB}
	Send, ^c
	StringUpper ,clipboard, clipboard
;    MsgBox, 4,, Soll der Text `n`t`t %clipboard% `n`n als Signatur und GG als Geschäftsgangstatus in das aktive Exemplar geschrieben werden?
;	IfMsgBox No
;	    return
	Send, {F8}
	Sleep, 1000
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	SLEEP, 100
	Send, {Tab 2}
	Send, lbs
	Send, {TAB 7}{CTRLDOWN}v{CTRLUP}
	Send, {TAB 4}
	Send, 07
	Send, {TAB}
	Send, gg
	loop {
		if getKeyState("ESC")
		return
		if getKeystate("ENTER")
	break
	}
	Sleep, 1200
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}
	Sleep, 100
	Send, {CTRLDOWN}{TAB 3}{CTRLUP}
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return

CutterJo:
; nach Cutter des markierten Textes suchen
IfWinExist, UB Eichstaett-Ingolstadt: Cutter Jo
{

	Send, ^c
	Replace=ÀA|ÁA|ÂA|ÃA|ÅA|ÇC|ĖE|ÈE|ÉE|ÊE|ËE|ÍI|ÌI|ÎI|ÏI|ÑN|ÒO|ÓO|ÔO|ÕO|ÙU|ÚU|ÛU|ÝY|ÐD|ÑN|àa|áa|âa|ãa|åa|âa|ǎa|çc|čc|èe|ée|êe|ëe|ìi|íi|îi|ïi|ñn|òo|óo|ôo|õo|ţt|ùu|úu|ûu|ýy|ÿy
	
	;Ôüäâïë
	
	Loop, Parse, Replace, |
	{
    StringSplit, Part, A_LoopField
	StringReplace, clipboard, clipboard, %Part1%, %Part2%, All
	}
	
	StringReplace clipboard, clipboard, Æ, Ae, All
	StringReplace clipboard, clipboard, Ä, Ae, All
	StringReplace clipboard, clipboard, Œ, Oe, All
	StringReplace clipboard, clipboard, Ø, Oe, All
	StringReplace clipboard, clipboard, Ö, Oe, All
	StringReplace clipboard, clipboard, Ü, Ue, All
	StringReplace clipboard, clipboard, æ, ae, All
	StringReplace clipboard, clipboard, ä, ae, All
	StringReplace clipboard, clipboard, œ, oe, All	
	StringReplace clipboard, clipboard, ø, oe, All
	StringReplace clipboard, clipboard, ö, oe, All
	StringReplace clipboard, clipboard, ü, ue, All
	StringReplace clipboard, clipboard, ʹ, , All
	
	WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
	SetKeyDelay, -1
	Send, ^l
	Sleep, 200
	Send, http://www.ub.ku-eichstaett.de/cgi-bin/cutterjo.pl?gugg=%clipboard%
	Sleep, 200
	Send, {Enter}

	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 

	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein Cutter Jo-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
Return


OGND_search:
IfWinExist, OGND 
{
	Send, ^c
	StringReplace ,clipboard, clipboard,|a%A_Space%,, All
	StringReplace ,clipboard, clipboard,RETRO!!!%A_Space%,, All


	WinActivate, OGND
	SetKeyDelay, -1
	Send, ^l
	Send, http://swb.bsz-bw.de/DB=2.104/SET=2/TTL=1/CMD?retrace=0&trm_old=&ACT=SRCHA&IKT=2072&TRM=%clipboard%
	Sleep, 100
	Send, {Enter}
	
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein OGND-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
Return

sig_search:
IfWinExist, ahk_class Catalog500.20.2
{
	Send, {ESC}
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.20.2
	If (vis=1){
	}
	else
	{
	Send, {F8}
	Sleep, 1000
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	Sleep, 100
	Send, {TAB 9}
	Sleep, 100
	Send, {CTRLDOWN}c{CTRLUP}
	Sleep, 100
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}{TAB}
	Send, {CTRLDOWN}v{CTRLUP}
	Send, {Enter}
	Sleep, 800
	Send, {CTRLDOWN}{TAB 4}{CTRLUP}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
Return

Push2_cat_b3kat:
IfWinExist, ahk_class Catalog500.20.2
{
	Send, ^c
	WinActivate, ahk_class Catalog500.20.2 
;	MsgBox, 48, test
	send, ^5
;	ControlFocus, Edit53, Katalogisierung,	
	Send, ^v
	Send, {Enter}
	Sleep, 500 
	Send, !l
	Sleep, 400
	Send, b
	Sleep, 400
	Send, !l
	Sleep, 500
	Send, !s
	Sleep, 500
	Send, !w
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return

	
Push2_cat_items:
IfWinExist, ahk_class Catalog500.20.2
{
	Send, ^c
	WinActivate, ahk_class Catalog500.20.2
	send, ^6
;	ControlFocus, Edit53, Katalogisierung,
	Send, a
	Send, s
	Send, {Tab}
	Send, ^v
	Send, {Enter}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDieses scheint nicht der Fall zu sein!
	Return
	

	
	

Push2_acq:
IfWinExist, ahk_class Acquisition500.20.2
{
	Send, ^c
	WinActivate, ahk_class Acquisition500.20.2 
	Send, {F2}
    Sleep, 1000
    Send, ^{TAB}^{TAB}^{TAB}
    Sleep, 500
    Send, {TAB}{TAB}b{TAB}
	Send, ^v
	Send, {Enter}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Erwerbungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return


locate_bv:
IfWinExist, ahk_class Catalog500.20.2
{
	WinActivate, ahk_class Catalog500.20.2
	IniWrite, BVB01, C:\AL500_20\alephcom\TAB\Guisys.ini, SearchLocate, SelectedBase 
	Send, {F9}
	Sleep, 200
	Send, ^{Tab}
	Sleep, 100
	Send, ^{Tab}
	Sleep, 100
	Send, !+l
	Sleep, 200
	Send, {Enter}
	Sleep, 500
	Send, {F9}
	Sleep, 500
	Send, ^{Tab}
	Sleep, 200
	Send, !a
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDieses scheint nicht der Fall zu sein!
	Return

locate_fu:
IfWinExist, ahk_class Catalog500.20.2
{
	WinActivate, ahk_class Catalog500.20.2
	IniWrite, FUB01, C:\AL500_20\alephcom\TAB\Guisys.ini, SearchLocate, SelectedBase 
	Send, {F9}
	Sleep, 200
	Send, ^{Tab}
	Sleep, 100
	Send, ^{Tab}
	Sleep, 100
	Send, !+l
	Sleep, 200
	Send, {Enter}
	Sleep, 500
	Send, {F9}
	Sleep, 500
	Send, ^{Tab}
	Sleep, 200
	Send, !a

	Return


}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDieses scheint nicht der Fall zu sein!
	Return

	
top_mozilla:
	WinSet, AlwaysOnTop, Toggle, ahk_class MozillaWindowClass
	Return	

top_excel:
	WinSet, AlwaysOnTop, Toggle, Microsoft Excel
	Return	


resize_cat_window:
	WinRestore, Katalog
	ResizeWin(1280,960)
	Return

	


