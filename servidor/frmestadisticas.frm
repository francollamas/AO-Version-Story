version 5.00
begin vb.form frmestadisticas 
   borderstyle     =   1  'fixed single
   caption         =   "stats"
   clientheight    =   3735
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   5415
   linktopic       =   "form1"
   maxbutton       =   0   'false
   scaleheight     =   3735
   scalewidth      =   5415
   startupposition =   3  'windows default
   begin vb.frame frame2 
      caption         =   "colas"
      height          =   1095
      left            =   120
      tabindex        =   9
      top             =   2520
      width           =   5175
      begin vb.commandbutton command2 
         caption         =   "adm"
         height          =   315
         left            =   2640
         tabindex        =   13
         top             =   600
         width           =   495
      end
      begin vb.combobox cboususcolas 
         height          =   315
         left            =   120
         tabindex        =   12
         top             =   600
         width           =   2415
      end
      begin vb.commandbutton command1 
         caption         =   "r"
         height          =   375
         left            =   4560
         tabindex        =   10
         top             =   360
         width           =   495
      end
      begin vb.label lblcolas 
         height          =   255
         left            =   120
         tabindex        =   11
         top             =   240
         width           =   4335
      end
   end
   begin vb.frame frame1 
      height          =   2295
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   5175
      begin vb.label lblstat 
         height          =   495
         index           =   3
         left            =   2400
         tabindex        =   8
         top             =   1560
         width           =   2535
      end
      begin vb.label lblstat 
         height          =   495
         index           =   2
         left            =   2400
         tabindex        =   7
         top             =   960
         width           =   2535
      end
      begin vb.label lblstat 
         height          =   255
         index           =   1
         left            =   2400
         tabindex        =   6
         top             =   600
         width           =   2535
      end
      begin vb.label lblstat 
         height          =   255
         index           =   0
         left            =   2400
         tabindex        =   5
         top             =   240
         width           =   2535
      end
      begin vb.label label1 
         alignment       =   1  'right justify
         caption         =   "max bytes enviados x seg:"
         height          =   255
         index           =   3
         left            =   240
         tabindex        =   4
         top             =   1560
         width           =   2055
      end
      begin vb.label label1 
         alignment       =   1  'right justify
         caption         =   "max bytes recibidos x seg:"
         height          =   255
         index           =   2
         left            =   240
         tabindex        =   3
         top             =   960
         width           =   2055
      end
      begin vb.label label1 
         alignment       =   1  'right justify
         caption         =   "bytes enviados x seg:"
         height          =   255
         index           =   1
         left            =   240
         tabindex        =   2
         top             =   600
         width           =   2055
      end
      begin vb.label label1 
         alignment       =   1  'right justify
         caption         =   "bytes recibidos x seg:"
         height          =   255
         index           =   0
         left            =   240
         tabindex        =   1
         top             =   240
         width           =   2055
      end
   end
end
attribute vb_name = "frmestadisticas"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private sub command1_click()
dim loopc as integer, n as long, m as long

n = 0 'numero de pjs
m = 0 'numero total de elementos en cola
if cboususcolas.listcount > 0 then _
    cboususcolas.clear

for loopc = 1 to lastuser
    if userlist(loopc).flags.userlogged and userlist(loopc).connid >= 0 and userlist(loopc).connidvalida then
        if userlist(loopc).colasalida.count > 0 then
            n = n + 1
            m = m + userlist(loopc).colasalida.count
            cboususcolas.additem userlist(loopc).name
        end if
    end if
next loopc

lblcolas.caption = n & " pjs, " & m & " elementos en las colas."

if cboususcolas.listcount > 0 then _
    cboususcolas.listindex = 0
    
end sub

private sub command2_click()
frmadmin.show
frmadmin.cbopjs.text = cboususcolas.text

end sub

private sub form_activate()
call actualizastats

end sub

public sub actualizastats()
lblstat(0).caption = tcpesstats.bytesrecibidosxseg
lblstat(1).caption = tcpesstats.bytesenviadosxseg
lblstat(2).caption = tcpesstats.bytesrecibidosxsegmax & vbcrlf & tcpesstats.bytesrecibidosxsegcuando
lblstat(3).caption = tcpesstats.bytesenviadosxsegmax & vbcrlf & tcpesstats.bytesenviadosxsegcuando

end sub

private sub form_click()
call actualizastats

end sub

private sub frame1_click()
call actualizastats

end sub

private sub lblstat_click(index as integer)
call actualizastats

end sub
