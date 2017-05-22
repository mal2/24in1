wait:
	time = A_TickCount + 4000
	stat =
	DetectHiddenText, On
	Send, {ENTER}
	StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
	While (stat = ""){
		StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
		if (A_TickCount > time) break
		While (stat <>  ""){ 
			if (A_TickCount > time) break
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
			if (stat = ){
				goto, ex
			}
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
			if (stat = ){
				goto, ex
			}
		}
		Sleep, 50
	}
	ex:
	While (stat <> ""){
		StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
		if (A_TickCount > time) break
		While (stat = ""){ 
			if (A_TickCount > time) break
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
			if (stat <> ){
				goto, ex
			}
			else {
				goto, ex2
			}
			Sleep, 200
			StatusBarGetText, stat, 3, ahk_class Catalog500.20.2
			if (stat <> ){
				goto, ex
			}
			else {
				goto, ex2
			}
		}
		Sleep, 50
	}
	ex2:
	Sleep, 1000
return

^esc::exitapp ; in case of emergency, hit shift-escape to quit

f3::
IfWinExist, HU Berlin
{
	WinActivate, Hu Berlin
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
	
	WinActivate, HU Berlin
	SetKeyDelay, -1
	Send, ^l
	Sleep, 200
	;Send, http://opac.hu-berlin.de
	Transform, hauth, HTML, %auth%
	Transform, htit, HTML, %tit%
	SendRaw, http://opac.hu-berlin.de/F/?func=find-c&ccl_term=WPE`%3D
	Send, %hauth%  
	SendRaw, `+AND`+WTI`%3D
	Send, %htit%
	Sleep, 200
	Send, {Enter}
	;Sleep, 2000
	;WinWait, HU Berlin Katalog - Einface Suche
	;Send, {SHIFTDOWN}{TAB 5}{SHIFTUP}
	;Sleep, 100
	;Send, {Enter}
	;WinWait, HU Berlin Katalog - Kommandosprache
	;Sleep, 200
	;Send, WPE=%auth% AND WTI=%tit%
	;Sleep, 200
	;Send, {Enter}
}
Else
    MsgBox,48,Hinweis,Dieser Shortcut funktioniert nur, wenn ein HU-Fenster aktiv ist!`nDies scheint nicht der Fall zu sein!
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

f1::
IfWinExist, ahk_class Catalog500.20.2
{
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 	

	Send, {CTRLDOWN}3{CTRLUP}{ALTDOWN}2{ALTUP}
	SLEEP, 100
	SEND, {TAB 9}{CTRLDOWN}c{CTRLUP}
	
	StringGetPos, a, clipboard, %A_Space%, L2
	StringLeft, rvk, clipboard, %a%
	a := a+1
	StringTrimLeft, cutter, clipboard, %a%
	;str := rvk . "`n" . cutter
		
	excel := ComObjActive("Excel.Application")

	workBook  := excel.ActiveWorkbook
	currentSheet := excel.ActiveSheet
	cell := excel.ActiveCell 

	cell.Value := rvk . "`n" . cutter ;str ;"UC 100`nB499-4,2(2)+2"
	
	excel.ActiveWorkbook.PrintOut()
	
	WinWait, ahk_class Catalog500.20.2 
	IfWinNotActive, ahk_class Catalog500.20.2
	WinActivate, ahk_class Catalog500.20.2
	WinWaitActive, ahk_class Catalog500.20.2, 
	
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