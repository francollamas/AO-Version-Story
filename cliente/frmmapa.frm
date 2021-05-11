version 5.00
begin vb.form frmmapa 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   8850
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   8595
   clipcontrols    =   0   'false
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   8850
   scalewidth      =   8595
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.image imgtooglemap 
      height          =   255
      index           =   1
      left            =   3840
      mousepointer    =   99  'custom
      top             =   120
      width           =   975
   end
   begin vb.image imgtooglemap 
      height          =   255
      index           =   0
      left            =   3960
      mousepointer    =   99  'custom
      top             =   7560
      width           =   735
   end
   begin vb.image imgcerrar 
      height          =   255
      left            =   8040
      mousepointer    =   99  'custom
      top             =   240
      width           =   255
   end
   begin vb.label lbltexto 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   $"frmmapa.frx":0000
      beginproperty font 
         name            =   "ms sans serif"
         size            =   12
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   975
      left            =   0
      tabindex        =   0
      top             =   7920
      width           =   8175
   end
end
attribute vb_name = "frmmapa"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
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

private clsformulario as clsformmovementmanager

private enum emaps
    iegeneral
    iedungeon
end enum

private picmaps(1) as picture

private currentmap as emaps

''
' this form is used to show the world map.
' it has two levels. the world map and the dungeons map.
' you can toggle between them pressing the arrows
'
' @file     frmmapa.frm
' @author marco vanotti (markoxx) marcovanotti15@gmail.com
' @version 1.0.0
' @date 20080724

''
' checks what key is down. if the key is const vbkeydown or const vbkeyup, it toggles the maps, else the form unloads.
'
' @param keycode specifies the key pressed
' @param shift specifies if shift button is pressed
private sub form_keydown(keycode as integer, shift as integer)
'*************************************************
'author: marco vanotti (markoxx)
'last modified: 24/07/08
'
'*************************************************

    select case keycode
        case vbkeydown, vbkeyup 'cambiamos el "nivel" del mapa, al estilo zelda ;d
            toggleimgmaps
        case else
            unload me
    end select
    
end sub

''
' toggle which image is visible.
'
private sub toggleimgmaps()
'*************************************************
'author: marco vanotti (markoxx)
'last modified: 24/07/08
'
'*************************************************

    imgtooglemap(currentmap).visible = false
    
    if currentmap = emaps.iegeneral then
        imgcerrar.visible = false
        currentmap = emaps.iedungeon
    else
        imgcerrar.visible = true
        currentmap = emaps.iegeneral
    end if
    
    imgtooglemap(currentmap).visible = true
    me.picture = picmaps(currentmap)
end sub

''
' load the images. resizes the form, adjusts image's left and top and set lbltexto's top and left.
'
private sub form_load()
'*************************************************
'author: marco vanotti (markoxx)
'last modified: 24/07/08
'
'*************************************************

on error goto error
    
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
        
    'cargamos las imagenes de los mapas
    set picmaps(emaps.iegeneral) = loadpicture(dirgraficos & "mapa1.jpg")
    set picmaps(emaps.iedungeon) = loadpicture(dirgraficos & "mapa2.jpg")
    
    ' imagen de fondo
    currentmap = emaps.iegeneral
    me.picture = picmaps(currentmap)
    
    imgcerrar.mouseicon = picmouseicon
    imgtooglemap(0).mouseicon = picmouseicon
    imgtooglemap(1).mouseicon = picmouseicon
    
    exit sub
error:
    msgbox err.description, vbinformation, "error: " & err.number
    unload me
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgtooglemap_click(index as integer)
    toggleimgmaps
end sub
