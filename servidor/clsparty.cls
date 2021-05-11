version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsparty"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
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




'clase party
'por el oso (ositear@yahoo.com.ar)
'define los metodos de control de la entidad party.
'las reglas del negocio de la parties se definen el el mdparty.bas

option explicit

private p_members(1 to party_maxmembers) as tpartymember
'miembros

private p_exptotal as long
'estadistica :d

private p_fundador as integer
'el creador

private p_cantmiembros as integer
'cantidad de miembros

'datos en los pjs: | indexparty(indice en p_members), partyleader(userindex del lider) |

'constructor de clase
public sub class_initialize()
    p_exptotal = 0
    p_cantmiembros = 0
end sub

'destructor de clase
public sub class_terminate()
end sub


public function miexperiencia(byval userindex as integer) as long
'me dice cuanta experiencia tengo colectada ya en la party
dim i as integer
i = 0

while i <= party_maxmembers and p_members(i).userindex <> userindex
    i = i + 1
wend
 
if i <= party_maxmembers then
    miexperiencia = p_members(i).experiencia
else        'esto no deberia pasar :p
    miexperiencia = -1
end if

end function

public sub obtenerexito(byval expganada as long, byval mapa as integer, x as integer, y as integer)
'se produjo un evento que da experiencia en la wp referenciada
dim i as integer
dim ui as integer
dim exppercapita as double

p_exptotal = p_exptotal + expganada

exppercapita = clng(expganada / p_cantmiembros)

for i = 1 to party_maxmembers
    ui = p_members(i).userindex
    if ui > 0 then
        if mapa = userlist(ui).pos.map and userlist(ui).flags.muerto = 0 then
            if distance(userlist(ui).pos.x, userlist(ui).pos.y, x, y) <= party_maxdistancia then
                p_members(i).experiencia = p_members(i).experiencia + exppercapita
                if p_members(i).experiencia < 0 then
                    p_members(i).experiencia = 0
                end if
                if party_experienciaporgolpe then
                    call addtovar(userlist(ui).stats.exp, exppercapita, maxexp)
                    call checkuserlevel(ui)
                    call senduserstatsbox(ui)
                end if
            end if
        end if
    end if
next i

end sub

public sub mandarmensajeaconsola(byval texto as string, byval sender as string)
'feo feo, muy feo acceder a senddata desde aca, pero bueeeeeeeeeee...
dim i as integer

for i = 1 to party_maxmembers
    if p_members(i).userindex > 0 then
        call senddata(toindex, p_members(i).userindex, 0, "|| [" & sender & "] " & texto & fonttype_party)
    end if
next i

end sub

public function espartyleader(byval userindex as integer) as boolean
    espartyleader = (userindex = p_fundador)
end function

public function nuevomiembro(byval userindex as integer) as boolean
dim i as integer
i = 1
while i <= party_maxmembers and p_members(i).userindex > 0
    i = i + 1
wend

if i <= party_maxmembers then
    p_members(i).experiencia = 0
    p_members(i).userindex = userindex
    nuevomiembro = true
    p_cantmiembros = p_cantmiembros + 1
else
    nuevomiembro = false
end if

end function

public function salemiembro(byval userindex as integer) as boolean
'el valor de retorno representa si se disuelve la party
dim i as integer
dim j as integer
i = 1
salemiembro = false
while i <= party_maxmembers and p_members(i).userindex <> userindex
    i = i + 1
wend

if i = 1 then
    'sale el founder, la party se disuelve
    salemiembro = true
    call mandarmensajeaconsola("el lider disuelve la party.", "servidor")
    for j = party_maxmembers to 1 step -1
        if p_members(j).userindex > 0 then
            call senddata(toindex, p_members(j).userindex, 0, "|| abandonas la party liderada por " & userlist(p_members(1).userindex).name & fonttype_party)
    
            call senddata(toindex, p_members(j).userindex, 0, "|| durante la misma has conseguido " & p_members(j).experiencia & " puntos de experiencia!" & fonttype_party)
    
            if not party_experienciaporgolpe then
                call addtovar(userlist(p_members(j).userindex).stats.exp, p_members(j).experiencia, maxexp)
                call checkuserlevel(p_members(j).userindex)
                call senduserstatsbox(p_members(j).userindex)
            end if
            call mandarmensajeaconsola(userlist(p_members(j).userindex).name & " abandona la party." & fonttype_party, "servidor")
            userlist(p_members(j).userindex).partyindex = 0
            p_cantmiembros = p_cantmiembros - 1
            p_members(j).userindex = 0
            p_members(j).experiencia = 0
        end if
    next j
else
    if i <= party_maxmembers then
        if not party_experienciaporgolpe then
            call addtovar(userlist(p_members(i).userindex).stats.exp, p_members(i).experiencia, maxexp)
            call checkuserlevel(p_members(i).userindex)
            call senduserstatsbox(p_members(i).userindex)
        end if
        call mandarmensajeaconsola(userlist(p_members(i).userindex).name & " abandona la party." & fonttype_party, "servidor")
        call senddata(toindex, p_members(i).userindex, 0, "|| durante la misma has conseguido " & p_members(i).experiencia & " puntos de experiencia!" & fonttype_party)
        p_cantmiembros = p_cantmiembros - 1
        p_members(i).userindex = 0
        p_members(i).experiencia = 0
        compactmemberlist
    end if
end if

end function

public function hacerleader(byval userindex as integer) as boolean
dim i as integer
dim oldleader as integer
dim oldexp as long
dim userindexindex as integer

userindexindex = 0
hacerleader = true

for i = 1 to party_maxmembers
    if p_members(i).userindex > 0 then
        if p_members(i).userindex = userindex then
            userindexindex = i
            exit for
        end if
        'chequeo la dif entre levels
        if abs(userlist(userindex).stats.elv - userlist(p_members(i).userindex).stats.elv) > maxpartydeltalevel then
            call senddata(toindex, p_members(i).userindex, 0, "|| no se puede hacer l�der a " & userlist(userindex).name & " pues la diferencia entre niveles de los miembros de la party ser�a mayor a " & maxpartydeltalevel & fonttype_party)
            hacerleader = false
        end if
    end if
next i

if not hacerleader then exit function

if userindexindex = 0 then
    'catastrofe! esto no deberia pasar nunca! pero como es ao.... :p
    call logerror("inconsistencia de parties")
    call senddata(toadmins, 0, 0, "|| inconsistencia de parties en hacerleader (uii = 0), avise a un programador esto es una catastrofe!!!!")
    hacerleader = false
    exit function
end if


'aca esta todo bien y doy vuelta las collections
oldleader = p_members(1).userindex
oldexp = p_members(1).experiencia

p_members(1).userindex = p_members(userindexindex).userindex     'que en realdiad es el userindex, pero no quiero inconsistencias moviendo experiencias
p_members(1).experiencia = p_members(userindexindex).experiencia

p_members(i).userindex = oldleader
p_members(i).experiencia = oldexp

p_fundador = p_members(1).userindex

'no need to compact
end function


public sub obtenermiembrosonline(byref memberlist as string)
'esta funcion viola un poco la correcta forma de hacer la clase
'pero bue...
dim i as integer
memberlist = "nombre(exp): "
for i = 1 to party_maxmembers
    if p_members(i).userindex > 0 then
        memberlist = memberlist & " - " & userlist(p_members(i).userindex).name & " (" & p_members(i).experiencia & ")"
    end if
next i

memberlist = memberlist & ". experiencia total: " & p_exptotal

end sub


public function puedeentrar(byval userindex as integer, byref razon as string) as boolean
'define las reglas del juego para dejar entrar a miembros
dim esarmada as boolean
dim escaos as boolean
dim mylevel as integer
dim i as integer
dim rv as boolean
dim ui as integer

rv = true
esarmada = (userlist(userindex).faccion.armadareal = 1)
escaos = (userlist(userindex).faccion.fuerzascaos = 1)
mylevel = userlist(userindex).stats.elv

rv = distancia(userlist(p_members(1).userindex).pos, userlist(userindex).pos) <= maxdistanciaingresoparty
if rv then
    rv = (p_members(party_maxmembers).userindex = 0)
    if rv then
        for i = 1 to party_maxmembers
            ui = p_members(i).userindex
            'pongo los casos que evitarian que pueda entrar
            'aspirante armada en party crimi
            if ui > 0 then
                if esarmada and criminal(ui) then
                    razon = "los miembros de la armada no entran a una party con criminales."
                    rv = false
                end if
                'aspirante caos en party ciuda
                if escaos and not criminal(ui) then
                    razon = "los miembros de la legi�n oscura no entran a una party con ciudadanos."
                    rv = false
                end if
                'aspirante crimi en party armada
                if userlist(ui).faccion.armadareal = 1 and criminal(userindex) then
                    razon = "los criminales no entran a partys con miembros de la armada real."
                    rv = false
                end if
                'aspirante ciuda en party caos
                if userlist(ui).faccion.fuerzascaos = 1 and not criminal(userindex) then
                    razon = "los miembros de la legi�n oscura no entran a una party con ciudadanos."
                    rv = false
                end if
                'diferencia entre niveles
                if abs(userlist(ui).stats.elv - userlist(userindex).stats.elv) > maxpartydeltalevel then
                    razon = "la diferencia con " & userlist(ui).name & " es mayor a " & maxpartydeltalevel & " niveles."
                    rv = false
                end if
            
                if not rv then exit for 'violate una programacion estructurada
            end if
        next i
    else
        razon = "la mayor cantidad de miembros es " & party_maxmembers
    end if
else
    razon = "te encuentras muy lejos del fundador."
end if

puedeentrar = rv

end function


public sub flushexperiencia()
'esta funcion se invoca frente a cerradas del servidor. flushea la experiencia
'acumulada a los usuarios.

dim i as integer
if not party_experienciaporgolpe then   'esto sirve solo cuando acumulamos la experiencia!
    for i = 1 to party_maxmembers
        if p_members(i).userindex > 0 then
            if p_members(i).experiencia > 0 then
                call addtovar(userlist(p_members(i).userindex).stats.exp, p_members(i).experiencia, maxexp)
                call checkuserlevel(p_members(i).userindex)
            else
                if abs(userlist(p_members(i).userindex).stats.exp) > abs(p_members(i).experiencia) then
                    userlist(p_members(i).userindex).stats.exp = userlist(p_members(i).userindex).stats.exp + p_members(i).experiencia
                else
                    userlist(p_members(i).userindex).stats.exp = 0
                end if
            end if
            p_members(i).experiencia = 0
            call senduserstatsbox(p_members(i).userindex)
        end if
    next i
end if

end sub




private sub compactmemberlist()
dim i as integer
dim freeindex as integer
dim tplayer as tpartymember
i = 1
while i <= party_maxmembers
    if p_members(i).userindex = 0 and freeindex = 0 then
        freeindex = i
    elseif p_members(i).userindex > 0 and freeindex > 0 then
        p_members(freeindex).experiencia = p_members(i).experiencia
        p_members(freeindex).userindex = p_members(i).userindex
        p_members(i).userindex = 0
        p_members(i).experiencia = 0
        'muevo el de la pos i a freeindex
        i = freeindex
        freeindex = 0
    end if
    i = i + 1
wend

end sub

public function cantmiembros() as integer
cantmiembros = p_cantmiembros
end function
