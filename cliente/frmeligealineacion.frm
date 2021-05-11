version 5.00
begin vb.form frmeligealineacion 
   backcolor       =   &h00000000&
   borderstyle     =   1  'fixed single
   clientheight    =   5250
   clientleft      =   15
   clienttop       =   15
   clientwidth     =   6705
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   5250
   scalewidth      =   6705
   startupposition =   1  'centerowner
   begin vb.label lblsalir 
      alignment       =   2  'center
      borderstyle     =   1  'fixed single
      caption         =   "salir"
      beginproperty font 
         name            =   "courier new"
         size            =   12
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   285
      left            =   5400
      tabindex        =   10
      top             =   4860
      width           =   915
   end
   begin vb.label lbldescripcion 
      backcolor       =   &h00000040&
      backstyle       =   0  'transparent
      caption         =   $"frmeligealineacion.frx":0000
      forecolor       =   &h00ffffff&
      height          =   645
      index           =   1
      left            =   1095
      tabindex        =   9
      top             =   4140
      width           =   5505
   end
   begin vb.label lbldescripcion 
      backcolor       =   &h00000080&
      backstyle       =   0  'transparent
      caption         =   $"frmeligealineacion.frx":00d5
      forecolor       =   &h00ffffff&
      height          =   645
      index           =   5
      left            =   1095
      tabindex        =   8
      top             =   3240
      width           =   5505
   end
   begin vb.label lbldescripcion 
      backcolor       =   &h00400040&
      backstyle       =   0  'transparent
      caption         =   $"frmeligealineacion.frx":01b1
      forecolor       =   &h00ffffff&
      height          =   645
      index           =   2
      left            =   1095
      tabindex        =   7
      top             =   2295
      width           =   5505
   end
   begin vb.label lbldescripcion 
      backcolor       =   &h00800000&
      backstyle       =   0  'transparent
      caption         =   $"frmeligealineacion.frx":025d
      forecolor       =   &h00ffffff&
      height          =   645
      index           =   4
      left            =   1095
      tabindex        =   6
      top             =   1350
      width           =   5505
   end
   begin vb.label lbldescripcion 
      backcolor       =   &h00400000&
      backstyle       =   0  'transparent
      caption         =   $"frmeligealineacion.frx":0326
      forecolor       =   &h00ffffff&
      height          =   825
      index           =   0
      left            =   1095
      tabindex        =   5
      top             =   270
      width           =   5505
   end
   begin vb.label lblnombre 
      backstyle       =   0  'transparent
      caption         =   "alineaci�n del mal"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   240
      index           =   1
      left            =   1005
      tabindex        =   4
      top             =   3915
      width           =   1680
   end
   begin vb.label lblnombre 
      backstyle       =   0  'transparent
      caption         =   "alineaci�n criminal"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   240
      index           =   5
      left            =   1005
      tabindex        =   3
      top             =   3015
      width           =   1680
   end
   begin vb.label lblnombre 
      backstyle       =   0  'transparent
      caption         =   "alineaci�n neutral"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   240
      index           =   2
      left            =   1005
      tabindex        =   2
      top             =   2070
      width           =   1635
   end
   begin vb.label lblnombre 
      backstyle       =   0  'transparent
      caption         =   "alineaci�n legal"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   240
      index           =   4
      left            =   1005
      tabindex        =   1
      top             =   1125
      width           =   1455
   end
   begin vb.label lblnombre 
      backstyle       =   0  'transparent
      caption         =   "alineaci�n real"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   240
      index           =   0
      left            =   1000
      tabindex        =   0
      top             =   45
      width           =   1455
   end
end
attribute vb_name = "frmeligealineacion"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmeligealineacion.frm
'
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

dim lastcoloured as byte

'odio programar sin tiempo (c) el oso

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lbldescripcion(lastcoloured).borderstyle = 0
    lbldescripcion(lastcoloured).backstyle = 0
end sub

private sub lbldescripcion_click(index as integer)
    call writeguildfundate(index)
    unload me
end sub

private sub lbldescripcion_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
    
    if lastcoloured <> index then
        lbldescripcion(lastcoloured).borderstyle = 0
        lbldescripcion(lastcoloured).backstyle = 0
    end if
    
    lbldescripcion(index).borderstyle = 1
    lbldescripcion(index).backstyle = 1
    
    select case index
        case 0
            lbldescripcion(index).backcolor = &h400000
        case 4
            lbldescripcion(index).backcolor = &h800000
        case 2
            lbldescripcion(index).backcolor = 4194368
        case 5
            lbldescripcion(index).backcolor = &h80&
        case 1
            lbldescripcion(index).backcolor = &h40&
    end select
    
    lastcoloured = index
end sub


private sub lblnombre_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
    lbldescripcion(lastcoloured).borderstyle = 0
    lbldescripcion(lastcoloured).backstyle = 0
end sub

private sub lblsalir_click()
    unload me
end sub
