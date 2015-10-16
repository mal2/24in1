; GetNestedTag() v1
; AHK Forum Topic : http://www.autohotkey.com/forum/viewtopic.php?t=77653
; Documentation   : http://www.autohotkey.net/~hugov/functions/GetNestedTag.html

GetNestedTag(data,tag,occurrence="1")
	{
	 Start:=InStr(data,tag,false,1,occurrence)
	 RegExMatch(tag,"i)<([a-z]*)",basetag) ; get yer basetag1 here
	 Loop
		{
		 Until:=InStr(data, "</" basetag1 ">", false, Start, A_Index) + StrLen(basetag1) + 3
 		 Strng:=SubStr(data, Start, Until - Start) 

		 StringReplace, strng, strng, <%basetag1%, <%basetag1%, UseErrorLevel ; start counting to make match
		 OpenCount:=ErrorLevel
		 StringReplace, strng, strng, </%basetag1%, </%basetag1%, UseErrorLevel
		 CloseCount:=ErrorLevel
		 If (OpenCount = CloseCount)
		 	Break

		 If (A_Index > 250) ; for safety so it won't get stuck in an endless loop, 
		 	{                 ; it is unlikely to have over 250 nested tags
		 	 strng=
		 	 Break
		 	}	
		}
	 If (StrLen(strng) < StrLen(tag)) ; something went wrong/can't find it
	 	strng=
	 Return strng
	}

; unhtml.ahk - stdlib desired name
; 
; StdLib compliant collection to convert HTML to Text
;
; Known Bugs: unHTML_StripEntities wont work for 
; Unicode / UTF-8 Entities - These will stay intact
;
; v 1.3 / (a & w) Nov 2008 by derRaphael(at)oleco.net
;

; Syntax sugar for combined call of StripEntities & StripTags
unHTML(html){          
	Return unHTML_StripTags(unHTML_StripEntities(html))
}

; Removes HTML Tags frolm given text
unHTML_StripTags(txt){ ; v1 (w) by derRaphael Oct 2008
	Return RegExReplace(txt,"<[^>]+>","")
}

; Strips HTML entities out of given Text / No Unicode / UTF8 Entity support yet
unHTML_StripEntities(html){ ; v1.3.1 (w) by derRaphael Nov 2008
	Loop,
		if (RegExMatch(html,"&[a-zA-Z0-9#]+;",entity)) {
			n:=RegExReplace(unHTML_ConvertEntity2Number(entity),"[^\d]")
			if ((n>0) && (n<256)) {
				html := RegExReplace(html,"\Q" entity "\E",chr(n))
			}
		} else 
			break
	return html
}

; Thx Jamey: http://www.autohotkey.com/forum/viewtopic.php?t=22522
; Rewrite by derRaphael v 1.3 / Nov 2008
unHTML_ConvertEntity2Number(sEntityName) {
   nNumber := -1   ;This will remain -1 if the entity name could not be translated.
   nStr := StrLen(sEntityName)

   ;Require the input format:  "& ... ;"
   if ((nStr < 3) || (SubStr(sEntityName, 1, 1) != "&") || (SubStr(sEntityName, 0) != ";"))
      return %nNumber%

   ;If the entity was given as its entity-number format, then return the number part.
   sEntityIdentifier := SubStr(sEntityName, 2, nStr-2)

   if sEntityIdentifier is integer
   {
      sEntityIdentifier := Round(sEntityIdentifier)   ;Not just can be interpreted as integer, but is!
      if (sEntityIdentifier >= 0)
         return %sEntityIdentifier%
      else
         return %nNumber%
   }

   ;If sEntityName really is a name-format entity, then find its number from the table below.
   	entityList := "quot|34,apos|39,amp|38,lt|60,gt|62,nbsp|160,iexcl|161,cent|162,pound|163,curren|164,"
				. "yen|165,brvbar|166,sect|167,uml|168,copy|169,ordf|170,laquo|171,not|172,shy|173,reg|"
				. "174,macr|175,deg|176,plusmn|177,sup2|178,sup3|179,acute|180,micro|181,para|182,middo"
				. "t|183,cedil|184,sup1|185,ordm|186,raquo|187,frac14|188,frac12|189,frac34|190,iquest|"
				. "191,Agrave|192,Aacute|193,Acirc|194,Atilde|195,Auml|196,Aring|197,AElig|198,Ccedil|1"
				. "99,Egrave|200,Eacute|201,Ecirc|202,Euml|203,Igrave|204,Iacute|205,Icirc|206,Iuml|207"
				. ",ETH|208,Ntilde|209,Ograve|210,Oacute|211,Ocirc|212,Otilde|213,Ouml|214,times|215,Os"
				. "lash|216,Ugrave|217,Uacute|218,Ucirc|219,Uuml|220,Yacute|221,THORN|222,szlig|223,agr"
				. "ave|224,aacute|225,acirc|226,atilde|227,auml|228,aring|229,aelig|230,ccedil|231,egra"
				. "ve|232,eacute|233,ecirc|234,euml|235,igrave|236,iacute|237,icirc|238,iuml|239,eth|24"
				. "0,ntilde|241,ograve|242,oacute|243,ocirc|244,otilde|245,ouml|246,divide|247,oslash|2"
				. "48,ugrave|249,uacute|250,ucirc|251,uuml|252,yacute|253,thorn|254,yuml|255,OElig|338,"
				. "oelig|339,Scaron|352,scaron|353,Yuml|376,circ|710,tilde|732,ensp|8194,emsp|8195,thin"
				. "sp|8201,zwnj|8204,zwj|8205,lrm|8206,rlm|8207,ndash|8211,mdash|8212,lsquo|8216,rsquo|"
				. "8217,sbquo|8218,ldquo|8220,rdquo|8221,bdquo|8222,dagger|8224,Dagger|8225,hellip|8230"
				. ",permil|8240,lsaquo|8249,rsaquo|8250,euro|8364,trade|8482"

	Loop,Parse,entityList,`,
		if (RegExMatch(A_LoopField,"i)^" sEntityIdentifier "\|(?P<Number>\d+)", n))
			break

   return (nNumber!="") ? nNumber : sEntityIdentifier
}
	
Loop{
		Loop, C:\temp\Aleph\*
		{
		If (A_LoopFileTimeCreated>Rec and A_LoopFileSizeKB>1)
		  {
		  FPath=%A_LoopFileFullPath%
		  Rec=%A_LoopFileTimeCreated%
		  }
		}

		if (act!=FPath){
		
		FileRead, html,%FPath%

		get=<td class=table-1>
		txt=% GetNestedTag(html,get)
		txt=% unHTML(txt)
		;StringGetPos, posL, txt, : , L2
		;StringLeft, txt, txt, posL
		;StringGetPos, posR, txt, `, , R2
		;StringLeft, txt, txt, posR

		FileAppend, %txt%`n, C:\Temp\lst.txt
		}
		act=%FPath%
		Sleep, 2000
	}