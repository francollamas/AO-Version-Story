version 5.00
begin vb.form frmcantidad 
   backcolor       =   &h80000000&
   borderstyle     =   0  'none
   clientheight    =   1470
   clientleft      =   1635
   clienttop       =   4410
   clientwidth     =   3240
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   98
   scalemode       =   3  'pixel
   scalewidth      =   216
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txtcantidad 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
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
      height          =   315
      left            =   450
      maxlength       =   5
      tabindex        =   0
      top             =   450
      width           =   2250
   end
   begin vb.image imgtirartodo 
      height          =   375
      left            =   1680
      tag             =   "1"
      top             =   975
      width           =   1335
   end
   begin vb.image imgtirar 
      height          =   375
      left            =   210
      tag             =   "1"
      top             =   975
      width           =   1335
   end
end
attribute vb_name = "frmcantidad"
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

private cbotontirar as clsgraphicalbutton
private cbotontirartodo as clsgraphicalbutton
public lastbuttonpressed as clsgraphicalbutton

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanatiraroro.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()

    dim grhpath as string
    
    grhpath = dirgraficos
    
    set cbotontirar = new clsgraphicalbutton
    set cbotontirartodo = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton

    call cbotontirar.initialize(imgtirar, grhpath & "botontirar.jpg", grhpath & "botontirarrollover.jpg", _
                        grhpath & "botontirarclick.jpg", me)
    call cbotontirartodo.initialize(imgtirartodo, grhpath & "botontirartodo.jpg", grhpath & "botontirartodorollover.jpg", _
                        grhpath & "botontirartodoclick.jpg", me)

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgtirar_click()
    if lenb(txtcantidad.text) > 0 then
        if not isnumeric(txtcantidad.text) then exit sub  'should never happen
        
        call writedrop(inventario.selecteditem, frmcantidad.txtcantidad.text)
        frmcantidad.txtcantidad.text = ""
    end if
    
    unload me
end sub

private sub imgtirartodo_click()
    if inventario.selecteditem = 0 then exit sub
    
    if inventario.selecteditem <> flagoro then
        call writedrop(inventario.selecteditem, inventario.amount(inventario.selecteditem))
        unload me
    else
        if usergld > 10000 then
            call writedrop(inventario.selecteditem, 10000)
            unload me
        else
            call writedrop(inventario.selecteditem, usergld)
            unload me
        end if
    end if

    frmcantidad.txtcantidad.text = ""
end sub

private sub txtcantidad_change()
on error goto errhandler
    if val(txtcantidad.text) < 0 then
        txtcantidad.text = "1"
    end if
    
    if val(txtcantidad.text) > max_inventory_objs then
        txtcantidad.text = "10000"
    end if
    
    exit sub
    
errhandler:
    'if we got here the user may have pasted (shift + insert) a really large number, causing an overflow, so we set amount back to 1
    txtcantidad.text = "1"
end sub

private sub txtcantidad_keypress(keyascii as integer)
    if (keyascii <> 8) then
        if (keyascii < 48 or keyascii > 57) then
            keyascii = 0
        end if
    end if
end sub

private sub txtcantidad_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub
