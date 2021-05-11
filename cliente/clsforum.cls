version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsforum"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'*****************************************************
'forum
'designed and implemented by zama
'zaxtor@gmail.com
'*****************************************************

'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'(at your option) any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************
option explicit

private const max_mensajes_foro as byte = 30
private const max_anuncios_foro as byte = 5

' post counter
private cantposts(0 to 2) as byte
private cantstickys(0 to 2) as byte

public sub addpost(byval forumtype as eforumtype, byref title as string, byref author as string, byref msgpost as string, byval sticky as boolean)
'***************************************************
'author: zama
'last modify date: -
'
'***************************************************

    with foros(forumtype)
        if sticky then
            if cantstickys(forumtype) < max_anuncios_foro then _
                cantstickys(forumtype) = cantstickys(forumtype) + 1
        
            call movearray(forumtype, sticky)
            
            .stickytitle(1) = title
            .stickyauthor(1) = author
            .stickypost(1) = msgpost
        else
            if cantposts(forumtype) < max_mensajes_foro then _
                cantposts(forumtype) = cantposts(forumtype) + 1
            
            call movearray(forumtype, sticky)
            
            .generaltitle(1) = title
            .generalauthor(1) = author
            .generalpost(1) = msgpost
        end if
    end with

end sub

public sub clearforums()
'***************************************************
'author: zama
'last modify date: -
'
'***************************************************

    dim index as long
    
    if cantposts(eforumtype.iegeneral) > 0 then
        for index = 1 to cantposts(eforumtype.iegeneral)
            foros(eforumtype.iegeneral).generalauthor(index) = vbnullstring
            foros(eforumtype.iegeneral).generaltitle(index) = vbnullstring
            foros(eforumtype.iegeneral).generalpost(index) = vbnullstring
        next index
        
        cantposts(eforumtype.iegeneral) = 0
    end if
    
    if cantposts(eforumtype.iereal) > 0 then
        for index = 1 to cantposts(eforumtype.iereal)
            foros(eforumtype.iereal).generalauthor(index) = vbnullstring
            foros(eforumtype.iereal).generaltitle(index) = vbnullstring
            foros(eforumtype.iereal).generalpost(index) = vbnullstring
        next index
        
        cantposts(eforumtype.iereal) = 0
    end if
    
    if cantposts(eforumtype.iecaos) > 0 then
        for index = 1 to cantposts(eforumtype.iecaos)
            foros(eforumtype.iecaos).generalauthor(index) = vbnullstring
            foros(eforumtype.iecaos).generaltitle(index) = vbnullstring
            foros(eforumtype.iecaos).generalpost(index) = vbnullstring
        next index
        
        cantposts(eforumtype.iecaos) = 0
    end if
    
    if cantstickys(eforumtype.iegeneral) > 0 then
        for index = 1 to cantstickys(eforumtype.iegeneral)
            foros(eforumtype.iegeneral).stickyauthor(index) = vbnullstring
            foros(eforumtype.iegeneral).stickytitle(index) = vbnullstring
            foros(eforumtype.iegeneral).stickypost(index) = vbnullstring
        next index
        
        cantstickys(eforumtype.iegeneral) = 0
    end if
    
    if cantstickys(eforumtype.iereal) > 0 then
        for index = 1 to cantstickys(eforumtype.iereal)
            foros(eforumtype.iereal).stickyauthor(index) = vbnullstring
            foros(eforumtype.iereal).stickytitle(index) = vbnullstring
            foros(eforumtype.iereal).stickypost(index) = vbnullstring
        next index
        
        cantstickys(eforumtype.iereal) = 0
    end if
    
    if cantstickys(eforumtype.iecaos) > 0 then
        for index = 1 to cantstickys(eforumtype.iecaos)
            foros(eforumtype.iecaos).stickyauthor(index) = vbnullstring
            foros(eforumtype.iecaos).stickytitle(index) = vbnullstring
            foros(eforumtype.iecaos).stickypost(index) = vbnullstring
        next index
        
        cantstickys(eforumtype.iecaos) = 0
    end if

end sub

public function getnropost(byval forumtype as eforumtype) as byte
'***************************************************
'author: zama
'last modify date: -
'
'***************************************************

    getnropost = cantposts(forumtype)
end function

public function getnrosticky(byval forumtype as eforumtype) as byte
'***************************************************
'author: zama
'last modify date: -
'
'***************************************************

    getnrosticky = cantstickys(forumtype)
end function

private sub movearray(byval forumtype as eforumtype, byval sticky as boolean)
dim i as long

with foros(forumtype)
    if sticky then
        for i = cantstickys(forumtype) to 2 step -1
            .stickytitle(i) = .stickytitle(i - 1)
            .stickypost(i) = .stickypost(i - 1)
            .stickyauthor(i) = .stickyauthor(i - 1)
        next i
    else
        for i = cantposts(forumtype) to 2 step -1
            .generaltitle(i) = .generaltitle(i - 1)
            .generalpost(i) = .generalpost(i - 1)
            .generalauthor(i) = .generalauthor(i - 1)
        next i
    end if
end with
end sub
