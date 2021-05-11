version 5.00
begin vb.form frmguildbrief 
   borderstyle     =   0  'none
   clientheight    =   7650
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   7620
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
   scaleheight     =   510
   scalemode       =   3  'pixel
   scalewidth      =   508
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   tag             =   "&h8000000a&"
   begin vb.textbox desc 
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
      height          =   915
      left            =   315
      locked          =   -1  'true
      multiline       =   -1  'true
      tabindex        =   19
      top             =   6090
      width           =   6930
   end
   begin vb.image imgsolicitaringreso 
      height          =   375
      left            =   6000
      tag             =   "1"
      top             =   7170
      width           =   1335
   end
   begin vb.image imgdeclararguerra 
      height          =   375
      left            =   4560
      tag             =   "1"
      top             =   7170
      width           =   1335
   end
   begin vb.image imgofreceralianza 
      height          =   375
      left            =   3120
      tag             =   "1"
      top             =   7170
      width           =   1335
   end
   begin vb.image imgofrecerpaz 
      height          =   375
      left            =   1680
      tag             =   "1"
      top             =   7170
      width           =   1335
   end
   begin vb.image imgcerrar 
      height          =   360
      left            =   120
      tag             =   "1"
      top             =   7170
      width           =   1455
   end
   begin vb.label codex 
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
      index           =   0
      left            =   360
      tabindex        =   18
      top             =   3600
      width           =   6735
   end
   begin vb.label codex 
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
      index           =   1
      left            =   360
      tabindex        =   17
      top             =   3840
      width           =   6735
   end
   begin vb.label codex 
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
      index           =   2
      left            =   360
      tabindex        =   16
      top             =   4080
      width           =   6735
   end
   begin vb.label codex 
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
      index           =   3
      left            =   360
      tabindex        =   15
      top             =   4320
      width           =   6735
   end
   begin vb.label codex 
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
      index           =   4
      left            =   360
      tabindex        =   14
      top             =   4560
      width           =   6735
   end
   begin vb.label codex 
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
      index           =   5
      left            =   360
      tabindex        =   13
      top             =   4800
      width           =   6735
   end
   begin vb.label codex 
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
      index           =   6
      left            =   360
      tabindex        =   12
      top             =   5040
      width           =   6735
   end
   begin vb.label codex 
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
      index           =   7
      left            =   360
      tabindex        =   11
      top             =   5280
      width           =   6735
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
      tabindex        =   10
      top             =   540
      width           =   4695
   end
   begin vb.label fundador 
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
      left            =   1440
      tabindex        =   9
      top             =   870
      width           =   2775
   end
   begin vb.label creacion 
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
      left            =   5760
      tabindex        =   8
      top             =   840
      width           =   1455
   end
   begin vb.label lider 
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
      left            =   1080
      tabindex        =   7
      top             =   1200
      width           =   3135
   end
   begin vb.label web 
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
      left            =   1440
      tabindex        =   6
      top             =   1545
      width           =   2655
   end
   begin vb.label miembros 
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
      left            =   5160
      tabindex        =   5
      top             =   1560
      width           =   1935
   end
   begin vb.label eleccion 
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
      left            =   5280
      tabindex        =   4
      top             =   1215
      width           =   1815
   end
   begin vb.label lblalineacion 
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
      left            =   5280
      tabindex        =   3
      top             =   1920
      width           =   1815
   end
   begin vb.label enemigos 
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
      left            =   1920
      tabindex        =   2
      top             =   1905
      width           =   2175
   end
   begin vb.label aliados 
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
      left            =   1800
      tabindex        =   1
      top             =   2235
      width           =   1575
   end
   begin vb.label antifaccion 
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
      left            =   2280
      tabindex        =   0
      top             =   2565
      width           =   2415
   end
end
attribute vb_name = "frmguildbrief"
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

private cbotonguerra as clsgraphicalbutton
private cbotonalianza as clsgraphicalbutton
private cbotonpaz as clsgraphicalbutton
private cbotonsolicitaringreso as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

public esleader as boolean

private sub desc_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanadetallesclan.jpg")
    
    call loadbuttons
    
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonguerra = new clsgraphicalbutton
    set cbotonalianza = new clsgraphicalbutton
    set cbotonpaz = new clsgraphicalbutton
    set cbotonsolicitaringreso = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotonguerra.initialize(imgdeclararguerra, grhpath & "botondeclararguerra.jpg", _
                                    grhpath & "botondeclararguerrarollover.jpg", _
                                    grhpath & "botondeclararguerraclick.jpg", me)

    call cbotonalianza.initialize(imgofreceralianza, grhpath & "botonofreceralianza.jpg", _
                                    grhpath & "botonofreceralianzarollover.jpg", _
                                    grhpath & "botonofreceralianzaclick.jpg", me)

    call cbotonpaz.initialize(imgofrecerpaz, grhpath & "botonofrecerpaz.jpg", _
                                    grhpath & "botonofrecerpazrollover.jpg", _
                                    grhpath & "botonofrecerpazclick.jpg", me)

    call cbotonsolicitaringreso.initialize(imgsolicitaringreso, grhpath & "botonsolicitaringreso.jpg", _
                                    grhpath & "botonsolicitaringresorollover.jpg", _
                                    grhpath & "botonsolicitaringresoclick.jpg", me)

    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrardetallesclan.jpg", _
                                    grhpath & "botoncerrarrolloverdetallesclan.jpg", _
                                    grhpath & "botoncerrarclickdetallesclan.jpg", me)


    if not esleader then
        imgdeclararguerra.visible = false
        imgofreceralianza.visible = false
        imgofrecerpaz.visible = false
    end if

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgdeclararguerra_click()
    call writeguilddeclarewar(nombre.caption)
    unload me
end sub

private sub imgofreceralianza_click()
    frmcommet.nombre = nombre.caption
    frmcommet.t = tipo.alianza
    call frmcommet.show(vbmodal, frmguildbrief)
end sub

private sub imgofrecerpaz_click()
    frmcommet.nombre = nombre.caption
    frmcommet.t = tipo.paz
    call frmcommet.show(vbmodal, frmguildbrief)
end sub

private sub imgsolicitaringreso_click()
    call frmguildsol.recievesolicitud(nombre.caption)
    call frmguildsol.show(vbmodal, frmguildbrief)
end sub
