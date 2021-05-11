attribute vb_name = "modguilds"
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

private const ordenarlistadeclanes = true
'true si se envia la lista ordenada por alineacion

public cantidaddeclanes as integer
'cantidad actual de clanes en el servidor

public guilds()         as clsclan
'array global de guilds, se indexa por userlist().guildindex

public const max_guilds as integer = 1000
'cantidad maxima de guilds en el servidor

public const cantidadmaximacodex as byte = 8
'cantidad maxima de codecs que se pueden definir

public const maxaspirantes as byte = 10
'cantidad maxima de aspirantes que puede tener un clan acumulados a la vez

public const maxantifaccion as byte = 5
'puntos maximos de antifaccion que un clan tolera antes de ser cambiada su alineacion

public gmsescuchando as new collection

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
dim nuevol  as boolean
dim nuevaa  as boolean
dim news    as string

    if guildindex > cantidaddeclanes or guildindex <= 0 then exit function 'x las dudas...
    if m_estadopermiteentrar(userindex, guildindex) then
        call guilds(guildindex).conectarmiembro(userindex)
        userlist(userindex).guildindex = guildindex
        m_conectarmiembroaclan = true
    else
        m_conectarmiembroaclan = m_validarpermanencia(userindex, true, nuevaa, nuevol)
        if nuevol then news = "el clan tiene nuevo l�der."
        if nuevaa then news = news & "el clan tiene nueva alineaci�n."
        if nuevol or nuevaa then call guilds(guildindex).setguildnews(news)
    end if

end function


public function m_validarpermanencia(byval userindex as integer, byval sumaantifaccion as boolean, byref cambioalineacion as boolean, byref cambiolider as boolean) as boolean
dim guildindex  as integer
dim ml          as string
dim m           as string
dim ui          as integer
dim sale        as boolean
dim i           as integer

    m_validarpermanencia = true
    guildindex = userlist(userindex).guildindex
    if guildindex > cantidaddeclanes and guildindex <= 0 then exit function
    
    if not m_estadopermiteentrar(userindex, guildindex) then
    
        call logclanes(userlist(userindex).name & " de " & guilds(guildindex).guildname & " es expulsado en validar permanencia")
    
        m_validarpermanencia = false
        if sumaantifaccion then guilds(guildindex).puntosantifaccion = guilds(guildindex).puntosantifaccion + 1
        
        cambioalineacion = (m_esguildfounder(userlist(userindex).name, guildindex) or guilds(guildindex).puntosantifaccion = maxantifaccion)
        
        call logclanes(userlist(userindex).name & " de " & guilds(guildindex).guildname & iif(cambioalineacion, " si ", " no ") & "provoca cambio de alinaecion. maxant:" & (guilds(guildindex).puntosantifaccion = maxantifaccion) & ", guildfou:" & m_esguildfounder(userlist(userindex).name, guildindex))
        
        if cambioalineacion then
            'aca tenemos un problema, el fundador acaba de cambiar el rumbo del clan o nos zarpamos de antifacciones
            'tenemos que resetear el lider, revisar si el lider permanece y si no asignarle liderazgo al fundador

            call guilds(guildindex).cambiaralineacion(alineacion_neutro)
            guilds(guildindex).puntosantifaccion = maxantifaccion
            'para la nueva alineacion, hay que revisar a todos los pjs!

            'uso getmemberlist y no los iteradores pq voy a rajar gente y puedo alterar
            'internamente al iterador en el proceso
            cambiolider = false
            i = 1
            ml = guilds(guildindex).getmemberlist(",")
            m = readfield(i, ml, asc(","))
            while m <> vbnullstring

                'vamos a violar un poco de capas..
                ui = nameindex(m)
                if ui > 0 then
                    sale = not m_estadopermiteentrar(ui, guildindex)
                else
                    sale = not m_estadopermiteentrarchar(m, guildindex)
                end if

                if sale then
                    if m_esguildfounder(m, guildindex) then 'hay que sacarlo de las armadas
                        if ui > 0 then
                            userlist(ui).faccion.fuerzascaos = 0
                            userlist(ui).faccion.armadareal = 0
                            userlist(ui).faccion.reenlistadas = 200
                        else
                            if fileexist(charpath & m & ".chr") then
                                call writevar(charpath & m & ".chr", "facciones", "ejercitocaos", 0)
                                call writevar(charpath & m & ".chr", "facciones", "armadareal", 0)
                                call writevar(charpath & m & ".chr", "facciones", "reenlistadas", 200)
                            end if
                        end if
                        m_validarpermanencia = true
                    else    'sale si no es guildfounder
                        if m_esguildleader(m, guildindex) then
                            'pierde el liderazgo
                            cambiolider = true
                            call guilds(guildindex).setleader(guilds(guildindex).fundador)
                        end if

                        call m_echarmiembrodeclan(-1, m)
                    end if
                end if
                i = i + 1
                m = readfield(i, ml, asc(","))
            wend
        else
            'no se va el fundador, el peor caso es que se vaya el lider
            
            'if m_esguildleader(userlist(userindex).name, guildindex) then
            '    call logclanes("se transfiere el liderazgo de: " & guilds(guildindex).guildname & " a " & guilds(guildindex).fundador)
            '    call guilds(guildindex).setleader(guilds(guildindex).fundador)  'transferimos el lideraztgo
            'end if
            call m_echarmiembrodeclan(-1, userlist(userindex).name)   'y lo echamos
        end if
    end if
    

end function

public sub m_desconectarmiembrodelclan(byval userindex as integer, byval guildindex as integer)
    if userlist(userindex).guildindex > cantidaddeclanes then exit sub
    call guilds(guildindex).desconectarmiembro(userindex)
end sub

private function m_esguildleader(byref pj as string, byval guildindex as integer) as boolean
    m_esguildleader = (ucase$(pj) = ucase$(trim$(guilds(guildindex).getleader)))
end function

private function m_esguildfounder(byref pj as string, byval guildindex as integer) as boolean
    m_esguildfounder = (ucase$(pj) = ucase$(trim$(guilds(guildindex).fundador)))
end function


'public function getleader(byval guildindex as integer) as string
'    getleader = vbnullstring
'
'    if guildindex <= 0 then exit function
'    getleader = guilds(guildindex).getleader()
'end function

public function m_echarmiembrodeclan(byval expulsador as integer, byval expulsado as string) as integer
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
                if m_esguildleader(expulsado, gi) then guilds(gi).setleader (guilds(gi).fundador)
                call guilds(gi).desconectarmiembro(userindex)
                call guilds(gi).expulsarmiembro(expulsado)
                call logclanes(expulsado & " ha sido expulsado de " & guilds(gi).guildname & " expulsador = " & expulsador)
                userlist(userindex).guildindex = 0
                call warpuserchar(userindex, userlist(userindex).pos.map, userlist(userindex).pos.x, userlist(userindex).pos.y)
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
                if m_esguildleader(expulsado, gi) then guilds(gi).setleader (guilds(gi).fundador)
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
dim gi as integer

    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then exit sub
    
    if not m_esguildleader(userlist(userindex).name, gi) then exit sub
    
    call guilds(gi).seturl(web)
    
end sub


public sub actualizarcodexydesc(byref datos as string, byval guildindex as integer)
dim cantcodex       as integer
dim i               as integer

    if guildindex = 0 then exit sub
    call guilds(guildindex).setdesc(readfield(1, datos, asc("�")))
    cantcodex = cint(readfield(2, datos, asc("�")))
    for i = 1 to cantcodex
        call guilds(guildindex).setcodex(i, readfield(2 + i, datos, asc("�")))
    next i
    for i = cantcodex + 1 to cantidadmaximacodex
        call guilds(guildindex).setcodex(i, vbnullstring)
    next i

end sub

public sub actualizarnoticias(byval userindex as integer, byref datos as string)
dim gi              as integer

    gi = userlist(userindex).guildindex
    
    if gi <= 0 or gi > cantidaddeclanes then exit sub
    
    if not m_esguildleader(userlist(userindex).name, gi) then exit sub
    
    call guilds(gi).setguildnews(datos)
        
end sub

public function crearnuevoclan(byref guildinfo as string, byval fundadorindex as integer, byval alineacion as alineacion_guild, byref referror as string) as boolean
dim guildname       as string
dim descripcion     as string
dim url             as string
dim codex()         as string
dim cantcodex       as integer
dim i               as integer
dim dummystring     as string

    crearnuevoclan = false
    if not puedefundarunclan(fundadorindex, alineacion, dummystring) then
        referror = dummystring
        exit function
    end if

    guildname = trim$(readfield(2, guildinfo, asc("�")))

    if guildname = vbnullstring or not guildnamevalido(guildname) then
        referror = "nombre de clan inv�lido."
        exit function
    end if
    
    if yaexiste(guildname) then
        referror = "ya existe un clan con ese nombre."
        exit function
    end if

    descripcion = readfield(1, guildinfo, asc("�"))
    url = readfield(3, guildinfo, asc("�"))
    cantcodex = cint(readfield(4, guildinfo, asc("�")))

    if cantcodex > 0 then
        redim codex(1 to cantcodex) as string
        for i = 1 to cantcodex
            codex(i) = readfield(4 + i, guildinfo, asc("�"))
        next i
    end if

    'tenemos todo para fundar ya
    if cantidaddeclanes < ubound(guilds) then
        cantidaddeclanes = cantidaddeclanes + 1
        'redim preserve guilds(1 to cantidaddeclanes) as clsclan

        'constructor custom de la clase clan
        set guilds(cantidaddeclanes) = new clsclan
        call guilds(cantidaddeclanes).inicializar(guildname, cantidaddeclanes, alineacion)
        
        'damos de alta al clan como nuevo inicializando sus archivos
        call guilds(cantidaddeclanes).inicializarnuevoclan(userlist(fundadorindex).name)
        
        'seteamos codex y descripcion
        for i = 1 to cantcodex
            call guilds(cantidaddeclanes).setcodex(i, codex(i))
        next i
        call guilds(cantidaddeclanes).setdesc(descripcion)
        call guilds(cantidaddeclanes).setguildnews("clan creado con alineaci�n : " & alineacion2string(alineacion))
        call guilds(cantidaddeclanes).setleader(userlist(fundadorindex).name)
        call guilds(cantidaddeclanes).seturl(url)
        
        '"conectamos" al nuevo miembro a la lista de la clase
        call guilds(cantidaddeclanes).aceptarnuevomiembro(userlist(fundadorindex).name)
        call guilds(cantidaddeclanes).conectarmiembro(fundadorindex)
        userlist(fundadorindex).guildindex = cantidaddeclanes
        call warpuserchar(fundadorindex, userlist(fundadorindex).pos.map, userlist(fundadorindex).pos.x, userlist(fundadorindex).pos.y, false)
        
        for i = 1 to cantidaddeclanes - 1
            call guilds(i).procesarfundaciondeotroclan
        next i
    else
        referror = "no hay mas slots para fundar clanes. consulte a un administrador."
        exit function
    end if
    
    crearnuevoclan = true
    
end function


public sub sendguildnews(byval userindex as integer)
dim news            as string
dim enemiescount    as integer
dim alliescount     as integer
dim guildindex      as integer
dim i               as integer


    guildindex = userlist(userindex).guildindex
    if guildindex = 0 then exit sub
    
    news = "guildne" & guilds(guildindex).getguildnews & "�"

    enemiescount = guilds(guildindex).cantidadenemys
    news = news & cstr(enemiescount) & "�"
    i = guilds(guildindex).iterador_proximarelacion(guerra)
    while i > 0
        news = news & guilds(i).guildname & "�"
        i = guilds(guildindex).iterador_proximarelacion(guerra)
    wend
    alliescount = guilds(guildindex).cantidadallies
    news = news & cstr(alliescount) & "�"
    i = guilds(guildindex).iterador_proximarelacion(aliados)
    while i > 0
        news = news & guilds(i).guildname & "�"
        i = guilds(guildindex).iterador_proximarelacion(aliados)
    wend

    call senddata(sendtarget.toindex, userindex, 0, news)

    if guilds(guildindex).eleccionesabiertas then
        call senddata(sendtarget.toindex, userindex, 0, "||hoy es la votacion para elegir un nuevo l�der para el clan!!." & fonttype_guild)
        call senddata(sendtarget.toindex, userindex, 0, "||la eleccion durara 24 horas, se puede votar a cualquier miembro del clan." & fonttype_guild)
        call senddata(sendtarget.toindex, userindex, 0, "||para votar escribe /voto nickname." & fonttype_guild)
        call senddata(sendtarget.toindex, userindex, 0, "||solo se computara un voto por miembro. tu voto no puede ser cambiado." & fonttype_guild)
    end if

end sub

public function m_puedesalirdeclan(byref nombre as string, byval guildindex as integer, byval quienloechaui as integer) as boolean
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
    if userlist(quienloechaui).flags.privilegios = playertype.user then
        if not m_esguildleader(ucase$(userlist(quienloechaui).name), guildindex) then
            if ucase$(userlist(quienloechaui).name) <> ucase$(nombre) then      'si no sale voluntariamente...
                exit function
            end if
        end if
    end if

    m_puedesalirdeclan = ucase$(guilds(guildindex).fundador) <> ucase$(nombre)

end function

public function puedefundarunclan(byval userindex as integer, byval alineacion as alineacion_guild, byref referror as string) as boolean

    puedefundarunclan = false
    if userlist(userindex).guildindex > 0 then
        referror = "ya perteneces a un clan, no puedes fundar otro"
        exit function
    end if
    
    if userlist(userindex).stats.elv < 25 or userlist(userindex).stats.userskills(eskill.liderazgo) < 90 then
        referror = "para fundar un clan debes ser nivel 25 y tener 90 en liderazgo."
        exit function
    end if
    
    select case alineacion
        case alineacion_guild.alineacion_armada
            if userlist(userindex).faccion.armadareal <> 1 then
                referror = "para fundar un clan real debes ser miembro de la armada."
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
                referror = "para fundar un clan del mal debes pertenecer a la legi�n oscura"
                exit function
            end if
        case alineacion_guild.alineacion_master
            if userlist(userindex).flags.privilegios < playertype.dios then
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
dim promedio    as long
dim elv         as integer
dim f           as byte

    m_estadopermiteentrarchar = false
    
    personaje = replace(personaje, "\", vbnullstring)
    personaje = replace(personaje, "/", vbnullstring)
    personaje = replace(personaje, ".", vbnullstring)
    
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
    select case s
        case "neutro"
            string2alineacion = alineacion_neutro
        case "legi�n oscura"
            string2alineacion = alineacion_legion
        case "armada real"
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
    select case alineacion
        case alineacion_guild.alineacion_neutro
            alineacion2string = "neutro"
        case alineacion_guild.alineacion_legion
            alineacion2string = "legi�n oscura"
        case alineacion_guild.alineacion_armada
            alineacion2string = "armada real"
        case alineacion_guild.alineacion_master
            alineacion2string = "game masters"
        case alineacion_guild.alineacion_ciuda
            alineacion2string = "legal"
        case alineacion_guild.alineacion_criminal
            alineacion2string = "criminal"
    end select
end function

public function relacion2string(byval relacion as relaciones_guild) as string
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
    select case ucase$(trim$(s))
        case vbnullstring, "p"
            string2relacion = paz
        case "g"
            string2relacion = guerra
        case "a"
            string2relacion = aliados
        case else
            string2relacion = paz
    end select
end function

private function guildnamevalido(byval cad as string) as boolean
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
dim i   as integer

yaexiste = false
guildname = ucase$(guildname)

for i = 1 to cantidaddeclanes
    yaexiste = (ucase$(guilds(i).guildname) = guildname)
    if yaexiste then exit function
next i



end function

public function v_abrirelecciones(byval userindex as integer, byref referror as string) as boolean
dim guildindex      as integer

    v_abrirelecciones = false
    guildindex = userlist(userindex).guildindex
    
    if guildindex = 0 or guildindex > cantidaddeclanes then
        referror = "tu no perteneces a ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, guildindex) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    if guilds(guildindex).eleccionesabiertas then
        referror = "las elecciones ya est�n abiertas"
        exit function
    end if
    
    v_abrirelecciones = true
    call guilds(guildindex).abrirelecciones
    
end function

public function v_usuariovota(byval userindex as integer, byref votado as string, byref referror as string) as boolean
dim guildindex      as integer

    v_usuariovota = false
    guildindex = userlist(userindex).guildindex
    
    if guildindex = 0 or guildindex > cantidaddeclanes then
        referror = "tu no perteneces a ning�n clan"
        exit function
    end if

    if not guilds(guildindex).eleccionesabiertas then
        referror = "no hay elecciones abiertas en tu clan."
        exit function
    end if
    
    if instr(1, guilds(guildindex).getmemberlist(","), votado, vbtextcompare) <= 0 then
        referror = votado & " no pertenece al clan"
        exit function
    end if

    if guilds(guildindex).yavoto(userlist(userindex).name) then
        referror = "ya has votado, no puedes cambiar tu voto"
        exit function
    end if
    
    call guilds(guildindex).contabilizarvoto(userlist(userindex).name, votado)
    v_usuariovota = true

end function

public sub v_rutinaelecciones()
dim i       as integer

on error goto errh
    call senddata(sendtarget.toall, 0, 0, "||servidor> revisando elecciones" & fonttype_server)
    for i = 1 to cantidaddeclanes
        if not guilds(i) is nothing then
            if guilds(i).revisarelecciones then
                call senddata(sendtarget.toall, 0, 0, "||        > " & guilds(i).getleader & " es el nuevo lider de " & guilds(i).guildname & "!" & fonttype_server)
            end if
        end if
proximo:
    next i
    call senddata(sendtarget.toall, 0, 0, "||servidor> elecciones revisadas" & fonttype_server)
exit sub
errh:
    call logerror("modguilds.v_rutinaelecciones():" & err.description)
    resume proximo
end sub

private function getguildindexfromchar(byref playername as string) as integer
'aca si que vamos a violar las capas deliveradamente ya que
'visual basic no permite declarar metodos de clase
dim i       as integer
dim temps   as string
    playername = replace(playername, "\", vbnullstring)
    playername = replace(playername, "/", vbnullstring)
    playername = replace(playername, ".", vbnullstring)
    temps = getvar(charpath & playername & ".chr", "guild", "guildindex")
    if isnumeric(temps) then
        getguildindexfromchar = cint(temps)
    else
        getguildindexfromchar = 0
    end if
end function

public function guildindex(byref guildname as string) as integer
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
dim i as integer
    
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        i = guilds(guildindex).m_iterador_proximouserindex
        while i > 0
            'no mostramos dioses y admins
            if i <> userindex and (userlist(i).flags.privilegios < playertype.dios or userlist(userindex).flags.privilegios >= playertype.dios) then _
                m_listademiembrosonline = m_listademiembrosonline & userlist(i).name & ","
            i = guilds(guildindex).m_iterador_proximouserindex
        wend
    end if
    if len(m_listademiembrosonline) > 0 then
        m_listademiembrosonline = left$(m_listademiembrosonline, len(m_listademiembrosonline) - 1)
    end if
end function

public function sendguildslist(byval userindex as integer) as string
dim tstr as string
dim tint as integer

    tstr = cantidaddeclanes & ","
    for tint = 1 to cantidaddeclanes
        tstr = tstr & guilds(tint).guildname & ","
    next tint
    sendguildslist = tstr
end function

public function sendguilddetails(byref guildname as string) as string
dim tstr    as string
dim gi      as integer
dim i       as integer

    gi = guildindex(guildname)
    if gi = 0 then exit function
    
    tstr = guilds(gi).guildname & "�"
    tstr = tstr & guilds(gi).fundador & "�"
    tstr = tstr & guilds(gi).getfechafundacion & "�"
    tstr = tstr & guilds(gi).getleader & "�"
    tstr = tstr & guilds(gi).geturl & "�"
    tstr = tstr & cstr(guilds(gi).cantidaddemiembros) & "�"
    tstr = tstr & iif(guilds(gi).eleccionesabiertas, "elecciones abiertas", "elecciones cerradas") & "�"
    tstr = tstr & alineacion2string(guilds(gi).alineacion) & "�"
    tstr = tstr & guilds(gi).cantidadenemys & "�"
    tstr = tstr & guilds(gi).cantidadallies & "�"
    tstr = tstr & guilds(gi).puntosantifaccion & "/" & cstr(maxantifaccion) & "�"
    for i = 1 to cantidadmaximacodex
        tstr = tstr & guilds(gi).getcodex(i) & "�"
    next i
    tstr = tstr & guilds(gi).getdesc
    
    sendguilddetails = tstr
end function


public function sendguildleaderinfo(byval userindex as integer) as string
dim tstr    as string
dim tint    as integer
dim cantasp as integer
dim gi      as integer

    sendguildleaderinfo = vbnullstring
    gi = userlist(userindex).guildindex
    
    if gi <= 0 or gi > cantidaddeclanes then
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then exit function
    
    '<-------lista de guilds ---------->
    tstr = cantidaddeclanes & "�"
    
    for tint = 1 to cantidaddeclanes
        tstr = tstr & guilds(tint).guildname & "�"
    next tint
    
    '<-------lista de miembros ---------->
    tstr = tstr & guilds(gi).cantidaddemiembros & "�"
    tstr = tstr & guilds(gi).getmemberlist("�") & "�"
    
    '<------- guild news -------->
    tstr = tstr & replace(guilds(gi).getguildnews, vbcrlf, "�") & "�"
    
    '<------- solicitudes ------->
    cantasp = guilds(gi).cantidadaspirantes()
    tstr = tstr & cantasp & "�"
    if cantasp > 0 then
        tstr = tstr & guilds(gi).getaspirantes("�") & "�"
    end if

    sendguildleaderinfo = tstr

end function


public function m_iterador_proximouserindex(byval guildindex as integer) as integer
    'itera sobre los onlinemembers
    m_iterador_proximouserindex = 0
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        m_iterador_proximouserindex = guilds(guildindex).m_iterador_proximouserindex()
    end if
end function

public function iterador_proximogm(byval guildindex as integer) as integer
    'itera sobre los gms escuchando este clan
    iterador_proximogm = 0
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        iterador_proximogm = guilds(guildindex).iterador_proximogm()
    end if
end function

public function r_iterador_proximapropuesta(byval guildindex as integer, byval tipo as relaciones_guild) as integer
    'itera sobre las propuestas
    r_iterador_proximapropuesta = 0
    if guildindex > 0 and guildindex <= cantidaddeclanes then
        r_iterador_proximapropuesta = guilds(guildindex).iterador_proximapropuesta(tipo)
    end if
end function


public function gmescuchaclan(byval userindex as integer, byval guildname as string) as integer
dim gi as integer
'devuelve el guildindex
    gi = guildindex(guildname)
    if gi > 0 then
        call guilds(gi).conectargm(userindex)
        call senddata(sendtarget.toindex, userindex, 0, "||conectado a : " & guildname & fonttype_guild)
        gmescuchaclan = gi
        userlist(userindex).escucheclan = gi
    else
        call senddata(sendtarget.toindex, userindex, 0, "||error, el clan no existe" & fonttype_guild)
        gmescuchaclan = 0
    end if
    
end function

public sub gmdejadeescucharclan(byval userindex as integer, byval guildindex as integer)
'el index lo tengo que tener de cuando me puse a escuchar
    userlist(userindex).escucheclan = 0
    call guilds(guildindex).desconectargm(userindex)
end sub
public function r_declararguerra(byval userindex as integer, byref guildguerra as string, byref referror as string) as integer
dim gi  as integer
dim gig as integer

    r_declararguerra = 0
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    if trim$(guildguerra) = vbnullstring then
        referror = "no has seleccionado ning�n clan"
        exit function
    end if

    gig = guildindex(guildguerra)
    
    if gi = gig then
        referror = "no puedes declarar la guerra a tu mismo clan"
        exit function
    end if

    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_declararguerra: " & gi & " declara a " & guildguerra)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)"
        exit function
    end if

    call guilds(gi).anularpropuestas(gig)
    call guilds(gig).anularpropuestas(gi)
    call guilds(gi).setrelacion(gig, guerra)
    call guilds(gig).setrelacion(gi, guerra)

    r_declararguerra = gig

end function


public function r_aceptarpropuestadepaz(byval userindex as integer, byref guildpaz as string, byref referror as string) as integer
'el clan de userindex acepta la propuesta de paz de guildpaz, con quien esta en guerra
dim gi      as integer
dim gig     as integer

    r_aceptarpropuestadepaz = 0
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    if trim$(guildpaz) = vbnullstring then
        referror = "no has seleccionado ning�n clan"
        exit function
    end if

    gig = guildindex(guildpaz)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_aceptarpropuestadepaz: " & gi & " acepta de " & guildpaz)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)"
        exit function
    end if

    if guilds(gi).getrelacion(gig) <> guerra then
        referror = "no est�s en guerra con ese clan"
        exit function
    end if
    
    if not guilds(gi).haypropuesta(gig, paz) then
        referror = "no hay ninguna propuesta de paz para aceptar"
        exit function
    end if

    call guilds(gi).anularpropuestas(gig)
    call guilds(gig).anularpropuestas(gi)
    call guilds(gi).setrelacion(gig, paz)
    call guilds(gig).setrelacion(gi, paz)
    
    r_aceptarpropuestadepaz = gig

end function

public function r_rechazarpropuestadealianza(byval userindex as integer, byref guildpro as string, byref referror as string) as integer
'devuelve el index al clan guildpro
dim gi      as integer
dim gig     as integer

    r_rechazarpropuestadealianza = 0
    gi = userlist(userindex).guildindex
    
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    if trim$(guildpro) = vbnullstring then
        referror = "no has seleccionado ning�n clan"
        exit function
    end if

    gig = guildindex(guildpro)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_rechazarpropuestadealianza: " & gi & " acepta de " & guildpro)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)"
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
'devuelve el index al clan guildpro
dim gi      as integer
dim gig     as integer

    r_rechazarpropuestadepaz = 0
    gi = userlist(userindex).guildindex
    
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    if trim$(guildpro) = vbnullstring then
        referror = "no has seleccionado ning�n clan"
        exit function
    end if

    gig = guildindex(guildpro)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_rechazarpropuestadepaz: " & gi & " acepta de " & guildpro)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)"
        exit function
    end if
    
    if not guilds(gi).haypropuesta(gig, paz) then
        referror = "no hay propuesta de paz del clan " & guildpro
        exit function
    end if
    
    call guilds(gi).anularpropuestas(gig)
    'avisamos al otro clan
    call guilds(gig).setguildnews(guilds(gi).guildname & " ha rechazado nuestra propuesta de paz. " & guilds(gig).getguildnews())
    r_rechazarpropuestadepaz = gig

end function


public function r_aceptarpropuestadealianza(byval userindex as integer, byref guildallie as string, byref referror as string) as integer
'el clan de userindex acepta la propuesta de paz de guildpaz, con quien esta en guerra
dim gi      as integer
dim gig     as integer

    r_aceptarpropuestadealianza = 0
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    if trim$(guildallie) = vbnullstring then
        referror = "no has seleccionado ning�n clan"
        exit function
    end if

    gig = guildindex(guildallie)
    
    if gig < 1 or gig > cantidaddeclanes then
        call logerror("modguilds.r_aceptarpropuestadealianza: " & gi & " acepta de " & guildallie)
        referror = "inconsistencia en el sistema de clanes. avise a un administrador (gig fuera de rango)"
        exit function
    end if

    if guilds(gi).getrelacion(gig) <> paz then
        referror = "no est�s en paz con el clan, solo puedes aceptar propuesas de alianzas con alguien que estes en paz."
        exit function
    end if
    
    if not guilds(gi).haypropuesta(gig, aliados) then
        referror = "no hay ninguna propuesta de alianza para aceptar."
        exit function
    end if

    call guilds(gi).anularpropuestas(gig)
    call guilds(gig).anularpropuestas(gi)
    call guilds(gi).setrelacion(gig, aliados)
    call guilds(gig).setrelacion(gi, aliados)
    
    r_aceptarpropuestadealianza = gig

end function


public function r_clangenerapropuesta(byval userindex as integer, byref otroclan as string, byval tipo as relaciones_guild, byref detalle as string, byref referror as string) as boolean
dim otroclangi      as integer
dim gi              as integer

    r_clangenerapropuesta = false
    
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan"
        exit function
    end if
    
    otroclangi = guildindex(otroclan)
    
    if otroclangi = gi then
        referror = "no puedes declarar relaciones con tu propio clan"
        exit function
    end if
    
    if otroclangi <= 0 or otroclangi > cantidaddeclanes then
        referror = "el sistema de clanes esta inconsistente, el otro clan no existe!"
        exit function
    end if
    
    if guilds(otroclangi).haypropuesta(gi, tipo) then
        referror = "ya hay propuesta de " & relacion2string(tipo) & " con " & otroclan
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    'de acuerdo al tipo procedemos validando las transiciones
    if tipo = paz then
        if guilds(gi).getrelacion(otroclangi) <> guerra then
            referror = "no est�s en guerra con " & otroclan
            exit function
        end if
    elseif tipo = guerra then
        'por ahora no hay propuestas de guerra
    elseif tipo = aliados then
        if guilds(gi).getrelacion(otroclangi) <> paz then
            referror = "para solicitar alianza no debes estar ni aliado ni en guerra con " & otroclan
            exit function
        end if
    end if
    
    call guilds(otroclangi).setpropuesta(tipo, gi, detalle)
    r_clangenerapropuesta = true

end function

public function r_verpropuesta(byval userindex as integer, byref otroguild as string, byval tipo as relaciones_guild, byref referror as string) as string
dim otroclangi      as integer
dim gi              as integer
    
    r_verpropuesta = vbnullstring
    referror = vbnullstring
    
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no eres miembro de ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    otroclangi = guildindex(otroguild)
    
    if not guilds(gi).haypropuesta(otroclangi, tipo) then
        referror = "no existe la propuesta solicitada"
        exit function
    end if
    
    r_verpropuesta = guilds(gi).getpropuesta(otroclangi, tipo)
    
end function

public function r_listadepropuestas(byval userindex as integer, byval tipo as relaciones_guild) as string
dim gi  as integer
dim i   as integer


    gi = userlist(userindex).guildindex
    if gi > 0 and gi <= cantidaddeclanes then
        i = guilds(gi).iterador_proximapropuesta(tipo)
        while i > 0
            r_listadepropuestas = r_listadepropuestas & guilds(i).guildname & ","
            i = guilds(gi).iterador_proximapropuesta(tipo)
        wend
        if len(r_listadepropuestas) > 0 then
            r_listadepropuestas = left$(r_listadepropuestas, len(r_listadepropuestas) - 1)
        end if
    end if

end function

public function r_cantidaddepropuestas(byval userindex as integer, byval tipo as relaciones_guild) as integer
dim gi as integer
    gi = userlist(userindex).guildindex
    if gi > 0 and gi <= cantidaddeclanes then
        r_cantidaddepropuestas = guilds(gi).cantidadpropuestas(tipo)
    end if
end function

public sub a_rechazaraspirantechar(byref aspirante as string, byval guild as integer, byref detalles as string)
    aspirante = replace(aspirante, "\", "")
    aspirante = replace(aspirante, "/", "")
    aspirante = replace(aspirante, ".", "")
    call guilds(guild).informarrechazoenchar(aspirante, detalles)
end sub

public function a_obtenerrechazodechar(byref aspirante as string) as string
    aspirante = replace(aspirante, "\", "")
    aspirante = replace(aspirante, "/", "")
    aspirante = replace(aspirante, ".", "")
    a_obtenerrechazodechar = getvar(charpath & aspirante & ".chr", "guild", "motivorechazo")
    call writevar(charpath & aspirante & ".chr", "guild", "motivorechazo", vbnullstring)
end function

public function a_rechazaraspirante(byval userindex as integer, byref nombre as string, byref motivo as string, byref referror as string) as boolean
dim gi              as integer
dim ui              as integer
dim nroaspirante    as integer

    a_rechazaraspirante = false
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no perteneces a ning�n clan"
        exit function
    end if

    nroaspirante = guilds(gi).numerodeaspirante(nombre)

    if nroaspirante = 0 then
        referror = nombre & " no es aspirante a tu clan"
        exit function
    end if

    call guilds(gi).retiraraspirante(nombre, nroaspirante)
    referror = "fue rechazada tu solicitud de ingreso a " & guilds(gi).guildname
    a_rechazaraspirante = true

end function

public function a_detallesaspirante(byval userindex as integer, byref nombre as string) as string
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

public function a_detallespersonaje(byval userindex as integer, byref personaje as string, byref referror as string) as string
dim gi          as integer
dim nroasp      as integer
dim tstr        as string
dim userfile    as string
dim peticiones  as string
dim miembro     as string
dim guildactual as integer



    a_detallespersonaje = vbnullstring
    
    gi = userlist(userindex).guildindex
    if gi <= 0 or gi > cantidaddeclanes then
        referror = "no perteneces a ning�n clan"
        exit function
    end if
    
    if not m_esguildleader(userlist(userindex).name, gi) then
        referror = "no eres el l�der de tu clan"
        exit function
    end if
    
    personaje = replace(personaje, "\", vbnullstring)
    personaje = replace(personaje, "/", vbnullstring)
    personaje = replace(personaje, ".", vbnullstring)
    
    nroasp = guilds(gi).numerodeaspirante(personaje)
    
    if nroasp = 0 then
        if instr(1, guilds(gi).getmemberlist("."), personaje, vbtextcompare) <= 0 then
            referror = "el personaje no es ni aspirante ni miembro del clan"
            exit function
        end if
    end if
    
    'ahora traemos la info
    
    userfile = charpath & personaje & ".chr"

    tstr = personaje & "�"
    tstr = tstr & getvar(userfile, "init", "raza") & "�"
    tstr = tstr & getvar(userfile, "init", "clase") & "�"
    tstr = tstr & getvar(userfile, "init", "genero") & "�"
    tstr = tstr & getvar(userfile, "stats", "elv") & "�"
    tstr = tstr & getvar(userfile, "stats", "gld") & "�"
    tstr = tstr & getvar(userfile, "stats", "banco") & "�"
    tstr = tstr & getvar(userfile, "rep", "promedio") & "�"
    
    peticiones = getvar(userfile, "guild", "pedidos")
    tstr = tstr & iif(len(peticiones) > 400, ".." & right$(peticiones, 400), peticiones) & "�"
    
    miembro = getvar(userfile, "guild", "miembro")
    tstr = tstr & iif(len(miembro) > 400, ".." & right$(miembro, 400), miembro) & "�"
    
    guildactual = val(getvar(userfile, "guild", "guildindex"))
    if guildactual > 0 and guildactual <= cantidaddeclanes then
        tstr = tstr & "<" & guilds(guildactual).guildname & ">" & "�"
    else
        tstr = tstr & "ninguno" & "�"
    end if

    tstr = tstr & getvar(userfile, "facciones", "ejercitoreal") & "�"
    tstr = tstr & getvar(userfile, "facciones", "ejercitocaos") & "�"
    tstr = tstr & getvar(userfile, "facciones", "ciudmatados") & "�"
    tstr = tstr & getvar(userfile, "facciones", "crimmatados") & "�"
    
    a_detallespersonaje = tstr
end function

public function a_nuevoaspirante(byval userindex as integer, byref clan as string, byref solicitud as string, byref referror as string) as boolean
dim viejosolicitado     as string
dim viejoguildindex     as integer
dim viejonroaspirante   as integer
dim nuevoguildindex     as integer

    a_nuevoaspirante = false

    if userlist(userindex).guildindex > 0 then
        referror = "ya perteneces a un clan, debes salir del mismo antes de solicitar ingresar a otro"
        exit function
    end if
    
    if esnewbie(userindex) then
        referror = "los newbies no tienen derecho a entrar a un clan."
        exit function
    end if

    nuevoguildindex = guildindex(clan)
    if nuevoguildindex = 0 then
        referror = "ese clan no existe! avise a un administrador."
        exit function
    end if
    
    if not m_estadopermiteentrar(userindex, nuevoguildindex) then
        referror = "tu no puedes entrar a un clan de alineaci�n " & alineacion2string(guilds(nuevoguildindex).alineacion)
        exit function
    end if

    if guilds(nuevoguildindex).cantidadaspirantes >= maxaspirantes then
        referror = "el clan tiene demasiados aspirantes. cont�ctate con un miembro para que procese las solicitudes."
        exit function
    end if

    viejosolicitado = getvar(charpath & userlist(userindex).name & ".chr", "guild", "aspirantea")

    if viejosolicitado <> vbnullstring then
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
        referror = "el pj no es aspirante al clan"
        exit function
    end if
    
    aspiranteui = nameindex(aspirante)
    if aspiranteui > 0 then
        'pj online
        if not m_estadopermiteentrar(aspiranteui, gi) then
            referror = aspirante & " no puede entrar a un clan " & alineacion2string(guilds(gi).alineacion)
            call guilds(gi).retiraraspirante(aspirante, nroaspirante)
            exit function
        end if
    else
        if not m_estadopermiteentrarchar(aspirante, gi) then
            referror = aspirante & " no puede entrar a un clan " & alineacion2string(guilds(gi).alineacion)
            call guilds(gi).retiraraspirante(aspirante, nroaspirante)
            exit function
        end if
    end if
    'el pj es aspirante al clan y puede entrar
    
    call guilds(gi).retiraraspirante(aspirante, nroaspirante)
    call guilds(gi).aceptarnuevomiembro(aspirante)

    a_aceptaraspirante = true

end function
