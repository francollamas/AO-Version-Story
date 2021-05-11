attribute vb_name = "mod_declaraciones"
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
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

'objetos p�blicos
public dialogosclanes as clsguilddlg
public dialogos as clsdialogs
public audio as clsaudio
public inventario as clsgrapchicalinventory
public invbanco(1) as clsgrapchicalinventory

'inventarios de comercio con usuario
public invcomusu as clsgrapchicalinventory  ' inventario del usuario visible en el comercio
public invorocomusu(2) as clsgrapchicalinventory  ' inventarios de oro (ambos usuarios)
public invoffercomusu(1) as clsgrapchicalinventory  ' inventarios de ofertas (ambos usuarios)

public invcomnpc as clsgrapchicalinventory  ' inventario con los items que ofrece el npc

'inventarios de herreria
public const max_list_items as byte = 4
public invlingosherreria(1 to max_list_items) as clsgrapchicalinventory
public invmaderascarpinteria(1 to max_list_items) as clsgrapchicalinventory
                
public surfacedb as clssurfacemanager   'no va new porque es una interfaz, el new se pone al decidir que clase de objeto es
public customkeys as clscustomkeys
public custommessages as clscustommessages

public incomingdata as clsbytequeue
public outgoingdata as clsbytequeue

''
'the main timer of the game.
public maintimer as clstimer

#if seguridadalkon then
public md5 as clsmd5
#end if

'error code
public const too_fast as long = 24036
public const refused as long = 24061
public const time_out as long = 24060


'sonidos
public const snd_click as string = "click.wav"
public const snd_pasos1 as string = "23.wav"
public const snd_pasos2 as string = "24.wav"
public const snd_navegando as string = "50.wav"
public const snd_over as string = "click2.wav"
public const snd_dice as string = "cupdice.wav"
public const snd_lluviainend as string = "lluviainend.wav"
public const snd_lluviaoutend as string = "lluviaoutend.wav"

' head index of the casper. used to know if a char is killed

' constantes de intervalo
public const int_macro_hechis as integer = 2788
public const int_macro_trabajo as integer = 900

public const int_attack as integer = 1500
public const int_arrows as integer = 1400
public const int_cast_spell as integer = 1400
public const int_cast_attack as integer = 1000
public const int_work as integer = 700
public const int_useitemu as integer = 450
public const int_useitemdck as integer = 125
public const int_sentrpu as integer = 2000

public macrobltindex as integer

public const casper_head as integer = 500
public const fragata_fantasmal as integer = 87

public const numatributes as byte = 5

public const humano_h_primer_cabeza as integer = 1
public const humano_h_ultima_cabeza as integer = 40 'en verdad es hasta la 51, pero como son muchas estas las dejamos no seleccionables
public const humano_h_cuerpo_desnudo as integer = 21

public const elfo_h_primer_cabeza as integer = 101
public const elfo_h_ultima_cabeza as integer = 122
public const elfo_h_cuerpo_desnudo as integer = 210

public const drow_h_primer_cabeza as integer = 201
public const drow_h_ultima_cabeza as integer = 221
public const drow_h_cuerpo_desnudo as integer = 32

public const enano_h_primer_cabeza as integer = 301
public const enano_h_ultima_cabeza as integer = 319
public const enano_h_cuerpo_desnudo as integer = 53

public const gnomo_h_primer_cabeza as integer = 401
public const gnomo_h_ultima_cabeza as integer = 416
public const gnomo_h_cuerpo_desnudo as integer = 222
'**************************************************
public const humano_m_primer_cabeza as integer = 70
public const humano_m_ultima_cabeza as integer = 89
public const humano_m_cuerpo_desnudo as integer = 39

public const elfo_m_primer_cabeza as integer = 170
public const elfo_m_ultima_cabeza as integer = 188
public const elfo_m_cuerpo_desnudo as integer = 259

public const drow_m_primer_cabeza as integer = 270
public const drow_m_ultima_cabeza as integer = 288
public const drow_m_cuerpo_desnudo as integer = 40

public const enano_m_primer_cabeza as integer = 370
public const enano_m_ultima_cabeza as integer = 384
public const enano_m_cuerpo_desnudo as integer = 60

public const gnomo_m_primer_cabeza as integer = 470
public const gnomo_m_ultima_cabeza as integer = 484
public const gnomo_m_cuerpo_desnudo as integer = 260

'musica
public const mp3_inicio as byte = 101

public rawserverslist as string

public type tcolor
    r as byte
    g as byte
    b as byte
end type

public colorespj(0 to 50) as tcolor


public type tserverinfo
    ip as string
    puerto as integer
    desc as string
    passrecport as integer
end type

public serverslst() as tserverinfo
public serversrecibidos as boolean

public curserver as integer

public creandoclan as boolean
public clanname as string
public site as string

public userciego as boolean
public userestupido as boolean

public nores as boolean 'no cambiar la resolucion
public graphicsfile as string 'que graficos.ind usamos

public rainbufferindex as long
public fogatabufferindex as long

public const bcabeza = 1
public const bpiernaizquierda = 2
public const bpiernaderecha = 3
public const bbrazoderecho = 4
public const bbrazoizquierdo = 5
public const btorso = 6

'timers de gettickcount
public const tat = 2000
public const tus = 600

public const primerbodybarco = 84
public const ultimobodybarco = 87

public numescudosanims as integer

public armasherrero() as titemsconstruibles
public armadurasherrero() as titemsconstruibles
public objcarpintero() as titemsconstruibles
public carpinteromejorar() as titemsconstruibles
public herreromejorar() as titemsconstruibles

public usamacro as boolean
public cntd as byte


public const max_bancoinventory_slots as byte = 40
public userbancoinventory(1 to max_bancoinventory_slots) as inventory

public tradingusername as string

public tips() as string * 255
public const loopadeternum as integer = 999

'direcciones
public enum e_heading
    north = 1
    east = 2
    south = 3
    west = 4
end enum

'objetos
public const max_inventory_objs as integer = 10000
public const max_inventory_slots as byte = 30
public const max_normal_inventory_slots as byte = 20
public const max_npc_inventory_slots as byte = 50
public const maxhechi as byte = 35

public const inv_offer_slots as byte = 20
public const inv_gold_slots as byte = 1

public const maxskillpoints as byte = 100

public const maxatributos as byte = 38

public const flagoro as integer = max_inventory_slots + 1
public const gold_offer_slot as integer = inv_offer_slots + 1

public const fogata as integer = 1521


public enum eclass
    mage = 1    'mago
    cleric      'cl�rigo
    warrior     'guerrero
    assasin     'asesino
    thief       'ladr�n
    bard        'bardo
    druid       'druida
    bandit      'bandido
    paladin     'palad�n
    hunter      'cazador
    worker      'trabajador
    pirat       'pirata
end enum

public enum eciudad
    cullathorpe = 1
    cnix
    cbanderbill
    clindos
    carghal
end enum

enum eraza
    humano = 1
    elfo
    elfooscuro
    gnomo
    enano
end enum

public enum eskill
    magia = 1
    robar = 2
    tacticas = 3
    armas = 4
    meditar = 5
    apu�alar = 6
    ocultarse = 7
    supervivencia = 8
    talar = 9
    comerciar = 10
    defensa = 11
    pesca = 12
    mineria = 13
    carpinteria = 14
    herreria = 15
    liderazgo = 16
    domar = 17
    proyectiles = 18
    wrestling = 19
    navegacion = 20
end enum

public enum eatributos
    fuerza = 1
    agilidad = 2
    inteligencia = 3
    carisma = 4
    constitucion = 5
end enum

enum egenero
    hombre = 1
    mujer
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
    otarbolelfico = 36
    otmochilas = 37
    otcualquiera = 1000
end enum

public enum emochilas
    mediana = 1
    grande = 2
end enum

public maxinventoryslots as byte

public const fundirmetal as integer = 88

' determina el color del nick
public enum enickcolor
    iecriminal = &h1
    ieciudadano = &h2
    ieatacable = &h4
end enum

public enum egmcommands
    gmmessage = 1           '/gmsg
    showname                '/showname
    onlineroyalarmy         '/onlinereal
    onlinechaoslegion       '/onlinecaos
    gonearby                '/ircerca
    comment                 '/rem
    servertime              '/hora
    where                   '/donde
    creaturesinmap          '/nene
    warpmetotarget          '/teleploc
    warpchar                '/telep
    silence                 '/silenciar
    sosshowlist             '/show sos
    sosremove               'sosdone
    gotochar                '/ira
    invisible               '/invisible
    gmpanel                 '/panelgm
    requestuserlist         'listusu
    working                 '/trabajando
    hiding                  '/ocultando
    jail                    '/carcel
    killnpc                 '/rmata
    warnuser                '/advertencia
    editchar                '/mod
    requestcharinfo         '/info
    requestcharstats        '/stat
    requestchargold         '/bal
    requestcharinventory    '/inv
    requestcharbank         '/bov
    requestcharskills       '/skills
    revivechar              '/revivir
    onlinegm                '/onlinegm
    onlinemap               '/onlinemap
    forgive                 '/perdon
    kick                    '/echar
    execute                 '/ejecutar
    banchar                 '/ban
    unbanchar               '/unban
    npcfollow               '/seguir
    summonchar              '/sum
    spawnlistrequest        '/cc
    spawncreature           'spa
    resetnpcinventory       '/resetinv
    cleanworld              '/limpiar
    servermessage           '/rmsg
    nicktoip                '/nick2ip
    iptonick                '/ip2nick
    guildonlinemembers      '/onclan
    teleportcreate          '/ct
    teleportdestroy         '/dt
    raintoggle              '/lluvia
    setchardescription      '/setdesc
    forcemiditomap          '/forcemidimap
    forcewavetomap          '/forcewavmap
    royalarmymessage        '/realmsg
    chaoslegionmessage      '/caosmsg
    citizenmessage          '/ciumsg
    criminalmessage         '/crimsg
    talkasnpc               '/talkas
    destroyallitemsinarea   '/massdest
    acceptroyalcouncilmember '/aceptconse
    acceptchaoscouncilmember '/aceptconsecaos
    itemsinthefloor         '/piso
    makedumb                '/estupido
    makedumbnomore          '/noestupido
    dumpiptables            '/dumpsecurity
    councilkick             '/kickconse
    settrigger              '/trigger
    asktrigger              '/trigger with no args
    bannediplist            '/baniplist
    bannedipreload          '/banipreload
    guildmemberlist         '/miembrosclan
    guildban                '/banclan
    banip                   '/banip
    unbanip                 '/unbanip
    createitem              '/ci
    destroyitems            '/dest
    chaoslegionkick         '/nocaos
    royalarmykick           '/noreal
    forcemidiall            '/forcemidi
    forcewaveall            '/forcewav
    removepunishment        '/borrarpena
    tileblockedtoggle       '/bloq
    killnpcnorespawn        '/mata
    killallnearbynpcs       '/masskill
    lastip                  '/lastip
    changemotd              '/motdcambia
    setmotd                 'zmotd
    systemmessage           '/smsg
    createnpc               '/acc
    createnpcwithrespawn    '/racc
    imperialarmour          '/ai1 - 4
    chaosarmour             '/ac1 - 4
    navigatetoggle          '/nave
    serveropentouserstoggle '/habilitar
    turnoffserver           '/apagar
    turncriminal            '/conden
    resetfactions           '/rajar
    removecharfromguild     '/rajarclan
    requestcharmail         '/lastemail
    alterpassword           '/apass
    altermail               '/aemail
    altername               '/aname
    togglecentinelactivated '/centinelaactivado
    dobackup                '/dobackup
    showguildmessages       '/showcmsg
    savemap                 '/guardamapa
    changemapinfopk         '/modmapinfo pk
    changemapinfobackup     '/modmapinfo backup
    changemapinforestricted '/modmapinfo restringir
    changemapinfonomagic    '/modmapinfo magiasinefecto
    changemapinfonoinvi     '/modmapinfo invisinefecto
    changemapinfonoresu     '/modmapinfo resusinefecto
    changemapinfoland       '/modmapinfo terreno
    changemapinfozone       '/modmapinfo zona
    changemapinfostealnpc   '/modmapinfo robonpcm
    changemapinfonoocultar  '/modmapinfo ocultarsinefecto
    changemapinfonoinvocar  '/modmapinfo invocarsinefecto
    savechars               '/grabar
    cleansos                '/borrar sos
    showserverform          '/show int
    night                   '/noche
    kickallchars            '/echartodospjs
    reloadnpcs              '/reloadnpcs
    reloadserverini         '/reloadsini
    reloadspells            '/reloadhechizos
    reloadobjects           '/reloadobj
    restart                 '/reiniciar
    resetautoupdate         '/autoupdate
    chatcolor               '/chatcolor
    ignored                 '/ignorado
    checkslot               '/slot
    setinivar               '/setinivar llave clave valor
    createpretorianclan     '/crearpretorianos
    removepretorianclan     '/eliminarpretorianos
    enabledenounces         '/denuncias
    showdenounceslist       '/show denuncias
    mapmessage              '/mapmsg
    setdialog               '/setdialog
    impersonate             '/impersonar
    imitate                 '/mimetizar
    recordadd
    recordremove
    recordaddobs
    recordlistrequest
    recorddetailsrequest
end enum

'
' mensajes
'
' mensaje_*  --> mensajes de texto que se muestran en el cuadro de texto
'

public const mensaje_criatura_falla_golpe as string = "���la criatura fall� el golpe!!!"
public const mensaje_criatura_matado as string = "���la criatura te ha matado!!!"
public const mensaje_rechazo_ataque_escudo as string = "���has rechazado el ataque con el escudo!!!"
public const mensaje_usuario_rechazo_ataque_escudo  as string = "���el usuario rechaz� el ataque con su escudo!!!"
public const mensaje_fallado_golpe as string = "���has fallado el golpe!!!"
public const mensaje_seguro_activado as string = ">>seguro activado<<"
public const mensaje_seguro_desactivado as string = ">>seguro desactivado<<"
public const mensaje_pierde_nobleza as string = "��has perdido puntaje de nobleza y ganado puntaje de criminalidad!! si sigues ayudando a criminales te convertir�s en uno de ellos y ser�s perseguido por las tropas de las ciudades."
public const mensaje_usar_meditando as string = "�est�s meditando! debes dejar de meditar para usar objetos."

public const mensaje_seguro_resu_on as string = "seguro de resurreccion activado"
public const mensaje_seguro_resu_off as string = "seguro de resurreccion desactivado"

public const mensaje_golpe_cabeza as string = "��la criatura te ha pegado en la cabeza por "
public const mensaje_golpe_brazo_izq as string = "��la criatura te ha pegado el brazo izquierdo por "
public const mensaje_golpe_brazo_der as string = "��la criatura te ha pegado el brazo derecho por "
public const mensaje_golpe_pierna_izq as string = "��la criatura te ha pegado la pierna izquierda por "
public const mensaje_golpe_pierna_der as string = "��la criatura te ha pegado la pierna derecha por "
public const mensaje_golpe_torso  as string = "��la criatura te ha pegado en el torso por "

' mensaje_[12]: aparecen antes y despues del valor de los mensajes anteriores (mensaje_golpe_*)
public const mensaje_1 as string = "��"
public const mensaje_2 as string = "!!"
public const mensaje_11 as string = "�"
public const mensaje_22 as string = "!"

public const mensaje_golpe_criatura_1 as string = "��le has pegado a la criatura por "

public const mensaje_ataque_fallo as string = " te atac� y fall�!!"

public const mensaje_recive_impacto_cabeza as string = " te ha pegado en la cabeza por "
public const mensaje_recive_impacto_brazo_izq as string = " te ha pegado el brazo izquierdo por "
public const mensaje_recive_impacto_brazo_der as string = " te ha pegado el brazo derecho por "
public const mensaje_recive_impacto_pierna_izq as string = " te ha pegado la pierna izquierda por "
public const mensaje_recive_impacto_pierna_der as string = " te ha pegado la pierna derecha por "
public const mensaje_recive_impacto_torso as string = " te ha pegado en el torso por "

public const mensaje_produce_impacto_1 as string = "��le has pegado a "
public const mensaje_produce_impacto_cabeza as string = " en la cabeza por "
public const mensaje_produce_impacto_brazo_izq as string = " en el brazo izquierdo por "
public const mensaje_produce_impacto_brazo_der as string = " en el brazo derecho por "
public const mensaje_produce_impacto_pierna_izq as string = " en la pierna izquierda por "
public const mensaje_produce_impacto_pierna_der as string = " en la pierna derecha por "
public const mensaje_produce_impacto_torso as string = " en el torso por "

public const mensaje_trabajo_magia as string = "haz click sobre el objetivo..."
public const mensaje_trabajo_pesca as string = "haz click sobre el sitio donde quieres pescar..."
public const mensaje_trabajo_robar as string = "haz click sobre la v�ctima..."
public const mensaje_trabajo_talar as string = "haz click sobre el �rbol..."
public const mensaje_trabajo_mineria as string = "haz click sobre el yacimiento..."
public const mensaje_trabajo_fundirmetal as string = "haz click sobre la fragua..."
public const mensaje_trabajo_proyectiles as string = "haz click sobre la victima..."

public const mensaje_entrar_party_1 as string = "si deseas entrar en una party con "
public const mensaje_entrar_party_2 as string = ", escribe /entrarparty"

public const mensaje_nene as string = "cantidad de npcs: "

public const mensaje_fragshooter_te_ha_matado as string = "te ha matado!"
public const mensaje_fragshooter_has_matado as string = "has matado a"
public const mensaje_fragshooter_has_ganado as string = "has ganado "
public const mensaje_fragshooter_puntos_de_experiencia as string = "puntos de experiencia."

public const mensaje_no_ves_nada_interesante as string = "no ves nada interesante."
public const mensaje_has_matado_a as string = "has matado a "
public const mensaje_has_ganado_expe_1 as string = "has ganado "
public const mensaje_has_ganado_expe_2 as string = " puntos de experiencia."
public const mensaje_te_ha_matado as string = " te ha matado!"

public const mensaje_hogar as string = "has llegado a tu hogar. el viaje ha finalizado."
public const mensaje_hogar_cancel as string = "tu viaje ha sido cancelado."

public enum emessages
    dontseeanything
    npcswing
    npckilluser
    blockedwithshielduser
    blockedwithshieldother
    userswing
    safemodeon
    safemodeoff
    resuscitationsafeoff
    resuscitationsafeon
    nobilitylost
    cantusewhilemeditating
    npchituser
    userhitnpc
    userattackedswing
    userhittedbyuser
    userhitteduser
    workrequesttarget
    havekilleduser
    userkill
    earnexp
    gohome
    cancelgohome
    finishhome
end enum

'inventario
type inventory
    objindex as integer
    name as string
    grhindex as integer
    '[alejo]: tipo de datos ahora es long
    amount as long
    '[/alejo]
    equipped as byte
    valor as single
    objtype as integer
    maxdef as integer
    mindef as integer 'budi
    maxhit as integer
    minhit as integer
end type

type npcinv
    objindex as integer
    name as string
    grhindex as integer
    amount as integer
    valor as single
    objtype as integer
    maxdef as integer
    mindef as integer
    maxhit as integer
    minhit as integer
    c1 as string
    c2 as string
    c3 as string
    c4 as string
    c5 as string
    c6 as string
    c7 as string
end type

type treputacion 'fama del usuario
    noblerep as long
    burguesrep as long
    pleberep as long
    ladronesrep as long
    bandidorep as long
    asesinorep as long
    
    promedio as long
end type

type testadisticasusu
    ciudadanosmatados as long
    criminalesmatados as long
    usuariosmatados as long
    npcsmatados as long
    clase as string
    penacarcel as long
end type

type titemsconstruibles
    name as string
    objindex as integer
    grhindex as integer
    linh as integer
    linp as integer
    lino as integer
    madera as integer
    maderaelfica as integer
    upgrade as integer
    upgradename as string
    upgradegrhindex as integer
end type

public nombres as boolean

'user status vars
global otroinventario(1 to max_inventory_slots) as inventory

public userhechizos(1 to maxhechi) as integer

public npcinventory(1 to max_npc_inventory_slots) as npcinv
public usermeditar as boolean
public username as string
public userpassword as string
public usermaxhp as integer
public userminhp as integer
public usermaxman as integer
public userminman as integer
public usermaxsta as integer
public userminsta as integer
public usermaxagu as byte
public userminagu as byte
public usermaxham as byte
public userminham as byte
public usergld as long
public userlvl as integer
public userport as integer
public userserverip as string
public userestado as byte '0 = vivo & 1 = muerto
public userpasarnivel as long
public userexp as long
public userreputacion as treputacion
public userestadisticas as testadisticasusu
public userdescansar as boolean
public tipf as string
public primeravez as boolean
public bshowtutorial as boolean
public fpsflag as boolean
public pausa as boolean
public userparalizado as boolean
public usernavegando as boolean
public userhogar as eciudad

public userfuerza as byte
public useragilidad as byte

public userweaponeqpslot as byte
public userarmoureqpslot as byte
public userhelmeqpslot as byte
public usershieldeqpslot as byte

'<-------------------------nuevo-------------------------->
public comerciando as boolean
public mirandoforo as boolean
public mirandoasignarskills as boolean
public mirandoestadisticas as boolean
public mirandoparty as boolean
public mirandocarpinteria as boolean
public mirandoherreria as boolean
'<-------------------------nuevo-------------------------->

public userclase as eclass
public usersexo as egenero
public userraza as eraza
public useremail as string

public const numciudades as byte = 5
public const numskills as byte = 20
public const numatributos as byte = 5
public const numclases as byte = 12
public const numrazas as byte = 5

public userskills(1 to numskills) as byte
public porcentajeskills(1 to numskills) as byte
public skillsnames(1 to numskills) as string

public useratributos(1 to numatributos) as byte
public atributosnames(1 to numatributos) as string

public ciudades(1 to numciudades) as string

public listarazas(1 to numrazas) as string
public listaclases(1 to numclases) as string

public skillpoints as integer
public alocados as integer
public flags() as integer
public oscuridad as integer
public logged as boolean

public usingskill as integer

public md5hushyo as string * 16

public pingtime as long

public espartyleader as boolean

public enum e_modo
    normal = 1
    crearnuevopj = 2
    dados = 3
end enum

public estadologin as e_modo
   
public enum fxmeditar
    chico = 4
    mediano = 5
    grande = 6
    xgrande = 16
    xxgrande = 34
end enum

public enum eclantype
    ct_royalarmy
    ct_evil
    ct_neutral
    ct_gm
    ct_legal
    ct_criminal
end enum

public enum eeditoptions
    eo_gold = 1
    eo_experience
    eo_body
    eo_head
    eo_citicenskilled
    eo_criminalskilled
    eo_level
    eo_class
    eo_skills
    eo_skillpointsleft
    eo_nobleza
    eo_asesino
    eo_sex
    eo_raza
    eo_addgold
    eo_vida
    eo_poss
end enum

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

'server stuff
public requestpostimer as integer 'used in main loop
public stxtbuffer as string 'holds temp raw data from server
public stxtbuffercmsg as string 'holds temp raw data from server
public sendnewchar as boolean 'used during login
public connected as boolean 'true when connected to server
public downloadingmap as boolean 'currently downloading a map from server
public usermap as integer

'control
public prgrun as boolean 'when true the program ends

public ipdelservidor as string
public puertodelservidor as string

'
'********** funciones api ***********
'

public declare function gettickcount lib "kernel32" () as long

'para escribir y leer variables
public declare function writeprivateprofilestring lib "kernel32" alias "writeprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpstring as string, byval lpfilename as string) as long
public declare function getprivateprofilestring lib "kernel32" alias "getprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpdefault as string, byval lpreturnedstring as string, byval nsize as long, byval lpfilename as string) as long

'teclado
public declare function getkeystate lib "user32" (byval nvirtkey as long) as integer
public declare function getasynckeystate lib "user32" (byval nvirtkey as long) as integer

public declare sub sleep lib "kernel32" (byval dwmilliseconds as long)

'para ejecutar el browser y programas externos
public const sw_shownormal as long = 1
public declare function shellexecute lib "shell32.dll" alias "shellexecutea" (byval hwnd as long, byval lpoperation as string, byval lpfile as string, byval lpparameters as string, byval lpdirectory as string, byval nshowcmd as long) as long

'lista de cabezas
public type tindicecabeza
    head(1 to 4) as integer
end type

public type tindicecuerpo
    body(1 to 4) as integer
    headoffsetx as integer
    headoffsety as integer
end type

public type tindicefx
    animacion as integer
    offsetx as integer
    offsety as integer
end type

public esperandolevel as boolean

' tipos de mensajes
public enum eforummsgtype
    iegeneral
    iegeneral_sticky
    iereal
    iereal_sticky
    iecaos
    iecaos_sticky
end enum

' indica los privilegios para visualizar los diferentes foros
public enum eforumvisibility
    iegeneral_member = &h1
    iereal_member = &h2
    iecaos_member = &h4
end enum

' indica el tipo de foro
public enum eforumtype
    iegeneral
    iereal
    iecaos
end enum

' limite de posts
public const max_sticky_post as byte = 5
public const max_general_post as byte = 30
public const sticky_forum_offset as byte = 50

' estructura contenedora de mensajes
public type tforo
    stickytitle(1 to max_sticky_post) as string
    stickypost(1 to max_sticky_post) as string
    stickyauthor(1 to max_sticky_post) as string
    generaltitle(1 to max_general_post) as string
    generalpost(1 to max_general_post) as string
    generalauthor(1 to max_general_post) as string
end type

' 1 foro general y 2 faccionarios
public foros(0 to 2) as tforo

' forum info handler
public clsforos as clsforum

'fragshooter variables
public fragshootercapturepending as boolean
public fragshooternickname as string
public fragshooterkilledsomeone as boolean


public traveling as boolean

public bshowguildnews as boolean
public guildnames() as string
public guildmembers() as string

public const offset_head as integer = -34

public enum esmtype
    sresucitation
    ssafemode
    mspells
    mwork
end enum

public const sm_cant as byte = 4
public smstatus(sm_cant) as boolean

'hardcoded grhs and items
public const grh_ini_sm as integer = 4978

public const oro_index as integer = 12
public const oro_grh as integer = 511

public const grh_half_star as integer = 5357
public const grh_full_star as integer = 5358
public const grh_glow_star as integer = 5359

public const lh_grh as integer = 724
public const lp_grh as integer = 725
public const lo_grh as integer = 723

public const madera_grh as integer = 550
public const madera_elfica_grh as integer = 1999

public picmouseicon as picture

public enum emovetype
    inventory = 1
    bank
end enum

public const mp3_initial_index as integer = 1000
