attribute vb_name = "protocol"
'**************************************************************
' protocol.bas - handles all incoming / outgoing messages for client-server communications.
' uses a binary protocol designed by myself.
'
' designed and implemented by juan mart�n sotuyo dodero (maraxus)
' (juansotuyo@gmail.com)
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

''
'handles all incoming / outgoing packets for client - server communications
'the binary prtocol here used was designed by juan mart�n sotuyo dodero.
'this is the first time it's used in alkon, though the second time it's coded.
'this implementation has several enhacements from the first design.
'
' @file     protocol.bas
' @author   juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version  1.0.0
' @date     20060517

option explicit

''
' todo : /banip y /unbanip ya no trabajan con nicks. esto lo puede mentir en forma local el cliente con un paquete a nicktoip

''
'when we have a list of strings, we use this to separate them and prevent
'having too many string lengths in the queue. yes, each string is null-terminated :p
private const separator as string * 1 = vbnullchar

private type tfont
    red as byte
    green as byte
    blue as byte
    bold as boolean
    italic as boolean
end type

private enum serverpacketid
    logged                  ' logged
    removedialogs           ' qtdl
    removechardialog        ' qdl
    navigatetoggle          ' naveg
    disconnect              ' finok
    commerceend             ' fincomok
    bankend                 ' finbanok
    commerceinit            ' initcom
    bankinit                ' initbanco
    usercommerceinit        ' initcomusu
    usercommerceend         ' fincomusuok
    showblacksmithform      ' sfh
    showcarpenterform       ' sfc
    npcswing                ' n1
    npckilluser             ' 6
    blockedwithshielduser   ' 7
    blockedwithshieldother  ' 8
    userswing               ' u1
    updateneeded            ' reau
    safemodeon              ' segon
    safemodeoff             ' segoff
    resuscitationsafeon
    resuscitationsafeoff
    nobilitylost            ' pn
    cantusewhilemeditating  ' m!
    updatesta               ' ass
    updatemana              ' asm
    updatehp                ' ash
    updategold              ' asg
    updateexp               ' ase
    changemap               ' cm
    posupdate               ' pu
    npchituser              ' n2
    userhitnpc              ' u2
    userattackedswing       ' u3
    userhittedbyuser        ' n4
    userhitteduser          ' n5
    chatoverhead            ' ||
    consolemsg              ' || - beware!! its the same as above, but it was properly splitted
    guildchat               ' |+
    showmessagebox          ' !!
    userindexinserver       ' iu
    usercharindexinserver   ' ip
    charactercreate         ' cc
    characterremove         ' bp
    characterchangenick
    charactermove           ' mp, +, * and _ '
    forcecharmove
    characterchange         ' cp
    objectcreate            ' ho
    objectdelete            ' bo
    blockposition           ' bq
    playmidi                ' tm
    playwave                ' tw
    guildlist               ' gl
    areachanged             ' ca
    pausetoggle             ' bkw
    raintoggle              ' llu
    createfx                ' cfx
    updateuserstats         ' est
    workrequesttarget       ' t01
    changeinventoryslot     ' csi
    changebankslot          ' sbo
    changespellslot         ' shs
    atributes               ' atr
    blacksmithweapons       ' lah
    blacksmitharmors        ' lar
    carpenterobjects        ' obr
    restok                  ' dok
    errormsg                ' err
    blind                   ' cegu
    dumb                    ' dumb
    showsignal              ' mcar
    changenpcinventoryslot  ' npci
    updatehungerandthirst   ' ehys
    fame                    ' fama
    ministats               ' mest
    levelup                 ' suni
    addforummsg             ' fmsg
    showforumform           ' mfor
    setinvisible            ' nover
    diceroll                ' dados
    meditatetoggle          ' medok
    blindnomore             ' nsegue
    dumbnomore              ' nestup
    sendskills              ' skills
    trainercreaturelist     ' lstcri
    guildnews               ' guildne
    offerdetails            ' peacede & alliede
    alianceproposalslist    ' alliepr
    peaceproposalslist      ' peacepr
    characterinfo           ' chrinfo
    guildleaderinfo         ' leaderi
    guilddetails            ' clandet
    showguildfundationform  ' showfun
    paralizeok              ' paradok
    showuserrequest         ' peticio
    tradeok                 ' transok
    bankok                  ' bancook
    changeusertradeslot     ' comusuinv
    sendnight               ' noc
    pong
    updatetagandstatus
    
    'gm messages
    spawnlist               ' spl
    showsosform             ' msos
    showmotdeditionform     ' zmotd
    showgmpanelform         ' abpanel
    usernamelist            ' listusu
end enum

private enum clientpacketid
    loginexistingchar       'ologin
    throwdices              'tirdad
    loginnewchar            'nlogin
    talk                    ';
    yell                    '-
    whisper                 '\
    walk                    'm
    requestpositionupdate   'rpu
    attack                  'at
    pickup                  'ag
    combatmodetoggle        'tab        - should be hanlded just by the client!!
    safetoggle              '/seg & seg  (seg's behaviour has to be coded in the client)
    resuscitationsafetoggle
    requestguildleaderinfo  'glinfo
    requestatributes        'atr
    requestfame             'fama
    requestskills           'eski
    requestministats        'fest
    commerceend             'fincom
    usercommerceend         'fincomusu
    bankend                 'finban
    usercommerceok          'comusuok
    usercommercereject      'comusuno
    drop                    'ti
    castspell               'lh
    leftclick               'lc
    doubleclick             'rc
    work                    'uk
    usespellmacro           'umh
    useitem                 'usa
    craftblacksmith         'cns
    craftcarpenter          'cnc
    workleftclick           'wlc
    createnewguild          'cig
    spellinfo               'infs
    equipitem               'equi
    changeheading           'chea
    modifyskills            'skse
    train                   'entr
    commercebuy             'comp
    bankextractitem         'reti
    commercesell            'vend
    bankdeposit             'depo
    forumpost               'demsg
    movespell               'desphe
    movebank
    clancodexupdate         'descod
    usercommerceoffer       'ofrecer
    guildacceptpeace        'aceppeat
    guildrejectalliance     'recpalia
    guildrejectpeace        'recppeat
    guildacceptalliance     'acepalia
    guildofferpeace         'peaceoff
    guildofferalliance      'allieoff
    guildalliancedetails    'alliedet
    guildpeacedetails       'peacedet
    guildrequestjoinerinfo  'envcomen
    guildallianceproplist   'envalpro
    guildpeaceproplist      'envpropp
    guilddeclarewar         'decguerr
    guildnewwebsite         'newwebsi
    guildacceptnewmember    'aceptari
    guildrejectnewmember    'rechazar
    guildkickmember         'echarcla
    guildupdatenews         'actgnews
    guildmemberinfo         '1hrinfo<
    guildopenelections      'abreelec
    guildrequestmembership  'solicitud
    guildrequestdetails     'clandetails
    online                  '/online
    quit                    '/salir
    guildleave              '/salirclan
    requestaccountstate     '/balance
    petstand                '/quieto
    petfollow               '/acompa�ar
    trainlist               '/entrenar
    rest                    '/descansar
    meditate                '/meditar
    resucitate              '/resucitar
    heal                    '/curar
    help                    '/ayuda
    requeststats            '/est
    commercestart           '/comerciar
    bankstart               '/boveda
    enlist                  '/enlistar
    information             '/informacion
    reward                  '/recompensa
    requestmotd             '/motd
    uptime                  '/uptime
    partyleave              '/salirparty
    partycreate             '/crearparty
    partyjoin               '/party
    inquiry                 '/encuesta ( with no params )
    guildmessage            '/cmsg
    partymessage            '/pmsg
    centinelreport          '/centinela
    guildonline             '/onlineclan
    partyonline             '/onlineparty
    councilmessage          '/bmsg
    rolemasterrequest       '/rol
    gmrequest               '/gm
    bugreport               '/_bug
    changedescription       '/desc
    guildvote               '/voto
    punishments             '/penas
    changepassword          '/contrase�a
    gamble                  '/apostar
    inquiryvote             '/encuesta ( with parameters )
    leavefaction            '/retirar ( with no arguments )
    bankextractgold         '/retirar ( with arguments )
    bankdepositgold         '/depositar
    denounce                '/denunciar
    guildfundate            '/fundarclan
    partykick               '/echarparty
    partysetleader          '/partylider
    partyacceptmember       '/acceptparty
    ping                    '/ping
    
    'gm messages
    gmmessage               '/gmsg
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
    asktrigger              '/trigger with no arguments
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
end enum

public enum fonttypenames
    fonttype_talk
    fonttype_fight
    fonttype_warning
    fonttype_info
    fonttype_infobold
    fonttype_ejecucion
    fonttype_party
    fonttype_veneno
    fonttype_guild
    fonttype_server
    fonttype_guildmsg
    fonttype_consejo
    fonttype_consejocaos
    fonttype_consejovesa
    fonttype_consejocaosvesa
    fonttype_centinela
    fonttype_gmmsg
    fonttype_gm
    fonttype_citizen
    fonttype_conse
    fonttype_dios
    
end enum

public fonttypes(20) as tfont

''
' initializes the fonts array

public sub initfonts()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with fonttypes(fonttypenames.fonttype_talk)
        .red = 255
        .green = 255
        .blue = 255
    end with
    
    with fonttypes(fonttypenames.fonttype_fight)
        .red = 255
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_warning)
        .red = 32
        .green = 51
        .blue = 223
        .bold = 1
        .italic = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_info)
        .red = 65
        .green = 190
        .blue = 156
    end with
    
    with fonttypes(fonttypenames.fonttype_infobold)
        .red = 65
        .green = 190
        .blue = 156
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_ejecucion)
        .red = 130
        .green = 130
        .blue = 130
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_party)
        .red = 255
        .green = 180
        .blue = 250
    end with
    
    fonttypes(fonttypenames.fonttype_veneno).green = 255
    
    with fonttypes(fonttypenames.fonttype_guild)
        .red = 255
        .green = 255
        .blue = 255
        .bold = 1
    end with
    
    fonttypes(fonttypenames.fonttype_server).green = 185
    
    with fonttypes(fonttypenames.fonttype_guildmsg)
        .red = 228
        .green = 199
        .blue = 27
    end with
    
    with fonttypes(fonttypenames.fonttype_consejo)
        .red = 130
        .green = 130
        .blue = 255
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_consejocaos)
        .red = 255
        .green = 60
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_consejovesa)
        .green = 200
        .blue = 255
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_consejocaosvesa)
        .red = 255
        .green = 50
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_centinela)
        .green = 255
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_gmmsg)
        .red = 255
        .green = 255
        .blue = 255
        .italic = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_gm)
        .red = 30
        .green = 255
        .blue = 30
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_citizen)
        .blue = 200
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_conse)
        .red = 30
        .green = 150
        .blue = 30
        .bold = 1
    end with
    
    with fonttypes(fonttypenames.fonttype_dios)
        .red = 250
        .green = 250
        .blue = 150
        .bold = 1
    end with
end sub

''
' handles incoming data.

public sub handleincomingdata()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
on error resume next
    select case incomingdata.peekbyte()
        case serverpacketid.logged                  ' logged
            call handlelogged
        
        case serverpacketid.removedialogs           ' qtdl
            call handleremovedialogs
        
        case serverpacketid.removechardialog        ' qdl
            call handleremovechardialog
        
        case serverpacketid.navigatetoggle          ' naveg
            call handlenavigatetoggle
        
        case serverpacketid.disconnect              ' finok
            call handledisconnect
        
        case serverpacketid.commerceend             ' fincomok
            call handlecommerceend
        
        case serverpacketid.bankend                 ' finbanok
            call handlebankend
        
        case serverpacketid.commerceinit            ' initcom
            call handlecommerceinit
        
        case serverpacketid.bankinit                ' initbanco
            call handlebankinit
        
        case serverpacketid.usercommerceinit        ' initcomusu
            call handleusercommerceinit
        
        case serverpacketid.usercommerceend         ' fincomusuok
            call handleusercommerceend
        
        case serverpacketid.showblacksmithform      ' sfh
            call handleshowblacksmithform
        
        case serverpacketid.showcarpenterform       ' sfc
            call handleshowcarpenterform
        
        case serverpacketid.npcswing                ' n1
            call handlenpcswing
        
        case serverpacketid.npckilluser             ' 6
            call handlenpckilluser
        
        case serverpacketid.blockedwithshielduser   ' 7
            call handleblockedwithshielduser
        
        case serverpacketid.blockedwithshieldother  ' 8
            call handleblockedwithshieldother
        
        case serverpacketid.userswing               ' u1
            call handleuserswing
        
        case serverpacketid.updateneeded            ' reau
            call handleupdateneeded
        
        case serverpacketid.safemodeon              ' segon
            call handlesafemodeon
        
        case serverpacketid.safemodeoff             ' segoff
            call handlesafemodeoff
            
        case serverpacketid.resuscitationsafeoff
            call handleresuscitationsafeoff
        
        case serverpacketid.resuscitationsafeon
            call handleresuscitationsafeon
        
        case serverpacketid.nobilitylost            ' pn
            call handlenobilitylost
        
        case serverpacketid.cantusewhilemeditating  ' m!
            call handlecantusewhilemeditating
        
        case serverpacketid.updatesta               ' ass
            call handleupdatesta
        
        case serverpacketid.updatemana              ' asm
            call handleupdatemana
        
        case serverpacketid.updatehp                ' ash
            call handleupdatehp
        
        case serverpacketid.updategold              ' asg
            call handleupdategold
        
        case serverpacketid.updateexp               ' ase
            call handleupdateexp
        
        case serverpacketid.changemap               ' cm
            call handlechangemap
        
        case serverpacketid.posupdate               ' pu
            call handleposupdate
        
        case serverpacketid.npchituser              ' n2
            call handlenpchituser
        
        case serverpacketid.userhitnpc              ' u2
            call handleuserhitnpc
        
        case serverpacketid.userattackedswing       ' u3
            call handleuserattackedswing
        
        case serverpacketid.userhittedbyuser        ' n4
            call handleuserhittedbyuser
        
        case serverpacketid.userhitteduser          ' n5
            call handleuserhitteduser
        
        case serverpacketid.chatoverhead            ' ||
            call handlechatoverhead
        
        case serverpacketid.consolemsg              ' || - beware!! its the same as above, but it was properly splitted
            call handleconsolemessage
        
        case serverpacketid.guildchat               ' |+
            call handleguildchat
        
        case serverpacketid.showmessagebox          ' !!
            call handleshowmessagebox
        
        case serverpacketid.userindexinserver       ' iu
            call handleuserindexinserver
        
        case serverpacketid.usercharindexinserver   ' ip
            call handleusercharindexinserver
        
        case serverpacketid.charactercreate         ' cc
            call handlecharactercreate
        
        case serverpacketid.characterremove         ' bp
            call handlecharacterremove
        
        case serverpacketid.characterchangenick
            call handlecharacterchangenick
            
        case serverpacketid.charactermove           ' mp, +, * and _ '
            call handlecharactermove
            
        case serverpacketid.forcecharmove
            call handleforcecharmove
        
        case serverpacketid.characterchange         ' cp
            call handlecharacterchange
        
        case serverpacketid.objectcreate            ' ho
            call handleobjectcreate
        
        case serverpacketid.objectdelete            ' bo
            call handleobjectdelete
        
        case serverpacketid.blockposition           ' bq
            call handleblockposition
        
        case serverpacketid.playmidi                ' tm
            call handleplaymidi
        
        case serverpacketid.playwave                ' tw
            call handleplaywave
        
        case serverpacketid.guildlist               ' gl
            call handleguildlist
        
        case serverpacketid.areachanged             ' ca
            call handleareachanged
        
        case serverpacketid.pausetoggle             ' bkw
            call handlepausetoggle
        
        case serverpacketid.raintoggle              ' llu
            call handleraintoggle
        
        case serverpacketid.createfx                ' cfx
            call handlecreatefx
        
        case serverpacketid.updateuserstats         ' est
            call handleupdateuserstats
        
        case serverpacketid.workrequesttarget       ' t01
            call handleworkrequesttarget
        
        case serverpacketid.changeinventoryslot     ' csi
            call handlechangeinventoryslot
        
        case serverpacketid.changebankslot          ' sbo
            call handlechangebankslot
        
        case serverpacketid.changespellslot         ' shs
            call handlechangespellslot
        
        case serverpacketid.atributes               ' atr
            call handleatributes
        
        case serverpacketid.blacksmithweapons       ' lah
            call handleblacksmithweapons
        
        case serverpacketid.blacksmitharmors        ' lar
            call handleblacksmitharmors
        
        case serverpacketid.carpenterobjects        ' obr
            call handlecarpenterobjects
        
        case serverpacketid.restok                  ' dok
            call handlerestok
        
        case serverpacketid.errormsg                ' err
            call handleerrormessage
        
        case serverpacketid.blind                   ' cegu
            call handleblind
        
        case serverpacketid.dumb                    ' dumb
            call handledumb
        
        case serverpacketid.showsignal              ' mcar
            call handleshowsignal
        
        case serverpacketid.changenpcinventoryslot  ' npci
            call handlechangenpcinventoryslot
        
        case serverpacketid.updatehungerandthirst   ' ehys
            call handleupdatehungerandthirst
        
        case serverpacketid.fame                    ' fama
            call handlefame
        
        case serverpacketid.ministats               ' mest
            call handleministats
        
        case serverpacketid.levelup                 ' suni
            call handlelevelup
        
        case serverpacketid.addforummsg             ' fmsg
            call handleaddforummessage
        
        case serverpacketid.showforumform           ' mfor
            call handleshowforumform
        
        case serverpacketid.setinvisible            ' nover
            call handlesetinvisible
        
        case serverpacketid.diceroll                ' dados
            call handlediceroll
        
        case serverpacketid.meditatetoggle          ' medok
            call handlemeditatetoggle
        
        case serverpacketid.blindnomore             ' nsegue
            call handleblindnomore
        
        case serverpacketid.dumbnomore              ' nestup
            call handledumbnomore
        
        case serverpacketid.sendskills              ' skills
            call handlesendskills
        
        case serverpacketid.trainercreaturelist     ' lstcri
            call handletrainercreaturelist
        
        case serverpacketid.guildnews               ' guildne
            call handleguildnews
        
        case serverpacketid.offerdetails            ' peacede and alliede
            call handleofferdetails
        
        case serverpacketid.alianceproposalslist    ' alliepr
            call handlealianceproposalslist
        
        case serverpacketid.peaceproposalslist      ' peacepr
            call handlepeaceproposalslist
        
        case serverpacketid.characterinfo           ' chrinfo
            call handlecharacterinfo
        
        case serverpacketid.guildleaderinfo         ' leaderi
            call handleguildleaderinfo
        
        case serverpacketid.guilddetails            ' clandet
            call handleguilddetails
        
        case serverpacketid.showguildfundationform  ' showfun
            call handleshowguildfundationform
        
        case serverpacketid.paralizeok              ' paradok
            call handleparalizeok
        
        case serverpacketid.showuserrequest         ' peticio
            call handleshowuserrequest
        
        case serverpacketid.tradeok                 ' transok
            call handletradeok
        
        case serverpacketid.bankok                  ' bancook
            call handlebankok
        
        case serverpacketid.changeusertradeslot     ' comusuinv
            call handlechangeusertradeslot
            
        case serverpacketid.sendnight               ' noc
            call handlesendnight
        
        case serverpacketid.pong
            call handlepong
        
        case serverpacketid.updatetagandstatus
            call handleupdatetagandstatus

        
        '*******************
        'gm messages
        '*******************
        case serverpacketid.spawnlist               ' spl
            call handlespawnlist
        
        case serverpacketid.showsosform             ' rsos and msos
            call handleshowsosform
        
        case serverpacketid.showmotdeditionform     ' zmotd
            call handleshowmotdeditionform
        
        case serverpacketid.showgmpanelform         ' abpanel
            call handleshowgmpanelform
        
        case serverpacketid.usernamelist            ' listusu
            call handleusernamelist
        
#if seguridadalkon then
        case else
            call handleincomingdataex
#else
        case else
            'error : abort!
            exit sub
#end if
    end select
    
    'done with this packet, move on to next one
    if incomingdata.length > 0 and err.number <> incomingdata.notenoughdataerrcode then
        err.clear
        call handleincomingdata
    end if
end sub

''
' handles the logged message.

private sub handlelogged()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    ' variable initialization
    enginerun = true
    nombres = true
    
    'set connected state
    call setconnected
    
    'show tip
    if tipf = "1" and primeravez then
        call cargartip
        frmtip.visible = true
        primeravez = false
    end if
end sub

''
' handles the removedialogs message.

private sub handleremovedialogs()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call dialogos.removealldialogs
end sub

''
' handles the removechardialog message.

private sub handleremovechardialog()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'check if the packet is complete
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    call dialogos.removedialog(incomingdata.readinteger())
end sub

''
' handles the navigatetoggle message.

private sub handlenavigatetoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    usernavegando = not usernavegando
end sub

''
' handles the disconnect message.

private sub handledisconnect()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as long
    
    'remove packet id
    call incomingdata.readbyte
    
    'close connection
#if usarwrench = 1 then
    frmmain.socket1.disconnect
#else
    if frmmain.winsock1.state <> sckclosed then _
        frmmain.winsock1.close
#end if
    
    'hide main form
    frmmain.visible = false
    frmmain.label1.visible = false
    
    'stop audio
    call audio.stopwave
    frmmain.isplaying = playloop.plnone
    
    'show connection form
    frmconnect.visible = true
    
    'reset global vars
    iscombate = false
    userdescansar = false
    userparalizado = false
    pausa = false
    userciego = false
    usermeditar = false
    usernavegando = false
    brain = false
    bfogata = false
    skillpoints = 0
    
    'delete all kind of dialogs
    call cleandialogs
    
    'reset some char variables...
    for i = 1 to lastchar
        charlist(i).invisible = false
    next i
    
    'unload all forms except frmmain and frmconnect
    dim frm as form
    
    for each frm in forms
        if frm.name <> frmmain.name and frm.name <> frmconnect.name then
            unload frm
        end if
    next
    
#if seguridadalkon then
    call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if
end sub

''
' handles the commerceend message.

private sub handlecommerceend()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    'clear item's list
    frmcomerciar.list1(0).clear
    frmcomerciar.list1(1).clear
    
    'reset vars
    comerciando = false
    
    'hide form
    unload frmcomerciar
end sub

''
' handles the bankend message.

private sub handlebankend()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    frmbancoobj.list1(0).clear
    frmbancoobj.list1(1).clear
    
    unload frmbancoobj
    comerciando = false
end sub

''
' handles the commerceinit message.

private sub handlecommerceinit()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as long
    
    'remove packet id
    call incomingdata.readbyte
    
    'fill our inventory list
    for i = 1 to max_inventory_slots
        if inventario.objindex(i) <> 0 then
            frmcomerciar.list1(1).additem inventario.itemname(i)
        else
            frmcomerciar.list1(1).additem ""
        end if
    next i
    
    'set state and show form
    comerciando = true
    frmcomerciar.show , frmmain
end sub

''
' handles the bankinit message.

private sub handlebankinit()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as long
    
    'remove packet id
    call incomingdata.readbyte
    
    call frmbancoobj.list1(1).clear
    
    'fill the inventory list
    for i = 1 to max_inventory_slots
        if inventario.objindex(i) <> 0 then
            frmbancoobj.list1(1).additem inventario.itemname(i)
        else
            frmbancoobj.list1(1).additem ""
        end if
    next i
    
    call frmbancoobj.list1(0).clear
    
    'fill the bank list
    for i = 1 to max_bancoinventory_slots
        if userbancoinventory(i).objindex <> 0 then
            frmbancoobj.list1(0).additem userbancoinventory(i).name
        else
            frmbancoobj.list1(0).additem ""
        end if
    next i
    
    'set state and show form
    comerciando = true
    frmbancoobj.show , frmmain
end sub

''
' handles the usercommerceinit message.

private sub handleusercommerceinit()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as long
    
    'remove packet id
    call incomingdata.readbyte
    
    'clears lists if necessary
    if frmcomerciarusu.list1.listcount > 0 then frmcomerciarusu.list1.clear
    if frmcomerciarusu.list2.listcount > 0 then frmcomerciarusu.list2.clear
    
    'fill inventory list
    for i = 1 to max_inventory_slots
        if inventario.objindex(i) <> 0 then
            frmcomerciarusu.list1.additem inventario.itemname(i)
            frmcomerciarusu.list1.itemdata(frmcomerciarusu.list1.newindex) = inventario.amount(i)
        else
            frmcomerciarusu.list1.additem ""
            frmcomerciarusu.list1.itemdata(frmcomerciarusu.list1.newindex) = 0
        end if
    next i
    
    'set state and show form
    comerciando = true
    call frmcomerciarusu.show(vbmodal, frmmain)
end sub

''
' handles the usercommerceend message.

private sub handleusercommerceend()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    'clear the lists
    frmcomerciarusu.list1.clear
    frmcomerciarusu.list2.clear
    
    'destroy the form and reset the state
    unload frmcomerciarusu
    comerciando = false
end sub

''
' handles the showblacksmithform message.

private sub handleshowblacksmithform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    if frmmain.macrotrabajo.enabled and (macrobltindex > 0) then
        call writecraftblacksmith(macrobltindex)
    else
        frmherrero.show , frmmain
    end if
end sub

''
' handles the showcarpenterform message.

private sub handleshowcarpenterform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    if frmmain.macrotrabajo.enabled and (macrobltindex > 0) then
        call writecraftcarpenter(macrobltindex)
    else
        frmcarp.show , frmmain
    end if
end sub

''
' handles the npcswing message.

private sub handlenpcswing()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_criatura_falla_golpe, 255, 0, 0, true, false, false)
end sub

''
' handles the npckilluser message.

private sub handlenpckilluser()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_criatura_matado, 255, 0, 0, true, false, false)
end sub

''
' handles the blockedwithshielduser message.

private sub handleblockedwithshielduser()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_rechazo_ataque_escudo, 255, 0, 0, true, false, false)
end sub

''
' handles the blockedwithshieldother message.

private sub handleblockedwithshieldother()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_usuario_rechazo_ataque_escudo, 255, 0, 0, true, false, false)
end sub

''
' handles the userswing message.

private sub handleuserswing()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_fallado_golpe, 255, 0, 0, true, false, false)
end sub

''
' handles the updateneeded message.

private sub handleupdateneeded()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call frmmain.dibujarsatelite
end sub

''
' handles the safemodeon message.

private sub handlesafemodeon()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call frmmain.dibujarseguro
    call addtorichtextbox(frmmain.rectxt, mensaje_seguro_activado, 0, 255, 0, true, false, false)
end sub

''
' handles the safemodeoff message.

private sub handlesafemodeoff()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call frmmain.desdibujarseguro
    call addtorichtextbox(frmmain.rectxt, mensaje_seguro_desactivado, 255, 0, 0, true, false, false)
end sub

''
' handles the resuscitationsafeoff message.

private sub handleresuscitationsafeoff()
'***************************************************
'author: rapsodius
'creation date: 10/10/07
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call frmmain.controlseguroresu(false)
    call addtorichtextbox(frmmain.rectxt, mensaje_seguro_resu_off, 255, 0, 0, true, false, false)
end sub

''
' handles the resuscitationsafeon message.

private sub handleresuscitationsafeon()
'***************************************************
'author: rapsodius
'creation date: 10/10/07
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call frmmain.controlseguroresu(true)
    call addtorichtextbox(frmmain.rectxt, mensaje_seguro_resu_on, 0, 255, 0, true, false, false)
end sub

''
' handles the nobilitylost message.

private sub handlenobilitylost()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_pierde_nobleza, 255, 0, 0, false, false, false)
end sub

''
' handles the cantusewhilemeditating message.

private sub handlecantusewhilemeditating()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_usar_meditando, 255, 0, 0, false, false, false)
end sub

''
' handles the updatesta message.

private sub handleupdatesta()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'check packet is complete
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    userminsta = incomingdata.readinteger()
    frmmain.stashp.width = (((userminsta / 100) / (usermaxsta / 100)) * 94)
end sub

''
' handles the updatemana message.

private sub handleupdatemana()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'check packet is complete
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    userminman = incomingdata.readinteger()
    
    if usermaxman > 0 then
        frmmain.manshp.width = (((userminman + 1 / 100) / (usermaxman + 1 / 100)) * 94)
    else
        frmmain.manshp.width = 0
    end if
end sub

''
' handles the updatehp message.

private sub handleupdatehp()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'check packet is complete
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    userminhp = incomingdata.readinteger()
    frmmain.hpshp.width = (((userminhp / 100) / (usermaxhp / 100)) * 94)
    
    'is the user alive??
    if userminhp = 0 then
        userestado = 1
        if frmmain.trainingmacro then frmmain.desactivarmacrohechizos
        if frmmain.macrotrabajo then frmmain.desactivarmacrotrabajo
    else
        userestado = 0
    end if
end sub

''
' handles the updategold message.

private sub handleupdategold()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/14/07
'last modified by: lucas tavolaro ortiz (tavo)
'- 08/14/07: added gldlbl color variation depending on user gold and level
'***************************************************
    'check packet is complete
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    usergld = incomingdata.readlong()
    
    if usergld >= clng(userlvl) * 10000 then
        'changes color
        frmmain.gldlbl.forecolor = &hff& 'red
    else
        'changes color
        frmmain.gldlbl.forecolor = &hffff& 'yellow
    end if
    
    frmmain.gldlbl.caption = usergld
end sub

''
' handles the updateexp message.

private sub handleupdateexp()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'check packet is complete
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    userexp = incomingdata.readlong()
    frmmain.exp.caption = "exp: " & userexp & "/" & userpasarnivel
    frmmain.lblporclvl.caption = "[" & round(cdbl(userexp) * cdbl(100) / cdbl(userpasarnivel), 2) & "%]"
end sub

''
' handles the changemap message.

private sub handlechangemap()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    usermap = incomingdata.readinteger()
    
'todo: once on-the-fly editor is implemented check for map version before loading....
'for now we just drop it
    call incomingdata.readinteger
        
#if seguridadalkon then
    call initmi
#end if
    
    if fileexist(dirmapas & "mapa" & usermap & ".map", vbnormal) then
        call switchmap(usermap)
        if blluvia(usermap) = 0 then
            if brain then
                call audio.stopwave(rainbufferindex)
                rainbufferindex = 0
                frmmain.isplaying = playloop.plnone
            end if
        end if
    else
        'no encontramos el mapa en el hd
        msgbox "error en los mapas, alg�n archivo ha sido modificado o esta da�ado."
        
        call closeclient
    end if
end sub

''
' handles the posupdate message.

private sub handleposupdate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'remove char from old position
    if mapdata(userpos.x, userpos.y).charindex = usercharindex then
        mapdata(userpos.x, userpos.y).charindex = 0
    end if
    
    'set new pos
    userpos.x = incomingdata.readbyte()
    userpos.y = incomingdata.readbyte()
    
    'set char
    mapdata(userpos.x, userpos.y).charindex = usercharindex
    charlist(usercharindex).pos = userpos
    
    'are we under a roof?
    btecho = iif(mapdata(userpos.x, userpos.y).trigger = 1 or _
            mapdata(userpos.x, userpos.y).trigger = 2 or _
            mapdata(userpos.x, userpos.y).trigger = 4, true, false)
                
    'update pos label
    frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
end sub

''
' handles the npchituser message.

private sub handlenpchituser()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 4 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    select case incomingdata.readbyte()
        case bcabeza
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_cabeza & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, false)
        case bbrazoizquierdo
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_izq & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, false)
        case bbrazoderecho
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_der & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, false)
        case bpiernaizquierda
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_izq & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, false)
        case bpiernaderecha
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_der & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, false)
        case btorso
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_torso & cstr(incomingdata.readinteger() & "!!"), 255, 0, 0, true, false, false)
    end select
end sub

''
' handles the userhitnpc message.

private sub handleuserhitnpc()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_criatura_1 & cstr(incomingdata.readlong()) & mensaje_2, 255, 0, 0, true, false, false)
end sub

''
' handles the userattackedswing message.

private sub handleuserattackedswing()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, mensaje_1 & charlist(incomingdata.readinteger()).nombre & mensaje_ataque_fallo, 255, 0, 0, true, false, false)
end sub

''
' handles the userhittingbyuser message.

private sub handleuserhittedbyuser()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 6 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim attacker as string
    
    attacker = charlist(incomingdata.readinteger()).nombre
    
    select case incomingdata.readbyte
        case bcabeza
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_cabeza & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bbrazoizquierdo
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_brazo_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bbrazoderecho
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_brazo_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bpiernaizquierda
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_pierna_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bpiernaderecha
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_pierna_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case btorso
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_torso & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
    end select
end sub

''
' handles the userhitteduser message.

private sub handleuserhitteduser()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 6 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim victim as string
    
    victim = charlist(incomingdata.readinteger()).nombre
    
    select case incomingdata.readbyte
        case bcabeza
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_cabeza & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bbrazoizquierdo
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_brazo_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bbrazoderecho
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_brazo_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bpiernaizquierda
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_pierna_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case bpiernaderecha
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_pierna_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
        case btorso
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_torso & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, false)
    end select
end sub

''
' handles the chatoverhead message.

private sub handlechatoverhead()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 8 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim chat as string
    dim charindex as integer
    dim r as byte
    dim g as byte
    dim b as byte
    
    chat = buffer.readasciistring()
    charindex = buffer.readinteger()
    
    r = buffer.readbyte()
    g = buffer.readbyte()
    b = buffer.readbyte()
    
    'only add the chat if the character exists (a characterremove may have been sent to the pc / npc area before the buffer was flushed)
    if charlist(charindex).active then _
        call dialogos.createdialog(chat, charindex, rgb(r, g, b))
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)

errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing
    
    if error <> 0 then _
        err.raise error
end sub

''
' handles the consolemessage message.

private sub handleconsolemessage()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 4 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim chat as string
    dim fontindex as integer
    dim str as string
    dim r as byte
    dim g as byte
    dim b as byte
    
    chat = buffer.readasciistring()
    fontindex = buffer.readbyte()
    
    if instr(1, chat, "~") then
        str = readfield(2, chat, 126)
            if val(str) > 255 then
                r = 255
            else
                r = val(str)
            end if
            
            str = readfield(3, chat, 126)
            if val(str) > 255 then
                g = 255
            else
                g = val(str)
            end if
            
            str = readfield(4, chat, 126)
            if val(str) > 255 then
                b = 255
            else
                b = val(str)
            end if
            
        call addtorichtextbox(frmmain.rectxt, left$(chat, instr(1, chat, "~") - 1), r, g, b, val(readfield(5, chat, 126)) <> 0, val(readfield(6, chat, 126)) <> 0)
    else
        with fonttypes(fontindex)
            call addtorichtextbox(frmmain.rectxt, chat, .red, .green, .blue, .bold, .italic)
        end with
    end if
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the guildchat message.

private sub handleguildchat()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/07/08 (niconz)
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim chat as string
    dim str as string
    dim r as byte
    dim g as byte
    dim b as byte
    dim tmp as integer
    dim cont as integer
    
    
    chat = buffer.readasciistring()
    
    if not dialogosclanes.activo then
        if instr(1, chat, "~") then
            str = readfield(2, chat, 126)
            if val(str) > 255 then
                r = 255
            else
                r = val(str)
            end if
            
            str = readfield(3, chat, 126)
            if val(str) > 255 then
                g = 255
            else
                g = val(str)
            end if
            
            str = readfield(4, chat, 126)
            if val(str) > 255 then
                b = 255
            else
                b = val(str)
            end if
            
            call addtorichtextbox(frmmain.rectxt, left$(chat, instr(1, chat, "~") - 1), r, g, b, val(readfield(5, chat, 126)) <> 0, val(readfield(6, chat, 126)) <> 0)
        else
            with fonttypes(fonttypenames.fonttype_guildmsg)
                call addtorichtextbox(frmmain.rectxt, chat, .red, .green, .blue, .bold, .italic)
            end with
        end if
    else
        call dialogosclanes.pushbacktext(readfield(1, chat, 126))
    end if
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the showmessagebox message.

private sub handleshowmessagebox()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    frmmensaje.msg.caption = buffer.readasciistring()
    frmmensaje.show
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the userindexinserver message.

private sub handleuserindexinserver()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    userindex = incomingdata.readinteger()
end sub

''
' handles the usercharindexinserver message.

private sub handleusercharindexinserver()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    usercharindex = incomingdata.readinteger()
    userpos = charlist(usercharindex).pos
    
    'are we under a roof?
    btecho = iif(mapdata(userpos.x, userpos.y).trigger = 1 or _
            mapdata(userpos.x, userpos.y).trigger = 2 or _
            mapdata(userpos.x, userpos.y).trigger = 4, true, false)

    frmmain.coord.caption = "(" & usermap & "," & userpos.x & "," & userpos.y & ")"
end sub

''
' handles the charactercreate message.

private sub handlecharactercreate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 24 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim charindex as integer
    dim body as integer
    dim head as integer
    dim heading as e_heading
    dim x as byte
    dim y as byte
    dim weapon as integer
    dim shield as integer
    dim helmet as integer
    dim privs as integer
    
    charindex = buffer.readinteger()
    body = buffer.readinteger()
    head = buffer.readinteger()
    heading = buffer.readbyte()
    x = buffer.readbyte()
    y = buffer.readbyte()
    weapon = buffer.readinteger()
    shield = buffer.readinteger()
    helmet = buffer.readinteger()
    
    
    with charlist(charindex)
        call setcharacterfx(charindex, buffer.readinteger(), buffer.readinteger())
        
        .nombre = buffer.readasciistring()
        .criminal = buffer.readbyte()
        
        privs = buffer.readbyte()
        
        if privs <> 0 then
            'if the player belongs to a council and is an admin, only whos as an admin
            if (privs and playertype.chaoscouncil) <> 0 and (privs and playertype.user) = 0 then
                privs = privs xor playertype.chaoscouncil
            end if
            
            if (privs and playertype.royalcouncil) <> 0 and (privs and playertype.user) = 0 then
                privs = privs xor playertype.royalcouncil
            end if
            
            'if the player is a rm, ignore other flags
            if privs and playertype.rolemaster then
                privs = playertype.rolemaster
            end if
            
            'log2 of the bit flags sent by the server gives our numbers ^^
            .priv = log(privs) / log(2)
        else
            .priv = 0
        end if
    end with
    
    call makechar(charindex, body, head, heading, x, y, weapon, shield, helmet)
    
    call refreshallchars
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

private sub handlecharacterchangenick()
'***************************************************
'author: budi
'last modification: 07/23/09
'
'***************************************************
    if incomingdata.length < 6 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    dim charindex as integer
    charindex = incomingdata.readinteger
    charlist(charindex).nombre = incomingdata.readasciistring
    
end sub

''
' handles the characterremove message.

private sub handlecharacterremove()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim charindex as integer
    
    charindex = incomingdata.readinteger()
    
    call erasechar(charindex)
    call refreshallchars
end sub

''
' handles the charactermove message.

private sub handlecharactermove()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim charindex as integer
    dim x as byte
    dim y as byte
    
    charindex = incomingdata.readinteger()
    x = incomingdata.readbyte()
    y = incomingdata.readbyte()
    
    with charlist(charindex)
        if .fxindex >= 40 and .fxindex <= 49 then   'if it's meditating, we remove the fx
            .fxindex = 0
        end if
        
        ' play steps sounds if the user is not an admin of any kind
        if .priv <> 1 and .priv <> 2 and .priv <> 3 and .priv <> 5 and .priv <> 25 then
            call dopasosfx(charindex)
        end if
    end with
    
    call movecharbypos(charindex, x, y)
    
    call refreshallchars
end sub

''
' handles the forcecharmove message.

private sub handleforcecharmove()
    
    if incomingdata.length < 2 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim direccion as byte
    
    direccion = incomingdata.readbyte()

    call movecharbyhead(usercharindex, direccion)
    call movescreen(direccion)
    
    call refreshallchars
end sub

''
' handles the characterchange message.

private sub handlecharacterchange()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 25/08/2009
'25/08/2009: zama - changed a variable used incorrectly.
'***************************************************
    if incomingdata.length < 18 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim charindex as integer
    dim tempint as integer
    dim headindex as integer
    
    charindex = incomingdata.readinteger()
    
    with charlist(charindex)
        tempint = incomingdata.readinteger()
        
        if tempint < lbound(bodydata()) or tempint > ubound(bodydata()) then
            .body = bodydata(0)
            .ibody = 0
        else
            .body = bodydata(tempint)
            .ibody = tempint
        end if
        
        
        headindex = incomingdata.readinteger()
        
        if headindex < lbound(headdata()) or headindex > ubound(headdata()) then
            .head = headdata(0)
            .ihead = 0
        else
            .head = headdata(headindex)
            .ihead = headindex
        end if
        
        .muerto = (headindex = casper_head)
        
        .heading = incomingdata.readbyte()
        
        tempint = incomingdata.readinteger()
        if tempint <> 0 then .arma = weaponanimdata(tempint)
        
        tempint = incomingdata.readinteger()
        if tempint <> 0 then .escudo = shieldanimdata(tempint)
        
        tempint = incomingdata.readinteger()
        if tempint <> 0 then .casco = cascoanimdata(tempint)
        
        call setcharacterfx(charindex, incomingdata.readinteger(), incomingdata.readinteger())
    end with
    
    call refreshallchars
end sub

''
' handles the objectcreate message.

private sub handleobjectcreate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim x as byte
    dim y as byte
    
    x = incomingdata.readbyte()
    y = incomingdata.readbyte()
    
    mapdata(x, y).objgrh.grhindex = incomingdata.readinteger()
    
    call initgrh(mapdata(x, y).objgrh, mapdata(x, y).objgrh.grhindex)
end sub

''
' handles the objectdelete message.

private sub handleobjectdelete()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim x as byte
    dim y as byte
    
    x = incomingdata.readbyte()
    y = incomingdata.readbyte()
    mapdata(x, y).objgrh.grhindex = 0
end sub

''
' handles the blockposition message.

private sub handleblockposition()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 4 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim x as byte
    dim y as byte
    
    x = incomingdata.readbyte()
    y = incomingdata.readbyte()
    
    if incomingdata.readboolean() then
        mapdata(x, y).blocked = 1
    else
        mapdata(x, y).blocked = 0
    end if
end sub

''
' handles the playmidi message.

private sub handleplaymidi()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 4 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    dim currentmidi as byte
    
    'remove packet id
    call incomingdata.readbyte
    
    currentmidi = incomingdata.readbyte()
    
    if currentmidi then
        call audio.playmidi(cstr(currentmidi) & ".mid", incomingdata.readinteger())
    else
        'remove the bytes to prevent errors
        call incomingdata.readinteger
    end if
end sub

''
' handles the playwave message.

private sub handleplaywave()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/14/07
'last modified by: rapsodius
'added support for 3d sounds.
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
        
    dim wave as byte
    dim srcx as byte
    dim srcy as byte
    
    wave = incomingdata.readbyte()
    srcx = incomingdata.readbyte()
    srcy = incomingdata.readbyte()
        
    call audio.playwave(cstr(wave) & ".wav", srcx, srcy)
end sub

''
' handles the guildlist message.

private sub handleguildlist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    'clear guild's list
    frmguildadm.guildslist.clear
    
    dim guilds() as string
    guilds = split(buffer.readasciistring(), separator)
    
    dim i as long
    for i = 0 to ubound(guilds())
        call frmguildadm.guildslist.additem(guilds(i))
    next i
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
    frmguildadm.show vbmodeless, frmmain
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the areachanged message.

private sub handleareachanged()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim x as byte
    dim y as byte
    
    x = incomingdata.readbyte()
    y = incomingdata.readbyte()
        
    call cambiodearea(x, y)
end sub

''
' handles the pausetoggle message.

private sub handlepausetoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    pausa = not pausa
end sub

''
' handles the raintoggle message.

private sub handleraintoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    if not inmapbounds(userpos.x, userpos.y) then exit sub
    
    btecho = (mapdata(userpos.x, userpos.y).trigger = 1 or _
            mapdata(userpos.x, userpos.y).trigger = 2 or _
            mapdata(userpos.x, userpos.y).trigger = 4)
    if brain then
        if blluvia(usermap) then
            'stop playing the rain sound
            call audio.stopwave(rainbufferindex)
            rainbufferindex = 0
            if btecho then
                call audio.playwave("lluviainend.wav", 0, 0, loopstyle.disabled)
            else
                call audio.playwave("lluviaoutend.wav", 0, 0, loopstyle.disabled)
            end if
            frmmain.isplaying = playloop.plnone
        end if
    end if
    
    brain = not brain
end sub

''
' handles the createfx message.

private sub handlecreatefx()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 7 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim charindex as integer
    dim fx as integer
    dim loops as integer
    
    charindex = incomingdata.readinteger()
    fx = incomingdata.readinteger()
    loops = incomingdata.readinteger()
    
    call setcharacterfx(charindex, fx, loops)
end sub

''
' handles the updateuserstats message.

private sub handleupdateuserstats()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 26 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    usermaxhp = incomingdata.readinteger()
    userminhp = incomingdata.readinteger()
    usermaxman = incomingdata.readinteger()
    userminman = incomingdata.readinteger()
    usermaxsta = incomingdata.readinteger()
    userminsta = incomingdata.readinteger()
    usergld = incomingdata.readlong()
    userlvl = incomingdata.readbyte()
    userpasarnivel = incomingdata.readlong()
    userexp = incomingdata.readlong()
    
    frmmain.exp.caption = "exp: " & userexp & "/" & userpasarnivel
    
    if userpasarnivel > 0 then
        frmmain.lblporclvl.caption = "[" & round(cdbl(userexp) * cdbl(100) / cdbl(userpasarnivel), 2) & "%]"
    else
        frmmain.lblporclvl.caption = "[n/a]"
    end if
    
    frmmain.hpshp.width = (((userminhp / 100) / (usermaxhp / 100)) * 94)
    
    if usermaxman > 0 then
        frmmain.manshp.width = (((userminman + 1 / 100) / (usermaxman + 1 / 100)) * 94)
    else
        frmmain.manshp.width = 0
    end if
    
    frmmain.stashp.width = (((userminsta / 100) / (usermaxsta / 100)) * 94)

    frmmain.gldlbl.caption = usergld
    frmmain.lvllbl.caption = userlvl
    
    if userminhp = 0 then
        userestado = 1
        if frmmain.trainingmacro then frmmain.desactivarmacrohechizos
        if frmmain.macrotrabajo then frmmain.desactivarmacrotrabajo
    else
        userestado = 0
    end if
    
    if usergld >= clng(userlvl) * 10000 then
        'changes color
        frmmain.gldlbl.forecolor = &hff& 'red
    else
        'changes color
        frmmain.gldlbl.forecolor = &hffff& 'yellow
    end if
end sub

''
' handles the workrequesttarget message.

private sub handleworkrequesttarget()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 2 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    usingskill = incomingdata.readbyte()

    frmmain.mousepointer = 2
    
    select case usingskill
        case magia
            call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_magia, 100, 100, 120, 0, 0)
        case pesca
            call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_pesca, 100, 100, 120, 0, 0)
        case robar
            call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_robar, 100, 100, 120, 0, 0)
        case talar
            call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_talar, 100, 100, 120, 0, 0)
        case mineria
            call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_mineria, 100, 100, 120, 0, 0)
        case fundirmetal
            call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_fundirmetal, 100, 100, 120, 0, 0)
        case proyectiles
            call addtorichtextbox(frmmain.rectxt, mensaje_trabajo_proyectiles, 100, 100, 120, 0, 0)
    end select
end sub

''
' handles the changeinventoryslot message.

private sub handlechangeinventoryslot()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 22 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim slot as byte
    dim objindex as integer
    dim name as string
    dim amount as integer
    dim equipped as boolean
    dim grhindex as integer
    dim objtype as byte
    dim maxhit as integer
    dim minhit as integer
    dim defense as integer
    dim value as single
    
    slot = buffer.readbyte()
    objindex = buffer.readinteger()
    name = buffer.readasciistring()
    amount = buffer.readinteger()
    equipped = buffer.readboolean()
    grhindex = buffer.readinteger()
    objtype = buffer.readbyte()
    maxhit = buffer.readinteger()
    minhit = buffer.readinteger()
    defense = buffer.readinteger()
    value = buffer.readsingle()
    
    call inventario.setitem(slot, objindex, amount, equipped, grhindex, objtype, maxhit, minhit, defense, value, name)
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the changebankslot message.

private sub handlechangebankslot()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 21 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim slot as byte
    slot = buffer.readbyte()
    
    with userbancoinventory(slot)
        .objindex = buffer.readinteger()
        .name = buffer.readasciistring()
        .amount = buffer.readinteger()
        .grhindex = buffer.readinteger()
        .objtype = buffer.readbyte()
        .maxhit = buffer.readinteger()
        .minhit = buffer.readinteger()
        .def = buffer.readinteger()
        .valor = buffer.readlong()
    end with
    
    if frmbancoobj.list1(0).listcount >= slot then _
        call frmbancoobj.list1(0).removeitem(slot - 1)
    
    call frmbancoobj.list1(0).additem(userbancoinventory(slot).name, slot - 1)
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the changespellslot message.

private sub handlechangespellslot()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 6 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim slot as byte
    slot = buffer.readbyte()
    
    userhechizos(slot) = buffer.readinteger()
    
    if slot <= frmmain.hlst.listcount then
        frmmain.hlst.list(slot - 1) = buffer.readasciistring()
    else
        call frmmain.hlst.additem(buffer.readasciistring())
    end if
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the attributes message.

private sub handleatributes()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 1 + numatributes then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim i as long
    
    for i = 1 to numatributes
        useratributos(i) = incomingdata.readbyte()
    next i
    
    'show them in character creation
    if estadologin = e_modo.dados then
        with frmcrearpersonaje
            if .visible then
                .lbfuerza.caption = useratributos(1)
                .lbagilidad.caption = useratributos(2)
                .lbinteligencia.caption = useratributos(3)
                .lbcarisma.caption = useratributos(4)
                .lbconstitucion.caption = useratributos(5)
            end if
        end with
    else
        llegaronatrib = true
    end if
end sub

''
' handles the blacksmithweapons message.

private sub handleblacksmithweapons()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim count as integer
    dim i as long
    dim tmp as string
    
    count = buffer.readinteger()
    
    call frmherrero.lstarmas.clear
    
    for i = 1 to count
        tmp = buffer.readasciistring() & " ("           'get the object's name
        tmp = tmp & cstr(buffer.readinteger()) & ","    'the iron needed
        tmp = tmp & cstr(buffer.readinteger()) & ","    'the silver needed
        tmp = tmp & cstr(buffer.readinteger()) & ")"    'the gold needed
        
        call frmherrero.lstarmas.additem(tmp)
        armasherrero(i) = buffer.readinteger()
    next i
    
    for i = i to ubound(armasherrero())
        armasherrero(i) = 0
    next i
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the blacksmitharmors message.

private sub handleblacksmitharmors()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim count as integer
    dim i as long
    dim tmp as string
    
    count = buffer.readinteger()
    
    call frmherrero.lstarmaduras.clear
    
    for i = 1 to count
        tmp = buffer.readasciistring() & " ("           'get the object's name
        tmp = tmp & cstr(buffer.readinteger()) & ","    'the iron needed
        tmp = tmp & cstr(buffer.readinteger()) & ","    'the silver needed
        tmp = tmp & cstr(buffer.readinteger()) & ")"    'the gold needed
        
        call frmherrero.lstarmaduras.additem(tmp)
        armadurasherrero(i) = buffer.readinteger()
    next i
    
    for i = i to ubound(armadurasherrero())
        armadurasherrero(i) = 0
    next i
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the carpenterobjects message.

private sub handlecarpenterobjects()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim count as integer
    dim i as long
    dim tmp as string
    
    count = buffer.readinteger()
    
    call frmcarp.lstarmas.clear
    
    for i = 1 to count
        tmp = buffer.readasciistring() & " ("          'get the object's name
        tmp = tmp & cstr(buffer.readinteger()) & ")"    'the wood needed
        
        call frmcarp.lstarmas.additem(tmp)
        objcarpintero(i) = buffer.readinteger()
    next i
    
    for i = i to ubound(objcarpintero())
        objcarpintero(i) = 0
    next i
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the restok message.

private sub handlerestok()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    userdescansar = not userdescansar
end sub

''
' handles the errormessage message.

private sub handleerrormessage()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    call msgbox(buffer.readasciistring())
    
    frmoldpersonaje.mousepointer = 1
    frmpasswd.mousepointer = 1
    if frmoldpersonaje.visible then
#if usarwrench = 1 then
        frmmain.socket1.disconnect
        frmmain.socket1.cleanup
#else
        if frmmain.winsock1.state <> sckclosed then _
            frmmain.winsock1.close
#end if
    end if
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the blind message.

private sub handleblind()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    userciego = true
end sub

''
' handles the dumb message.

private sub handledumb()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    userestupido = true
end sub

''
' handles the showsignal message.

private sub handleshowsignal()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim tmp as string
    tmp = buffer.readasciistring()
    
    call initcartel(tmp, buffer.readinteger())
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the changenpcinventoryslot message.

private sub handlechangenpcinventoryslot()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 21 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim slot as byte
    slot = buffer.readbyte()
    
    with npcinventory(slot)
        .name = buffer.readasciistring()
        .amount = buffer.readinteger()
        .valor = buffer.readsingle()
        .grhindex = buffer.readinteger()
        .objindex = buffer.readinteger()
        .objtype = buffer.readbyte()
        .maxhit = buffer.readinteger()
        .minhit = buffer.readinteger()
        .def = buffer.readinteger()
    end with
    
    if frmcomerciar.list1(0).listcount >= slot then _
        call frmcomerciar.list1(0).removeitem(slot - 1)
    
    call frmcomerciar.list1(0).additem(npcinventory(slot).name, slot - 1)
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the updatehungerandthirst message.

private sub handleupdatehungerandthirst()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    usermaxagu = incomingdata.readbyte()
    userminagu = incomingdata.readbyte()
    usermaxham = incomingdata.readbyte()
    userminham = incomingdata.readbyte()
    frmmain.aguasp.width = (((userminagu / 100) / (usermaxagu / 100)) * 94)
    frmmain.comidasp.width = (((userminham / 100) / (usermaxham / 100)) * 94)
end sub

''
' handles the fame message.

private sub handlefame()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 29 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    with userreputacion
        .asesinorep = incomingdata.readlong()
        .bandidorep = incomingdata.readlong()
        .burguesrep = incomingdata.readlong()
        .ladronesrep = incomingdata.readlong()
        .noblerep = incomingdata.readlong()
        .pleberep = incomingdata.readlong()
        .promedio = incomingdata.readlong()
    end with
    
    llegofama = true
end sub

''
' handles the ministats message.

private sub handleministats()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 20 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    with userestadisticas
        .ciudadanosmatados = incomingdata.readlong()
        .criminalesmatados = incomingdata.readlong()
        .usuariosmatados = incomingdata.readlong()
        .npcsmatados = incomingdata.readinteger()
        .clase = listaclases(incomingdata.readbyte())
        .penacarcel = incomingdata.readlong()
    end with
end sub

''
' handles the levelup message.

private sub handlelevelup()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    skillpoints = skillpoints + incomingdata.readinteger()
    frmmain.label1.visible = true
end sub

''
' handles the addforummessage message.

private sub handleaddforummessage()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim title as string
    dim message as string
    
    title = buffer.readasciistring()
    message = buffer.readasciistring()
    
    call frmforo.list.additem(title)
    frmforo.text(frmforo.list.listcount - 1).text = message
    call load(frmforo.text(frmforo.list.listcount))
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the showforumform message.

private sub handleshowforumform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    if not frmforo.visible then
        frmforo.show , frmmain
    end if
end sub

''
' handles the setinvisible message.

private sub handlesetinvisible()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 4 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim charindex as integer
    
    charindex = incomingdata.readinteger()
    charlist(charindex).invisible = incomingdata.readboolean()
    
#if seguridadalkon then
    if charlist(charindex).invisible then
        call mi(cualmi).setinvisible(charindex)
    else
        call mi(cualmi).resetinvisible(charindex)
    end if
#end if

end sub

''
' handles the diceroll message.

private sub handlediceroll()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 6 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    useratributos(eatributos.fuerza) = incomingdata.readbyte()
    useratributos(eatributos.agilidad) = incomingdata.readbyte()
    useratributos(eatributos.inteligencia) = incomingdata.readbyte()
    useratributos(eatributos.carisma) = incomingdata.readbyte()
    useratributos(eatributos.constitucion) = incomingdata.readbyte()
    
    frmcrearpersonaje.lbfuerza = useratributos(eatributos.fuerza)
    frmcrearpersonaje.lbagilidad = useratributos(eatributos.agilidad)
    frmcrearpersonaje.lbinteligencia = useratributos(eatributos.inteligencia)
    frmcrearpersonaje.lbcarisma = useratributos(eatributos.carisma)
    frmcrearpersonaje.lbconstitucion = useratributos(eatributos.constitucion)
end sub

''
' handles the meditatetoggle message.

private sub handlemeditatetoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    usermeditar = not usermeditar
end sub

''
' handles the blindnomore message.

private sub handleblindnomore()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    userciego = false
end sub

''
' handles the dumbnomore message.

private sub handledumbnomore()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    userestupido = false
end sub

''
' handles the sendskills message.

private sub handlesendskills()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 1 + numskills then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim i as long
    
    for i = 1 to numskills
        userskills(i) = incomingdata.readbyte()
    next i
    llegaronskills = true
end sub

''
' handles the trainercreaturelist message.

private sub handletrainercreaturelist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim creatures() as string
    dim i as long
    
    creatures = split(buffer.readasciistring(), separator)
    
    for i = 0 to ubound(creatures())
        call frmentrenador.lstcriaturas.additem(creatures(i))
    next i
    frmentrenador.show , frmmain
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the guildnews message.

private sub handleguildnews()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 7 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim guildlist() as string
    dim i as long
    
    'get news' string
    frmguildnews.news = buffer.readasciistring()
    
    'get enemy guilds list
    guildlist = split(buffer.readasciistring(), separator)
    
    for i = 0 to ubound(guildlist)
        call frmguildnews.guerra.additem(guildlist(i))
    next i
    
    'get allied guilds list
    guildlist = split(buffer.readasciistring(), separator)
    
    for i = 0 to ubound(guildlist)
        call frmguildnews.aliados.additem(guildlist(i))
    next i
    
    frmguildnews.show vbmodeless, frmmain
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the offerdetails message.

private sub handleofferdetails()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    call frmuserrequest.recievepeticion(buffer.readasciistring())
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the alianceproposalslist message.

private sub handlealianceproposalslist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim guildlist() as string
    dim i as long
    
    guildlist = split(buffer.readasciistring(), separator)
    
    call frmpeaceprop.lista.clear
    for i = 0 to ubound(guildlist())
        call frmpeaceprop.lista.additem(guildlist(i))
    next i
    
    frmpeaceprop.proposaltype = tipo_propuesta.alianza
    call frmpeaceprop.show(vbmodeless, frmmain)
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the peaceproposalslist message.

private sub handlepeaceproposalslist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim guildlist() as string
    dim i as long
    
    guildlist = split(buffer.readasciistring(), separator)
    
    call frmpeaceprop.lista.clear
    for i = 0 to ubound(guildlist())
        call frmpeaceprop.lista.additem(guildlist(i))
    next i
    
    frmpeaceprop.proposaltype = tipo_propuesta.paz
    call frmpeaceprop.show(vbmodeless, frmmain)
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the characterinfo message.

private sub handlecharacterinfo()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 35 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    with frmcharinfo
        if .frmtype = charinfofrmtype.frmmembers then
            .rechazar.visible = false
            .aceptar.visible = false
            .echar.visible = true
            .desc.visible = false
        else
            .rechazar.visible = true
            .aceptar.visible = true
            .echar.visible = false
            .desc.visible = true
        end if
        
        .nombre.caption = "nombre: " & buffer.readasciistring()
        .raza.caption = "raza: " & listarazas(buffer.readbyte())
        .clase.caption = "clase: " & listaclases(buffer.readbyte())
        
        if buffer.readbyte() = 1 then
            .genero.caption = "genero: hombre"
        else
            .genero.caption = "genero: mujer"
        end if
        
        .nivel.caption = "nivel: " & buffer.readbyte()
        .oro.caption = "oro: " & buffer.readlong()
        .banco.caption = "banco: " & buffer.readlong()
        
        dim reputation as long
        reputation = buffer.readlong()
        
        .reputacion.caption = "reputaci�n: " & reputation
        
        .txtpeticiones.text = buffer.readasciistring()
        .guildactual.caption = "clan: " & buffer.readasciistring()
        .txtmiembro.text = buffer.readasciistring()
        
        dim armada as boolean
        dim caos as boolean
        
        armada = buffer.readboolean()
        caos = buffer.readboolean()
        
        if armada then
            .ejercito.caption = "ej�rcito: armada real"
        elseif caos then
            .ejercito.caption = "ej�rcito: legi�n oscura"
        end if
        
        .ciudadanos.caption = "ciudadanos asesinados: " & cstr(buffer.readlong())
        .criminales.caption = "criminales asesinados: " & cstr(buffer.readlong())
        
        if reputation > 0 then
            .status.caption = " (ciudadano)"
            .status.forecolor = vbblue
        else
            .status.caption = " (criminal)"
            .status.forecolor = vbred
        end if
        
        call .show(vbmodeless, frmmain)
    end with
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the guildleaderinfo message.

private sub handleguildleaderinfo()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 9 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim list() as string
    dim i as long
    
    with frmguildleader
        'get list of existing guilds
        list = split(buffer.readasciistring(), separator)
        
        'empty the list
        call .guildslist.clear
        
        for i = 0 to ubound(list())
            call .guildslist.additem(list(i))
        next i
        
        'get list of guild's members
        list = split(buffer.readasciistring(), separator)
        .miembros.caption = "el clan cuenta con " & cstr(ubound(list()) + 1) & " miembros."
        
        'empty the list
        call .members.clear
        
        for i = 0 to ubound(list())
            call .members.additem(list(i))
        next i
        
        .txtguildnews = buffer.readasciistring()
        
        'get list of join requests
        list = split(buffer.readasciistring(), separator)
        
        'empty the list
        call .solicitudes.clear
        
        for i = 0 to ubound(list())
            call .solicitudes.additem(list(i))
        next i
        
        .show , frmmain
    end with

    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the guilddetails message.

private sub handleguilddetails()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 26 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    with frmguildbrief
        if not .esleader then
            .guerra.visible = false
            .aliado.visible = false
            .command3.visible = false
        else
            .guerra.visible = true
            .aliado.visible = true
            .command3.visible = true
        end if
        
        .nombre.caption = "nombre:" & buffer.readasciistring()
        .fundador.caption = "fundador:" & buffer.readasciistring()
        .creacion.caption = "fecha de creacion:" & buffer.readasciistring()
        .lider.caption = "l�der:" & buffer.readasciistring()
        .web.caption = "web site:" & buffer.readasciistring()
        .miembros.caption = "miembros:" & buffer.readinteger()
        
        if buffer.readboolean() then
            .eleccion.caption = "elecci�n de l�der: abierta"
        else
            .eleccion.caption = "elecci�n de l�der: cerrada"
        end if
        
        .lblalineacion.caption = "alineaci�n: " & buffer.readasciistring()
        .enemigos.caption = "clanes enemigos:" & buffer.readinteger()
        .aliados.caption = "clanes aliados:" & buffer.readinteger()
        .antifaccion.caption = "puntos antifaccion: " & buffer.readasciistring()
        
        dim codexstr() as string
        dim i as long
        
        codexstr = split(buffer.readasciistring(), separator)
        
        for i = 0 to 7
            .codex(i).caption = codexstr(i)
        next i
        
        .desc.text = buffer.readasciistring()
    end with
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
    frmguildbrief.show vbmodeless, frmmain
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the showguildfundationform message.

private sub handleshowguildfundationform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    creandoclan = true
    frmguildfoundation.show , frmmain
end sub

''
' handles the paralizeok message.

private sub handleparalizeok()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    userparalizado = not userparalizado
end sub

''
' handles the showuserrequest message.

private sub handleshowuserrequest()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    call frmuserrequest.recievepeticion(buffer.readasciistring())
    call frmuserrequest.show(vbmodeless, frmmain)
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the tradeok message.

private sub handletradeok()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    if frmcomerciar.visible then
        dim i as long
        
        call frmcomerciar.list1(1).clear
        
        for i = 1 to max_inventory_slots
            if inventario.objindex(i) <> 0 then
                call frmcomerciar.list1(1).additem(inventario.itemname(i))
            else
                call frmcomerciar.list1(1).additem("")
            end if
        next i
        
        'alter order according to if we bought or sold so the labels and grh remain the same
        if frmcomerciar.lasactionbuy then
            frmcomerciar.list1(1).listindex = frmcomerciar.lastindex2
            frmcomerciar.list1(0).listindex = frmcomerciar.lastindex1
        else
            frmcomerciar.list1(0).listindex = frmcomerciar.lastindex1
            frmcomerciar.list1(1).listindex = frmcomerciar.lastindex2
        end if
    end if
end sub

''
' handles the bankok message.

private sub handlebankok()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    dim i as long
    
    if frmbancoobj.visible then
        
        call frmbancoobj.list1(1).clear
        
        for i = 1 to max_inventory_slots
            if inventario.objindex(i) <> 0 then
                call frmbancoobj.list1(1).additem(inventario.itemname(i))
            else
                call frmbancoobj.list1(1).additem("")
            end if
        next i
        
        'alter order according to if we bought or sold so the labels and grh remain the same
        if frmbancoobj.lasactionbuy then
            frmbancoobj.list1(1).listindex = frmbancoobj.lastindex2
            frmbancoobj.list1(0).listindex = frmbancoobj.lastindex1
        else
            frmbancoobj.list1(0).listindex = frmbancoobj.lastindex1
            frmbancoobj.list1(1).listindex = frmbancoobj.lastindex2
        end if
        
        frmbancoobj.nopuedemover = false
    end if
       
end sub

''
' handles the changeusertradeslot message.

private sub handlechangeusertradeslot()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 22 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    with otroinventario(1)
        .objindex = buffer.readinteger()
        .name = buffer.readasciistring()
        .amount = buffer.readlong()
        .grhindex = buffer.readinteger()
        .objtype = buffer.readbyte()
        .maxhit = buffer.readinteger()
        .minhit = buffer.readinteger()
        .def = buffer.readinteger()
        .valor = buffer.readlong()
        
        frmcomerciarusu.list2.clear
        
        call frmcomerciarusu.list2.additem(.name)
        frmcomerciarusu.list2.itemdata(frmcomerciarusu.list2.newindex) = .amount
        
        frmcomerciarusu.lblestadoresp.visible = false
    end with
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the sendnight message.

private sub handlesendnight()
'***************************************************
'author: fredy horacio treboux (liquid)
'last modification: 01/08/07
'
'***************************************************
    if incomingdata.length < 2 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    dim tbool as boolean 'check, este handle no hace nada con lo que recibe.. porque, ehmm.. no hay noche?.. o si?
    tbool = incomingdata.readboolean()
end sub

''
' handles the spawnlist message.

private sub handlespawnlist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim creaturelist() as string
    dim i as long
    
    creaturelist = split(buffer.readasciistring(), separator)
    
    for i = 0 to ubound(creaturelist())
        call frmspawnlist.lstcriaturas.additem(creaturelist(i))
    next i
    frmspawnlist.show , frmmain
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the showsosform message.

private sub handleshowsosform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim soslist() as string
    dim i as long
    
    soslist = split(buffer.readasciistring(), separator)
    
    for i = 0 to ubound(soslist())
        call frmmsg.list1.additem(soslist(i))
    next i
    
    frmmsg.show , frmmain
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the showmotdeditionform message.

private sub handleshowmotdeditionform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    frmcambiamotd.txtmotd.text = buffer.readasciistring()
    frmcambiamotd.show , frmmain
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the showgmpanelform message.

private sub handleshowgmpanelform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    frmpanelgm.show vbmodeless, frmmain
end sub

''
' handles the usernamelist message.

private sub handleusernamelist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim userlist() as string
    dim i as long
    
    userlist = split(buffer.readasciistring(), separator)
    
    if frmpanelgm.visible then
        frmpanelgm.cbolistausus.clear
        for i = 0 to ubound(userlist())
            call frmpanelgm.cbolistausus.additem(userlist(i))
        next i
        if frmpanelgm.cbolistausus.listcount > 0 then frmpanelgm.cbolistausus.listindex = 0
    end if
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub

''
' handles the pong message.

private sub handlepong()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    call incomingdata.readbyte
    
    call addtorichtextbox(frmmain.rectxt, "el ping es " & (gettickcount - pingtime) & " ms.", 255, 0, 0, true, false, false)
    
    pingtime = 0
end sub

''
' handles the updatetag message.

private sub handleupdatetagandstatus()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if incomingdata.length < 6 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(incomingdata)
    
    'remove packet id
    call buffer.readbyte
    
    dim charindex as integer
    dim criminal as boolean
    dim usertag as string
    
    charindex = buffer.readinteger()
    criminal = buffer.readboolean()
    usertag = buffer.readasciistring()
    
    'update char status adn tag!
    with charlist(charindex)
        if criminal then
            .criminal = 1
        else
            .criminal = 0
        end if
        
        .nombre = usertag
    end with
    
    'if we got here then packet is complete, copy data back to original queue
    call incomingdata.copybuffer(buffer)
    
errhandler:
    dim error as long
    error = err.number
on error goto 0
    
    'destroy auxiliar buffer
    set buffer = nothing

    if error <> 0 then _
        err.raise error
end sub


''
' writes the "loginexistingchar" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeloginexistingchar()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "loginexistingchar" message to the outgoing data buffer
'***************************************************
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.loginexistingchar)
        
        call .writeasciistring(username)
        
#if seguridadalkon then
        call .writeasciistringfixed(userpassword)
#else
        call .writeasciistring(userpassword)
#end if
        
        call .writebyte(app.major)
        call .writebyte(app.minor)
        call .writebyte(app.revision)
        
        for i = 1 to 7
            call .writeinteger(versiones(i))
        next i
        
#if seguridadalkon then
        call .writeasciistringfixed(md5hushyo)
#end if
    end with
end sub

''
' writes the "throwdices" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writethrowdices()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "throwdices" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.throwdices)
end sub

''
' writes the "loginnewchar" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeloginnewchar()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "loginnewchar" message to the outgoing data buffer
'***************************************************
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.loginnewchar)
        
        call .writeasciistring(username)
        
#if seguridadalkon then
        call .writeasciistringfixed(userpassword)
#else
        call .writeasciistring(userpassword)
#end if
        
        call .writebyte(app.major)
        call .writebyte(app.minor)
        call .writebyte(app.revision)
        
        for i = 1 to 7
            call .writeinteger(versiones(i))
        next i
        
#if seguridadalkon then
        call .writeasciistringfixed(md5hushyo)
#end if
        
        call .writebyte(userraza)
        call .writebyte(usersexo)
        call .writebyte(userclase)
        
        for i = 1 to numskills
            call .writebyte(userskills(i))
        next i
        
        call .writeasciistring(useremail)
        
        call .writebyte(userhogar)
    end with
end sub

''
' writes the "talk" message to the outgoing data buffer.
'
' @param    chat the chat text to be sent.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetalk(byval chat as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "talk" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.talk)
        
        call .writeasciistring(chat)
    end with
end sub

''
' writes the "yell" message to the outgoing data buffer.
'
' @param    chat the chat text to be sent.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeyell(byval chat as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "yell" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.yell)
        
        call .writeasciistring(chat)
    end with
end sub

''
' writes the "whisper" message to the outgoing data buffer.
'
' @param    charindex the index of the char to whom to whisper.
' @param    chat the chat text to be sent to the user.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writewhisper(byval charindex as integer, byval chat as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "whisper" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.whisper)
        
        call .writeinteger(charindex)
        
        call .writeasciistring(chat)
    end with
end sub

''
' writes the "walk" message to the outgoing data buffer.
'
' @param    heading the direction in wich the user is moving.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writewalk(byval heading as e_heading)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "walk" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.walk)
        
        call .writebyte(heading)
    end with
end sub

''
' writes the "requestpositionupdate" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestpositionupdate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestpositionupdate" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestpositionupdate)
end sub

''
' writes the "attack" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeattack()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "attack" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.attack)
end sub

''
' writes the "pickup" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepickup()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "pickup" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.pickup)
end sub

''
' writes the "combatmodetoggle" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecombatmodetoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "combatmodetoggle" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.combatmodetoggle)
end sub

''
' writes the "safetoggle" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesafetoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "safetoggle" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.safetoggle)
end sub

''
' writes the "resuscitationsafetoggle" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeresuscitationtoggle()
'**************************************************************
'author: rapsodius
'creation date: 10/10/07
'writes the resuscitation safe toggle packet to the outgoing data buffer.
'**************************************************************
    call outgoingdata.writebyte(clientpacketid.resuscitationsafetoggle)
end sub

''
' writes the "requestguildleaderinfo" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestguildleaderinfo()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestguildleaderinfo" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestguildleaderinfo)
end sub

''
' writes the "requestatributes" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestatributes()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestatributes" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestatributes)
end sub

''
' writes the "requestfame" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestfame()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestfame" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestfame)
end sub

''
' writes the "requestskills" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestskills()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestskills" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestskills)
end sub

''
' writes the "requestministats" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestministats()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestministats" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestministats)
end sub

''
' writes the "commerceend" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecommerceend()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "commerceend" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.commerceend)
end sub

''
' writes the "usercommerceend" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercommerceend()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "usercommerceend" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.usercommerceend)
end sub

''
' writes the "bankend" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankend()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankend" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.bankend)
end sub

''
' writes the "usercommerceok" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercommerceok()
'***************************************************
'author: fredy horacio treboux (liquid)
'last modification: 01/10/07
'writes the "usercommerceok" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.usercommerceok)
end sub

''
' writes the "usercommercereject" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercommercereject()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "usercommercereject" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.usercommercereject)
end sub

''
' writes the "drop" message to the outgoing data buffer.
'
' @param    slot inventory slot where the item to drop is.
' @param    amount number of items to drop.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedrop(byval slot as byte, byval amount as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "drop" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.drop)
        
        call .writebyte(slot)
        call .writeinteger(amount)
    end with
end sub

''
' writes the "castspell" message to the outgoing data buffer.
'
' @param    slot spell list slot where the spell to cast is.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecastspell(byval slot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "castspell" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.castspell)
        
        call .writebyte(slot)
    end with
end sub

''
' writes the "leftclick" message to the outgoing data buffer.
'
' @param    x tile coord in the x-axis in which the user clicked.
' @param    y tile coord in the y-axis in which the user clicked.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeleftclick(byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "leftclick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.leftclick)
        
        call .writebyte(x)
        call .writebyte(y)
    end with
end sub

''
' writes the "doubleclick" message to the outgoing data buffer.
'
' @param    x tile coord in the x-axis in which the user clicked.
' @param    y tile coord in the y-axis in which the user clicked.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedoubleclick(byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "doubleclick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.doubleclick)
        
        call .writebyte(x)
        call .writebyte(y)
    end with
end sub

''
' writes the "work" message to the outgoing data buffer.
'
' @param    skill the skill which the user attempts to use.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writework(byval skill as eskill)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "work" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.work)
        
        call .writebyte(skill)
    end with
end sub

''
' writes the "usespellmacro" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusespellmacro()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "usespellmacro" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.usespellmacro)
end sub

''
' writes the "useitem" message to the outgoing data buffer.
'
' @param    slot invetory slot where the item to use is.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeuseitem(byval slot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "useitem" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.useitem)
        
        call .writebyte(slot)
    end with
end sub

''
' writes the "craftblacksmith" message to the outgoing data buffer.
'
' @param    item index of the item to craft in the list sent by the server.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecraftblacksmith(byval item as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "craftblacksmith" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.craftblacksmith)
        
        call .writeinteger(item)
    end with
end sub

''
' writes the "craftcarpenter" message to the outgoing data buffer.
'
' @param    item index of the item to craft in the list sent by the server.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecraftcarpenter(byval item as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "craftcarpenter" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.craftcarpenter)
        
        call .writeinteger(item)
    end with
end sub

''
' writes the "workleftclick" message to the outgoing data buffer.
'
' @param    x tile coord in the x-axis in which the user clicked.
' @param    y tile coord in the y-axis in which the user clicked.
' @param    skill the skill which the user attempts to use.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeworkleftclick(byval x as byte, byval y as byte, byval skill as eskill)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "workleftclick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.workleftclick)
        
        call .writebyte(x)
        call .writebyte(y)
        
        call .writebyte(skill)
    end with
end sub

''
' writes the "createnewguild" message to the outgoing data buffer.
'
' @param    desc    the guild's description
' @param    name    the guild's name
' @param    site    the guild's website
' @param    codex   array of all rules of the guild.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecreatenewguild(byval desc as string, byval name as string, byval site as string, byref codex() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "createnewguild" message to the outgoing data buffer
'***************************************************
    dim temp as string
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.createnewguild)
        
        call .writeasciistring(desc)
        call .writeasciistring(name)
        call .writeasciistring(site)
        
        for i = lbound(codex()) to ubound(codex())
            temp = temp & codex(i) & separator
        next i
        
        if len(temp) then _
            temp = left$(temp, len(temp) - 1)
        
        call .writeasciistring(temp)
    end with
end sub

''
' writes the "spellinfo" message to the outgoing data buffer.
'
' @param    slot spell list slot where the spell which's info is requested is.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writespellinfo(byval slot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "spellinfo" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.spellinfo)
        
        call .writebyte(slot)
    end with
end sub

''
' writes the "equipitem" message to the outgoing data buffer.
'
' @param    slot invetory slot where the item to equip is.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeequipitem(byval slot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "equipitem" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.equipitem)
        
        call .writebyte(slot)
    end with
end sub

''
' writes the "changeheading" message to the outgoing data buffer.
'
' @param    heading the direction in wich the user is moving.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangeheading(byval heading as e_heading)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "changeheading" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changeheading)
        
        call .writebyte(heading)
    end with
end sub

''
' writes the "modifyskills" message to the outgoing data buffer.
'
' @param    skilledt a-based array containing for each skill the number of points to add to it.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writemodifyskills(byref skilledt() as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "modifyskills" message to the outgoing data buffer
'***************************************************
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.modifyskills)
        
        for i = 1 to numskills
            call .writebyte(skilledt(i))
        next i
    end with
end sub

''
' writes the "train" message to the outgoing data buffer.
'
' @param    creature position within the list provided by the server of the creature to train against.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetrain(byval creature as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "train" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.train)
        
        call .writebyte(creature)
    end with
end sub

''
' writes the "commercebuy" message to the outgoing data buffer.
'
' @param    slot position within the npc's inventory in which the desired item is.
' @param    amount number of items to buy.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecommercebuy(byval slot as byte, byval amount as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "commercebuy" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.commercebuy)
        
        call .writebyte(slot)
        call .writeinteger(amount)
    end with
end sub

''
' writes the "bankextractitem" message to the outgoing data buffer.
'
' @param    slot position within the bank in which the desired item is.
' @param    amount number of items to extract.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankextractitem(byval slot as byte, byval amount as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankextractitem" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.bankextractitem)
        
        call .writebyte(slot)
        call .writeinteger(amount)
    end with
end sub

''
' writes the "commercesell" message to the outgoing data buffer.
'
' @param    slot position within user inventory in which the desired item is.
' @param    amount number of items to sell.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecommercesell(byval slot as byte, byval amount as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "commercesell" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.commercesell)
        
        call .writebyte(slot)
        call .writeinteger(amount)
    end with
end sub

''
' writes the "bankdeposit" message to the outgoing data buffer.
'
' @param    slot position within the user inventory in which the desired item is.
' @param    amount number of items to deposit.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankdeposit(byval slot as byte, byval amount as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankdeposit" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.bankdeposit)
        
        call .writebyte(slot)
        call .writeinteger(amount)
    end with
end sub

''
' writes the "forumpost" message to the outgoing data buffer.
'
' @param    title the message's title.
' @param    message the body of the message.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeforumpost(byval title as string, byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "forumpost" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.forumpost)
        
        call .writeasciistring(title)
        call .writeasciistring(message)
    end with
end sub

''
' writes the "movespell" message to the outgoing data buffer.
'
' @param    upwards true if the spell will be moved up in the list, false if it will be moved downwards.
' @param    slot spell list slot where the spell which's info is requested is.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writemovespell(byval upwards as boolean, byval slot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "movespell" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.movespell)
        
        call .writeboolean(upwards)
        call .writebyte(slot)
    end with
end sub

''
' writes the "movebank" message to the outgoing data buffer.
'
' @param    upwards true if the item will be moved up in the list, false if it will be moved downwards.
' @param    slot bank list slot where the item which's info is requested is.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writemovebank(byval upwards as boolean, byval slot as byte)
'***************************************************
'author: torres patricio (pato)
'last modification: 06/14/09
'writes the "movebank" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.movebank)
        
        call .writeboolean(upwards)
        call .writebyte(slot)
    end with
end sub

''
' writes the "clancodexupdate" message to the outgoing data buffer.
'
' @param    desc new description of the clan.
' @param    codex new codex of the clan.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeclancodexupdate(byval desc as string, byref codex() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "clancodexupdate" message to the outgoing data buffer
'***************************************************
    dim temp as string
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.clancodexupdate)
        
        call .writeasciistring(desc)
        
        for i = lbound(codex()) to ubound(codex())
            temp = temp & codex(i) & separator
        next i
        
        if len(temp) then _
            temp = left$(temp, len(temp) - 1)
        
        call .writeasciistring(temp)
    end with
end sub

''
' writes the "usercommerceoffer" message to the outgoing data buffer.
'
' @param    slot position within user inventory in which the desired item is.
' @param    amount number of items to offer.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercommerceoffer(byval slot as byte, byval amount as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "usercommerceoffer" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.usercommerceoffer)
        
        call .writebyte(slot)
        call .writelong(amount)
    end with
end sub

''
' writes the "guildacceptpeace" message to the outgoing data buffer.
'
' @param    guild the guild whose peace offer is accepted.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildacceptpeace(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildacceptpeace" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildacceptpeace)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "guildrejectalliance" message to the outgoing data buffer.
'
' @param    guild the guild whose aliance offer is rejected.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildrejectalliance(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildrejectalliance" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildrejectalliance)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "guildrejectpeace" message to the outgoing data buffer.
'
' @param    guild the guild whose peace offer is rejected.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildrejectpeace(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildrejectpeace" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildrejectpeace)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "guildacceptalliance" message to the outgoing data buffer.
'
' @param    guild the guild whose aliance offer is accepted.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildacceptalliance(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildacceptalliance" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildacceptalliance)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "guildofferpeace" message to the outgoing data buffer.
'
' @param    guild the guild to whom peace is offered.
' @param    proposal the text to send with the proposal.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildofferpeace(byval guild as string, byval proposal as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildofferpeace" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildofferpeace)
        
        call .writeasciistring(guild)
        call .writeasciistring(proposal)
    end with
end sub

''
' writes the "guildofferalliance" message to the outgoing data buffer.
'
' @param    guild the guild to whom an aliance is offered.
' @param    proposal the text to send with the proposal.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildofferalliance(byval guild as string, byval proposal as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildofferalliance" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildofferalliance)
        
        call .writeasciistring(guild)
        call .writeasciistring(proposal)
    end with
end sub

''
' writes the "guildalliancedetails" message to the outgoing data buffer.
'
' @param    guild the guild whose aliance proposal's details are requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildalliancedetails(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildalliancedetails" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildalliancedetails)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "guildpeacedetails" message to the outgoing data buffer.
'
' @param    guild the guild whose peace proposal's details are requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildpeacedetails(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildpeacedetails" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildpeacedetails)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "guildrequestjoinerinfo" message to the outgoing data buffer.
'
' @param    username the user who wants to join the guild whose info is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildrequestjoinerinfo(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildrequestjoinerinfo" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildrequestjoinerinfo)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "guildallianceproplist" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildallianceproplist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildallianceproplist" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.guildallianceproplist)
end sub

''
' writes the "guildpeaceproplist" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildpeaceproplist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildpeaceproplist" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.guildpeaceproplist)
end sub

''
' writes the "guilddeclarewar" message to the outgoing data buffer.
'
' @param    guild the guild to which to declare war.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguilddeclarewar(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guilddeclarewar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guilddeclarewar)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "guildnewwebsite" message to the outgoing data buffer.
'
' @param    url the guild's new website's url.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildnewwebsite(byval url as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildnewwebsite" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildnewwebsite)
        
        call .writeasciistring(url)
    end with
end sub

''
' writes the "guildacceptnewmember" message to the outgoing data buffer.
'
' @param    username the name of the accepted player.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildacceptnewmember(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildacceptnewmember" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildacceptnewmember)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "guildrejectnewmember" message to the outgoing data buffer.
'
' @param    username the name of the rejected player.
' @param    reason the reason for which the player was rejected.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildrejectnewmember(byval username as string, byval reason as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildrejectnewmember" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildrejectnewmember)
        
        call .writeasciistring(username)
        call .writeasciistring(reason)
    end with
end sub

''
' writes the "guildkickmember" message to the outgoing data buffer.
'
' @param    username the name of the kicked player.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildkickmember(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildkickmember" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildkickmember)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "guildupdatenews" message to the outgoing data buffer.
'
' @param    news the news to be posted.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildupdatenews(byval news as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildupdatenews" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildupdatenews)
        
        call .writeasciistring(news)
    end with
end sub

''
' writes the "guildmemberinfo" message to the outgoing data buffer.
'
' @param    username the user whose info is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildmemberinfo(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildmemberinfo" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildmemberinfo)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "guildopenelections" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildopenelections()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildopenelections" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.guildopenelections)
end sub

''
' writes the "guildrequestmembership" message to the outgoing data buffer.
'
' @param    guild the guild to which to request membership.
' @param    application the user's application sheet.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildrequestmembership(byval guild as string, byval application as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildrequestmembership" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildrequestmembership)
        
        call .writeasciistring(guild)
        call .writeasciistring(application)
    end with
end sub

''
' writes the "guildrequestdetails" message to the outgoing data buffer.
'
' @param    guild the guild whose details are requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildrequestdetails(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildrequestdetails" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildrequestdetails)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "online" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeonline()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "online" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.online)
end sub

''
' writes the "quit" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writequit()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/16/08
'writes the "quit" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.quit)
end sub

''
' writes the "guildleave" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildleave()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildleave" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.guildleave)
end sub

''
' writes the "requestaccountstate" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestaccountstate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestaccountstate" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestaccountstate)
end sub

''
' writes the "petstand" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepetstand()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "petstand" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.petstand)
end sub

''
' writes the "petfollow" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepetfollow()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "petfollow" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.petfollow)
end sub

''
' writes the "trainlist" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetrainlist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "trainlist" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.trainlist)
end sub

''
' writes the "rest" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerest()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "rest" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.rest)
end sub

''
' writes the "meditate" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writemeditate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "meditate" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.meditate)
end sub

''
' writes the "resucitate" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeresucitate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "resucitate" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.resucitate)
end sub

''
' writes the "heal" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeheal()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "heal" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.heal)
end sub

''
' writes the "help" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writehelp()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "help" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.help)
end sub

''
' writes the "requeststats" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequeststats()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requeststats" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requeststats)
end sub

''
' writes the "commercestart" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecommercestart()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "commercestart" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.commercestart)
end sub

''
' writes the "bankstart" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankstart()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankstart" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.bankstart)
end sub

''
' writes the "enlist" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeenlist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "enlist" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.enlist)
end sub

''
' writes the "information" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeinformation()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "information" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.information)
end sub

''
' writes the "reward" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writereward()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "reward" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.reward)
end sub

''
' writes the "requestmotd" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestmotd()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestmotd" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestmotd)
end sub

''
' writes the "uptime" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeuptime()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "uptime" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.uptime)
end sub

''
' writes the "partyleave" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartyleave()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partyleave" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.partyleave)
end sub

''
' writes the "partycreate" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartycreate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partycreate" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.partycreate)
end sub

''
' writes the "partyjoin" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartyjoin()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partyjoin" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.partyjoin)
end sub

''
' writes the "inquiry" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeinquiry()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "inquiry" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.inquiry)
end sub

''
' writes the "guildmessage" message to the outgoing data buffer.
'
' @param    message the message to send to the guild.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildmessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildrequestdetails" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildmessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "partymessage" message to the outgoing data buffer.
'
' @param    message the message to send to the party.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartymessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partymessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.partymessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "centinelreport" message to the outgoing data buffer.
'
' @param    number the number to report to the centinel.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecentinelreport(byval number as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "centinelreport" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.centinelreport)
        
        call .writeinteger(number)
    end with
end sub

''
' writes the "guildonline" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildonline()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildonline" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.guildonline)
end sub

''
' writes the "partyonline" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartyonline()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partyonline" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.partyonline)
end sub

''
' writes the "councilmessage" message to the outgoing data buffer.
'
' @param    message the message to send to the other council members.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecouncilmessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "councilmessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.councilmessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "rolemasterrequest" message to the outgoing data buffer.
'
' @param    message the message to send to the role masters.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerolemasterrequest(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "rolemasterrequest" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.rolemasterrequest)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "gmrequest" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writegmrequest()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "gmrequest" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.gmrequest)
end sub

''
' writes the "bugreport" message to the outgoing data buffer.
'
' @param    message the message explaining the reported bug.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebugreport(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bugreport" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.bugreport)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "changedescription" message to the outgoing data buffer.
'
' @param    desc the new description of the user's character.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangedescription(byval desc as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "changedescription" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changedescription)
        
        call .writeasciistring(desc)
    end with
end sub

''
' writes the "guildvote" message to the outgoing data buffer.
'
' @param    username the user to vote for clan leader.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildvote(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildvote" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildvote)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "punishments" message to the outgoing data buffer.
'
' @param    username the user whose's  punishments are requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepunishments(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "punishments" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.punishments)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "changepassword" message to the outgoing data buffer.
'
' @param    oldpass previous password.
' @param    newpass new password.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangepassword(byref oldpass as string, byref newpass as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 10/10/07
'last modified by: rapsodius
'writes the "changepassword" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changepassword)
        
#if seguridadalkon then
        call .writeasciistringfixed(md5.getmd5string(oldpass))
        call md5.md5reset
        call .writeasciistringfixed(md5.getmd5string(newpass))
        call md5.md5reset
#else
        call .writeasciistring(oldpass)
        call .writeasciistring(newpass)
#end if
    end with
end sub

''
' writes the "gamble" message to the outgoing data buffer.
'
' @param    amount the amount to gamble.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writegamble(byval amount as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "gamble" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.gamble)
        
        call .writeinteger(amount)
    end with
end sub

''
' writes the "inquiryvote" message to the outgoing data buffer.
'
' @param    opt the chosen option to vote for.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeinquiryvote(byval opt as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "inquiryvote" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.inquiryvote)
        
        call .writebyte(opt)
    end with
end sub

''
' writes the "leavefaction" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeleavefaction()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "leavefaction" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.leavefaction)
end sub

''
' writes the "bankextractgold" message to the outgoing data buffer.
'
' @param    amount the amount of money to extract from the bank.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankextractgold(byval amount as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankextractgold" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.bankextractgold)
        
        call .writelong(amount)
    end with
end sub

''
' writes the "bankdepositgold" message to the outgoing data buffer.
'
' @param    amount the amount of money to deposit in the bank.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankdepositgold(byval amount as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankdepositgold" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.bankdepositgold)
        
        call .writelong(amount)
    end with
end sub

''
' writes the "denounce" message to the outgoing data buffer.
'
' @param    message the message to send with the denounce.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedenounce(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "denounce" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.denounce)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "guildfundate" message to the outgoing data buffer.
'
' @param    clantype the alignment of the clan to be founded.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildfundate(byval clantype as eclantype)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildfundate" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildfundate)
        
        call .writebyte(clantype)
    end with
end sub

''
' writes the "partykick" message to the outgoing data buffer.
'
' @param    username the user to kick fro mthe party.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartykick(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partykick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.partykick)
            
        call .writeasciistring(username)
    end with
end sub

''
' writes the "partysetleader" message to the outgoing data buffer.
'
' @param    username the user to set as the party's leader.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartysetleader(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partysetleader" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.partysetleader)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "partyacceptmember" message to the outgoing data buffer.
'
' @param    username the user to accept into the party.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepartyacceptmember(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "partyacceptmember" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.partyacceptmember)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "guildmemberlist" message to the outgoing data buffer.
'
' @param    guild the guild whose member list is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildmemberlist(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildmemberlist" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildmemberlist)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "gmmessage" message to the outgoing data buffer.
'
' @param    message the message to be sent to the other gms online.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writegmmessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "gmmessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.gmmessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "showname" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowname()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showname" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.showname)
end sub

''
' writes the "onlineroyalarmy" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeonlineroyalarmy()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "onlineroyalarmy" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.onlineroyalarmy)
end sub

''
' writes the "onlinechaoslegion" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeonlinechaoslegion()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "onlinechaoslegion" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.onlinechaoslegion)
end sub

''
' writes the "gonearby" message to the outgoing data buffer.
'
' @param    username the suer to approach.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writegonearby(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "gonearby" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.gonearby)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "comment" message to the outgoing data buffer.
'
' @param    message the message to leave in the log as a comment.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecomment(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "comment" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.comment)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "servertime" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeservertime()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "servertime" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.servertime)
end sub

''
' writes the "where" message to the outgoing data buffer.
'
' @param    username the user whose position is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writewhere(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "where" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.where)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "creaturesinmap" message to the outgoing data buffer.
'
' @param    map the map in which to check for the existing creatures.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecreaturesinmap(byval map as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "creaturesinmap" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.creaturesinmap)
        
        call .writeinteger(map)
    end with
end sub

''
' writes the "warpmetotarget" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writewarpmetotarget()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "warpmetotarget" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.warpmetotarget)
end sub

''
' writes the "warpchar" message to the outgoing data buffer.
'
' @param    username the user to be warped. "yo" represent's the user's char.
' @param    map the map to which to warp the character.
' @param    x the x position in the map to which to waro the character.
' @param    y the y position in the map to which to waro the character.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writewarpchar(byval username as string, byval map as integer, byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "warpchar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.warpchar)
        
        call .writeasciistring(username)
        
        call .writeinteger(map)
        
        call .writebyte(x)
        call .writebyte(y)
    end with
end sub

''
' writes the "silence" message to the outgoing data buffer.
'
' @param    username the user to silence.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesilence(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "silence" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.silence)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "sosshowlist" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesosshowlist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "sosshowlist" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.sosshowlist)
end sub

''
' writes the "sosremove" message to the outgoing data buffer.
'
' @param    username the user whose sos call has been already attended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesosremove(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "sosremove" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.sosremove)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "gotochar" message to the outgoing data buffer.
'
' @param    username the user to be approached.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writegotochar(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "gotochar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.gotochar)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "invisible" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeinvisible()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "invisible" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.invisible)
end sub

''
' writes the "gmpanel" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writegmpanel()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "gmpanel" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.gmpanel)
end sub

''
' writes the "requestuserlist" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestuserlist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestuserlist" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestuserlist)
end sub

''
' writes the "working" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeworking()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "working" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.working)
end sub

''
' writes the "hiding" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writehiding()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "hiding" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.hiding)
end sub

''
' writes the "jail" message to the outgoing data buffer.
'
' @param    username the user to be sent to jail.
' @param    reason the reason for which to send him to jail.
' @param    time the time (in minutes) the user will have to spend there.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writejail(byval username as string, byval reason as string, byval time as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "jail" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.jail)
        
        call .writeasciistring(username)
        call .writeasciistring(reason)
        
        call .writebyte(time)
    end with
end sub

''
' writes the "killnpc" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writekillnpc()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "killnpc" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.killnpc)
end sub

''
' writes the "warnuser" message to the outgoing data buffer.
'
' @param    username the user to be warned.
' @param    reason reason for the warning.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writewarnuser(byval username as string, byval reason as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "warnuser" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.warnuser)
        
        call .writeasciistring(username)
        call .writeasciistring(reason)
    end with
end sub

''
' writes the "editchar" message to the outgoing data buffer.
'
' @param    username    the user to be edited.
' @param    editoption  indicates what to edit in the char.
' @param    arg1        additional argument 1. contents depend on editoption.
' @param    arg2        additional argument 2. contents depend on editoption.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeeditchar(byval username as string, byval editoption as eeditoptions, byval arg1 as string, byval arg2 as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "editchar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.editchar)
        
        call .writeasciistring(username)
        
        call .writebyte(editoption)
        
        call .writeasciistring(arg1)
        call .writeasciistring(arg2)
    end with
end sub

''
' writes the "requestcharinfo" message to the outgoing data buffer.
'
' @param    username the user whose information is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestcharinfo(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestcharinfo" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.requestcharinfo)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "requestcharstats" message to the outgoing data buffer.
'
' @param    username the user whose stats are requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestcharstats(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestcharstats" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.requestcharstats)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "requestchargold" message to the outgoing data buffer.
'
' @param    username the user whose gold is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestchargold(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestchargold" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.requestchargold)
        
        call .writeasciistring(username)
    end with
end sub
    
''
' writes the "requestcharinventory" message to the outgoing data buffer.
'
' @param    username the user whose inventory is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestcharinventory(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestcharinventory" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.requestcharinventory)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "requestcharbank" message to the outgoing data buffer.
'
' @param    username the user whose banking information is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestcharbank(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestcharbank" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.requestcharbank)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "requestcharskills" message to the outgoing data buffer.
'
' @param    username the user whose skills are requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestcharskills(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestcharskills" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.requestcharskills)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "revivechar" message to the outgoing data buffer.
'
' @param    username the user to eb revived.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerevivechar(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "revivechar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.revivechar)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "onlinegm" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeonlinegm()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "onlinegm" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.onlinegm)
end sub

''
' writes the "onlinemap" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeonlinemap(byval map as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 26/03/2009
'writes the "onlinemap" message to the outgoing data buffer
'26/03/2009: now you don't need to be in the map to use the comand, so you send the map to server
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.onlinemap)
        
        call .writeinteger(map)
    end with
end sub

''
' writes the "forgive" message to the outgoing data buffer.
'
' @param    username the user to be forgiven.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeforgive(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "forgive" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.forgive)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "kick" message to the outgoing data buffer.
'
' @param    username the user to be kicked.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writekick(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "kick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.kick)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "execute" message to the outgoing data buffer.
'
' @param    username the user to be executed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeexecute(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "execute" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.execute)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "banchar" message to the outgoing data buffer.
'
' @param    username the user to be banned.
' @param    reason the reson for which the user is to be banned.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebanchar(byval username as string, byval reason as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "banchar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.banchar)
        
        call .writeasciistring(username)
        
        call .writeasciistring(reason)
    end with
end sub

''
' writes the "unbanchar" message to the outgoing data buffer.
'
' @param    username the user to be unbanned.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeunbanchar(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "unbanchar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.unbanchar)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "npcfollow" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writenpcfollow()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "npcfollow" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.npcfollow)
end sub

''
' writes the "summonchar" message to the outgoing data buffer.
'
' @param    username the user to be summoned.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesummonchar(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "summonchar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.summonchar)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "spawnlistrequest" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writespawnlistrequest()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "spawnlistrequest" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.spawnlistrequest)
end sub

''
' writes the "spawncreature" message to the outgoing data buffer.
'
' @param    creatureindex the index of the creature in the spawn list to be spawned.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writespawncreature(byval creatureindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "spawncreature" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.spawncreature)
        
        call .writeinteger(creatureindex)
    end with
end sub

''
' writes the "resetnpcinventory" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeresetnpcinventory()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "resetnpcinventory" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.resetnpcinventory)
end sub

''
' writes the "cleanworld" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecleanworld()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "cleanworld" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.cleanworld)
end sub

''
' writes the "servermessage" message to the outgoing data buffer.
'
' @param    message the message to be sent to players.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeservermessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "servermessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.servermessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "nicktoip" message to the outgoing data buffer.
'
' @param    username the user whose ip is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writenicktoip(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "nicktoip" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.nicktoip)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "iptonick" message to the outgoing data buffer.
'
' @param    ip the ip for which to search for players. must be an array of 4 elements with the 4 components of the ip.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeiptonick(byref ip() as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "iptonick" message to the outgoing data buffer
'***************************************************
    if ubound(ip()) - lbound(ip()) + 1 <> 4 then exit sub   'invalid ip
    
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.iptonick)
        
        for i = lbound(ip()) to ubound(ip())
            call .writebyte(ip(i))
        next i
    end with
end sub

''
' writes the "guildonlinemembers" message to the outgoing data buffer.
'
' @param    guild the guild whose online player list is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildonlinemembers(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildonlinemembers" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildonlinemembers)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "teleportcreate" message to the outgoing data buffer.
'
' @param    map the map to which the teleport will lead.
' @param    x the position in the x axis to which the teleport will lead.
' @param    y the position in the y axis to which the teleport will lead.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeteleportcreate(byval map as integer, byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "teleportcreate" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.teleportcreate)
        
        call .writeinteger(map)
        
        call .writebyte(x)
        call .writebyte(y)
    end with
end sub

''
' writes the "teleportdestroy" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeteleportdestroy()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "teleportdestroy" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.teleportdestroy)
end sub

''
' writes the "raintoggle" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeraintoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "raintoggle" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.raintoggle)
end sub

''
' writes the "setchardescription" message to the outgoing data buffer.
'
' @param    desc the description to set to players.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesetchardescription(byval desc as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "setchardescription" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.setchardescription)
        
        call .writeasciistring(desc)
    end with
end sub

''
' writes the "forcemiditomap" message to the outgoing data buffer.
'
' @param    midiid the id of the midi file to play.
' @param    map the map in which to play the given midi.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeforcemiditomap(byval midiid as byte, byval map as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "forcemiditomap" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.forcemiditomap)
        
        call .writebyte(midiid)
        
        call .writeinteger(map)
    end with
end sub

''
' writes the "forcewavetomap" message to the outgoing data buffer.
'
' @param    waveid  the id of the wave file to play.
' @param    map     the map into which to play the given wave.
' @param    x       the position in the x axis in which to play the given wave.
' @param    y       the position in the y axis in which to play the given wave.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeforcewavetomap(byval waveid as byte, byval map as integer, byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "forcewavetomap" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.forcewavetomap)
        
        call .writebyte(waveid)
        
        call .writeinteger(map)
        
        call .writebyte(x)
        call .writebyte(y)
    end with
end sub

''
' writes the "royalarmymessage" message to the outgoing data buffer.
'
' @param    message the message to send to the royal army members.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeroyalarmymessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "royalarmymessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.royalarmymessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "chaoslegionmessage" message to the outgoing data buffer.
'
' @param    message the message to send to the chaos legion member.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechaoslegionmessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "chaoslegionmessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.chaoslegionmessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "citizenmessage" message to the outgoing data buffer.
'
' @param    message the message to send to citizens.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecitizenmessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "citizenmessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.citizenmessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "criminalmessage" message to the outgoing data buffer.
'
' @param    message the message to send to criminals.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecriminalmessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "criminalmessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.criminalmessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "talkasnpc" message to the outgoing data buffer.
'
' @param    message the message to send to the royal army members.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetalkasnpc(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "talkasnpc" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.talkasnpc)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "destroyallitemsinarea" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedestroyallitemsinarea()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "destroyallitemsinarea" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.destroyallitemsinarea)
end sub

''
' writes the "acceptroyalcouncilmember" message to the outgoing data buffer.
'
' @param    username the name of the user to be accepted into the royal army council.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeacceptroyalcouncilmember(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "acceptroyalcouncilmember" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.acceptroyalcouncilmember)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "acceptchaoscouncilmember" message to the outgoing data buffer.
'
' @param    username the name of the user to be accepted as a chaos council member.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeacceptchaoscouncilmember(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "acceptchaoscouncilmember" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.acceptchaoscouncilmember)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "itemsinthefloor" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeitemsinthefloor()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "itemsinthefloor" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.itemsinthefloor)
end sub

''
' writes the "makedumb" message to the outgoing data buffer.
'
' @param    username the name of the user to be made dumb.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writemakedumb(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "makedumb" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.makedumb)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "makedumbnomore" message to the outgoing data buffer.
'
' @param    username the name of the user who will no longer be dumb.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writemakedumbnomore(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "makedumbnomore" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.makedumbnomore)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "dumpiptables" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedumpiptables()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "dumpiptables" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.dumpiptables)
end sub

''
' writes the "councilkick" message to the outgoing data buffer.
'
' @param    username the name of the user to be kicked from the council.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecouncilkick(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "councilkick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.councilkick)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "settrigger" message to the outgoing data buffer.
'
' @param    trigger the type of trigger to be set to the tile.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesettrigger(byval trigger as etrigger)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "settrigger" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.settrigger)
        
        call .writebyte(trigger)
    end with
end sub

''
' writes the "asktrigger" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeasktrigger()
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 04/13/07
'writes the "asktrigger" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.asktrigger)
end sub

''
' writes the "bannediplist" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebannediplist()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bannediplist" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.bannediplist)
end sub

''
' writes the "bannedipreload" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebannedipreload()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bannedipreload" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.bannedipreload)
end sub

''
' writes the "guildban" message to the outgoing data buffer.
'
' @param    guild the guild whose members will be banned.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildban(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildban" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildban)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "banip" message to the outgoing data buffer.
'
' @param    byip    if set to true, we are banning by ip, otherwise the ip of a given character.
' @param    ip      the ip for which to search for players. must be an array of 4 elements with the 4 components of the ip.
' @param    nick    the nick of the player whose ip will be banned.
' @param    reason  the reason for the ban.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebanip(byval byip as boolean, byref ip() as byte, byval nick as string, byval reason as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "banip" message to the outgoing data buffer
'***************************************************
    if byip and ubound(ip()) - lbound(ip()) + 1 <> 4 then exit sub   'invalid ip
    
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.banip)
        
        call .writeboolean(byip)
        
        if byip then
            for i = lbound(ip()) to ubound(ip())
                call .writebyte(ip(i))
            next i
        else
            call .writeasciistring(nick)
        end if
        
        call .writeasciistring(reason)
    end with
end sub

''
' writes the "unbanip" message to the outgoing data buffer.
'
' @param    ip the ip for which to search for players. must be an array of 4 elements with the 4 components of the ip.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeunbanip(byref ip() as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "unbanip" message to the outgoing data buffer
'***************************************************
    if ubound(ip()) - lbound(ip()) + 1 <> 4 then exit sub   'invalid ip
    
    dim i as long
    
    with outgoingdata
        call .writebyte(clientpacketid.unbanip)
        
        for i = lbound(ip()) to ubound(ip())
            call .writebyte(ip(i))
        next i
    end with
end sub

''
' writes the "createitem" message to the outgoing data buffer.
'
' @param    itemindex the index of the item to be created.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecreateitem(byval itemindex as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "createitem" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.createitem)
        
        call .writeinteger(itemindex)
    end with
end sub

''
' writes the "destroyitems" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedestroyitems()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "destroyitems" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.destroyitems)
end sub

''
' writes the "chaoslegionkick" message to the outgoing data buffer.
'
' @param    username the name of the user to be kicked from the chaos legion.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechaoslegionkick(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "chaoslegionkick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.chaoslegionkick)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "royalarmykick" message to the outgoing data buffer.
'
' @param    username the name of the user to be kicked from the royal army.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeroyalarmykick(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "royalarmykick" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.royalarmykick)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "forcemidiall" message to the outgoing data buffer.
'
' @param    midiid the id of the midi file to play.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeforcemidiall(byval midiid as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "forcemidiall" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.forcemidiall)
        
        call .writebyte(midiid)
    end with
end sub

''
' writes the "forcewaveall" message to the outgoing data buffer.
'
' @param    waveid the id of the wave file to play.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeforcewaveall(byval waveid as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "forcewaveall" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.forcewaveall)
        
        call .writebyte(waveid)
    end with
end sub

''
' writes the "removepunishment" message to the outgoing data buffer.
'
' @param    username the user whose punishments will be altered.
' @param    punishment the id of the punishment to be removed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeremovepunishment(byval username as string, byval punishment as byte, byval newtext as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "removepunishment" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.removepunishment)
        
        call .writeasciistring(username)
        call .writebyte(punishment)
        call .writeasciistring(newtext)
    end with
end sub

''
' writes the "tileblockedtoggle" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetileblockedtoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "tileblockedtoggle" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.tileblockedtoggle)
end sub

''
' writes the "killnpcnorespawn" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writekillnpcnorespawn()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "killnpcnorespawn" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.killnpcnorespawn)
end sub

''
' writes the "killallnearbynpcs" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writekillallnearbynpcs()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "killallnearbynpcs" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.killallnearbynpcs)
end sub

''
' writes the "lastip" message to the outgoing data buffer.
'
' @param    username the user whose last ips are requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writelastip(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "lastip" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.lastip)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "changemotd" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemotd()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "changemotd" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.changemotd)
end sub

''
' writes the "setmotd" message to the outgoing data buffer.
'
' @param    message the message to be set as the new motd.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesetmotd(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "setmotd" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.setmotd)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "systemmessage" message to the outgoing data buffer.
'
' @param    message the message to be sent to all players.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesystemmessage(byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "systemmessage" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.systemmessage)
        
        call .writeasciistring(message)
    end with
end sub

''
' writes the "createnpc" message to the outgoing data buffer.
'
' @param    npcindex the index of the npc to be created.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecreatenpc(byval npcindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "createnpc" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.createnpc)
        
        call .writeinteger(npcindex)
    end with
end sub

''
' writes the "createnpcwithrespawn" message to the outgoing data buffer.
'
' @param    npcindex the index of the npc to be created.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecreatenpcwithrespawn(byval npcindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "createnpcwithrespawn" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.createnpcwithrespawn)
        
        call .writeinteger(npcindex)
    end with
end sub

''
' writes the "imperialarmour" message to the outgoing data buffer.
'
' @param    armourindex the index of imperial armour to be altered.
' @param    objectindex the index of the new object to be set as the imperial armour.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeimperialarmour(byval armourindex as byte, byval objectindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "imperialarmour" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.imperialarmour)
        
        call .writebyte(armourindex)
        
        call .writeinteger(objectindex)
    end with
end sub

''
' writes the "chaosarmour" message to the outgoing data buffer.
'
' @param    armourindex the index of chaos armour to be altered.
' @param    objectindex the index of the new object to be set as the chaos armour.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechaosarmour(byval armourindex as byte, byval objectindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "chaosarmour" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.chaosarmour)
        
        call .writebyte(armourindex)
        
        call .writeinteger(objectindex)
    end with
end sub

''
' writes the "navigatetoggle" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writenavigatetoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "navigatetoggle" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.navigatetoggle)
end sub

''
' writes the "serveropentouserstoggle" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeserveropentouserstoggle()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "serveropentouserstoggle" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.serveropentouserstoggle)
end sub

''
' writes the "turnoffserver" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeturnoffserver()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "turnoffserver" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.turnoffserver)
end sub

''
' writes the "turncriminal" message to the outgoing data buffer.
'
' @param    username the name of the user to turn into criminal.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeturncriminal(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "turncriminal" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.turncriminal)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "resetfactions" message to the outgoing data buffer.
'
' @param    username the name of the user who will be removed from any faction.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeresetfactions(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "resetfactions" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.resetfactions)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "removecharfromguild" message to the outgoing data buffer.
'
' @param    username the name of the user who will be removed from any guild.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeremovecharfromguild(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "removecharfromguild" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.removecharfromguild)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "requestcharmail" message to the outgoing data buffer.
'
' @param    username the name of the user whose mail is requested.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerequestcharmail(byval username as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "requestcharmail" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.requestcharmail)
        
        call .writeasciistring(username)
    end with
end sub

''
' writes the "alterpassword" message to the outgoing data buffer.
'
' @param    username the name of the user whose mail is requested.
' @param    copyfrom the name of the user from which to copy the password.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writealterpassword(byval username as string, byval copyfrom as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "alterpassword" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.alterpassword)
        
        call .writeasciistring(username)
        call .writeasciistring(copyfrom)
    end with
end sub

''
' writes the "altermail" message to the outgoing data buffer.
'
' @param    username the name of the user whose mail is requested.
' @param    newmail the new email of the player.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writealtermail(byval username as string, byval newmail as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "altermail" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.altermail)
        
        call .writeasciistring(username)
        call .writeasciistring(newmail)
    end with
end sub

''
' writes the "altername" message to the outgoing data buffer.
'
' @param    username the name of the user whose mail is requested.
' @param    newname the new user name.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writealtername(byval username as string, byval newname as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "altername" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.altername)
        
        call .writeasciistring(username)
        call .writeasciistring(newname)
    end with
end sub

''
' writes the "togglecentinelactivated" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetogglecentinelactivated()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "togglecentinelactivated" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.togglecentinelactivated)
end sub

''
' writes the "dobackup" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedobackup()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "dobackup" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.dobackup)
end sub

''
' writes the "showguildmessages" message to the outgoing data buffer.
'
' @param    guild the guild to listen to.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowguildmessages(byval guild as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showguildmessages" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.showguildmessages)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "savemap" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesavemap()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "savemap" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.savemap)
end sub

''
' writes the "changemapinfopk" message to the outgoing data buffer.
'
' @param    ispk true if the map is pk, false otherwise.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinfopk(byval ispk as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "changemapinfopk" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinfopk)
        
        call .writeboolean(ispk)
    end with
end sub

''
' writes the "changemapinfobackup" message to the outgoing data buffer.
'
' @param    backup true if the map is to be backuped, false otherwise.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinfobackup(byval backup as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "changemapinfobackup" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinfobackup)
        
        call .writeboolean(backup)
    end with
end sub

''
' writes the "changemapinforestricted" message to the outgoing data buffer.
'
' @param    restrict newbies (only newbies), no (everyone), armada (just armadas), caos (just caos) or faccion (armadas & caos only)
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinforestricted(byval restrict as string)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'writes the "changemapinforestricted" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinforestricted)
        
        call .writeasciistring(restrict)
    end with
end sub

''
' writes the "changemapinfonomagic" message to the outgoing data buffer.
'
' @param    nomagic true if no magic is to be allowed in the map.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinfonomagic(byval nomagic as boolean)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'writes the "changemapinfonomagic" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinfonomagic)
        
        call .writeboolean(nomagic)
    end with
end sub

''
' writes the "changemapinfonoinvi" message to the outgoing data buffer.
'
' @param    noinvi true if invisibility is not to be allowed in the map.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinfonoinvi(byval noinvi as boolean)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'writes the "changemapinfonoinvi" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinfonoinvi)
        
        call .writeboolean(noinvi)
    end with
end sub
                            
''
' writes the "changemapinfonoresu" message to the outgoing data buffer.
'
' @param    noresu true if resurection is not to be allowed in the map.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinfonoresu(byval noresu as boolean)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'writes the "changemapinfonoresu" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinfonoresu)
        
        call .writeboolean(noresu)
    end with
end sub
                        
''
' writes the "changemapinfoland" message to the outgoing data buffer.
'
' @param    land options: "bosque", "nieve", "desierto", "ciudad", "campo", "dungeon".
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinfoland(byval land as string)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'writes the "changemapinfoland" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinfoland)
        
        call .writeasciistring(land)
    end with
end sub
                        
''
' writes the "changemapinfozone" message to the outgoing data buffer.
'
' @param    zone options: "bosque", "nieve", "desierto", "ciudad", "campo", "dungeon".
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemapinfozone(byval zone as string)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'writes the "changemapinfozone" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.changemapinfozone)
        
        call .writeasciistring(zone)
    end with
end sub

''
' writes the "savechars" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesavechars()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "savechars" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.savechars)
end sub

''
' writes the "cleansos" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecleansos()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "cleansos" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.cleansos)
end sub

''
' writes the "showserverform" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowserverform()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showserverform" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.showserverform)
end sub

''
' writes the "night" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writenight()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "night" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.night)
end sub

''
' writes the "kickallchars" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writekickallchars()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "kickallchars" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.kickallchars)
end sub

''
' writes the "reloadnpcs" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writereloadnpcs()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "reloadnpcs" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.reloadnpcs)
end sub

''
' writes the "reloadserverini" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writereloadserverini()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "reloadserverini" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.reloadserverini)
end sub

''
' writes the "reloadspells" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writereloadspells()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "reloadspells" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.reloadspells)
end sub

''
' writes the "reloadobjects" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writereloadobjects()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "reloadobjects" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.reloadobjects)
end sub

''
' writes the "restart" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerestart()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "restart" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.restart)
end sub

''
' writes the "resetautoupdate" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeresetautoupdate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "resetautoupdate" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.resetautoupdate)
end sub

''
' writes the "chatcolor" message to the outgoing data buffer.
'
' @param    r the red component of the new chat color.
' @param    g the green component of the new chat color.
' @param    b the blue component of the new chat color.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechatcolor(byval r as byte, byval g as byte, byval b as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "chatcolor" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.chatcolor)
        
        call .writebyte(r)
        call .writebyte(g)
        call .writebyte(b)
    end with
end sub

''
' writes the "ignored" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeignored()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "ignored" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.ignored)
end sub

''
' writes the "checkslot" message to the outgoing data buffer.
'
' @param    username    the name of the char whose slot will be checked.
' @param    slot        the slot to be checked.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecheckslot(byval username as string, byval slot as byte)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'writes the "checkslot" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.checkslot)
        call .writeasciistring(username)
        call .writebyte(slot)
    end with
end sub

''
' writes the "ping" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeping()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 26/01/2007
'writes the "ping" message to the outgoing data buffer
'***************************************************
    'prevent the timer from being cut
    if pingtime <> 0 then exit sub
    
    call outgoingdata.writebyte(clientpacketid.ping)
    
    ' avoid computing errors due to frame rate
    call flushbuffer
    doevents
    
    pingtime = gettickcount
end sub

''
' writes the "setinivar" message to the outgoing data buffer.
'
' @param    sllave the name of the key which contains the value to edit
' @param    sclave the name of the value to edit
' @param    svalor the new value to set to sclave
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesetinivar(byref sllave as string, byref sclave as string, byref svalor as string)
'***************************************************
'author: brian chaia (brianpr)
'last modification: 21/06/2009
'writes the "setinivar" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.setinivar)
        
        call .writeasciistring(sllave)
        call .writeasciistring(sclave)
        call .writeasciistring(svalor)
    end with
end sub

''
' flushes the outgoing data buffer of the user.
'
' @param    userindex user whose outgoing data buffer will be flushed.

public sub flushbuffer()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'sends all data existing in the buffer
'***************************************************
    dim snddata as string
    
    with outgoingdata
        if .length = 0 then _
            exit sub
        
        snddata = .readasciistringfixed(.length)
        
        call senddata(snddata)
    end with
end sub

''
' sends the data using the socket controls in the mainform.
'
' @param    sddata  the data to be sent to the server.

private sub senddata(byref sddata as string)
    
    'no enviamos nada si no estamos conectados
#if usarwrench = 1 then
    if not frmmain.socket1.iswritable then
        'put data back in the bytequeue
        call outgoingdata.writeasciistringfixed(sddata)
        
        exit sub
    end if
    
    if not frmmain.socket1.connected then exit sub
#else
    if frmmain.winsock1.state <> sckconnected then exit sub
#end if

#if seguridadalkon then
    dim data() as byte
    
    data = strconv(sddata, vbfromunicode)
    
    call datasent(data)
    
    sddata = strconv(data, vbunicode)
#end if
    
    'send data!
#if usarwrench = 1 then
    call frmmain.socket1.write(sddata, len(sddata))
#else
    call frmmain.winsock1.senddata(sddata)
#end if

end sub
