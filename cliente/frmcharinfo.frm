version 5.00
begin vb.form frmcharinfo 
   borderstyle     =   0  'none
   caption         =   "informaci�n del personaje"
   clientheight    =   6585
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   6390
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
   scaleheight     =   439
   scalemode       =   3  'pixel
   scalewidth      =   426
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txtpeticiones 
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
      height          =   1080
      left            =   360
      locked          =   -1  'true
      multiline       =   -1  'true
      scrollbars      =   2  'vertical
      tabindex        =   1
      top             =   3210
      width           =   5730
   end
   begin vb.textbox txtmiembro 
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
      height          =   1080
      left            =   360
      locked          =   -1  'true
      multiline       =   -1  'true
      scrollbars      =   2  'vertical
      tabindex        =   0
      top             =   4695
      width           =   5730
   end
   begin vb.image imgaceptar 
      height          =   510
      left            =   5160
      tag             =   "1"
      top             =   5955
      width           =   1020
   end
   begin vb.image imgrechazar 
      height          =   510
      left            =   3840
      tag             =   "1"
      top             =   5955
      width           =   1020
   end
   begin vb.image imgpeticion 
      height          =   510
      left            =   2640
      tag             =   "1"
      top             =   5955
      width           =   1020
   end
   begin vb.image imgechar 
      height          =   510
      left            =   1440
      tag             =   "1"
      top             =   5955
      width           =   1020
   end
   begin vb.image imgcerrar 
      height          =   510
      left            =   120
      tag             =   "1"
      top             =   5955
      width           =   1020
   end
   begin vb.label status 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   3120
      tabindex        =   14
      top             =   2280
      width           =   1080
   end
   begin vb.label nombre 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1320
      tabindex        =   13
      top             =   700
      width           =   1440
   end
   begin vb.label nivel 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1320
      tabindex        =   12
      top             =   1750
      width           =   1185
   end
   begin vb.label clase 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1320
      tabindex        =   11
      top             =   1225
      width           =   1575
   end
   begin vb.label raza 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1320
      tabindex        =   10
      top             =   960
      width           =   1560
   end
   begin vb.label genero 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1320
      tabindex        =   9
      top             =   1500
      width           =   1335
   end
   begin vb.label oro 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1320
      tabindex        =   8
      top             =   2010
      width           =   1365
   end
   begin vb.label banco 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1320
      tabindex        =   7
      top             =   2250
      width           =   1425
   end
   begin vb.label guildactual 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   3960
      tabindex        =   6
      top             =   960
      width           =   2265
   end
   begin vb.label ejercito 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   3960
      tabindex        =   5
      top             =   1230
      width           =   1785
   end
   begin vb.label ciudadanos 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   4905
      tabindex        =   4
      top             =   1500
      width           =   1185
   end
   begin vb.label criminales 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   4920
      tabindex        =   3
      top             =   1770
      width           =   1185
   end
   begin vb.label reputacion 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   4905
      tabindex        =   2
      top             =   2040
      width           =   1185
   end
end
attribute vb_name = "frmcharinfo"
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
private cbotonpeticion as clsgraphicalbutton
private cbotonrechazar as clsgraphicalbutton
private cbotonechar as clsgraphicalbutton
private cbotonaceptar as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

public enum charinfofrmtype
    frmmembers
    frmmembershiprequests
end enum

public frmtype as charinfofrmtype

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanainfopj.jpg")
    
    call loadbuttons
    
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotoncerrar = new clsgraphicalbutton
    set cbotonpeticion = new clsgraphicalbutton
    set cbotonrechazar = new clsgraphicalbutton
    set cbotonechar = new clsgraphicalbutton
    set cbotonaceptar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarinfochar.jpg", _
                                    grhpath & "botoncerrarrolloverinfochar.jpg", _
                                    grhpath & "botoncerrarclickinfochar.jpg", me)

    call cbotonpeticion.initialize(imgpeticion, grhpath & "botonpeticion.jpg", _
                                    grhpath & "botonpeticionrollover.jpg", _
                                    grhpath & "botonpeticionclick.jpg", me)

    call cbotonrechazar.initialize(imgrechazar, grhpath & "botonrechazar.jpg", _
                                    grhpath & "botonrechazarrollover.jpg", _
                                    grhpath & "botonrechazarclick.jpg", me)

    call cbotonechar.initialize(imgechar, grhpath & "botonechar.jpg", _
                                    grhpath & "botonecharrollover.jpg", _
                                    grhpath & "botonecharclick.jpg", me)
                                    
    call cbotonaceptar.initialize(imgaceptar, grhpath & "botonaceptarinfochar.jpg", _
                                    grhpath & "botonaceptarrolloverinfochar.jpg", _
                                    grhpath & "botonaceptarclickinfochar.jpg", me)

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgaceptar_click()
    call writeguildacceptnewmember(nombre)
    unload frmguildleader
    call writerequestguildleaderinfo
    unload me
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgechar_click()
    call writeguildkickmember(nombre)
    unload frmguildleader
    call writerequestguildleaderinfo
    unload me
end sub

private sub imgpeticion_click()
    call writeguildrequestjoinerinfo(nombre)
end sub

private sub imgrechazar_click()
    frmcommet.t = rechazopj
    frmcommet.nombre = nombre.caption
    frmcommet.show vbmodeless, frmcharinfo
end sub

private sub txtmiembro_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub
