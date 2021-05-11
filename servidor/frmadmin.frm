version 5.00
begin vb.form frmadmin 
   backcolor       =   &h00c0c0c0&
   caption         =   "administraci�n del servidor"
   clientheight    =   3135
   clientleft      =   60
   clienttop       =   450
   clientwidth     =   4680
   linktopic       =   "form1"
   scaleheight     =   3135
   scalewidth      =   4680
   startupposition =   3  'windows default
   begin vb.frame frame1 
      caption         =   "personajes"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2895
      index           =   0
      left            =   240
      tabindex        =   0
      top             =   120
      width           =   4215
      begin vb.textbox text1 
         enabled         =   0   'false
         height          =   495
         left            =   480
         multiline       =   -1  'true
         scrollbars      =   2  'vertical
         tabindex        =   5
         top             =   720
         width           =   3135
      end
      begin vb.commandbutton command3 
         caption         =   "echar todos los pjs no privilegiados"
         height          =   375
         left            =   480
         tabindex        =   4
         top             =   2280
         width           =   3135
      end
      begin vb.commandbutton command2 
         caption         =   "r"
         height          =   315
         left            =   3720
         tabindex        =   3
         top             =   360
         width           =   255
      end
      begin vb.combobox cbopjs 
         height          =   315
         left            =   480
         tabindex        =   2
         top             =   360
         width           =   3135
      end
      begin vb.commandbutton command1 
         caption         =   "echar"
         height          =   375
         left            =   480
         tabindex        =   1
         top             =   1800
         width           =   3135
      end
   end
end
attribute vb_name = "frmadmin"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmadmin.frm
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

private sub cbopjs_change()
call actualizapjinfo
end sub

private sub cbopjs_click()
call actualizapjinfo
end sub

private sub command1_click()
dim tindex as long

tindex = nameindex(cbopjs.text)
if tindex > 0 then
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> " & userlist(tindex).name & " ha sido hechado. ", fonttypenames.fonttype_server))
    call closesocket(tindex)
end if

end sub

public sub actualizalistapjs()
dim loopc as long

with cbopjs
    .clear
    
    for loopc = 1 to lastuser
        if userlist(loopc).flags.userlogged and userlist(loopc).connid >= 0 and userlist(loopc).connidvalida then
            if userlist(loopc).flags.privilegios and playertype.user then
                .additem userlist(loopc).name
                .itemdata(.newindex) = loopc
            end if
        end if
    next loopc
end with

end sub

private sub command3_click()
call echarpjsnoprivilegiados

end sub

private sub actualizapjinfo()
dim tindex as long

tindex = nameindex(cbopjs.text)
if tindex > 0 then
    with userlist(tindex)
        text1.text = .outgoingdata.length & " elementos en cola." & vbcrlf
    end with
end if

end sub
