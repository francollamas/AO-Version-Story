version 5.00
object = "{831fdd16-0c5c-11d2-a9fc-0000f8754da1}#2.0#0"; "mscomctl.ocx"
begin vb.form frmpanelgm 
   borderstyle     =   1  'fixed single
   caption         =   "panel gm"
   clientheight    =   8475
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4200
   clipcontrols    =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   8475
   scalewidth      =   4200
   startupposition =   1  'centerowner
   begin vb.frame frame 
      borderstyle     =   0  'none
      height          =   7695
      index           =   3
      left            =   120
      tabindex        =   12
      top             =   360
      width           =   3975
      begin vb.commandbutton cmdconsulta 
         caption         =   "/consulta"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   87
         top             =   1320
         width           =   1095
      end
      begin vb.commandbutton cmdnoreal 
         caption         =   "/noreal"
         causesvalidation=   0   'false
         height          =   315
         left            =   2040
         tabindex        =   86
         top             =   6480
         width           =   1815
      end
      begin vb.commandbutton cmdnocaos 
         caption         =   "/nocaos"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   85
         top             =   6480
         width           =   1815
      end
      begin vb.commandbutton cmdkickconse 
         caption         =   "/kickconse"
         causesvalidation=   0   'false
         height          =   675
         left            =   2520
         tabindex        =   84
         top             =   6960
         width           =   1335
      end
      begin vb.commandbutton cmdaceptconsecaos 
         caption         =   "/aceptconsecaos"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   83
         top             =   7320
         width           =   2295
      end
      begin vb.commandbutton cmdaceptconse 
         caption         =   "/aceptconse"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   82
         top             =   6960
         width           =   2295
      end
      begin vb.combobox cbolistausus 
         height          =   315
         left            =   120
         sorted          =   -1  'true
         tabindex        =   54
         top             =   480
         width           =   3675
      end
      begin vb.commandbutton cmdactualiza 
         caption         =   "actualizar"
         causesvalidation=   0   'false
         height          =   255
         left            =   120
         tabindex        =   53
         top             =   120
         width           =   3675
      end
      begin vb.commandbutton cmdircerca 
         caption         =   "/ircerca"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   52
         top             =   960
         width           =   1095
      end
      begin vb.commandbutton cmddonde 
         caption         =   "/donde"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   51
         top             =   1320
         width           =   1095
      end
      begin vb.commandbutton cmdpenas 
         caption         =   "/penas"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         style           =   1  'graphical
         tabindex        =   50
         top             =   3480
         width           =   1095
      end
      begin vb.commandbutton cmdtelep 
         caption         =   "/telep"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   49
         top             =   960
         width           =   1095
      end
      begin vb.commandbutton cmdsilenciar 
         caption         =   "/silenciar"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   48
         top             =   3840
         width           =   1095
      end
      begin vb.commandbutton cmdira 
         caption         =   "/ira"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   47
         top             =   1320
         width           =   1095
      end
      begin vb.commandbutton cmdcarcel 
         caption         =   "/carcel"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   46
         top             =   3480
         width           =   1095
      end
      begin vb.commandbutton cmdadvertencia 
         caption         =   "/advertencia"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   45
         top             =   3480
         width           =   1335
      end
      begin vb.commandbutton cmdinfo 
         caption         =   "/info"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   44
         top             =   1920
         width           =   1095
      end
      begin vb.commandbutton cmdstat 
         caption         =   "/stat"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   43
         top             =   1920
         width           =   1095
      end
      begin vb.commandbutton cmdbal 
         caption         =   "/bal"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   42
         top             =   1920
         width           =   1095
      end
      begin vb.commandbutton cmdinv 
         caption         =   "/inv"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   41
         top             =   2280
         width           =   1095
      end
      begin vb.commandbutton cmdbov 
         caption         =   "/bov"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   40
         top             =   2280
         width           =   1095
      end
      begin vb.commandbutton cmdskills 
         caption         =   "/skills"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   39
         top             =   2280
         width           =   1095
      end
      begin vb.commandbutton cmdrevivir 
         caption         =   "/revivir"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   38
         top             =   4800
         width           =   1095
      end
      begin vb.commandbutton cmdperdon 
         caption         =   "/perdon"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   37
         top             =   5160
         width           =   1095
      end
      begin vb.commandbutton cmdechar 
         caption         =   "/echar"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   36
         top             =   3840
         width           =   1095
      end
      begin vb.commandbutton cmdejecutar 
         caption         =   "/ejecutar"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   35
         top             =   4800
         width           =   1095
      end
      begin vb.commandbutton cmdban 
         caption         =   "/ban"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   34
         top             =   4200
         width           =   1095
      end
      begin vb.commandbutton cmdunban 
         caption         =   "/unban"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   33
         top             =   4200
         width           =   1095
      end
      begin vb.commandbutton cmdsum 
         caption         =   "/sum"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   32
         top             =   960
         width           =   1095
      end
      begin vb.commandbutton cmdnick2ip 
         caption         =   "/nick2ip"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   31
         top             =   2880
         width           =   1095
      end
      begin vb.commandbutton cmdestupido 
         caption         =   "/estupido"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   30
         top             =   5760
         width           =   1095
      end
      begin vb.commandbutton cmdnoestupido 
         caption         =   "/noestupido"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   29
         top             =   5760
         width           =   1335
      end
      begin vb.commandbutton cmdborrarpena 
         caption         =   "/borrarpena"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   28
         top             =   3840
         width           =   1335
      end
      begin vb.commandbutton cmdlastip 
         caption         =   "/lastip"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   27
         top             =   2880
         width           =   1095
      end
      begin vb.commandbutton cmdconden 
         caption         =   "/conden"
         causesvalidation=   0   'false
         height          =   315
         left            =   120
         tabindex        =   26
         top             =   5160
         width           =   1095
      end
      begin vb.commandbutton cmdrajar 
         caption         =   "/rajar"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   25
         top             =   5160
         width           =   1095
      end
      begin vb.commandbutton cmdrajarclan 
         caption         =   "/rajarclan"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   24
         top             =   4200
         width           =   1335
      end
      begin vb.commandbutton cmdlastemail 
         caption         =   "/lastemail"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   23
         top             =   2880
         width           =   1095
      end
   end
   begin vb.commandbutton cmdcerrar 
      caption         =   "cerrar"
      causesvalidation=   0   'false
      height          =   375
      left            =   0
      tabindex        =   0
      top             =   8160
      width           =   4215
   end
   begin vb.frame frame 
      borderstyle     =   0  'none
      height          =   1455
      index           =   1
      left            =   120
      tabindex        =   1
      top             =   360
      width           =   3975
      begin vb.commandbutton cmdgmsg 
         caption         =   "/gmsg"
         causesvalidation=   0   'false
         height          =   315
         left            =   240
         tabindex        =   11
         top             =   600
         width           =   1095
      end
      begin vb.commandbutton cmdhora 
         caption         =   "/hora"
         causesvalidation=   0   'false
         height          =   315
         left            =   240
         tabindex        =   10
         top             =   120
         width           =   855
      end
      begin vb.commandbutton cmdrmsg 
         caption         =   "/rmsg"
         causesvalidation=   0   'false
         height          =   315
         left            =   1440
         tabindex        =   9
         top             =   600
         width           =   1095
      end
      begin vb.commandbutton cmdrealmsg 
         caption         =   "/realmsg"
         causesvalidation=   0   'false
         height          =   315
         left            =   240
         tabindex        =   8
         top             =   1080
         width           =   1095
      end
      begin vb.commandbutton cmdcaosmsg 
         caption         =   "/caosmsg"
         causesvalidation=   0   'false
         height          =   315
         left            =   1440
         tabindex        =   7
         top             =   1080
         width           =   1095
      end
      begin vb.commandbutton cmdciumsg 
         caption         =   "/ciumsg"
         causesvalidation=   0   'false
         height          =   315
         left            =   2640
         tabindex        =   6
         top             =   1080
         width           =   1095
      end
      begin vb.commandbutton cmdtalkas 
         caption         =   "/talkas"
         causesvalidation=   0   'false
         height          =   315
         left            =   2880
         tabindex        =   5
         top             =   120
         width           =   855
      end
      begin vb.commandbutton cmdmotdcambia 
         caption         =   "/motdcambia"
         causesvalidation=   0   'false
         height          =   315
         left            =   1320
         tabindex        =   4
         top             =   120
         width           =   1335
      end
      begin vb.commandbutton cmdsmsg 
         caption         =   "/smsg"
         causesvalidation=   0   'false
         height          =   315
         left            =   2640
         tabindex        =   3
         top             =   600
         width           =   1095
      end
   end
   begin vb.frame frame 
      borderstyle     =   0  'none
      height          =   2415
      index           =   5
      left            =   120
      tabindex        =   55
      top             =   360
      width           =   3975
      begin vb.commandbutton cmdcc 
         caption         =   "/cc"
         causesvalidation=   0   'false
         height          =   315
         left            =   720
         tabindex        =   72
         top             =   720
         width           =   2655
      end
      begin vb.commandbutton cmdlimpiar 
         caption         =   "/limpiar"
         causesvalidation=   0   'false
         height          =   315
         left            =   2280
         tabindex        =   71
         top             =   120
         width           =   1095
      end
      begin vb.commandbutton cmdct 
         caption         =   "/ct"
         causesvalidation=   0   'false
         height          =   315
         left            =   720
         tabindex        =   70
         top             =   1200
         width           =   1095
      end
      begin vb.commandbutton cmddt 
         caption         =   "/dt"
         causesvalidation=   0   'false
         height          =   315
         left            =   2280
         tabindex        =   69
         top             =   1200
         width           =   1095
      end
      begin vb.commandbutton cmdlluvia 
         caption         =   "/lluvia"
         causesvalidation=   0   'false
         height          =   315
         left            =   720
         tabindex        =   68
         top             =   120
         width           =   1095
      end
      begin vb.commandbutton cmdmassdest 
         caption         =   "/massdest"
         causesvalidation=   0   'false
         height          =   315
         left            =   2280
         tabindex        =   67
         top             =   2040
         width           =   1095
      end
      begin vb.commandbutton cmdpiso 
         caption         =   "/piso"
         causesvalidation=   0   'false
         height          =   315
         left            =   720
         tabindex        =   66
         top             =   2040
         width           =   1095
      end
      begin vb.commandbutton cmdci 
         caption         =   "/ci"
         causesvalidation=   0   'false
         height          =   315
         left            =   720
         tabindex        =   65
         top             =   1680
         width           =   1095
      end
      begin vb.commandbutton cmddest 
         caption         =   "/dest"
         causesvalidation=   0   'false
         height          =   315
         left            =   2280
         tabindex        =   64
         top             =   1680
         width           =   1095
      end
   end
   begin vb.frame frame 
      borderstyle     =   0  'none
      height          =   2415
      index           =   2
      left            =   120
      tabindex        =   2
      top             =   360
      width           =   3975
      begin vb.commandbutton cmdonlinereal 
         caption         =   "/onlinereal"
         causesvalidation=   0   'false
         height          =   315
         left            =   480
         tabindex        =   21
         top             =   1560
         width           =   1335
      end
      begin vb.commandbutton cmdonlinecaos 
         caption         =   "/onlinecaos"
         causesvalidation=   0   'false
         height          =   315
         left            =   2160
         tabindex        =   20
         top             =   1560
         width           =   1335
      end
      begin vb.commandbutton cmdnene 
         caption         =   "/nene"
         causesvalidation=   0   'false
         height          =   315
         left            =   480
         tabindex        =   19
         top             =   1080
         width           =   1335
      end
      begin vb.commandbutton cmdshow_sos 
         caption         =   "/show sos"
         causesvalidation=   0   'false
         height          =   315
         left            =   480
         tabindex        =   18
         top             =   120
         width           =   1335
      end
      begin vb.commandbutton cmdtrabajando 
         caption         =   "/trabajando"
         causesvalidation=   0   'false
         height          =   315
         left            =   480
         tabindex        =   17
         top             =   600
         width           =   1335
      end
      begin vb.commandbutton cmdocultando 
         caption         =   "/ocultando"
         causesvalidation=   0   'false
         height          =   315
         left            =   2160
         tabindex        =   16
         top             =   600
         width           =   1335
      end
      begin vb.commandbutton cmdonlinegm 
         caption         =   "/onlinegm"
         causesvalidation=   0   'false
         height          =   315
         left            =   480
         tabindex        =   15
         top             =   2040
         width           =   3015
      end
      begin vb.commandbutton cmdonlinemap 
         caption         =   "/onlinemap"
         causesvalidation=   0   'false
         height          =   315
         left            =   2160
         tabindex        =   14
         top             =   1080
         width           =   1335
      end
      begin vb.commandbutton cmdborrar_sos 
         caption         =   "/borrar sos"
         causesvalidation=   0   'false
         height          =   315
         left            =   2160
         tabindex        =   13
         top             =   120
         width           =   1335
      end
   end
   begin vb.frame frame 
      borderstyle     =   0  'none
      height          =   1815
      index           =   6
      left            =   120
      tabindex        =   56
      top             =   360
      width           =   3975
      begin vb.commandbutton cmdshowcmsg 
         caption         =   "/showcmsg"
         causesvalidation=   0   'false
         height          =   315
         left            =   480
         tabindex        =   80
         top             =   1080
         width           =   1335
      end
      begin vb.commandbutton cmdbanclan 
         caption         =   "/banclan"
         causesvalidation=   0   'false
         height          =   315
         left            =   480
         tabindex        =   79
         top             =   1440
         width           =   3015
      end
      begin vb.commandbutton cmdmiembrosclan 
         caption         =   "/miembrosclan"
         causesvalidation=   0   'false
         height          =   315
         left            =   1920
         tabindex        =   78
         top             =   1080
         width           =   1575
      end
      begin vb.commandbutton cmdbanipreload 
         caption         =   "/banipreload"
         causesvalidation=   0   'false
         height          =   315
         left            =   1440
         tabindex        =   77
         top             =   480
         width           =   2295
      end
      begin vb.commandbutton cmdbaniplist 
         caption         =   "/baniplist"
         causesvalidation=   0   'false
         height          =   315
         left            =   240
         tabindex        =   76
         top             =   480
         width           =   1095
      end
      begin vb.commandbutton cmdip2nick 
         caption         =   "/ip2nick"
         causesvalidation=   0   'false
         height          =   315
         left            =   240
         tabindex        =   75
         top             =   120
         width           =   1095
      end
      begin vb.commandbutton cmdbanip 
         caption         =   "/banip"
         causesvalidation=   0   'false
         height          =   315
         left            =   1440
         tabindex        =   74
         top             =   120
         width           =   975
      end
      begin vb.commandbutton cmdunbanip 
         caption         =   "/unbanip"
         causesvalidation=   0   'false
         height          =   315
         left            =   2520
         tabindex        =   73
         top             =   120
         width           =   1215
      end
   end
   begin vb.frame frame 
      borderstyle     =   0  'none
      height          =   1935
      index           =   4
      left            =   120
      tabindex        =   22
      top             =   360
      width           =   3975
      begin vb.commandbutton cmdshowname 
         caption         =   "/showname"
         causesvalidation=   0   'false
         height          =   315
         left            =   2280
         tabindex        =   63
         top             =   600
         width           =   1215
      end
      begin vb.commandbutton cmdrem 
         caption         =   "/rem"
         causesvalidation=   0   'false
         height          =   315
         left            =   600
         tabindex        =   62
         top             =   1560
         width           =   2895
      end
      begin vb.commandbutton cmdinvisible 
         caption         =   "/invisible"
         causesvalidation=   0   'false
         height          =   315
         left            =   600
         tabindex        =   61
         top             =   120
         width           =   1215
      end
      begin vb.commandbutton cmdsetdesc 
         caption         =   "/setdesc"
         causesvalidation=   0   'false
         height          =   315
         left            =   2280
         tabindex        =   60
         top             =   1080
         width           =   1215
      end
      begin vb.commandbutton cmdnave 
         caption         =   "/nave"
         causesvalidation=   0   'false
         height          =   315
         left            =   600
         tabindex        =   59
         top             =   600
         width           =   1215
      end
      begin vb.commandbutton cmdchatcolor 
         caption         =   "/chatcolor"
         causesvalidation=   0   'false
         height          =   315
         left            =   600
         tabindex        =   58
         top             =   1080
         width           =   1215
      end
      begin vb.commandbutton cmdignorado 
         caption         =   "/ignorado"
         causesvalidation=   0   'false
         height          =   315
         left            =   2280
         tabindex        =   57
         top             =   120
         width           =   1215
      end
   end
   begin mscomctllib.tabstrip tabstrip 
      causesvalidation=   0   'false
      height          =   1935
      left            =   0
      tabindex        =   81
      top             =   0
      width           =   4215
      _extentx        =   7435
      _extenty        =   3413
      _version        =   393216
      beginproperty tabs {1efb6598-857c-11d1-b16a-00c0f0283628} 
         numtabs         =   6
         beginproperty tab1 {1efb659a-857c-11d1-b16a-00c0f0283628} 
            caption         =   "message"
            imagevartype    =   2
         endproperty
         beginproperty tab2 {1efb659a-857c-11d1-b16a-00c0f0283628} 
            caption         =   "info"
            imagevartype    =   2
         endproperty
         beginproperty tab3 {1efb659a-857c-11d1-b16a-00c0f0283628} 
            caption         =   "player"
            imagevartype    =   2
         endproperty
         beginproperty tab4 {1efb659a-857c-11d1-b16a-00c0f0283628} 
            caption         =   "me"
            imagevartype    =   2
         endproperty
         beginproperty tab5 {1efb659a-857c-11d1-b16a-00c0f0283628} 
            caption         =   "world"
            imagevartype    =   2
         endproperty
         beginproperty tab6 {1efb659a-857c-11d1-b16a-00c0f0283628} 
            caption         =   "admin"
            imagevartype    =   2
         endproperty
      endproperty
   end
end
attribute vb_name = "frmpanelgm"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmpanelgm.frm
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

''
' important!!!
' to prevent the combo list of usernames from closing when a conole message arrives, the validate event allways
' sets the cancel arg to true. this, combined with setting the causesvalidation of the richtextbox to true
' makes the trick. however, in order to be able to use other commands, all other controls in this form must have the
' cuasesvalidation parameter set to false (unless you want to code your custom flag system to know when to allow or not the loose of focus).

private sub cbolistausus_validate(cancel as boolean)
    cancel = true
end sub

private sub cmdaceptconse_click()
    '/aceptconse
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea aceptar a " & nick & " como consejero real?", vbyesno, "atencion!") = vbyes then _
            call writeacceptroyalcouncilmember(nick)
end sub

private sub cmdaceptconsecaos_click()
    '/aceptconsecaos
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea aceptar a " & nick & " como consejero del caos?", vbyesno, "atencion!") = vbyes then _
            call writeacceptchaoscouncilmember(nick)
end sub

private sub cmdadvertencia_click()
    '/advertencia
    dim tstr as string
    dim nick as string

    nick = cbolistausus.text
        
    if lenb(nick) <> 0 then
        tstr = inputbox("escriba el motivo de la advertencia.", "advertir a " & nick)
                
        if lenb(tstr) <> 0 then
            'we use the parser to control the command format
            call parseusercommand("/advertencia " & nick & "@" & tstr)
        end if
    end if
end sub

private sub cmdbal_click()
    '/bal
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerequestchargold(nick)
end sub

private sub cmdban_click()
    '/ban
    dim tstr as string
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then
        tstr = inputbox("escriba el motivo del ban.", "ban a " & nick)
                
        if lenb(tstr) <> 0 then _
            if msgbox("�seguro desea banear a " & nick & "?", vbyesno, "atencion!") = vbyes then _
                call writebanchar(nick, tstr)
    end if
end sub

private sub cmdbanclan_click()
    '/banclan
    dim tstr as string
    
    tstr = inputbox("escriba el nombre del clan.", "banear clan")
    if lenb(tstr) <> 0 then _
        if msgbox("�seguro desea banear al clan " & tstr & "?", vbyesno, "atencion!") = vbyes then _
            call writeguildban(tstr)
end sub

private sub cmdbanip_click()
    '/banip
    dim tstr as string
    dim reason as string
    
    tstr = inputbox("escriba el ip o el nick del pj.", "banear ip")
    
    reason = inputbox("escriba el motivo del ban.", "banear ip")
    
    if lenb(tstr) <> 0 then _
        if msgbox("�seguro desea banear la ip " & tstr & "?", vbyesno, "atencion!") = vbyes then _
            call parseusercommand("/banip " & tstr & " " & reason) 'we use the parser to control the command format
end sub

private sub cmdbaniplist_click()
    '/baniplist
    call writebannediplist
end sub

private sub cmdbanipreload_click()
    '/banipreload
    call writebannedipreload
end sub

private sub cmdborrar_sos_click()
    '/borrar sos
    if msgbox("�seguro desea borrar el sos?", vbyesno, "atencion!") = vbyes then _
        call writecleansos
end sub

private sub cmdborrarpena_click()
    '/borrarpena
    dim tstr as string
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then
        tstr = inputbox("indique el n�mero de la pena a borrar.", "borrar pena")
        if lenb(tstr) <> 0 then _
            if msgbox("�seguro desea borrar la pena " & tstr & " a " & nick & "?", vbyesno, "atencion!") = vbyes then _
                call parseusercommand("/borrarpena " & nick & "@" & tstr) 'we use the parser to control the command format
    end if
end sub

private sub cmdbov_click()
    '/bov
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerequestcharbank(nick)
end sub

private sub cmdcaosmsg_click()
    '/caosmsg
    dim tstr as string
    
    tstr = inputbox("escriba un mensaje.", "mensaje por consola legionoscura")
    if lenb(tstr) <> 0 then _
        call writechaoslegionmessage(tstr)
end sub

private sub cmdcarcel_click()
    '/carcel
    dim tstr as string
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then
        tstr = inputbox("escriba el motivo de la pena.", "carcel a " & nick)
                
        if lenb(tstr) <> 0 then
            tstr = tstr & "@" & inputbox("indique el tiempo de condena (entre 0 y 60 minutos).", "carcel a " & nick)
            'we use the parser to control the command format
            call parseusercommand("/carcel " & nick & "@" & tstr)
        end if
    end if
end sub

private sub cmdcc_click()
    '/cc
    call writespawnlistrequest
end sub

private sub cmdchatcolor_click()
    '/chatcolor
    dim tstr as string
    
    tstr = inputbox("defina el color (r g b). deje en blanco para usar el default.", "cambiar color del chat")
    
    call parseusercommand("/chatcolor " & tstr) 'we use the parser to control the command format
end sub

private sub cmdci_click()
    '/ci
    dim tstr as string
    
    tstr = inputbox("indique el n�mero del objeto a crear.", "crear objeto")
    if lenb(tstr) <> 0 then _
        if msgbox("�seguro desea crear el objeto " & tstr & "?", vbyesno, "atencion!") = vbyes then _
            call parseusercommand("/ci " & tstr) 'we use the parser to control the command format
end sub

private sub cmdciumsg_click()
    '/ciumsg
    dim tstr as string
    
    tstr = inputbox("escriba un mensaje.", "mensaje por consola ciudadanos")
    if lenb(tstr) <> 0 then _
        call writecitizenmessage(tstr)
end sub

private sub cmdconden_click()
    '/conden
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea volver criminal a " & nick & "?", vbyesno, "atencion!") = vbyes then _
            call writeturncriminal(nick)
end sub

private sub cmdconsulta_click()
    writeconsulta
end sub

private sub cmdct_click()
    '/ct
    dim tstr as string
    
    tstr = inputbox("indique la posici�n donde lleva el portal (mapa x y).", "crear portal")
    if lenb(tstr) <> 0 then _
        call parseusercommand("/ct " & tstr) 'we use the parser to control the command format
end sub

private sub cmddest_click()
    '/dest
    if msgbox("�seguro desea destruir el objeto sobre el que esta parado?", vbyesno, "atencion!") = vbyes then _
        call writedestroyitems
end sub

private sub cmddonde_click()
    '/donde
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writewhere(nick)
end sub

private sub cmddt_click()
    'dt
    if msgbox("�seguro desea destruir el portal?", vbyesno, "atencion!") = vbyes then _
        call writeteleportdestroy
end sub

private sub cmdechar_click()
    '/echar
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writekick(nick)
end sub

private sub cmdejecutar_click()
    '/ejecutar
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea ejecutar a " & nick & "?", vbyesno, "atencion!") = vbyes then _
            call writeexecute(nick)
end sub

private sub cmdestupido_click()
    '/estupido
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writemakedumb(nick)
end sub

private sub cmdgmsg_click()
    '/gmsg
    dim tstr as string
    
    tstr = inputbox("escriba el mensaje.", "mensaje por consola de gm")
    if lenb(tstr) <> 0 then _
        call writegmmessage(tstr)
end sub

private sub cmdhora_click()
    '/hora
    call protocol.writeservertime
end sub

private sub cmdignorado_click()
    '/ignorado
    call writeignored
end sub

private sub cmdinfo_click()
    '/info
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerequestcharinfo(nick)
end sub

private sub cmdinv_click()
    '/inv
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerequestcharinventory(nick)
end sub

private sub cmdinvisible_click()
    '/invisible
    call writeinvisible
end sub

private sub cmdip2nick_click()
    '/ip2nick
    dim tstr as string
    
    tstr = inputbox("escriba la ip.", "ip to nick")
    if lenb(tstr) <> 0 then _
        call parseusercommand("/ip2nick " & tstr) 'we use the parser to control the command format
end sub

private sub cmdira_click()
    '/ira
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writegotochar(nick)
end sub

private sub cmdircerca_click()
    '/ircerca
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writegonearby(nick)
end sub

private sub cmdkickconse_click()
    'kickconse
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea destituir a " & nick & " de su cargo de consejero?", vbyesno, "atencion!") = vbyes then _
            call writecouncilkick(nick)
end sub

private sub cmdlastemail_click()
    '/lastemail
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerequestcharmail(nick)
end sub

private sub cmdlastip_click()
    '/lastip
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writelastip(nick)
end sub

private sub cmdlimpiar_click()
    '/limpiar
    call writecleanworld
end sub

private sub cmdlluvia_click()
    '/lluvia
    call writeraintoggle
end sub

private sub cmdmassdest_click()
    '/massdest
    if msgbox("�seguro desea destruir todos los items del mapa?", vbyesno, "atencion!") = vbyes then _
        call writedestroyallitemsinarea
end sub

private sub cmdmiembrosclan_click()
    '/miembrosclan
    dim tstr as string
    
    tstr = inputbox("escriba el nombre del clan.", "lista de miembros del clan")
    if lenb(tstr) <> 0 then _
        call writeguildmemberlist(tstr)
end sub

private sub cmdmotdcambia_click()
    '/motdcambia
    call writechangemotd
end sub

private sub cmdnave_click()
    '/nave
    call writenavigatetoggle
end sub

private sub cmdnene_click()
    '/nene
    dim tstr as string
    
    tstr = inputbox("indique el mapa.", "n�mero de npcs enemigos.")
    if lenb(tstr) <> 0 then _
        call parseusercommand("/nene " & tstr) 'we use the parser to control the command format
end sub

private sub cmdnick2ip_click()
    '/nick2ip
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writenicktoip(nick)
end sub

private sub cmdnocaos_click()
    '/nocaos
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea expulsar a " & nick & " de la legi�n oscura?", vbyesno, "atencion!") = vbyes then _
            call writechaoslegionkick(nick)
end sub

private sub cmdnoestupido_click()
    '/noestupido
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writemakedumbnomore(nick)
end sub

private sub cmdnoreal_click()
    '/noreal
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea expulsar a " & nick & " de la armada real?", vbyesno, "atencion!") = vbyes then _
            call writeroyalarmykick(nick)
end sub

private sub cmdocultando_click()
    '/ocultando
    call writehiding
end sub

private sub cmdonlinecaos_click()
    '/onlinecaos
    call writeonlinechaoslegion
end sub

private sub cmdonlinegm_click()
    '/onlinegm
    call writeonlinegm
end sub

private sub cmdonlinemap_click()
    '/onlinemap
    call writeonlinemap(usermap)
end sub

private sub cmdonlinereal_click()
    '/onlinereal
    call writeonlineroyalarmy
end sub

private sub cmdpenas_click()
    '/penas
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writepunishments(nick)
end sub

private sub cmdperdon_click()
    '/perdon
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writeforgive(nick)
end sub

private sub cmdpiso_click()
    '/piso
    call writeitemsinthefloor
end sub

private sub cmdrajar_click()
    '/rajar
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea resetear la facci�n de " & nick & "?", vbyesno, "atencion!") = vbyes then _
            call writeresetfactions(nick)
end sub

private sub cmdrajarclan_click()
    '/rajarclan
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea expulsar a " & nick & " de su clan?", vbyesno, "atencion!") = vbyes then _
            call writeremovecharfromguild(nick)
end sub

private sub cmdrealmsg_click()
    '/realmsg
    dim tstr as string
    
    tstr = inputbox("escriba un mensaje.", "mensaje por consola armadareal")
    if lenb(tstr) <> 0 then _
        call writeroyalarmymessage(tstr)
end sub

private sub cmdrem_click()
    '/rem
    dim tstr as string
    
    tstr = inputbox("escriba el comentario.", "comentario en el loggm")
    if lenb(tstr) <> 0 then _
        call writecomment(tstr)
end sub

private sub cmdrevivir_click()
    '/revivir
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerevivechar(nick)
end sub

private sub cmdrmsg_click()
    '/rmsg
    dim tstr as string
    
    tstr = inputbox("escriba el mensaje.", "mensaje por consola de rolemaster")
    if lenb(tstr) <> 0 then _
        call writeservermessage(tstr)
end sub

private sub cmdsetdesc_click()
    '/setdesc
    dim tstr as string
    
    tstr = inputbox("escriba una desc.", "set description")
    if lenb(tstr) <> 0 then _
        call writesetchardescription(tstr)
end sub

private sub cmdshow_sos_click()
    '/show sos
    call writesosshowlist
end sub

private sub cmdshowcmsg_click()
    '/showcmsg
    dim tstr as string
    
    tstr = inputbox("escriba el nombre del clan que desea escuchar.", "escuchar los mensajes del clan")
    if lenb(tstr) <> 0 then _
        call writeshowguildmessages(tstr)
end sub

private sub cmdshowname_click()
    '/showname
    call writeshowname
end sub

private sub cmdsilenciar_click()
    '/silenciar
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writesilence(nick)
end sub

private sub cmdskills_click()
    '/skills
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerequestcharskills(nick)
end sub

private sub cmdsmsg_click()
    '/smsg
    dim tstr as string
    
    tstr = inputbox("escriba el mensaje.", "mensaje de sistema")
    if lenb(tstr) <> 0 then _
        call writesystemmessage(tstr)
end sub

private sub cmdstat_click()
    '/stat
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writerequestcharstats(nick)
end sub

private sub cmdsum_click()
    '/sum
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        call writesummonchar(nick)
end sub

private sub cmdtalkas_click()
    '/talkas
    dim tstr as string
    
    tstr = inputbox("escriba un mensaje.", "hablar por npc")
    if lenb(tstr) <> 0 then _
        call writetalkasnpc(tstr)
end sub

private sub cmdtelep_click()
    '/telep
    dim tstr as string
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then
        tstr = inputbox("indique la posici�n (mapa x y).", "transportar a " & nick)
        if lenb(tstr) <> 0 then _
            call parseusercommand("/telep " & nick & " " & tstr) 'we use the parser to control the command format
    end if
end sub

private sub cmdtrabajando_click()
    '/trabajando
    call writeworking
end sub

private sub cmdunban_click()
    '/unban
    dim nick as string

    nick = cbolistausus.text
    
    if lenb(nick) <> 0 then _
        if msgbox("�seguro desea unbanear a " & nick & "?", vbyesno, "atencion!") = vbyes then _
            call writeunbanchar(nick)
end sub

private sub cmdunbanip_click()
    '/unbanip
    dim tstr as string
    
    tstr = inputbox("escriba el ip.", "unbanear ip")
    if lenb(tstr) <> 0 then _
        if msgbox("�seguro desea unbanear la ip " & tstr & "?", vbyesno, "atencion!") = vbyes then _
            call parseusercommand("/unbanip " & tstr) 'we use the parser to control the command format
end sub

private sub form_load()
    call showtab(1)
    call cmdactualiza_click
end sub

private sub cmdactualiza_click()
    call writerequestuserlist
    call flushbuffer
end sub

private sub cmdcerrar_click()
    unload me
end sub

private sub form_queryunload(cancel as integer, unloadmode as integer)
    unload me
end sub

private sub tabstrip_click()
    call showtab(tabstrip.selecteditem.index)
end sub

private sub showtab(tabid as byte)
    dim i as byte
    
    for i = 1 to frame.ubound
        frame(i).visible = (i = tabid)
    next i
    
    with frame(tabid)
        frmpanelgm.height = .height + 1280
        tabstrip.height = .height + 480
        cmdcerrar.top = .height + 465
    end with
end sub
