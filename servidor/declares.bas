attribute vb_name = "declaraciones"
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

public mixedkey as long
public serverip as string
public crcsubkey as string

type testadisticasdiarias
    segundos as double
    maxusuarios as integer
    promedio as integer
end type
    
public daystats as testadisticasdiarias

public ados as new clsantidos
public aclon as new clsantimassclon
public trashcollector as new collection


public const maxspawnattemps = 60
public const maxusermatados = 9000000
public const loopadeternum = 999
public const fxsangre = 14


public const ifragatafantasmal = 87

public type tllamadagm
    usuario as string * 255
    desc as string * 255
end type

public const limitenewbie = 8

public type tcabecera 'cabecera de los con
    desc as string * 255
    crc as long
    magicword as long
end type

public micabecera as tcabecera

public const ningunescudo = 2
public const ninguncasco = 2

public const espadamatadragonesindex = 402

public const maxmascotasentrenador = 7

public const fxwarp = 1
public const fxcurar = 2

public const fxmeditarchico = 4
public const fxmeditarmediano = 5
public const fxmeditargrande = 6

public const posinvalida = 3

public const bosque = "bosque"
public const nieve = "nieve"
public const desierto = "desierto"

public const ciudad = "ciudad"
public const campo = "campo"
public const dungeon = "dungeon"

' <<<<<< targets >>>>>>
public const uusuarios = 1
public const unpc = 2
public const uusuariosynpc = 3
public const uterreno = 4

' <<<<<< acciona sobre >>>>>>
public const upropiedades = 1
public const uestado = 2
public const uinvocacion = 4
public const umaterializa = 3

public const dragon = 6
public const matadragones = 1

public const max_mensajes_foro = 35

public const maxuserhechizos = 35


public const esfuerzotalargeneral = 4
public const esfuerzotalarle�ador = 2

public const esfuerzopescarpescador = 1
public const esfuerzopescargeneral = 3

public const esfuerzoexcavarminero = 2
public const esfuerzoexcavargeneral = 5


public const bcabeza = 1
public const bpiernaizquierda = 2
public const bpiernaderecha = 3
public const bbrazoderecho = 4
public const bbrazoizquierdo = 5
public const btorso = 6

public const guardias = 6

public const maxrep = 6000000
public const maxoro = 90000000
public const maxexp = 99999999

public const maxatributos = 35
public const minatributos = 6

public const lingotehierro = 386
public const lingoteplata = 387
public const lingoteoro = 388
public const le�a = 58


public const maxnpcs = 10000
public const maxchars = 10000

public const hacha_le�ador = 127
public const piquete_minero = 187

public const daga = 15
public const fogata_apag = 136
public const fogata = 63
public const oro_mina = 194
public const plata_mina = 193
public const hierro_mina = 192
public const martillo_herrero = 389
public const serrucho_carpintero = 198
public const objarboles = 4

public const npctype_comun = 0
public const npctype_revivir = 1
public const npctype_guardias = 2
public const npctype_entrenador = 3
public const npctype_banquero = 4



public const fx_teleport_index = 1


public const min_apu�alar = 10

'********** constantantes ***********
public const numskills = 21
public const numatributos = 5
public const numclases = 17
public const numrazas = 5

public const maxskillpoints = 100

public const flagoro = 777

public const north = 1
public const east = 2
public const south = 3
public const west = 4


public const maxmascotas = 3

'%%%%%%%%%% constantes de indices %%%%%%%%%%%%%%%
public const vlasalto = 100
public const vlasesino = 1000
public const vlcazador = 5
public const vlnoble = 5
public const vlladron = 25
public const vlproleta = 2



'%%%%%%%%%% constantes de indices %%%%%%%%%%%%%%%
public const icuerpomuerto = 8
public const icabezamuerto = 500


public const ioro = 12
public const pescado = 139


'%%%%%%%%%% constantes de indices %%%%%%%%%%%%%%%
public const suerte = 1
public const magia = 2
public const robar = 3
public const tacticas = 4
public const armas = 5
public const meditar = 6
public const apu�alar = 7
public const ocultarse = 8
public const supervivencia = 9
public const talar = 10
public const comerciar = 11
public const defensa = 12
public const pesca = 13
public const mineria = 14
public const carpinteria = 15
public const herreria = 16
public const liderazgo = 17
public const domar = 18
public const proyectiles = 19
public const wresterling = 20
public const navegacion = 21

public const fundirmetal = 88

public const xa = 40
public const xd = 10
public const balance = 9

public const fuerza = 1
public const agilidad = 2
public const inteligencia = 3
public const carisma = 4
public const constitucion = 5


public const adicionalhpguerrero = 2 'hp adicionales cuando sube de nivel
public const adicionalstladron = 3

public const adicionalstle�ador = 23
public const adicionalstpescador = 20
public const adicionalstminero = 25

'tama�o del mapa
public const xmaxmapsize = 100
public const xminmapsize = 1
public const ymaxmapsize = 100
public const yminmapsize = 1

'tama�o del tileset
public const tilesizex = 32
public const tilesizey = 32

'tama�o en tiles de la pantalla de visualizacion
public const xwindow = 17
public const ywindow = 13

'sonidos
public const sound_bump = 1
public const sound_swing = 2
public const sound_talar = 13
public const sound_pescar = 14
public const sound_minero = 15
public const snd_warp = 3
public const snd_puerta = 5
public const sound_nivel = 6
public const sound_comida = 7
public const snd_usermuerte = 11
public const snd_impacto = 10
public const snd_impacto2 = 12
public const snd_le�ador = 13
public const snd_fogata = 14
public const snd_ave = 21
public const snd_ave2 = 22
public const snd_ave3 = 34
public const snd_grillo = 28
public const snd_grillo2 = 29
public const sound_sacararma = 25
public const snd_escudo = 37
public const martilloherrero = 41
public const laburocarpintero = 42
public const snd_creacionclan = 44
public const snd_aceptadoclan = 43
public const snd_declarewar = 45
public const snd_beber = 46

'objetos
public const max_inventory_objs = 10000
public const max_inventory_slots = 20

'<------------------categorias principales--------->
public const objtype_useonce = 1
public const objtype_weapon = 2
public const objtype_armour = 3
public const objtype_arboles = 4
public const objtype_guita = 5
public const objtype_puertas = 6
public const objtype_contenedores = 7
public const objtype_carteles = 8
public const objtype_llaves = 9
public const objtype_foros = 10
public const objtype_pociones = 11
public const objtype_bebida = 13
public const objtype_le�a = 14
public const objtype_fogata = 15
public const objtype_herramientas = 18
public const objtype_yacimiento = 22
public const objtype_pergaminos = 24
public const objtype_teleport = 19
public const objtype_yunque = 27
public const objtype_fragua = 28
public const objtype_minerales = 23
public const objtype_cualquiera = 1000
public const objtype_instrumentos = 26
public const objtype_barcos = 31
public const objtype_flechas = 32
public const objtype_botellavacia = 33
public const objtype_botellallena = 34
public const objtype_manchas = 35

'<------------------sub-categorias----------------->
public const objtype_armadura = 0
public const objtype_casco = 1
public const objtype_escudo = 2
public const objtype_ca�a = 138



'tipo de posicones
'1 modifica la agilidad
'2 modifica la fuerza
'3 repone hp
'4 repone mana

'texto
public const fonttype_talk = "~255~255~255~0~0"
public const fonttype_fight = "~255~0~0~1~0"
public const fonttype_warning = "~32~51~223~1~1"
public const fonttype_info = "~65~190~156~0~0"
public const fonttype_veneno = "~0~255~0~0~0"
public const fonttype_guild = "~255~255~255~1~0"

'estadisticas
public const stat_maxelv = 99
public const stat_maxhp = 999
public const stat_maxsta = 999
public const stat_maxman = 2000
public const stat_maxhit = 99
public const stat_maxdef = 99

public const snd_sync = &h0
public const snd_async = &h1

public const snd_nodefault = &h2

public const snd_loop = &h8
public const snd_nostop = &h10



'**************************************************************
'**************************************************************
'************************ tipos *******************************
'**************************************************************
'**************************************************************

type thechizo
    nombre as string
    desc as string
    palabrasmagicas as string
    
    hechizeromsg as string
    targetmsg as string
    propiomsg as string
    
    resis as byte
    
    tipo as byte
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
    removerparalisis as byte
    curaveneno as byte
    envenena as byte
    maldicion as byte
    removermaldicion as byte
    bendicion as byte
    estupidez as byte
    ceguera as byte
    revivir as byte
    morph as byte
    
    invoca as byte
    numnpc as integer
    cant as integer
    
    materializa as byte
    itemindex as byte
    
    minskill as integer
    manarequerido as integer

    target as byte
end type

type levelskill

levelvalue as integer

end type

type userobj
    objindex as integer
    amount as integer
    equipped as byte
end type

type inventario
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
    herramientaeqpobjindex as integer
    herramientaeqpslot as integer
    barcoobjindex as integer
    barcoslot as byte
    nroitems as integer
end type


type position
    x as integer
    y as integer
end type

type worldpos
    map as integer
    x as integer
    y as integer
end type

type fxdata
    nombre as string
    grhindex as integer
    delay as integer
end type

'datos de user o npc
type char
    charindex as integer
    head as integer
    body as integer
    
    weaponanim as integer
    shieldanim as integer
    cascoanim as integer
    
    fx as integer
    loops as integer
    
    heading as byte
end type

'tipos de objetos
public type objdata
    
    name as string 'nombre del obj
    
    objtype as integer 'tipo enum que determina cuales son las caract del obj
    subtipo as integer 'tipo enum que determina cuales son las caract del obj
    
    grhindex as integer ' indice del grafico que representa el obj
    grhsecundario as integer
    
    respawn as byte
    
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
    mujer as byte
    hombre as byte
    envenena as byte
    
    resistencia as long
    agarrable as byte
    
    
    lingh as integer
    lingo as integer
    lingp as integer
    madera as integer
    
    skherreria as integer
    skcarpinteria as integer
    
    texto as string
    
    'clases que no tienen permitido usar este obj
    claseprohibida(1 to numclases) as string
    
    snd1 as integer
    snd2 as integer
    snd3 as integer
    minint as integer
    
    real as integer
    caos as integer
    
end type

public type obj
    objindex as integer
    amount as integer
end type

'[kevin]
'banco objs
public const max_bancoinventory_slots = 40
'[/kevin]

'[kevin]
type bancoinventario
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

type treputacion 'fama del usuario
    noblerep as double
    burguesrep as double
    pleberep as double
    ladronesrep as double
    bandidorep as double
    asesinorep as double
    promedio as double
end type



'estadisticas de los usuarios
type userstats
    gld as long 'dinero
    banco as long
    met as integer
    
    maxhp as integer
    minhp as integer
    
    fit as integer
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
    elv as long
    elu as long
    userskills(1 to numskills) as integer
    useratributos(1 to numatributos) as integer
    useratributosbackup(1 to numatributos) as integer
    userhechizos(1 to maxuserhechizos) as integer
    usuariosmatados as integer
    criminalesmatados as integer
    npcsmuertos as integer
    
    skillpts as integer
    
end type

'flags
type userflags
    muerto as byte '�esta muerto?
    escondido as byte '�esta escondido?
    comerciando as boolean '�esta comerciando?
    userlogged as boolean '�esta online?
    meditando as boolean
    modocombate as boolean
    descuento as string
    hambre as byte
    sed as byte
    puedeatacar as byte
    puedemoverse as byte
    puedelanzarspell as byte
    puedetrabajar as byte
    envenenado as byte
    paralizado as byte
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
    
    duracionefecto as long
    targetnpc as integer ' npc se�alado por el usuario
    targetnpctipo as integer ' tipo del npc se�alado
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
    
    statschanged as byte
    privilegios as byte
    
    valcode as integer
    
    lastcrimmatado as string
    lastciudmatado as string
    
    oldbody as integer
    oldhead as integer
    admininvisible as byte
    
end type

type usercounters
    idlecount as long
    attackcounter as integer
    hpcounter as integer
    stacounter as integer
    frio as integer
    comcounter as integer
    aguacounter as integer
    veneno as integer
    paralisis as integer
    ceguera as integer
    estupidez as integer
    invisibilidad as integer
    piquetec as long
    pena as long
    sendmapcounter as worldpos
    pasos as integer
    '[gonzalo]
    saliendo as boolean
    salir as integer
    '[/gonzalo]
end type

type tfacciones
    armadareal as byte
    fuerzascaos as byte
    criminalesmatados as double
    ciudadanosmatados as double
    recompensasreal as long
    recompensascaos as long
    recibioexpinicialreal as byte
    recibioexpinicialcaos as byte
    recibioarmadurareal as byte
    recibioarmaduracaos as byte
end type

type tguild
    guildname as string
    solicitudes as long
    solicitudesrechazadas as long
    echadas as long
    vecesfueguildleader as long
    yavoto as byte
    esguildleader as byte
    fundoclan as byte
    clanfundado as string
    clanesparticipo as long
    guildpoints as double
end type

'tipo de los usuarios
type user
    
    name as string
    id as long
    
    modname as string
    password as string
    
    char as char 'define la apariencia
    origchar as char
    
    desc as string ' descripcion
    clase as string
    raza as string
    genero as string
    email as string
    hogar as string
    
    
    invent as inventario
    
    pos as worldpos
    
    
    connid as integer 'id
    rdbuffer as string 'buffer roto
    
    commandsbuffer as new ccolaarray
    
    '[kevin]
    bancoinvent as bancoinventario
    '[/kevin]
    
    
    counters as usercounters
    
    mascotasindex(1 to maxmascotas) as integer
    mascotastype(1 to maxmascotas) as integer
    nromacotas as integer
    
    stats as userstats
    flags as userflags
    numeropaquetespormilisec as long
    bytestransmitidosuser as long
    bytestransmitidossvr as long
    
    reputacion as treputacion
    
    faccion as tfacciones
    guildinfo as tguild
    guildref  as cguild
    
    prevcrc as long
    packetnumber as long
    randkey as long
    
    ip as string
    
     '[alejo]
    comusu as tcomerciousuario
    '[/alejo]
    
    anticuelgue as long
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

type npcstats
    alineacion as integer
    maxhp as long
    minhp as long
    maxhit as integer
    minhit as integer
    def as integer
    usuariosmatados as integer
    impactrate as integer
end type

type npccounters
    paralisis as integer
    tiempoexistencia as long
    
end type

type npcflags
    afectaparalisis as byte
    golpeexacto as byte
    domable as integer
    respawn as byte
    npcactive as boolean '�esta vivo?
    follow as boolean
    faccion as byte
    lanzaspells as byte
    
    oldmovement as byte
    oldhostil as byte
    
    aguavalida as byte
    tierrainvalida as byte
    
    useainow as boolean
    sound as integer
    attacking as integer
    attackedby as string
    category1 as string
    category2 as string
    category3 as string
    category4 as string
    category5 as string
    backup as byte
    respawnorigpos as byte
    
    envenenado as byte
    paralizado as byte
    invisible as byte
    maldicion as byte
    bendicion as byte
    
    snd1 as integer
    snd2 as integer
    snd3 as integer
    snd4 as integer
    
end type

type tcriaturasentrenador
    npcindex as integer
    npcname as string
    tmpindex as integer
end type

'<--------- new type for holding the pathfinding info ------>
type npcpathfindinginfo
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
'<--------- new type for holding the pathfinding info ------>


type npc
    name as string
    char as char 'define como se vera
    desc as string
    
    npctype as integer
    numero as integer
    
    level as integer
    
    invrespawn as byte
    
    comercia as integer
    target as long
    targetnpc as long
    tipoitems as integer
    
    veneno as byte
    
    pos as worldpos 'posicion
    orig as worldpos
    skilldomar as integer
    
    movement as integer
    attackable as byte
    hostile as byte
    poderataque as long
    poderevasion as long
    
    inflacion as long
    
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
    
    '<---------new!! needed for pathfindig----------->
    pfinfo as npcpathfindinginfo

    
end type

'**********************************************************
'**********************************************************
'******************** tipos del mapa **********************
'**********************************************************
'**********************************************************
'tile
type mapblock
    blocked as byte
    graphic(1 to 4) as integer
    userindex as integer
    npcindex as integer
    objinfo as obj
    tileexit as worldpos
    trigger as integer
end type

'info del mapa
type mapinfo
    numusers as integer
    music as string
    name as string
    startpos as worldpos
    mapversion as integer
    pk as boolean
    
    terreno as string
    zona as string
    restringir as string
    backup as byte
end type



'********** v a r i a b l e s     p u b l i c a s ***********

public serveronline as boolean
public ultimaversion as string
public backup as boolean

public listarazas() as string
public skillsnames() as string
public listaclases() as string


public endl as string
public endc as string

public recordusuarios as long

'directorios
public inipath as string
public charpath as string
public mappath as string
public datpath as string

'bordes del mapa
public minxborder as byte
public maxxborder as byte
public minyborder as byte
public maxyborder as byte

public respos as worldpos
public startpos as worldpos 'posicion de comienzo


public numusers as integer 'numero de usuarios actual
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
public oscuridad as integer
public nochedia as integer
public puedecrearpersonajes as byte

'*****************arrays publicos*************************
public userlist() as user 'usuarios
public npclist() as npc 'npcs
public mapdata() as mapblock
public mapinfo() as mapinfo
public hechizos() as thechizo
public charlist() as integer
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
'*********************************************************

public nix as worldpos
public ullathorpe as worldpos
public banderbill as worldpos
public lindos as worldpos

public prision as worldpos
public libertad as worldpos


public ayuda as new ccola

public declare function gettickcount lib "kernel32" () as long


public declare function writeprivateprofilestring lib "kernel32" alias "writeprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpstring as string, byval lpfilename as string) as long
public declare function getprivateprofilestring lib "kernel32" alias "getprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpdefault as string, byval lpreturnedstring as string, byval nsize as long, byval lpfilename as string) as long
public declare function sndplaysound lib "winmm.dll" alias "sndplaysounda" (byval lpszsoundname as string, byval uflags as long) as long
public declare function gencrc lib "crc" alias "gencrc" (byval crckey as long, byval crcstring as string) as long


sub playwaveapi(file as string)

on error resume next
dim rc as integer

rc = sndplaysound(file, snd_async)

end sub

