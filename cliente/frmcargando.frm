version 5.00
object = "{3b7c8863-d78f-101b-b9b5-04021c009402}#1.2#0"; "richtx32.ocx"
begin vb.form frmcargando 
   autoredraw      =   -1  'true
   backcolor       =   &h00000000&
   borderstyle     =   3  'fixed dialog
   clientheight    =   7245
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   9630
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   483
   scalemode       =   3  'pixel
   scalewidth      =   642
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.filelistbox mp3files 
      height          =   480
      left            =   180
      pattern         =   "*.mp3"
      tabindex        =   2
      top             =   240
      visible         =   0   'false
      width           =   1215
   end
   begin richtextlib.richtextbox status 
      height          =   2400
      left            =   2340
      tabindex        =   1
      tabstop         =   0   'false
      tooltiptext     =   "mensajes del servidor"
      top             =   2940
      width           =   5160
      _extentx        =   9102
      _extenty        =   4233
      _version        =   393217
      backcolor       =   8421376
      readonly        =   -1  'true
      scrollbars      =   2
      textrtf         =   $"frmcargando.frx":0000
      beginproperty font {0be35203-8f91-11ce-9de3-00aa004bb851} 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   -1  'true
         strikethrough   =   0   'false
      endproperty
   end
   begin vb.picturebox logo 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      height          =   7200
      left            =   45
      scaleheight     =   480
      scalemode       =   3  'pixel
      scalewidth      =   640
      tabindex        =   0
      top             =   45
      width           =   9600
   end
end
attribute vb_name = "frmcargando"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
'
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'gnu general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'
'argentum online is based on baronsoft's vb6 online rpg
'you can contact the original creator of ore at aaron@baronsoft.com
'for more information about ore please visit http://www.baronsoft.com/
'
'
'you can contact me at:
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'calle 3 n�mero 983 piso 7 dto a
'la plata - pcia, buenos aires - republica argentina
'c�digo postal 1900
'pablo ignacio m�rquez



private sub form_load()
logo.picture = loadpicture(dirgraficos & "cargando.jpg")
end sub

