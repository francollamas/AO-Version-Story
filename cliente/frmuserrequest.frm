version 5.00
begin vb.form frmuserrequest 
   borderstyle     =   0  'none
   clientheight    =   2430
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   4650
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   scaleheight     =   162
   scalemode       =   3  'pixel
   scalewidth      =   310
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox text1 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   1395
      left            =   225
      multiline       =   -1  'true
      tabindex        =   0
      top             =   405
      width           =   4185
   end
   begin vb.image imgcerrar 
      height          =   375
      left            =   120
      tag             =   "1"
      top             =   1920
      width           =   4350
   end
end
attribute vb_name = "frmuserrequest"
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

private cbotoncerrar as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private clsformulario as clsformmovementmanager

public sub recievepeticion(byval p as string)

    text1 = replace$(p, "�", vbcrlf)
    me.show vbmodeless, frmmain

end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanapeticion.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotoncerrar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarpeticion.jpg", _
                                    grhpath & "botoncerrarrolloverpeticion.jpg", _
                                    grhpath & "botoncerrarclickpeticion.jpg", me)
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub text1_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub
