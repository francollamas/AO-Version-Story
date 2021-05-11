version 5.00
begin vb.form frmmapa 
   backcolor       =   &h80000007&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   6780
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   8775
   clipcontrols    =   0   'false
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   6780
   scalewidth      =   8775
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
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
      forecolor       =   &h8000000e&
      height          =   975
      left            =   240
      tabindex        =   0
      top             =   5040
      width           =   8175
   end
   begin vb.image imgmapdungeon 
      height          =   4935
      left            =   0
      top             =   0
      width           =   8775
   end
   begin vb.image imgmap 
      height          =   4935
      left            =   0
      top             =   0
      width           =   8775
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

    imgmap.visible = not imgmap.visible
    imgmapdungeon.visible = not imgmapdungeon.visible
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
    
    'cargamos las imagenes de los mapas
    imgmap.picture = loadpicture(dirgraficos & "mapa1.jpg")
    imgmapdungeon.picture = loadpicture(dirgraficos & "mapa2.jpg")
    
    
    'ajustamos el tama�o del formulario a la imagen m�s grande
    if imgmap.width > imgmapdungeon.width then
        me.width = imgmap.width
    else
        me.width = imgmapdungeon.width
    end if
    
    if imgmap.height > imgmapdungeon.height then
        me.height = imgmap.height + lbltexto.height
    else
        me.height = imgmapdungeon.height + lbltexto.height
    end if
    
    'movemos ambas im�genes al centro del formulario
    imgmap.left = me.width * 0.5 - imgmap.width * 0.5
    imgmap.top = (me.height - lbltexto.height) * 0.5 - imgmap.height * 0.5
    
    imgmapdungeon.left = me.width * 0.5 - imgmapdungeon.width * 0.5
    imgmapdungeon.top = (me.height - lbltexto.height) * 0.5 - imgmapdungeon.height * 0.5
    
    lbltexto.top = me.height - lbltexto.height
    lbltexto.left = me.width * 0.5 - lbltexto.width * 0.5
    
    imgmapdungeon.visible = false
    exit sub
error:
    msgbox err.description, vbinformation, "error: " & err.number
    unload me
end sub
