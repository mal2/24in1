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
   Gui, 1:Add, Text,, <ALT>+G  -  Druckt Excel Laufzettel mit GRÜNEM Etikett.
   Gui, 1:Add, Text,, <STRG>+<ALT>+G  -  Druckt Excel Laufzettel mit KOMPLETT GRÜNEM Etikett.
   Gui, 1:Add, Text,, <ALT>+W  -  Druckt Excel Laufzettel mit WIESSEM Etikett.
   Gui, 1:Add, Text,, <ALT>+R  -  Druckt Excel Laufzettel mit ROTEM Etikett.

   
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