;
; AutoHotkey Version: 1.x
; Language:       English
; Platform:       Win9x/NT
; Author:         A.N.Other <myemail@nowhere.com>
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

ScriptName         = 24in1
ScriptNameClean    = Aleph Shortcuts
ScriptVersion      = 2.4

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
   Gui, 1:Font,S9, Lucida Console
   Gui, 1:Add, Text,, <ALT>+C  -  Sucht einen zuvor markierten Text mit Cutter Jo.
;   Gui, 1:Add, Text,, <WIN>+C  -  Sucht einen den Autor (ohne markieren) mit Cutter Jo.
   Gui, 1:Add, Text,, <ALT>+D  -  Springt zur Indexsuche in Aleph.    
   Gui, 1:Add, Text,, <ALT>+E  -  Schreibt GG als Geschäftsgangstatus im Exemplarsatz und springt zu Strichcode.    
   Gui, 1:Add, Text,, <ALT>+G  -  Trägt 700g in die Interne Notiz des Exemplarsatzes ein.    
   Gui, 1:Add, Text,, <ALT>+O  -  Sucht einen zuvor markierten Text in der OGND.  
   Gui, 1:Add, Text,, <ALT>+Y  -  Sucht einen zuvor markierten Text in RVK-Online. 
   Gui, 1:Add, Text,, <ALT>+W  -  Sucht in der Indexsuche nach der vergebenen Signatur. 
   Gui, 1:Add, Text,, <ALT>+Q  -  Aktiviert Exemplaranzeige. 
   Gui, 1:Add, Text,, <WIN>+Q  -  Springt zu Strichcode.
   Gui, 1:Add, Text,, <ALT>+R  -  RFID beschreiben, Etikett erstellen und Status auf Verfügbar stellen.`n            Word wartet mit dem Etikettdruck bis die Druck-Taste (Print) gedrückt wird.
   Gui, 1:Add, Text,, <ALT>+S  -  Sucht einen zuvor markierten Text über die "Einfache Suche". 
   Gui, 1:Add, Text,, <WIN>+S  -  Sucht nach dem Autor des aktuelle Datensatzes (ohne markieren) über die "Einfache Suche". 
   Gui, 1:Add, Text,, <ALT>+F  -  Kopiert den Text der Indexsuche in das Signaturfeld, schreibt GG als`n            Geschäftsgangstatus in den Exemplarsatz und springt zu Strichcode.
   Gui, 1:Add, Text,, <WIN>+F  -  Wie <ALT>+F nur das an eine Signatur z.B. UC 100 M766 ein +2 ängehängt wird`n            bzw. eine Exemplarnummer um eins hochgezählt wird.
   Gui, 1:Add, Text,, <Win>+<ALT>+F  -  Wie <WIN>+F  aber anstatt +2 wird -2 angehängt
   Gui, 1:Add, Text,, <ALT>+B  -  Kopiert den Text der Indexsuche in das Signaturfeld, schreibt GG als`n            Geschäftsgangstatus in den Exemplarsatz, ändert Standort zu LBS und springt zu Strichcode.
   Gui, 1:Add, Text,, <WIN>+B  -  Wie <ALT>+B nur das an eine Signatur z.B. UC 100 M766 ein +2 ängehängt wird`n            bzw. eine Exemplarnummer um eins hochgezählt wird.
   Gui, 1:Add, Text,, <ALT>+X  -  Sucht einen zuvor markierten Text in einer geöffneten Excel-Tabelle.
   Gui, 1:Add, Text,, <F11>  -  Sucht Autor Cutter in Cutter-Joe, kopiert Cutter in die Zwischenablage.`n            Sucht dann nach Autor in einfacher Suche. Mit F12 kopiert man eine markierte RVK (z.B. ST 200),`n            diese wird mit dem Cutter kombiniert in der Indexsuche gesucht.
   Gui, 1:Add, Text,, <F4>  -  Sucht Autor Cutter in Cutter-Joe und Signatur in Indexsuche.
   Gui, 1:Add, Text,, --------------------------------------------------------------------------------------------------------------
   Gui, 1:Add, Text,, <STRG>+<WIN>+6: `n     - Lädt einen Exemplarsatz in der Exemplarverwaltung der Katalogisierung anhand `n       des zuvor in einem anderen Programm markierten Barcodes.
   Gui, 1:Add, Text,, <STRG>+<WIN>+l: `n     - Lädt über die Systemnummer einen FUB01-Datensatz in der Katalogisierung, lokalisiert `n       ihn im B3Kat und öffnet abschliessend den BVB01-Satz. 
   Gui, 1:Add, Text,, <STRG>+<WIN>+o: `n     - Lädt über die Bestellnummer einen Bestellsatz im Erwerbungsmodul. 
   Gui, 1:Add, Text,, <ALT>+<WIN>+b in Aleph-Dienstrecherche: `n     - Lokalisieren in BVB01
   Gui, 1:Add, Text,, <ALT>+<WIN>+f in Aleph-Dienstrecherche: `n     - Lokalisieren in FUB01 
   ;Gui, 1:Add, Text,, --------------------------------------------------------------------------------------------------------------
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
   Gui, 2:Add, Text,, Strichcode einscannen und die Inventarnummer vergleichen. Autor markieren und <ALT>+C drücken um den markierten Text in Cutter Joe einzufügen. Dazu muss Cutter Joe in einem Firefox Fenster geöffnet und der Cutter Joe Tab`nmuss aktiv sein. Am besten ist es Cutter Joe in einen separaten Fenster zu öffnen, dieses wird dann Automatisch vom Makro aktiviert.`nDa das Makro danach direkt wieder zu Aleph springt bietet es sich an das Katalog-Fenster so zu verkleinern, dass am linken Rand etwas Platz ist um das Firefox-Fenster sehen zu können, wenn es sich im Hintergrund befindet.`nMit <ALT>+S such man dann einen einen markierten text, z.B. Autor oder Titel, in der einfachen Suche. Der markierte Text wird in das oberste der drei Suchfelder eingefügt.`nIst für das Buch noch keine RVK vergeben wird mit <ALT>+g "700g" in die Interne Notiz geschrieben. Nachdem man den Dublettencheck usw. durchgeführt hat, kann man mit <ALT>+D zur Indexsuche wechseln und nach der zu`nvergebenden Signatur suchen. Es ist nicht notwendig Großbuchstaben zu verwenden die Signatur kann auch etwa so aussehen us 1000 o91. Ist die Signatur nur einmal vorhanden wird sie mit <ALT>+F aus dem Indexsuchenfeld`nkopiert und in das Signaturfeld eigefügt. Danach wird der Exemplarstatus auf GG gestellt und gewartet bis Sie entweder ENTER oder ESC zum Bestätigen bzw. Abbrechen drücken. Nachdem ENTER gedrückt wurde sprigt das Makro`nin das Strichcodefeld.

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

add=0 ; Globale Variable für den +n cutter

;esc::exitapp

!r::
	Gosub, rfid_etikett
	Return
	
!s::
	Gosub, find_search
	Return

#s::	
	Gosub, find_search_o
	Return

!q::
	; zu Exemplaranzeige springen
	Gosub, show_item
	Return
	
#q::
	; zu Strichcode springen
	Gosub, go_barcode
	Return

!c::
	; Cutter Jo Suchanfrage
	Gosub, CutterJo
	Return

;#c::
	; nach Cutter des Autoren suchen	
;	GoSub, CutterJo_o
;	Return
	
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
	cnt=0
	add=0
	Gosub, add_call_no_gg
	Return
	
#f::
	; auf GG stellen, mit +n cutter
	add=1
	Gosub, add_call_no_gg
	Return
	
!#f::
	; auf GG stellen und Standort in LBS ändern, mit +n cutter
	cnt=1
	Gosub, add_call_no_gg
	Return

^#f::
	; auf GG stellen, mit Excelliste
	add=0
	cnt=0
	Gosub, add_call_no_gg_ex
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
	
#w::
	; vergebene Signatur in Indexsuche kopieren, ein Buch nach oben in Liste und suchen
	GoSub, sig_search_rev
	Return	
	
!y::
	; markierten Text in RVK-Online suchen
	GoSub, RVK_search
	Return
	
!b::
	; auf GG stellen und Standort in LBS ändern
	Gosub, add_call_no_gg_lbs
	Return
	
#b::
	; auf GG stellen und Standort in LBS ändern, mit +n cutter
	add=1
	Gosub, add_call_no_gg_lbs
	Return
	

!x::
	; markierten Text im Excel suchen
	Gosub, Excel_search
	Return
	
f11::
	;Automatisiert suchen und Cutter bilden
	GoSub, full_search
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

;#!f::
;	Gosub, locate_fu
;	Return
	; funktioniert nur bei Einzelplatzinstallation unter C:\Al500_20	
	
^Down::
 	Gosub, resize_cat_window
 	Return
 	
;^!x:: ; Funktioniert, aber im Hinergrund
;	ControlClick, Custom14, Katalog
;	Send, test
;	Return


	
	
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

wait:
	stat =
	DetectHiddenText, On
	Send, {ENTER}
	StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
	While (stat = ""){

		StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
		While (stat <>  ""){ 

			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
			if (stat = ){
				goto, ex5
			}
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
			if (stat = ){
				goto, ex5
			}
		}
		Sleep, 50
	}
	ex5:
	While (stat <> ""){
		StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
		
		While (stat = ""){ 
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
			if (stat <> ){
				goto, ex5
			}
			else {
				goto, ex25
			}
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
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
	GoSub, wait
	Sleep, 500

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
	MsgBox, 48, Hinweis, Ein Fehler ist aufgetreten, das Makro wird abgebrochen.
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
		Send, u
		Sleep, 100
		Send, u	
		MsgBox,48, Hinweis, Druckauftrag abgeschlossen, 2
		Send, {Alt}
		Sleep, 100
		Send, d
		Sleep, 100
		Send, l
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
	Send, {Enter}
	GoSub, wait
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

full_search:
IfWinExist, UB Eichstaett-Ingolstadt: Cutter Jo
{
	SetKeyDelay, -1
	
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
	WinGet, ActiveControlList, ControlList, A
	Loop, Parse, ActiveControlList, `n
	{
	ControlGetText, str, %A_LoopField%, ahk_class Catalog500.20.2
	StringLeft, strt, str, 3
		if (strt = "TIT") {
		fld = %A_LoopField%
		}
	}
	
	ControlGetText, str, %fld%, ahk_class Catalog500.20.2
	;MsgBox, %str%
	StringGetPos, posL, str, %A_Space%, L2
	StringGetPos, posR, str, %A_Space%, R2
	posL +=1
	StringLeft, stat, str, %posR%
	StringTrimLeft, stat, stat, %posL%
	StringGetPos, pos, stat, :
	StringLeft, auth, stat, %pos%
	pos+=2
	StringTrimLeft, tit, stat, %pos%
	StringTrimRight, tit, tit, 7
	
	Replace=ÀA|ÁA|ÂA|ÃA|ÅA|ÇC|ÈE|ÉE|ÊE|ËE|ÍI|ÌI|ÎI|ÏI|ÑN|ÒO|ÓO|ÔO|ÕO|ŠS|ÙU|ÚU|ÛU|ÝY|ÐD|ÑN|ŽZ|àa|áa|âa|ãa|åa|âa|aa|çc|cc|cc|èe|ée|êe|ëe|gg|ìi|íi|îi|ïi|ñn|òo|óo|ôo|õo|šs|ss|tt|ùu|úu|ûu|ýy|ÿy|'*|'*
	
	;Ôüäâïë
	
	Loop, Parse, Replace, |
	{
    StringSplit, Part, A_LoopField
	StringReplace, auth, auth, %Part1%, %Part2%, All
	}
	
	StringReplace auth, auth, ß, ss, All
	StringReplace auth, auth, Æ, Ae, All
	StringReplace auth, auth, Ä, Ae, All
	StringReplace auth, auth, Œ, Oe, All
	StringReplace auth, auth, Ø, Oe, All
	StringReplace auth, auth, Ö, Oe, All
	StringReplace auth, auth, Ü, Ue, All
	StringReplace auth, auth, æ, ae, All
	StringReplace auth, auth, ä, ae, All
	StringReplace auth, auth, œ, oe, All	
	StringReplace auth, auth, ø, oe, All
	StringReplace auth, auth, ö, oe, All
	StringReplace auth, auth, ü, ue, All
	StringReplace auth, auth, *, , All
	
	
	WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
	SetKeyDelay, -1
	Send, ^l
	Sleep, 200
	Send, http://www.ub.ku-eichstaett.de/cgi-bin/cutterjo.pl?gugg=%auth%
	Sleep, 200
	Send, {Enter}
	Sleep, 500
	Send, {TAB}
	Sleep, 100
	Send, ^a
	Sleep, 100
	Send, ^c
	Sleep, 200
	Send, ^l
	Sleep, 200
	Send, {Enter}
	

	Loop, parse, clipboard, `n, `r
	{
	If (A_Index == 7) {
    csn = %A_LoopField%
	}
	}
	
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
	
	Send, {F9}
	Sleep, 200
	Send, {UP}{UP}
	Sleep, 600
	Send, {CTRLDOWN}2{CTRLUP}
	Sleep, 100
	Send, {ALTDOWN}1{ALTUP}
	Sleep, 100
	Send,{TAB 3}
	Sleep, 100
	Send, %auth%
	Sleep, 100
	Send, {ENTER}
	;Sleep, 800
	GoSub, wait
	ControlGet, vis, Visible, , &Ansicht, ahk_class Catalog500.20.2
	If (vis=1){
	Send, !a
	}
	
	KeyWait, F12, D

	Send, ^c
	Sleep, 100
	;StringTrimRight, clipboard, clipboard, 2
	rvk=%clipboard%
	
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}
	Sleep, 100
	Send, {TAB}
	Send, %rvk%%A_Space%%csn%
	Sleep, 100
	Send, {Enter}
	

	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein Cutter Jo-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
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
	GoSub, wait
	Sleep, 500
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}1{ALTUP}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return

go_barcode:
; zu Barcode springen
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
	Send, {CTRLDOWN}3{CTRLUP}
	Sleep, 100
	Send, ^{TAB}
	Sleep, 100
	Send, {TAB 2}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return

; Nach markierten Text suchen
find_search:
IfWinExist, ahk_class Catalog500.20.2
{
	Send, ^c
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2,
	Send, {F9}
	Sleep, 200
	Send, {UP}{UP}
	Sleep, 600
	Send, {CTRLDOWN}2{CTRLUP}{ALTDOWN}1{ALTUP}{TAB 3}
	Send, {CTRLDOWN}v{CTRLUP}
	Sleep, 100
	Send, {ENTER}
	;Sleep, 800
	GoSub, wait
	ControlGet, vis, Visible, , &Ansicht, ahk_class Catalog500.20.2
	If (vis=1){
	Send, !a
	}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return

; Nach markierten Text suchen
find_search_o:
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2,
	
	WinGet, ActiveControlList, ControlList, A
	Loop, Parse, ActiveControlList, `n
	{
	ControlGetText, str, %A_LoopField%, ahk_class Catalog500.20.2
	StringLeft, strt, str, 3
		if (strt = "TIT") {
		fld = %A_LoopField%
		}
	}
	
	ControlGetText, str, %fld%, ahk_class Catalog500.20.2
	StringGetPos, posL, str, %A_Space%, L2
	StringGetPos, posR, str, %A_Space%, R2
	posL +=1
	StringLeft, stat, str, %posR%
	StringTrimLeft, stat, stat, %posL%
	StringGetPos, pos, stat, :
	StringLeft, auth, stat, %pos%
		
	Send, {F9}
	Sleep, 200
	Send, {UP}{UP}
	Sleep, 600
	Send, {CTRLDOWN}2{CTRLUP}{ALTDOWN}1{ALTUP}{TAB 3}
	Send, %auth%
	Sleep, 100
	Send, {ENTER}
	;Sleep, 800
	GoSub, wait
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
	GoSub, wait
	Sleep, 500
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
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}
	Sleep, 100
	Send, {TAB}
	;	loop{
	;	GetKeyState, state, LButton
	;	if state = D
	;		break
	;	GetKeyState, state, Enter
	;	if state = D
	;		break
	;	}		
	;Sleep, 400
	;Send, ^2
	;Send, {TAB 2}
	;Send, ^c
	;a = %clipboard%
	;Send, {TAB 8}
	;Send, {DOWN}
	;Sleep, 300
	SetMouseDelay, -1
	;MouseGetPos, xpos, ypos 
	;ControlGetPos, x, y, w, h, ListBox9, ahk_class Catalog500.20.2
	
	;x := x + 120
	;y := y + h/20
	;MouseMove, %x%, %y%
	;DllCall("SetCursorPos", "int", x, "int", y)
	;MouseClick
	;Sleep, 300
	;Send, ^c
	;MouseMove, %xpos%, %ypos% 
	;MsgBox,48, Hinweis, %clipboard%
	;If (a == clipboard) {
	;MsgBox, 48, Hinweis, Signatur vergeben!
	;}
	;clipboard = %a%
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return


; auf GG stellen
item_process_status_gg:
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
	GoSub, wait
	Sleep, 500
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}{TAB 14}
	Send, gg
	Send, {ENTER}
	;Sleep, 1200
	GoSub, wait
	Send, {Down}
	;Sleep, 1000
	GoSub, wait
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
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 	
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}{TAB}
	Send, ^c
	StringUpper ,clipboard, clipboard
	
	if (add=1){
		StringLen, length, clipboard
		IfInString, clipboard, +
		{
			StringRight, num, clipboard, 1
			StringLeft, clipboard, clipboard, length-1			
			num:=num+1			
			clipboard=%clipboard%%num%
		} else
		{
			num:="+2"
			clipboard=%clipboard%%num%
		}
		Send, {CTRLDOWN}v{CTRLUP}
	}
	
	if (cnt=1){
		StringLen, length, clipboard
		IfInString, clipboard, -
		{
			StringRight, num, clipboard, 1
			StringLeft, clipboard, clipboard, length-1			
			num:=num+1			
			clipboard=%clipboard%%num%
		} else
		{
			num:="-2"
			clipboard=%clipboard%%num%
		}
		Send, {CTRLDOWN}v{CTRLUP}
	}
	
	
;    MsgBox, 4,, Soll der Text `n`t`t %clipboard% `n`n als Signatur und GG als Geschäftsgangstatus in das aktive Exemplar geschrieben werden?
	IfMsgBox No
	    return
	Send, {F8}
	Sleep, 300
	GoSub, wait
	Sleep, 500
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	SLEEP, 100
	SEND, {TAB 9}{CTRLDOWN}v{CTRLUP}
	Send, {TAB 5}
	Send, gg
	Sleep, 100
	Send, {SHIFTDOWN}{TAB 5}{SHIFTUP}
	Send, {END}
	loop {
		if getKeyState("ESC")
		return
		if getKeystate("ENTER")
	break
	}
	;Sleep, 1200
	GoSub, wait
	
	if (add=1){	
		Send, {Down} 
		;Sleep, 1000
		GoSub, wait
	}
	
	Sleep, 200
	Send, {CTRLDOWN}3{CTRLUP}
	Sleep, 100
	Send, {ALTDOWN}3{ALTUP}
	Sleep, 100
	Send, {CTRLDOWN}{TAB 3}{CTRLUP}
	add=0
	cnt=0
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return	
	

add_call_no_gg_ex:
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 	
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}{TAB}
	Send, ^c
	StringUpper ,clipboard, clipboard
	
	if (add=1){
		StringLen, length, clipboard
		IfInString, clipboard, +
		{
			StringRight, num, clipboard, 1
			StringLeft, clipboard, clipboard, length-1			
			num:=num+1			
			clipboard=%clipboard%%num%
		} else
		{
			num:="+2"
			clipboard=%clipboard%%num%
		}
		Send, {CTRLDOWN}v{CTRLUP}
	}
	
	if (cnt=1){
		StringLen, length, clipboard
		IfInString, clipboard, -
		{
			StringRight, num, clipboard, 1
			StringLeft, clipboard, clipboard, length-1			
			num:=num+1			
			clipboard=%clipboard%%num%
		} else
		{
			num:="-2"
			clipboard=%clipboard%%num%
		}
		Send, {CTRLDOWN}v{CTRLUP}
	}
	
	
;    MsgBox, 4,, Soll der Text `n`t`t %clipboard% `n`n als Signatur und GG als Geschäftsgangstatus in das aktive Exemplar geschrieben werden?
	IfMsgBox No
	    return
	Send, {F8}
	Sleep, 100
	GoSub, wait
	Sleep, 500
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	SLEEP, 100
	SEND, {TAB 9}{CTRLDOWN}v{CTRLUP}
	Send, {TAB 5}
	Send, gg
	Sleep, 100
	Send, {SHIFTDOWN}{TAB 5}{SHIFTUP}
	Send, {END}
	loop {
		if getKeyState("ESC")
		return
		if getKeystate("ENTER")
	break
	}
	;Sleep, 1200
	GoSub, wait
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	SLEEP, 100
	SEND, {TAB 9}{CTRLDOWN}c{CTRLUP}
	
	StringGetPos, a, clipboard, %A_Space%, L2
	StringLeft, rvk, clipboard, %a%
	a := a+1
	StringTrimLeft, cutter, clipboard, %a%
	
	excel := ComObjActive("Excel.Application")

	workBook  := excel.ActiveWorkbook
	currentSheet := excel.ActiveSheet
	cell := excel.ActiveCell 

	cell.Value := rvk . "`n" . cutter
	
	Sleep, 100
	
	excel.ActiveWorkbook.PrintOut()
		
	Send, ^2
	if (add=1){	
		Send, {Down} 
		;Sleep, 1000
		GoSub, wait
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}
	Sleep, 100
	Send, {CTRLDOWN}{TAB 3}{CTRLUP}
	add=0
	cnt=0
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
	Return
	
add_call_no_gg_lbs:
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 	
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}{TAB}
	Send, ^c
	StringUpper ,clipboard, clipboard
	
	if (add=1){
		StringLen, length, clipboard
		IfInString, clipboard, +
		{
			StringRight, num, clipboard, 1
			StringLeft, clipboard, clipboard, length-1			
			num:=num+1			
			clipboard=%clipboard%%num%
		} else
		{
			num:="+2"
			clipboard=%clipboard%%num%
		}
		Send, {CTRLDOWN}v{CTRLUP}
	}
	
;    MsgBox, 4,, Soll der Text `n`t`t %clipboard% `n`n als Signatur und GG als Geschäftsgangstatus in das aktive Exemplar geschrieben werden?
;	IfMsgBox No
;	    return
	Send, {F8}
	GoSub, wait
	Sleep, 500
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
	if (add=1){	
		Send, {Down}
		Sleep, 1000
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}
	Sleep, 100
	Send, {CTRLDOWN}{TAB 3}{CTRLUP}
	add=0
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
	
	Replace=ÀA|ÁA|ÂA|ÃA|ÅA|ÇC|ÈE|ÉE|ÊE|ËE|ÍI|ÌI|ÎI|ÏI|ÑN|ÒO|ÓO|ÔO|ÕO|ŠS|ÙU|ÚU|ÛU|ÝY|ÐD|ÑN|ŽZ|àa|áa|âa|ãa|åa|âa|ǎa|çc|čc|ćc|èe|ée|êe|ëe|ğg|ìi|íi|îi|ïi|ñn|òo|óo|ôo|õo|šs|şs|ţt|ùu|úu|ûu|ýy|ÿy|'*|ʹ*
	
	;ĖE|
	
	Loop, Parse, Replace, |
	{
    StringSplit, Part, A_LoopField
	StringReplace, clipboard, clipboard, %Part1%, %Part2%, All
	}
	
	StringReplace clipboard, clipboard, ß, ss, All
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
	StringReplace clipboard, clipboard, *, , All
	
	
	WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
	SetKeyDelay, -1
	Send, ^l
	Sleep, 200
	Send, http://www.ub.ku-eichstaett.de/cgi-bin/cutterjo.pl?gugg=%clipboard%
	Sleep, 200
	Send, {Enter}
;	Sleep, 200
;	Send, {TAB}
;	Sleep, 100
;	Send, ^a
;	Sleep, 100
;	Send, ^c
;	Sleep, 200
;	Send, ^l
;	Sleep, 200
;	Send, {Enter}

;	Loop, parse, clipboard, `n, `r
;	{
;	If (A_Index == 7) {
;   clipboard = %A_LoopField%
;	}
;	}
	
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 

	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein Cutter Jo-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
Return

CutterJo_o:
; nach Cutter des Autoren suchen
IfWinExist, UB Eichstaett-Ingolstadt: Cutter Jo
{

	ControlGetText, clipboard, Static87, ahk_class Catalog500.20.2
	StringGetPos, a, clipboard, :
	StringGetPos, b, clipboard, Druck-Konfiguration
	if (b != -1) {
	ControlGetText, clipboard, Static93, ahk_class Catalog500.20.2
	StringGetPos, a, clipboard, :
	}
	a := a - 13
	StringMid, clipboard, clipboard, 14 , %a%
	
	Replace=ÀA|ÁA|ÂA|ÃA|ÅA|ÇC|ÈE|ÉE|ÊE|ËE|ÍI|ÌI|ÎI|ÏI|ÑN|ÒO|ÓO|ÔO|ÕO|ŠS|ÙU|ÚU|ÛU|ÝY|ÐD|ÑN|ŽZ|àa|áa|âa|ãa|åa|âa|ǎa|çc|čc|ćc|èe|ée|êe|ëe|ğg|ìi|íi|îi|ïi|ñn|òo|óo|ôo|õo|šs|şs|ţt|ùu|úu|ûu|ýy|ÿy|'*|ʹ*
	
	;Ôüäâïë
	
	Loop, Parse, Replace, |
	{
    StringSplit, Part, A_LoopField
	StringReplace, clipboard, clipboard, %Part1%, %Part2%, All
	}
	
	StringReplace clipboard, clipboard, ß, ss, All
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
	StringReplace clipboard, clipboard, *, , All
	
	
	WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
	SetKeyDelay, -1
	Send, ^l
	Sleep, 200
	Send, http://www.ub.ku-eichstaett.de/cgi-bin/cutterjo.pl?gugg=%clipboard%
	Sleep, 200
	Send, {Enter}
;	Sleep, 200
;	Send, {TAB}
;	Sleep, 100
;	Send, ^a
;	Sleep, 100
;	Send, ^c
;	Sleep, 200
;	Send, ^l
;	Sleep, 200
;	Send, {Enter}

;	Loop, parse, clipboard, `n, `r
;	{
;	If (A_Index == 7) {
;   clipboard = %A_LoopField%
;	}
;	}
	
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

RVK_search:
IfWinExist, RVK 
{
	Send, ^c
	
	StringReplace, clipboard, clipboard, %A_Space%, +, All
	
	clipboard = http://rzbvm001.uni-regensburg.de/sepp/rvko_neu/mytree.phtml?not_s=%clipboard%
	
	WinActivate, RVK
	SetKeyDelay, -1
	Send, ^l
	Send, ^v
	Sleep, 100
	Send, {Enter}
	
	return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein RVK-Online-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
Return


sig_search:
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
	Send, {ESC}
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.20.2
	If (vis=1){
	}
	else
	{
	Send, {F8}
	GoSub, wait
	Sleep, 500
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	Sleep, 100
	Send, {TAB 9}
	Sleep, 100
	Send, {CTRLDOWN}c{CTRLUP}
	Sleep, 100
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}3{ALTUP}

	;ControlGetText, clipboard, Edit24, ahk_class Catalog500.20.2
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}
	Send, a
	Send, s
	Send, {TAB}
	Send, {CTRLDOWN}v{CTRLUP}
	Send, {Enter}
	;Sleep, 800
	GoSub, wait
	Send, {CTRLDOWN}{TAB 4}{CTRLUP}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
Return

sig_search_rev:
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
	Send, {ESC}
	ControlGet, vis, Visible, , &Etikett, ahk_class Catalog500.20.2
	If (vis=1){
	}
	else
	{
	Send, {F8}
	GoSub, wait
	Sleep, 500
	}
	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	Sleep, 100
	Send, {TAB 9}
	Sleep, 100
	Send, {CTRLDOWN}c{CTRLUP}
	Sleep, 100
	Send, {CTRLDOWN}2{CTRLUP}
	Sleep, 100
	Send, {UP}
	GoSub, wait
	Sleep, 500
	Send, {F9}
	Sleep, 200
	Send, {DOWN}{DOWN}{UP}
	Sleep, 800
	Send, {CTRLDOWN}2{CTRLUP}{TAB}
	Send, a
	Send, s
	Send, {TAB}
	Send, {CTRLDOWN}v{CTRLUP}
	Send, {Enter}
	;Sleep, 800
	GoSub, wait
	Send, {CTRLDOWN}{TAB 4}{CTRLUP}
	Return
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn das Katalogisierungs-Modul aktiv ist!`nDies scheint nicht der Fall zu sein!
Return

Excel_search:
IfWinExist, ahk_class Catalog500.20.2
{
	Send, {CTRLDOWN}c{CTRLUP}
	WinActivate, Microsoft Excel
	SetKeyDelay, -1
	Sleep, 100
	Send, {CTRLDOWN}f{CTRLUP}
	Sleep, 100
	Send, {ESC}
	Sleep, 100
	Send, {CTRLDOWN}f{CTRLUP}
	Sleep, 100
	;ControlClick, EDTBX1, Suchen
	Send,{CTRLDOWN}v{CTRLUP}{ALTDOWN}l{ALTUP}
	
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

f4::
IfWinExist, UB Eichstaett-Ingolstadt: Cutter Jo
{
	SetKeyDelay, -1
	
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
	WinGet, ActiveControlList, ControlList, A
	Loop, Parse, ActiveControlList, `n
	{
	ControlGetText, str, %A_LoopField%, ahk_class Catalog500.20.2
	StringLeft, strt, str, 3
		if (strt = "TIT") {
		fld = %A_LoopField%
		}
	}
	
	ControlGetText, str, %fld%, ahk_class Catalog500.20.2
	StringGetPos, posL, str, %A_Space%, L2
	StringGetPos, posR, str, %A_Space%, R2
	posL +=1
	StringLeft, stat, str, %posR%
	StringTrimLeft, stat, stat, %posL%
	StringGetPos, pos, stat, :
	StringLeft, auth, stat, %pos%
	pos+=2
	StringTrimLeft, tit, stat, %pos%
	StringTrimRight, tit, tit, 7
	
	Replace=ÀA|ÁA|ÂA|ÃA|ÅA|ÇC|ÈE|ÉE|ÊE|ËE|ÍI|ÌI|ÎI|ÏI|ÑN|ÒO|ÓO|ÔO|ÕO|ŠS|ÙU|ÚU|ÛU|ÝY|ÐD|ÑN|ŽZ|àa|áa|âa|ãa|åa|âa|aa|çc|cc|cc|èe|ée|êe|ëe|gg|ìi|íi|îi|ïi|ñn|òo|óo|ôo|õo|šs|ss|tt|ùu|úu|ûu|ýy|ÿy|'*|'*
	
	;Ôüäâïë
	
	Loop, Parse, Replace, |
	{
    StringSplit, Part, A_LoopField
	StringReplace, auth, auth, %Part1%, %Part2%, All
	}
	
	StringReplace auth, auth, ß, ss, All
	StringReplace auth, auth, Æ, Ae, All
	StringReplace auth, auth, Ä, Ae, All
	StringReplace auth, auth, Œ, Oe, All
	StringReplace auth, auth, Ø, Oe, All
	StringReplace auth, auth, Ö, Oe, All
	StringReplace auth, auth, Ü, Ue, All
	StringReplace auth, auth, æ, ae, All
	StringReplace auth, auth, ä, ae, All
	StringReplace auth, auth, œ, oe, All	
	StringReplace auth, auth, ø, oe, All
	StringReplace auth, auth, ö, oe, All
	StringReplace auth, auth, ü, ue, All
	StringReplace auth, auth, *, , All
	
	WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
	SetKeyDelay, -1
	Send, ^l
	Sleep, 200
	Send, http://www.ub.ku-eichstaett.de/cgi-bin/cutterjo.pl?gugg=%auth%
	Sleep, 100
	Send, {Enter}
	Send, !w
	}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein Cutter Jo-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
return

