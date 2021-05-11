attribute vb_name = "modguilds"
'**************************************************************
' modguilds.bas - module to allow the usage of areas instead of maps.
' saves a lot of bandwidth.
'
' implemented by mariano barrou (el oso)
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

'guilds nueva version. hecho por el oso, eliminando los problemas
'de sincronizacion con los datos en el hd... entre varios otros
'��

''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
'declaracioens publicas concernientes al juego
'y configuracion del sistema de clanes
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
private guildinfofile   as string
'archivo .\guilds\guildinfo.ini o similar

private const max_guilds as integer = 1000
'cantidad maxima de guilds en el servidor

public cantidaddeclanes as integer
'cantidad actual de clanes en el servidor

private guilds(1 to max_guilds) as clsclan
'array global de guilds, se indexa por userlist().guildindex

private const cantidadmaximacodex as byte = 8
'cantidad maxima de codecs que se pueden definir

public const maxaspirantes as byte = 10
'cantidad maxima de aspirantes que puede tener un clan acumulados a la vez

private const maxantifaccion as byte = 5
'puntos maximos de antifaccion que un clan tolera antes de ser cambiada su alineacion

public enum alineacion_guild
    alineacion_legion = 1
    alineacion_criminal = 2
    alineacion_neutro = 3
    alineacion_ciuda = 4
    alineacion_armada = 5
    alineacion_master = 6
end enum
'alineaciones permitidas

public enum sonidos_guild
    snd_creacionclan = 44
    snd_aceptadoclan = 43
    snd_declarewar = 45
end enum
'numero de .wav del cliente

public enum relaciones_guild
    guerra = -1
    paz = 0
    aliados = 1
end enum
'estado entre clanes
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

public sub loadguildsdb()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim cantclanes  as string
dim i           as integer
dim tempstr     as string
dim alin        as alineacion_guild
    
    guildinfofile = app.path & "\guilds\guildsinfo.inf"

    cantclanes = getvar(guildinfofile, "init", "nroguilds")
    
    if isnumeric(cantclanes) then
        cantidaddeclanes = cint(cantclanes)
    else
        cantidaddeclanes = 0
    end if
    
    for i = 1 to cantidaddeclanes
        set guilds(i) = new clsclan
        tempstr = getvar(guildinfofile, "guild" & i, "guildname")
        alin = string2alineacion(getvar(guildinfofile, "guild" & i, "alineacion"))
        call guilds(i).inicializar(tempstr, i, alin)
    next i
    
end sub

public function m_conectarmiembroaclan(byval userindex as integer, byval guildindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************


dim nuevaa  as boolean
dim news    as string

    if guildindex > cantidaddeclanes or guildindex <= 0 then exit function 'x las dudas...
    if m_estadopermiteentrar(userindex, guildindex) then
        call guilds(guildindex).conectarmiembro(userindex)
        userlist(userindex).guildindex = guildindex
        m_conectarmiembroaclan = true
    else
        m_conectarmiembroaclan = m_validarpermanencia(userindex, true, nuevaa)
        if nuevaa then news = news & "el clan tiene nueva alineaci�n."
        'if nuevol or nuevaa then call guilds(guildindex).setguildnews(news)
    end if

end function


public function m_validarpermanencia(byval userindex as integer, byval sumaantifaccion as boolean, _
                            byref cambioalineacion as boolean) as boolean
'***************************************************
'autor: unknown (orginal version)
'last modification: 14/12/2009
'25/03/2009: zama - desequipo los items faccionarios que tenga el funda al abandonar la faccion
'14/12/2009: zama - la alineacion del clan depende del lider
'14/02/2010: zama - ya no es necesario saber si el lider cambia, ya que no puede cambiar.
'***************************************************

dim guildindex  as integer

    m_validarpermanencia = true
    
    guildindex = userlist(userindex).guildindex
    if guildindex > cantidaddeclanes and guildindex <= 0 then exit function
    
    if not m_estadopermiteentrar(userindex, guildindex) then
        
        ' es el lider, bajamos 1 rango de alineacion
        if m_esguildleader(userlist(userindex).name, guildindex) then
            call logclanes(userlist(userindex).name & ", l�der de " & guilds(guildindex).guildname & " hizo bajar la alienaci�n de su clan.")
        
            cambioalineacion = true
            
            ' por si paso de ser armada/legion a pk/ciuda, chequeo de nuevo
            do
                call updateguildmembers(guildindex)
            loop until m_estadopermiteentrar(userindex, guildindex)
        else
            call logclanes(userlist(userindex).name & " de " & guilds(guildindex).guildname & " es expulsado en validar permanencia.")
        
            m_validarpermanencia = false
            if sumaantifaccion then guilds(guildindex).puntosantifaccion = guilds(guildindex).puntosantifaccion + 1
            
            cambioalineacion = guilds(guildindex).puntosantifaccion = maxantifaccion
            
            call logclanes(userlist(userindex).name & " de " & guilds(guildindex).guildname & _
                iif(cambioalineacion, " si ", " no ") & "provoca cambio de alineaci�n. maxant:" & cambioalineacion)
            
            call m_echarmiembrodeclan(-1, userlist(userindex).name)
            
            ' llegamos a la maxima cantidad de antifacciones permitidas, bajamos un grado de alineaci�n
            if cambioalineacion then
                call updateguildmembers(guildindex)
            end if
        end if
    end if
end function

private sub updateguildmembers(byval guildindex as integer)
'***************************************************
'autor: zama
'last modification: 14/01/2010 (zama)
'14/01/2010: zama - pulo detalles en el funcionamiento general.
'***************************************************
    dim guildmembers() as string
    dim totalmembers as integer
    dim memberindex as long
    dim sale as boolean
    dim membername as string
    dim userindex as integer
    dim reenlistadas as integer
    
    ' si devuelve true, cambio a neutro y echamos a todos los que est�n de mas, sino no echamos a nadie
    if guilds(guildindex).cambiaralineacion(bajargrado(guildindex)) then 'alineacion_neutro)
        
        'uso getmemberlist y no los iteradores pq voy a rajar gente y puedo alterar
        'internamente al iterador en el proceso
        guildmembers = guilds(guildindex).getmemberlist()
        totalmembers = ubound(guildmembers)
        
        for memberindex = 0 to totalmembers
            membername = guildmembers(memberindex)
            
            'vamos a violar un poco de capas..
            userindex = nameindex(membername)
            if userindex > 0 then
                sale = not m_estadopermiteentrar(userindex, guildindex)
            else
                sale = not m_estadopermiteentrarchar(membername, guildindex)
            end if

            if sale then
                if m_esguildleader(membername, guildindex) then  'hay que sacarlo de las facciones
                 
                    if userindex > 0 then
                        if userlist(userindex).faccion.armadareal <> 0 then
                            call expulsarfaccionreal(userindex)
                            ' no cuenta como reenlistada :p.
                            userlist(userindex).faccion.reenlistadas = userlist(userindex).faccion.reenlistadas - 1
                        elseif userlist(userindex).faccion.fuerzascaos <> 0 then
                            call expulsarfaccioncaos(userindex)
                            ' no cuenta como reenlistada :p.
                            userlist(userindex).faccion.reenlistadas = userlist(userindex).faccion.reenlistadas - 1
                        end if
                    else
                        if fileexist(charpath & membername & ".chr") then
                            call writevar(charpath & membername & ".chr", "facciones", "ejercitocaos", 0)
                            call writevar(charpath & membername & ".chr", "facciones", "ejercitoreal", 0)
                            reenlistadas = getvar(charpath & membername & ".chr", "facciones", "reenlistadas")
                            call writevar(charpath & membername & ".chr", "facciones", "reenlistadas", _
                                    iif(reenlistadas > 1, reenlistadas - 1, reenlistadas))
                        end if
                    end if
                else    'sale si no es guildleader
                    call m_echarmiembrodeclan(-1, membername)
                end if
            end if
        next memberindex
    else
        ' resetea los puntos de antifacci�n
        guilds(guildindex).puntosantifaccion = 0
    end if
end sub

private function bajargrado(byval guildindex as integer) as alineacion_guild
'***************************************************
'autor: zama
'last modification: 27/11/2009
'reduce el grado de la alineacion a partir de la alineacion dada
'***************************************************

select case guilds(guildindex).alineacion
    case alineacion_armada
        bajargrado = alineacion_ciuda
    case alineacion_legion
        bajargrado = alineacion_criminal
    case else
        bajargrado = alineacion_neutro
end select

end function

public sub m_desconectarmiembrodelclan(byval userindex as integer, byval guildindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

if userlist(userindex).guildindex > cantidaddeclanes then exit sub
    call guilds(guildindex).desconectarmiembro(userindex)
end sub

private function m_esguildleader(byref pj as string, byval guildindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    m_esguildleader = (ucase$(pj) = ucase$(trim$(guilds(guildindex).getleader)))
end function

private function m_esguildfounder(byref pj as string, byval guildindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    m_esguildfounder = (ucase$(pj) = ucase$(trim$(guilds(guildindex).fundador)))
end function

public function m_echarmiembrodeclan(byval expulsador as integer, byval expulsado as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'ui echa a expulsado del clan de expulsado
dim userindex   as integer
dim gi          as integer
    
    m_echarmiembrodeclan = 0

    userindex = nameindex(expulsado)
    if userindex > 0 then
        'pj online
        gi = userlist(userindex).guildindex
        if gi > 0 then
            if m_puedesalirdeclan(expulsado, gi, expulsador) then
                call guilds(gi).desconectarmiembro(userindex)
                call guilds(gi).expulsarmiembro(expulsado)
                call logclanes(expulsado & " ha sido expulsado de " & guilds(gi).guildname & " expulsador = " & expulsador)
                userlist(userindex).guildindex = 0
                call refreshcharstatus(userindex)
                m_echarmiembrodeclan = gi
            else
                m_echarmiembrodeclan = 0
            end if
        else
            m_echarmiembrodeclan = 0
        end if
    else
        'pj offline
        gi = getguildindexfromchar(expulsado)
        if gi > 0 then
            if m_puedesalirdeclan(expulsado, gi, expulsador) then
                call guilds(gi).expulsarmiembro(expulsado)
                call logclanes(expulsado & " ha sido expulsado de " & guilds(gi).guildname & " expulsador = " & expulsador)
                m_echarmiembrodeclan = gi
            else
                m_echarmiembrodeclan = 0
            end if
        else
            m_echarmiembrodeclan = 0
        end if
    end if

end function

public sub actualizarwebsite(byval userindex as integer, byref web as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim gi as integer

    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then exit sub
    
    if not m_esguildleader(userlist(userindex).name, gi) then exit sub
    
    call guilds(gi).seturl(web)
    
end sub


public sub changecodexanddesc(byref desc as string, byref codex() as string, byval guildindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim i as long
    
    if guildindex < 1 or guildindex > cantidaddeclanes then exit sub
    
    with guilds(guildindex)
        call .setdesc(desc)
        
        for i = 0 to ubound(codex())
            call .setcodex(i, codex(i))
        next i
        
        for i = i to cantidadmaximacodex
            call .setcodex(i, vbnullstring)
        next i
    end with
end sub

public sub actualizarnoticias(byval userindex as integer, byref datos as string)
'***************************************************
'author: unknown
'last modification: 21/02/2010
'21/02/2010: zama - ahora le avisa a los miembros que cambio el guildnews.
'***************************************************

    dim gi as integer

    with userlist(userindex)
        gi = .guildindex
        
        if gi <= 0 or gi > cantidaddeclanes then exit sub
        
        if not m_esguildleader(.name, gi) then exit sub
        
        call guilds(gi).setguildnews(datos)
        
        call senddata(sendtarget.todiosesyclan, .guildindex, preparemessageguildchat(.name & " ha actualizado las noticias del clan!"))
    end with
end sub

public function crearnuevoclan(byval fundadorindex as integer, byref desc as string, byref guildname as string, byref url as string, byref codex() as string, byval alineacion as alineacion_guild, byref referror as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim cantcodex       as integer
dim i               as integer
dim dummystring     as string

    crearnuevoclan = false
    if not puedefundarunclan(fundadorindex, alineacion, dummystring) then
        referror = dummystring
        exit function
    end if

    if guildname = vbnullstring or not guildnamevalido(guildname) then
        referror = "nombre de clan inv�lido."
        exit function
    end if
    
    if yaexiste(guildname) then
        referror = "ya existe un clan con ese nombre."
        exit function
    end if

    cantcodex = ubound(codex()) + 1

    'tenemos todo para fundar ya
    if cantidaddeclanes < ubound(guilds) then
        cantidaddeclanes = cantidaddeclanes + 1
        'redim preserve guilds(1 to cantidaddeclanes) as clsclan

        'constructor custom de la clase clan
        set guilds(cantidaddeclanes) = new clsclan
        
        with guilds(cantidaddeclanes)
            call .inicializar(guildname, cantidaddeclanes, alineacion)
            
            'damos de alta al clan como nuevo inicializando sus archivos
            call .inicializarnuevoclan(userlist(fundadorindex).name)
            
            'seteamos codex y descripcion
            for i = 1 to cantcodex
                call .setcodex(i, codex(i - 1))
            next i
            call .setdesc(desc)
            call .setguildnews("clan creado con alineaci�n: " & alineacion2string(alineacion))
            call .setleader(userlist(fundadorindex).name)
            call .seturl(url)
            
            '"conectamos" al nuevo miembro a la lista de la clase
            call .aceptarnuevomiembro(userlist(fundadorindex).name)
            call .conectarmiembro(fundadorindex)
        end with
        
        userlist(fundadorindex).guildindex = cantidaddeclanes
        call refreshcharstatus(fundadorindex)
        
        for i = 1 to cantidaddeclanes - 1
            call guilds(i).procesarfundaciondeotroclan
        next i
    else
        referror = "no hay m�s slots para fundar clanes. consulte a un administrador."
        exit function
    end if
    
    crearnuevoclan = true
end function

public sub sendguildnews(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim guildindex  as integer
dim i               as integer
dim go as integer

    guildindex = userlist(userindex).guildindex
    if guildindex = 0 then exit sub

    dim enemies() as string
    
    with guilds(guildindex)
        if .cantidadenemys then
            redim enemies(0 to .cantidadenemys - 1) as string
        else
            redim enemies(0)
        end if
        
        dim allies() as string
        
        if .cantidadallies then
            redim allies(0 to .cantidadallies - 1) as string
        else
            redim allies(0)
        end if
        
        i = .iterador_proximarelacion(relaciones_guild.guerra)
        go = 0
        
        while i > 0
            enemies(go) = guilds(i).guildname
            i = .iterador_proximarelacion(relaciones_guild.guerra)
            go = go + 1
        wend
        
        i = .iterador_proximarelacion(relaciones_guild.aliados)
        go = 0
        
        while i > 0
            allies(go) = guilds(i).guildname
            i = .iterador_proximarelacion(relaciones_guild.aliados)
        wend
    
        call writeguildnews(userindex, .getguildnews, enemies, allies)
    
        if .eleccionesabiertas then
            call writeconsolemsg(userindex, "hoy es la votaci�n para elegir un nuevo l�der para el clan.", fonttypenames.fonttype_guild)
            call writeconsolemsg(userindex, "la elecci�n durar� 24 horas, se puede votar a cualquier miembro del clan.", fonttypenames.fonttype_guild)
            call writeconsolemsg(userindex, "para votar escribe /voto nickname.", fonttypenames.fonttype_guild)
            call writeconsolemsg(userindex, "s�lo se computar� un voto por miembro. tu voto no puede ser cambiado.", fonttypenames.fonttype_guild)
        end if
    end with

end sub

public function m_puedesalirdeclan(byref nombre as string, byval guildindex as integer, byval quienloechaui as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'sale solo si no es fundador del clan.

    m_puedesalirdeclan = false
    if guildindex = 0 then exit function
    
    'esto es un parche, si viene en -1 es porque la invoca la rutina de expulsion automatica de clanes x antifacciones
    if quienloechaui = -1 then
        m_puedesalirdeclan = true
        exit function
    end if

    'cuando ui no puede echar a nombre?
    'si no es gm y no es lider del clan del pj y no es el mismo que se va voluntariamente
    if userlist(quienloechaui).flags.privilegios and playertype.user then
        if not m_esguildleader(ucase$(userlist(quienloechaui).name), guildindex) then
            if ucase$(userlist(quienloechaui).name) <> ucase$(nombre) then      'si no sale voluntariamente...
                exit function
            end if
        end if
    end if

    ' ahora el lider es el unico que no puede salir del clan
    m_puedesalirdeclan = ucase$(guilds(guildindex).getleader) <> ucase$(nombre)

end function

public function puedefundarunclan(byval userindex as integer, byval alineacion as alineacion_guild, byref referror as string) as boolean
'***************************************************
'autor: unknown
'last modification: 27/11/2009
'returns true if can found a guild
'27/11/2009: zama - ahora valida si ya fundo clan o no.
'***************************************************
    
    if userlist(userindex).guildindex > 0 then
        referror = "ya perteneces a un clan, no puedes fundar otro"
        exit function
    end if
    
    if userlist(userindex).stats.elv < 25 or userlist(userindex).stats.userskills(eskill.liderazgo) < 90 then
        referror = "para fundar un clan debes ser nivel 25 y tener 90 skills en liderazgo."
        exit function
    end if
    
    select case alineacion
        case alineacion_guild.alineacion_armada
            if userlist(userindex).faccion.armadareal <> 1 then
                referror = "para fundar un clan real debes ser miembro del ej�rcito real."
                exit function
            end if
        case alineacion_guild.alineacion_ciuda
            if criminal(userindex) then
                referror = "para fundar un clan de ciudadanos no debes ser criminal."
                exit function
            end if
        case alineacion_guild.alineacion_criminal
            if not criminal(userindex) then
                referror = "para fundar un clan de criminales no debes ser ciudadano."
                exit function
            end if
        case alineacion_guild.alineacion_legion
            if userlist(userindex).faccion.fuerzascaos <> 1 then
                referror = "para fundar un clan del mal debes pertenecer a la legi�n oscura."
                exit function
            end if
        case alineacion_guild.alineacion_master
            if userlist(userindex).flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then
                referror = "para fundar un clan sin alineaci�n debes ser un dios."
                exit function
            end if
        case alineacion_guild.alineacion_neutro
            if userlist(userindex).faccion.armadareal <> 0 or userlist(userindex).faccion.fuerzascaos <> 0 then
                referror = "para fundar un clan neutro no debes pertenecer a ninguna facci�n."
                exit function
            end if
    end select
    
    puedefundarunclan = true
    
end function

private function m_estadopermiteentrarchar(byref personaje as string, byval guildindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim promedio    as long
dim elv         as integer
dim f           as byte

    m_estadopermiteentrarchar = false
    
    if instrb(personaje, "\") <> 0 then
        personaje = replace(personaje, "\", vbnullstring)
    end if
    if instrb(personaje, "/") <> 0 then
        personaje = replace(personaje, "/", vbnullstring)
    end if
    if instrb(personaje, ".") <> 0 then
        personaje = replace(personaje, ".", vbnullstring)
    end if
    
    if fileexist(charpath & personaje & ".chr") then
        promedio = clng(getvar(charpath & personaje & ".chr", "rep", "promedio"))
        select case guilds(guildindex).alineacion
            case alineacion_guild.alineacion_armada
                if promedio >= 0 then
                    elv = cint(getvar(charpath & personaje & ".chr", "stats", "elv"))
                    if elv >= 25 then
                        f = cbyte(getvar(charpath & personaje & ".chr", "facciones", "ejercitoreal"))
                    end if
                    m_estadopermiteentrarchar = iif(elv >= 25, f <> 0, true)
                end if
            case alineacion_guild.alineacion_ciuda
                m_estadopermiteentrarchar = promedio >= 0
            case alineacion_guild.alineacion_criminal
                m_estadopermiteentrarchar = promedio < 0
            case alineacion_guild.alineacion_neutro
                m_estadopermiteentrarchar = cbyte(getvar(charpath & personaje & ".chr", "facciones", "ejercitoreal")) = 0
                m_estadopermiteentrarchar = m_estadopermiteentrarchar and (cbyte(getvar(charpath & personaje & ".chr", "facciones", "ejercitocaos")) = 0)
            case alineacion_guild.alineacion_legion
                if promedio < 0 then
                    elv = cint(getvar(charpath & personaje & ".chr", "stats", "elv"))
                    if elv >= 25 then
                        f = cbyte(getvar(charpath & personaje & ".chr", "facciones", "ejercitocaos"))
                    end if
                    m_estadopermiteentrarchar = iif(elv >= 25, f <> 0, true)
                end if
            case else
                m_estadopermiteentrarchar = true
        end select
    end if
end function

private function m_estadopermiteentrar(byval userindex as integer, byval guildindex as integer) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    select case guilds(guildindex).alineacion
        case alineacion_guild.alineacion_armada
            m_estadopermiteentrar = not criminal(userindex) and _
                    iif(userlist(userindex).stats.elv >= 25, userlist(userindex).faccion.armadareal <> 0, true)
        
        case alineacion_guild.alineacion_legion
            m_estadopermiteentrar = criminal(userindex) and _
                    iif(userlist(userindex).stats.elv >= 25, userlist(userindex).faccion.fuerzascaos <> 0, true)
        
        case alineacion_guild.alineacion_neutro
            m_estadopermiteentrar = userlist(userindex).faccion.armadareal = 0 and userlist(userindex).faccion.fuerzascaos = 0
        
        case alineacion_guild.alineacion_ciuda
            m_estadopermiteentrar = not criminal(userindex)
        
        case alineacion_guild.alineacion_criminal
            m_estadopermiteentrar = criminal(userindex)
        
        case else   'game masters
            m_estadopermiteentrar = true
    end select
end function

public function string2alineacion(byref s as string) as alineacion_guild
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    select case s
        case "neutral"
            string2alineacion = alineacion_neutro
        case "del mal"
            string2alineacion = alineacion_legion
        case "real"
            string2alineacion = alineacion_armada
        case "game masters"
            string2alineacion = alineacion_master
        case "legal"
            string2alineacion = alineacion_ciuda
        case "criminal"
            string2alineacion = alineacion_criminal
    end select
end function

public function alineacion2string(byval alineacion as alineacion_guild) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    select case alineacion
        case alineacion_guild.alineacion_neutro
            alineacion2string = "neutral"
        case alineacion_guild.alineacion_legion
            alineacion2string = "del mal"
        case alineacion_guild.alineacion_armada
            alineacion2string = "real"
        case alineacion_guild.alineacion_master
            alineacion2string = "game masters"
        case alineacion_guild.alineacion_ciuda
            alineacion2string = "legal"
        case alineacion_guild.alineacion_criminal
            alineacion2string = "criminal"
    end select
end function

public function relacion2string(byval relacion as relaciones_guild) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    select case relacion
        case relaciones_guild.aliados
            relacion2string = "a"
        case relaciones_guild.guerra
            relacion2string = "g"
        case relaciones_guild.paz
            relacion2string = "p"
        case relaciones_guild.aliados
            relacion2string = "?"
    end select
end function

public function string2relacion(byval s as string) as relaciones_guild
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    select case ucase$(trim$(s))
        case vbnullstring, "p"
            string2relacion = relaciones_guild.paz
        case "g"
            string2relacion = relaciones_guild.guerra
        case "a"
            string2relacion = relaciones_guild.aliados
        case else
            string2relacion = relaciones_guild.paz
    end select
end function

private function guildnamevalido(byval cad as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim car     as byte
dim i       as integer

'old function by morgo

cad = lcase$(cad)

for i = 1 to len(cad)
    car = asc(mid$(cad, i, 1))

    if (car < 97 or car > 122) and (car <> 255) and (car <> 32) then
        guildnamevalido = false
        exit function
    end if
    
next i

guildnamevalido = true

end function

private function yaexiste(byval guildname as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim i   as integer

yaexiste = false
guildname = ucase$(guildname)

for i = 1 to cantidaddeclanes
    yaexiste = (ucase$(guilds(i).guildname) = guildname)
    if yaexiste then exit function
next i

end function

public function hasfound(byref username as string) as boolean
'***************************************************
'autor: zama
'last modification: 27/11/2009
'returns true if it's already the founder of other guild
'***************************************************
dim i as long
dim name as string

name = ucase$(username)

for i = 1 to cantidaddeclanes
    hasfound = (ucase$(guilds(i).fundador) = name)
    if hasfound then exit function
next i

end function

public function v_abrirelecciones(byval userindex as integer, byref referror as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim guildindex      as integer

    v_abrirelecciones = false
    guildindex = userlist(userindex).guildindex
    
    if guildindex = 0 or guildindex > cantidaddeclanes then
        referror = "t� no perteneces a ning�n clan."
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, guildindex) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    if guilds(guildindex).eleccionesabiertas then
        referror = "las elecciones ya est�n abiertas."
        exit function
    end if
    
    v_abrirelecciones = true
    call guilds(guildindex).abrirelecciones
    
end function

public function v_usuariovota(byval userindex as integer, byref votado as string, byref referror as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim guildindex      as integer
dim list()          as string
dim i as long

    v_usuariovota = false
    guildindex = userlist(userindex).guildindex
    
    if guildindex = 0 or guildindex > cantidaddeclanes then
        referror = "t� no perteneces a ning�n clan."
        exit function
    end if

    with guilds(guildindex)
        if not .eleccionesabiertas then
            referror = "no hay elecciones abiertas en tu clan."
            exit function
        end if
        
        
        list = .getmemberlist()
        for i = 0 to ubound(list())
            if ucase$(votado) = list(i) then exit for
        next i
        
        if i > ubound(list()) then
            referror = votado & " no pertenece al clan."
            exit function
        end if
        
        
        if .yavoto(userlist(userindex).name) then
            referror = "ya has votado, no puedes cambiar tu voto."
            exit function
        end if
        
        call .contabilizarvoto(userlist(userindex).name, votado)
        v_usuariovota = true
    end with

end function

public sub v_rutinaelecciones()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim i       as integer

on error goto errh
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> revisando elecciones", fonttypenames.fonttype_server))
    for i = 1 to cantidaddeclanes
        if not guilds(i) is nothing then
            if guilds(i).revisarelecciones then
                call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> " & guilds(i).getleader & " es el nuevo l�der de " & guilds(i).guildname & ".", fonttypenames.fonttype_server))
            end if
        end if
proximo:
    next i
    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("servidor> elecciones revisadas.", fonttypenames.fonttype_server))
exit sub
errh:
    call logerror("modguilds.v_rutinaelecciones():" & err.description)
    resume proximo
end sub

private function getguildindexfromchar(byref playername as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'aca si que vamos a violar las capas deliveradamente ya que
'visual basic no permite declarar metodos de clase
dim temps   as string
    if instrb(playername, "\") <> 0 then
        playername = replace(playername, "\", vbnullstring)
    end if
    if instrb(playername, "/") <> 0 then
        playername = replace(playername, "/", vbnullstring)
    end if
    if instrb(playername, ".") <> 0 then
        playername = replace(playername, ".", vbnullstring)
    end if
    temps = getvar(charpath & playername & ".chr", "guild", "guildindex")
    if isnumeric(temps) then
        getguildindexfromchar = cint(temps)
    else
        getguildindexfromchar = 0
    end if
end function

public function guildindex(byref guildname as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'me da el indice del guildname
dim i as integer

    guildindex = 0
    guildname = ucase$(guildname)
    for i = 1 to cantidaddeclanes
        if ucase$(guilds(i).guildname) = guildname then
            guildindex = i
            exit function
        end if
    next i
end function

public function m_listademiembrosonline(byval userindex as integer, byval guildindex as integer) as string
'***************************************************
'author: unknown
'last modification: 28/05/2010
'28/05/2010: zama - solo dioses pueden ver otros dioses online.
'***************************************************

    dim i as integer
    dim priv as playertype

    priv = playertype.user or playertype.consejero or playertype.semidios
    
    ' solo dioses pueden ver otros dioses online
    if userlist(userindex).flags.privilegios and (playertype.dios or playertype.admin) then
        priv = priv or playertype.dios or playertype.admin
    end if
    
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        
        ' horrible, tengo que decirlo..
        i = guilds(guildindex).m_iterador_proximouserindex
        
        while i > 0
        
            'no mostramos dioses y admins
            if i <> userindex and (userlist(i).flags.privilegios and priv) then
                m_listademiembrosonline = m_listademiembrosonline & userlist(i).name & ","
            end if
            
            i = guilds(guildindex).m_iterador_proximouserindex
        wend
    end if
    
    if len(m_listademiembrosonline) > 0 then
        m_listademiembrosonline = left$(m_listademiembrosonline, len(m_listademiembrosonline) - 1)
    end if
end function

public function prepareguildslist() as string()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim tstr() as string
    dim i as long
    
    if cantidaddeclanes = 0 then
        redim tstr(0) as string
    else
        redim tstr(cantidaddeclanes - 1) as string
        
        for i = 1 to cantidaddeclanes
            tstr(i - 1) = guilds(i).guildname
        next i
    end if
    
    prepareguildslist = tstr
end function

public sub sendguilddetails(byval userindex as integer, byref guildname as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim codex(cantidadmaximacodex - 1)  as string
    dim gi      as integer
    dim i       as long

    gi = guildindex(guildname)
    if gi = 0 then exit sub
    
    with guilds(gi)
        for i = 1 to cantidadmaximacodex
            codex(i - 1) = .getcodex(i)
        next i
        
        call protocol.writeguilddetails(userindex, guildname, .fundador, .getfechafundacion, .getleader, _
                                    .geturl, .cantidaddemiembros, .eleccionesabiertas, alineacion2string(.alineacion), _
                                    .cantidadenemys, .cantidadallies, .puntosantifaccion & "/" & cstr(maxantifaccion), _
                                    codex, .getdesc)
    end with
end sub

public sub sendguildleaderinfo(byval userindex as integer)
'***************************************************
'autor: mariano barrou (el oso)
'last modification: 12/10/06
'las modified by: juan mart�n sotuyo dodero (maraxus)
'***************************************************
    dim gi      as integer
    dim guildlist() as string
    dim memberlist() as string
    dim aspirantslist() as string

    with userlist(userindex)
        gi = .guildindex
        
        guildlist = prepareguildslist()
        
        if gi <= 0 or gi > cantidaddeclanes then
            'send the guild list instead
            call writeguildlist(userindex, guildlist)
            exit sub
        end if
        
        memberlist = guilds(gi).getmemberlist()
        
        if not m_esguildleader(.name, gi) then
            'send the guild list instead
            call writeguildmemberinfo(userindex, guildlist, memberlist)
            exit sub
        end if
        
        aspirantslist = guilds(gi).getaspirantes()
        
        call writeguildleaderinfo(userindex, guildlist, memberlist, guilds(gi).getguildnews(), aspirantslist)
    end with
end sub


public function m_iterador_proximouserindex(byval guildindex as integer) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'itera sobre los onlinemembers
    m_iterador_proximouserindex = 0
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        m_iterador_proximouserindex = guilds(guildindex).m_iterador_proximouserindex()
    end if
end function

public function iterador_proximogm(byval guildindex as integer) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'itera sobre los gms escuchando este clan
    iterador_proximogm = 0
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        iterador_proximogm = guilds(guildindex).iterador_proximogm()
    end if
end function

public function r_iterador_proximapropuesta(byval guildindex as integer, byval tipo as relaciones_guild) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    'itera sobre las propuestas
    r_iterador_proximapropuesta = 0
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        r_iterador_proximapropuesta = guilds(guildindex).iterador_proximapropuesta(tipo)
    end if
end function

public function gmescuchaclan(byval userindex as integer, byval guildname as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim gi as integer

    'listen to no guild at all
    if lenb(guildname) = 0 and userlist(userindex).escucheclan <> 0 then
        'quit listening to previous guild!!
        call writeconsolemsg(userindex, "dejas de escuchar a : " & guilds(userlist(userindex).escucheclan).guildname, fonttypenames.fonttype_guild)
        guilds(userlist(userindex).escucheclan).desconectargm (userindex)
        exit function
    end if
    
'devuelve el guildindex
    gi = guildindex(guildname)
    if gi > 0 then
        if userlist(userindex).escucheclan <> 0 then
            if userlist(userindex).escucheclan = gi then
                'already listening to them...
                call writeconsolemsg(userindex, "conectado a : " & guildname, fonttypenames.fonttype_guild)
                gmescuchaclan = gi
                exit function
            else
                'quit listening to previous guild!!
                call writeconsolemsg(userindex, "dejas de escuchar a : " & guilds(userlist(userindex).escucheclan).guildname, fonttypenames.fonttype_guild)
                guilds(userlist(userindex).escucheclan).desconectargm (userindex)
            end if
        end if
        
        call guilds(gi).conectargm(userindex)
        call writeconsolemsg(userindex, "conectado a : " & guildname, fonttypenames.fonttype_guild)
        gmescuchaclan = gi
        userlist(userindex).escucheclan = gi
    else
        call writeconsolemsg(userindex, "error, el clan no existe.", fonttypenames.fonttype_guild)
        gmescuchaclan = 0
    end if
    
end function

public sub gmdejadeescucharclan(byval userindex as integer, byval guildindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'el index lo tengo que tener de cuando me puse a escuchar
    userlist(userindex).escucheclan = 0
    call guilds(guildindex).desconectargm(userindex)
end sub
public function r_declararguerra(byval userindex as integer, byref guildguerra as string, byref referror as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim gi  as integer
dim gig as integer

    r_declararguerra = 0
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan."
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan."
        exit function
    end if
    
    if trim$(guildguerra) = vbnullstring then
        referror = "no has seleccionado ning�n clan."
        exit function
    end if
    
    gig = guildindex(guildguerra)
    if guilds(gi).getrelacion(gig) = guerra then
        referror = "tu clan ya est� en guerra con " & guildguerra & "."
        exit function
    end if
        
    if gi = gig then
        referror = "no puedes declarar la guerra a tu mismo clan."
        exit function
    end if

    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_declararguerra: " & gi & " declara a " & guildguerra)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)"
        exit function
    end if

    call guilds(gi).anularpropuestas(gig)
    call guilds(gig).anularpropuestas(gi)
    call guilds(gi).setrelacion(gig, relaciones_guild.guerra)
    call guilds(gig).setrelacion(gi, relaciones_guild.guerra)
    
    r_declararguerra = gig

end function


public function r_aceptarpropuestadepaz(byval userindex as integer, byref guildpaz as string, byref referror as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'el clan de userindex acepta la propuesta de paz de guildpaz, con quien esta en guerra
dim gi      as integer
dim gig     as integer

    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan."
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan."
        exit function
    end if
    
    if trim$(guildpaz) = vbnullstring then
        referror = "no has seleccionado ning�n clan."
        exit function
    end if

    gig = guildindex(guildpaz)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_aceptarpropuestadepaz: " & gi & " acepta de " & guildpaz)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)."
        exit function
    end if

    if guilds(gi).getrelacion(gig) <> relaciones_guild.guerra then
        referror = "no est�s en guerra con ese clan."
        exit function
    end if
    
    if not guilds(gi).haypropuesta(gig, relaciones_guild.paz) then
        referror = "no hay ninguna propuesta de paz para aceptar."
        exit function
    end if

    call guilds(gi).anularpropuestas(gig)
    call guilds(gig).anularpropuestas(gi)
    call guilds(gi).setrelacion(gig, relaciones_guild.paz)
    call guilds(gig).setrelacion(gi, relaciones_guild.paz)
    
    r_aceptarpropuestadepaz = gig
end function

public function r_rechazarpropuestadealianza(byval userindex as integer, byref guildpro as string, byref referror as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'devuelve el index al clan guildpro
dim gi      as integer
dim gig     as integer

    r_rechazarpropuestadealianza = 0
    gi = userlist(userindex).guildindex
    
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan."
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan."
        exit function
    end if
    
    if trim$(guildpro) = vbnullstring then
        referror = "no has seleccionado ning�n clan."
        exit function
    end if

    gig = guildindex(guildpro)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_rechazarpropuestadealianza: " & gi & " acepta de " & guildpro)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)."
        exit function
    end if
    
    if not guilds(gi).haypropuesta(gig, aliados) then
        referror = "no hay propuesta de alianza del clan " & guildpro
        exit function
    end if
    
    call guilds(gi).anularpropuestas(gig)
    'avisamos al otro clan
    call guilds(gig).setguildnews(guilds(gi).guildname & " ha rechazado nuestra propuesta de alianza. " & guilds(gig).getguildnews())
    r_rechazarpropuestadealianza = gig

end function


public function r_rechazarpropuestadepaz(byval userindex as integer, byref guildpro as string, byref referror as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'devuelve el index al clan guildpro
dim gi      as integer
dim gig     as integer

    r_rechazarpropuestadepaz = 0
    gi = userlist(userindex).guildindex
    
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan."
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan."
        exit function
    end if
    
    if trim$(guildpro) = vbnullstring then
        referror = "no has seleccionado ning�n clan."
        exit function
    end if

    gig = guildindex(guildpro)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_rechazarpropuestadepaz: " & gi & " acepta de " & guildpro)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)."
        exit function
    end if
    
    if not guilds(gi).haypropuesta(gig, relaciones_guild.paz) then
        referror = "no hay propuesta de paz del clan " & guildpro
        exit function
    end if
    
    call guilds(gi).anularpropuestas(gig)
    'avisamos al otro clan
    call guilds(gig).setguildnews(guilds(gi).guildname & " ha rechazado nuestra propuesta de paz. " & guilds(gig).getguildnews())
    r_rechazarpropuestadepaz = gig

end function

public function r_aceptarpropuestadealianza(byval userindex as integer, byref guildallie as string, byref referror as string) as integer
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

'el clan de userindex acepta la propuesta de paz de guildpaz, con quien esta en guerra
dim gi      as integer
dim gig     as integer

    r_aceptarpropuestadealianza = 0
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan."
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan."
        exit function
    end if
    
    if trim$(guildallie) = vbnullstring then
        referror = "no has seleccionado ning�n clan."
        exit function
    end if

    gig = guildindex(guildallie)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_aceptarpropuestadealianza: " & gi & " acepta de " & guildallie)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)."
        exit function
    end if

    if guilds(gi).getrelacion(gig) <> relaciones_guild.paz then
        referror = "no est�s en paz con el clan, solo puedes aceptar propuesas de alianzas con alguien que estes en paz."
        exit function
    end if
    
    if not guilds(gi).haypropuesta(gig, relaciones_guild.aliados) then
        referror = "no hay ninguna propuesta de alianza para aceptar."
        exit function
    end if

    call guilds(gi).anularpropuestas(gig)
    call guilds(gig).anularpropuestas(gi)
    call guilds(gi).setrelacion(gig, relaciones_guild.aliados)
    call guilds(gig).setrelacion(gi, relaciones_guild.aliados)
    
    r_aceptarpropuestadealianza = gig

end function


public function r_clangenerapropuesta(byval userindex as integer, byref otroclan as string, byval tipo as relaciones_guild, byref detalle as string, byref referror as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim otroclangi      as integer
dim gi              as integer

    r_clangenerapropuesta = false
    
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan."
        exit function
    end if
    
    otroclangi = guildindex(otroclan)
    
    if otroclangi = gi then
        referror = "no puedes declarar relaciones con tu propio clan."
        exit function
    end if
    
    if otroclangi <= 0 or otroclangi > cantidaddeclanes then
        referror = "el sistema de clanes esta inconsistente, el otro clan no existe."
        exit function
    end if
    
    if guilds(otroclangi).haypropuesta(gi, tipo) then
        referror = "ya hay propuesta de " & relacion2string(tipo) & " con " & otroclan
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan."
        exit function
    end if
    
    'de acuerdo al tipo procedemos validando las transiciones
    if tipo = relaciones_guild.paz then
        if guilds(gi).getrelacion(otroclangi) <> relaciones_guild.guerra then
            referror = "no est�s en guerra con " & otroclan
            exit function
        end if
    elseif tipo = relaciones_guild.guerra then
        'por ahora no hay propuestas de guerra
    elseif tipo = relaciones_guild.aliados then
        if guilds(gi).getrelacion(otroclangi) <> relaciones_guild.paz then
            referror = "para solicitar alianza no debes estar ni aliado ni en guerra con " & otroclan
            exit function
        end if
    end if
    
    call guilds(otroclangi).setpropuesta(tipo, gi, detalle)
    r_clangenerapropuesta = true

end function

public function r_verpropuesta(byval userindex as integer, byref otroguild as string, byval tipo as relaciones_guild, byref referror as string) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim otroclangi      as integer
dim gi              as integer
    
    r_verpropuesta = vbnullstring
    referror = vbnullstring
    
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan."
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan."
        exit function
    end if
    
    otroclangi = guildindex(otroguild)
    
    if not guilds(gi).haypropuesta(otroclangi, tipo) then
        referror = "no existe la propuesta solicitada."
        exit function
    end if
    
    r_verpropuesta = guilds(gi).getpropuesta(otroclangi, tipo)
    
end function

public function r_listadepropuestas(byval userindex as integer, byval tipo as relaciones_guild) as string()
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim gi  as integer
    dim i   as integer
    dim proposalcount as integer
    dim proposals() as string
    
    gi = userlist(userindex).guildindex
    
    if gi > 0 and gi <= cantidaddeclanes then
        with guilds(gi)
            proposalcount = .cantidadpropuestas(tipo)
            
            'resize array to contain all proposals
            if proposalcount > 0 then
                redim proposals(proposalcount - 1) as string
            else
                redim proposals(0) as string
            end if
            
            'store each guild name
            for i = 0 to proposalcount - 1
                proposals(i) = guilds(.iterador_proximapropuesta(tipo)).guildname
            next i
        end with
    end if
    
    r_listadepropuestas = proposals
end function

public sub a_rechazaraspirantechar(byref aspirante as string, byval guild as integer, byref detalles as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if instrb(aspirante, "\") <> 0 then
        aspirante = replace(aspirante, "\", "")
    end if
    if instrb(aspirante, "/") <> 0 then
        aspirante = replace(aspirante, "/", "")
    end if
    if instrb(aspirante, ".") <> 0 then
        aspirante = replace(aspirante, ".", "")
    end if
    call guilds(guild).informarrechazoenchar(aspirante, detalles)
end sub

public function a_obtenerrechazodechar(byref aspirante as string) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if instrb(aspirante, "\") <> 0 then
        aspirante = replace(aspirante, "\", "")
    end if
    if instrb(aspirante, "/") <> 0 then
        aspirante = replace(aspirante, "/", "")
    end if
    if instrb(aspirante, ".") <> 0 then
        aspirante = replace(aspirante, ".", "")
    end if
    a_obtenerrechazodechar = getvar(charpath & aspirante & ".chr", "guild", "motivorechazo")
    call writevar(charpath & aspirante & ".chr", "guild", "motivorechazo", vbnullstring)
end function

public function a_rechazaraspirante(byval userindex as integer, byref nombre as string, byref referror as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim gi              as integer
dim nroaspirante    as integer

    a_rechazaraspirante = false
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no perteneces a ning�n clan"
        exit function
    end if

    nroaspirante = guilds(gi).numerodeaspirante(nombre)

    if nroaspirante = 0 then
        referror = nombre & " no es aspirante a tu clan."
        exit function
    end if

    call guilds(gi).retiraraspirante(nombre, nroaspirante)
    referror = "fue rechazada tu solicitud de ingreso a " & guilds(gi).guildname
    a_rechazaraspirante = true

end function

public function a_detallesaspirante(byval userindex as integer, byref nombre as string) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim gi              as integer
    dim nroaspirante    as integer

    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        exit function
    end if
    
    nroaspirante = guilds(gi).numerodeaspirante(nombre)
    if nroaspirante > 0 then
        a_detallesaspirante = guilds(gi).detallessolicitudaspirante(nroaspirante)
    end if
    
end function

public sub senddetallespersonaje(byval userindex as integer, byval personaje as string)
 '***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    dim gi          as integer
    dim nroasp      as integer
    dim guildname   as string
    dim userfile    as clsinimanager
    dim miembro     as string
    dim guildactual as integer
    dim list()      as string
    dim i           as long
    
    on error goto error
    gi = userlist(userindex).guildindex
    
    personaje = ucase$(personaje)
    
    if gi <= 0 or gi > cantidaddeclanes then
        call protocol.writeconsolemsg(userindex, "no perteneces a ning�n clan.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        call protocol.writeconsolemsg(userindex, "no eres el l�der de tu clan.", fonttypenames.fonttype_info)
        exit sub
    end if
    
    if instrb(personaje, "\") <> 0 then
        personaje = replace$(personaje, "\", vbnullstring)
    end if
    if instrb(personaje, "/") <> 0 then
        personaje = replace$(personaje, "/", vbnullstring)
    end if
    if instrb(personaje, ".") <> 0 then
        personaje = replace$(personaje, ".", vbnullstring)
    end if
    
    nroasp = guilds(gi).numerodeaspirante(personaje)
    
    if nroasp = 0 then
        list = guilds(gi).getmemberlist()
        
        for i = 0 to ubound(list())
            if personaje = list(i) then exit for
        next i
        
        if i > ubound(list()) then
            call protocol.writeconsolemsg(userindex, "el personaje no es ni aspirante ni miembro del clan.", fonttypenames.fonttype_info)
            exit sub
        end if
    end if
    
    'ahora traemos la info
    
    set userfile = new clsinimanager
    
    with userfile
        .initialize (charpath & personaje & ".chr")
        
        ' get the character's current guild
        guildactual = val(.getvalue("guild", "guildindex"))
        if guildactual > 0 and guildactual <= cantidaddeclanes then
            guildname = "<" & guilds(guildactual).guildname & ">"
        else
            guildname = "ninguno"
        end if
        
        'get previous guilds
        miembro = .getvalue("guild", "miembro")
        if len(miembro) > 400 then
            miembro = ".." & right$(miembro, 400)
        end if
        
        call protocol.writecharacterinfo(userindex, personaje, .getvalue("init", "raza"), .getvalue("init", "clase"), _
                                .getvalue("init", "genero"), .getvalue("stats", "elv"), .getvalue("stats", "gld"), _
                                .getvalue("stats", "banco"), .getvalue("rep", "promedio"), .getvalue("guild", "pedidos"), _
                                guildname, miembro, .getvalue("facciones", "ejercitoreal"), .getvalue("facciones", "ejercitocaos"), _
                                .getvalue("facciones", "ciudmatados"), .getvalue("facciones", "crimmatados"))
    end with
    
    set userfile = nothing
    
    exit sub
error:
    set userfile = nothing
    if not (fileexist(charpath & personaje & ".chr", vbarchive)) then
        call logerror("el usuario " & userlist(userindex).name & " (" & userindex & _
                    " ) ha pedido los detalles del personaje " & personaje & " que no se encuentra.")
    else
        call logerror("[" & err.number & "] " & err.description & " en la rutina senddetallespersonaje, por el usuario " & _
                    userlist(userindex).name & " (" & userindex & " ), pidiendo informaci�n sobre el personaje " & personaje)
    end if
end sub

public function a_nuevoaspirante(byval userindex as integer, byref clan as string, byref solicitud as string, byref referror as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim viejosolicitado     as string
dim viejoguildindex     as integer
dim viejonroaspirante   as integer
dim nuevoguildindex     as integer

    a_nuevoaspirante = false

    if userlist(userindex).guildindex > 0 then
        referror = "ya perteneces a un clan, debes salir del mismo antes de solicitar ingresar a otro."
        exit function
    end if
    
    if esnewbie(userindex) then
        referror = "los newbies no tienen derecho a entrar a un clan."
        exit function
    end if

    nuevoguildindex = guildindex(clan)
    if nuevoguildindex = 0 then
        referror = "ese clan no existe, avise a un administrador."
        exit function
    end if
    
    if not m_estadopermiteentrar(userindex, nuevoguildindex) then
        referror = "t� no puedes entrar a un clan de alineaci�n " & alineacion2string(guilds(nuevoguildindex).alineacion)
        exit function
    end if

    if guilds(nuevoguildindex).cantidadaspirantes >= maxaspirantes then
        referror = "el clan tiene demasiados aspirantes. cont�ctate con un miembro para que procese las solicitudes."
        exit function
    end if

    viejosolicitado = getvar(charpath & userlist(userindex).name & ".chr", "guild", "aspirantea")

    if lenb(viejosolicitado) <> 0 then
        'borramos la vieja solicitud
        viejoguildindex = cint(viejosolicitado)
        if viejoguildindex <> 0 then
            viejonroaspirante = guilds(viejoguildindex).numerodeaspirante(userlist(userindex).name)
            if viejonroaspirante > 0 then
                call guilds(viejoguildindex).retiraraspirante(userlist(userindex).name, viejonroaspirante)
            end if
        else
            'referror = "inconsistencia en los clanes, avise a un administrador"
            'exit function
        end if
    end if
    
    call guilds(nuevoguildindex).nuevoaspirante(userlist(userindex).name, solicitud)
    a_nuevoaspirante = true
end function

public function a_aceptaraspirante(byval userindex as integer, byref aspirante as string, byref referror as string) as boolean
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

dim gi              as integer
dim nroaspirante    as integer
dim aspiranteui     as integer

    'un pj ingresa al clan :d

    a_aceptaraspirante = false
    
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no perteneces a ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    nroaspirante = guilds(gi).numerodeaspirante(aspirante)
    
    if nroaspirante = 0 then
        referror = "el pj no es aspirante al clan."
        exit function
    end if
    
    aspiranteui = nameindex(aspirante)
    if aspiranteui > 0 then
        'pj online
        if not m_estadopermiteentrar(aspiranteui, gi) then
            referror = aspirante & " no puede entrar a un clan de alineaci�n " & alineacion2string(guilds(gi).alineacion)
            call guilds(gi).retiraraspirante(aspirante, nroaspirante)
            exit function
        elseif not userlist(aspiranteui).guildindex = 0 then
            referror = aspirante & " ya es parte de otro clan."
            call guilds(gi).retiraraspirante(aspirante, nroaspirante)
            exit function
        end if
    else
        if not m_estadopermiteentrarchar(aspirante, gi) then
            referror = aspirante & " no puede entrar a un clan de alineaci�n " & alineacion2string(guilds(gi).alineacion)
            call guilds(gi).retiraraspirante(aspirante, nroaspirante)
            exit function
        elseif getguildindexfromchar(aspirante) then
            referror = aspirante & " ya es parte de otro clan."
            call guilds(gi).retiraraspirante(aspirante, nroaspirante)
            exit function
        end if
    end if
    'el pj es aspirante al clan y puede entrar
    
    call guilds(gi).retiraraspirante(aspirante, nroaspirante)
    call guilds(gi).aceptarnuevomiembro(aspirante)
    
    ' if player is online, update tag
    if aspiranteui > 0 then
        call refreshcharstatus(aspiranteui)
    end if
    
    a_aceptaraspirante = true
end function

public function guildname(byval guildindex as integer) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if guildindex <= 0 or guildindex > cantidaddeclanes then _
        exit function
    
    guildname = guilds(guildindex).guildname
end function

public function guildleader(byval guildindex as integer) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if guildindex <= 0 or guildindex > cantidaddeclanes then _
        exit function
    
    guildleader = guilds(guildindex).getleader
end function

public function guildalignment(byval guildindex as integer) as string
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

    if guildindex <= 0 or guildindex > cantidaddeclanes then _
        exit function
    
    guildalignment = alineacion2string(guilds(guildindex).alineacion)
end function

public function guildfounder(byval guildindex as integer) as string
'***************************************************
'autor: zama
'returns the guild founder's name
'last modification: 25/03/2009
'***************************************************
    if guildindex <= 0 or guildindex > cantidaddeclanes then _
        exit function
    
    guildfounder = guilds(guildindex).fundador
end function
