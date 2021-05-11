version 5.00
begin vb.form frmparty 
   borderstyle     =   0  'none
   clientheight    =   6420
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   5640
   linktopic       =   "form1"
   scaleheight     =   428
   scalemode       =   3  'pixel
   scalewidth      =   376
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
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
      left            =   555
      maxlength       =   160
      multiline       =   -1  'true
      tabindex        =   2
      tabstop         =   0   'false
      tooltiptext     =   "chat"
      top             =   720
      width           =   4530
   end
   begin vb.textbox txttoadd 
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
      height          =   240
      left            =   1530
      maxlength       =   20
      tabindex        =   1
      top             =   4365
      width           =   2580
   end
   begin vb.listbox lstmembers 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
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
      height          =   1395
      left            =   1530
      tabindex        =   0
      top             =   1590
      width           =   2595
   end
   begin vb.label lbltotalexp 
      backstyle       =   0  'transparent
      caption         =   "000000"
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
      left            =   3075
      tabindex        =   3
      top             =   3150
      width           =   1335
   end
   begin vb.image imgcerrar 
      height          =   360
      left            =   3840
      tag             =   "1"
      top             =   5400
      width           =   1455
   end
   begin vb.image imglidergrupo 
      height          =   360
      left            =   2880
      tag             =   "1"
      top             =   3480
      width           =   1455
   end
   begin vb.image imgexpulsar 
      height          =   360
      left            =   1320
      tag             =   "1"
      top             =   3480
      width           =   1455
   end
   begin vb.image imgagregar 
      height          =   360
      left            =   2040
      tag             =   "1"
      top             =   4830
      width           =   1455
   end
   begin vb.image imgsalirparty 
      height          =   375
      left            =   300
      top             =   5400
      width           =   1455
   end
   begin vb.image imgdisolver 
      height          =   360
      left            =   300
      tag             =   "1"
      top             =   5400
      width           =   1455
   end
end
attribute vb_name = "frmparty"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmparty.frm
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

private cbotonagregar as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton
private cbotondisolver as clsgraphicalbutton
private cbotonlidergrupo as clsgraphicalbutton
private cbotonexpulsar as clsgraphicalbutton
private cbotonsalirparty as clsgraphicalbutton

public lastpressed as clsgraphicalbutton


private spartychat as string
private const leader_form_height as integer = 6015
private const normal_form_height as integer = 4455
private const offset_buttons as integer = 43 ' pixels


private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    lstmembers.clear
        
    if espartyleader then
        me.picture = loadpicture(app.path & "\graficos\ventanapartylider.jpg")
        me.height = leader_form_height
    else
        me.picture = loadpicture(app.path & "\graficos\ventanapartymiembro.jpg")
        me.height = normal_form_height
    end if
    
    call loadbuttons

    mirandoparty = true
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonagregar = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    set cbotondisolver = new clsgraphicalbutton
    set cbotonlidergrupo = new clsgraphicalbutton
    set cbotonexpulsar = new clsgraphicalbutton
    set cbotonsalirparty = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotonagregar.initialize(imgagregar, grhpath & "botonagregarparty.jpg", _
                                    grhpath & "botonagregarrolloverparty.jpg", _
                                    grhpath & "botonagregarclickparty.jpg", me)
                                    
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarparty.jpg", _
                                    grhpath & "botoncerrarrolloverparty.jpg", _
                                    grhpath & "botoncerrarclickparty.jpg", me)
                                    
    call cbotondisolver.initialize(imgdisolver, grhpath & "botondisolverparty.jpg", _
                                    grhpath & "botondisolverrolloverparty.jpg", _
                                    grhpath & "botondisolverclickparty.jpg", me)
                                    
    call cbotonlidergrupo.initialize(imglidergrupo, grhpath & "botonlidergrupoparty.jpg", _
                                    grhpath & "botonlidergruporolloverparty.jpg", _
                                    grhpath & "botonlidergrupoclickparty.jpg", me)
                                    
    call cbotonexpulsar.initialize(imgexpulsar, grhpath & "botonexpulsarparty.jpg", _
                                    grhpath & "botonexpulsarrolloverparty.jpg", _
                                    grhpath & "botonexpulsarclickparty.jpg", me)
                                    
    call cbotonsalirparty.initialize(imgsalirparty, grhpath & "botonsalirgrupoparty.jpg", _
                                    grhpath & "botonsalirgruporolloverparty.jpg", _
                                    grhpath & "botonsalirgrupoclickparty.jpg", me)
                                    
    ' botones visibles solo para el lider
    imgexpulsar.visible = espartyleader
    imglidergrupo.visible = espartyleader
    txttoadd.visible = espartyleader
    imgagregar.visible = espartyleader
    
    imgdisolver.visible = espartyleader
    imgsalirparty.visible = not espartyleader
    
    imgsalirparty.top = me.scaleheight - offset_buttons
    imgdisolver.top = me.scaleheight - offset_buttons
    imgcerrar.top = me.scaleheight - offset_buttons


end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub form_unload(cancel as integer)
    mirandoparty = false
end sub

private sub imgagregar_click()
    if len(txttoadd) > 0 then
        if not isnumeric(txttoadd) then
            call writepartyacceptmember(trim(txttoadd.text))
            unload me
            call writerequestpartyform
        end if
    end if
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgdisolver_click()
    call writepartyleave
    unload me
end sub

private sub imgexpulsar_click()
   
    if lstmembers.listindex < 0 then exit sub
    
    dim fname as string
    fname = getname
    
    if fname <> "" then
        call writepartykick(fname)
        unload me
        
        ' para que no llame al form si disolvi� la party
        if ucase$(fname) <> ucase$(username) then call writerequestpartyform
    end if

end sub

private function getname() as string
'**************************************************************
'author: zama
'last modify date: 27/12/2009
'**************************************************************
    dim sname as string
    
    sname = trim(mid(lstmembers.list(lstmembers.listindex), 1, instr(lstmembers.list(lstmembers.listindex), " (")))
    if len(sname) > 0 then getname = sname
        
end function

private sub imglidergrupo_click()
    
    if lstmembers.listindex < 0 then exit sub
    
    dim sname as string
    sname = getname
    
    if sname <> "" then
        call writepartysetleader(sname)
        unload me
        call writerequestpartyform
    end if
end sub

private sub imgsalirparty_click()
    call writepartyleave
    unload me
end sub

private sub lstmembers_mousedown(button as integer, shift as integer, x as single, y as single)

    if espartyleader then
        lastpressed.toggletonormal
    end if
    
end sub

private sub sendtxt_change()
'**************************************************************
'author: unknown
'last modify date: 03/10/2009
'**************************************************************
    if len(sendtxt.text) > 160 then
        spartychat = "soy un cheater, avisenle a un gm"
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
        
        spartychat = sendtxt.text
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
        if lenb(spartychat) <> 0 then call writepartymessage(spartychat)
        
        spartychat = ""
        sendtxt.text = ""
        keycode = 0
        sendtxt.setfocus
    end if
end sub

private sub txttoadd_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub txttoadd_keypress(keyascii as integer)
    if not (keyascii = vbkeyback) and _
       not (keyascii >= vbkeyspace and keyascii <= 250) then _
        keyascii = 0
end sub

private sub txttoadd_keyup(keycode as integer, shift as integer)
    if keycode = vbkeyreturn then imgagregar_click
end sub


