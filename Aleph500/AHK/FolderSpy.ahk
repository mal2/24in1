IfWinActive, ahk_class CabinetWClass
{
	Loop {
		SetTitleMatchMode, 3
		WinGetTitle, active_title, A
		for window in ComObjCreate("Shell.Application").Windows
		try address := % window.Document.Folder.Self.Path   ; http://ahkscript.org/boards/viewtopic.php?p=28751#p28751
		;MsgBox, "%address%"
		GoSub, FileAdded
		Sleep, 800
	}
}

FileAdded:
Loop, C:\temp\Aleph\*.*
{
	now := %A_Now%
	EnvSub, now, %A_LoopFileTimeCreated%, seconds
	If now < 2 ; newer as 2 seconds
	{ 
		SetTimer, FileAdded, off
		;MsgBox a new file `n%A_LoopFileFullPath% `nis added in %address%
		; Run, %address%  ; if the explorer window has been closed in the meantime
		WinWait, %active_title% 
		WinActivate, %active_title% 
		WinWaitActive, %active_title%
		; Send, your keys
		; Sleep some time
		; SetTimer, FileAdded, on
		
		StringRight, OutputVar, A_LoopFileFullPath, 10
		StringLeft, Num, OutputVar, 5 
		Num := Num + 1
		
		StringTrimRight, OutputVar, A_LoopFileFullPath, 10
		NewStr := OutputVar . Num . ".html"
		
		;MsgBox Edit `n%NewStr%
		
		FileRead, CurrPage , %NewStr%
		
		FiltPage := RegExReplace(CurrPage, "<style .+?<\/style>" , "")
		FiltPage := RegExReplace(FiltPage, "<.+?>" , "")
		RegExMatch(FiltPage, "Titel.*?ISBN", str)
		
		StringGetPos, posR, str, `:, L3
		StringLeft, str2, str, posR
		StringGetPos, posL, str2, `, , R1
		StringLen, len, str2
		posL := len-posL-2
		StringRight, str, str2, posL
		
		Sleep, 500
		clipboard = %str%
		clipwait
		Sleep, 500
		Send, !c
	}
}
return