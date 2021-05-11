version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsinireader"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clsinireader.cls - loads ini files into memory and applies binary search to get values at high speed.
' use it instead of getvar when reading several values form the same file at once, otherwise it's not usefull.
' based in the idea of alejolp and his clsleerinis.
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
'loads a complete ini file into memory and sorts it's data and keys for faster searches.
'it is much faster than getprivateprofilestringa if you search for several values within a file, otherwise stick to the api.
'it's particularly usefull when you can keep a whole file in memory such as npcs.dat'
' based in the idea of alejolp and his clsleerinis.
'
' @author juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version 1.0.0
' @date 20060501

option explicit
option base 0


''
'structure that contains a value and it's key in a ini file
'
' @param    key string containing the key associated to the value.
' @param    value string containing the value of the ini entry.
' @see      mainnode
'

private type childnode
    key as string
    value as string
end type

''
'structure that contains all info under a tag in a ini file.
'such tags are indicated with the "[" and "]" characters.
'
' @param    name string containing the text within the "[" and "]" characters.
'it's the key used when searching for a main section of the ini data.
' @param    values array of childnodes, each containing a value entry along with it's key.
' @param    numvalues number of entrys in the main node.
'

private type mainnode
    name as string
    values() as childnode
    numvalues as integer
end type

''
'containts all main sections of the loaded ini file
'
private filedata() as mainnode

''
'stores the total number of main sections in the loaded ini file
'
private mainnodes as long

''
'default constructor. does nothing.
'

private sub class_initialize()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/01/2006
'
'**************************************************************
end sub

''
'destroy every array and deallocates al memory.
'

private sub class_terminate()
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/01/2006
'
'**************************************************************
    dim i as long
    
    'clean up
    if mainnodes then
        for i = 1 to mainnodes - 1
            erase filedata(i).values
        next i
        
        erase filedata
    end if
    
    mainnodes = 0
end sub

''
'loads a ini file so it's values can be read. must be called before being able to use getvalue.
'
' @param    file complete path of the ini file to be loaded.
' @see      getvalue
'

public sub initialize(byval file as string)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 27/07/2006
'opens the requested file and loads it's data into memory
'**************************************************************
    dim handle as integer
    dim text as string
    dim pos as long
    
    'prevent memory losses if we are attempting to reload a file....
    call class_terminate
    
    'get a free handle and start reading line by line until the end
    handle = freefile
    
    open file for input as handle
    
    do until eof(handle)
        line input #handle, text
        
        'is it null??
        if len(text) then
            'if it starts with '[' it is a main node or nothing (getprivateprofilestringa works this way), otherwise it's a value
            if left$(text, 1) = "[" then
                'if it has an ending ']' it's a main node, otherwise it's nothing
                pos = instr(2, text, "]")
                if pos then
                    'add a main node
                    redim preserve filedata(mainnodes) as mainnode
                    
                    filedata(mainnodes).name = ucase$(trim$(mid$(text, 2, pos - 2)))
                    
                    mainnodes = mainnodes + 1
                end if
            else
                'so it's a value. check if it has a '=', otherwise it's nothing
                pos = instr(2, text, "=")
                if pos then
                    'is it under any main node??
                    if mainnodes then
                        with filedata(mainnodes - 1)
                            'add it to the main node's value
                            redim preserve .values(.numvalues) as childnode
                            
                            .values(.numvalues).value = right$(text, len(text) - pos)
                            .values(.numvalues).key = ucase$(left$(text, pos - 1))
                            
                            .numvalues = .numvalues + 1
                        end with
                    end if
                end if
            end if
        end if
    loop
    
    close handle
    
    dim i as long
    
    if mainnodes then
        'sort main nodes to allow binary search
        call sortmainnodes(0, mainnodes - 1)
        
        'sort values of each node to allow binary search
        for i = 0 to mainnodes - 1
            if filedata(i).numvalues then _
                call sortchildnodes(filedata(i), 0, filedata(i).numvalues - 1)
        next i
    end if
end sub

''
'sorts all child nodes within the given mainnode alphabetically by their keys. uses quicksort.
'
' @param    node the mainnode whose values are to be sorted.
' @param    first the first index to consider when sorting.
' @param    last the last index to be considered when sorting.
'

private sub sortchildnodes(byref node as mainnode, byval first as integer, byval last as integer)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/01/2006
'sorts the list of values in a given mainnode using quicksort,
'this allows the use of binary search for faster searches
'**************************************************************
    dim min as integer      'first item in the list
    dim max as integer      'last item in the list
    dim comp as string      'item used to compare
    dim temp as childnode
    
    min = first
    max = last
    
    with node
        comp = .values((min + max) \ 2).key
    
        do while min <= max
            do while .values(min).key < comp and min < last
                min = min + 1
            loop
            do while .values(max).key > comp and max > first
                max = max - 1
            loop
            if min <= max then
                temp = .values(min)
                .values(min) = .values(max)
                .values(max) = temp
                min = min + 1
                max = max - 1
            end if
        loop
    end with
    
    if first < max then sortchildnodes node, first, max
    if min < last then sortchildnodes node, min, last
end sub

''
'sorts all main nodes in the loaded ini file alphabetically by their names. uses quicksort.
'
' @param    first the first index to consider when sorting.
' @param    last the last index to be considered when sorting.
'

private sub sortmainnodes(byval first as integer, byval last as integer)
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/01/2006
'sorts the mainnodes list using quicksort,
'this allows the use of binary search for faster searches
'**************************************************************
    dim min as integer      'first item in the list
    dim max as integer      'last item in the list
    dim comp as string      'item used to compare
    dim temp as mainnode
    
    min = first
    max = last
    
    comp = filedata((min + max) \ 2).name
    
    do while min <= max
        do while filedata(min).name < comp and min < last
            min = min + 1
        loop
        do while filedata(max).name > comp and max > first
            max = max - 1
        loop
        if min <= max then
            temp = filedata(min)
            filedata(min) = filedata(max)
            filedata(max) = temp
            min = min + 1
            max = max - 1
        end if
    loop
    
    if first < max then sortmainnodes first, max
    if min < last then sortmainnodes min, last
end sub

''
'searches for a given key within a given main section and if it exists retrieves it's value, otherwise a null string
'
' @param    main the name of the main section in which we will be searching.
' @param    key the key of the value we are looking for.
' @returns  the value asociated with the given key under the requeted main section of the ini file or a null string if it's not found.
'

public function getvalue(byval main as string, byval key as string) as string
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/01/2006
'returns a value if the key and main node exist, or a nullstring otherwise
'**************************************************************
    dim i as long
    dim j as long
    
    'search for the main node
    i = findmain(ucase$(main))
    
    if i >= 0 then
        'if valid, binary search among keys
        j = findkey(filedata(i), ucase$(key))
        
        'if we found it we return it
        if j >= 0 then getvalue = filedata(i).values(j).value
    end if
end function

''
'searches for a given key within a given main node and returns the index in which it's stored or the negation of the index in which it should be if not found.
'
' @param    node the mainnode among whose value entries we will be searching.
' @param    key the key of the value we are looking for.
' @returns  the index in which the value with the key we are looking for is stored or the negation of the index in which it should be if not found.
'

private function findkey(byref node as mainnode, byval key as string) as long
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/01/2006
'returns the index of the value which key matches the requested one,
'or the negation of the position were it should be if not found
'**************************************************************
    dim min as long
    dim max as long
    dim mid as long
    
    min = 0
    max = node.numvalues - 1
    
    do while min <= max
        mid = (min + max) \ 2
        
        if node.values(mid).key < key then
            min = mid + 1
        elseif node.values(mid).key > key then
            max = mid - 1
        else
            'we found it
            findkey = mid
            exit function
        end if
    loop
    
    'not found, return the negation of the position where it should be
    '(all higher values are to the right of the list and lower values are to the left)
    findkey = not mid
end function

''
'searches for a main section with the given name within the loaded ini file and returns the index in which it's stored or the negation of the index in which it should be if not found.
'
' @param    name the name of the mainnode we are looking for.
' @returns  the index in which the main section we are looking for is stored or the negation of the index in which it should be if not found.
'

private function findmain(byval name as string) as long
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 5/01/2006
'returns the index of the mainnode which name matches the requested one,
'or the negation of the position were it should be if not found
'**************************************************************
    dim min as long
    dim max as long
    dim mid as long
    
    min = 0
    max = mainnodes - 1
    
    do while min <= max
        mid = (min + max) \ 2
        
        if filedata(mid).name < name then
            min = mid + 1
        elseif filedata(mid).name > name then
            max = mid - 1
        else
            'we found it
            findmain = mid
            exit function
        end if
    loop
    
    'not found, return the negation of the position where it should be
    '(all higher values are to the right of the list and lower values are to the left)
    findmain = not mid
end function
