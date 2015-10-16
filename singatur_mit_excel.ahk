	excel := ComObjActive("Excel.Application")

	workBook  := excel.ActiveWorkbook
	currentSheet := excel.ActiveSheet
	cell := excel.ActiveCell 

	i=2
	;n := excel.ActiveSheet.Range(excel.ActiveSheet.Cells(2, i) , excel.ActiveSheet.Cells(2, i).End(xlDown)).Rows.Count
	n = 2
	
	while i <= n
    {
		sig := excel.ActiveSheet.Cells(2, i).Value

		IfWinExist, ahk_class Catalog500.22.0
		{
			WinWait, ahk_class Catalog500.22.0 
			IfWinNotActive, ahk_class Catalog500.22.0
			WinActivate, ahk_class Catalog500.22.0
			WinWaitActive, ahk_class Catalog500.22.0,
			
			; öffne Exemplaransicht
			Send, {F9}
			Sleep, 200
			Send, {UP}{UP}
			Sleep, 600
			Send, {CTRLDOWN}2{CTRLUP}{ALTDOWN}3{ALTUP}{TAB 6}
			Send, %sig%
			Sleep, 100
			Send, {Enter}
			Sleep, 500
			Send, ^3
			Send, !+e
			Sleep, 500
						
			; Suche nach Cutter
			WinGet, ActiveControlList, ControlList, A
			Loop, Parse, ActiveControlList, `n
			{
			ControlGetText, str, %A_LoopField%, ahk_class Catalog500.22.0
			StringLeft, strt, str, 3
				if (strt = "TIT") {
				fld = %A_LoopField%
				}
			}
			
			ControlGetText, str, %fld%, ahk_class Catalog500.22.0
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
			
			Replace=ÀA|ÁA|ÂA|ÃA|ÅA|ÇC|ÈE|ÉE|ÊE|ËE|ÍI|ÌI|ÎI|ÏI|ÑN|ÒO|ÓO|ÔO|ÕO|ŠS|ÙU|ÚU|ÛU|ÝY|ÐD|ÑN|ŽZ|àa|áa|âa|ãa|åa|âa|aa|çc|cc|cc|èe|ée|êe|ëe|gg|ìi|íi|îi|ïi|ñn|òo|óo|ôo|õo|šs|ss|tt|ùu|úu|ûu|ýy|ÿy|'*|'*|'*
			
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
			SendRaw, http://www.ub.ku-eichstaett.de/cgi-bin/cutterjo.pl?gugg=%auth%
			
			
			Sleep, 200
			Send, {Enter}
			
			
			;Combine RVK from cliupboard and Cutter
			If Clipboard !=  ;  checks to see if clipboard is not empty
			{
				rvk=%clipboard%
			}
	
			Replace="*|'*|'*|'*
			Loop, Parse, Replace, |
			{
			StringSplit, Part, A_LoopField
			StringReplace, rvk, rvk, %Part1%, %Part2%, All
			}
			StringReplace rvk, rvk, *, , All	
			
			IfWinNotActive, UB Eichstaett-Ingolstadt: Cutter Jo
			WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
			WinWaitActive, UB Eichstaett-Ingolstadt: Cutter Jo, 
			Sleep, 200
			Send, {Tab}
			Sleep, 100
			Send, ^a
			Sleep, 100
			Send, ^c
			Clipwait
			Sleep, 200

			Loop, parse, clipboard, `n, `r
			{
			If (A_Index == 8) {
			csn = %A_LoopField%
			}
			}

			IfWinNotActive, ahk_class Catalog500.22.0
			WinActivate, ahk_class Catalog500.22.0
			WinWaitActive, ahk_class Catalog500.22.0, 
			
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
			Sleep, 200
			
			MouseClick, left,  330,  314
			Sleep, 200
			MouseClick, left,  330,  314
			Sleep, 1000
			
			If Clipboard = %rvk%%A_Space%%csn%
			{
				Replace=ÀA|ÁA|ÂA|ÃA|ÅA|ÇC|ÈE|ÉE|ÊE|ËE|ÍI|ÌI|ÎI|ÏI|ÑN|ÒO|ÓO|ÔO|ÕO|ŠS|ÙU|ÚU|ÛU|ÝY|ÐD|ÑN|ŽZ|àa|áa|âa|ãa|åa|âa|aa|çc|cc|cc|èe|ée|êe|ëe|gg|ìi|íi|îi|ïi|ñn|òo|óo|ôo|õo|šs|ss|tt|ùu|úu|ûu|ýy|ÿy|'*|'*|'*
			
				;Ôüäâïë
				
				Loop, Parse, Replace, |
				{
				StringSplit, Part, A_LoopField
				StringReplace, tit, tit, %Part1%, %Part2%, All
				}
				
				StringReplace tit, tit, ß, ss, All
				StringReplace tit, tit, Æ, Ae, All
				StringReplace tit, tit, Ä, Ae, All
				StringReplace tit, tit, Œ, Oe, All
				StringReplace tit, tit, Ø, Oe, All
				StringReplace tit, tit, Ö, Oe, All
				StringReplace tit, tit, Ü, Ue, All
				StringReplace tit, tit, æ, ae, All
				StringReplace tit, tit, ä, ae, All
				StringReplace tit, tit, œ, oe, All	
				StringReplace tit, tit, ø, oe, All
				StringReplace tit, tit, ö, oe, All
				StringReplace tit, tit, ü, ue, All
				StringReplace tit, tit, *, , All
				
				WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
				SetKeyDelay, -1
				Send, ^l
				Sleep, 200
				SendRaw, http://www.ub.ku-eichstaett.de/cgi-bin/cutterjo.pl?gugg=%tit%
								
				Sleep, 200
				Send, {Enter}
				

				Replace="*|'*|'*|'*
				Loop, Parse, Replace, |
				{
				StringSplit, Part, A_LoopField
				StringReplace, rvk, rvk, %Part1%, %Part2%, All
				}
				StringReplace rvk, rvk, *, , All	
				
				IfWinNotActive, UB Eichstaett-Ingolstadt: Cutter Jo
				WinActivate, UB Eichstaett-Ingolstadt: Cutter Jo
				WinWaitActive, UB Eichstaett-Ingolstadt: Cutter Jo, 
				Sleep, 200
				Send, {Tab}
				Sleep, 100
				Send, ^a
				Sleep, 100
				Send, ^c
				Clipwait
				Sleep, 200

				Loop, parse, clipboard, `n, `r
				{
				If (A_Index == 8) {
				csn2 = %A_LoopField%
				}
				}
				
				StringLeft, csn2, csn2, 2
				
				IfWinNotActive, ahk_class Catalog500.22.0
				WinActivate, ahk_class Catalog500.22.0
				WinWaitActive, ahk_class Catalog500.22.0, 
				
				Send, {F9}
				Sleep, 200
				Send, {DOWN}{DOWN}{UP}
				Sleep, 800
				Send, {CTRLDOWN}2{CTRLUP}{TAB}
				Sleep, 100
				Send, {TAB}
				Send, %rvk%%A_Space%%csn%%A_Space%%csn2%
				Sleep, 100
				Send, {Enter}
			} else
			{
			MsgBox, "Signatur noch nicht vergeben"
			}
			

		}
		i=i+1
	}