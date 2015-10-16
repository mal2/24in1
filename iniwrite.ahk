Needle = #32770
IniRead, Classes, BiblioAleph.ini, General, ValidClasses
MsgBox, The value is %Classes%
IfInString, Classes, %Needle%
{
MsgBox, already in ini
}
else
{
VClasses := Classes . "|" . Needle
IniWrite, %VClasses%, BiblioAleph.ini, General, ValidClasses
}
   