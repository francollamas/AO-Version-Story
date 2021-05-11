attribute vb_name = "acciones"
'argentum online 0.11.20
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



sub accion(byval userindex as integer, byval map as integer, byval x as integer, byval y as integer)
on error resume next

'�posicion valida?
if inmapbounds(map, x, y) then
   
    dim foundchar as byte
    dim foundsomething as byte
    dim tempcharindex as integer
       
    '�es un obj?
    if mapdata(map, x, y).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x, y).objinfo.objindex
        
        select case objdata(mapdata(map, x, y).objinfo.objindex).objtype
            
            case objtype_puertas 'es una puerta
                call accionparapuerta(map, x, y, userindex)
            case objtype_carteles 'es un cartel
                call accionparacartel(map, x, y, userindex)
            case objtype_foros 'foro
                call accionparaforo(map, x, y, userindex)
            case objtype_le�a 'le�a
                if mapdata(map, x, y).objinfo.objindex = fogata_apag then
                    call accionpararamita(map, x, y, userindex)
                end if
            
        end select
    '>>>>>>>>>>>objetos que ocupam mas de un tile<<<<<<<<<<<<<
    elseif mapdata(map, x + 1, y).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x + 1, y).objinfo.objindex
        call senddata(toindex, userindex, 0, "sele" & objdata(mapdata(map, x + 1, y).objinfo.objindex).objtype & "," & objdata(mapdata(map, x + 1, y).objinfo.objindex).name & "," & "obj")
        select case objdata(mapdata(map, x + 1, y).objinfo.objindex).objtype
            
            case 6 'es una puerta
                call accionparapuerta(map, x + 1, y, userindex)
            
        end select
    elseif mapdata(map, x + 1, y + 1).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x + 1, y + 1).objinfo.objindex
        call senddata(toindex, userindex, 0, "sele" & objdata(mapdata(map, x + 1, y + 1).objinfo.objindex).objtype & "," & objdata(mapdata(map, x + 1, y + 1).objinfo.objindex).name & "," & "obj")
        select case objdata(mapdata(map, x + 1, y + 1).objinfo.objindex).objtype
            
            case 6 'es una puerta
                call accionparapuerta(map, x + 1, y + 1, userindex)
            
        end select
    elseif mapdata(map, x, y + 1).objinfo.objindex > 0 then
        userlist(userindex).flags.targetobj = mapdata(map, x, y + 1).objinfo.objindex
        call senddata(toindex, userindex, 0, "sele" & objdata(mapdata(map, x, y + 1).objinfo.objindex).objtype & "," & objdata(mapdata(map, x, y + 1).objinfo.objindex).name & "," & "obj")
        select case objdata(mapdata(map, x, y + 1).objinfo.objindex).objtype
            
            case 6 'es una puerta
                call accionparapuerta(map, x, y + 1, userindex)
            
        end select
        
    elseif mapdata(map, x, y).npcindex > 0 then
        if npclist(mapdata(map, x, y).npcindex).comercia = 1 then
              if distancia(npclist(userlist(userindex).flags.targetnpc).pos, userlist(userindex).pos) > 3 then
                  call senddata(toindex, userindex, 0, "||estas demasiado lejos del vendedor." & fonttype_info)
                  exit sub
              end if
              
        '[dng!]
        if npclist(userlist(userindex).flags.targetnpc).name = "sr" then
            if userlist(userindex).faccion.armadareal <> 1 then
                call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbwhite & "�" & "muestra tu bandera antes de comprar ropa del ej�rcito" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                exit sub
            end if
        end if
        
        if npclist(userlist(userindex).flags.targetnpc).name = "sc" then
            if userlist(userindex).faccion.fuerzascaos <> 1 then
                call senddata(topcarea, userindex, userlist(userindex).pos.map, "||" & vbred & "�" & "�vete de aqu�!" & "�" & str(npclist(userlist(userindex).flags.targetnpc).char.charindex))
                exit sub
            end if
        end if
        '[/dng!]
        
        'iniciamos la rutina pa' comerciar.
        call iniciarcomercionpc(userindex)
        end if
        
    else
        userlist(userindex).flags.targetnpc = 0
        userlist(userindex).flags.targetnpctipo = 0
        userlist(userindex).flags.targetuser = 0
        userlist(userindex).flags.targetobj = 0
        call senddata(toindex, userindex, 0, "||no ves nada interesante." & fonttype_info)
    end if
    
end if

end sub

sub accionpararamita(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next

dim suerte as byte
dim exito as byte
dim obj as obj
dim raise as integer

dim pos as worldpos
pos.map = map
pos.x = x
pos.y = y

if distancia(pos, userlist(userindex).pos) > 2 then
    call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
    exit sub
end if


if userlist(userindex).stats.userskills(supervivencia) > 1 and userlist(userindex).stats.userskills(supervivencia) < 6 then
            suerte = 3
elseif userlist(userindex).stats.userskills(supervivencia) >= 6 and userlist(userindex).stats.userskills(supervivencia) <= 10 then
            suerte = 2
elseif userlist(userindex).stats.userskills(supervivencia) >= 10 and userlist(userindex).stats.userskills(supervivencia) then
            suerte = 1
end if

exito = randomnumber(1, suerte)

if exito = 1 then
    obj.objindex = fogata
    obj.amount = 1
    
    call senddata(toindex, userindex, 0, "||has prendido la fogata." & fonttype_info)
    call senddata(topcarea, userindex, userlist(userindex).pos.map, "fo")
    
    call makeobj(tomap, 0, map, obj, map, x, y)
    
    
else
    call senddata(toindex, userindex, 0, "||no has podido hacer fuego." & fonttype_info)
end if

'sino tiene hambre o sed quizas suba el skill supervivencia
if userlist(userindex).flags.hambre = 0 and userlist(userindex).flags.sed = 0 then
    call subirskill(userindex, supervivencia)
end if

end sub

sub accionparaforo(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next

dim pos as worldpos
pos.map = map
pos.x = x
pos.y = y

if distancia(pos, userlist(userindex).pos) > 2 then
    call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
    exit sub
end if

'�hay mensajes?
dim f as string, tit as string, men as string, base as string, auxcad as string
f = app.path & "\foros\" & ucase$(objdata(mapdata(map, x, y).objinfo.objindex).foroid) & ".for"
if fileexist(f, vbnormal) then
    dim num as integer
    num = val(getvar(f, "info", "cantmsg"))
    base = left$(f, len(f) - 4)
    dim i as integer
    dim n as integer
    for i = 1 to num
        n = freefile
        f = base & i & ".for"
        open f for input shared as #n
        input #n, tit
        men = ""
        auxcad = ""
        do while not eof(n)
            input #n, auxcad
            men = men & vbcrlf & auxcad
        loop
        close #n
        call senddata(toindex, userindex, 0, "fmsg" & tit & chr(176) & men)
        
    next
end if
call senddata(toindex, userindex, 0, "mfor")
end sub


sub accionparapuerta(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next

dim miobj as obj
dim wp as worldpos

if not (distance(userlist(userindex).pos.x, userlist(userindex).pos.y, x, y) > 2) then
    if objdata(mapdata(map, x, y).objinfo.objindex).llave = 0 then
        if objdata(mapdata(map, x, y).objinfo.objindex).cerrada = 1 then
                'abre la puerta
                if objdata(mapdata(map, x, y).objinfo.objindex).llave = 0 then
                          
                     mapdata(map, x, y).objinfo.objindex = objdata(mapdata(map, x, y).objinfo.objindex).indexabierta
                                  
                     call makeobj(tomap, 0, map, mapdata(map, x, y).objinfo, map, x, y)
                     
                     'desbloquea
                     mapdata(map, x, y).blocked = 0
                     mapdata(map, x - 1, y).blocked = 0
                     
                     'bloquea todos los mapas
                     call bloquear(tomap, 0, map, map, x, y, 0)
                     call bloquear(tomap, 0, map, map, x - 1, y, 0)
                     
                       
                     'sonido
                     senddata topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_puerta
                    
                else
                     call senddata(toindex, userindex, 0, "||la puerta esta cerrada con llave." & fonttype_info)
                end if
        else
                'cierra puerta
                mapdata(map, x, y).objinfo.objindex = objdata(mapdata(map, x, y).objinfo.objindex).indexcerrada
                
                call makeobj(tomap, 0, map, mapdata(map, x, y).objinfo, map, x, y)
                
                
                mapdata(map, x, y).blocked = 1
                mapdata(map, x - 1, y).blocked = 1
                
                
                call bloquear(tomap, 0, map, map, x - 1, y, 1)
                call bloquear(tomap, 0, map, map, x, y, 1)
                
                senddata topcarea, userindex, userlist(userindex).pos.map, "tw" & snd_puerta
        end if
        
        userlist(userindex).flags.targetobj = mapdata(map, x, y).objinfo.objindex
    else
        call senddata(toindex, userindex, 0, "||la puerta esta cerrada con llave." & fonttype_info)
    end if
else
    call senddata(toindex, userindex, 0, "||estas demasiado lejos." & fonttype_info)
end if

end sub

sub accionparacartel(byval map as integer, byval x as integer, byval y as integer, byval userindex as integer)
on error resume next


dim miobj as obj

if objdata(mapdata(map, x, y).objinfo.objindex).objtype = 8 then
  
  if len(objdata(mapdata(map, x, y).objinfo.objindex).texto) > 0 then
       call senddata(toindex, userindex, 0, "mcar" & _
        objdata(mapdata(map, x, y).objinfo.objindex).texto & _
        chr(176) & objdata(mapdata(map, x, y).objinfo.objindex).grhsecundario)
  end if
  
end if

end sub


