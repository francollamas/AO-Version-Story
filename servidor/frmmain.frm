version 5.00
object = "{33101c00-75c3-11cf-a8a0-444553540000}#1.0#0"; "cswsk32.ocx"
begin vb.form frmmain 
   backcolor       =   &h00c0c0c0&
   borderstyle     =   3  'fixed dialog
   caption         =   "argentum online"
   clientheight    =   1725
   clientleft      =   1950
   clienttop       =   1815
   clientwidth     =   5190
   controlbox      =   0   'false
   fillcolor       =   &h00c0c0c0&
   beginproperty font 
      name            =   "arial"
      size            =   8.25
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   forecolor       =   &h80000004&
   icon            =   "frmmain.frx":0000
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   palettemode     =   1  'usezorder
   scaleheight     =   1725
   scalewidth      =   5190
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   windowstate     =   1  'minimized
   begin socketwrenchctrl.socket socket2 
      index           =   0
      left            =   15
      top             =   495
      _version        =   65536
      _extentx        =   741
      _extenty        =   741
      _stockprops     =   0
      autoresolve     =   -1  'true
      backlog         =   1
      binary          =   0   'false
      blocking        =   0   'false
      broadcast       =   0   'false
      buffersize      =   0
      hostaddress     =   ""
      hostfile        =   ""
      hostname        =   ""
      inline          =   0   'false
      interval        =   0
      keepalive       =   0   'false
      library         =   ""
      linger          =   0
      localport       =   0
      localservice    =   ""
      protocol        =   0
      remoteport      =   0
      remoteservice   =   ""
      reuseaddress    =   0   'false
      route           =   -1  'true
      timeout         =   0
      type            =   1
      urgent          =   0   'false
   end
   begin socketwrenchctrl.socket socket1 
      left            =   30
      top             =   -60
      _version        =   65536
      _extentx        =   741
      _extenty        =   741
      _stockprops     =   0
      autoresolve     =   -1  'true
      backlog         =   1
      binary          =   0   'false
      blocking        =   0   'false
      broadcast       =   0   'false
      buffersize      =   2048
      hostaddress     =   ""
      hostfile        =   ""
      hostname        =   ""
      inline          =   0   'false
      interval        =   0
      keepalive       =   0   'false
      library         =   ""
      linger          =   0
      localport       =   0
      localservice    =   ""
      protocol        =   0
      remoteport      =   0
      remoteservice   =   ""
      reuseaddress    =   0   'false
      route           =   -1  'true
      timeout         =   0
      type            =   1
      urgent          =   0   'false
   end
   begin vb.timer ttraficstat 
      interval        =   6000
      left            =   570
      top             =   105
   end
   begin vb.timer timer1 
      interval        =   3000
      left            =   1425
      top             =   630
   end
   begin vb.timer cmdexec 
      interval        =   1
      left            =   1260
      top             =   90
   end
   begin vb.timer gametimer 
      interval        =   40
      left            =   1800
      top             =   60
   end
   begin vb.timer tpiquetec 
      interval        =   6000
      left            =   495
      top             =   510
   end
   begin vb.timer tlluviaevent 
      interval        =   60000
      left            =   2040
      top             =   720
   end
   begin vb.timer tlluvia 
      interval        =   500
      left            =   60
      top             =   1035
   end
   begin vb.timer autosave 
      enabled         =   0   'false
      interval        =   60000
      left            =   570
      top             =   1080
   end
   begin vb.frame frame1 
      caption         =   "broadcast"
      height          =   1095
      left            =   120
      tabindex        =   2
      top             =   600
      width           =   4935
      begin vb.timer auditoria 
         interval        =   1000
         left            =   3180
         top             =   90
      end
      begin vb.commandbutton command1 
         caption         =   "enviar"
         height          =   255
         left            =   120
         tabindex        =   5
         top             =   720
         width           =   4695
      end
      begin vb.textbox broadmsg 
         height          =   315
         left            =   1080
         tabindex        =   4
         top             =   240
         width           =   3735
      end
      begin vb.label label1 
         caption         =   "mensaje"
         height          =   255
         left            =   120
         tabindex        =   3
         top             =   240
         width           =   855
      end
   end
   begin vb.timer fx 
      interval        =   200
      left            =   2520
      top             =   60
   end
   begin vb.timer npcataca 
      interval        =   4000
      left            =   4440
      top             =   0
   end
   begin vb.timer killlog 
      interval        =   60000
      left            =   3465
      top             =   45
   end
   begin vb.timer timer_ai 
      interval        =   100
      left            =   3960
      top             =   60
   end
   begin vb.label cantusuarios 
      appearance      =   0  'flat
      autosize        =   -1  'true
      backcolor       =   &h00c0c0c0&
      backstyle       =   0  'transparent
      caption         =   "numero de usuarios:"
      beginproperty font 
         name            =   "ms serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000000&
      height          =   195
      left            =   120
      tabindex        =   1
      top             =   240
      width           =   1575
   end
   begin vb.label txstatus 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      forecolor       =   &h000000ff&
      height          =   210
      left            =   120
      tabindex        =   0
      top             =   5520
      width           =   45
   end
   begin vb.menu mnucontroles 
      caption         =   "argentum"
      begin vb.menu mnuservidor 
         caption         =   "configuracion"
      end
      begin vb.menu mnusystray 
         caption         =   "systray servidor"
      end
      begin vb.menu mnucerrar 
         caption         =   "cerrar servidor"
      end
   end
   begin vb.menu mnupopup 
      caption         =   "popupmenu"
      visible         =   0   'false
      begin vb.menu mnumostrar 
         caption         =   "&mostrar"
      end
      begin vb.menu mnusalir 
         caption         =   "&salir"
      end
   end
end
attribute vb_name = "frmmain"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.0.2
'copyright (c) 2002 m�rquez pablo ignacio
'
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'gnu general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
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

private type notifyicondata
    cbsize as long
    hwnd as long
    uid as long
    uflags as long
    ucallbackmessage as long
    hicon as long
    sztip as string * 64
end type
   
const nim_add = 0
const nim_modify = 1
const nim_delete = 2
const nif_message = 1
const nif_icon = 2
const nif_tip = 4

const wm_mousemove = &h200
const wm_lbuttondown = &h201
const wm_lbuttonup = &h202
const wm_lbuttondblclk = &h203
const wm_rbuttondown = &h204
const wm_rbuttonup = &h205
const wm_rbuttondblclk = &h206
const wm_mbuttondown = &h207
const wm_mbuttonup = &h208
const wm_mbuttondblclk = &h209

private declare function getwindowthreadprocessid lib "user32" (byval hwnd as long, lpdwprocessid as long) as long
private declare function setcapture lib "user32" (byval hwnd as long) as long
private declare function shell_notifyicona lib "shell32" (byval dwmessage as long, lpdata as notifyicondata) as integer

private function setnotifyicondata(hwnd as long, id as long, flags as long, callbackmessage as long, icon as long, tip as string) as notifyicondata
    dim nidtemp as notifyicondata

    nidtemp.cbsize = len(nidtemp)
    nidtemp.hwnd = hwnd
    nidtemp.uid = id
    nidtemp.uflags = flags
    nidtemp.ucallbackmessage = callbackmessage
    nidtemp.hicon = icon
    nidtemp.sztip = tip & chr$(0)

    setnotifyicondata = nidtemp
end function

sub checkidleuser()
dim iuserindex as integer

for iuserindex = 1 to maxusers
   
   'conexion activa? y es un usuario loggeado?
   if userlist(iuserindex).connid <> -1 and userlist(iuserindex).flags.userlogged then
        'actualiza el contador de inactividad
        userlist(iuserindex).counters.idlecount = userlist(iuserindex).counters.idlecount + 1
        if userlist(iuserindex).counters.idlecount >= idlelimit then
            call senddata(toindex, iuserindex, 0, "!!demasiado tiempo inactivo. has sido desconectado..")
            call cerrar_usuario(iuserindex)
        end if
  end if
  
next iuserindex

end sub



private sub auditoria_timer()
on error goto errhand

dim k as integer
for k = 1 to lastuser
    if userlist(k).connid <> -1 then
        daystats.segundos = daystats.segundos + 1
    end if
next k

call pasarsegundo

static andando as boolean
static contador as long
dim tmp as boolean

contador = contador + 1

if contador >= 10 then
    contador = 0
    tmp = estadisticasweb.estadisticasandando()
    
    if andando = false and tmp = true then
        call inicializaestadisticas
    end if
    
    andando = tmp
end if

exit sub

errhand:
call logerror("error en timer auditoria (sistema de desconexion de 10 segundos). err: " & err.description & " - " & err.number)
end sub

private sub autosave_timer()

on error goto errhandler
'fired every minute

static minutos as long
static minutoslatsclean as long

static minssocketreset as long

static minspjessave as long

minsrunning = minsrunning + 1

if minsrunning = 60 then
    horas = horas + 1
    if horas = 24 then
        call savedaystats
        daystats.maxusuarios = 0
        daystats.segundos = 0
        daystats.promedio = 0
        call dayelapsed
        'dias = dias + 1
        horas = 0
    end if
    minsrunning = 0
end if

dim i as integer
    
minutos = minutos + 1

'minssocketreset = minssocketreset + 1
'for debug purposes
'if minssocketreset > 1 then
'    minssocketreset = 0
'    for i = 1 to maxusers
'        if userlist(i).connid <> -1 and not userlist(i).flags.userlogged then call closesocket(i)
'    next i
'    call reloadsokcet
'end if
    
if minutos >= minutosws then
    call dobackup
    call aclon.vaciarcoleccion
    minutos = 0
end if

if minutoslatsclean >= 15 then
        minutoslatsclean = 0
        call respawnorigposnpcs 'respawn de los guardias en las pos originales
        call limpiarmundo
else
        minutoslatsclean = minutoslatsclean + 1
end if

'[consejeros]
'if minspjessave >= 30 then
'    minspjessave = 0
'    call guardarusuarios
'else
'    minspjessave = minspjessave + 1
'end if

call purgarpenas
call checkidleuser

'<<<<<-------- log the number of users online ------>>>
dim n as integer
n = freefile(1)
open app.path & "\logs\numusers.log" for output shared as n
print #n, numusers
close #n
'<<<<<-------- log the number of users online ------>>>

exit sub
errhandler:
    call logerror("error en timerautosave")

end sub






private sub cmdexec_timer()
dim i as integer

for i = 1 to maxusers
    if userlist(i).connid <> -1 then
        if not userlist(i).commandsbuffer.isempty then
            call handledata(i, userlist(i).commandsbuffer.pop)
        end if
    end if
next i

end sub

private sub command1_click()
call senddata(toall, 0, 0, "!!" & broadmsg.text & endc)
end sub

public sub initmain(byval f as byte)

if f = 1 then
    call mnusystray_click
else
    frmmain.show
end if

end sub




private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
on error resume next
   
   if not visible then
        select case x \ screen.twipsperpixelx
                
            case wm_lbuttondblclk
                windowstate = vbnormal
                visible = true
                dim hprocess as long
                getwindowthreadprocessid hwnd, hprocess
                appactivate hprocess
            case wm_rbuttonup
                hhook = setwindowshookex(wh_callwndproc, addressof apphook, app.hinstance, app.threadid)
                popupmenu mnupopup
                if hhook then unhookwindowshookex hhook: hhook = 0
        end select
   end if
   
end sub

private sub form_queryunload(cancel as integer, unloadmode as integer)
'cancel = 1
'me.hide
end sub

private sub form_resize()
'if windowstate = vbminimized then command2_click
end sub

private sub quitariconosystray()
on error resume next

'borramos el icono del systray
dim i as integer
dim nid as notifyicondata

nid = setnotifyicondata(frmmain.hwnd, vbnull, nif_message or nif_icon or nif_tip, vbnull, frmmain.icon, "")

i = shell_notifyicona(nim_delete, nid)
    

end sub

private sub form_unload(cancel as integer)
on error resume next

call quitariconosystray

#if usarapi then
call limpiawsapi
#else
socket1.cleanup
#end if

call descarganpcsdat


dim loopc as integer

for loopc = 1 to maxusers
    if userlist(loopc).connid <> -1 then call closesocket(loopc)
next

'log
dim n as integer
n = freefile
open app.path & "\logs\main.log" for append shared as #n
print #n, date & " " & time & " server cerrado."
close #n

end



end sub




private sub fx_timer()
dim mapindex as integer
dim n as integer
for mapindex = 1 to nummaps
    randomize
    if randomnumber(1, 150) < 12 then
        if mapinfo(mapindex).numusers > 0 then

                select case mapinfo(mapindex).terreno
                   'bosque
                   case bosque
                        n = randomnumber(1, 100)
                        select case mapinfo(mapindex).zona
                            case campo
                              if not lloviendo then
                                if n < 30 and n >= 15 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_ave)
                                elseif n < 30 and n < 15 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_ave2)
                                elseif n >= 30 and n <= 35 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_grillo)
                                elseif n >= 35 and n <= 40 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_grillo2)
                                elseif n >= 40 and n <= 45 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_ave3)
                                end if
                               end if
                            case ciudad
                               if not lloviendo then
                                if n < 30 and n >= 15 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_ave)
                                elseif n < 30 and n < 15 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_ave2)
                                elseif n >= 30 and n <= 35 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_grillo)
                                elseif n >= 35 and n <= 40 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_grillo2)
                                elseif n >= 40 and n <= 45 then
                                  call senddata(tomap, 0, mapindex, "tw" & snd_ave3)
                                end if
                               end if
                        end select

                end select

        end if
    end if
next

end sub

private sub gametimer_timer()
dim iuserindex as integer
dim benviarstats as boolean
dim benviarays as boolean
dim inpcindex as integer

static ltirarbasura as long
static lpermiteatacar as long
static lpermitecast as long
static lpermitetrabajar as long

'[alejo]
if lpermiteatacar < intervalouserpuedeatacar then
    lpermiteatacar = lpermiteatacar + 1
end if

if lpermitecast < intervalouserpuedecastear then
    lpermitecast = lpermitecast + 1
end if

if lpermitetrabajar < intervalouserpuedetrabajar then
     lpermitetrabajar = lpermitetrabajar + 1
end if
'[/alejo]


 '<<<<<< procesa eventos de los usuarios >>>>>>
 for iuserindex = 1 to maxusers
   'conexion activa?
   if userlist(iuserindex).connid <> -1 then
      '�user valido?
      if userlist(iuserindex).flags.userlogged then
         
         '[alejo-18-5]
         benviarstats = false
         benviarays = false
         
         userlist(iuserindex).numeropaquetespormilisec = 0

         '<<<<<<<<<<<< allow attack >>>>>>>>>>>>>
'         if lpermiteatacar < intervalouserpuedeatacar then
'                lpermiteatacar = lpermiteatacar + 1
'         else
         if not lpermiteatacar < intervalouserpuedeatacar then
                userlist(iuserindex).flags.puedeatacar = 1
'                lpermiteatacar = 0
         end if
         '<<<<<<<<<<<< allow attack >>>>>>>>>>>>>

         '<<<<<<<<<<<< allow cast spells >>>>>>>>>>>
'         if lpermitecast < intervalouserpuedecastear then
'              lpermitecast = lpermitecast + 1
'         else
         if not lpermitecast < intervalouserpuedecastear then
              userlist(iuserindex).flags.puedelanzarspell = 1
'              lpermitecast = 0
         end if
         '<<<<<<<<<<<< allow cast spells >>>>>>>>>>>

         '<<<<<<<<<<<< allow work >>>>>>>>>>>
'         if lpermitetrabajar < intervalouserpuedetrabajar then
'              lpermitetrabajar = lpermitetrabajar + 1
'         else
         if not lpermitetrabajar < intervalouserpuedetrabajar then
              userlist(iuserindex).flags.puedetrabajar = 1
'              lpermitetrabajar = 0
         end if
         '<<<<<<<<<<<< allow work >>>>>>>>>>>


         call dotileevents(iuserindex, userlist(iuserindex).pos.map, userlist(iuserindex).pos.x, userlist(iuserindex).pos.y)
         
                
         if userlist(iuserindex).flags.paralizado = 1 then call efectoparalisisuser(iuserindex)
         if userlist(iuserindex).flags.ceguera = 1 or _
            userlist(iuserindex).flags.estupidez then call efectocegueestu(iuserindex)
          
         if userlist(iuserindex).flags.muerto = 0 then
               
               '[consejeros]
               if userlist(iuserindex).flags.desnudo and userlist(iuserindex).flags.privilegios = 0 then call efectofrio(iuserindex)
               if userlist(iuserindex).flags.meditando then call domeditar(iuserindex)
               if userlist(iuserindex).flags.envenenado = 1 and userlist(iuserindex).flags.privilegios = 0 then call efectoveneno(iuserindex, benviarstats)
               if userlist(iuserindex).flags.admininvisible <> 1 and userlist(iuserindex).flags.invisible = 1 then call efectoinvisibilidad(iuserindex)
          
               call duracionpociones(iuserindex)
               call hambreysed(iuserindex, benviarays)

               if lloviendo then
                    if not intemperie(iuserindex) then
                                 if not userlist(iuserindex).flags.descansar and (userlist(iuserindex).flags.hambre = 0 and userlist(iuserindex).flags.sed = 0) then
                                 'no esta descansando
                                          call sanar(iuserindex, benviarstats, sanaintervalosindescansar)
                                          call recstamina(iuserindex, benviarstats, staminaintervalosindescansar)
                                 elseif userlist(iuserindex).flags.descansar then
                                 'esta descansando
                                          call sanar(iuserindex, benviarstats, sanaintervalodescansar)
                                          call recstamina(iuserindex, benviarstats, staminaintervalodescansar)
                                          'termina de descansar automaticamente
                                          if userlist(iuserindex).stats.maxhp = userlist(iuserindex).stats.minhp and _
                                             userlist(iuserindex).stats.maxsta = userlist(iuserindex).stats.minsta then
                                                    call senddata(toindex, iuserindex, 0, "dok")
                                                    call senddata(toindex, iuserindex, 0, "||has terminado de descansar." & fonttype_info)
                                                    userlist(iuserindex).flags.descansar = false
                                          end if
                                 end if 'not userlist(userindex).flags.descansar and (userlist(userindex).flags.hambre = 0 and userlist(userindex).flags.sed = 0)
                    end if
               else
                    if not userlist(iuserindex).flags.descansar and (userlist(iuserindex).flags.hambre = 0 and userlist(iuserindex).flags.sed = 0) then
                    'no esta descansando
                             call sanar(iuserindex, benviarstats, sanaintervalosindescansar)
                             call recstamina(iuserindex, benviarstats, staminaintervalosindescansar)
                    elseif userlist(iuserindex).flags.descansar then
                    'esta descansando
                             call sanar(iuserindex, benviarstats, sanaintervalodescansar)
                             call recstamina(iuserindex, benviarstats, staminaintervalodescansar)
                             'termina de descansar automaticamente
                             if userlist(iuserindex).stats.maxhp = userlist(iuserindex).stats.minhp and _
                                userlist(iuserindex).stats.maxsta = userlist(iuserindex).stats.minsta then
                                     call senddata(toindex, iuserindex, 0, "dok")
                                     call senddata(toindex, iuserindex, 0, "||has terminado de descansar." & fonttype_info)
                                     userlist(iuserindex).flags.descansar = false
                             end if
                    end if 'not userlist(userindex).flags.descansar and (userlist(userindex).flags.hambre = 0 and userlist(userindex).flags.sed = 0)
               end if

               if benviarstats then call senduserstatsbox(iuserindex)
               if benviarays then call enviarhambreysed(iuserindex)

               if userlist(iuserindex).nromacotas > 0 then call tiempoinvocacion(iuserindex)
       end if 'muerto
     else 'no esta logeado?
     'userlist(iuserindex).counters.idlecount = 0
     '[gonzalo]: deshabilitado para el nuevo sistema de tiraje
     'de dados :)
        userlist(iuserindex).counters.idlecount = userlist(iuserindex).counters.idlecount + 1
        if userlist(iuserindex).counters.idlecount > intervaloparaconexion then
              userlist(iuserindex).counters.idlecount = 0
              call closesocket(iuserindex)
        end if
     end if 'userlogged
        
   end if

   next iuserindex

'[alejo]
if not lpermiteatacar < intervalouserpuedeatacar then
    lpermiteatacar = 0
end if

if not lpermitecast < intervalouserpuedecastear then
    lpermitecast = 0
end if

if not lpermitetrabajar < intervalouserpuedetrabajar then
     lpermitetrabajar = 0
end if

'[/alejo]
  'doevents
end sub

private sub mnucerrar_click()

call saveguildsdb

if msgbox("��atencion!! si cierra el servidor puede provocar la perdida de datos. �desea hacerlo de todas maneras?", vbyesno) = vbyes then
    dim f
    for each f in forms
        unload f
    next
end if

end sub

private sub mnusalir_click()
    call mnucerrar_click
end sub

public sub mnumostrar_click()
on error resume next
    windowstate = vbnormal
    form_mousemove 0, 0, 7725, 0
end sub

private sub killlog_timer()
on error resume next

if fileexist(app.path & "\logs\connect.log", vbnormal) then kill app.path & "\logs\connect.log"
if fileexist(app.path & "\logs\haciendo.log", vbnormal) then kill app.path & "\logs\haciendo.log"
if fileexist(app.path & "\logs\stats.log", vbnormal) then kill app.path & "\logs\stats.log"
if fileexist(app.path & "\logs\asesinatos.log", vbnormal) then kill app.path & "\logs\asesinatos.log"
if fileexist(app.path & "\logs\hackattemps.log", vbnormal) then kill app.path & "\logs\hackattemps.log"
if fileexist(app.path & "\logs\wsapi.log", vbnormal) then kill app.path & "\logs\wsapi.log"

end sub

private sub mnuservidor_click()
frmservidor.visible = true
end sub

private sub mnusystray_click()

dim i as integer
dim s as string
dim nid as notifyicondata

s = "argentum-online"
nid = setnotifyicondata(frmmain.hwnd, vbnull, nif_message or nif_icon or nif_tip, wm_mousemove, frmmain.icon, s)
i = shell_notifyicona(nim_add, nid)
    
if windowstate <> vbminimized then windowstate = vbminimized
visible = false

end sub






private sub npcataca_timer()

dim npc as integer

for npc = 1 to lastnpc
    npclist(npc).canattack = 1
next npc


end sub




private sub socket1_accept(socketid as integer)
#if not (usarapi = 1) then

'=========================================================
'uso del control socket wrench
'=============================

if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "pedido de conexion socketid:" & socketid & vbcrlf

on error resume next
    
    dim newindex as integer
    
    
    if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "nextopenuser" & vbcrlf
    
    newindex = nextopenuser ' nuevo indice
    if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "userindex asignado " & newindex & vbcrlf
    
    if newindex <= maxusers then
            if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "cargando socket " & newindex & vbcrlf
            
            unload socket2(newindex)
            load socket2(newindex)
            
            socket2(newindex).addressfamily = af_inet
            socket2(newindex).protocol = ipproto_ip
            socket2(newindex).sockettype = sock_stream
            socket2(newindex).binary = false
            socket2(newindex).buffersize = socket_buffer_size
            socket2(newindex).blocking = false
            socket2(newindex).linger = 1
            
            socket2(newindex).accept = socketid
            
            
            if ados.maxconexiones(socket2(newindex).peeraddress) then
            
                userlist(newindex).connid = -1
                if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "user slot reseteado " & newindex & vbcrlf
            
               
                
                if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "socket unloaded" & newindex & vbcrlf
                
                'call logcriticevent(socket2(newindex).peeraddress & " intento crear mas de 3 conexiones.")
                call ados.restarconexion(socket2(newindex).peeraddress)
                'socket2(newindex).disconnect
                unload frmmain.socket2(newindex)
                
                exit sub
            end if
            
            userlist(newindex).connid = socketid
            userlist(newindex).ip = socket2(newindex).peeraddress
            
            if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & socket2(newindex).peeraddress & " logged." & vbcrlf
    else
        call logcriticevent("no acepte conexion porque no tenia slots")
    end if
    
exit sub

#end if
end sub


private sub socket1_blocking(status as integer, cancel as integer)
cancel = true
end sub

private sub socket1_lasterror(errorcode as integer, errorstring as string, response as integer)
' solo para depurar
'call logerror("socket1:" & errorstring)

if debugsocket then frmdebugsocket.text2.text = frmdebugsocket.text2.text & time & " " & errorstring & vbcrlf

frmdebugsocket.label3.caption = socket1.state
end sub

private sub socket2_blocking(index as integer, status as integer, cancel as integer)
'cancel = true
end sub

private sub socket2_connect(index as integer)
'if debugsocket then frmdebugsocket.text1.text = frmdebugsocket.text1.text & "conectado" & vbcrlf
set userlist(index).commandsbuffer = new ccolaarray
end sub

private sub socket2_disconnect(index as integer)
    if userlist(index).flags.userlogged and _
        userlist(index).counters.saliendo = false then
        call cerrar_usuario(index)
    else
        call closesocket(index)
    end if
end sub

'private sub socket2_lasterror(index as integer, errorcode as integer, errorstring as string, response as integer)
''24004   wsaeintr    blocking function was canceled
''24009   wsaebadf    invalid socket descriptor passed to function
''24013   wsaeacces   access denied
''24014   wsaefault   invalid address passed to function
''24022   wsaeinval   invalid socket function call
''24024   wsaemfile   no socket descriptors are available
''24035   wsaewouldblock  socket would block on this operation
''24036   wsaeinprogress  blocking function in progress
''24037   wsaealready function being canceled has already completed
''24038   wsaenotsock invalid socket descriptor passed to function
''24039   wsaedestaddrreq destination address is required
''24040   wsaemsgsize datagram was too large to fit in specified buffer
''24041   wsaeprototype   specified protocol is the wrong type for this socket
''24042   wsaenoprotoopt  socket option is unknown or unsupported
''24043   wsaeprotonosupport  specified protocol is not supported
''24044   wsaesocktnosupport  specified socket type is not supported in this address family
''24045   wsaeopnotsupp   socket operation is not supported
''24046   wsaepfnosupport specified protocol family is not supported
''24047   wsaeafnosupport specified address family is not supported by this protocol
''24048   wsaeaddrinuse   specified address is already in use
''24049   wsaeaddrnotavail    specified address is not available
''24050   wsaenetdown network subsystem has failed
''24051   wsaenetunreach  network cannot be reached from this host
''24052   wsaenetreset    network dropped connection on reset
''24053   wsaeconnaborted connection was aborted due to timeout or other failure
''24054   wsaeconnreset   connection was reset by remote network
''24055   wsaenobufs  no buffer space is available
''24056   wsaeisconn  socket is already connected
''24057   wsaenotconn socket is not connected
''24058   wsaeshutdown    socket connection has been shut down
''24060   wsaetimedout    operation timed out before completion
''24061   wsaeconnrefused connection refused by remote network
''24064   wsaehostdown    remote host is down
''24065   wsaehostunreach remote host is unreachable
''24091   wsasysnotready  network subsystem is not ready for communication
''24092   wsavernotsupported  requested version is not available
''24093   wsanotinitialized   windows sockets library not initialized
''25001   wsahost_not_found   authoritative answer host not found
''25002   wsatry_again    non-authoritative answer host not found
''25003   wsano_recovery  non-recoverable error
''25004   wsano_data  no data record of requested type
''response = socket_errignore
'if errorcode = 24053 then call closesocket(index)
'end sub

private sub socket2_read(index as integer, datalength as integer, isurgent as integer)

#if not (usarapi = 1) then

on error goto errorhandler

'*********************************************
'separamos las lineas con endc y las enviamos a handledata()
'*********************************************
dim loopc as integer
dim rd as string
dim rbuffer(1 to command_buffer_size) as string
dim cr as integer
dim tchar as string
dim schar as integer
dim echar as integer
dim aux$
dim origcad as string

dim lenrd as long

'<<<<<<<<<<<<<<<<<< evitamos dos >>>>>>>>>>>>>>>>>>>>>>>>>>>
'call addtovar(userlist(index).numeropaquetespormilisec, 1, 1000)
'
'if userlist(index).numeropaquetespormilisec > 700 then
'   'userlist(index).flags.administrativeban = 1
'   call logcriticalhackattemp(userlist(index).name & " " & frmmain.socket2(index).peeraddress & " alcanzo el max paquetes por iteracion.")
'   call senddata(toindex, index, 0, "errse ha perdido la conexion, por favor vuelva a conectarse.")
'   call closesocket(index)
'   exit sub
'end if

call socket2(index).read(rd, datalength)

origcad = rd
lenrd = len(rd)

'call addtovar(userlist(index).bytestransmitidosuser, lenb(rd), 100000)

'[��bucle infinito!!]'
if lenrd = 0 then
    userlist(index).anticuelgue = userlist(index).anticuelgue + 1
    if userlist(index).anticuelgue >= 150 then
        userlist(index).anticuelgue = 0
        call logerror("!!!! detectado bucle infinito de eventos socket2_read. cerrando indice " & index)
        socket2(index).disconnect
        call closesocket(index)
        exit sub
    end if
else
    userlist(index).anticuelgue = 0
end if
'[��bucle infinito!!]'

'verificamos por una comando roto y le agregamos el resto
if userlist(index).rdbuffer <> "" then
    rd = userlist(index).rdbuffer & rd
    userlist(index).rdbuffer = ""
end if

'verifica por mas de una linea
schar = 1
for loopc = 1 to lenrd

    tchar = mid$(rd, loopc, 1)

    if tchar = endc then
        cr = cr + 1
        echar = loopc - schar
        rbuffer(cr) = mid$(rd, schar, echar)
        schar = loopc + 1
    end if
        
next loopc

'verifica una linea rota y guarda
if len(rd) - (schar - 1) <> 0 then
    userlist(index).rdbuffer = mid$(rd, schar, len(rd))
end if

'enviamos el buffer al manejador
for loopc = 1 to cr
    
    '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    '%%% si esta opcion se activa soluciona %%%
    '%%% el problema del speedhack          %%%
    '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if clientscommandsqueue = 1 then
        if rbuffer(loopc) <> "" then if not userlist(index).commandsbuffer.push(rbuffer(loopc)) then call cerrar_usuario(index)
    
    else ' sh tiebe efecto
          if userlist(index).connid <> -1 then
            call handledata(index, rbuffer(loopc))
          else
            exit sub
          end if
    end if
        
next loopc

exit sub


errorhandler:
    call logerror("error en socket read." & err.description & " numero paquetes:" & userlist(index).numeropaquetespormilisec & " . rdata:" & origcad)

#end if
end sub



private sub timer_ai_timer()

on error goto errorhandler

dim npcindex as integer
dim x as integer
dim y as integer
dim useai as integer
dim mapa as integer

if not haciendobk then
    'update npcs
    for npcindex = 1 to lastnpc
        
        if npclist(npcindex).flags.npcactive then 'nos aseguramos que sea inteligente!
           if npclist(npcindex).flags.paralizado = 1 then
                 call efectoparalisisnpc(npcindex)
           else
                'usamos ai si hay algun user en el mapa
                mapa = npclist(npcindex).pos.map
                if mapa > 0 then
                     if mapinfo(mapa).numusers > 0 then
                             if npclist(npcindex).movement <> estatico then
                                   call npcai(npcindex)
                             end if
                     end if
                end if
                
           end if
                   
        end if
    
    next npcindex

end if


exit sub

errorhandler:
 call logerror("error en timer_ai_timer " & npclist(npcindex).name & " mapa:" & npclist(npcindex).pos.map)
 call muerenpc(npcindex, 0)

end sub

private sub timer1_timer()

dim i as integer

for i = 1 to maxusers
    if userlist(i).flags.userlogged then _
        if userlist(i).flags.oculto = 1 then call dopermaneceroculto(i)
next i

end sub

private sub tlluvia_timer()
on error goto errhandler

dim icount as integer

if lloviendo then
   for icount = 1 to lastuser
    call efectolluvia(icount)
   next icount
end if

exit sub
errhandler:
call logerror("tlluvia")
end sub

private sub tlluviaevent_timer()

on error goto errorhandler

static minutoslloviendo as long
static minutossinlluvia as long

if not lloviendo then
    minutossinlluvia = minutossinlluvia + 1
    if minutossinlluvia >= 15 and minutossinlluvia < 1440 then
            if randomnumber(1, 100) <= 10 then
                lloviendo = true
                minutossinlluvia = 0
                call senddata(toall, 0, 0, "llu")
            end if
    elseif minutossinlluvia >= 1440 then
                lloviendo = true
                minutossinlluvia = 0
                call senddata(toall, 0, 0, "llu")
    end if
else
    minutoslloviendo = minutoslloviendo + 1
    if minutoslloviendo >= 5 then
            lloviendo = false
            call senddata(toall, 0, 0, "llu")
            minutoslloviendo = 0
    else
            if randomnumber(1, 100) <= 7 then
                lloviendo = false
                minutoslloviendo = 0
                call senddata(toall, 0, 0, "llu")
            end if
    end if
end if


exit sub
errorhandler:
call logerror("error tlluviatimer")



end sub


private sub tpiquetec_timer()
on error goto errhandler

static segundos as integer

segundos = segundos + 6

dim i as integer

for i = 1 to lastuser
    if userlist(i).flags.userlogged then
            
            if mapdata(userlist(i).pos.map, userlist(i).pos.x, userlist(i).pos.y).trigger = 5 then
                    userlist(i).counters.piquetec = userlist(i).counters.piquetec + 1
                    call senddata(toindex, i, 0, "||estas obstruyendo la via publica, muevete o seras encarcelado!!!" & fonttype_info)
                    if userlist(i).counters.piquetec > 23 then
                            userlist(i).counters.piquetec = 0
                            call encarcelar(i, 3)
                    end if
            else
                    if userlist(i).counters.piquetec > 0 then userlist(i).counters.piquetec = 0
            end if
            
            if segundos >= 18 then
'                dim nfile as integer
'                nfile = freefile ' obtenemos un canal
'                open app.path & "\logs\maxpasos.log" for append shared as #nfile
'                print #nfile, userlist(i).counters.pasos
'                close #nfile
                if segundos >= 18 then userlist(i).counters.pasos = 0
            end if
            
    end if
next i

if segundos >= 18 then segundos = 0
   
exit sub

errhandler:
    call logerror("error en tpiquetec_timer")
end sub


private sub ttraficstat_timer()

'dim i as integer
'
'if frmtrafic.visible then frmtrafic.lsttrafico.clear
'
'for i = 1 to lastuser
'    if userlist(i).flags.userlogged then
'        if frmtrafic.visible then
'            frmtrafic.lsttrafico.additem userlist(i).name & " " & userlist(i).bytestransmitidosuser + userlist(i).bytestransmitidossvr & " bytes per second"
'        end if
'        userlist(i).bytestransmitidosuser = 0
'        userlist(i).bytestransmitidossvr = 0
'    end if
'next i

end sub

private sub userslst_click()

end sub
