attribute vb_name = "declaraciones"
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

''
' modulo de declaraciones. aca hay de todo.
'

#if seguridadalkon then
public ados as new clsantidos
#end if

public aclon as new clsantimassclon
public trashcollector as new collection


public const maxspawnattemps = 60
public const infinite_loops as integer = -1
public const fxsangre = 14

''
' the color of chats over head of dead characters.
public const chat_color_dead_char as long = &hc0c0c0

''
' the color of yells made by any kind of game administrator.
public const chat_color_gm_yell as long = &hf82ff

''
' coordinates for normal sounds (not 3d, like rain)
public const no_3d_sound as byte = 0

public const ifragatafantasmal = 87
public const ifragatareal = 190
public const ifragatacaos = 189
public const ibarca = 84
public const igalera = 85
public const igaleon = 86
public const ibarcaciuda = 395
public const ibarcapk = 396
public const igaleraciuda = 397
public const igalerapk = 398
public const igaleonciuda = 399
public const igaleonpk = 400

public enum iminerales
    hierrocrudo = 192
    platacruda = 193
    orocrudo = 194
    lingotedehierro = 386
    lingotedeplata = 387
    lingotedeoro = 388
end enum

public enum playertype
    user = &h1
    consejero = &h2
    semidios = &h4
    dios = &h8
    admin = &h10
    rolemaster = &h20
    chaoscouncil = &h40
    royalcouncil = &h80
end enum

public enum eclass
    mage = 1       'mago
    cleric      'cl�rigo
    warrior     'guerrero
    assasin     'asesino
    thief       'ladr�n
    bard        'bardo
    druid       'druida
    bandit      'bandido
    paladin     'palad�n
    hunter      'cazador
    fisher      'pescador
    blacksmith  'herrero
    lumberjack  'le�ador
    miner       'minero
    carpenter   'carpintero
    pirat       'pirata
end enum

public enum eciudad
    cullathorpe = 1
    cnix
    cbanderbill
    clindos
    carghal
end enum

public enum eraza
    humano = 1
    elfo
    drow
    gnomo
    enano
end enum

enum egenero
    hombre = 1
    mujer
end enum

public enum eclantype
    ct_royalarmy
    ct_evil
    ct_neutral
    ct_gm
    ct_legal
    ct_criminal
end enum

public const limitenewbie as byte = 12

public type tcabecera 'cabecera de los con
    desc as string * 255
    crc as long
    magicword as long
end type

public micabecera as tcabecera

'barrin 3/10/03
'cambiado a 2 segundos el 30/11/07
public const tiempo_iniciomeditar as integer = 2000

public const ningunescudo as integer = 2
public const ninguncasco as integer = 2
public const ningunarma as integer = 2

public const espadamatadragonesindex as integer = 402
public const laudmagico as integer = 696
public const flautamagica as integer = 208


public const maxmascotasentrenador as byte = 7

public enum fxids
    fxwarp = 1
    fxmeditarchico = 4
    fxmeditarmediano = 5
    fxmeditargrande = 6
    fxmeditarxgrande = 16
    fxmeditarxxgrande = 34
end enum

public const tiempo_carcel_piquete as long = 10

''
' triggers
'
' @param nada nada
' @param bajotecho bajo techo
' @param trigger_2 ???
' @param posinvalida los npcs no pueden pisar tiles con este trigger
' @param zonasegura no se puede robar o pelear desde este trigger
' @param antipiquete
' @param zonapelea al pelear en este trigger no se caen las cosas y no cambia el estado de ciuda o crimi
'
public enum etrigger
    nada = 0
    bajotecho = 1
    trigger_2 = 2
    posinvalida = 3
    zonasegura = 4
    antipiquete = 5
    zonapelea = 6
end enum

''
' constantes para el trigger 6
'
' @see etrigger
' @param trigger6_permite trigger6_permite
' @param trigger6_prohibe trigger6_prohibe
' @param trigger6_ausente el trigger no aparece
'
public enum etrigger6
    trigger6_permite = 1
    trigger6_prohibe = 2
    trigger6_ausente = 3
end enum

'todo : reemplazar por un enum
public const bosque as string = "bosque"
public const nieve as string = "nieve"
public const desierto as string = "desierto"
public const ciudad as string = "ciudad"
public const campo as string = "campo"
public const dungeon as string = "dungeon"

' <<<<<< targets >>>>>>
public enum targettype
    uusuarios = 1
    unpc = 2
    uusuariosynpc = 3
    uterreno = 4
end enum

' <<<<<< acciona sobre >>>>>>
public enum tipohechizo
    upropiedades = 1
    uestado = 2
    umaterializa = 3    'nose usa
    uinvocacion = 4
end enum

public const max_mensajes_foro as byte = 35

public const maxuserhechizos as byte = 35


' todo: y esto ? lo conoce gd ?
public const esfuerzotalargeneral as byte = 4
public const esfuerzotalarle�ador as byte = 2

public const esfuerzopescarpescador as byte = 1
public const esfuerzopescargeneral as byte = 3

public const esfuerzoexcavarminero as byte = 2
public const esfuerzoexcavargeneral as byte = 5

public const fx_teleport_index as integer = 1

' la utilidad de esto es casi nula, s�lo se revisa si fue a la cabeza...
public enum partescuerpo
    bcabeza = 1
    bpiernaizquierda = 2
    bpiernaderecha = 3
    bbrazoderecho = 4
    bbrazoizquierdo = 5
    btorso = 6
end enum

public const guardias as integer = 6

public const maxrep as long = 6000000
public const maxoro as long = 90000000
public const maxexp as long = 99999999

public const maxusermatados as long = 65000

public const maxatributos as byte = 38
public const minatributos as byte = 6

public const lingotehierro as integer = 386
public const lingoteplata as integer = 387
public const lingoteoro as integer = 388
public const le�a as integer = 58


public const maxnpcs as integer = 10000
public const maxchars as integer = 10000

public const hacha_le�ador as integer = 127
public const piquete_minero as integer = 187

public const daga as integer = 15
public const fogata_apag as integer = 136
public const fogata as integer = 63
public const oro_mina as integer = 194
public const plata_mina as integer = 193
public const hierro_mina as integer = 192
public const martillo_herrero as integer = 389
public const serrucho_carpintero as integer = 198
public const objarboles as integer = 4
public const red_pesca as integer = 543
public const ca�a_pesca as integer = 138

public enum enpctype
    comun = 0
    revividor = 1
    guardiareal = 2
    entrenador = 3
    banquero = 4
    noble = 5
    dragon = 6
    timbero = 7
    guardiascaos = 8
    resucitadornewbie = 9
end enum

public const min_apu�alar as byte = 10

'********** constantantes ***********

''
' cantidad de skills
public const numskills as byte = 21

''
' cantidad de atributos
public const numatributos as byte = 5

''
' cantidad de clases
public const numclases as byte = 16

''
' cantidad de razas
public const numrazas as byte = 5


''
' valor maximo de cada skill
public const maxskillpoints as byte = 100

''
'direccion
'
' @param north norte
' @param east este
' @param south sur
' @param west oeste
'
public enum eheading
    north = 1
    east = 2
    south = 3
    west = 4
end enum

''
' cantidad maxima de mascotas
public const maxmascotas as byte = 3

'%%%%%%%%%% constantes de indices %%%%%%%%%%%%%%%
public const vlasalto as integer = 100
public const vlasesino as integer = 1000
public const vlcazador as integer = 5
public const vlnoble as integer = 5
public const vlladron as integer = 25
public const vlproleta as integer = 2

'%%%%%%%%%% constantes de indices %%%%%%%%%%%%%%%
public const icuerpomuerto as integer = 8
public const icabezamuerto as integer = 500


public const ioro as byte = 12
public const pescado as byte = 139

public enum peces_posibles
    pescado1 = 139
    pescado2 = 544
    pescado3 = 545
    pescado4 = 546
end enum

'%%%%%%%%%% constantes de indices %%%%%%%%%%%%%%%
public enum eskill
    suerte = 1
    magia = 2
    robar = 3
    tacticas = 4
    armas = 5
    meditar = 6
    apu�alar = 7
    ocultarse = 8
    supervivencia = 9
    talar = 10
    comerciar = 11
    defensa = 12
    pesca = 13
    mineria = 14
    carpinteria = 15
    herreria = 16
    liderazgo = 17
    domar = 18
    proyectiles = 19
    wrestling = 20
    navegacion = 21
end enum

public const fundirmetal = 88

public enum eatributos
    fuerza = 1
    agilidad = 2
    inteligencia = 3
    carisma = 4
    constitucion = 5
end enum

public const adicionalhpguerrero as byte = 2 'hp adicionales cuando sube de nivel
public const adicionalhpcazador as byte = 1 'hp adicionales cuando sube de nivel

public const aumentostdef as byte = 15
public const aumentostladron as byte = aumentostdef + 3
public const aumentostmago as byte = aumentostdef - 1
public const aumentostle�ador as byte = aumentostdef + 23
public const aumentostpescador as byte = aumentostdef + 20
public const aumentostminero as byte = aumentostdef + 25

'tama�o del mapa
public const xmaxmapsize as byte = 100
public const xminmapsize as byte = 1
public const ymaxmapsize as byte = 100
public const yminmapsize as byte = 1

'tama�o del tileset
public const tilesizex as byte = 32
public const tilesizey as byte = 32

'tama�o en tiles de la pantalla de visualizacion
public const xwindow as byte = 17
public const ywindow as byte = 13

'sonidos
public const snd_swing as byte = 2
public const snd_talar as byte = 13
public const snd_pescar as byte = 14
public const snd_minero as byte = 15
public const snd_warp as byte = 3
public const snd_puerta as byte = 5
public const snd_nivel as byte = 6

public const snd_usermuerte as byte = 11
public const snd_impacto as byte = 10
public const snd_impacto2 as byte = 12
public const snd_le�ador as byte = 13
public const snd_fogata as byte = 14
public const snd_ave as byte = 21
public const snd_ave2 as byte = 22
public const snd_ave3 as byte = 34
public const snd_grillo as byte = 28
public const snd_grillo2 as byte = 29
public const snd_sacararma as byte = 25
public const snd_escudo as byte = 37
public const martilloherrero as byte = 41
public const laburocarpintero as byte = 42
public const snd_beber as byte = 46

''
' cantidad maxima de objetos por slot de inventario
public const max_inventory_objs as integer = 10000

''
' cantidad de "slots" en el inventario
public const max_inventory_slots as byte = 20

''
' constante para indicar que se esta usando oro
public const flagoro as integer = max_inventory_slots + 1


' categorias principales
public enum eobjtype
    otuseonce = 1
    otweapon = 2
    otarmadura = 3
    otarboles = 4
    otguita = 5
    otpuertas = 6
    otcontenedores = 7
    otcarteles = 8
    otllaves = 9
    otforos = 10
    otpociones = 11
    otbebidas = 13
    otle�a = 14
    otfogata = 15
    otescudo = 16
    otcasco = 17
    otanillo = 18
    otteleport = 19
    otyacimiento = 22
    otminerales = 23
    otpergaminos = 24
    otinstrumentos = 26
    otyunque = 27
    otfragua = 28
    otbarcos = 31
    otflechas = 32
    otbotellavacia = 33
    otbotellallena = 34
    otmanchas = 35          'no se usa
    otcualquiera = 1000
end enum

'texto
public const fonttype_talk as string = "~255~255~255~0~0"
public const fonttype_fight as string = "~255~0~0~1~0"
public const fonttype_warning as string = "~32~51~223~1~1"
public const fonttype_info as string = "~65~190~156~0~0"
public const fonttype_infobold as string = "~65~190~156~1~0"
public const fonttype_ejecucion as string = "~130~130~130~1~0"
public const fonttype_party as string = "~255~180~255~0~0"
public const fonttype_veneno as string = "~0~255~0~0~0"
public const fonttype_guild as string = "~255~255~255~1~0"
public const fonttype_server as string = "~0~185~0~0~0"
public const fonttype_guildmsg as string = "~228~199~27~0~0"
public const fonttype_consejo as string = "~130~130~255~1~0"
public const fonttype_consejocaos as string = "~255~60~00~1~0"
public const fonttype_consejovesa as string = "~0~200~255~1~0"
public const fonttype_consejocaosvesa as string = "~255~50~0~1~0"
public const fonttype_centinela as string = "~0~255~0~1~0"

'estadisticas
public const stat_maxelv as byte = 255
public const stat_maxhp as integer = 999
public const stat_maxsta as integer = 999
public const stat_maxman as integer = 9999
public const stat_maxhit_under36 as byte = 99
public const stat_maxhit_over36 as integer = 999
public const stat_maxdef as byte = 99



' **************************************************************
' **************************************************************
' ************************ tipos *******************************
' **************************************************************
' **************************************************************

public type thechizo
    nombre as string
    desc as string
    palabrasmagicas as string
    
    hechizeromsg as string
    targetmsg as string
    propiomsg as string
    
'    resis as byte
    
    tipo as tipohechizo
    
    wav as integer
    fxgrh as integer
    loops as byte
    
    subehp as byte
    minhp as integer
    maxhp as integer
    
    subemana as byte
    mimana as integer
    mamana as integer
    
    subesta as byte
    minsta as integer
    maxsta as integer
    
    subeham as byte
    minham as integer
    maxham as integer
    
    subesed as byte
    minsed as integer
    maxsed as integer
    
    subeagilidad as byte
    minagilidad as integer
    maxagilidad as integer
    
    subefuerza as byte
    minfuerza as integer
    maxfuerza as integer
    
    subecarisma as byte
    mincarisma as integer
    maxcarisma as integer
    
    invisibilidad as byte
    paraliza as byte
    inmoviliza as byte
    removerparalisis as byte
    removerestupidez as byte
    curaveneno as byte
    envenena as byte
    maldicion as byte
    removermaldicion as byte
    bendicion as byte
    estupidez as byte
    ceguera as byte
    revivir as byte
    morph as byte
    mimetiza as byte
    remueveinvisibilidadparcial as byte
    
    invoca as byte
    numnpc as integer
    cant as integer

'    materializa as byte
'    itemindex as byte
    
    minskill as integer
    manarequerido as integer

    'barrin 29/9/03
    starequerido as integer

    target as targettype
    
    needstaff as integer
    staffaffected as boolean
end type

public type levelskill
    levelvalue as integer
end type

public type userobj
    objindex as integer
    amount as integer
    equipped as byte
end type

public type inventario
    object(1 to max_inventory_slots) as userobj
    weaponeqpobjindex as integer
    weaponeqpslot as byte
    armoureqpobjindex as integer
    armoureqpslot as byte
    escudoeqpobjindex as integer
    escudoeqpslot as byte
    cascoeqpobjindex as integer
    cascoeqpslot as byte
    municioneqpobjindex as integer
    municioneqpslot as byte
    anilloeqpobjindex as integer
    anilloeqpslot as byte
    barcoobjindex as integer
    barcoslot as byte
    nroitems as integer
end type

public type tpartydata
    pindex as integer
    remxp as double 'la exp. en el server se cuenta con doubles
    targetuser as integer 'para las invitaciones
end type

public type position
    x as integer
    y as integer
end type

public type worldpos
    map as integer
    x as integer
    y as integer
end type

public type fxdata
    nombre as string
    grhindex as integer
    delay as integer
end type

'datos de user o npc
public type char
    charindex as integer
    head as integer
    body as integer
    
    weaponanim as integer
    shieldanim as integer
    cascoanim as integer
    
    fx as integer
    loops as integer
    
    heading as eheading
end type

'tipos de objetos
public type objdata
    name as string 'nombre del obj
    
    objtype as eobjtype 'tipo enum que determina cuales son las caract del obj
    
    grhindex as integer ' indice del grafico que representa el obj
    grhsecundario as integer
    
    'solo contenedores
    maxitems as integer
    conte as inventario
    apu�ala as byte
    
    hechizoindex as integer
    
    foroid as string
    
    minhp as integer ' minimo puntos de vida
    maxhp as integer ' maximo puntos de vida
    
    
    mineralindex as integer
    lingoteinex as integer
    
    
    proyectil as integer
    municion as integer
    
    crucial as byte
    newbie as integer
    
    'puntos de stamina que da
    minsta as integer ' minimo puntos de stamina
    
    'pociones
    tipopocion as byte
    maxmodificador as integer
    minmodificador as integer
    duracionefecto as long
    minskill as integer
    lingoteindex as integer
    
    minhit as integer 'minimo golpe
    maxhit as integer 'maximo golpe
    
    minham as integer
    minsed as integer
    
    def as integer
    mindef as integer ' armaduras
    maxdef as integer ' armaduras
    
    ropaje as integer 'indice del grafico del ropaje
    
    weaponanim as integer ' apunta a una anim de armas
    shieldanim as integer ' apunta a una anim de escudo
    cascoanim as integer
    
    valor as long     ' precio
    
    cerrada as integer
    llave as byte
    clave as long 'si clave=llave la puerta se abre o cierra
    
    indexabierta as integer
    indexcerrada as integer
    indexcerradallave as integer
    
    razaenana as byte
    razadrow as byte
    razaelfa as byte
    razagnoma as byte
    razahumana as byte
    
    mujer as byte
    hombre as byte
    
    envenena as byte
    paraliza as byte
    
    agarrable as byte
    
    lingh as integer
    lingo as integer
    lingp as integer
    madera as integer
    
    skherreria as integer
    skcarpinteria as integer
    
    texto as string
    
    'clases que no tienen permitido usar este obj
    claseprohibida(1 to numclases) as eclass
    
    snd1 as integer
    snd2 as integer
    snd3 as integer
    
    real as integer
    caos as integer
    
    nosecae as integer
    
    staffpower as integer
    staffdamagebonus as integer
    defensamagicamax as integer
    defensamagicamin as integer
    refuerzo as byte
    
    log as byte 'es un objeto que queremos loguear? pablo (toxicwaste) 07/09/07
    nolog as byte 'es un objeto que esta prohibido loguear?
end type

public type obj
    objindex as integer
    amount as integer
end type

'[pablo toxicwaste]
public type modclase
    evasion as double
    ataquearmas as double
    ataqueproyectiles as double
    da�oarmas as double
    da�oproyectiles as double
    da�owrestling as double
    escudo as double
end type

public type modraza
    fuerza as single
    agilidad as single
    inteligencia as single
    carisma as single
    constitucion as single
end type
'[/pablo toxicwaste]

'[kevin]
'banco objs
public const max_bancoinventory_slots as byte = 40
'[/kevin]

'[kevin]
public type bancoinventario
    object(1 to max_bancoinventory_slots) as userobj
    nroitems as integer
end type
'[/kevin]


'*********************************************************
'*********************************************************
'*********************************************************
'*********************************************************
'******* t i p o s   d e    u s u a r i o s **************
'*********************************************************
'*********************************************************
'*********************************************************
'*********************************************************

public type treputacion 'fama del usuario
    noblerep as long
    burguesrep as long
    pleberep as long
    ladronesrep as long
    bandidorep as long
    asesinorep as long
    promedio as long
end type

'estadisticas de los usuarios
public type userstats
    gld as long 'dinero
    banco as long
    
    maxhp as integer
    minhp as integer
    
    maxsta as integer
    minsta as integer
    maxman as integer
    minman as integer
    maxhit as integer
    minhit as integer
    
    maxham as integer
    minham as integer
    
    maxagu as integer
    minagu as integer
        
    def as integer
    exp as double
    elv as byte
    elu as long
    userskills(1 to numskills) as byte
    useratributos(1 to numatributos) as byte
    useratributosbackup(1 to numatributos) as byte
    userhechizos(1 to maxuserhechizos) as integer
    usuariosmatados as long
    criminalesmatados as long
    npcsmuertos as integer
    
    skillpts as integer
    
end type

'flags
public type userflags
    estaempo as byte    'empollando (by yb)
    muerto as byte '�esta muerto?
    escondido as byte '�esta escondido?
    comerciando as boolean '�esta comerciando?
    userlogged as boolean '�esta online?
    meditando as boolean
    modocombate as boolean
    descuento as string
    hambre as byte
    sed as byte
    puedemoverse as byte
    timerlanzarspell as long
    puedetrabajar as byte
    envenenado as byte
    paralizado as byte
    inmovilizado as byte
    estupidez as byte
    ceguera as byte
    invisible as byte
    maldicion as byte
    bendicion as byte
    oculto as byte
    desnudo as byte
    descansar as boolean
    hechizo as integer
    tomopocion as boolean
    tipopocion as byte
    
    vuela as byte
    navegando as byte
    seguro as boolean
    seguroresu as boolean
    
    duracionefecto as long
    targetnpc as integer ' npc se�alado por el usuario
    targetnpctipo as enpctype ' tipo del npc se�alado
    npcinv as integer
    
    ban as byte
    administrativeban as byte
    
    targetuser as integer ' usuario se�alado
    
    targetobj as integer ' obj se�alado
    targetobjmap as integer
    targetobjx as integer
    targetobjy as integer
    
    targetmap as integer
    targetx as integer
    targety as integer
    
    targetobjinvindex as integer
    targetobjinvslot as integer
    
    atacadopornpc as integer
    atacadoporuser as integer
    npcatacado as integer
    
    statschanged as byte
    privilegios as playertype
    
    valcode as integer
    
    lastcrimmatado as string
    lastciudmatado as string
    
    oldbody as integer
    oldhead as integer
    admininvisible as byte
    adminperseguible as boolean
    
    chatcolor as long
    
    '[el oso]
    md5reportado as string
    '[/el oso]
    
    '[barrin 30-11-03]
    timeswalk as long
    startwalk as long
    countsh as long
    '[/barrin 30-11-03]
    
    '[cdt 17-02-04]
    ultimomensaje as byte
    '[/cdt]
    
    noactualizado as boolean
    
    silenciado as byte
    
    mimetizado as byte
    
    centinelaok as boolean 'centinela
end type

public type usercounters
    idlecount as long
    attackcounter as integer
    hpcounter as integer
    stacounter as integer
    frio as integer
    lava as integer
    comcounter as integer
    aguacounter as integer
    veneno as integer
    paralisis as integer
    ceguera as integer
    estupidez as integer
    
    invisibilidad as integer
    tiempooculto as integer
    
    mimetismo as integer
    piquetec as long
    pena as long
    sendmapcounter as worldpos
    '[gonzalo]
    saliendo as boolean
    salir as integer
    '[/gonzalo]
    
    'barrin 3/10/03
    tiniciomeditar as long
    bpuedemeditar as boolean
    'barrin
    
    timerlanzarspell as long
    timerpuedeatacar as long
    timerpuedeusararco as long
    timerpuedetrabajar as long
    timerusar as long
    timermagiagolpe as long
    timergolpemagia as long
    timergolpeusar as long
    
    
    trabajando as long  ' para el centinela
    ocultando as long   ' unico trabajo no revisado por el centinela
    
    failedusageattempts as long
end type

'cosas faccionarias.
public type tfacciones
    armadareal as byte
    fuerzascaos as byte
    criminalesmatados as long
    ciudadanosmatados as long
    recompensasreal as long
    recompensascaos as long
    recibioexpinicialreal as byte
    recibioexpinicialcaos as byte
    recibioarmadurareal as byte
    recibioarmaduracaos as byte
    reenlistadas as byte
    nivelingreso as integer
    fechaingreso as string
    matadosingreso as integer 'para armadas nada mas
    nextrecompensa as integer
end type

'tipo de los usuarios
public type user
    name as string
    id as long
    
    showname as boolean 'permite que los gms oculten su nick con el comando /showname
    
    char as char 'define la apariencia
    charmimetizado as char
    origchar as char
    
    desc as string ' descripcion
    descrm as string
    
    clase as eclass
    raza as eraza
    genero as egenero
    email as string
    hogar as eciudad
        
    invent as inventario
    
    pos as worldpos
    
    connidvalida as boolean
    connid as long 'id
    
    '[kevin]
    bancoinvent as bancoinventario
    '[/kevin]
    
    counters as usercounters
    
    mascotasindex(1 to maxmascotas) as integer
    mascotastype(1 to maxmascotas) as integer
    nromascotas as integer
    
    stats as userstats
    flags as userflags
    
    reputacion as treputacion
    
    faccion as tfacciones
    
#if seguridadalkon then
    security as securitydata
#end if

#if conuptime then
    logontime as date
    uptime as long
#end if

    ip as string
    
     '[alejo]
    comusu as tcomerciousuario
    '[/alejo]
    
    empocont as byte
    
    guildindex as integer   'puntero al array global de guilds
    fundandoguildalineacion as alineacion_guild     'esto esta aca hasta que se parchee el cliente y se pongan cadenas de datos distintas para cada alineacion
    escucheclan as integer
    
    partyindex as integer   'index a la party q es miembro
    partysolicitud as integer   'index a la party q solicito
    
    keycrypt as integer
    
    areasinfo as areainfo
    
    'outgoing and incoming messages
    outgoingdata as clsbytequeue
    incomingdata as clsbytequeue
end type


'*********************************************************
'*********************************************************
'*********************************************************
'*********************************************************
'**  t i p o s   d e    n p c s **************************
'*********************************************************
'*********************************************************
'*********************************************************
'*********************************************************

public type npcstats
    alineacion as integer
    maxhp as long
    minhp as long
    maxhit as integer
    minhit as integer
    def as integer
    defm as integer
end type

public type npccounters
    paralisis as integer
    tiempoexistencia as long
end type

public type npcflags
    afectaparalisis as byte
    domable as integer
    respawn as byte
    npcactive as boolean '�esta vivo?
    follow as boolean
    faccion as byte
    atacadoble as byte
    lanzaspells as byte
    
    expcount as long
    
    oldmovement as tipoai
    oldhostil as byte
    
    aguavalida as byte
    tierrainvalida as byte
    
    sound as integer
    attackedby as string
    attackedfirstby as string
    backup as byte
    respawnorigpos as byte
    
    envenenado as byte
    paralizado as byte
    inmovilizado as byte
    invisible as byte
    maldicion as byte
    bendicion as byte
    
    snd1 as integer
    snd2 as integer
    snd3 as integer
end type

public type tcriaturasentrenador
    npcindex as integer
    npcname as string
    tmpindex as integer
end type

' new type for holding the pathfinding info
public type npcpathfindinginfo
    path() as tvertice      ' this array holds the path
    target as position      ' the location where the npc has to go
    pathlenght as integer   ' number of steps *
    curpos as integer       ' current location of the npc
    targetuser as integer   ' userindex chased
    nopath as boolean       ' if it is true there is no path to the target location
    
    '* by setting pathlenght to 0 we force the recalculation
    '  of the path, this is very useful. for example,
    '  if a npc or a user moves over the npc's path, blocking
    '  its way, the function npclegalpos set pathlenght to 0
    '  forcing the seek of a new path.
    
end type
' new type for holding the pathfinding info


public type npc
    name as string
    char as char 'define como se vera
    desc as string

    npctype as enpctype
    numero as integer

    invrespawn as byte

    comercia as integer
    target as long
    targetnpc as long
    tipoitems as integer

    veneno as byte

    pos as worldpos 'posicion
    orig as worldpos
    skilldomar as integer

    movement as tipoai
    attackable as byte
    hostile as byte
    poderataque as long
    poderevasion as long


    giveexp as long
    givegld as long

    stats as npcstats
    flags as npcflags
    contadores as npccounters
    
    invent as inventario
    canattack as byte
    
    nroexpresiones as byte
    expresiones() as string ' le da vida ;)
    
    nrospells as byte
    spells() as integer  ' le da vida ;)
    
    '<<<<entrenadores>>>>>
    nrocriaturas as integer
    criaturas() as tcriaturasentrenador
    maestrouser as integer
    maestronpc as integer
    mascotas as integer
    
    ' new!! needed for pathfindig
    pfinfo as npcpathfindinginfo
    areasinfo as areainfo
end type

'**********************************************************
'**********************************************************
'******************** tipos del mapa **********************
'**********************************************************
'**********************************************************
'tile
public type mapblock
    blocked as byte
    graphic(1 to 4) as integer
    userindex as integer
    npcindex as integer
    objinfo as obj
    tileexit as worldpos
    trigger as etrigger
end type

'info del mapa
type mapinfo
    numusers as integer
    music as string
    name as string
    startpos as worldpos
    mapversion as integer
    pk as boolean
    magiasinefecto as byte
    noencriptarmp as byte
    invisinefecto as byte
    resusinefecto as byte
    
    terreno as string
    zona as string
    restringir as string
    backup as byte
end type

'********** v a r i a b l e s     p u b l i c a s ***********

public serveronline as boolean
public ultimaversion as string
public backup as boolean ' todo: se usa esta variable ?

public listarazas(1 to numrazas) as string
public skillsnames(1 to numskills) as string
public listaclases(1 to numclases) as string
public listaatributos(1 to numatributos) as string


public recordusuarios as long

'
'directorios
'

''
'ruta base del server, en donde esta el "server.ini"
public inipath as string

''
'ruta base para guardar los chars
public charpath as string

''
'ruta base para los archivos de mapas
public mappath as string

''
'ruta base para los dats
public datpath as string

''
'bordes del mapa
public minxborder as byte
public maxxborder as byte
public minyborder as byte
public maxyborder as byte

''
'numero de usuarios actual
public numusers as integer
public lastuser as integer
public lastchar as integer
public numchars as integer
public lastnpc as integer
public numnpcs as integer
public numfx as integer
public nummaps as integer
public numobjdatas as integer
public numerohechizos as integer
public allowmultilogins as byte
public idlelimit as integer
public maxusers as integer
public hideme as byte
public lastbackup as string
public minutos as string
public haciendobk as boolean
public puedecrearpersonajes as integer
public serversologms as integer

''
'esta activada la verificacion md5 ?
public md5clientesactivado as byte


public enpausa as boolean
public entesting as boolean


'*****************arrays publicos*************************
public userlist() as user 'usuarios
public npclist(1 to maxnpcs) as npc 'npcs
public mapdata() as mapblock
public mapinfo() as mapinfo
public hechizos() as thechizo
public charlist(1 to maxchars) as integer
public objdata() as objdata
public fx() as fxdata
public spawnlist() as tcriaturasentrenador
public levelskill(1 to 50) as levelskill
public forbidennames() as string
public armasherrero() as integer
public armadurasherrero() as integer
public objcarpintero() as integer
public md5s() as string
public banips as new collection
public parties(1 to max_parties) as clsparty
public modclase(1 to numclases) as modclase
public modraza(1 to numrazas) as modraza
public modvida(1 to numclases) as double
public distribucionenteravida(1 to 5) as integer
public distribucionsemienteravida(1 to 4) as integer
'*********************************************************

public nix as worldpos
public ullathorpe as worldpos
public banderbill as worldpos
public lindos as worldpos
public arghal as worldpos

public prision as worldpos
public libertad as worldpos

public ayuda as new ccola
public consultapopular as new consultaspopulares
public sonidosmapas as new soundmapinfo

public declare function gettickcount lib "kernel32" () as long

public declare function writeprivateprofilestring lib "kernel32" alias "writeprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpstring as string, byval lpfilename as string) as long
public declare function getprivateprofilestring lib "kernel32" alias "getprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpdefault as string, byval lpreturnedstring as string, byval nsize as long, byval lpfilename as string) as long

public declare sub zeromemory lib "kernel32.dll" alias "rtlzeromemory" (byref destination as any, byval length as long)

public enum e_objetoscriticos
    manzana = 1
    manzana2 = 2
    manzananewbie = 467
end enum
