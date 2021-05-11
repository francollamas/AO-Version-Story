version 5.00
begin vb.form frmcomerciarusu 
   borderstyle     =   3  'fixed dialog
   clientheight    =   6225
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   6015
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   415
   scalemode       =   3  'pixel
   scalewidth      =   401
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.commandbutton command2 
      caption         =   "cerrar"
      height          =   375
      left            =   4680
      tabindex        =   12
      top             =   60
      width           =   1275
   end
   begin vb.frame frame2 
      caption         =   "ofrecer"
      height          =   5475
      left            =   3060
      tabindex        =   6
      top             =   600
      width           =   2895
      begin vb.optionbutton optque 
         caption         =   "oro"
         height          =   195
         index           =   1
         left            =   1440
         tabindex        =   14
         top             =   240
         width           =   915
      end
      begin vb.optionbutton optque 
         caption         =   "objeto"
         height          =   195
         index           =   0
         left            =   180
         tabindex        =   13
         top             =   240
         value           =   -1  'true
         width           =   915
      end
      begin vb.textbox txtcant 
         height          =   285
         left            =   1440
         tabindex        =   9
         text            =   "1"
         top             =   4560
         width           =   1215
      end
      begin vb.commandbutton cmdofrecer 
         caption         =   "ofrecer"
         height          =   375
         left            =   180
         tabindex        =   8
         top             =   4980
         width           =   2490
      end
      begin vb.listbox list1 
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   400
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   3960
         left            =   180
         tabindex        =   7
         top             =   480
         width           =   2490
      end
      begin vb.label label1 
         alignment       =   1  'right justify
         backstyle       =   0  'transparent
         caption         =   "cantidad:"
         height          =   255
         left            =   240
         tabindex        =   10
         top             =   4560
         width           =   1155
      end
   end
   begin vb.frame frame1 
      caption         =   "respuesta"
      height          =   5475
      left            =   60
      tabindex        =   1
      top             =   600
      width           =   2895
      begin vb.commandbutton cmdrechazar 
         caption         =   "rechazar"
         enabled         =   0   'false
         height          =   375
         left            =   1440
         tabindex        =   11
         top             =   4980
         width           =   1230
      end
      begin vb.commandbutton cmdaceptar 
         caption         =   "aceptar"
         enabled         =   0   'false
         height          =   375
         left            =   180
         tabindex        =   4
         top             =   4980
         width           =   1230
      end
      begin vb.listbox list2 
         height          =   3960
         left            =   180
         tabindex        =   2
         top             =   480
         width           =   2490
      end
      begin vb.label label3 
         caption         =   "cantidad: 0"
         height          =   255
         left            =   180
         tabindex        =   3
         top             =   4620
         width           =   2535
      end
   end
   begin vb.picturebox picture1 
      backcolor       =   &h00000000&
      height          =   540
      left            =   120
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   0
      top             =   60
      width           =   540
   end
   begin vb.label lblestadoresp 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "esperando respuesta..."
      forecolor       =   &h00ff0000&
      height          =   255
      left            =   1762
      tabindex        =   5
      top             =   180
      visible         =   0   'false
      width           =   2490
   end
end
attribute vb_name = "frmcomerciarusu"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'
'
'[alejo]

private sub cmdaceptar_click()
call senddata("comusuok")
end sub

private sub cmdofrecer_click()

if optque(0).value = true then
    if list1.listindex < 0 then exit sub
    if list1.itemdata(list1.listindex) <= 0 then exit sub
    
'    if val(txtcant.text) > list1.itemdata(list1.listindex) or _
'        val(txtcant.text) <= 0 then exit sub
elseif optque(1).value = true then
'    if val(txtcant.text) > usergld then
'        exit sub
'    end if
end if

if optque(0).value = true then
    call senddata("ofrecer" & list1.listindex + 1 & "," & trim(val(txtcant.text)))
elseif optque(1).value = true then
    call senddata("ofrecer" & flagoro & "," & trim(val(txtcant.text)))
else
    exit sub
end if

lblestadoresp.visible = true

end sub

private sub cmdrechazar_click()
call senddata("comusuno")
end sub

private sub command2_click()
call senddata("fincomusu")

end sub

private sub form_deactivate()
me.setfocus
picture1.setfocus

end sub

private sub form_load()
'carga las imagenes...?
lblestadoresp.visible = false


end sub

private sub form_lostfocus()
me.setfocus
picture1.setfocus

end sub

private sub list1_click()
dibujagrh userinventory(list1.listindex + 1).grhindex

end sub

public sub dibujagrh(grh as integer)
dim sr as rect, dr as rect

sr.left = 0
sr.top = 0
sr.right = 32
sr.bottom = 32

dr.left = 0
dr.top = 0
dr.right = 32
dr.bottom = 32

call drawgrhtohdc(picture1.hwnd, picture1.hdc, grh, sr, dr)

end sub

private sub list2_click()
if list2.listindex >= 0 then
    dibujagrh otroinventario(list2.listindex + 1).grhindex
    label3.caption = "cantidad: " & list2.itemdata(list2.listindex)
    cmdaceptar.enabled = true
    cmdrechazar.enabled = true
else
    cmdaceptar.enabled = false
    cmdrechazar.enabled = false
end if

end sub

private sub optque_click(index as integer)
select case index
case 0
    list1.enabled = true
case 1
    list1.enabled = false
end select

end sub

private sub txtcant_keydown(keycode as integer, shift as integer)
if not ((keycode >= 48 and keycode <= 57) or keycode = vbkeyback or _
        keycode = vbkeydelete or (keycode >= 37 and keycode <= 40)) then
    'txtcant = keycode
    keycode = 0
end if

end sub

private sub txtcant_keypress(keyascii as integer)
if not ((keyascii >= 48 and keyascii <= 57) or keyascii = vbkeyback or _
        keyascii = vbkeydelete or (keyascii >= 37 and keyascii <= 40)) then
    'txtcant = keycode
    keyascii = 0
end if

end sub

'[/alejo]

