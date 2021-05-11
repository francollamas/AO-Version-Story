attribute vb_name = "previnstance"
'**************************************************************
' previnstance.bas - checks for previous instances of the client running
' by using a named mutex.
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

''
'prevents multiple instances of the game running on the same computer.

'
' @author fredy horacio treboux (liquid) @and juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version 1.0.0
' @date 20070104

option explicit

'declaration of the win32 api function for creating /destroying a mutex, and some types and constants.
private declare function createmutex lib "kernel32" alias "createmutexa" (byref lpmutexattributes as security_attributes, byval binitialowner as long, byval lpname as string) as long
private declare function releasemutex lib "kernel32" (byval hmutex as long) as long
private declare function closehandle lib "kernel32" (byval hobject as long) as long

private type security_attributes
    nlength as long
    lpsecuritydescriptor as long
    binherithandle as long
end type

private const error_already_exists = 183&

private mutexhid as long

''
' creates a named mutex. private function, since we will use it just to check if a previous instance of the app is running.
'
' @param mutexname the name of the mutex, should be universally unique for the mutex to be created.

private function createnamedmutex(byref mutexname as string) as boolean
'***************************************************
'autor: fredy horacio treboux (liquid)
'last modification: 01/04/07
'last modified by: juan mart�n sotuyo dodero (maraxus) - changed security atributes to make it work in all os
'***************************************************
    dim sa as security_attributes
    
    with sa
        .binherithandle = 0
        .lpsecuritydescriptor = 0
        .nlength = lenb(sa)
    end with
    
    mutexhid = createmutex(sa, false, "global\" & mutexname)
    
    createnamedmutex = not (err.lastdllerror = error_already_exists) 'check if the mutex already existed
end function

''
' checks if there's another instance of the app running, returns true if there is or false otherwise.

public function findpreviousinstance() as boolean
'***************************************************
'autor: fredy horacio treboux (liquid)
'last modification: 01/04/07
'
'***************************************************
    'we try to create a mutex, the name could be anything, but must contain no backslashes.
    if createnamedmutex("uniquenamethatactuallycouldbeanything") then
        'there's no other instance running
        findpreviousinstance = false
    else
        'there's another instance running
        findpreviousinstance = true
    end if
end function

''
' closes the client, allowing other instances to be open.

public sub closeclient()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/04/07
'
'***************************************************
    call releasemutex(mutexhid)
    call closehandle(mutexhid)
end sub
