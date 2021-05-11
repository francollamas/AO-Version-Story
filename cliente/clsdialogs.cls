version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsdialogs"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clsdialogs.cls - chats over head manager.
' creates and manipulates chats over heads, rendering and updating them.
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

''
' creates and manipulates chats over heads, rendering and updating them.
'
' @file     clsdialogs.cls
' @author   juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version  1.0.0
' @date     20070729

option explicit
option base 0

''
' maximum number of dialogs that can exist.
private const max_dialogs as byte = 50

''
' maximum length of any dialog line without having to split it.
private const max_length as byte = 15

''
' the number of milliseconds the dialog should be rendered.
private const dialog_life as long = 16600


''
' the dialog structure
'
' @param    textline    array of lines of a formated chat.
' @param    x           x coord for rendering.
' @param    y           y coord for rendering.
' @param    starttime   the time (in ms) at which the dialog was created.
' @param    charindex   the charindex that created this dialog.
' @param    color       the color to be used when rendering the text.
' @param    renderable  set to true if the chat should be rendered this frame, false otherwise
'                           (used to skip dialogs from people outside render area).
private type dialog
    textline()  as string
    x           as integer
    y           as integer
    starttime   as long
    charindex   as integer
    color       as long
    renderable  as boolean
end type

''
' array if dialogs, sorted by the charindex.
private dialogs(max_dialogs - 1) as dialog

''
' the number of dialogs being used at the moment.
private dialogcount as byte

''
' the size of the font being used to render
private usedfont as stdfont


''
' initializes the instance of the class.

private sub class_initialize()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/28/07
'initializes the dialog instance
'***************************************************
    dialogcount = 0
end sub

''
' clean up and release resources

private sub class_terminate()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/28/07
'clean up
'***************************************************
end sub

private function binarysearch(byval charindex as integer) as integer
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'returns the index of the dialog in the list, or the negation
'of the position were it should be if not found (for binary insertion)
'**************************************************************
    dim min as long
    dim max as long
    dim mid as long
    
    min = 0
    max = dialogcount - 1
    
    do while min <= max
        mid = (min + max) \ 2
        
        if dialogs(mid).charindex < charindex then
            min = mid + 1
        elseif dialogs(mid).charindex > charindex then
            max = mid - 1
        else
            'we found it
            binarysearch = mid
            exit function
        end if
    loop
    
    'not found, return the negation of the position where it should be
    '(all higher values are to the right of the list and lower values are to the left)
    binarysearch = not mid
end function

''
' create sa new dialog. if the user already had a dialog, then it's replaced,
' otherwise a new slot is used.
'
' @param    chat        the text of the chat being spoken.
' @param    charindex   the character saying the chat.
' @param    color       the color being use din the chat when rendered.
'
' @remarks  if there are no more free slots, and the char didn't have a previous dialog,
'           the chat is ignored.

public sub createdialog(byref chat as string, byval charindex as integer, byval color as long)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'creates a new dialog.
'**************************************************************
    dim slot as integer
    dim i as long
    
    slot = binarysearch(charindex)
    
    if slot < 0 then
        if dialogcount = max_dialogs then exit sub  'out of space! should never happen....
        
        'we need to add it. get insertion index and move list backwards.
        slot = not slot
        
        for i = dialogcount to slot + 1 step -1
            dialogs(i) = dialogs(i - 1)
        next i
        
        dialogcount = dialogcount + 1
    end if
    
    with dialogs(slot)
        .charindex = charindex
        .color = color
        .renderable = false
        .starttime = gettickcount
        .textline = formatchat(chat)
    end with
end sub

''
' splits a text into several lines to make it comply with the max_length unless it's impossible (a single word longer than max_length).
'
' @param    chat    the text to be formated.
'
' @return   the array of lines into which the text is splitted.
'
' @see      max_length

private function formatchat(byref chat as string) as string()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'formats a dialog into different text lines.
'**************************************************************
    dim word as string
    dim curpos as long
    dim length as long
    dim acumlength as long
    dim linelength as long
    dim wordlength as long
    dim curline as long
    dim chatlines() as string
    
    'initialize variables
    curline = 0
    curpos = 1
    length = len(chat)
    acumlength = 0
    linelength = -1
    redim chatlines(fieldcount(chat, 32)) as string
    
    'start formating
    do while acumlength < length
        word = readfield(curpos, chat, 32)
        
        wordlength = len(word)
        
        ' is the first word of the first line? (it's the only that can start at -1)
        if linelength = -1 then
            chatlines(curline) = word
            
            linelength = wordlength
            acumlength = wordlength
        else
            ' is the word too long to fit in this line?
            if linelength + wordlength + 1 > max_length then
                'put it in the next line
                curline = curline + 1
                chatlines(curline) = word
                
                linelength = wordlength
            else
                'add it to this line
                chatlines(curline) = chatlines(curline) & " " & word
                
                linelength = linelength + wordlength + 1
            end if
            
            acumlength = acumlength + wordlength + 1
        end if
        
        'increase to search for next word
        curpos = curpos + 1
    loop
    
    ' if it's only one line, center text
    if curline = 0 and length < max_length then
        chatlines(curline) = string(max_length - length, " ") & chatlines(curline)
    end if
    
    'resize array to fit
    redim preserve chatlines(curline) as string
    
    formatchat = chatlines
end function

''
' updates the position where a given dialog will be rendered.
'
' @param    x           the x coord where to start rendering.
' @param    y           the y coord where to start rendering.
' @param    charindex   the character whose dialog's position is being updated.

public sub updatedialogpos(byval x as integer, byval y as integer, byval charindex as integer)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'updates a dialog's position.
'**************************************************************
    dim slot as integer
    
    slot = binarysearch(charindex)
    
    if slot >= 0 then
        with dialogs(slot)
            .x = x - (max_length \ 2) * 3
            .y = y - (ubound(.textline()) * 3)
            .renderable = true
        end with
    end if
end sub

''
' displays all renderable dialogs on screen.

public sub render()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'renders all renderable dialogs and gets rid of old ones.
'**************************************************************
    dim i as long
    dim j as long
    dim offset as integer
    dim removeddialogs as long
    
    for i = 0 to dialogcount - 1
        'decrease index to prevent jumping over a dialog
        'crappy vb will cache the limit of the for loop, so even if it changed, it won't matter
        with dialogs(i - removeddialogs)
            if .starttime + dialog_life < gettickcount then
                call removedialog(.charindex)
                
                removeddialogs = removeddialogs + 1
            elseif .renderable then
                offset = -(usedfont.size + 5) * ubound(.textline())
                
                'render it
                for j = 0 to ubound(.textline())
                    call drawtext(.x, .y + offset, .textline(j), .color, usedfont)
                    offset = offset + usedfont.size + 5
                next j
            end if
        end with
    next i
end sub

''
' removes the dialog from the requested char.
'
' @param    charindex   the character whose dialog will be removed.

public sub removedialog(byval charindex as integer)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'removes the dialog from the requested char.
'**************************************************************
    dim slot as integer
    dim i as long
    
    slot = binarysearch(charindex)
    
    if slot < 0 then exit sub
    
    for i = slot to max_dialogs - 2
        dialogs(i) = dialogs(i + 1)
    next i
    
    dialogcount = dialogcount - 1
end sub

''
' removes all dialogs from all characters.

public sub removealldialogs()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'removes all dialogs from all chars.
'**************************************************************
    dialogcount = 0
end sub

''
' retrieves the font being used to render dialogs.
'
' @return   the font being used to render dialogs.

public property get font() as stdfont
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'retrieves the font being used to render dialogs.
'**************************************************************
    font = usedfont
end property

''
' sets the font being used to render dialogs.
'
' @param    nvalue  the new font to be used to render dialogs.

public property let font(byref nvalue as stdfont)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 07/28/07
'sets the font being used to render dialogs.
'**************************************************************
    set usedfont = nvalue
end property
