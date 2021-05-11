version 5.00
begin vb.form frmmensaje 
   backcolor       =   &h00c0c0c0&
   borderstyle     =   0  'none
   clientheight    =   3180
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   3990
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   scaleheight     =   212
   scalemode       =   3  'pixel
   scalewidth      =   266
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.image imgcerrar 
      height          =   375
      left            =   720
      tag             =   "1"
      top             =   2685
      width           =   2655
   end
   begin vb.label msg 
      backstyle       =   0  'transparent
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
      height          =   2055
      left            =   240
      tabindex        =   0
      top             =   480
      width           =   3495
      wordwrap        =   -1  'true
   end
end
attribute vb_name = "frmmensaje"
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

private cbotoncerrar as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private sub form_deactivate()
    me.setfocus
end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanamsj.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotoncerrar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarmsj.jpg", _
                                    grhpath & "botoncerrarrollovermsj.jpg", _
                                    grhpath & "botoncerrarclickmsj.jpg", me)
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub msg_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub
