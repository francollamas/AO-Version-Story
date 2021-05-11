version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsgraphicalbutton"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'*****************************************************
'graphical button
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

private withevents buttonholder as image
attribute buttonholder.vb_varhelpid = -1

private rolloverbuttonimage as picture  'img holder
private normalbuttonimage as picture 'img holder
private clickbuttonimage as picture  'img holder
private disabledbuttonimage as picture  'img holder

private soundclick as boolean

private formactual as form ' form owner

private overbutton as boolean 'indicates wether the mouse is over the button or not
private disabled as boolean 'indicates wether it's enabled or not

public sub initialize(byref imgbutton as image, byval imgnormalpath as string, _
            byval imgrolloverpath as string, byval imgclickpath as string, byref formulario as form, _
            optional byval imgdisabledpath as string, optional byval startdisabled as boolean = false, _
            optional byval makeclicksound as boolean = true, optional byval showhandpointer as boolean = true)
'***************************************************
'author: zama
'last modify date: 22/12/09
'sets the reference to the image container
'***************************************************
    set buttonholder = imgbutton
    set formactual = formulario
    
    set rolloverbuttonimage = loadpicture(imgrolloverpath)
    set normalbuttonimage = loadpicture(imgnormalpath)
    set clickbuttonimage = loadpicture(imgclickpath)
    set disabledbuttonimage = loadpicture(imgdisabledpath)
    
    soundclick = makeclicksound
    
    with buttonholder
        if showhandpointer then
            .mousepointer = vbcustom
            .mouseicon = picmouseicon
        end if
        
        if startdisabled then
            disabled = true
            .picture = disabledbuttonimage
        else
            .picture = normalbuttonimage
        end if
    end with
    
end sub

private sub buttonholder_click()
'***************************************************
'author: zama
'last modify date: 02/01/2010
'implements the mouse click event of the image button.
'plays the click sound.
'***************************************************
    if disabled then exit sub
    if not soundclick then exit sub
    
    call audio.playwave(snd_click)
end sub

private sub buttonholder_mousedown(button as integer, shift as integer, x as single, y as single)
'***************************************************
'author: zama
'last modify date: 29/12/09
'implements the mouse down event of the image button.
'toggle to click image button.
'***************************************************
    if disabled then exit sub
    
    buttonholder.picture = clickbuttonimage
end sub

private sub buttonholder_mousemove(button as integer, shift as integer, x as single, y as single)
'***************************************************
'author: zama
'last modify date: 22/12/09
'implements the mouse move event of the image button.
'toggle to pressed image button.
'***************************************************
    if disabled then exit sub
    
    if not overbutton then
    
        'this helps when two buttons are close
        formactual.lastbuttonpressed.toggletonormal
        
        buttonholder.picture = rolloverbuttonimage
        overbutton = true
        
        set formactual.lastbuttonpressed = me
    end if
end sub

public sub toggletonormal()
'***************************************************
'author: zama
'last modify date: 22/12/09
'toggle to normal image button.
'***************************************************
    if disabled then exit sub
    
    if not overbutton then exit sub
    
    buttonholder.picture = normalbuttonimage
    overbutton = false
end sub

private sub buttonholder_mouseup(button as integer, shift as integer, x as single, y as single)
'***************************************************
'author: zama
'last modify date: 29/12/09
'implements the mouse up event of the image button.
'toggle to rollover image button.
'***************************************************
    if disabled then exit sub
    
    buttonholder.picture = rolloverbuttonimage
end sub

public sub enablebutton(optional byval toogleenable as boolean = true)
    if disabled = not toogleenable then exit sub
    
    overbutton = false
    disabled = not toogleenable
    if disabled then
        buttonholder.picture = disabledbuttonimage
    else
        buttonholder.picture = normalbuttonimage
    end if
    
end sub

public function isenabled() as boolean
    isenabled = not disabled
end function
