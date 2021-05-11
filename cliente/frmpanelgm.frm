version 5.00
begin vb.form frmpanelgm 
   borderstyle     =   1  'fixed single
   caption         =   "panel gm"
   clientheight    =   3735
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4635
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3735
   scalewidth      =   4635
   startupposition =   1  'centerowner
   begin vb.commandbutton cmdaccion 
      caption         =   "ver oro en banco"
      height          =   315
      index           =   19
      left            =   120
      tabindex        =   22
      top             =   2640
      width           =   1575
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "show sos"
      height          =   315
      index           =   18
      left            =   3420
      tabindex        =   21
      top             =   2280
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "boveda"
      height          =   315
      index           =   17
      left            =   2340
      tabindex        =   20
      top             =   2280
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "ban x ip"
      height          =   315
      index           =   16
      left            =   1260
      tabindex        =   19
      top             =   2280
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "penas"
      height          =   315
      index           =   15
      left            =   180
      tabindex        =   18
      top             =   2280
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "ip 2 nick"
      height          =   315
      index           =   14
      left            =   1260
      tabindex        =   17
      top             =   1440
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "nick 2 ip"
      height          =   315
      index           =   13
      left            =   180
      tabindex        =   16
      top             =   1440
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "unban"
      height          =   315
      index           =   12
      left            =   3420
      tabindex        =   15
      top             =   1860
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "carcel"
      height          =   315
      index           =   11
      left            =   3420
      tabindex        =   14
      top             =   1440
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "skills"
      height          =   315
      index           =   10
      left            =   1260
      tabindex        =   13
      top             =   1860
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "inv"
      height          =   315
      index           =   9
      left            =   180
      tabindex        =   12
      top             =   1860
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "info"
      height          =   315
      index           =   8
      left            =   3420
      tabindex        =   11
      top             =   1020
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "n.ene."
      height          =   315
      index           =   7
      left            =   180
      tabindex        =   10
      top             =   1020
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "donde"
      height          =   315
      index           =   6
      left            =   3420
      tabindex        =   9
      top             =   600
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "hora"
      height          =   315
      index           =   5
      left            =   2340
      tabindex        =   8
      top             =   600
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "guardar comentario"
      height          =   315
      index           =   4
      left            =   180
      tabindex        =   7
      top             =   600
      width           =   2055
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "ira"
      height          =   315
      index           =   3
      left            =   1260
      tabindex        =   6
      top             =   1020
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "sum"
      height          =   315
      index           =   2
      left            =   2340
      tabindex        =   5
      top             =   1020
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "ban"
      height          =   315
      index           =   1
      left            =   2340
      tabindex        =   4
      top             =   1860
      width           =   975
   end
   begin vb.commandbutton cmdaccion 
      caption         =   "echar"
      height          =   315
      index           =   0
      left            =   2340
      tabindex        =   3
      top             =   1440
      width           =   975
   end
   begin vb.commandbutton cmdactualiza 
      caption         =   "actualiza"
      height          =   315
      left            =   3600
      tabindex        =   2
      top             =   120
      width           =   915
   end
   begin vb.commandbutton cmdcerrar 
      caption         =   "cerrar"
      height          =   375
      left            =   240
      tabindex        =   1
      top             =   3120
      width           =   4035
   end
   begin vb.combobox cbolistausus 
      height          =   315
      left            =   120
      sorted          =   -1  'true
      tabindex        =   0
      top             =   120
      width           =   3435
   end
   begin vb.line line1 
      index           =   5
      x1              =   120
      x2              =   120
      y1              =   540
      y2              =   1380
   end
   begin vb.line line1 
      index           =   4
      x1              =   4440
      x2              =   4440
      y1              =   540
      y2              =   960
   end
   begin vb.line line1 
      index           =   3
      x1              =   2280
      x2              =   2280
      y1              =   960
      y2              =   1380
   end
   begin vb.line line1 
      index           =   2
      x1              =   2280
      x2              =   4440
      y1              =   960
      y2              =   960
   end
   begin vb.line line1 
      index           =   1
      x1              =   120
      x2              =   4440
      y1              =   540
      y2              =   540
   end
   begin vb.line line1 
      index           =   0
      x1              =   120
      x2              =   2280
      y1              =   1380
      y2              =   1380
   end
end
attribute vb_name = "frmpanelgm"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private sub cmdaccion_click(index as integer)
dim ok as boolean, tmp as string, tmp2 as string
dim nick as string

nick = cbolistausus.text

select case index
case 0 '/echar nick
    call senddata("/echar " & nick)
case 1 '/ban motivo@nick
    tmp = inputbox("motivo ?", "")
    if msgbox("esta seguro que desea banear al personaje """ & nick & """ ?", vbyesno) = vbyes then
        call senddata("/ban " & tmp & "@" & nick)
    end if
case 2 '/sum nick
    call senddata("/sum " & nick)
case 3 '/ira nick
    call senddata("/ira " & nick)
case 4 '/rem
    tmp = inputbox("comentario ?", "")
    call senddata("/rem " & tmp)
case 5 '/hora
    call senddata("/hora")
case 6 '/donde nick
    call senddata("/donde " & nick)
case 7 '/nene
    tmp = inputbox("mapa ?", "")
    call senddata("/nene " & trim(tmp))
case 8 '/info nick
    call senddata("/info " & nick)
case 9 '/inv nick
    call senddata("/inv " & cbolistausus.text)
case 10 '/skills nick
    call senddata("/skills " & nick)
case 11 '/carcel minutos nick
    tmp = inputbox("minutos ? (hasta 30)", "")
    tmp2 = inputbox("razon ?", "")
    if msgbox("esta seguro que desea encarcelar al personaje """ & nick & """ ?", vbyesno) = vbyes then
        call senddata("/carcel " & nick & "@" & tmp2 & "@" & tmp)
    end if
case 12 '/unban nick
    if msgbox("esta seguro que desea removerle el ban al personaje """ & nick & """ ?", vbyesno) = vbyes then
        call senddata("/unban " & nick)
    end if
case 13 '/nick2ip nick
    call senddata("/nick2ip " & nick)
case 14 '/ip2nick ip
    call senddata("/ip2nick " & nick)
case 15 '/penas
    call senddata("/penas " & cbolistausus.text)
case 16 'ban x ip
    tmp = inputbox("ingrese el motivo del ban", "ban x ip")
    if msgbox("esta seguro que desea banear el (ip o personaje) " & nick & "por ip?", vbyesno) = vbyes then
        nick = replace(nick, " ", "+")
        call senddata("/banip " & nick & tmp)
    end if
case 17 ' muesta bobeda
    call senddata("/bov " & nick)
case 18 ' sos
    call senddata("/show sos")
case 19 ' balance
    call senddata("/bal " & cbolistausus.text)
end select


end sub

private sub cmdactualiza_click()
call senddata("listusu")

end sub

private sub cmdcerrar_click()
unload me
end sub

private sub form_load()
    call cmdactualiza_click
end sub

private sub form_queryunload(cancel as integer, unloadmode as integer)
unload me
end sub
