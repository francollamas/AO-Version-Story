version 5.00
object = "{6b7e6392-850a-101b-afc0-4210102a8da7}#1.3#0"; "comctl32.ocx"
begin vb.form frmstat 
   backcolor       =   &h00c0c0c0&
   borderstyle     =   3  'fixed dialog
   clientheight    =   1095
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   5625
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   73
   scalemode       =   3  'pixel
   scalewidth      =   375
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin comctllib.progressbar progressbar1 
      height          =   255
      left            =   240
      tabindex        =   1
      top             =   600
      width           =   5175
      _extentx        =   9128
      _extenty        =   450
      _version        =   327682
      appearance      =   1
   end
   begin vb.label titu 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "procesando mapas..."
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000000&
      height          =   195
      left            =   2040
      tabindex        =   0
      top             =   240
      width           =   1800
   end
end
attribute vb_name = "frmstat"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.2
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

option explicit
