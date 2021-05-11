version 5.00
begin vb.form frmguilddetails 
   borderstyle     =   0  'none
   caption         =   "detalles del clan"
   clientheight    =   6810
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   6840
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
   scaleheight     =   454
   scalemode       =   3  'pixel
   scalewidth      =   456
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txtdesc 
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
      height          =   1500
      left            =   405
      multiline       =   -1  'true
      tabindex        =   0
      top             =   420
      width           =   6015
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   0
      left            =   480
      tabindex        =   1
      top             =   3255
      width           =   5835
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   1
      left            =   480
      tabindex        =   2
      top             =   3645
      width           =   5835
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   2
      left            =   480
      tabindex        =   3
      top             =   4020
      width           =   5835
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   3
      left            =   480
      tabindex        =   4
      top             =   4380
      width           =   5835
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   4
      left            =   480
      tabindex        =   5
      top             =   4755
      width           =   5835
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   5
      left            =   480
      tabindex        =   6
      top             =   5130
      width           =   5835
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   6
      left            =   480
      tabindex        =   7
      top             =   5505
      width           =   5835
   end
   begin vb.textbox txtcodex1 
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
      forecolor       =   &h80000004&
      height          =   255
      index           =   7
      left            =   480
      tabindex        =   8
      top             =   5865
      width           =   5835
   end
   begin vb.image imgconfirmar 
      height          =   360
      left            =   4920
      tag             =   "1"
      top             =   6360
      width           =   1455
   end
   begin vb.image imgsalir 
      height          =   360
      left            =   480
      tag             =   "1"
      top             =   6360
      width           =   1455
   end
end
attribute vb_name = "frmguilddetails"
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

private cbotonconfirmar as clsgraphicalbutton
private cbotonsalir as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private const max_desc_length as integer = 520
private const max_codex_length as integer = 100

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanacodex.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonconfirmar = new clsgraphicalbutton
    set cbotonsalir = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotonconfirmar.initialize(imgconfirmar, grhpath & "botonconfirmarcodex.jpg", _
                                    grhpath & "botonconfirmarrollovercodex.jpg", _
                                    grhpath & "botonconfirmarclickcodex.jpg", me)

    call cbotonsalir.initialize(imgsalir, grhpath & "botonsalircodex.jpg", _
                                    grhpath & "botonsalirrollovercodex.jpg", _
                                    grhpath & "botonsalirclickcodex.jpg", me)
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgconfirmar_click()
    dim fdesc as string
    dim codex() as string
    dim k as byte
    dim cont as byte

    fdesc = replace(txtdesc, vbcrlf, "�", , , vbbinarycompare)


    cont = 0
    for k = 0 to txtcodex1.ubound
        if lenb(txtcodex1(k).text) <> 0 then cont = cont + 1
    next k
    
    if cont < 4 then
        msgbox "debes definir al menos cuatro mandamientos."
        exit sub
    end if
                
    redim codex(txtcodex1.ubound) as string
    for k = 0 to txtcodex1.ubound
        codex(k) = txtcodex1(k)
    next k

    if creandoclan then
        call writecreatenewguild(fdesc, clanname, site, codex)
    else
        call writeclancodexupdate(fdesc, codex)
    end if

    creandoclan = false
    unload me
end sub

private sub imgsalir_click()
    unload me
end sub

private sub txtcodex1_change(index as integer)
    if len(txtcodex1.item(index).text) > max_codex_length then _
        txtcodex1.item(index).text = left$(txtcodex1.item(index).text, max_codex_length)
end sub

private sub txtcodex1_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub txtdesc_change()
    if len(txtdesc.text) > max_desc_length then _
        txtdesc.text = left$(txtdesc.text, max_desc_length)
end sub
