filename =
latest = 
Loop C:\temp\Aleph\*.*
{
	filename = %A_LoopFileName%
}

StringMid, latest, filename, 7, 5

FileRead, Contents, *t C:\temp\Aleph\~Aleph%latest%.html
if not ErrorLevel  ; Successfully loaded.
{
	Loop Parse, Contents, <>,%A_Tab%
	{
    StringReplace Contents, Contents, <%A_LoopField%>,, all
    }
	Loop Parse, Contents, {},%A_Tab%
	{
    StringReplace Contents, Contents, {%A_LoopField%},, all
    }	
	
	StringGetPos, PosR, Contents, `) , R
	StringGetPos, PosL, Contents, `; , R2
		
	StringMid, Contents, Contents, PosL+3, PosR-PosL-2
    FileAppend, %Contents%, C:\temp\Aleph\test
    Contents =  ; Free the memory.
}