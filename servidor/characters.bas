attribute vb_name = "characters"
'**************************************************************
' characters.bas - library of functions to manipulate characters.
'
' designed and implemented by juan mart�n sotuyo dodero (maraxus)
' (juansotuyo@gmail.com)
'**************************************************************

'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the affero general public license;
'either version 1 of the license, or any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the affero general public license
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'**************************************************************************

option explicit

''
' value representing invalid indexes.
public const invalid_index as integer = 0

''
' retrieves the userlist index of the user with the give char index.
'
' @param    charindex   the char index being used by the user to be retrieved.
' @return   the index of the user with the char placed in charindex or invalid_index if it's not a user or valid char index.
' @see      invalid_index

public function charindextouserindex(byval charindex as integer) as integer
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'takes a charindex and transforms it into a userindex. returns invalid_index in case of error.
'***************************************************
    charindextouserindex = charlist(charindex)
    
    if charindextouserindex < 1 or charindextouserindex > maxusers then
        charindextouserindex = invalid_index
        exit function
    end if
    
    if userlist(charindextouserindex).char.charindex <> charindex then
        charindextouserindex = invalid_index
        exit function
    end if
end function
