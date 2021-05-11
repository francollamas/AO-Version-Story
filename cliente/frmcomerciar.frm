version 5.00
begin vb.form frmcomerciar 
   backcolor       =   &h80000013&
   borderstyle     =   0  'none
   clientheight    =   7290
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   6930
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   mousepointer    =   99  'custom
   scaleheight     =   486
   scalemode       =   3  'pixel
   scalewidth      =   462
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox cantidad 
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
      height          =   285
      left            =   3150
      tabindex        =   6
      text            =   "1"
      top             =   6570
      width           =   630
   end
   begin vb.picturebox picinvuser 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      causesvalidation=   0   'false
      clipcontrols    =   0   'false
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h80000008&
      height          =   3840
      left            =   3945
      scaleheight     =   256
      scalemode       =   3  'pixel
      scalewidth      =   160
      tabindex        =   5
      top             =   1965
      width           =   2400
   end
   begin vb.picturebox picinvnpc 
      appearance      =   0  'flat
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      causesvalidation=   0   'false
      clipcontrols    =   0   'false
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h80000008&
      height          =   3840
      left            =   600
      scaleheight     =   256
      scalemode       =   3  'pixel
      scalewidth      =   160
      tabindex        =   4
      top             =   1965
      width           =   2400
   end
   begin vb.image imgcross 
      height          =   450
      left            =   6075
      mouseicon       =   "frmcomerciar.frx":0000
      mousepointer    =   99  'custom
      tag             =   "1"
      top             =   360
      width           =   450
   end
   begin vb.image imgvender 
      height          =   465
      left            =   3840
      mouseicon       =   "frmcomerciar.frx":030a
      mousepointer    =   99  'custom
      tag             =   "1"
      top             =   6000
      width           =   2580
   end
   begin vb.image imgcomprar 
      height          =   465
      left            =   510
      mouseicon       =   "frmcomerciar.frx":045c
      mousepointer    =   99  'custom
      tag             =   "1"
      top             =   6030
      width           =   2580
   end
   begin vb.label label1 
      autosize        =   -1  'true
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
      height          =   195
      index           =   2
      left            =   3510
      tabindex        =   3
      top             =   1335
      visible         =   0   'false
      width           =   75
   end
   begin vb.label label1 
      autosize        =   -1  'true
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
      height          =   195
      index           =   3
      left            =   3510
      tabindex        =   2
      top             =   1050
      visible         =   0   'false
      width           =   75
   end
   begin vb.label label1 
      autosize        =   -1  'true
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
      height          =   195
      index           =   1
      left            =   2160
      tabindex        =   1
      top             =   1050
      width           =   75
   end
   begin vb.label label1 
      autosize        =   -1  'true
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
      height          =   195
      index           =   0
      left            =   2160
      tabindex        =   0
      top             =   720
      width           =   75
   end
end
attribute vb_name = "frmcomerciar"
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

public lastindex1 as integer
public lastindex2 as integer
public lasactionbuy as boolean
private clicknpcinv as boolean
private lindex as byte

private cbotonvender as clsgraphicalbutton
private cbotoncomprar as clsgraphicalbutton
private cbotoncruz as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

private sub cantidad_change()
    if val(cantidad.text) < 1 then
        cantidad.text = 1
    end if
    
    if val(cantidad.text) > max_inventory_objs then
        cantidad.text = max_inventory_objs
    end if
    
    if clicknpcinv then
        if invcomnpc.selecteditem <> 0 then
            'el precio, cuando nos venden algo, lo tenemos que redondear para arriba.
            label1(1).caption = "precio: " & calculatesellprice(npcinventory(invcomnpc.selecteditem).valor, val(cantidad.text))  'no mostramos numeros reales
        end if
    else
        if invcomusu.selecteditem <> 0 then
            label1(1).caption = "precio: " & calculatebuyprice(inventario.valor(invcomusu.selecteditem), val(cantidad.text))  'no mostramos numeros reales
        end if
    end if
end sub

private sub cantidad_keypress(keyascii as integer)
    if (keyascii <> 8) then
        if (keyascii <> 6) and (keyascii < 48 or keyascii > 57) then
            keyascii = 0
        end if
    end if
end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me

    
    'cargamos la interfase
    me.picture = loadpicture(dirgraficos & "ventanacomercio.jpg")
    
    call loadbuttons
    
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonvender = new clsgraphicalbutton
    set cbotoncomprar = new clsgraphicalbutton
    set cbotoncruz = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotonvender.initialize(imgvender, grhpath & "botonvender.jpg", _
                                    grhpath & "botonvenderrollover.jpg", _
                                    grhpath & "botonvenderclick.jpg", me)

    call cbotoncomprar.initialize(imgcomprar, grhpath & "botoncomprar.jpg", _
                                    grhpath & "botoncomprarrollover.jpg", _
                                    grhpath & "botoncomprarclick.jpg", me)

    call cbotoncruz.initialize(imgcross, "", _
                                    grhpath & "botoncruzapretadacomercio.jpg", _
                                    grhpath & "botoncruzapretadacomercio.jpg", me)


end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

''
' calculates the selling price of an item (the price that a merchant will sell you the item)
'
' @param objvalue specifies value of the item.
' @param objamount specifies amount of items that you want to buy
' @return   the price of the item.

private function calculatesellprice(byref objvalue as single, byval objamount as long) as long
'*************************************************
'author: marco vanotti (markoxx)
'last modified: 19/08/2008
'last modify by: franco zeoli (noich)
'*************************************************
    on error goto error
    'we get a single value from the server, when vb uses it, by approaching, it can diff with the server value, so we do (value * 100000) and get the entire part, to discard the unwanted floating values.
    calculatesellprice = ccur(objvalue * 1000000) / 1000000 * objamount + 0.5
    
    exit function
error:
    msgbox err.description, vbexclamation, "error: " & err.number
end function
''
' calculates the buying price of an item (the price that a merchant will buy you the item)
'
' @param objvalue specifies value of the item.
' @param objamount specifies amount of items that you want to buy
' @return   the price of the item.
private function calculatebuyprice(byref objvalue as single, byval objamount as long) as long
'*************************************************
'author: marco vanotti (markoxx)
'last modified: 19/08/2008
'last modify by: franco zeoli (noich)
'*************************************************
    on error goto error
    'we get a single value from the server, when vb uses it, by approaching, it can diff with the server value, so we do (value * 100000) and get the entire part, to discard the unwanted floating values.
    calculatebuyprice = fix(ccur(objvalue * 1000000) / 1000000 * objamount)
    
    exit function
error:
    msgbox err.description, vbexclamation, "error: " & err.number
end function

private sub imgcomprar_click()
    ' debe tener seleccionado un item para comprarlo.
    if invcomnpc.selecteditem = 0 then exit sub
    
    if not isnumeric(cantidad.text) or cantidad.text = 0 then exit sub
    
    call audio.playwave(snd_click)
    
    lasactionbuy = true
    if usergld >= calculatesellprice(npcinventory(invcomnpc.selecteditem).valor, val(cantidad.text)) then
        call writecommercebuy(invcomnpc.selecteditem, val(cantidad.text))
    else
        call addtorichtextbox(frmmain.rectxt, "no tienes suficiente oro.", 2, 51, 223, 1, 1)
        exit sub
    end if
    
end sub

private sub imgcross_click()
    call writecommerceend
end sub

private sub imgvender_click()
    ' debe tener seleccionado un item para comprarlo.
    if invcomusu.selecteditem = 0 then exit sub

    if not isnumeric(cantidad.text) or cantidad.text = 0 then exit sub
    
    call audio.playwave(snd_click)
    
    lasactionbuy = false

    call writecommercesell(invcomusu.selecteditem, val(cantidad.text))
end sub

private sub picinvnpc_click()
    dim itemslot as byte
    
    itemslot = invcomnpc.selecteditem
    if itemslot = 0 then exit sub
    
    clicknpcinv = true
    invcomusu.deselectitem
    
    label1(0).caption = npcinventory(itemslot).name
    label1(1).caption = "precio: " & calculatesellprice(npcinventory(itemslot).valor, val(cantidad.text)) 'no mostramos numeros reales
    
    if npcinventory(itemslot).amount <> 0 then
    
        select case npcinventory(itemslot).objtype
            case eobjtype.otweapon
                label1(2).caption = "m�x golpe:" & npcinventory(itemslot).maxhit
                label1(3).caption = "m�n golpe:" & npcinventory(itemslot).minhit
                label1(2).visible = true
                label1(3).visible = true
            case eobjtype.otarmadura, eobjtype.otcasco, eobjtype.otescudo
                label1(2).caption = "m�x defensa:" & npcinventory(itemslot).maxdef
                label1(3).caption = "m�n defensa:" & npcinventory(itemslot).mindef
                label1(2).visible = true
                label1(3).visible = true
            case else
                label1(2).visible = false
                label1(3).visible = false
        end select
    else
        label1(2).visible = false
        label1(3).visible = false
    end if
end sub

private sub picinvnpc_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub


private sub picinvuser_click()
    dim itemslot as byte
    
    itemslot = invcomusu.selecteditem
    
    if itemslot = 0 then exit sub
    
    clicknpcinv = false
    invcomnpc.deselectitem
    
    label1(0).caption = inventario.itemname(itemslot)
    label1(1).caption = "precio: " & calculatebuyprice(inventario.valor(itemslot), val(cantidad.text)) 'no mostramos numeros reales
    
    if inventario.amount(itemslot) <> 0 then
    
        select case inventario.objtype(itemslot)
            case eobjtype.otweapon
                label1(2).caption = "m�x golpe:" & inventario.maxhit(itemslot)
                label1(3).caption = "m�n golpe:" & inventario.minhit(itemslot)
                label1(2).visible = true
                label1(3).visible = true
            case eobjtype.otarmadura, eobjtype.otcasco, eobjtype.otescudo
                label1(2).caption = "m�x defensa:" & inventario.maxdef(itemslot)
                label1(3).caption = "m�n defensa:" & inventario.mindef(itemslot)
                label1(2).visible = true
                label1(3).visible = true
            case else
                label1(2).visible = false
                label1(3).visible = false
        end select
    else
        label1(2).visible = false
        label1(3).visible = false
    end if
end sub

private sub picinvuser_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub
