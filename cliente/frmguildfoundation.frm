version 5.00
begin vb.form frmguildfoundation 
   borderstyle     =   0  'none
   caption         =   "creaci�n de un clan"
   clientheight    =   3840
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   4050
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   256
   scalemode       =   3  'pixel
   scalewidth      =   270
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txtclanname 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h00ffffff&
      height          =   285
      left            =   360
      tabindex        =   0
      top             =   1815
      width           =   3345
   end
   begin vb.textbox txtweb 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      forecolor       =   &h00ffffff&
      height          =   285
      left            =   360
      tabindex        =   1
      top             =   2760
      width           =   3345
   end
   begin vb.image imgsiguiente 
      height          =   375
      left            =   2400
      tag             =   "1"
      top             =   3240
      width           =   1335
   end
   begin vb.image imgcancelar 
      height          =   375
      left            =   240
      tag             =   "1"
      top             =   3240
      width           =   1335
   end
end
attribute vb_name = "frmguildfoundation"
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

private cbotonsiguiente as clsgraphicalbutton
private cbotoncancelar as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private sub form_deactivate()
    me.setfocus
end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me

    me.picture = loadpicture(app.path & "\graficos\ventananombreclan.jpg")
        
    call loadbuttons
    
    if len(txtclanname.text) <= 30 then
        if not asciivalidos(txtclanname) then
            msgbox "nombre invalido."
            exit sub
        end if
    else
        msgbox "nombre demasiado extenso."
        exit sub
    end if

end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonsiguiente = new clsgraphicalbutton
    set cbotoncancelar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotonsiguiente.initialize(imgsiguiente, grhpath & "botonsiguientenombreclan.jpg", _
                                    grhpath & "botonsiguienterollovernombreclan.jpg", _
                                    grhpath & "botonsiguienteclicknombreclan.jpg", me)

    call cbotoncancelar.initialize(imgcancelar, grhpath & "botoncancelarnombreclan.jpg", _
                                    grhpath & "botoncancelarrollovernombreclan.jpg", _
                                    grhpath & "botoncancelarclicknombreclan.jpg", me)

end sub


private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgcancelar_click()
    unload me
end sub

private sub imgsiguiente_click()
    clanname = txtclanname.text
    site = txtweb.text
    unload me
    frmguilddetails.show , frmmain
end sub

private sub txtweb_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub
