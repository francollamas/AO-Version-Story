version 5.00
begin vb.form frmadmin 
   backcolor       =   &h00ffc0c0&
   borderstyle     =   1  'fixed single
   caption         =   "administraci�n del servidor"
   clientheight    =   2865
   clientleft      =   45
   clienttop       =   435
   clientwidth     =   4680
   linktopic       =   "form1"
   maxbutton       =   0   'false
   scaleheight     =   2865
   scalewidth      =   4680
   startupposition =   2  'centerscreen
   begin vb.frame frame1 
      backcolor       =   &h00ffc0c0&
      caption         =   "personajes"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2535
      index           =   0
      left            =   240
      tabindex        =   0
      top             =   120
      width           =   4215
      begin vb.textbox text1 
         backcolor       =   &h00c0ffff&
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
         backcolor       =   &h00ffc0c0&
         caption         =   "echar todos los pjs no privilegiados"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   495
         left            =   480
         style           =   1  'graphical
         tabindex        =   4
         top             =   1920
         width           =   3135
      end
      begin vb.commandbutton command2 
         backcolor       =   &h00ffc0c0&
         caption         =   "r"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   315
         left            =   3720
         style           =   1  'graphical
         tabindex        =   3
         top             =   360
         width           =   255
      end
      begin vb.combobox cbopjs 
         backcolor       =   &h00c0ffff&
         height          =   315
         left            =   480
         tabindex        =   2
         top             =   360
         width           =   3135
      end
      begin vb.commandbutton command1 
         backcolor       =   &h00ffc0c0&
         caption         =   "echar"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   375
         left            =   480
         style           =   1  'graphical
         tabindex        =   1
         top             =   1440
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
        call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> " & userlist(tindex).name & " ha sido echado.", fonttypenames.fonttype_server))
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
