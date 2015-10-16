SetWinDelay, 0
SetControlDelay, 0
SetTitleMatchMode,1

ScriptName         = Umsigelung
ScriptNameClean    = Aleph_sig
ScriptVersion      = 1.1

IfWinExist, ahk_class Catalog500.22.0
{
		WinActivate, ahk_class Catalog500.22.0
		InputBox, siegel, Sigel, Bitte Sigel der nehmenden Bibliothek eigeben.
	if ErrorLevel
		EXIT
	else
		While (true) {
			WinActivate, ahk_class Catalog500.22.0
			InputBox,  barcode, Barcode, Bitte Barcode einscannen
		if ErrorLevel
			EXIT	
		else
			Send, {CTRLDOWN}3{CTRLUP}
			Send, ^{TAB}
			Send, {TAB 2}
			Send, {DEL 20}
			Send, %barcode%
		Sleep, 100
			Send, {Enter}	
		clipboard =
		Gosub, wait
		Sleep, 200
			Send, ^3
			Send, !2
			Send, {TAB}
			Send, ^c
			ClipWait
		Sleep, 100
		siegel_alt = %clipboard%
			Send, %siegel%
		Sleep, 100
			Send, {TAB}
		if (siegel = "726") {
			Send, F-RVK
		} 
		if (siegel = "871") {
			Send, MAG-O
		} 
		if (siegel = "822") {
			Send, MAG-O
		} 
		if (siegel = "867") {
			Send, MAG-O
		} 
		if (siegel = "885") {
			Send, MAG-O
		} 
		if (siegel = "896") {
			Send, MAG-O
		} 
		if (siegel = "912") {
			Send, MAG-O
		} 	
		else {
			Send, LS
		}
		Sleep, 100
			Send, {Tab 11}
			Send, ^c
			ClipWait
		Sleep, 100
		if (siegel_alt = "726" and siegel != "814" ) { ;and siegel = "823"
			if (clipboard = "06") {
				Send, 07
			}
		}
		if (siegel_alt = "726" and siegel = "814" ) { ; von 726 weiß 06 nach 814 weiß 02
			if (clipboard = "06") {
				Send, 02
			}
		}
		if (siegel_alt = "814" and siegel = "726") {
			if (clipboard = "02") {
				Send, 06
			}
		}
		if (siegel_alt = "814" and siegel != "726" and siegel != "814") {
			if (clipboard = "02") {
				Send, 07
			}
		}
		if (siegel_alt != "814" and siegel_alt != "726" and siegel = "814") {
			if (clipboard = "07") {
				Send, 02
			}
			if (clipboard = "01") {
				Send, 07
			}
		}
		if (siegel_alt != "814" and siegel_alt != "726" and siegel = "726") {
			if (clipboard = "07") {
				Send, 06
			}
			if (clipboard = "01") {
				Send, 02
			}			
			if (clipboard = "05") {
			Send, 03
			}
		}
		if (siegel_alt = "726") {
			if (clipboard = "03") {
				Send, 05
			}
		}
		
		Sleep, 100
			Send, {TAB}
			Send, {DEL}
			Send, {ENTER}
		} 
} else {
		MsgBox, Bitte starten Sie zuerst den Katalog.
}

wait:
	timeout = 5000
	start = A_TickCount
	stat = ""
	DetectHiddenText, On
	;Send, {ENTER}
	StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
	While (stat = "" and (A_TickCount-timeout) > start){

		StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
		While (stat <>  "" and (A_TickCount-timeout) > start){ 

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
	While (stat <> "" and (A_TickCount-timeout) > start){
		StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
		
		While (stat = "" and (A_TickCount-timeout) > start){ 
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