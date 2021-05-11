version 5.00
begin vb.form frmentrenador 
   borderstyle     =   0  'none
   clientheight    =   3675
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   4215
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
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   245
   scalemode       =   3  'pixel
   scalewidth      =   281
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.listbox lstcriaturas 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
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
      height          =   2175
      left            =   870
      tabindex        =   0
      top             =   675
      width           =   2355
   end
   begin vb.image imgsalir 
      height          =   375
      left            =   2160
      tag             =   "1"
      top             =   3120
      width           =   1335
   end
   begin vb.image imgluchar 
      height          =   375
      left            =   600
      tag             =   "1"
      top             =   3120
      width           =   1335
   end
end
attribute vb_name = "frmentrenador"
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



'[code]:matux
'
'    le puse el iconito de la manito a los botones ^_^,
'   le puse borde a la ventana y le cambi� la letra a
'   una m�s linda :)
'
'[end]'

option explicit

private clsformulario as clsformmovementmanager

private cbotonluchar as clsgraphicalbutton
private cbotonsalir as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
        
    me.picture = loadpicture(app.path & "\graficos\ventanaentrenador.jpg")
    
    call loadbuttons
    
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonluchar = new clsgraphicalbutton
    set cbotonsalir = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotonluchar.initialize(imgluchar, grhpath & "botonluchar.jpg", _
                                    grhpath & "botonlucharrollover.jpg", _
                                    grhpath & "botonlucharclick.jpg", me)

    call cbotonsalir.initialize(imgsalir, grhpath & "botonsalirentrenador.jpg", _
                                    grhpath & "botonsalirrolloverentrenador.jpg", _
                                    grhpath & "botonsalirclickentrenador.jpg", me)

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgluchar_click()
    call writetrain(lstcriaturas.listindex + 1)
    unload me
end sub

private sub imgsalir_click()
    unload me
end sub

private sub lstcriaturas_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub
