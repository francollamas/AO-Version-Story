version 5.00
begin vb.form frmmain 
   backcolor       =   &h00c0c0c0&
   borderstyle     =   3  'fixed dialog
   caption         =   "argentum online"
   clientheight    =   1785
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
   scaleheight     =   1785
   scalewidth      =   5190
   startupposition =   2  'centerscreen
   windowstate     =   1  'minimized
   begin vb.checkbox superlog 
      caption         =   "log"
      height          =   255
      left            =   3120
      tabindex        =   9
      top             =   480
      width           =   615
   end
   begin vb.commandbutton cmddump 
      caption         =   "dump"
      height          =   255
      left            =   3720
      tabindex        =   8
      top             =   480
      width           =   1215
   end
   begin vb.timer fx 
      enabled         =   0   'false
      interval        =   4000
      left            =   1440
      top             =   540
   end
   begin vb.timer auditoria 
      enabled         =   0   'false
      interval        =   1000
      left            =   1440
      top             =   1020
   end
   begin vb.timer timer1 
      enabled         =   0   'false
      interval        =   3000
      left            =   945
      top             =   540
   end
   begin vb.timer cmdexec 
      enabled         =   0   'false
      interval        =   1
      left            =   960
      top             =   60
   end
   begin vb.timer gametimer 
      enabled         =   0   'false
      interval        =   40
      left            =   1440
      top             =   60
   end
   begin vb.timer tpiquetec 
      enabled         =   0   'false
      interval        =   6000
      left            =   480
      top             =   540
   end
   begin vb.timer tlluviaevent 
      enabled         =   0   'false
      interval        =   60000
      left            =   960
      top             =   1020
   end
   begin vb.timer tlluvia 
      enabled         =   0   'false
      interval        =   500
      left            =   0
      top             =   1035
   end
   begin vb.timer autosave 
      enabled         =   0   'false
      interval        =   60000
      left            =   480
      top             =   1020
   end
   begin vb.timer npcataca 
      enabled         =   0   'false
      interval        =   4000
      left            =   1920
      top             =   1020
   end
   begin vb.timer killlog 
      enabled         =   0   'false
      interval        =   60000
      left            =   1920
      top             =   60
   end
   begin vb.timer timer_ai 
      enabled         =   0   'false
      interval        =   100
      left            =   1935
      top             =   540
   end
   begin vb.frame frame1 
      caption         =   "broadcast"
      height          =   1095
      left            =   120
      tabindex        =   2
      top             =   600
      width           =   4935
      begin vb.commandbutton command2 
         caption         =   "broadcast consola"
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   255
         left            =   2520
         tabindex        =   6
         top             =   720
         width           =   2295
      end
      begin vb.commandbutton command1 
         caption         =   "broadcast clientes"
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   700
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   255
         left            =   120
         tabindex        =   5
         top             =   720
         width           =   2295
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
         index           =   0
         left            =   120
         tabindex        =   3
         top             =   240
         width           =   855
      end
   end
   begin vb.label escuch 
      caption         =   "label2"
      height          =   255
      left            =   3240
      tabindex        =   7
      top             =   240
      width           =   1335
   end
   begin vb.label cantusuarios 
      appearance      =   0  'flat
      autosize        =   -1  'true
      backcolor       =   &h00c0c0c0&
      backstyle       =   0  'transparent
      caption         =   "numero de usuarios:"
      beginproperty font 
         name            =   "tahoma"
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
      width           =   1725
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

public escuchadas as long

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
            call senddata(sendtarget.toindex, iuserindex, 0, "!!demasiado tiempo inactivo. has sido desconectado..")
            'mato los comercios seguros
            if userlist(iuserindex).comusu.destusu > 0 then
                if userlist(userlist(iuserindex).comusu.destusu).flags.userlogged then
                    if userlist(userlist(iuserindex).comusu.destusu).comusu.destusu = iuserindex then
                        call senddata(sendtarget.toindex, userlist(iuserindex).comusu.destusu, 0, "||comercio cancelado por el otro usuario" & fonttype_talk)
                        call fincomerciarusu(userlist(iuserindex).comusu.destusu)
                    end if
                end if
                call fincomerciarusu(iuserindex)
            end if
            call cerrar_usuario(iuserindex)
        end if
  end if
  
next iuserindex

end sub



private sub auditoria_timer()
on error goto errhand

call pasarsegundo 'sistema de desconexion de 10 segs

call actualizaestadisticasweb
call actualizastatses



exit sub

errhand:
call logerror("error en timer auditoria. err: " & err.description & " - " & err.number)
end sub

private sub autosave_timer()

on error goto errhandler
'fired every minute
static minutos as long
static minutoslatsclean as long
static minssocketreset as long
static minspjessave as long
static minutosnumuserscheck as long

dim i as integer
dim num as long

minsrunning = minsrunning + 1

if minsrunning = 60 then
    horas = horas + 1
    if horas = 24 then
        call savedaystats
        daystats.maxusuarios = 0
        daystats.segundos = 0
        daystats.promedio = 0
        
        horas = 0
        
    end if
    minsrunning = 0
end if

    
minutos = minutos + 1

'�?�?�?�?�?�?�?�?�?�?�
call modareas.areasoptimizacion
'�?�?�?�?�?�?�?�?�?�?�

'actualizamos el centinela
call modcentinela.pasarminutocentinela

#if usarquesocket = 1 then
' ok la cosa es asi, este cacho de codigo es para
' evitar los problemas de socket. a menos que estes
' seguro de lo que estas haciendo, te recomiendo
' que lo dejes tal cual est�.
' alejo.
minssocketreset = minssocketreset + 1
' cada 1 minutos hacer el checkeo
if minssocketreset >= 5 then
    minssocketreset = 0
    for i = 1 to maxusers
        if userlist(i).connid <> -1 and not userlist(i).flags.userlogged then
            if userlist(i).counters.idlecount > ((intervalocerrarconexion * 2) / 3) then
                call closesocket(i)
            end if
        end if
    next i
    'call reloadsokcet
    
    call logcriticevent("numusers: " & numusers & " wsapisock2usr: " & wsapisock2usr.count)
end if
#end if

minutosnumuserscheck = minutosnumuserscheck + 1

if minutosnumuserscheck >= 2 then
    minutosnumuserscheck = 0
    num = 0
    for i = 1 to maxusers
        if userlist(i).connid <> -1 and userlist(i).flags.userlogged then
            num = num + 1
        end if
    next i
    if num <> numusers then
        numusers = num
        'call senddata(sendtarget.toadmins, 0, 0, "servidor> error en numusers. contactar a algun programador." & fonttype_server)
        call logcriticevent("num <> numusers")
    end if
end if

if minutos = minutosws - 1 then
    call senddata(sendtarget.toall, 0, 0, "||worldsave en 1 minuto ..." & fonttype_veneno)
end if

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

call purgarpenas
call checkidleuser

'<<<<<-------- log the number of users online ------>>>
dim n as integer
n = freefile()
open app.path & "\logs\numusers.log" for output shared as n
print #n, numusers
close #n
'<<<<<-------- log the number of users online ------>>>

exit sub
errhandler:
    call logerror("error en timerautosave " & err.number & ": " & err.description)

end sub






private sub cmddump_click()
on error resume next

dim i as integer
for i = 1 to maxusers
    call logcriticevent(i & ") connid: " & userlist(i).connid & ". connidvalida: " & userlist(i).connidvalida & " name: " & userlist(i).name & " userlogged: " & userlist(i).flags.userlogged)
next i

call logcriticevent("lastuser: " & lastuser & " nextopenuser: " & nextopenuser)

end sub

private sub cmdexec_timer()
dim i as integer
static n as long

on error resume next ':(((

n = n + 1

for i = 1 to maxusers
    if userlist(i).connid <> -1 and userlist(i).connidvalida then
        if not userlist(i).commandsbuffer.isempty then
            call handledata(i, userlist(i).commandsbuffer.pop)
        end if
        if n >= 10 then
            if userlist(i).colasalida.count > 0 then ' and userlist(i).sockpuedoenviar then
    #if usarquesocket = 1 then
                call intentarenviardatosencolados(i)
    '#elseif usarquesocket = 0 then
    '            call wrchintentarenviardatosencolados(i)
    '#elseif usarquesocket = 2 then
    '            call servintentarenviardatosencolados(i)
    #elseif usarquesocket = 3 then
        'nada, el control deberia ocuparse de esto!!!
        'si la cola se llena, dispara un on close
    #end if
            end if
        end if
    end if
next i

if n >= 10 then
    n = 0
end if

exit sub
hayerror:

end sub

private sub command1_click()
call senddata(sendtarget.toall, 0, 0, "!!" & broadmsg.text & endc)
end sub

public sub initmain(byval f as byte)

if f = 1 then
    call mnusystray_click
else
    frmmain.show
end if

end sub

private sub command2_click()
call senddata(sendtarget.toall, 0, 0, "||servidor> " & broadmsg.text & fonttype_server)
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

#if usarquesocket = 1 then
call limpiawsapi(frmmain.hwnd)
#elseif usarquesocket = 0 then
socket1.cleanup
#elseif usarquesocket = 2 then
serv.detener
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

set sonidosmapas = nothing

end sub

private sub fx_timer()
on error goto hayerror

call sonidosmapas.reproducirsonidosdemapas

exit sub
hayerror:

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

on error goto hayerror

 '<<<<<< procesa eventos de los usuarios >>>>>>
 for iuserindex = 1 to maxusers
   'conexion activa?
   if userlist(iuserindex).connid <> -1 then
      '�user valido?

      if userlist(iuserindex).connidvalida and userlist(iuserindex).flags.userlogged then
         
         '[alejo-18-5]
         benviarstats = false
         benviarays = false
         
         userlist(iuserindex).numeropaquetespormilisec = 0

         
         call dotileevents(iuserindex, userlist(iuserindex).pos.map, userlist(iuserindex).pos.x, userlist(iuserindex).pos.y)
         
                
         if userlist(iuserindex).flags.paralizado = 1 then call efectoparalisisuser(iuserindex)
         if userlist(iuserindex).flags.ceguera = 1 or _
            userlist(iuserindex).flags.estupidez then call efectocegueestu(iuserindex)
         
          
         if userlist(iuserindex).flags.muerto = 0 then
               
               '[consejeros]
               if userlist(iuserindex).flags.desnudo and userlist(iuserindex).flags.privilegios = playertype.user then call efectofrio(iuserindex)
               if userlist(iuserindex).flags.meditando then call domeditar(iuserindex)
               if userlist(iuserindex).flags.envenenado = 1 and userlist(iuserindex).flags.privilegios = playertype.user then call efectoveneno(iuserindex, benviarstats)
               if userlist(iuserindex).flags.admininvisible <> 1 and userlist(iuserindex).flags.invisible = 1 then call efectoinvisibilidad(iuserindex)
               if userlist(iuserindex).flags.mimetizado = 1 then call efectomimetismo(iuserindex)
                
               call duracionpociones(iuserindex)
                
               call hambreysed(iuserindex, benviarays)
                
               if lloviendo then
                    if not intemperie(iuserindex) then
                        if not userlist(iuserindex).flags.descansar and (userlist(iuserindex).flags.hambre = 0 and userlist(iuserindex).flags.sed = 0) then
                        'no esta descansando
                            
                            call sanar(iuserindex, benviarstats, sanaintervalosindescansar)
                            if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ash" & userlist(iuserindex).stats.minhp): benviarstats = false
                            call recstamina(iuserindex, benviarstats, staminaintervalosindescansar)
                            if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ass" & userlist(iuserindex).stats.minsta): benviarstats = false
                            
                        elseif userlist(iuserindex).flags.descansar then
                        'esta descansando
                            
                            call sanar(iuserindex, benviarstats, sanaintervalodescansar)
                            if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ash" & userlist(iuserindex).stats.minhp): benviarstats = false
                            call recstamina(iuserindex, benviarstats, staminaintervalodescansar)
                            if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ass" & userlist(iuserindex).stats.minsta): benviarstats = false
                                 'termina de descansar automaticamente
                            if userlist(iuserindex).stats.maxhp = userlist(iuserindex).stats.minhp and _
                                userlist(iuserindex).stats.maxsta = userlist(iuserindex).stats.minsta then
                                    call senddata(sendtarget.toindex, iuserindex, 0, "dok")
                                    call senddata(sendtarget.toindex, iuserindex, 0, "||has terminado de descansar." & fonttype_info)
                                    userlist(iuserindex).flags.descansar = false
                            end if
                            
                        end if 'not userlist(userindex).flags.descansar and (userlist(userindex).flags.hambre = 0 and userlist(userindex).flags.sed = 0)
                    end if
               else
                    if not userlist(iuserindex).flags.descansar and (userlist(iuserindex).flags.hambre = 0 and userlist(iuserindex).flags.sed = 0) then
                    'no esta descansando
                        
                        call sanar(iuserindex, benviarstats, sanaintervalosindescansar)
                        if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ash" & userlist(iuserindex).stats.minhp): benviarstats = false
                        call recstamina(iuserindex, benviarstats, staminaintervalosindescansar)
                        if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ass" & userlist(iuserindex).stats.minsta): benviarstats = false
                        
                    elseif userlist(iuserindex).flags.descansar then
                    'esta descansando
                        
                        call sanar(iuserindex, benviarstats, sanaintervalodescansar)
                        if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ash" & userlist(iuserindex).stats.minhp): benviarstats = false
                        call recstamina(iuserindex, benviarstats, staminaintervalodescansar)
                        if benviarstats then call senddata(sendtarget.toindex, iuserindex, 0, "ass" & userlist(iuserindex).stats.minsta): benviarstats = false
                             'termina de descansar automaticamente
                        if userlist(iuserindex).stats.maxhp = userlist(iuserindex).stats.minhp and _
                            userlist(iuserindex).stats.maxsta = userlist(iuserindex).stats.minsta then
                                call senddata(sendtarget.toindex, iuserindex, 0, "dok")
                                call senddata(sendtarget.toindex, iuserindex, 0, "||has terminado de descansar." & fonttype_info)
                                userlist(iuserindex).flags.descansar = false
                        end if
                        
                    end if 'not userlist(userindex).flags.descansar and (userlist(userindex).flags.hambre = 0 and userlist(userindex).flags.sed = 0)
               end if
               
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

exit sub
hayerror:
logerror ("error en gametimer: " & err.description & " userindex = " & iuserindex)
'[/alejo]
  'doevents
end sub

private sub mnucerrar_click()


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
if not fileexist(app.path & "\logs\nokillwsapi.txt") then
    if fileexist(app.path & "\logs\wsapi.log", vbnormal) then kill app.path & "\logs\wsapi.log"
end if

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

on error resume next
dim npc as integer

for npc = 1 to lastnpc
    npclist(npc).canattack = 1
next npc

end sub

private sub timer_ai_timer()

on error goto errorhandler
dim npcindex as integer
dim x as integer
dim y as integer
dim useai as integer
dim mapa as integer
dim e_p as integer

'barrin 29/9/03
if not haciendobk and not enpausa then
    'update npcs
    for npcindex = 1 to lastnpc
        
        if npclist(npcindex).flags.npcactive then 'nos aseguramos que sea inteligente!
            e_p = espretoriano(npcindex)
            if e_p > 0 then
                if npclist(npcindex).flags.paralizado = 1 then call efectoparalisisnpc(npcindex)
                select case e_p
                    case 1  ''clerigo
                        call prcler_ai(npcindex)
                    case 2  ''mago
                        call prmago_ai(npcindex)
                    case 3  ''cazador
                        call prcaza_ai(npcindex)
                    case 4  ''rey
                        call prrey_ai(npcindex)
                    case 5  ''guerre
                        call prguer_ai(npcindex)
                end select
            else
                ''ia comun
                if npclist(npcindex).flags.paralizado = 1 then
                      call efectoparalisisnpc(npcindex)
                else
                     'usamos ai si hay algun user en el mapa
                     if npclist(npcindex).flags.inmovilizado = 1 then
                        call efectoparalisisnpc(npcindex)
                     end if
                     mapa = npclist(npcindex).pos.map
                     if mapa > 0 then
                          if mapinfo(mapa).numusers > 0 then
                                  if npclist(npcindex).movement <> tipoai.estatico then
                                        call npcai(npcindex)
                                  end if
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

on error resume next
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
call logerror("tlluvia " & err.number & ": " & err.description)
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
                call senddata(sendtarget.toall, 0, 0, "llu")
            end if
    elseif minutossinlluvia >= 1440 then
                lloviendo = true
                minutossinlluvia = 0
                call senddata(sendtarget.toall, 0, 0, "llu")
    end if
else
    minutoslloviendo = minutoslloviendo + 1
    if minutoslloviendo >= 5 then
            lloviendo = false
            call senddata(sendtarget.toall, 0, 0, "llu")
            minutoslloviendo = 0
    else
            if randomnumber(1, 100) <= 7 then
                lloviendo = false
                minutoslloviendo = 0
                call senddata(sendtarget.toall, 0, 0, "llu")
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
dim nuevaa as boolean
dim nuevol as boolean
dim gi as integer

segundos = segundos + 6

dim i as integer

for i = 1 to lastuser
    if userlist(i).flags.userlogged then
            
            if mapdata(userlist(i).pos.map, userlist(i).pos.x, userlist(i).pos.y).trigger = etrigger.antipiquete then
                    userlist(i).counters.piquetec = userlist(i).counters.piquetec + 1
                    call senddata(sendtarget.toindex, i, 0, "||estas obstruyendo la via publica, mu�vete o seras encarcelado!!!" & fonttype_info)
                    if userlist(i).counters.piquetec > 23 then
                            userlist(i).counters.piquetec = 0
                            call encarcelar(i, tiempo_carcel_piquete)
                    end if
            else
                    if userlist(i).counters.piquetec > 0 then userlist(i).counters.piquetec = 0
            end if

            'ustedes se preguntaran que hace esto aca?
            'bueno la respuesta es simple: el codigo de ao es una mierda y encontrar
            'todos los puntos en los cuales la alineacion puede cambiar es un dolor de
            'huevos, asi que lo controlo aca, cada 6 segundos, lo cual es razonable

            gi = userlist(i).guildindex
            if gi > 0 then
                nuevaa = false
                nuevol = false
                if not modguilds.m_validarpermanencia(i, true, nuevaa, nuevol) then
                    call senddata(sendtarget.toindex, i, 0, "||has sido expulsado del clan. �el clan ha sumado un punto de antifacci�n!" & fonttype_guild)
                end if
                if nuevaa then
                    call senddata(sendtarget.toguildmembers, gi, 0, "||�el clan ha pasado a tener alineaci�n neutral!" & fonttype_guild)
                    call logclanes("el clan cambio de alineacion!")
                end if
                if nuevol then
                    call senddata(sendtarget.toguildmembers, gi, 0, "||�el clan tiene un nuevo l�der!" & fonttype_guild)
                    call logclanes("el clan tiene nuevo lider!")
                end if
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
    call logerror("error en tpiquetec_timer " & err.number & ": " & err.description)
end sub





'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'''''''''''''''''uso del control tcpserv'''''''''''''''''''''''''''
'''''''''''''compilar con usarquesocket = 3''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''


#if usarquesocket = 3 then

private sub tcpserv_eror(byval numero as long, byval descripcion as string)
    call logerror("tcpserver socket error: " & numero & "/" & descripcion)
end sub

private sub tcpserv_nuevaconn(byval id as long)
on error goto errorhandlernc

    escuchadas = escuchadas + 1
    escuch.caption = escuchadas
    
    dim i as integer
    
    dim newindex as integer
    newindex = nextopenuser
    
    if newindex <= maxusers then
        'call logindex(newindex, "******> accept. connid: " & id)
        
        tcpserv.setdato id, newindex
        
        if ados.maxconexiones(tcpserv.getip(id)) then
            call ados.restarconexion(tcpserv.getip(id))
            call resetuserslot(newindex)
            exit sub
        end if

        if newindex > lastuser then lastuser = newindex

        userlist(newindex).connid = id
        userlist(newindex).ip = tcpserv.getip(id)
        userlist(newindex).connidvalida = true
        set userlist(newindex).commandsbuffer = new ccolaarray
        
        for i = 1 to banips.count
            if banips.item(i) = tcpserv.getip(id) then
                call resetuserslot(newindex)
                exit sub
            end if
        next i

    else
        call closesocket(newindex, true)
        logcriticevent ("newindex > maxusers. imposible alocatear sockets")
    end if

exit sub

errorhandlernc:
call logerror("tcpserver::nuevaconexion " & err.description)
end sub

private sub tcpserv_close(byval id as long, byval midato as long)
    on error goto eh
    '' no cierro yo el socket. el on_close lo cierra por mi.
    'call logindex(midato, "******> remote close. connid: " & id & " midato: " & midato)
    call closesocket(midato, false)
exit sub
eh:
    call logerror("ocurrio un error en el evento tcpserv_close. id/midato:" & id & "/" & midato)
end sub

private sub tcpserv_read(byval id as long, datos as variant, byval cantidad as long, byval midato as long)
dim t() as string
dim loopc as long
dim rd as string
on error goto errorh
if userlist(midato).connid <> userlist(midato).connid then
    call logerror("recibi un read de un usuario con connid alterada")
    exit sub
end if

rd = strconv(datos, vbunicode)

'call logindex(midato, "read. connid: " & id & " midato: " & midato & " dato: " & rd)

userlist(midato).rdbuffer = userlist(midato).rdbuffer & rd

t = split(userlist(midato).rdbuffer, endc)
if ubound(t) > 0 then
    userlist(midato).rdbuffer = t(ubound(t))
    
    for loopc = 0 to ubound(t) - 1
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        '%%% si esta opcion se activa soluciona %%%
        '%%% el problema del speedhack          %%%
        '%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if clientscommandsqueue = 1 then
            if t(loopc) <> "" then
                if not userlist(midato).commandsbuffer.push(t(loopc)) then
                    call logerror("cerramos por no encolar. userindex:" & midato)
                    call closesocket(midato)
                end if
            end if
        else ' no encolamos los comandos (muy viejo)
              if userlist(midato).connid <> -1 then
                call handledata(midato, t(loopc))
              else
                exit sub
              end if
        end if
    next loopc
end if
exit sub

errorh:
call logerror("error socket read: " & midato & " dato:" & rd & " userlogged: " & userlist(midato).flags.userlogged & " connid:" & userlist(midato).connid & " id parametro" & id & " error:" & err.description)

end sub

#end if
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''fin  uso del control tcpserv'''''''''''''''''''''''''
'''''''''''''compilar con usarquesocket = 3''''''''''''''''''''''''
'''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
