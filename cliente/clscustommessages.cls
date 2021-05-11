version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clscustommessages"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clscustommessages.cls - user-defined messages with shortcut.
' allows the creation and serialization of user defined messages to be used with shortcuts.
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
option base 0

''
' defines the number of messages that can be created.
private const message_count as byte = 10

''
' defines the maximum length allowed for any custom message.
private const max_message_length as byte = 120

''
' the error code thrown when the message being set is invalid.
private const invalid_message as long = vbobjecterror + 123

''
' relative path from the application in which custom message are stored.
private const message_file_path as string = "/init/messages.txt"


''
'array of defined messages.
private custommessages(message_count - 1) as string


''
' class constructor. initializes a new clscustommessage

private sub class_initialize()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/26/07
'initializes the messages by loading them from the config file
'***************************************************
on error goto errhandler
    dim handle as integer
    dim i as long
    
    'load custom messages
    handle = freefile()
    
    open app.path & message_file_path for input as handle
    
    for i = 0 to message_count - 1
        line input #handle, custommessages(i)
        
        'purge invalid messages
        if not messageisvalid(custommessages(i)) then
            custommessages(i) = vbnullstring
        end if
    next i
    
    close handle
    
    'if the file does not exist (only possible error),
    'then we have nothing to worry. all messages will be empty
errhandler:
end sub

''
' class desconstructor. serializes messages to

private sub class_terminate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/26/07
'stores all messages back into config file for later use.
'***************************************************
    dim handle as integer
    dim i as long
    dim directories() as string
    dim path as string
    
    'make sure the path exists
    directories = split(message_file_path, "/")
    path = app.path
    
    for i = 0 to ubound(directories()) - 1
        path = path & "/" & directories(i)
        
        if lenb(dir(path, vbdirectory)) = 0 then
            call mkdir(path)
        end if
    next i
    
    'serialize custom messages
    handle = freefile()
    
    open app.path & message_file_path for output as handle
    
    for i = 0 to message_count - 1
        print #handle, custommessages(i)
    next i
    
    close handle
end sub

''
' retrieves the requested message.
'
' @param    index   the message index to retrieve.
' @return   the message requested.

public property get message(byval index as integer) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/26/07
'retrieves the requested message.
'***************************************************
    if index < 0 or index >= message_count then
        exit property
    end if
    
    message = custommessages(index)
end property

''
' sets the requested message.
'
' @param    index   the message index to be set.
' @param    nvalue  the message to be stored.

public property let message(byval index as integer, byval nvalue as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/26/07
'sets the given message index with the requested message.
'***************************************************
    if index < 0 or index >= message_count then
        exit property
    end if
    
    if not messageisvalid(nvalue) then
        call err.raise(invalid_message)
        exit property
    end if
    
    custommessages(index) = nvalue
end property

''
' retrieves the error code of invalid messages.
'
' @return   the error code triggered when an invalid message is found.

public property get invalidmessageerrcode() as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/26/07
'retrieves the invalid_message error code.
'***************************************************
    invalidmessageerrcode = invalid_message
end property

''
' checks if the given message is valid or not.
'
' @param    msg   the message to be checked.
' @return   true if the message is valid, false otherwise.

private function messageisvalid(byref msg as string) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/07/07
'last modified by: rapsodius
'
'erased line "msg=strconv(msg,vbunicode)", because
'it was causing problems and detected as many messages
'as wrong with nothing bad on them
'***************************************************
    dim i as long
    dim char as string * 1
    dim ascii as byte
    
    'get rid of spaces
    msg = trim$(msg)
        
    'empty messages are valid
    if lenb(msg) = 0 then
        messageisvalid = true
        exit function
    end if
    
    for i = 1 to len(msg)
        char = mid$(msg, i, 1)
        ascii = asc(char)
        
        'check for invalid chars...
        if ascii < 31 then exit function
        
        if ascii > 126 and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" _
          and char <> "�" and char <> "�" and char <> "�" and char <> "�" and char <> "�" then
            exit function
        end if
    next i
    
    'discard extremely long messages
    if len(msg) > max_message_length then exit function
    
    messageisvalid = true
end function
