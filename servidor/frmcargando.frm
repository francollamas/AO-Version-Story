version 5.00
object = "{6b7e6392-850a-101b-afc0-4210102a8da7}#1.3#0"; "comctl32.ocx"
begin vb.form frmcargando 
   backcolor       =   &h00c0c0c0&
   borderstyle     =   0  'none
   caption         =   "argentum"
   clientheight    =   3105
   clientleft      =   1410
   clienttop       =   3000
   clientwidth     =   6450
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   261.181
   scalemode       =   0  'user
   scalewidth      =   430
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin comctllib.progressbar cargar 
      height          =   255
      left            =   120
      tabindex        =   3
      top             =   2760
      width           =   3855
      _extentx        =   6800
      _extenty        =   450
      _version        =   327682
      appearance      =   1
      min             =   1e-4
   end
   begin vb.picturebox picture1 
      borderstyle     =   0  'none
      height          =   2775
      left            =   -120
      scaleheight     =   2775
      scalewidth      =   6735
      tabindex        =   0
      top             =   -120
      width           =   6735
      begin vb.label label1 
         alignment       =   2  'center
         autosize        =   -1  'true
         backstyle       =   0  'transparent
         caption         =   "cargando, por favor espere..."
         forecolor       =   &h000000ff&
         height          =   225
         index           =   3
         left            =   2280
         tabindex        =   2
         top             =   2040
         width           =   2445
      end
   end
   begin vb.label label1 
      alignment       =   1  'right justify
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   " aa"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000000&
      height          =   195
      index           =   2
      left            =   6120
      tabindex        =   1
      top             =   2760
      width           =   255
   end
end
attribute vb_name = "frmcargando"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.12.2
'copyright (c) 2002 m�rquez pablo ignacio
'
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

option explicit

private sub form_load()
'label1(1).caption = label1(1).caption & " v." & app.major & "." & app.minor & "." & app.revision
picture1.picture = loadpicture(app.path & "\logo.jpg")
end sub
