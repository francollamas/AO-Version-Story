version 5.00
begin vb.form frminterv 
   caption         =   "intervalos"
   clientheight    =   4710
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   7650
   linktopic       =   "form1"
   scaleheight     =   4710
   scalewidth      =   7650
   startupposition =   3  'windows default
   begin vb.commandbutton command2 
      caption         =   "guardar intervalos"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   4200
      tabindex        =   36
      top             =   4320
      width           =   3255
   end
   begin vb.commandbutton command1 
      caption         =   "aplicar"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   2160
      tabindex        =   0
      top             =   4320
      width           =   2055
   end
   begin vb.frame frame11 
      caption         =   "npcs"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   2880
      tabindex        =   49
      top             =   2160
      width           =   1695
      begin vb.frame frame4 
         caption         =   "a.i"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1575
         left            =   150
         tabindex        =   50
         top             =   240
         width           =   1365
         begin vb.textbox txtai 
            height          =   285
            left            =   150
            tabindex        =   52
            text            =   "0"
            top             =   1080
            width           =   1050
         end
         begin vb.textbox txtnpcpuedeatacar 
            height          =   285
            left            =   135
            tabindex        =   51
            text            =   "0"
            top             =   510
            width           =   1050
         end
         begin vb.label label7 
            autosize        =   -1  'true
            caption         =   "ai"
            height          =   195
            left            =   165
            tabindex        =   54
            top             =   840
            width           =   150
         end
         begin vb.label label9 
            autosize        =   -1  'true
            caption         =   "puede atacar"
            height          =   195
            left            =   150
            tabindex        =   53
            top             =   255
            width           =   960
         end
      end
   end
   begin vb.frame frame12 
      caption         =   "clima && ambiente"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   4680
      tabindex        =   39
      top             =   2160
      width           =   2865
      begin vb.frame frame7 
         caption         =   "frio y fx ambientales"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1650
         left            =   120
         tabindex        =   40
         top             =   240
         width           =   2625
         begin vb.textbox txtcmdexec 
            height          =   285
            left            =   1320
            tabindex        =   44
            text            =   "0"
            top             =   1110
            width           =   915
         end
         begin vb.textbox txtintervaloperdidastaminalluvia 
            height          =   300
            left            =   1320
            tabindex        =   43
            text            =   "0"
            top             =   480
            width           =   930
         end
         begin vb.textbox txtintervalowavfx 
            height          =   300
            left            =   150
            tabindex        =   42
            text            =   "0"
            top             =   480
            width           =   930
         end
         begin vb.textbox txtintervalofrio 
            height          =   285
            left            =   180
            tabindex        =   41
            text            =   "0"
            top             =   1080
            width           =   915
         end
         begin vb.label label20 
            autosize        =   -1  'true
            caption         =   "timerexec"
            height          =   195
            left            =   1320
            tabindex        =   48
            top             =   840
            width           =   750
         end
         begin vb.label label19 
            autosize        =   -1  'true
            caption         =   "stamina lluvia"
            height          =   195
            left            =   1350
            tabindex        =   47
            top             =   270
            width           =   1035
         end
         begin vb.label label13 
            autosize        =   -1  'true
            caption         =   "fxs"
            height          =   195
            left            =   180
            tabindex        =   46
            top             =   270
            width           =   270
         end
         begin vb.label label12 
            autosize        =   -1  'true
            caption         =   "frio"
            height          =   195
            left            =   195
            tabindex        =   45
            top             =   810
            width           =   255
         end
      end
   end
   begin vb.frame frame6 
      caption         =   "usuarios"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   120
      tabindex        =   3
      top             =   0
      width           =   7455
      begin vb.frame frame9 
         caption         =   "otros"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   90
         tabindex        =   24
         top             =   210
         width           =   1410
         begin vb.textbox txtintervaloparaconexion 
            height          =   300
            left            =   45
            tabindex        =   26
            text            =   "0"
            top             =   495
            width           =   930
         end
         begin vb.textbox txttrabajo 
            height          =   300
            left            =   60
            tabindex        =   25
            text            =   "0"
            top             =   1020
            width           =   930
         end
         begin vb.label label14 
            autosize        =   -1  'true
            caption         =   "intervalocon"
            height          =   195
            left            =   120
            tabindex        =   28
            top             =   270
            width           =   900
         end
         begin vb.label label16 
            autosize        =   -1  'true
            caption         =   "trabajo"
            height          =   195
            left            =   165
            tabindex        =   27
            top             =   780
            width           =   540
         end
      end
      begin vb.frame frame8 
         caption         =   "combate"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   1545
         tabindex        =   19
         top             =   210
         width           =   1410
         begin vb.textbox txtpuedeatacar 
            height          =   300
            left            =   135
            tabindex        =   22
            text            =   "0"
            top             =   1200
            width           =   930
         end
         begin vb.textbox txtintervalolanzahechizo 
            height          =   300
            left            =   150
            tabindex        =   20
            text            =   "0"
            top             =   525
            width           =   930
         end
         begin vb.label label17 
            autosize        =   -1  'true
            caption         =   "puede atacar"
            height          =   195
            left            =   135
            tabindex        =   23
            top             =   930
            width           =   975
         end
         begin vb.label label15 
            autosize        =   -1  'true
            caption         =   "lanza spell"
            height          =   195
            left            =   150
            tabindex        =   21
            top             =   285
            width           =   825
         end
      end
      begin vb.frame frame3 
         caption         =   "hambre y sed"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   5925
         tabindex        =   14
         top             =   210
         width           =   1410
         begin vb.textbox txtintervalohambre 
            height          =   285
            left            =   150
            tabindex        =   16
            text            =   "0"
            top             =   510
            width           =   1050
         end
         begin vb.textbox txtintervalosed 
            height          =   285
            left            =   150
            tabindex        =   15
            text            =   "0"
            top             =   1185
            width           =   1050
         end
         begin vb.label label5 
            autosize        =   -1  'true
            caption         =   "hambre"
            height          =   195
            left            =   180
            tabindex        =   18
            top             =   255
            width           =   555
         end
         begin vb.label label6 
            autosize        =   -1  'true
            caption         =   "sed"
            height          =   195
            left            =   165
            tabindex        =   17
            top             =   930
            width           =   285
         end
      end
      begin vb.frame frame1 
         caption         =   "sanar"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   4470
         tabindex        =   9
         top             =   210
         width           =   1410
         begin vb.textbox txtsanaintervalodescansar 
            height          =   285
            left            =   150
            tabindex        =   11
            text            =   "0"
            top             =   510
            width           =   1050
         end
         begin vb.textbox txtsanaintervalosindescansar 
            height          =   285
            left            =   150
            tabindex        =   10
            text            =   "0"
            top             =   1185
            width           =   1050
         end
         begin vb.label label3 
            autosize        =   -1  'true
            caption         =   "descansando"
            height          =   195
            left            =   180
            tabindex        =   13
            top             =   255
            width           =   990
         end
         begin vb.label label1 
            autosize        =   -1  'true
            caption         =   "sin descansar"
            height          =   195
            left            =   165
            tabindex        =   12
            top             =   930
            width           =   1005
         end
      end
      begin vb.frame frame2 
         caption         =   "stamina"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1710
         left            =   3015
         tabindex        =   4
         top             =   210
         width           =   1410
         begin vb.textbox txtstaminaintervalosindescansar 
            height          =   285
            left            =   150
            tabindex        =   6
            text            =   "0"
            top             =   1185
            width           =   1050
         end
         begin vb.textbox txtstaminaintervalodescansar 
            height          =   285
            left            =   165
            tabindex        =   5
            text            =   "0"
            top             =   510
            width           =   1050
         end
         begin vb.label label2 
            autosize        =   -1  'true
            caption         =   "sin descansar"
            height          =   195
            left            =   165
            tabindex        =   8
            top             =   930
            width           =   1005
         end
         begin vb.label label4 
            autosize        =   -1  'true
            caption         =   "descansando"
            height          =   195
            left            =   180
            tabindex        =   7
            top             =   255
            width           =   990
         end
      end
   end
   begin vb.frame frame5 
      caption         =   "magia"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2055
      left            =   120
      tabindex        =   2
      top             =   2160
      width           =   2655
      begin vb.frame frame10 
         caption         =   "duracion spells"
         beginproperty font 
            name            =   "ms sans serif"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   1650
         left            =   135
         tabindex        =   29
         top             =   270
         width           =   2400
         begin vb.textbox txtinvocacion 
            height          =   300
            left            =   1170
            tabindex        =   37
            text            =   "0"
            top             =   1170
            width           =   900
         end
         begin vb.textbox txtintervaloinvisible 
            height          =   300
            left            =   1170
            tabindex        =   34
            text            =   "0"
            top             =   495
            width           =   900
         end
         begin vb.textbox txtintervaloparalizado 
            height          =   300
            left            =   195
            tabindex        =   31
            text            =   "0"
            top             =   1170
            width           =   795
         end
         begin vb.textbox txtintervaloveneno 
            height          =   300
            left            =   195
            tabindex        =   30
            text            =   "0"
            top             =   510
            width           =   795
         end
         begin vb.label label18 
            autosize        =   -1  'true
            caption         =   "invocacion"
            height          =   195
            left            =   1170
            tabindex        =   38
            top             =   960
            width           =   795
         end
         begin vb.label label11 
            autosize        =   -1  'true
            caption         =   "invisible"
            height          =   195
            left            =   1170
            tabindex        =   35
            top             =   285
            width           =   570
         end
         begin vb.label label10 
            autosize        =   -1  'true
            caption         =   "paralizado"
            height          =   195
            left            =   225
            tabindex        =   33
            top             =   960
            width           =   735
         end
         begin vb.label label8 
            autosize        =   -1  'true
            caption         =   "veneno"
            height          =   180
            left            =   225
            tabindex        =   32
            top             =   300
            width           =   555
         end
      end
   end
   begin vb.commandbutton ok 
      caption         =   "ok"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   255
      left            =   120
      tabindex        =   1
      top             =   4320
      width           =   2055
   end
end
attribute vb_name = "frminterv"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.12.2
'copyright (c) 2002 m�rquez pablo ignacio
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

public sub aplicarintervalos()

'�?�?�?�?�?�?�?�?�?�?� intervalos del main loop �?�?�?�?�?�?�?�?�
sanaintervalosindescansar = val(txtsanaintervalosindescansar.text)
staminaintervalosindescansar = val(txtstaminaintervalosindescansar.text)
sanaintervalodescansar = val(txtsanaintervalodescansar.text)
staminaintervalodescansar = val(txtstaminaintervalodescansar.text)
intervalosed = val(txtintervalosed.text)
intervalohambre = val(txtintervalohambre.text)
intervaloveneno = val(txtintervaloveneno.text)
intervaloparalizado = val(txtintervaloparalizado.text)
intervaloinvisible = val(txtintervaloinvisible.text)
intervalofrio = val(txtintervalofrio.text)
intervalowavfx = val(txtintervalowavfx.text)
intervaloinvocacion = val(txtinvocacion.text)
intervaloparaconexion = val(txtintervaloparaconexion.text)

'///////////////// timers \\\\\\\\\\\\\\\\\\\

intervalouserpuedecastear = val(txtintervalolanzahechizo.text)
frmmain.npcataca.interval = val(txtnpcpuedeatacar.text)
frmmain.timer_ai.interval = val(txtai.text)
intervalouserpuedetrabajar = val(txttrabajo.text)
intervalouserpuedeatacar = val(txtpuedeatacar.text)
frmmain.tlluvia.interval = val(txtintervaloperdidastaminalluvia.text)



end sub

private sub command1_click()
on error resume next
call aplicarintervalos

end sub

private sub command2_click()

on error goto err

'intervalos
call writevar(inipath & "server.ini", "intervalos", "sanaintervalosindescansar", str(sanaintervalosindescansar))
call writevar(inipath & "server.ini", "intervalos", "staminaintervalosindescansar", str(staminaintervalosindescansar))
call writevar(inipath & "server.ini", "intervalos", "sanaintervalodescansar", str(sanaintervalodescansar))
call writevar(inipath & "server.ini", "intervalos", "staminaintervalodescansar", str(staminaintervalodescansar))
call writevar(inipath & "server.ini", "intervalos", "intervalosed", str(intervalosed))
call writevar(inipath & "server.ini", "intervalos", "intervalohambre", str(intervalohambre))
call writevar(inipath & "server.ini", "intervalos", "intervaloveneno", str(intervaloveneno))
call writevar(inipath & "server.ini", "intervalos", "intervaloparalizado", str(intervaloparalizado))
call writevar(inipath & "server.ini", "intervalos", "intervaloinvisible", str(intervaloinvisible))
call writevar(inipath & "server.ini", "intervalos", "intervalofrio", str(intervalofrio))
call writevar(inipath & "server.ini", "intervalos", "intervalowavfx", str(intervalowavfx))
call writevar(inipath & "server.ini", "intervalos", "intervaloinvocacion", str(intervaloinvocacion))
call writevar(inipath & "server.ini", "intervalos", "intervaloparaconexion", str(intervaloparaconexion))

'&&&&&&&&&&&&&&&&&&&&& timers &&&&&&&&&&&&&&&&&&&&&&&

call writevar(inipath & "server.ini", "intervalos", "intervalolanzahechizo", str(intervalouserpuedecastear))
call writevar(inipath & "server.ini", "intervalos", "intervalonpcai", frmmain.timer_ai.interval)
call writevar(inipath & "server.ini", "intervalos", "intervalonpcpuedeatacar", frmmain.npcataca.interval)
call writevar(inipath & "server.ini", "intervalos", "intervalotrabajo", str(intervalouserpuedetrabajar))
call writevar(inipath & "server.ini", "intervalos", "intervalouserpuedeatacar", str(intervalouserpuedeatacar))
call writevar(inipath & "server.ini", "intervalos", "intervaloperdidastaminalluvia", frmmain.tlluvia.interval)


msgbox "los intervalos se han guardado sin problemas"

exit sub
err:
    msgbox "error al intentar grabar los intervalos"
end sub

private sub ok_click()
me.visible = false
end sub

