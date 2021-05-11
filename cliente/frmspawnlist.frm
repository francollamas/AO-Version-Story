version 5.00
begin vb.form frmspawnlist 
   borderstyle     =   0  'none
   caption         =   "invocar"
   clientheight    =   3465
   clientleft      =   0
   clienttop       =   -105
   clientwidth     =   3300
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   231
   scalemode       =   3  'pixel
   scalewidth      =   220
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.listbox lstcriaturas 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
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
      height          =   2175
      left            =   420
      tabindex        =   0
      top             =   495
      width           =   2355
   end
   begin vb.image imgsalir 
      height          =   375
      left            =   360
      top             =   2910
      width           =   855
   end
   begin vb.image imginvocar 
      height          =   375
      left            =   1500
      top             =   2910
      width           =   1335
   end
end
attribute vb_name = "frmspawnlist"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

private clsformulario as clsformmovementmanager

private cbotoninvocar as clsgraphicalbutton
private cbotonsalir as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanainvocar.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotoninvocar = new clsgraphicalbutton
    set cbotonsalir = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotoninvocar.initialize(imginvocar, grhpath & "botoninvocar.jpg", _
                                    grhpath & "botoninvocarrollover.jpg", _
                                    grhpath & "botoninvocarclick.jpg", me)

    call cbotonsalir.initialize(imgsalir, grhpath & "botonsalirinvocar.jpg", _
                                    grhpath & "botonsalirrolloverinvocar.jpg", _
                                    grhpath & "botonsalirclickinvocar.jpg", me)
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imginvocar_click()
    call writespawncreature(lstcriaturas.listindex + 1)
end sub

private sub imgsalir_click()
    unload me
end sub

private sub lstcriaturas_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub
