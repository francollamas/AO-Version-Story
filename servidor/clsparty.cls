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
'**************************************************************
' clsparty.cls
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

private p_members(1 to party_maxmembers) as tpartymember
'miembros

private p_exptotal as long
'estadistica :d

private p_fundador as integer
'el creador

private p_cantmiembros as integer
'cantidad de miembros

private p_sumaniveleselevados as single
'suma de todos los niveles elevados a la exponentenivelparty > esta variable se usa para calcular la experiencia repartida en la party.

'datos en los pjs: | indexparty(indice en p_members), partyleader(userindex del lider) |

'constructor de clase
public sub class_initialize()
'***************************************************
'author: unknown
'last modification: 07/04/08
'last modification by: marco vanotti (markoxx)
' - 09/29/07 p_sumaniveles added (tavo)
' - 07/04/08 p_sumaniveles changed to p_sumaniveleselevados (markoxx)
'***************************************************
    p_exptotal = 0
    p_cantmiembros = 0
    p_sumaniveleselevados = 0
end sub

'destructor de clase
public sub class_terminate()
end sub

''
' sets the new p_sumaniveleselevados to the party.
'
' @param lvl specifies reference to user level
' @remarks when a user level up and he is in a party, we update p_sumaniveleselavados so the formula still works.
public sub updatesumaniveleselevados(byval lvl as integer)
'*************************************************
'author: marco vanotti (markoxx)
'last modified: 11/24/09
'11/24/09: pato - change the exponent to a variable with the exponent
'*************************************************
    p_sumaniveleselevados = p_sumaniveleselevados - ((lvl - 1) ^ exponentenivelparty) + lvl ^ exponentenivelparty
end sub

public function miexperiencia(byval userindex as integer) as long
'***************************************************
'author: unknown
'last modification: 11/27/09
'last modification by: budi
' - 09/29/07 experience is round to the biggest number less than that number
' - 09/29/07 now experience is a real-number
' - 11/27/09 arregl� el out of range.
'***************************************************
'me dice cuanta experiencia tengo colectada ya en la party
dim i as integer
i = 1

while i <= party_maxmembers and p_members(i).userindex <> userindex
    i = i + 1
wend

if i <= party_maxmembers then
    miexperiencia = fix(p_members(i).experiencia)
else        'esto no deberia pasar :p
    miexperiencia = -1
end if

end function

public sub obtenerexito(byval expganada as long, byval mapa as integer, x as integer, y as integer)
'***************************************************
'author: unknown
'last modification: 07/04/08
'last modification by: marco vanotti (markoxx)
' - 09/29/07 new formula for calculating the experience point of each user
' - 09/29/07 experience is round to the biggest number less than that number
' - 09/29/07 now experience is a real-number
' - 04/04/08 ahora antes de calcular la experiencia a x usuario se fija si ese usuario existe (markoxx)
' - 07/04/08 new formula to calculate experience for each user. (markoxx)
'***************************************************
'se produjo un evento que da experiencia en la wp referenciada
dim i as integer
dim ui as integer
dim expthisuser as double

p_exptotal = p_exptotal + expganada

for i = 1 to party_maxmembers
    ui = p_members(i).userindex
    if ui > 0 then
        ' formula: exp* (nivel ^ exponentenivelparty) / sumadeniveleselevados
        expthisuser = cdbl(expganada * (userlist(p_members(i).userindex).stats.elv ^ exponentenivelparty) / p_sumaniveleselevados)
        
        if mapa = userlist(ui).pos.map and userlist(ui).flags.muerto = 0 then
            if distance(userlist(ui).pos.x, userlist(ui).pos.y, x, y) <= party_maxdistancia then
                p_members(i).experiencia = p_members(i).experiencia + expthisuser
                if p_members(i).experiencia < 0 then
                    p_members(i).experiencia = 0
                end if
                if party_experienciaporgolpe then
                    userlist(ui).stats.exp = userlist(ui).stats.exp + fix(expthisuser)
                    if userlist(ui).stats.exp > maxexp then _
                        userlist(ui).stats.exp = maxexp
                    call checkuserlevel(ui)
                    call writeupdateuserstats(ui)
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
        call writeconsolemsg(p_members(i).userindex, " [" & sender & "] " & texto, fonttypenames.fonttype_party)
    end if
next i

end sub

public function espartyleader(byval userindex as integer) as boolean
    espartyleader = (userindex = p_fundador)
end function

public function nuevomiembro(byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: 07/04/08
'last modification by: marco vanotti (markoxx)
' - 09/29/07 there is no level prohibition (tavo)
' - 07/04/08 added const exponentenivelparty. (markoxx)
'***************************************************

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
    p_sumaniveleselevados = p_sumaniveleselevados + (userlist(userindex).stats.elv ^ exponentenivelparty)
else
    nuevomiembro = false
end if

end function

public function salemiembro(byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: 07/04/08
'last modification by: marco vanotti (markoxx)
' - 09/29/07 experience is round to the biggest number less than that number
' - 09/29/07 now experience is a real-number (tavo)
' - 07/04/08 added const exponentenivelparty. (markoxx)
'11/03/2010: zama - ahora no le dice al lider que salio de su propia party, y optimice con with.
'***************************************************
'el valor de retorno representa si se disuelve la party
    dim i as integer
    dim j as integer
    dim memberindex as integer
    
    i = 1
    salemiembro = false
    while i <= party_maxmembers and p_members(i).userindex <> userindex
        i = i + 1
    wend
    
    if i = 1 then
        'sale el founder, la party se disuelve
        salemiembro = true
        call mandarmensajeaconsola("el l�der disuelve la party.", "servidor")
        
        for j = party_maxmembers to 1 step -1
            
            with p_members(j)
            
                if .userindex > 0 then
                    
                    ' no envia el mensaje al lider
                    if j <> 1 then
                        call writeconsolemsg(.userindex, "abandonas la party liderada por " & _
                            userlist(p_members(1).userindex).name & ".", fonttypenames.fonttype_party)
                    end if
                    
                    call writeconsolemsg(.userindex, "durante la misma has conseguido " & cstr(fix(.experiencia)) & " puntos de experiencia.", fonttypenames.fonttype_party)
            
                    if not party_experienciaporgolpe then
                        userlist(.userindex).stats.exp = userlist(.userindex).stats.exp + fix(.experiencia)
                        if userlist(.userindex).stats.exp > maxexp then _
                            userlist(.userindex).stats.exp = maxexp
                        call checkuserlevel(.userindex)
                        call writeupdateuserstats(.userindex)
                    end if
                    
                    call mandarmensajeaconsola(userlist(.userindex).name & " abandona la party.", "servidor")
                    
                    userlist(.userindex).partyindex = 0
                    p_cantmiembros = p_cantmiembros - 1
                    p_sumaniveleselevados = p_sumaniveleselevados - (userlist(userindex).stats.elv ^ exponentenivelparty)
                    .userindex = 0
                    .experiencia = 0
                    
                end if
                
            end with
            
        next j
    else
        if i <= party_maxmembers then
            
            memberindex = p_members(i).userindex
            
            with userlist(memberindex)
                if not party_experienciaporgolpe then
                    .stats.exp = .stats.exp + fix(p_members(i).experiencia)
                    if .stats.exp > maxexp then .stats.exp = maxexp
                    
                    call checkuserlevel(memberindex)
                    call writeupdateuserstats(memberindex)
                end if
                
                call mandarmensajeaconsola(.name & " abandona la party.", "servidor")
                'todo: revisar que esto este bien, y no este faltando/sobrando un mensaje, ahora solo los estoy corrigiendo
                call writeconsolemsg(memberindex, "durante la misma has conseguido " & _
                    cstr(fix(p_members(i).experiencia)) & " puntos de experiencia.", fonttypenames.fonttype_party)
                
                p_cantmiembros = p_cantmiembros - 1
                p_sumaniveleselevados = p_sumaniveleselevados - (userlist(userindex).stats.elv ^ exponentenivelparty)
                memberindex = 0
                p_members(i).experiencia = 0
                p_members(i).userindex = 0
                compactmemberlist
            end with
        end if
    end if

end function

public function hacerleader(byval userindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: 09/29/07
'last modification by: lucas tavolaro ortiz (tavo)
' - 09/29/07 there is no level prohibition
'***************************************************
dim i as integer
dim oldleader as integer
dim oldexp as double
dim userindexindex as integer

userindexindex = 0
hacerleader = true

for i = 1 to party_maxmembers
    if p_members(i).userindex > 0 then
        if p_members(i).userindex = userindex then
            userindexindex = i
        end if
    end if
next i

if not hacerleader then exit function

if userindexindex = 0 then
    'catastrofe! esto no deberia pasar nunca! pero como es ao.... :p
    call logerror("inconsistencia de parties")
    call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("���inconsistencia de parties en hacerleader (uii = 0), avise a un programador esto es una catastrofe!!!!", fonttypenames.fonttype_guild))
    hacerleader = false
    exit function
end if


'aca esta todo bien y doy vuelta las collections
oldleader = p_members(1).userindex
oldexp = p_members(1).experiencia

p_members(1).userindex = p_members(userindexindex).userindex     'que en realdiad es el userindex, pero no quiero inconsistencias moviendo experiencias
p_members(1).experiencia = p_members(userindexindex).experiencia

p_members(userindexindex).userindex = oldleader
p_members(userindexindex).experiencia = oldexp

p_fundador = p_members(1).userindex

'no need to compact
end function


public sub obtenermiembrosonline(byref memberlist() as integer)
'***************************************************
'author: unknown
'last modification: 09/29/07
'last modification by: marco vanotti (markoxx)
' - 09/29/07 experience is round to the biggest number less than that number
' - 09/29/07 now experience is a real-number (tavo)
' - 08/18/08 now totalexperience is fixed (markoxx)
' - 11/27/09 rehice la funci�n, ahora devuelve el array con los ui online (budi)
'***************************************************

dim i as integer

for i = 1 to party_maxmembers
    if p_members(i).userindex > 0 then
        memberlist(i) = p_members(i).userindex
    end if
next i

end sub

public function obtenerexperienciatotal() as long
'***************************************************
'author: budi
'last modification: 11/27/09
'retrieves the total experience acumulated in the party
'***************************************************
obtenerexperienciatotal = p_exptotal
end function

public function puedeentrar(byval userindex as integer, byref razon as string) as boolean
'***************************************************
'author: unknown
'last modification: 09/29/07
'last modification by: lucas tavolaro ortiz (tavo)
' - 09/29/07 there is no level prohibition
'***************************************************
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
                    razon = "los miembros del ej�rcito real no entran a una party con criminales."
                    rv = false
                end if
                'aspirante caos en party ciuda
                if escaos and not criminal(ui) then
                    razon = "los miembros de la legi�n oscura no entran a una party con ciudadanos."
                    rv = false
                end if
                'aspirante crimi en party armada
                if userlist(ui).faccion.armadareal = 1 and criminal(userindex) then
                    razon = "los criminales no entran a parties con miembros del ej�rcito real."
                    rv = false
                end if
                'aspirante ciuda en party caos
                if userlist(ui).faccion.fuerzascaos = 1 and not criminal(userindex) then
                    razon = "los ciudadanos no entran a parties con miembros de la legi�n oscura."
                    rv = false
                end if
            
                if not rv then exit for 'violate una programacion estructurada
            end if
        next i
    else
        razon = "la mayor cantidad de miembros es " & party_maxmembers
    end if
else
    '�con o sin nombre?
    razon = "el usuario " & userlist(userindex).name & " se encuentra muy lejos."
end if

puedeentrar = rv

end function


public sub flushexperiencia()
'***************************************************
'author: unknown
'last modification: 09/29/07
'last modification by: lucas tavolaro ortiz (tavo)
' - 09/29/07 experience is round to the biggest number less than that number
' - 09/29/07 now experience is a real-number
'***************************************************
'esta funcion se invoca frente a cerradas del servidor. flushea la experiencia
'acumulada a los usuarios.

dim i as integer
if not party_experienciaporgolpe then   'esto sirve solo cuando acumulamos la experiencia!
    for i = 1 to party_maxmembers
        if p_members(i).userindex > 0 then
            if p_members(i).experiencia > 0 then
                userlist(p_members(i).userindex).stats.exp = userlist(p_members(i).userindex).stats.exp + fix(p_members(i).experiencia)
                if userlist(p_members(i).userindex).stats.exp > maxexp then _
                    userlist(p_members(i).userindex).stats.exp = maxexp
                call checkuserlevel(p_members(i).userindex)
            else
                if abs(userlist(p_members(i).userindex).stats.exp) > abs(fix(p_members(i).experiencia)) then
                    userlist(p_members(i).userindex).stats.exp = userlist(p_members(i).userindex).stats.exp + fix(p_members(i).experiencia)
                else
                    userlist(p_members(i).userindex).stats.exp = 0
                end if
            end if
            p_members(i).experiencia = 0
            call writeupdateuserstats(p_members(i).userindex)
        end if
    next i
end if

end sub

private sub compactmemberlist()
dim i as integer
dim freeindex as integer
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
