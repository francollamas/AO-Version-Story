version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsclan"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
option explicit

''
' clase clan
'
' es el "ado" de los clanes. la interfaz entre el disco y
' el juego. los datos no se guardan en memoria
' para evitar problemas de sincronizacion, y considerando
' que la performance de estas rutinas no es critica.
' by el oso :p

private p_guildname                 as string
private p_alineacion                as alineacion_guild
private p_onlinemembers             as collection   'array de userindexes!
private p_gmsonline                 as collection
private p_propuestasdepaz           as collection
private p_propuestasdealianza       as collection
private p_iteradorrelaciones        as integer
private p_iteradoronlinemembers     as integer
private p_iteradorpropuesta         as integer
private p_iteradoronlinegms         as integer
private p_guildnumber               as integer      'numero de guild en el mundo
private p_relaciones()              as relaciones_guild 'array de relaciones con los otros clanes
private guildinfofile               as string
private guildpath                   as string       'aca pq me es mas comodo setearlo y pq en ningun disenio
private membersfile                 as string       'decente la capa de arriba se entera donde estan
private solicitudesfile             as string       'los datos fisicamente
private propuestasfile              as string
private relacionesfile              as string
private votacionesfile              as string

private const newslength = 1024
private const desclength = 256
private const codexlength = 256

public property get guildname() as string
    guildname = p_guildname
end property


'
'alineacion y antifaccion
'

public property get alineacion() as alineacion_guild
    alineacion = p_alineacion
end property

public property get puntosantifaccion() as integer
    puntosantifaccion = val(getvar(guildinfofile, "guild" & p_guildnumber, "antifaccion"))
end property

public property let puntosantifaccion(byval p as integer)
    call writevar(guildinfofile, "guild" & p_guildnumber, "antifaccion", cstr(p))
end property

public sub cambiaralineacion(byval nuevaalineacion as alineacion_guild)
    p_alineacion = nuevaalineacion
    call writevar(guildinfofile, "guild" & p_guildnumber, "alineacion", alineacion2string(p_alineacion))
end sub

'
'inicializadores
'

private sub class_initialize()
    guildpath = app.path & "\guilds\"
    guildinfofile = guildpath & "guildsinfo.inf"
end sub

private sub class_terminate()
    set p_onlinemembers = nothing
    set p_gmsonline = nothing
    set p_propuestasdepaz = nothing
    set p_propuestasdealianza = nothing
end sub



public sub inicializar(byval guildname as string, byval guildnumber as integer, byval alineacion as alineacion_guild)
dim i as integer

    p_guildname = guildname
    p_guildnumber = guildnumber
    p_alineacion = alineacion
    set p_onlinemembers = new collection
    set p_gmsonline = new collection
    set p_propuestasdepaz = new collection
    set p_propuestasdealianza = new collection
    'alliesfile = guildpath & p_guildname & "-allied.all"
    'enemiesfile = guildpath & p_guildname & "-enemys.ene"
    relacionesfile = guildpath & p_guildname & "-relaciones.rel"
    membersfile = guildpath & p_guildname & "-members.mem"
    propuestasfile = guildpath & p_guildname & "-propositions.pro"
    solicitudesfile = guildpath & p_guildname & "-solicitudes.sol"
    votacionesfile = guildpath & p_guildname & "-votaciones.vot"
    p_iteradoronlinemembers = 0
    p_iteradorpropuesta = 0
    p_iteradoronlinegms = 0
    p_iteradorrelaciones = 0
    redim preserve p_relaciones(1 to cantidaddeclanes) as relaciones_guild
    for i = 1 to cantidaddeclanes
        p_relaciones(i) = string2relacion(getvar(relacionesfile, "relaciones", cstr(i)))
    next i
    for i = 1 to cantidaddeclanes
        if trim$(getvar(propuestasfile, cstr(i), "pendiente")) = "1" then
            select case string2relacion(trim$(getvar(propuestasfile, cstr(i), "tipo")))
                case relaciones_guild.aliados
                    p_propuestasdealianza.add i
                case relaciones_guild.paz
                    p_propuestasdepaz.add i
            end select
        end if
    next i
end sub

''
' esta tiene que llamarse luego de inicializar()
'
' @param fundador nombre del fundador del clan
'
public sub inicializarnuevoclan(byref fundador as string)
dim oldq    as string  'string pq al comienzo quizas no hay archivo guildinfo.ini y oldq es ""
dim newq    as integer
    'para que genere los archivos
    call writevar(membersfile, "init", "nromembers", "0")
    call writevar(solicitudesfile, "init", "cantsolicitudes", "0")


    oldq = getvar(guildinfofile, "init", "nroguilds")
    if isnumeric(oldq) then
        newq = cint(trim$(oldq)) + 1
    else
        newq = 1
    end if

    call writevar(guildinfofile, "init", "nroguilds", newq)

    call writevar(guildinfofile, "guild" & newq, "founder", fundador)
    call writevar(guildinfofile, "guild" & newq, "guildname", p_guildname)
    call writevar(guildinfofile, "guild" & newq, "date", date)
    call writevar(guildinfofile, "guild" & newq, "antifaccion", "0")
    call writevar(guildinfofile, "guild" & newq, "alineacion", alineacion2string(p_alineacion))

end sub

public sub procesarfundaciondeotroclan()
    redim preserve p_relaciones(1 to cantidaddeclanes) as relaciones_guild
    p_relaciones(cantidaddeclanes) = paz
end sub


'
'membresias
'

public property get fundador() as string
    fundador = getvar(guildinfofile, "guild" & p_guildnumber, "founder")
end property

'public property get jugadoresonline() as string
'dim i as integer
'    'leve violacion de capas x aqui, je
'    for i = 1 to p_onlinemembers.count
'        jugadoresonline = userlist(p_onlinemembers.item(i)).name & "," & jugadoresonline
'    next i
'end property

public property get cantidaddemiembros() as integer
dim oldq as string
    oldq = getvar(membersfile, "init", "nromembers")
    cantidaddemiembros = iif(isnumeric(oldq), cint(oldq), 0)
end property

public sub setleader(byref leader as string)
    call writevar(guildinfofile, "guild" & p_guildnumber, "leader", leader)
end sub

public function getleader() as string
    getleader = getvar(guildinfofile, "guild" & p_guildnumber, "leader")
end function

public function getmemberlist(byval separador as string) as string
dim oldq    as integer
dim tempstr as string

    oldq = me.cantidaddemiembros
    
    while oldq > 0
        tempstr = tempstr & getvar(membersfile, "members", "member" & oldq) & separador
        oldq = oldq - 1
    wend
    
    if len(tempstr) > 0 then
        tempstr = left$(tempstr, len(tempstr) - len(separador))
    end if
    
    getmemberlist = tempstr
end function

public sub conectarmiembro(byval userindex as integer)
    p_onlinemembers.add userindex
end sub

public sub desconectarmiembro(byval userindex as integer)
dim i   as integer
    for i = 1 to p_onlinemembers.count
        if p_onlinemembers.item(i) = userindex then
            p_onlinemembers.remove i
            exit sub
        end if
    next i
end sub

public sub aceptarnuevomiembro(byref nombre as string)
dim oldq    as integer
dim cantp   as integer
dim cantps  as string
dim oldqs  as string
    
    if dir(charpath & nombre & ".chr") <> vbnullstring then
        call writevar(charpath & nombre & ".chr", "guild", "guildindex", p_guildnumber)
        call writevar(charpath & nombre & ".chr", "guild", "aspirantea", "0")
        'cantps = getvar(charpath & nombre & ".chr", "guild", "clanesparticipo")
        'if isnumeric(cantps) then
        '    cantp = cint(cantps)
        'else
        '    cantp = 0
        'end if
        'call writevar(charpath & nombre & ".chr", "guild", "clanesparticipo", cantp + 1)
        oldqs = getvar(membersfile, "init", "nromembers")
        if isnumeric(oldqs) then
            oldq = cint(oldqs)
        else
            oldq = 0
        end if
        call writevar(membersfile, "init", "nromembers", oldq + 1)
        call writevar(membersfile, "members", "member" & oldq + 1, nombre)
    end if

end sub

public sub expulsarmiembro(byref nombre as string)
dim oldq        as integer
dim temps       as string
dim i           as integer
dim esmiembro   as boolean
dim miembrode   as string

    if dir(charpath & nombre & ".chr") <> vbnullstring then
        oldq = cint(getvar(membersfile, "init", "nromembers"))
        i = 1
        nombre = ucase$(nombre)
        while i <= oldq and ucase$(trim$(getvar(membersfile, "members", "member" & i))) <> nombre
            i = i + 1
        wend
        esmiembro = i <= oldq
        
        if esmiembro then
            call writevar(charpath & nombre & ".chr", "guild", "guildindex", vbnullstring)
            while i < oldq
                temps = getvar(membersfile, "members", "member" & i + 1)
                call writevar(membersfile, "members", "member" & i, temps)
                i = i + 1
            wend
            call writevar(membersfile, "members", "member" & oldq, vbnullstring)
            'seteo la cantidad de miembros nueva
            call writevar(membersfile, "init", "nromembers", oldq - 1)
            'lo echo a el
            miembrode = getvar(charpath & nombre & ".chr", "guild", "miembro")
            if not instr(1, miembrode, p_guildname, vbtextcompare) > 0 then
                if miembrode <> vbnullstring then
                    miembrode = miembrode & ","
                end if
                miembrode = miembrode & p_guildname
                call writevar(charpath & nombre & ".chr", "guild", "miembro", miembrode)
            end if
        end if

    end if

end sub

'
'aspirantes
'

public function getaspirantes(byval separador as string) as string
dim oldq    as integer
dim tempstr as string

    oldq = me.cantidadaspirantes()
    
    while oldq > 0
        tempstr = tempstr & getvar(solicitudesfile, "solicitud" & oldq, "nombre") & separador
        oldq = oldq - 1
    wend
    
    if len(tempstr) > 0 then
        tempstr = left$(tempstr, len(tempstr) - len(separador))
    end if
    
    getaspirantes = tempstr

end function


public function cantidadaspirantes() as integer
dim temps as string

    cantidadaspirantes = 0
    temps = getvar(solicitudesfile, "init", "cantsolicitudes")
    if not isnumeric(temps) then
        exit function
    end if
    cantidadaspirantes = cint(temps)

end function

public function detallessolicitudaspirante(byval nroaspirante as integer)
    detallessolicitudaspirante = getvar(solicitudesfile, "solicitud" & nroaspirante, "detalle")
end function

public function numerodeaspirante(byref nombre as string) as integer
dim i       as integer
dim cantasp as integer
    
    numerodeaspirante = 0
    
    for i = 1 to maxaspirantes
        if ucase$(trim$(getvar(solicitudesfile, "solicitud" & i, "nombre"))) = ucase$(nombre) then
            numerodeaspirante = i
            exit function
        end if
    next i
end function

public sub nuevoaspirante(byref nombre as string, byref peticion as string)
dim i       as integer
dim oldq    as string
dim oldqi   as integer

    oldq = getvar(solicitudesfile, "init", "cantsolicitudes")
    if isnumeric(oldq) then
        oldqi = cint(oldq)
    else
        oldqi = 0
    end if
    for i = 1 to maxaspirantes
        if getvar(solicitudesfile, "solicitud" & i, "nombre") = vbnullstring then
            call writevar(solicitudesfile, "solicitud" & i, "nombre", nombre)
            call writevar(solicitudesfile, "solicitud" & i, "detalle", iif(trim$(peticion) = vbnullstring, "peticion vacia", peticion))
            call writevar(solicitudesfile, "init", "cantsolicitudes", oldqi + 1)
            call writevar(charpath & nombre & ".chr", "guild", "aspirantea", p_guildnumber)
            exit sub
        end if
    next i
end sub

public sub retiraraspirante(byref nombre as string, byref nroaspirante as integer)
dim oldq    as string
dim oldqi   as string
dim pedidos as string
dim i       as integer

    oldq = getvar(solicitudesfile, "init", "cantsolicitudes")
    if isnumeric(oldq) then
        oldqi = cint(oldq)
    else
        oldqi = 1
    end if
    'call writevar(solicitudesfile, "solicitud" & nroaspirante, "nombre", vbnullstring)
    'call writevar(solicitudesfile, "solicitud" & nroaspirante, "detalle", vbnullstring)
    call writevar(charpath & nombre & ".chr", "guild", "aspirantea", "0")
    pedidos = getvar(charpath & nombre & ".chr", "guild", "pedidos")
    if not instr(1, pedidos, p_guildname, vbtextcompare) > 0 then
        if pedidos <> vbnullstring then
            pedidos = pedidos & ","
        end if
        pedidos = pedidos & p_guildname
        call writevar(charpath & nombre & ".chr", "guild", "pedidos", pedidos)
    end if
    
    call writevar(solicitudesfile, "init", "cantsolicitudes", oldqi - 1)
    for i = nroaspirante to modguilds.maxaspirantes - 1
        call writevar(solicitudesfile, "solicitud" & i, "nombre", getvar(solicitudesfile, "solicitud" & (i + 1), "nombre"))
        call writevar(solicitudesfile, "solicitud" & i, "detalle", getvar(solicitudesfile, "solicitud" & (i + 1), "detalle"))
    next i
    
    call writevar(solicitudesfile, "solicitud" & modguilds.maxaspirantes, "nombre", vbnullstring)
    call writevar(solicitudesfile, "solicitud" & modguilds.maxaspirantes, "detalle", vbnullstring)
    
end sub

public sub informarrechazoenchar(byref nombre as string, byref detalles as string)
    call writevar(charpath & nombre & ".chr", "guild", "motivorechazo", detalles)
end sub

'
'definicion del clan (codex y noticias)
'

public function getfechafundacion() as string
    getfechafundacion = getvar(guildinfofile, "guild" & p_guildnumber, "date")
end function

public sub setcodex(byval codexnumber as integer, byref codex as string)
    call replaceinvalidchars(codex)
    codex = left$(codex, codexlength)
    call writevar(guildinfofile, "guild" & p_guildnumber, "codex" & codexnumber, codex)
end sub

public function getcodex(byval codexnumber as integer) as string
    getcodex = getvar(guildinfofile, "guild" & p_guildnumber, "codex" & codexnumber)
end function


public sub seturl(byref url as string)
    call writevar(guildinfofile, "guild" & p_guildnumber, "url", left$(url, 40))
end sub

public function geturl() as string
    geturl = getvar(guildinfofile, "guild" & p_guildnumber, "url")
end function

public sub setguildnews(byref news as string)
    call replaceinvalidchars(news)
    
    news = left$(news, newslength)
    
    call writevar(guildinfofile, "guild" & p_guildnumber, "guildnews", news)
end sub

public function getguildnews() as string
    getguildnews = getvar(guildinfofile, "guild" & p_guildnumber, "guildnews")
end function

public sub setdesc(byref desc as string)
    call replaceinvalidchars(desc)
    desc = left$(desc, desclength)
    
    call writevar(guildinfofile, "guild" & p_guildnumber, "desc", desc)
end sub

public function getdesc() as string
    getdesc = getvar(guildinfofile, "guild" & p_guildnumber, "desc")
end function



'
'
'elecciones
'
'

public function eleccionesabiertas() as boolean
dim ee as string
    ee = getvar(guildinfofile, "guild" & p_guildnumber, "eleccionesabiertas")
    eleccionesabiertas = (ee = "1")     'cualquier otra cosa da falso
end function

public sub abrirelecciones()
    call writevar(guildinfofile, "guild" & p_guildnumber, "eleccionesabiertas", "1")
    call writevar(guildinfofile, "guild" & p_guildnumber, "eleccionesfinalizan", dateadd("d", 1, now))
    call writevar(votacionesfile, "init", "numvotos", "0")
end sub

private sub cerrarelecciones()  'solo pueden cerrarse mediante recuento de votos
    call writevar(guildinfofile, "guild" & p_guildnumber, "eleccionesabiertas", "0")
    call writevar(guildinfofile, "guild" & p_guildnumber, "eleccionesfinalizan", vbnullstring)
    call kill(votacionesfile)   'borramos toda la evidencia ;-)
end sub

public sub contabilizarvoto(byref votante as string, byref votado as string)
dim q       as integer
dim temps   as string

    temps = getvar(votacionesfile, "init", "numvotos")
    q = iif(isnumeric(temps), cint(temps), 0)
    call writevar(votacionesfile, "votos", votante, votado)
    call writevar(votacionesfile, "init", "numvotos", cstr(q + 1))
end sub

public function yavoto(byref votante) as boolean
    yavoto = (trim$(getvar(votacionesfile, "votos", votante)) <> vbnullstring)
end function

private function contarvotos(byref cantganadores as integer) as string
dim q           as integer
dim i           as integer
dim temps       as string
dim tempv       as string
dim tempn       as string
dim tempw       as string
dim d           as diccionario

on error goto errh
    contarvotos = vbnullstring
    cantganadores = 0
    temps = getvar(membersfile, "init", "nromembers")
    q = iif(isnumeric(temps), cint(temps), 0)
    if q > 0 then
        'el diccionario tiene clave el elegido y valor la #votos
        set d = new diccionario
        
        for i = 1 to q
            'miembro del clan
            temps = getvar(membersfile, "members", "member" & i)
            
            'a quienvoto
            tempv = getvar(votacionesfile, "votos", temps)
            
            'si voto a alguien contabilizamos el voto
            if tempv <> vbnullstring then
                if not isnull(d.at(tempv)) then  'cuantos votos tiene?
                    call d.atput(tempv, cint(d.at(tempv)) + 1)
                else
                    call d.atput(tempv, 1)
                end if
            end if
        next i
    
        'quien quedo con mas votos, y cuantos tuvieron esos votos?
        contarvotos = d.mayorvalor(cantganadores)
    
        set d = nothing
    end if
    
exit function
errh:
    logerror ("clsclan.contarvotos: " & err.description)
    if not d is nothing then set d = nothing
    contarvotos = vbnullstring
end function

public function revisarelecciones() as boolean
dim fechasufragio   as date
dim temps           as string
dim ganador         as string
dim cantganadores   as integer

    revisarelecciones = false
    temps = trim$(getvar(guildinfofile, "guild" & p_guildnumber, "eleccionesfinalizan"))
    
    if temps = vbnullstring then exit function
    
    if isdate(temps) then
        fechasufragio = cdate(temps)
        if fechasufragio < now then     'toca!
            ganador = contarvotos(cantganadores)

            if cantganadores > 1 then
                'empate en la votacion
                call setguildnews("*empate en la votaci�n. " & ganador & " con " & cantganadores & " votos ganaron las elecciones del clan")
            elseif cantganadores = 1 then
                if instr(1, me.getmemberlist(","), ganador, vbtextcompare) > 0 then
                    call setguildnews("*" & ganador & " gan� la elecci�n del clan*")
                    call me.setleader(ganador)
                    revisarelecciones = true
                else
                    call setguildnews("*" & ganador & " gan� la elecci�n del clan pero abandon� las filas por lo que la votaci�n queda desierta*")
                end if
            else
                call setguildnews("*el per�odo de votaci�n se cerr� sin votos*")
            end if
            
            call cerrarelecciones
            
        end if
    else
        call logerror("clsclan.revisarelecciones: temps is not date")
    end if

end function

'/votaciones


'
'relaciones
'

public property get cantidadpropuestas(byval tipo as relaciones_guild) as integer
    select case tipo
        case relaciones_guild.aliados
            cantidadpropuestas = p_propuestasdealianza.count
        case relaciones_guild.guerra
        
        case relaciones_guild.paz
            cantidadpropuestas = p_propuestasdepaz.count
    end select
end property

public property get cantidadenemys() as integer
dim i as integer
    for i = 1 to cantidaddeclanes
        cantidadenemys = cantidadenemys + iif(p_relaciones(i) = guerra, 1, 0)
    next i
end property

public property get cantidadallies() as integer
dim i as integer
    for i = 1 to cantidaddeclanes
        cantidadallies = cantidadallies + iif(p_relaciones(i) = aliados, 1, 0)
    next i
end property

public function getrelacion(byval otroguild as integer) as relaciones_guild
    getrelacion = p_relaciones(otroguild)
end function

public sub setrelacion(byval guildindex as integer, byval relacion as relaciones_guild)
    p_relaciones(guildindex) = relacion
    call writevar(relacionesfile, "relaciones", guildindex, relacion2string(relacion))
end sub

public sub setpropuesta(byval tipo as relaciones_guild, byval otroguild as integer, byref detalle as string)
    call writevar(propuestasfile, cstr(otroguild), "detalle", detalle)
    call writevar(propuestasfile, cstr(otroguild), "tipo", relacion2string(tipo))
    call writevar(propuestasfile, cstr(otroguild), "pendiente", "1")
    select case tipo
        case relaciones_guild.aliados
            p_propuestasdealianza.add otroguild
        case relaciones_guild.paz
            p_propuestasdepaz.add otroguild
    end select
end sub

public sub anularpropuestas(byval otroguild as integer)
dim i as integer

    call writevar(propuestasfile, cstr(otroguild), "detalle", vbnullstring)
    call writevar(propuestasfile, cstr(otroguild), "pendiente", "0")
    for i = 1 to p_propuestasdepaz.count
        if p_propuestasdepaz.item(i) = otroguild then p_propuestasdepaz.remove (i)
        exit sub
    next i
    for i = 1 to p_propuestasdealianza.count
        if p_propuestasdealianza.item(i) = otroguild then p_propuestasdealianza.remove (i)
        exit sub
    next i
    
end sub

public function getpropuesta(byval otroguild as integer, byref tipo as relaciones_guild) as string
'trae la solicitd que haya, no valida si es actual o de que tipo es
    getpropuesta = getvar(propuestasfile, cstr(otroguild), "detalle")
    tipo = string2relacion(getvar(propuestasfile, cstr(otroguild), "tipo"))
end function

public function haypropuesta(byval otroguild as integer, byref tipo as relaciones_guild) as boolean
dim i as integer

    haypropuesta = false
    select case tipo
        case relaciones_guild.aliados
            for i = 1 to p_propuestasdealianza.count
                if p_propuestasdealianza.item(i) = otroguild then
                    haypropuesta = true
                end if
            next i
        case relaciones_guild.paz
            for i = 1 to p_propuestasdepaz.count
                if p_propuestasdepaz.item(i) = otroguild then
                    haypropuesta = true
                end if
            next i
        case relaciones_guild.guerra

    end select

end function

'public function getenemy(byval enemyindex as integer) as string
'    getenemy = getvar(enemiesfile, "enemys", "enemy" & enemyindex)
'end function

'public function getallie(byval allieindex as integer) as string
'    getallie = getvar(alliesfile, "allies", "allie" & allieindex)
'end function


'
'iteradores
'

public function iterador_proximapropuesta(byval tipo as relaciones_guild) as integer
    
    iterador_proximapropuesta = 0
    select case tipo
        case relaciones_guild.aliados
            if p_iteradorpropuesta < p_propuestasdealianza.count then
                p_iteradorpropuesta = p_iteradorpropuesta + 1
                iterador_proximapropuesta = p_propuestasdealianza.item(p_iteradorpropuesta)
            else
                p_iteradorpropuesta = 0
                iterador_proximapropuesta = 0
            end if
        case relaciones_guild.paz
            if p_iteradorpropuesta < p_propuestasdepaz.count then
                p_iteradorpropuesta = p_iteradorpropuesta + 1
                iterador_proximapropuesta = p_propuestasdepaz.item(p_iteradorpropuesta)
            else
                p_iteradorpropuesta = 0
                iterador_proximapropuesta = 0
            end if
    end select
    
end function

public function m_iterador_proximouserindex() as integer
    
    if p_iteradoronlinemembers < p_onlinemembers.count then
        p_iteradoronlinemembers = p_iteradoronlinemembers + 1
        m_iterador_proximouserindex = p_onlinemembers.item(p_iteradoronlinemembers)
    else
        p_iteradoronlinemembers = 0
        m_iterador_proximouserindex = 0
    end if
end function

public function iterador_proximogm() as integer
    
    if p_iteradoronlinegms < p_gmsonline.count then
        p_iteradoronlinegms = p_iteradoronlinegms + 1
        iterador_proximogm = p_gmsonline.item(p_iteradoronlinegms)
    else
        p_iteradoronlinegms = 0
        iterador_proximogm = 0
    end if
end function

public function iterador_proximarelacion(byval r as relaciones_guild) as integer
    
    while p_iteradorrelaciones < ubound(p_relaciones)
        
        p_iteradorrelaciones = p_iteradorrelaciones + 1
        if p_relaciones(p_iteradorrelaciones) = r then
            iterador_proximarelacion = p_iteradorrelaciones
            exit function
        end if
    wend

    if p_iteradorrelaciones >= ubound(p_relaciones) then
        p_iteradorrelaciones = 0
    end if
end function
'
'
'


'
'administrativas
'

public sub conectargm(byval userindex as integer)
    p_gmsonline.add userindex
end sub

public sub desconectargm(byval userindex as integer)
dim i as integer
    for i = 1 to p_gmsonline.count
        if p_gmsonline.item(i) = userindex then
            p_gmsonline.remove (i)
        end if
    next i
end sub



'
'varias, extras y demases
'

private sub replaceinvalidchars(byref s as string)
    s = replace(s, chr(13), vbnullstring)
    s = replace(s, chr(10), vbnullstring)
    s = replace(s, "�", vbnullstring)   'morgo usaba esto como "separador"
    s = replace(s, endc, vbnullstring)
end sub



