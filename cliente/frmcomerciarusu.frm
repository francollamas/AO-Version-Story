version 5.00
object = "{3b7c8863-d78f-101b-b9b5-04021c009402}#1.2#0"; "richtx32.ocx"
begin vb.form frmcomerciarusu 
   borderstyle     =   0  'none
   clientheight    =   8850
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   9975
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   590
   scalemode       =   3  'pixel
   scalewidth      =   665
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.picturebox picinvoroprop 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      height          =   480
      left            =   3450
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   64
      tabindex        =   7
      top             =   930
      width           =   960
   end
   begin vb.textbox txtagregar 
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
      height          =   270
      left            =   4500
      tabindex        =   6
      top             =   2295
      width           =   1035
   end
   begin vb.picturebox picinvoroofertaotro 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      height          =   480
      left            =   5610
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   64
      tabindex        =   5
      top             =   5040
      width           =   960
   end
   begin vb.picturebox picinvofertaotro 
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
      height          =   2880
      left            =   6975
      scaleheight     =   192
      scalemode       =   3  'pixel
      scalewidth      =   160
      tabindex        =   4
      top             =   5040
      width           =   2400
   end
   begin vb.picturebox picinvofertaprop 
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
      height          =   2880
      left            =   6960
      scaleheight     =   192
      scalemode       =   3  'pixel
      scalewidth      =   160
      tabindex        =   3
      top             =   930
      width           =   2400
   end
   begin vb.textbox sendtxt 
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
      height          =   255
      left            =   495
      maxlength       =   160
      multiline       =   -1  'true
      tabindex        =   2
      tabstop         =   0   'false
      tooltiptext     =   "chat"
      top             =   7965
      width           =   6060
   end
   begin vb.picturebox picinvcomercio 
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
      height          =   2880
      left            =   630
      scaleheight     =   192
      scalemode       =   3  'pixel
      scalewidth      =   160
      tabindex        =   1
      top             =   945
      width           =   2400
   end
   begin vb.picturebox picinvoroofertaprop 
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      height          =   480
      left            =   5610
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   64
      tabindex        =   0
      top             =   930
      width           =   960
   end
   begin richtextlib.richtextbox commerceconsole 
      height          =   1620
      left            =   495
      tabindex        =   8
      tabstop         =   0   'false
      tooltiptext     =   "mensajes del servidor"
      top             =   6030
      width           =   6075
      _extentx        =   10716
      _extenty        =   2858
      _version        =   393217
      backcolor       =   0
      readonly        =   -1  'true
      scrollbars      =   2
      disablenoscroll =   -1  'true
      textrtf         =   $"frmcomerciarusu.frx":0000
      beginproperty font {0be35203-8f91-11ce-9de3-00aa004bb851} 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
   end
   begin vb.image imgcancelar 
      height          =   360
      left            =   480
      tag             =   "1"
      top             =   4680
      width           =   1455
   end
   begin vb.image imgrechazar 
      height          =   360
      left            =   8220
      tag             =   "2"
      top             =   8160
      width           =   1455
   end
   begin vb.image imgconfirmar 
      height          =   360
      left            =   7440
      tag             =   "2"
      top             =   4080
      width           =   1455
   end
   begin vb.image imgaceptar 
      height          =   360
      left            =   6750
      tag             =   "2"
      top             =   8160
      width           =   1455
   end
   begin vb.image imgagregar 
      height          =   255
      left            =   4920
      top             =   1920
      width           =   255
   end
   begin vb.image imgquitar 
      height          =   255
      left            =   4920
      top             =   2760
      width           =   255
   end
end
attribute vb_name = "frmcomerciarusu"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmcomerciarusu.frm
'
'**************************************************************

'**************************************************************************
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
'**************************************************************************

option explicit

private clsformulario as clsformmovementmanager

private cbotonaceptar as clsgraphicalbutton
private cbotoncancelar as clsgraphicalbutton
private cbotonrechazar as clsgraphicalbutton
private cbotonconfirmar as clsgraphicalbutton
public lastbuttonpressed as clsgraphicalbutton

private const gold_offer_slot as byte = inv_offer_slots + 1

private scommercechat as string

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgaceptar_click()
    if not cbotonaceptar.isenabled then exit sub  ' deshabilitado
    
    call writeusercommerceok
    habilitaraceptarrechazar false
    
end sub

private sub imgagregar_click()
   
    ' no tiene seleccionado ningun item
    if invcomusu.selecteditem = 0 then
        call printcommercemsg("�no tienes ning�n item seleccionado!", fonttypenames.fonttype_fight)
        exit sub
    end if
    
    ' numero invalido
    if not isnumeric(txtagregar.text) then exit sub
    
    habilitarconfirmar true
    
    dim offerslot as byte
    dim amount as long
    dim invslot as byte
        
    with invcomusu
        if .selecteditem = flagoro then
            if val(txtagregar.text) > invorocomusu(0).amount(1) then
                call printcommercemsg("�no tienes esa cantidad!", fonttypenames.fonttype_fight)
                exit sub
            end if
            
            amount = invorocomusu(1).amount(1) + val(txtagregar.text)
    
            ' le aviso al otro de mi cambio de oferta
            call writeusercommerceoffer(flagoro, val(txtagregar.text), gold_offer_slot)
            
            ' actualizo los inventarios
            call invorocomusu(0).changeslotitemamount(1, invorocomusu(0).amount(1) - val(txtagregar.text))
            call invorocomusu(1).changeslotitemamount(1, amount)
            
            call printcommercemsg("�agregaste " & val(txtagregar.text) & " moneda" & iif(val(txtagregar.text) = 1, "", "s") & " de oro a tu oferta!!", fonttypenames.fonttype_guild)
            
        elseif .selecteditem > 0 then
             if val(txtagregar.text) > .amount(.selecteditem) then
                call printcommercemsg("�no tienes esa cantidad!", fonttypenames.fonttype_fight)
                exit sub
            end if
             
            offerslot = checkavailableslot(.selecteditem, val(txtagregar.text))
            
            ' hay espacio o lugar donde sumarlo?
            if offerslot > 0 then
            
                call printcommercemsg("�agregaste " & val(txtagregar.text) & " " & .itemname(.selecteditem) & " a tu oferta!!", fonttypenames.fonttype_guild)
                
                ' le aviso al otro de mi cambio de oferta
                call writeusercommerceoffer(.selecteditem, val(txtagregar.text), offerslot)
                
                ' actualizo el inventario general de comercio
                call .changeslotitemamount(.selecteditem, .amount(.selecteditem) - val(txtagregar.text))
                
                amount = invoffercomusu(0).amount(offerslot) + val(txtagregar.text)
                
                ' actualizo los inventarios
                if invoffercomusu(0).objindex(offerslot) > 0 then
                    ' si ya esta el item, solo actualizo su cantidad en el invenatario
                    call invoffercomusu(0).changeslotitemamount(offerslot, amount)
                else
                    invslot = .selecteditem
                    ' si no agrego todo
                    call invoffercomusu(0).setitem(offerslot, .objindex(invslot), _
                                                    amount, 0, .grhindex(invslot), .objtype(invslot), _
                                                    .maxhit(invslot), .minhit(invslot), .maxdef(invslot), .mindef(invslot), _
                                                    .valor(invslot), .itemname(invslot))
                end if
            end if
        end if
    end with
end sub

private sub imgcancelar_click()
    call writeusercommerceend
end sub

private sub imgconfirmar_click()
    if not cbotonconfirmar.isenabled then exit sub  ' deshabilitado
    
    habilitarconfirmar false
    imgagregar.visible = false
    imgquitar.visible = false
    txtagregar.enabled = false
    
    call printcommercemsg("�has confirmado tu oferta! ya no puedes cambiarla.", fonttypenames.fonttype_conse)
    call writeusercommerceconfirm
end sub

private sub imgquitar_click()
    dim amount as long
    dim invcomslot as byte

    ' no tiene seleccionado ningun item
    if invoffercomusu(0).selecteditem = 0 then
        call printcommercemsg("�no tienes ning�n �tem seleccionado!", fonttypenames.fonttype_fight)
        exit sub
    end if
    
    ' numero invalido
    if not isnumeric(txtagregar.text) then exit sub

    ' comparar con el inventario para distribuir los items
    if invoffercomusu(0).selecteditem = flagoro then
        amount = iif(val(txtagregar.text) > invorocomusu(1).amount(1), invorocomusu(1).amount(1), val(txtagregar.text))
        ' estoy quitando, paso un valor negativo
        amount = amount * (-1)
        
        ' no tiene sentido que se quiten 0 unidades
        if amount <> 0 then
            ' le aviso al otro de mi cambio de oferta
            call writeusercommerceoffer(flagoro, amount, gold_offer_slot)
            
            ' actualizo los inventarios
            call invorocomusu(0).changeslotitemamount(1, invorocomusu(0).amount(1) - amount)
            call invorocomusu(1).changeslotitemamount(1, invorocomusu(1).amount(1) + amount)
        
            call printcommercemsg("��quitaste " & amount * (-1) & " moneda" & iif(val(txtagregar.text) = 1, "", "s") & " de oro de tu oferta!!", fonttypenames.fonttype_guild)
        end if
    else
        amount = iif(val(txtagregar.text) > invoffercomusu(0).amount(invoffercomusu(0).selecteditem), _
                    invoffercomusu(0).amount(invoffercomusu(0).selecteditem), val(txtagregar.text))
        ' estoy quitando, paso un valor negativo
        amount = amount * (-1)
        
        ' no tiene sentido que se quiten 0 unidades
        if amount <> 0 then
            with invoffercomusu(0)
                
                call printcommercemsg("��quitaste " & amount * (-1) & " " & .itemname(.selecteditem) & " de tu oferta!!", fonttypenames.fonttype_guild)
    
                ' le aviso al otro de mi cambio de oferta
                call writeusercommerceoffer(0, amount, .selecteditem)
            
                ' actualizo el inventario general
                call updateinvcom(.objindex(.selecteditem), abs(amount))
                 
                 ' actualizo el inventario de oferta
                 if .amount(.selecteditem) + amount = 0 then
                     ' borro el item
                     call .setitem(.selecteditem, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "")
                 else
                     ' le resto la cantidad deseada
                     call .changeslotitemamount(.selecteditem, .amount(.selecteditem) + amount)
                 end if
            end with
        end if
    end if
    
    ' si quito todos los items de la oferta, no puede confirmarla
    if not hasanyitem(invoffercomusu(0)) and _
       not hasanyitem(invorocomusu(1)) then habilitarconfirmar (false)
end sub

private sub imgrechazar_click()
    if not cbotonrechazar.isenabled then exit sub  ' deshabilitado
    
    call writeusercommercereject
end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me

    me.picture = loadpicture(dirgraficos & "ventanacomerciousuario.jpg")
    
    loadbuttons
    
    call printcommercemsg("> una vez termines de formar tu oferta, debes presionar en ""confirmar"", tras lo cual ya no podr�s modificarla.", fonttypenames.fonttype_guildmsg)
    call printcommercemsg("> luego que el otro usuario confirme su oferta, podr�s aceptarla o rechazarla. si la rechazas, se terminar� el comercio.", fonttypenames.fonttype_guildmsg)
    call printcommercemsg("> cuando ambos acepten la oferta del otro, se realizar� el intercambio.", fonttypenames.fonttype_guildmsg)
    call printcommercemsg("> si se intercambian m�s �tems de los que pueden entrar en tu inventario, es probable que caigan al suelo, as� que presta mucha atenci�n a esto.", fonttypenames.fonttype_guildmsg)
    
end sub

private sub loadbuttons()

    dim grhpath as string
    grhpath = dirgraficos
    
    set cbotonaceptar = new clsgraphicalbutton
    set cbotonconfirmar = new clsgraphicalbutton
    set cbotonrechazar = new clsgraphicalbutton
    set cbotoncancelar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    call cbotonaceptar.initialize(imgaceptar, grhpath & "botonaceptarcomusu.jpg", _
                                        grhpath & "botonaceptarrollovercomusu.jpg", _
                                        grhpath & "botonaceptarclickcomusu.jpg", me, _
                                        grhpath & "botonaceptargriscomusu.jpg", true)
                                    
    call cbotonconfirmar.initialize(imgconfirmar, grhpath & "botonconfirmarcomusu.jpg", _
                                        grhpath & "botonconfirmarrollovercomusu.jpg", _
                                        grhpath & "botonconfirmarclickcomusu.jpg", me, _
                                        grhpath & "botonconfirmargriscomusu.jpg", true)
                                        
    call cbotonrechazar.initialize(imgrechazar, grhpath & "botonrechazarcomusu.jpg", _
                                        grhpath & "botonrechazarrollovercomusu.jpg", _
                                        grhpath & "botonrechazarclickcomusu.jpg", me, _
                                        grhpath & "botonrechazargriscomusu.jpg", true)
                                        
    call cbotoncancelar.initialize(imgcancelar, grhpath & "botoncancelarcomusu.jpg", _
                                        grhpath & "botoncancelarrollovercomusu.jpg", _
                                        grhpath & "botoncancelarclickcomusu.jpg", me)
    
end sub

private sub form_lostfocus()
    me.setfocus
end sub

private sub subtxtagregar_change()
    if val(txtagregar.text) < 1 then txtagregar.text = "1"

    if val(txtagregar.text) > 2147483647 then txtagregar.text = "2147483647"
end sub

private sub picinvcomercio_click()
    call invorocomusu(0).deselectitem
end sub

private sub picinvcomercio_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub picinvofertaotro_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub picinvofertaprop_click()
    invorocomusu(1).deselectitem
end sub

private sub picinvofertaprop_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub picinvoroofertaotro_click()
    ' no se puede seleccionar el oro que oferta el otro :p
    invorocomusu(2).deselectitem
end sub

private sub picinvoroofertaprop_click()
    invoffercomusu(0).selectgold
end sub

private sub picinvoroprop_click()
    invcomusu.selectgold
end sub

private sub sendtxt_change()
'**************************************************************
'author: unknown
'last modify date: 03/10/2009
'**************************************************************
    if len(sendtxt.text) > 160 then
        scommercechat = "soy un cheater, avisenle a un gm"
    else
        'make sure only valid chars are inserted (with shift + insert they can paste illegal chars)
        dim i as long
        dim tempstr as string
        dim charascii as integer
        
        for i = 1 to len(sendtxt.text)
            charascii = asc(mid$(sendtxt.text, i, 1))
            if charascii >= vbkeyspace and charascii <= 250 then
                tempstr = tempstr & chr$(charascii)
            end if
        next i
        
        if tempstr <> sendtxt.text then
            'we only set it if it's different, otherwise the event will be raised
            'constantly and the client will crush
            sendtxt.text = tempstr
        end if
        
        scommercechat = sendtxt.text
    end if
end sub

private sub sendtxt_keypress(keyascii as integer)
    if not (keyascii = vbkeyback) and _
       not (keyascii >= vbkeyspace and keyascii <= 250) then _
        keyascii = 0
end sub

private sub sendtxt_keyup(keycode as integer, shift as integer)
    'send text
    if keycode = vbkeyreturn then
        if lenb(scommercechat) <> 0 then call writecommercechat(scommercechat)
        
        scommercechat = ""
        sendtxt.text = ""
        keycode = 0
    end if
end sub

private sub txtagregar_change()
'**************************************************************
'author: unknown
'last modify date: 03/10/2009
'**************************************************************
    'make sure only valid chars are inserted (with shift + insert they can paste illegal chars)
    dim i as long
    dim tempstr as string
    dim charascii as integer
    
    for i = 1 to len(txtagregar.text)
        charascii = asc(mid$(txtagregar.text, i, 1))
        
        if charascii >= 48 and charascii <= 57 then
            tempstr = tempstr & chr$(charascii)
        end if
    next i
    
    if tempstr <> txtagregar.text then
        'we only set it if it's different, otherwise the event will be raised
        'constantly and the client will crush
        txtagregar.text = tempstr
    end if
end sub

private sub txtagregar_keydown(keycode as integer, shift as integer)
if not ((keycode >= 48 and keycode <= 57) or keycode = vbkeyback or _
        keycode = vbkeydelete or (keycode >= 37 and keycode <= 40)) then
    keycode = 0
end if

end sub

private sub txtagregar_keypress(keyascii as integer)
if not ((keyascii >= 48 and keyascii <= 57) or keyascii = vbkeyback or _
        keyascii = vbkeydelete or (keyascii >= 37 and keyascii <= 40)) then
    'txtcant = keycode
    keyascii = 0
end if

end sub

private function checkavailableslot(byval invslot as byte, byval amount as long) as byte
'***************************************************
'author: zama
'last modify date: 30/11/2009
'search for an available slot to put an item. if found returns the slot, else returns 0.
'***************************************************
    dim slot as long
on error goto err
    ' primero chequeo si puedo sumar esa cantidad en algun slot que ya tenga ese item
    for slot = 1 to inv_offer_slots
        if invcomusu.objindex(invslot) = invoffercomusu(0).objindex(slot) then
            if invoffercomusu(0).amount(slot) + amount <= max_inventory_objs then
                ' puedo sumarlo aca
                checkavailableslot = slot
                exit function
            end if
        end if
    next slot
    
    ' no lo puedo sumar, me fijo si hay alguno vacio
    for slot = 1 to inv_offer_slots
        if invoffercomusu(0).objindex(slot) = 0 then
            ' esta vacio, lo dejo aca
            checkavailableslot = slot
            exit function
        end if
    next slot
    exit function
err:
    debug.print "slot: " & slot
end function

public sub updateinvcom(byval objindex as integer, byval amount as long)
    dim slot as byte
    dim remainingamount as long
    dim difamount as long
    
    remainingamount = amount
    
    for slot = 1 to max_inventory_slots
        
        if invcomusu.objindex(slot) = objindex then
            difamount = inventario.amount(slot) - invcomusu.amount(slot)
            if difamount > 0 then
                if remainingamount > difamount then
                    remainingamount = remainingamount - difamount
                    call invcomusu.changeslotitemamount(slot, inventario.amount(slot))
                else
                    call invcomusu.changeslotitemamount(slot, invcomusu.amount(slot) + remainingamount)
                    exit sub
                end if
            end if
        end if
    next slot
end sub

public sub printcommercemsg(byref msg as string, byval fontindex as integer)
    
    with fonttypes(fontindex)
        call addtorichtextbox(frmcomerciarusu.commerceconsole, msg, .red, .green, .blue, .bold, .italic)
    end with
    
end sub

public function hasanyitem(byref inventory as clsgrapchicalinventory) as boolean

    dim slot as long
    
    for slot = 1 to inventory.maxobjs
        if inventory.amount(slot) > 0 then hasanyitem = true: exit function
    next slot
    
end function

public sub habilitarconfirmar(byval habilitar as boolean)
    call cbotonconfirmar.enablebutton(habilitar)
end sub

public sub habilitaraceptarrechazar(byval habilitar as boolean)
    call cbotonaceptar.enablebutton(habilitar)
    call cbotonrechazar.enablebutton(habilitar)
end sub
