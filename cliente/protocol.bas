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
    userofferconfirm
    commercechat
    showblacksmithform      ' sfh
    showcarpenterform       ' sfc
    updatesta               ' ass
    updatemana              ' asm
    updatehp                ' ash
    updategold              ' asg
    updatebankgold
    updateexp               ' ase
    changemap               ' cm
    posupdate               ' pu
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
    guildmemberinfo
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
    
    showguildalign
    showpartyform
    updatestrenghtanddexterity
    updatestrenght
    updatedexterity
    addslots
    multimessage
    stopworking
    cancelofferitem
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
    safetoggle              '/seg & seg  (seg's behaviour has to be coded in the client)
    resuscitationsafetoggle
    requestguildleaderinfo  'glinfo
    requestatributes        'atr
    requestfame             'fama
    requestskills           'eski
    requestministats        'fest
    commerceend             'fincom
    usercommerceend         'fincomusu
    usercommerceconfirm
    commercechat
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
    releasepet              '/liberar
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
    guildfundation
    partykick               '/echarparty
    partysetleader          '/partylider
    partyacceptmember       '/acceptparty
    ping                    '/ping
    
    requestpartyform
    itemupgrade
    gmcommands
    initcrafting
    home
    showguildnews
    sharenpc                '/compartirnpc
    stopsharingnpc          '/nocompartirnpc
    consulta
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
            
        case serverpacketid.commercechat
            call handlecommercechat
        
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
            
        case serverpacketid.userofferconfirm
            call handleuserofferconfirm
        
        case serverpacketid.showblacksmithform      ' sfh
            call handleshowblacksmithform
        
        case serverpacketid.showcarpenterform       ' sfc
            call handleshowcarpenterform
        
        case serverpacketid.updatesta               ' ass
            call handleupdatesta
        
        case serverpacketid.updatemana              ' asm
            call handleupdatemana
        
        case serverpacketid.updatehp                ' ash
            call handleupdatehp
        
        case serverpacketid.updategold              ' asg
            call handleupdategold
            
        case serverpacketid.updatebankgold
            call handleupdatebankgold

        case serverpacketid.updateexp               ' ase
            call handleupdateexp
        
        case serverpacketid.changemap               ' cm
            call handlechangemap
        
        case serverpacketid.posupdate               ' pu
            call handleposupdate
        
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
        
        case serverpacketid.guildmemberinfo
            call handleguildmemberinfo
            
        
        
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
            
        case serverpacketid.showguildalign
            call handleshowguildalign
        
        case serverpacketid.showpartyform
            call handleshowpartyform
        
        case serverpacketid.updatestrenghtanddexterity
            call handleupdatestrenghtanddexterity
            
        case serverpacketid.updatestrenght
            call handleupdatestrenght
            
        case serverpacketid.updatedexterity
            call handleupdatedexterity
            
        case serverpacketid.addslots
            call handleaddslots

        case serverpacketid.multimessage
            call handlemultimessage
        
        case serverpacketid.stopworking
            call handlestopworking
            
        case serverpacketid.cancelofferitem
            call handlecancelofferitem
            
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

public sub handlemultimessage()

    dim bodypart as byte
    dim da�o as integer
    
with incomingdata
    call .readbyte
    
    select case .readbyte
        case emessages.dontseeanything
            call addtorichtextbox(frmmain.rectxt, mensaje_no_ves_nada_interesante, 65, 190, 156, false, false, true)
        
        case emessages.npcswing
            call addtorichtextbox(frmmain.rectxt, mensaje_criatura_falla_golpe, 255, 0, 0, true, false, true)
        
        case emessages.npckilluser
            call addtorichtextbox(frmmain.rectxt, mensaje_criatura_matado, 255, 0, 0, true, false, true)
        
        case emessages.blockedwithshielduser
            call addtorichtextbox(frmmain.rectxt, mensaje_rechazo_ataque_escudo, 255, 0, 0, true, false, true)
        
        case emessages.blockedwithshieldother
            call addtorichtextbox(frmmain.rectxt, mensaje_usuario_rechazo_ataque_escudo, 255, 0, 0, true, false, true)
        
        case emessages.userswing
            call addtorichtextbox(frmmain.rectxt, mensaje_fallado_golpe, 255, 0, 0, true, false, true)
        
        case emessages.safemodeon
            call frmmain.controlsm(esmtype.ssafemode, true)
        
        case emessages.safemodeoff
            call frmmain.controlsm(esmtype.ssafemode, false)
        
        case emessages.resuscitationsafeoff
            call frmmain.controlsm(esmtype.sresucitation, false)
         
        case emessages.resuscitationsafeon
            call frmmain.controlsm(esmtype.sresucitation, true)
        
        case emessages.nobilitylost
            call addtorichtextbox(frmmain.rectxt, mensaje_pierde_nobleza, 255, 0, 0, false, false, true)
        
        case emessages.cantusewhilemeditating
            call addtorichtextbox(frmmain.rectxt, mensaje_usar_meditando, 255, 0, 0, false, false, true)
        
        case emessages.npchituser
            select case incomingdata.readbyte()
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_cabeza & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
                
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_izq & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
                
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_der & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
                
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_izq & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
                
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_der & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
                
                case btorso
                    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_torso & cstr(incomingdata.readinteger() & "!!"), 255, 0, 0, true, false, true)
            end select
        
        case emessages.userhitnpc
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_criatura_1 & cstr(incomingdata.readlong()) & mensaje_2, 255, 0, 0, true, false, true)
        
        case emessages.userattackedswing
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & charlist(incomingdata.readinteger()).nombre & mensaje_ataque_fallo, 255, 0, 0, true, false, true)
        
        case emessages.userhittedbyuser
            dim attackername as string
            
            attackername = getrawname(charlist(incomingdata.readinteger()).nombre)
            bodypart = incomingdata.readbyte()
            da�o = incomingdata.readinteger()
            
            select case bodypart
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & attackername & mensaje_recive_impacto_cabeza & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & attackername & mensaje_recive_impacto_brazo_izq & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & attackername & mensaje_recive_impacto_brazo_der & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & attackername & mensaje_recive_impacto_pierna_izq & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & attackername & mensaje_recive_impacto_pierna_der & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case btorso
                    call addtorichtextbox(frmmain.rectxt, mensaje_1 & attackername & mensaje_recive_impacto_torso & da�o & mensaje_2, 255, 0, 0, true, false, true)
            end select
        
        case emessages.userhitteduser

            dim victimname as string
            
            victimname = getrawname(charlist(incomingdata.readinteger()).nombre)
            bodypart = incomingdata.readbyte()
            da�o = incomingdata.readinteger()
            
            select case bodypart
                case bcabeza
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victimname & mensaje_produce_impacto_cabeza & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bbrazoizquierdo
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victimname & mensaje_produce_impacto_brazo_izq & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bbrazoderecho
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victimname & mensaje_produce_impacto_brazo_der & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bpiernaizquierda
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victimname & mensaje_produce_impacto_pierna_izq & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case bpiernaderecha
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victimname & mensaje_produce_impacto_pierna_der & da�o & mensaje_2, 255, 0, 0, true, false, true)
                
                case btorso
                    call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victimname & mensaje_produce_impacto_torso & da�o & mensaje_2, 255, 0, 0, true, false, true)
            end select
        
        case emessages.workrequesttarget
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

        case emessages.havekilleduser
            dim level as long
            call showconsolemsg(mensaje_has_matado_a & charlist(.readinteger).nombre & mensaje_22, 255, 0, 0, true, false)
            level = .readlong
            call showconsolemsg(mensaje_has_ganado_expe_1 & level & mensaje_has_ganado_expe_2, 255, 0, 0, true, false)
            if clientsetup.bkill and clientsetup.bactive then
                if level / 2 > clientsetup.bymurderedlevel then
                    iscapturepending = true
                end if
            end if
        case emessages.userkill
            call showconsolemsg(charlist(.readinteger).nombre & mensaje_te_ha_matado, 255, 0, 0, true, false)
            if clientsetup.bdie and clientsetup.bactive then _
                iscapturepending = true
        case emessages.earnexp
            call showconsolemsg(mensaje_has_ganado_expe_1 & .readlong & mensaje_has_ganado_expe_2, 255, 0, 0, true, false)
        case emessages.gohome
            dim distance as byte
            dim hogar as string
            dim tiempo as integer
            distance = .readbyte
            tiempo = .readinteger
            hogar = .readasciistring
            call showconsolemsg("est�s a " & distance & " mapas de distancia de " & hogar & ", este viaje durar� " & tiempo & " segundos.", 255, 0, 0, true)
            traveling = true
        case emessages.finishhome
            call showconsolemsg(mensaje_hogar, 255, 255, 255)
            traveling = false
        case emessages.cancelgohome
            call showconsolemsg(mensaje_hogar_cancel, 255, 0, 0, true)
            traveling = false
    end select
end with
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
    
    if bshowtutorial then frmtutorial.show
    
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
    
    'stop audio
    call audio.stopwave
    frmmain.isplaying = playloop.plnone
    
    'show connection form
    frmconnect.visible = true
    
    'reset global vars
    userdescansar = false
    userparalizado = false
    pausa = false
    userciego = false
    usermeditar = false
    usernavegando = false
    brain = false
    bfogata = false
    skillpoints = 0
    comerciando = false
    'new
    traveling = false
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
    
    for i = 1 to max_inventory_slots
        call inventario.setitem(i, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "")
    next i
    
#if seguridadalkon then
    call mi(cualmi).inicializar(randomnumber(1, 1000), 10000)
#end if

    call audio.playmidi("2.mid")
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
    
    set invbanco(0) = nothing
    set invbanco(1) = nothing
    
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
    
    ' initialize commerce inventories
    call invcomusu.initialize(directdraw, frmcomerciar.picinvuser, inventario.maxobjs)
    call invcomnpc.initialize(directdraw, frmcomerciar.picinvnpc, max_npc_inventory_slots)

    'fill user inventory
    for i = 1 to max_inventory_slots
        if inventario.objindex(i) <> 0 then
            with inventario
                call invcomusu.setitem(i, .objindex(i), _
                .amount(i), .equipped(i), .grhindex(i), _
                .objtype(i), .maxhit(i), .minhit(i), .maxdef(i), .mindef(i), _
                .valor(i), .itemname(i))
            end with
        end if
    next i
    
    ' fill npc inventory
    for i = 1 to 50
        if npcinventory(i).objindex <> 0 then
            with npcinventory(i)
                call invcomnpc.setitem(i, .objindex, _
                .amount, 0, .grhindex, _
                .objtype, .maxhit, .minhit, .maxdef, .mindef, _
                .valor, .name)
            end with
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
    dim bankgold as long
    
    'remove packet id
    call incomingdata.readbyte
    
        bankgold = incomingdata.readlong
    call invbanco(0).initialize(directdraw, frmbancoobj.picbancoinv, max_bancoinventory_slots)
    call invbanco(1).initialize(directdraw, frmbancoobj.picinv, inventario.maxobjs)
    
    for i = 1 to inventario.maxobjs
        with inventario
            call invbanco(1).setitem(i, .objindex(i), _
                .amount(i), .equipped(i), .grhindex(i), _
                .objtype(i), .maxhit(i), .minhit(i), .maxdef(i), .mindef(i), _
                .valor(i), .itemname(i))
        end with
    next i
    
    for i = 1 to max_bancoinventory_slots
        with userbancoinventory(i)
            call invbanco(0).setitem(i, .objindex, _
                .amount, .equipped, .grhindex, _
                .objtype, .maxhit, .minhit, .maxdef, .mindef, _
                .valor, .name)
        end with
    next i
    
    'set state and show form
    comerciando = true
    
    frmbancoobj.lblusergld.caption = bankgold
    
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
    tradingusername = incomingdata.readasciistring
    
    ' initialize commerce inventories
    call invcomusu.initialize(directdraw, frmcomerciarusu.picinvcomercio, inventario.maxobjs)
    call invoffercomusu(0).initialize(directdraw, frmcomerciarusu.picinvofertaprop, inv_offer_slots)
    call invoffercomusu(1).initialize(directdraw, frmcomerciarusu.picinvofertaotro, inv_offer_slots)
    call invorocomusu(0).initialize(directdraw, frmcomerciarusu.picinvoroprop, inv_gold_slots, , tilepixelwidth * 2, tilepixelheight, tilepixelwidth / 2)
    call invorocomusu(1).initialize(directdraw, frmcomerciarusu.picinvoroofertaprop, inv_gold_slots, , tilepixelwidth * 2, tilepixelheight, tilepixelwidth / 2)
    call invorocomusu(2).initialize(directdraw, frmcomerciarusu.picinvoroofertaotro, inv_gold_slots, , tilepixelwidth * 2, tilepixelheight, tilepixelwidth / 2)

    'fill user inventory
    for i = 1 to max_inventory_slots
        if inventario.objindex(i) <> 0 then
            with inventario
                call invcomusu.setitem(i, .objindex(i), _
                .amount(i), .equipped(i), .grhindex(i), _
                .objtype(i), .maxhit(i), .minhit(i), .maxdef(i), .mindef(i), _
                .valor(i), .itemname(i))
            end with
        end if
    next i

    ' inventarios de oro
    call invorocomusu(0).setitem(1, oro_index, usergld, 0, oro_grh, 0, 0, 0, 0, 0, 0, "oro")
    call invorocomusu(1).setitem(1, oro_index, 0, 0, oro_grh, 0, 0, 0, 0, 0, 0, "oro")
    call invorocomusu(2).setitem(1, oro_index, 0, 0, oro_grh, 0, 0, 0, 0, 0, 0, "oro")


    'set state and show form
    comerciando = true
    call frmcomerciarusu.show(vbmodeless, frmmain)
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
    
    set invcomusu = nothing
    set invorocomusu(0) = nothing
    set invorocomusu(1) = nothing
    set invorocomusu(2) = nothing
    set invoffercomusu(0) = nothing
    set invoffercomusu(1) = nothing
    
    'destroy the form and reset the state
    unload frmcomerciarusu
    comerciando = false
end sub

''
' handles the userofferconfirm message.
private sub handleuserofferconfirm()
'***************************************************
'author: zama
'last modification: 14/12/2009
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    with frmcomerciarusu
        ' now he can accept the offer or reject it
        .habilitaraceptarrechazar true
        
        .printcommercemsg tradingusername & " ha confirmado su oferta!", fonttypenames.fonttype_conse
    end with
    
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_criatura_falla_golpe, 255, 0, 0, true, false, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_criatura_matado, 255, 0, 0, true, false, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_rechazo_ataque_escudo, 255, 0, 0, true, false, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_usuario_rechazo_ataque_escudo, 255, 0, 0, true, false, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_fallado_golpe, 255, 0, 0, true, false, true)
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
    
    call frmmain.controlsm(esmtype.ssafemode, true)
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
    
    call frmmain.controlsm(esmtype.ssafemode, false)
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
    
    call frmmain.controlsm(esmtype.sresucitation, false)
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
    
    call frmmain.controlsm(esmtype.sresucitation, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_pierde_nobleza, 255, 0, 0, false, false, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_usar_meditando, 255, 0, 0, false, false, true)
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
    
    frmmain.lblenergia = userminsta & "/" & usermaxsta
    
    dim bwidth as byte
    
    bwidth = (((userminsta / 100) / (usermaxsta / 100)) * 75)
    
    frmmain.shpenergia.width = 75 - bwidth
    frmmain.shpenergia.left = 584 + (75 - frmmain.shpenergia.width)
    
    frmmain.shpenergia.visible = (bwidth <> 75)
    
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
    
    frmmain.lblmana = userminman & "/" & usermaxman
    
    dim bwidth as byte
    
    if usermaxman > 0 then _
        bwidth = (((userminman / 100) / (usermaxman / 100)) * 75)
        
    frmmain.shpmana.width = 75 - bwidth
    frmmain.shpmana.left = 584 + (75 - frmmain.shpmana.width)
    
    frmmain.shpmana.visible = (bwidth <> 75)
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
    
    frmmain.lblvida = userminhp & "/" & usermaxhp
    
    dim bwidth as byte
    
    bwidth = (((userminhp / 100) / (usermaxhp / 100)) * 75)
    
    frmmain.shpvida.width = 75 - bwidth
    frmmain.shpvida.left = 584 + (75 - frmmain.shpvida.width)
    
    frmmain.shpvida.visible = (bwidth <> 75)
    
    'is the user alive??
    if userminhp = 0 then
        userestado = 1
        if frmmain.trainingmacro then call frmmain.desactivarmacrohechizos
        if frmmain.macrotrabajo then call frmmain.desactivarmacrotrabajo
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
' handles the updatebankgold message.

private sub handleupdatebankgold()
'***************************************************
'autor: zama
'last modification: 14/12/2009
'
'***************************************************
    'check packet is complete
    if incomingdata.length < 5 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    frmbancoobj.lblusergld.caption = incomingdata.readlong
    
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
    frmmain.lblexp.caption = "exp: " & userexp & "/" & userpasarnivel
    frmmain.lblporclvl.caption = "[" & round(cdbl(userexp) * cdbl(100) / cdbl(userpasarnivel), 2) & "%]"
end sub

''
' handles the updatestrenghtanddexterity message.

private sub handleupdatestrenghtanddexterity()
'***************************************************
'author: budi
'last modification: 11/26/09
'***************************************************
    'check packet is complete
    if incomingdata.length < 3 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    userfuerza = incomingdata.readbyte
    useragilidad = incomingdata.readbyte
    frmmain.lblstrg.caption = userfuerza
    frmmain.lbldext.caption = useragilidad
    frmmain.lblstrg.forecolor = getstrenghtcolor()
    frmmain.lbldext.forecolor = getdexteritycolor()
end sub

' handles the updatestrenghtanddexterity message.

private sub handleupdatestrenght()
'***************************************************
'author: budi
'last modification: 11/26/09
'***************************************************
    'check packet is complete
    if incomingdata.length < 2 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    userfuerza = incomingdata.readbyte
    frmmain.lblstrg.caption = userfuerza
    frmmain.lblstrg.forecolor = getstrenghtcolor()
end sub

' handles the updatestrenghtanddexterity message.

private sub handleupdatedexterity()
'***************************************************
'author: budi
'last modification: 11/26/09
'***************************************************
    'check packet is complete
    if incomingdata.length < 2 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    'get data and update form
    useragilidad = incomingdata.readbyte
    frmmain.lbldext.caption = useragilidad
    frmmain.lbldext.forecolor = getdexteritycolor()
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
    frmmain.coord.caption = usermap & " x: " & userpos.x & " y: " & userpos.y
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
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_cabeza & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
        case bbrazoizquierdo
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_izq & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
        case bbrazoderecho
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_brazo_der & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
        case bpiernaizquierda
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_izq & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
        case bpiernaderecha
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_pierna_der & cstr(incomingdata.readinteger()) & "!!", 255, 0, 0, true, false, true)
        case btorso
            call addtorichtextbox(frmmain.rectxt, mensaje_golpe_torso & cstr(incomingdata.readinteger() & "!!"), 255, 0, 0, true, false, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_golpe_criatura_1 & cstr(incomingdata.readlong()) & mensaje_2, 255, 0, 0, true, false, true)
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
    
    call addtorichtextbox(frmmain.rectxt, mensaje_1 & charlist(incomingdata.readinteger()).nombre & mensaje_ataque_fallo, 255, 0, 0, true, false, true)
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
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_cabeza & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bbrazoizquierdo
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_brazo_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bbrazoderecho
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_brazo_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bpiernaizquierda
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_pierna_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bpiernaderecha
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_pierna_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case btorso
            call addtorichtextbox(frmmain.rectxt, mensaje_1 & attacker & mensaje_recive_impacto_torso & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
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
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_cabeza & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bbrazoizquierdo
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_brazo_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bbrazoderecho
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_brazo_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bpiernaizquierda
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_pierna_izq & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case bpiernaderecha
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_pierna_der & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
        case btorso
            call addtorichtextbox(frmmain.rectxt, mensaje_produce_impacto_1 & victim & mensaje_produce_impacto_torso & cstr(incomingdata.readinteger() & mensaje_2), 255, 0, 0, true, false, true)
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
        call dialogos.createdialog(trim$(chat), charindex, rgb(r, g, b))
    
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
        
        ' para no perder el foco cuando chatea por party
        if fontindex = fonttypenames.fonttype_party then
            if mirandoparty then frmparty.sendtxt.setfocus
        end if
    end if
'    call checktext(chat)
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
' handles the consolemessage message.

private sub handlecommercechat()
'***************************************************
'author: zama
'last modification: 03/12/2009
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
            
        call addtorichtextbox(frmcomerciarusu.commerceconsole, left$(chat, instr(1, chat, "~") - 1), r, g, b, val(readfield(5, chat, 126)) <> 0, val(readfield(6, chat, 126)) <> 0)
    else
        with fonttypes(fontindex)
            call addtorichtextbox(frmcomerciarusu.commerceconsole, chat, .red, .green, .blue, .bold, .italic)
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

    frmmain.coord.caption = usermap & " x: " & userpos.x & " y: " & userpos.y
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
    dim nickcolor as byte
    
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
        nickcolor = buffer.readbyte()
        
        if (nickcolor and enickcolor.iecriminal) <> 0 then
            .criminal = 1
        else
            .criminal = 0
        end if
        
        .atacable = (nickcolor and enickcolor.ieatacable) <> 0
        
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
    
    with frmguildadm
        'clear guild's list
        .guildslist.clear
        
        guildnames = split(buffer.readasciistring(), separator)
        
        dim i as long
        for i = 0 to ubound(guildnames())
            call .guildslist.additem(guildnames(i))
        next i
        
        'if we got here then packet is complete, copy data back to original queue
        call incomingdata.copybuffer(buffer)
        
        .show vbmodeless, frmmain
    end with
    
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
    
    frmmain.lblexp.caption = "exp: " & userexp & "/" & userpasarnivel
    
    if userpasarnivel > 0 then
        frmmain.lblporclvl.caption = "[" & round(cdbl(userexp) * cdbl(100) / cdbl(userpasarnivel), 2) & "%]"
    else
        frmmain.lblporclvl.caption = "[n/a]"
    end if
    
    frmmain.gldlbl.caption = usergld
    frmmain.lbllvl.caption = userlvl
    
    'stats
    frmmain.lblmana = userminman & "/" & usermaxman
    frmmain.lblvida = userminhp & "/" & usermaxhp
    frmmain.lblenergia = userminsta & "/" & usermaxsta
    
    dim bwidth as byte
    
    '***************************
    if usermaxman > 0 then _
        bwidth = (((userminman / 100) / (usermaxman / 100)) * 75)
        
    frmmain.shpmana.width = 75 - bwidth
    frmmain.shpmana.left = 584 + (75 - frmmain.shpmana.width)
    
    frmmain.shpmana.visible = (bwidth <> 75)
    '***************************
    
    bwidth = (((userminhp / 100) / (usermaxhp / 100)) * 75)
    
    frmmain.shpvida.width = 75 - bwidth
    frmmain.shpvida.left = 584 + (75 - frmmain.shpvida.width)
    
    frmmain.shpvida.visible = (bwidth <> 75)
    '***************************
    
    bwidth = (((userminsta / 100) / (usermaxsta / 100)) * 75)
    
    frmmain.shpenergia.width = 75 - bwidth
    frmmain.shpenergia.left = 584 + (75 - frmmain.shpenergia.width)
    
    frmmain.shpenergia.visible = (bwidth <> 75)
    '***************************
    
    if userminhp = 0 then
        userestado = 1
        if frmmain.trainingmacro then call frmmain.desactivarmacrohechizos
        if frmmain.macrotrabajo then call frmmain.desactivarmacrotrabajo
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
    dim maxdef as integer
    dim mindef as integer
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
    maxdef = buffer.readinteger()
    mindef = buffer.readinteger
    value = buffer.readsingle()
    
    if equipped then
        select case objtype
            case eobjtype.otweapon
                frmmain.lblweapon = minhit & "/" & maxhit
                userweaponeqpslot = slot
            case eobjtype.otarmadura
                frmmain.lblarmor = mindef & "/" & maxdef
                userarmoureqpslot = slot
            case eobjtype.otescudo
                frmmain.lblshielder = mindef & "/" & maxdef
                userhelmeqpslot = slot
            case eobjtype.otcasco
                frmmain.lblhelm = mindef & "/" & maxdef
                usershieldeqpslot = slot
        end select
    else
        select case slot
            case userweaponeqpslot
                frmmain.lblweapon = "0/0"
                userweaponeqpslot = 0
            case userarmoureqpslot
                frmmain.lblarmor = "0/0"
                userarmoureqpslot = 0
            case userhelmeqpslot
                frmmain.lblshielder = "0/0"
                userhelmeqpslot = 0
            case usershieldeqpslot
                frmmain.lblhelm = "0/0"
                usershieldeqpslot = 0
        end select
    end if
    
    call inventario.setitem(slot, objindex, amount, equipped, grhindex, objtype, maxhit, minhit, maxdef, mindef, value, name)

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

' handles the addslots message.
private sub handleaddslots()
'***************************************************
'author: budi
'last modification: 12/01/09
'
'***************************************************

    call incomingdata.readbyte
    
    maxinventoryslots = incomingdata.readbyte
end sub

' handles the stopworking message.
private sub handlestopworking()
'***************************************************
'author: budi
'last modification: 12/01/09
'
'***************************************************

    call incomingdata.readbyte
    
    with fonttypes(fonttypenames.fonttype_info)
        call showconsolemsg("�has terminado de trabajar!", .red, .green, .blue, .bold, .italic)
    end with
    
    if frmmain.macrotrabajo.enabled then call frmmain.desactivarmacrotrabajo
end sub

' handles the cancelofferitem message.

private sub handlecancelofferitem()
'***************************************************
'author: torres patricio (pato)
'last modification: 05/03/10
'
'***************************************************
    dim slot as byte
    dim amount as long
    
    call incomingdata.readbyte
    
    slot = incomingdata.readbyte
    
    with invoffercomusu(0)
        amount = .amount(slot)
        
        ' no tiene sentido que se quiten 0 unidades
        if amount <> 0 then
            ' actualizo el inventario general
            call frmcomerciarusu.updateinvcom(.objindex(slot), amount)
            
            ' borro el item
            call .setitem(slot, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, "")
        end if
    end with
    
    ' si era el �nico �tem de la oferta, no puede confirmarla
    if not frmcomerciarusu.hasanyitem(invoffercomusu(0)) and _
        not frmcomerciarusu.hasanyitem(invorocomusu(1)) then call frmcomerciarusu.habilitarconfirmar(false)
    
    with fonttypes(fonttypenames.fonttype_info)
        call frmcomerciarusu.printcommercemsg("�no puedes comerciar ese objeto!", fonttypenames.fonttype_info)
    end with
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
        .maxdef = buffer.readinteger()
        .mindef = buffer.readinteger
        .valor = buffer.readlong()
        
        if comerciando then
            call invbanco(0).setitem(slot, .objindex, .amount, _
                .equipped, .grhindex, .objtype, .maxhit, _
                .minhit, .maxdef, .mindef, .valor, .name)
        end if
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
                for i = 1 to numatributes
                    .lblatributos(i).caption = useratributos(i)
                next i
                
                .updatestats
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
    dim j as long
    dim k as long
    
    count = buffer.readinteger()
    
    redim armasherrero(count) as titemsconstruibles
    redim herreromejorar(0) as titemsconstruibles
    
    for i = 1 to count
        with armasherrero(i)
            .name = buffer.readasciistring()    'get the object's name
            .grhindex = buffer.readinteger()
            .linh = buffer.readinteger()        'the iron needed
            .linp = buffer.readinteger()        'the silver needed
            .lino = buffer.readinteger()        'the gold needed
            .objindex = buffer.readinteger()
            .upgrade = buffer.readinteger()
        end with
    next i
    
    with frmherrero
        ' inicializo los inventarios
        call invlingosherreria(1).initialize(directdraw, .piclingotes0, 3, , , , , , false)
        call invlingosherreria(2).initialize(directdraw, .piclingotes1, 3, , , , , , false)
        call invlingosherreria(3).initialize(directdraw, .piclingotes2, 3, , , , , , false)
        call invlingosherreria(4).initialize(directdraw, .piclingotes3, 3, , , , , , false)
        
        call .hideextracontrols(count)
        call .renderlist(1, true)
    end with
    
    for i = 1 to count
        with armasherrero(i)
            if .upgrade then
                for k = 1 to count
                    if .upgrade = armasherrero(k).objindex then
                        j = j + 1
                
                        redim preserve herreromejorar(j) as titemsconstruibles
                        
                        herreromejorar(j).name = .name
                        herreromejorar(j).grhindex = .grhindex
                        herreromejorar(j).objindex = .objindex
                        herreromejorar(j).upgradename = armasherrero(k).name
                        herreromejorar(j).upgradegrhindex = armasherrero(k).grhindex
                        herreromejorar(j).linh = armasherrero(k).linh - .linh * 0.85
                        herreromejorar(j).linp = armasherrero(k).linp - .linp * 0.85
                        herreromejorar(j).lino = armasherrero(k).lino - .lino * 0.85
                        
                        exit for
                    end if
                next k
            end if
        end with
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
    dim j as long
    dim k as long
    
    count = buffer.readinteger()
    
    redim armadurasherrero(count) as titemsconstruibles
    
    for i = 1 to count
        with armadurasherrero(i)
            .name = buffer.readasciistring()    'get the object's name
            .grhindex = buffer.readinteger()
            .linh = buffer.readinteger()        'the iron needed
            .linp = buffer.readinteger()        'the silver needed
            .lino = buffer.readinteger()        'the gold needed
            .objindex = buffer.readinteger()
            .upgrade = buffer.readinteger()
        end with
    next i
    
    j = ubound(herreromejorar)
    
    for i = 1 to count
        with armadurasherrero(i)
            if .upgrade then
                for k = 1 to count
                    if .upgrade = armadurasherrero(k).objindex then
                        j = j + 1
                
                        redim preserve herreromejorar(j) as titemsconstruibles
                        
                        herreromejorar(j).name = .name
                        herreromejorar(j).grhindex = .grhindex
                        herreromejorar(j).objindex = .objindex
                        herreromejorar(j).upgradename = armadurasherrero(k).name
                        herreromejorar(j).upgradegrhindex = armadurasherrero(k).grhindex
                        herreromejorar(j).linh = armadurasherrero(k).linh - .linh * 0.85
                        herreromejorar(j).linp = armadurasherrero(k).linp - .linp * 0.85
                        herreromejorar(j).lino = armadurasherrero(k).lino - .lino * 0.85
                        
                        exit for
                    end if
                next k
            end if
        end with
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
    dim j as long
    dim k as long
    
    count = buffer.readinteger()
    
    redim objcarpintero(count) as titemsconstruibles
    redim carpinteromejorar(0) as titemsconstruibles
    
    for i = 1 to count
        with objcarpintero(i)
            .name = buffer.readasciistring()        'get the object's name
            .grhindex = buffer.readinteger()
            .madera = buffer.readinteger()          'the wood needed
            .maderaelfica = buffer.readinteger()    'the elfic wood needed
            .objindex = buffer.readinteger()
            .upgrade = buffer.readinteger()
        end with
    next i
    
    with frmcarp
        ' inicializo los inventarios
        call invmaderascarpinteria(1).initialize(directdraw, .picmaderas0, 2, , , , , , false)
        call invmaderascarpinteria(2).initialize(directdraw, .picmaderas1, 2, , , , , , false)
        call invmaderascarpinteria(3).initialize(directdraw, .picmaderas2, 2, , , , , , false)
        call invmaderascarpinteria(4).initialize(directdraw, .picmaderas3, 2, , , , , , false)
        
        call .hideextracontrols(count)
        call .renderlist(1)
    end with
    
    for i = 1 to count
        with objcarpintero(i)
            if .upgrade then
                for k = 1 to count
                    if .upgrade = objcarpintero(k).objindex then
                        j = j + 1
                
                        redim preserve carpinteromejorar(j) as titemsconstruibles
                        
                        carpinteromejorar(j).name = .name
                        carpinteromejorar(j).grhindex = .grhindex
                        carpinteromejorar(j).objindex = .objindex
                        carpinteromejorar(j).upgradename = objcarpintero(k).name
                        carpinteromejorar(j).upgradegrhindex = objcarpintero(k).grhindex
                        carpinteromejorar(j).madera = objcarpintero(k).madera - .madera * 0.85
                        carpinteromejorar(j).maderaelfica = objcarpintero(k).maderaelfica - .maderaelfica * 0.85
                        
                        exit for
                    end if
                next k
            end if
        end with
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
    
    if frmconnect.visible then
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
        .maxdef = buffer.readinteger()
        .mindef = buffer.readinteger
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
    frmmain.lblhambre = userminham & "/" & usermaxham
    frmmain.lblsed = userminagu & "/" & usermaxagu

    dim bwidth as byte
    
    bwidth = (((userminham / 100) / (usermaxham / 100)) * 75)
    
    frmmain.shphambre.width = 75 - bwidth
    frmmain.shphambre.left = 584 + (75 - frmmain.shphambre.width)
    
    frmmain.shphambre.visible = (bwidth <> 75)
    '*********************************
    
    bwidth = (((userminagu / 100) / (usermaxagu / 100)) * 75)
    
    frmmain.shpsed.width = 75 - bwidth
    frmmain.shpsed.left = 584 + (75 - frmmain.shpsed.width)
    
    frmmain.shpsed.visible = (bwidth <> 75)
    
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
    
    call frmmain.lightskillstar(true)
end sub

''
' handles the addforummessage message.

private sub handleaddforummessage()
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
    
    dim forumtype as eforummsgtype
    dim title as string
    dim message as string
    dim author as string
    dim banuncio as boolean
    dim bsticky as boolean
    
    forumtype = buffer.readbyte
    
    title = buffer.readasciistring()
    author = buffer.readasciistring()
    message = buffer.readasciistring()
    
    if not frmforo.forolimpio then
        clsforos.clearforums
        frmforo.forolimpio = true
    end if

    call clsforos.addpost(forumalignment(forumtype), title, author, message, esanuncio(forumtype))
    
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
    
    frmforo.privilegios = incomingdata.readbyte
    frmforo.canpoststicky = incomingdata.readbyte
    
    if not mirandoforo then
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
    
    with frmcrearpersonaje
        .lblatributos(eatributos.fuerza) = useratributos(eatributos.fuerza)
        .lblatributos(eatributos.agilidad) = useratributos(eatributos.agilidad)
        .lblatributos(eatributos.inteligencia) = useratributos(eatributos.inteligencia)
        .lblatributos(eatributos.carisma) = useratributos(eatributos.carisma)
        .lblatributos(eatributos.constitucion) = useratributos(eatributos.constitucion)
        
        .updatestats
    end with
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
'last modification: 11/19/09
'11/19/09: pato - now the server send the percentage of progress of the skills.
'***************************************************
    if incomingdata.length < 2 + numskills * 2 then
        err.raise incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    'remove packet id
    call incomingdata.readbyte
    
    userclase = incomingdata.readbyte
    dim i as long
    
    for i = 1 to numskills
        userskills(i) = incomingdata.readbyte()
        porcentajeskills(i) = incomingdata.readbyte()
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
'last modification: 11/19/09
'11/19/09: pato - is optional show the frmguildnews form
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
    dim stemp as string
    
    'get news' string
    frmguildnews.news = buffer.readasciistring()
    
    'get enemy guilds list
    guildlist = split(buffer.readasciistring(), separator)
    
    for i = 0 to ubound(guildlist)
        stemp = frmguildnews.txtclanesguerra.text
        frmguildnews.txtclanesguerra.text = stemp & guildlist(i) & vbcrlf
    next i
    
    'get allied guilds list
    guildlist = split(buffer.readasciistring(), separator)
    
    for i = 0 to ubound(guildlist)
        stemp = frmguildnews.txtclanesaliados.text
        frmguildnews.txtclanesaliados.text = stemp & guildlist(i) & vbcrlf
    next i
    
    if clientsetup.bguildnews then frmguildnews.show vbmodeless, frmmain
    
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
    
    dim vsguildlist() as string
    dim i as long
    
    vsguildlist = split(buffer.readasciistring(), separator)
    
    call frmpeaceprop.lista.clear
    for i = 0 to ubound(vsguildlist())
        call frmpeaceprop.lista.additem(vsguildlist(i))
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
            .imgrechazar.visible = false
            .imgaceptar.visible = false
            .imgechar.visible = true
            .imgpeticion.visible = false
        else
            .imgrechazar.visible = true
            .imgaceptar.visible = true
            .imgechar.visible = false
            .imgpeticion.visible = true
        end if
        
        .nombre.caption = buffer.readasciistring()
        .raza.caption = listarazas(buffer.readbyte())
        .clase.caption = listaclases(buffer.readbyte())
        
        if buffer.readbyte() = 1 then
            .genero.caption = "hombre"
        else
            .genero.caption = "mujer"
        end if
        
        .nivel.caption = buffer.readbyte()
        .oro.caption = buffer.readlong()
        .banco.caption = buffer.readlong()
        
        dim reputation as long
        reputation = buffer.readlong()
        
        .reputacion.caption = reputation
        
        .txtpeticiones.text = buffer.readasciistring()
        .guildactual.caption = buffer.readasciistring()
        .txtmiembro.text = buffer.readasciistring()
        
        dim armada as boolean
        dim caos as boolean
        
        armada = buffer.readboolean()
        caos = buffer.readboolean()
        
        if armada then
            .ejercito.caption = "armada real"
        elseif caos then
            .ejercito.caption = "legi�n oscura"
        end if
        
        .ciudadanos.caption = cstr(buffer.readlong())
        .criminales.caption = cstr(buffer.readlong())
        
        if reputation > 0 then
            .status.caption = " ciudadano"
            .status.forecolor = vbblue
        else
            .status.caption = " criminal"
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
    
    dim i as long
    dim list() as string
    
    with frmguildleader
        'get list of existing guilds
        guildnames = split(buffer.readasciistring(), separator)
        
        'empty the list
        call .guildslist.clear
        
        for i = 0 to ubound(guildnames())
            call .guildslist.additem(guildnames(i))
        next i
        
        'get list of guild's members
        guildmembers = split(buffer.readasciistring(), separator)
        .miembros.caption = cstr(ubound(guildmembers()) + 1)
        
        'empty the list
        call .members.clear
        
        for i = 0 to ubound(guildmembers())
            call .members.additem(guildmembers(i))
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
        .imgdeclararguerra.visible = .esleader
        .imgofreceralianza.visible = .esleader
        .imgofrecerpaz.visible = .esleader
        
        .nombre.caption = buffer.readasciistring()
        .fundador.caption = buffer.readasciistring()
        .creacion.caption = buffer.readasciistring()
        .lider.caption = buffer.readasciistring()
        .web.caption = buffer.readasciistring()
        .miembros.caption = buffer.readinteger()
        
        if buffer.readboolean() then
            .eleccion.caption = "abierta"
        else
            .eleccion.caption = "cerrada"
        end if
        
        .lblalineacion.caption = buffer.readasciistring()
        .enemigos.caption = buffer.readinteger()
        .aliados.caption = buffer.readinteger()
        .antifaccion.caption = buffer.readasciistring()
        
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
' handles the showguildalign message.

private sub handleshowguildalign()
'***************************************************
'author: zama
'last modification: 14/12/2009
'
'***************************************************
    'remove packet id
    call incomingdata.readbyte
    
    frmeligealineacion.show vbmodeless, frmmain
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
        
        'update user inventory
        for i = 1 to max_inventory_slots
            ' agrego o quito un item en su totalidad
            if inventario.objindex(i) <> invcomusu.objindex(i) then
                with inventario
                    call invcomusu.setitem(i, .objindex(i), _
                    .amount(i), .equipped(i), .grhindex(i), _
                    .objtype(i), .maxhit(i), .minhit(i), .maxdef(i), .mindef(i), _
                    .valor(i), .itemname(i))
                end with
            ' vendio o compro cierta cantidad de un item que ya tenia
            elseif inventario.amount(i) <> invcomusu.amount(i) then
                call invcomusu.changeslotitemamount(i, inventario.amount(i))
            end if
        next i
        
        ' fill npc inventory
        for i = 1 to 20
            ' compraron la totalidad de un item, o vendieron un item que el npc no tenia
            if npcinventory(i).objindex <> invcomnpc.objindex(i) then
                with npcinventory(i)
                    call invcomnpc.setitem(i, .objindex, _
                    .amount, 0, .grhindex, _
                    .objtype, .maxhit, .minhit, .maxdef, .mindef, _
                    .valor, .name)
                end with
            ' compraron o vendieron cierta cantidad (no su totalidad)
            elseif npcinventory(i).amount <> invcomnpc.amount(i) then
                call invcomnpc.changeslotitemamount(i, npcinventory(i).amount)
            end if
        next i
    
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
        
        for i = 1 to inventario.maxobjs
            with inventario
                call invbanco(1).setitem(i, .objindex(i), .amount(i), _
                    .equipped(i), .grhindex(i), .objtype(i), .maxhit(i), _
                    .minhit(i), .maxdef(i), .mindef(i), .valor(i), .itemname(i))
            end with
        next i
        
        'alter order according to if we bought or sold so the labels and grh remain the same
        if frmbancoobj.lasactionbuy then
            'frmbancoobj.list1(1).listindex = frmbancoobj.lastindex2
            'frmbancoobj.list1(0).listindex = frmbancoobj.lastindex1
        else
            'frmbancoobj.list1(0).listindex = frmbancoobj.lastindex1
            'frmbancoobj.list1(1).listindex = frmbancoobj.lastindex2
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
    
    dim offerslot as byte
    
    'remove packet id
    call buffer.readbyte
    
    offerslot = buffer.readbyte
    
    with buffer
        if offerslot = gold_offer_slot then
            call invorocomusu(2).setitem(1, .readinteger(), .readlong(), 0, _
                                            .readinteger(), .readbyte(), .readinteger(), _
                                            .readinteger(), .readinteger(), .readinteger(), .readlong(), .readasciistring())
        else
            call invoffercomusu(1).setitem(offerslot, .readinteger(), .readlong(), 0, _
                                            .readinteger(), .readbyte(), .readinteger(), _
                                            .readinteger(), .readinteger(), .readinteger(), .readlong(), .readasciistring())
        end if
    end with
    
    call frmcomerciarusu.printcommercemsg(tradingusername & " ha modificado su oferta.", fonttypenames.fonttype_veneno)
    
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
' handles the showsosform message.

private sub handleshowpartyform()
'***************************************************
'author: budi
'last modification: 11/26/09
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
    
    dim members() as string
    dim i as long
    
    espartyleader = cbool(buffer.readbyte())
       
    members = split(buffer.readasciistring(), separator)
    for i = 0 to ubound(members())
        call frmparty.lstmembers.additem(members(i))
    next i
    
    frmparty.lbltotalexp.caption = buffer.readlong
    frmparty.show , frmmain
    
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
'*************************************su**************
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
    
    call addtorichtextbox(frmmain.rectxt, "el ping es " & (gettickcount - pingtime) & " ms.", 255, 0, 0, true, false, true)
    
    pingtime = 0
end sub

''
' handles the pong message.

private sub handleguildmemberinfo()
'***************************************************
'author: zama
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
    
    with frmguildmember
        'clear guild's list
        .lstclanes.clear
        
        guildnames = split(buffer.readasciistring(), separator)
        
        dim i as long
        for i = 0 to ubound(guildnames())
            call .lstclanes.additem(guildnames(i))
        next i
        
        'get list of guild's members
        guildmembers = split(buffer.readasciistring(), separator)
        .lblcantmiembros.caption = cstr(ubound(guildmembers()) + 1)
        
        'empty the list
        call .lstmiembros.clear
        
        for i = 0 to ubound(guildmembers())
            call .lstmiembros.additem(guildmembers(i))
        next i
        
        'if we got here then packet is complete, copy data back to original queue
        call incomingdata.copybuffer(buffer)
        
        .show vbmodeless, frmmain
    end with
    
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
    dim nickcolor as byte
    dim usertag as string
    
    charindex = buffer.readinteger()
    nickcolor = buffer.readbyte()
    usertag = buffer.readasciistring()
    
    'update char status adn tag!
    with charlist(charindex)
        if (nickcolor and enickcolor.iecriminal) <> 0 then
            .criminal = 1
        else
            .criminal = 0
        end if
        
        .atacable = (nickcolor and enickcolor.ieatacable) <> 0
        
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
        
#if seguridadalkon then
        call .writeasciistringfixed(md5hushyo)
#end if
        
        call .writebyte(userraza)
        call .writebyte(usersexo)
        call .writebyte(userclase)
        call .writeinteger(userhead)
        
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

public sub writerequestpartyform()
'***************************************************
'author: budi
'last modification: 11/26/09
'writes the "requestpartyform" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.requestpartyform)

end sub

''
' writes the "itemupgrade" message to the outgoing data buffer.
'
' @param    itemindex the index to the item to upgrade.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeitemupgrade(byval itemindex as integer)
'***************************************************
'author: torres patricio (pato)
'last modification: 12/09/09
'writes the "itemupgrade" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.itemupgrade)
    call outgoingdata.writeinteger(itemindex)
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
' writes the "usercommerceconfirm" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercommerceconfirm()
'***************************************************
'author: zama
'last modification: 14/12/2009
'writes the "usercommerceconfirm" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.usercommerceconfirm)
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
' writes the "showguildnews" message to the outgoing data buffer.
'

public sub writeshowguildnews()
'***************************************************
'author: zama
'last modification: 21/02/2010
'writes the "showguildnews" message to the outgoing data buffer
'***************************************************
 
     outgoingdata.writebyte (clientpacketid.showguildnews)
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

public sub writeforumpost(byval title as string, byval message as string, byval forummsgtype as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "forumpost" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.forumpost)
        
        call .writebyte(forummsgtype)
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

public sub writeusercommerceoffer(byval slot as byte, byval amount as long, byval offerslot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "usercommerceoffer" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.usercommerceoffer)
        
        call .writebyte(slot)
        call .writelong(amount)
        call .writebyte(offerslot)
    end with
end sub

public sub writecommercechat(byval chat as string)
'***************************************************
'author: zama
'last modification: 03/12/2009
'writes the "commercechat" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.commercechat)
        
        call .writeasciistring(chat)
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
' writes the "releasepet" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writereleasepet()
'***************************************************
'author: zama
'last modification: 18/11/2009
'writes the "releasepet" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.releasepet)
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
' writes the "consulta" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeconsulta()
'***************************************************
'author: zama
'last modification: 01/05/2010
'writes the "consulta" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.consulta)

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
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildfundate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 03/21/2001
'writes the "guildfundate" message to the outgoing data buffer
'14/12/2009: zama - now first checks if the user can foundate a guild.
'03/21/2001: pato - deleted de clantype param.
'***************************************************
    call outgoingdata.writebyte(clientpacketid.guildfundate)
end sub

''
' writes the "guildfundation" message to the outgoing data buffer.
'
' @param    clantype the alignment of the clan to be founded.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildfundation(byval clantype as eclantype)
'***************************************************
'author: zama
'last modification: 14/12/2009
'writes the "guildfundation" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.guildfundation)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.guildmemberlist)
        
        call .writeasciistring(guild)
    end with
end sub

''
' writes the "initcrafting" message to the outgoing data buffer.
'
' @param    cantidad the final aumont of item to craft.
' @param    nroporciclo the amount of items to craft per cicle.

public sub writeinitcrafting(byval cantidad as long, byval nroporciclo as integer)
'***************************************************
'author: zama
'last modification: 29/01/2010
'writes the "initcrafting" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.initcrafting)
        call .writelong(cantidad)
        
        call .writeinteger(nroporciclo)
    end with
end sub

''
' writes the "home" message to the outgoing data buffer.
'
public sub writehome()
'***************************************************
'author: budi
'last modification: 01/06/10
'writes the "home" message to the outgoing data buffer
'***************************************************
    with outgoingdata
        call .writebyte(clientpacketid.home)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.gmmessage)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.showname)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.onlineroyalarmy)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.onlinechaoslegion)
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
        call outgoingdata.writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.gonearby)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.comment)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.servertime)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.where)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.creaturesinmap)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.warpmetotarget)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.warpchar)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.silence)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.sosshowlist)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.sosremove)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.gotochar)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.invisible)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.gmpanel)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.requestuserlist)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.working)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.hiding)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.jail)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.killnpc)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.warnuser)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.editchar)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.requestcharinfo)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.requestcharstats)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.requestchargold)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.requestcharinventory)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.requestcharbank)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.requestcharskills)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.revivechar)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.onlinegm)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.onlinemap)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.forgive)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.kick)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.execute)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.banchar)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.unbanchar)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.npcfollow)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.summonchar)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.spawnlistrequest)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.spawncreature)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.resetnpcinventory)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.cleanworld)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.servermessage)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.nicktoip)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.iptonick)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.guildonlinemembers)
        
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

public sub writeteleportcreate(byval map as integer, byval x as byte, byval y as byte, optional byval radio as byte = 0)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "teleportcreate" message to the outgoing data buffer
'***************************************************
    with outgoingdata
            call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.teleportcreate)
        
        call .writeinteger(map)
        
        call .writebyte(x)
        call .writebyte(y)
        
        call .writebyte(radio)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.teleportdestroy)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.raintoggle)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.setchardescription)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.forcemiditomap)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.forcewavetomap)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.royalarmymessage)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.chaoslegionmessage)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.citizenmessage)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.criminalmessage)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.talkasnpc)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.destroyallitemsinarea)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.acceptroyalcouncilmember)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.acceptchaoscouncilmember)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.itemsinthefloor)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.makedumb)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.makedumbnomore)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.dumpiptables)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.councilkick)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.settrigger)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.asktrigger)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.bannediplist)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.bannedipreload)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.guildban)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.banip)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.unbanip)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.createitem)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.destroyitems)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.chaoslegionkick)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.royalarmykick)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.forcemidiall)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.forcewaveall)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.removepunishment)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.tileblockedtoggle)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.killnpcnorespawn)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.killallnearbynpcs)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.lastip)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.changemotd)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.setmotd)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.systemmessage)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.createnpc)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.createnpcwithrespawn)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.imperialarmour)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.chaosarmour)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.navigatetoggle)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.serveropentouserstoggle)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.turnoffserver)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.turncriminal)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.resetfactions)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.removecharfromguild)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.requestcharmail)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.alterpassword)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.altermail)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.altername)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.togglecentinelactivated)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.dobackup)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.showguildmessages)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.savemap)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinfopk)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinfobackup)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinforestricted)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinfonomagic)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinfonoinvi)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinfonoresu)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinfoland)
        
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.changemapinfozone)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.savechars)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.cleansos)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.showserverform)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.night)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.kickallchars)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.reloadnpcs)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.reloadserverini)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.reloadspells)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.reloadobjects)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.restart)
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.resetautoupdate)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.chatcolor)
        
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
    call outgoingdata.writebyte(clientpacketid.gmcommands)
    call outgoingdata.writebyte(egmcommands.ignored)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.checkslot)
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
' writes the "sharenpc" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesharenpc()
'***************************************************
'author: zama
'last modification: 15/04/2010
'writes the "sharenpc" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.sharenpc)
end sub

''
' writes the "stopsharingnpc" message to the outgoing data buffer.
'
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writestopsharingnpc()
'***************************************************
'author: zama
'last modification: 15/04/2010
'writes the "stopsharingnpc" message to the outgoing data buffer
'***************************************************
    call outgoingdata.writebyte(clientpacketid.stopsharingnpc)
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
        call .writebyte(clientpacketid.gmcommands)
        call .writebyte(egmcommands.setinivar)
        
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
