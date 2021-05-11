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
' @author juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version 1.0.0
' @date 20060517

option explicit

''
'when we have a list of strings, we use this to separate them and prevent
'having too many string lengths in the queue. yes, each string is null-terminated :p
private const separator as string * 1 = vbnullchar

''
'auxiliar bytequeue used as buffer to generate messages not intended to be sent right away.
'specially usefull to create a message once and send it over to several clients.
private auxiliarbuffer as new clsbytequeue


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
    sharenpc                '/compartir
    stopsharingnpc
    consultation
end enum

''
'the last existing client packet id.
private const last_client_packet_id as byte = 128

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
end enum



''
' handles incoming data.
'
' @param    userindex the index of the user sending the message.

public sub handleincomingdata(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/09/07
'
'***************************************************
on error resume next
    dim packetid as byte
    
    packetid = userlist(userindex).incomingdata.peekbyte()
    
    'does the packet requires a logged user??
    if not (packetid = clientpacketid.throwdices _
      or packetid = clientpacketid.loginexistingchar _
      or packetid = clientpacketid.loginnewchar) then
        
        'is the user actually logged?
        if not userlist(userindex).flags.userlogged then
            call closesocket(userindex)
            exit sub
        
        'he is logged. reset idle counter if id is valid.
        elseif packetid <= last_client_packet_id then
            userlist(userindex).counters.idlecount = 0
        end if
    elseif packetid <= last_client_packet_id then
        userlist(userindex).counters.idlecount = 0
        
        'is the user logged?
        if userlist(userindex).flags.userlogged then
            call closesocket(userindex)
            exit sub
        end if
    end if
    
    ' ante cualquier paquete, pierde la proteccion de ser atacado.
    userlist(userindex).flags.nopuedeseratacado = false
    
    select case packetid
        case clientpacketid.loginexistingchar       'ologin
            call handleloginexistingchar(userindex)
        
        case clientpacketid.throwdices              'tirdad
            call handlethrowdices(userindex)
        
        case clientpacketid.loginnewchar            'nlogin
            call handleloginnewchar(userindex)
        
        case clientpacketid.talk                    ';
            call handletalk(userindex)
        
        case clientpacketid.yell                    '-
            call handleyell(userindex)
        
        case clientpacketid.whisper                 '\
            call handlewhisper(userindex)
        
        case clientpacketid.walk                    'm
            call handlewalk(userindex)
        
        case clientpacketid.requestpositionupdate   'rpu
            call handlerequestpositionupdate(userindex)
        
        case clientpacketid.attack                  'at
            call handleattack(userindex)
        
        case clientpacketid.pickup                  'ag
            call handlepickup(userindex)
        
        case clientpacketid.safetoggle              '/seg & seg  (seg's behaviour has to be coded in the client)
            call handlesafetoggle(userindex)
        
        case clientpacketid.resuscitationsafetoggle
            call handleresuscitationtoggle(userindex)
        
        case clientpacketid.requestguildleaderinfo  'glinfo
            call handlerequestguildleaderinfo(userindex)
        
        case clientpacketid.requestatributes        'atr
            call handlerequestatributes(userindex)
        
        case clientpacketid.requestfame             'fama
            call handlerequestfame(userindex)
        
        case clientpacketid.requestskills           'eski
            call handlerequestskills(userindex)
        
        case clientpacketid.requestministats        'fest
            call handlerequestministats(userindex)
        
        case clientpacketid.commerceend             'fincom
            call handlecommerceend(userindex)
            
        case clientpacketid.commercechat
            call handlecommercechat(userindex)
        
        case clientpacketid.usercommerceend         'fincomusu
            call handleusercommerceend(userindex)
            
        case clientpacketid.usercommerceconfirm
            call handleusercommerceconfirm(userindex)
        
        case clientpacketid.bankend                 'finban
            call handlebankend(userindex)
        
        case clientpacketid.usercommerceok          'comusuok
            call handleusercommerceok(userindex)
        
        case clientpacketid.usercommercereject      'comusuno
            call handleusercommercereject(userindex)
        
        case clientpacketid.drop                    'ti
            call handledrop(userindex)
        
        case clientpacketid.castspell               'lh
            call handlecastspell(userindex)
        
        case clientpacketid.leftclick               'lc
            call handleleftclick(userindex)
        
        case clientpacketid.doubleclick             'rc
            call handledoubleclick(userindex)
        
        case clientpacketid.work                    'uk
            call handlework(userindex)
        
        case clientpacketid.usespellmacro           'umh
            call handleusespellmacro(userindex)
        
        case clientpacketid.useitem                 'usa
            call handleuseitem(userindex)
        
        case clientpacketid.craftblacksmith         'cns
            call handlecraftblacksmith(userindex)
        
        case clientpacketid.craftcarpenter          'cnc
            call handlecraftcarpenter(userindex)
        
        case clientpacketid.workleftclick           'wlc
            call handleworkleftclick(userindex)
        
        case clientpacketid.createnewguild          'cig
            call handlecreatenewguild(userindex)
        
        case clientpacketid.spellinfo               'infs
            call handlespellinfo(userindex)
        
        case clientpacketid.equipitem               'equi
            call handleequipitem(userindex)
        
        case clientpacketid.changeheading           'chea
            call handlechangeheading(userindex)
        
        case clientpacketid.modifyskills            'skse
            call handlemodifyskills(userindex)
        
        case clientpacketid.train                   'entr
            call handletrain(userindex)
        
        case clientpacketid.commercebuy             'comp
            call handlecommercebuy(userindex)
        
        case clientpacketid.bankextractitem         'reti
            call handlebankextractitem(userindex)
        
        case clientpacketid.commercesell            'vend
            call handlecommercesell(userindex)
        
        case clientpacketid.bankdeposit             'depo
            call handlebankdeposit(userindex)
        
        case clientpacketid.forumpost               'demsg
            call handleforumpost(userindex)
        
        case clientpacketid.movespell               'desphe
            call handlemovespell(userindex)
            
        case clientpacketid.movebank
            call handlemovebank(userindex)
        
        case clientpacketid.clancodexupdate         'descod
            call handleclancodexupdate(userindex)
        
        case clientpacketid.usercommerceoffer       'ofrecer
            call handleusercommerceoffer(userindex)
        
        case clientpacketid.guildacceptpeace        'aceppeat
            call handleguildacceptpeace(userindex)
        
        case clientpacketid.guildrejectalliance     'recpalia
            call handleguildrejectalliance(userindex)
        
        case clientpacketid.guildrejectpeace        'recppeat
            call handleguildrejectpeace(userindex)
        
        case clientpacketid.guildacceptalliance     'acepalia
            call handleguildacceptalliance(userindex)
        
        case clientpacketid.guildofferpeace         'peaceoff
            call handleguildofferpeace(userindex)
        
        case clientpacketid.guildofferalliance      'allieoff
            call handleguildofferalliance(userindex)
        
        case clientpacketid.guildalliancedetails    'alliedet
            call handleguildalliancedetails(userindex)
        
        case clientpacketid.guildpeacedetails       'peacedet
            call handleguildpeacedetails(userindex)
        
        case clientpacketid.guildrequestjoinerinfo  'envcomen
            call handleguildrequestjoinerinfo(userindex)
        
        case clientpacketid.guildallianceproplist   'envalpro
            call handleguildallianceproplist(userindex)
        
        case clientpacketid.guildpeaceproplist      'envpropp
            call handleguildpeaceproplist(userindex)
        
        case clientpacketid.guilddeclarewar         'decguerr
            call handleguilddeclarewar(userindex)
        
        case clientpacketid.guildnewwebsite         'newwebsi
            call handleguildnewwebsite(userindex)
        
        case clientpacketid.guildacceptnewmember    'aceptari
            call handleguildacceptnewmember(userindex)
        
        case clientpacketid.guildrejectnewmember    'rechazar
            call handleguildrejectnewmember(userindex)
        
        case clientpacketid.guildkickmember         'echarcla
            call handleguildkickmember(userindex)
        
        case clientpacketid.guildupdatenews         'actgnews
            call handleguildupdatenews(userindex)
        
        case clientpacketid.guildmemberinfo         '1hrinfo<
            call handleguildmemberinfo(userindex)
        
        case clientpacketid.guildopenelections      'abreelec
            call handleguildopenelections(userindex)
        
        case clientpacketid.guildrequestmembership  'solicitud
            call handleguildrequestmembership(userindex)
        
        case clientpacketid.guildrequestdetails     'clandetails
            call handleguildrequestdetails(userindex)
                  
        case clientpacketid.online                  '/online
            call handleonline(userindex)
        
        case clientpacketid.quit                    '/salir
            call handlequit(userindex)
        
        case clientpacketid.guildleave              '/salirclan
            call handleguildleave(userindex)
        
        case clientpacketid.requestaccountstate     '/balance
            call handlerequestaccountstate(userindex)
        
        case clientpacketid.petstand                '/quieto
            call handlepetstand(userindex)
        
        case clientpacketid.petfollow               '/acompa�ar
            call handlepetfollow(userindex)
            
        case clientpacketid.releasepet              '/liberar
            call handlereleasepet(userindex)
        
        case clientpacketid.trainlist               '/entrenar
            call handletrainlist(userindex)
        
        case clientpacketid.rest                    '/descansar
            call handlerest(userindex)
        
        case clientpacketid.meditate                '/meditar
            call handlemeditate(userindex)
        
        case clientpacketid.resucitate              '/resucitar
            call handleresucitate(userindex)
        
        case clientpacketid.heal                    '/curar
            call handleheal(userindex)
        
        case clientpacketid.help                    '/ayuda
            call handlehelp(userindex)
        
        case clientpacketid.requeststats            '/est
            call handlerequeststats(userindex)
        
        case clientpacketid.commercestart           '/comerciar
            call handlecommercestart(userindex)
        
        case clientpacketid.bankstart               '/boveda
            call handlebankstart(userindex)
        
        case clientpacketid.enlist                  '/enlistar
            call handleenlist(userindex)
        
        case clientpacketid.information             '/informacion
            call handleinformation(userindex)
        
        case clientpacketid.reward                  '/recompensa
            call handlereward(userindex)
        
        case clientpacketid.requestmotd             '/motd
            call handlerequestmotd(userindex)
        
        case clientpacketid.uptime                  '/uptime
            call handleuptime(userindex)
        
        case clientpacketid.partyleave              '/salirparty
            call handlepartyleave(userindex)
        
        case clientpacketid.partycreate             '/crearparty
            call handlepartycreate(userindex)
        
        case clientpacketid.partyjoin               '/party
            call handlepartyjoin(userindex)
        
        case clientpacketid.inquiry                 '/encuesta ( with no params )
            call handleinquiry(userindex)
        
        case clientpacketid.guildmessage            '/cmsg
            call handleguildmessage(userindex)
        
        case clientpacketid.partymessage            '/pmsg
            call handlepartymessage(userindex)
        
        case clientpacketid.centinelreport          '/centinela
            call handlecentinelreport(userindex)
        
        case clientpacketid.guildonline             '/onlineclan
            call handleguildonline(userindex)
        
        case clientpacketid.partyonline             '/onlineparty
            call handlepartyonline(userindex)
        
        case clientpacketid.councilmessage          '/bmsg
            call handlecouncilmessage(userindex)
        
        case clientpacketid.rolemasterrequest       '/rol
            call handlerolemasterrequest(userindex)
        
        case clientpacketid.gmrequest               '/gm
            call handlegmrequest(userindex)
        
        case clientpacketid.bugreport               '/_bug
            call handlebugreport(userindex)
        
        case clientpacketid.changedescription       '/desc
            call handlechangedescription(userindex)
        
        case clientpacketid.guildvote               '/voto
            call handleguildvote(userindex)
        
        case clientpacketid.punishments             '/penas
            call handlepunishments(userindex)
        
        case clientpacketid.changepassword          '/contrase�a
            call handlechangepassword(userindex)
        
        case clientpacketid.gamble                  '/apostar
            call handlegamble(userindex)
        
        case clientpacketid.inquiryvote             '/encuesta ( with parameters )
            call handleinquiryvote(userindex)
        
        case clientpacketid.leavefaction            '/retirar ( with no arguments )
            call handleleavefaction(userindex)
        
        case clientpacketid.bankextractgold         '/retirar ( with arguments )
            call handlebankextractgold(userindex)
        
        case clientpacketid.bankdepositgold         '/depositar
            call handlebankdepositgold(userindex)
        
        case clientpacketid.denounce                '/denunciar
            call handledenounce(userindex)
        
        case clientpacketid.guildfundate            '/fundarclan
            call handleguildfundate(userindex)
            
        case clientpacketid.guildfundation
            call handleguildfundation(userindex)
        
        case clientpacketid.partykick               '/echarparty
            call handlepartykick(userindex)
        
        case clientpacketid.partysetleader          '/partylider
            call handlepartysetleader(userindex)
        
        case clientpacketid.partyacceptmember       '/acceptparty
            call handlepartyacceptmember(userindex)
        
        case clientpacketid.ping                    '/ping
            call handleping(userindex)
            
        case clientpacketid.requestpartyform
            call handlepartyform(userindex)
            
        case clientpacketid.itemupgrade
            call handleitemupgrade(userindex)
        
        case clientpacketid.gmcommands              'gm messages
            call handlegmcommands(userindex)
            
        case clientpacketid.initcrafting
            call handleinitcrafting(userindex)
        
        case clientpacketid.home
            call handlehome(userindex)
        
        case clientpacketid.showguildnews
            call handleshowguildnews(userindex)
            
        case clientpacketid.sharenpc
            call handlesharenpc(userindex)
            
        case clientpacketid.stopsharingnpc
            call handlestopsharingnpc(userindex)
            
        case clientpacketid.consultation
            call handleconsultation(userindex)
        
#if seguridadalkon then
        case else
            call handleincomingdataex(userindex)
#else
        case else
            'error : abort!
            call closesocket(userindex)
#end if
    end select
    
    'done with this packet, move on to next one or send everything if no more packets found
    if userlist(userindex).incomingdata.length > 0 and err.number = 0 then
        err.clear
        call handleincomingdata(userindex)
    
    elseif err.number <> 0 and not err.number = userlist(userindex).incomingdata.notenoughdataerrcode then
        'an error ocurred, log it and kick player.
        call logerror("error: " & err.number & " [" & err.description & "] " & " source: " & err.source & _
                        vbtab & " helpfile: " & err.helpfile & vbtab & " helpcontext: " & err.helpcontext & _
                        vbtab & " lastdllerror: " & err.lastdllerror & vbtab & _
                        " - userindex: " & userindex & " - producido al manejar el paquete: " & cstr(packetid))
        call closesocket(userindex)
    
    else
        'flush buffer - send everything that has been written
        call flushbuffer(userindex)
    end if
end sub

public sub writemultimessage(byval userindex as integer, byval messageindex as integer, optional byval arg1 as long, optional byval arg2 as long, optional byval arg3 as long, optional byval stringarg1 as string)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.multimessage)
        call .writebyte(messageindex)
        
        select case messageindex
            case emessages.dontseeanything, emessages.npcswing, emessages.npckilluser, emessages.blockedwithshielduser, _
                emessages.blockedwithshieldother, emessages.userswing, emessages.safemodeon, emessages.safemodeoff, _
                emessages.resuscitationsafeoff, emessages.resuscitationsafeon, emessages.nobilitylost, _
                emessages.cantusewhilemeditating, emessages.cancelhome, emessages.finishhome
            
            case emessages.npchituser
                call .writebyte(arg1) 'target
                call .writeinteger(arg2) 'damage
                
            case emessages.userhitnpc
                call .writelong(arg1) 'damage
                
            case emessages.userattackedswing
                call .writeinteger(userlist(arg1).char.charindex)
                
            case emessages.userhittedbyuser
                call .writeinteger(arg1) 'attackerindex
                call .writebyte(arg2) 'target
                call .writeinteger(arg3) 'damage
                
            case emessages.userhitteduser
                call .writeinteger(arg1) 'attackerindex
                call .writebyte(arg2) 'target
                call .writeinteger(arg3) 'damage
                
            case emessages.workrequesttarget
                call .writebyte(arg1) 'skill
            
            case emessages.havekilleduser '"has matado a " & userlist(victimindex).name & "!" "has ganado " & daexp & " puntos de experiencia."
                call .writeinteger(userlist(arg1).char.charindex) 'victimindex
                call .writelong(arg2) 'expe
            
            case emessages.userkill '"�" & .name & " te ha matado!"
                call .writeinteger(userlist(arg1).char.charindex) 'attackerindex
            
            case emessages.earnexp
            
            case emessages.home
                call .writebyte(cbyte(arg1))
                call .writeinteger(cint(arg2))
                'el cliente no conoce nada sobre nombre de mapas y hogares, por lo tanto _
                 hasta que no se pasen los dats e .infs al cliente, esto queda as�.
                call .writeasciistring(stringarg1) 'call .writebyte(cbyte(arg2))
                
        end select
    end with
exit sub ''

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

private sub handlegmcommands(byval userindex as integer)
'***************************************************
'author: unknown
'last modification: -
'
'***************************************************

on error goto errhandler

dim command as byte

with userlist(userindex)
    call .incomingdata.readbyte
    
    command = .incomingdata.peekbyte
    
    select case command
        case egmcommands.gmmessage                '/gmsg
            call handlegmmessage(userindex)
        
        case egmcommands.showname                '/showname
            call handleshowname(userindex)
        
        case egmcommands.onlineroyalarmy
            call handleonlineroyalarmy(userindex)
        
        case egmcommands.onlinechaoslegion       '/onlinecaos
            call handleonlinechaoslegion(userindex)
        
        case egmcommands.gonearby                '/ircerca
            call handlegonearby(userindex)
        
        case egmcommands.comment                 '/rem
            call handlecomment(userindex)
        
        case egmcommands.servertime              '/hora
            call handleservertime(userindex)
        
        case egmcommands.where                   '/donde
            call handlewhere(userindex)
        
        case egmcommands.creaturesinmap          '/nene
            call handlecreaturesinmap(userindex)
        
        case egmcommands.warpmetotarget          '/teleploc
            call handlewarpmetotarget(userindex)
        
        case egmcommands.warpchar                '/telep
            call handlewarpchar(userindex)
        
        case egmcommands.silence                 '/silenciar
            call handlesilence(userindex)
        
        case egmcommands.sosshowlist             '/show sos
            call handlesosshowlist(userindex)
        
        case egmcommands.sosremove               'sosdone
            call handlesosremove(userindex)
        
        case egmcommands.gotochar                '/ira
            call handlegotochar(userindex)
        
        case egmcommands.invisible               '/invisible
            call handleinvisible(userindex)
        
        case egmcommands.gmpanel                 '/panelgm
            call handlegmpanel(userindex)
        
        case egmcommands.requestuserlist         'listusu
            call handlerequestuserlist(userindex)
        
        case egmcommands.working                 '/trabajando
            call handleworking(userindex)
        
        case egmcommands.hiding                  '/ocultando
            call handlehiding(userindex)
        
        case egmcommands.jail                    '/carcel
            call handlejail(userindex)
        
        case egmcommands.killnpc                 '/rmata
            call handlekillnpc(userindex)
        
        case egmcommands.warnuser                '/advertencia
            call handlewarnuser(userindex)
        
        case egmcommands.editchar                '/mod
            call handleeditchar(userindex)
        
        case egmcommands.requestcharinfo         '/info
            call handlerequestcharinfo(userindex)
        
        case egmcommands.requestcharstats        '/stat
            call handlerequestcharstats(userindex)
        
        case egmcommands.requestchargold         '/bal
            call handlerequestchargold(userindex)
        
        case egmcommands.requestcharinventory    '/inv
            call handlerequestcharinventory(userindex)
        
        case egmcommands.requestcharbank         '/bov
            call handlerequestcharbank(userindex)
        
        case egmcommands.requestcharskills       '/skills
            call handlerequestcharskills(userindex)
        
        case egmcommands.revivechar              '/revivir
            call handlerevivechar(userindex)
        
        case egmcommands.onlinegm                '/onlinegm
            call handleonlinegm(userindex)
        
        case egmcommands.onlinemap               '/onlinemap
            call handleonlinemap(userindex)
        
        case egmcommands.forgive                 '/perdon
            call handleforgive(userindex)
        
        case egmcommands.kick                    '/echar
            call handlekick(userindex)
        
        case egmcommands.execute                 '/ejecutar
            call handleexecute(userindex)
        
        case egmcommands.banchar                 '/ban
            call handlebanchar(userindex)
        
        case egmcommands.unbanchar               '/unban
            call handleunbanchar(userindex)
        
        case egmcommands.npcfollow               '/seguir
            call handlenpcfollow(userindex)
        
        case egmcommands.summonchar              '/sum
            call handlesummonchar(userindex)
        
        case egmcommands.spawnlistrequest        '/cc
            call handlespawnlistrequest(userindex)
        
        case egmcommands.spawncreature           'spa
            call handlespawncreature(userindex)
        
        case egmcommands.resetnpcinventory       '/resetinv
            call handleresetnpcinventory(userindex)
        
        case egmcommands.cleanworld              '/limpiar
            call handlecleanworld(userindex)
        
        case egmcommands.servermessage           '/rmsg
            call handleservermessage(userindex)
        
        case egmcommands.nicktoip                '/nick2ip
            call handlenicktoip(userindex)
        
        case egmcommands.iptonick                '/ip2nick
            call handleiptonick(userindex)
        
        case egmcommands.guildonlinemembers      '/onclan
            call handleguildonlinemembers(userindex)
        
        case egmcommands.teleportcreate          '/ct
            call handleteleportcreate(userindex)
        
        case egmcommands.teleportdestroy         '/dt
            call handleteleportdestroy(userindex)
        
        case egmcommands.raintoggle              '/lluvia
            call handleraintoggle(userindex)
        
        case egmcommands.setchardescription      '/setdesc
            call handlesetchardescription(userindex)
        
        case egmcommands.forcemiditomap          '/forcemidimap
            call hanldeforcemiditomap(userindex)
        
        case egmcommands.forcewavetomap          '/forcewavmap
            call handleforcewavetomap(userindex)
        
        case egmcommands.royalarmymessage        '/realmsg
            call handleroyalarmymessage(userindex)
        
        case egmcommands.chaoslegionmessage      '/caosmsg
            call handlechaoslegionmessage(userindex)
        
        case egmcommands.citizenmessage          '/ciumsg
            call handlecitizenmessage(userindex)
        
        case egmcommands.criminalmessage         '/crimsg
            call handlecriminalmessage(userindex)
        
        case egmcommands.talkasnpc               '/talkas
            call handletalkasnpc(userindex)
        
        case egmcommands.destroyallitemsinarea   '/massdest
            call handledestroyallitemsinarea(userindex)
        
        case egmcommands.acceptroyalcouncilmember '/aceptconse
            call handleacceptroyalcouncilmember(userindex)
        
        case egmcommands.acceptchaoscouncilmember '/aceptconsecaos
            call handleacceptchaoscouncilmember(userindex)
        
        case egmcommands.itemsinthefloor         '/piso
            call handleitemsinthefloor(userindex)
        
        case egmcommands.makedumb                '/estupido
            call handlemakedumb(userindex)
        
        case egmcommands.makedumbnomore          '/noestupido
            call handlemakedumbnomore(userindex)
        
        case egmcommands.dumpiptables            '/dumpsecurity
            call handledumpiptables(userindex)
        
        case egmcommands.councilkick             '/kickconse
            call handlecouncilkick(userindex)
        
        case egmcommands.settrigger              '/trigger
            call handlesettrigger(userindex)
        
        case egmcommands.asktrigger              '/trigger with no args
            call handleasktrigger(userindex)
        
        case egmcommands.bannediplist            '/baniplist
            call handlebannediplist(userindex)
        
        case egmcommands.bannedipreload          '/banipreload
            call handlebannedipreload(userindex)
        
        case egmcommands.guildmemberlist         '/miembrosclan
            call handleguildmemberlist(userindex)
        
        case egmcommands.guildban                '/banclan
            call handleguildban(userindex)
        
        case egmcommands.banip                   '/banip
            call handlebanip(userindex)
        
        case egmcommands.unbanip                 '/unbanip
            call handleunbanip(userindex)
        
        case egmcommands.createitem              '/ci
            call handlecreateitem(userindex)
        
        case egmcommands.destroyitems            '/dest
            call handledestroyitems(userindex)
        
        case egmcommands.chaoslegionkick         '/nocaos
            call handlechaoslegionkick(userindex)
        
        case egmcommands.royalarmykick           '/noreal
            call handleroyalarmykick(userindex)
        
        case egmcommands.forcemidiall            '/forcemidi
            call handleforcemidiall(userindex)
        
        case egmcommands.forcewaveall            '/forcewav
            call handleforcewaveall(userindex)
        
        case egmcommands.removepunishment        '/borrarpena
            call handleremovepunishment(userindex)
        
        case egmcommands.tileblockedtoggle       '/bloq
            call handletileblockedtoggle(userindex)
        
        case egmcommands.killnpcnorespawn        '/mata
            call handlekillnpcnorespawn(userindex)
        
        case egmcommands.killallnearbynpcs       '/masskill
            call handlekillallnearbynpcs(userindex)
        
        case egmcommands.lastip                  '/lastip
            call handlelastip(userindex)
        
        case egmcommands.changemotd              '/motdcambia
            call handlechangemotd(userindex)
        
        case egmcommands.setmotd                 'zmotd
            call handlesetmotd(userindex)
        
        case egmcommands.systemmessage           '/smsg
            call handlesystemmessage(userindex)
        
        case egmcommands.createnpc               '/acc
            call handlecreatenpc(userindex)
        
        case egmcommands.createnpcwithrespawn    '/racc
            call handlecreatenpcwithrespawn(userindex)
        
        case egmcommands.imperialarmour          '/ai1 - 4
            call handleimperialarmour(userindex)
        
        case egmcommands.chaosarmour             '/ac1 - 4
            call handlechaosarmour(userindex)
        
        case egmcommands.navigatetoggle          '/nave
            call handlenavigatetoggle(userindex)
        
        case egmcommands.serveropentouserstoggle '/habilitar
            call handleserveropentouserstoggle(userindex)
        
        case egmcommands.turnoffserver           '/apagar
            call handleturnoffserver(userindex)
        
        case egmcommands.turncriminal            '/conden
            call handleturncriminal(userindex)
        
        case egmcommands.resetfactions           '/rajar
            call handleresetfactions(userindex)
        
        case egmcommands.removecharfromguild     '/rajarclan
            call handleremovecharfromguild(userindex)
        
        case egmcommands.requestcharmail         '/lastemail
            call handlerequestcharmail(userindex)
        
        case egmcommands.alterpassword           '/apass
            call handlealterpassword(userindex)
        
        case egmcommands.altermail               '/aemail
            call handlealtermail(userindex)
        
        case egmcommands.altername               '/aname
            call handlealtername(userindex)
        
        case egmcommands.togglecentinelactivated '/centinelaactivado
            call handletogglecentinelactivated(userindex)
        
        case declaraciones.egmcommands.dobackup               '/dobackup
            call handledobackup(userindex)
        
        case egmcommands.showguildmessages       '/showcmsg
            call handleshowguildmessages(userindex)
        
        case egmcommands.savemap                 '/guardamapa
            call handlesavemap(userindex)
        
        case egmcommands.changemapinfopk         '/modmapinfo pk
            call handlechangemapinfopk(userindex)
        
        case egmcommands.changemapinfobackup     '/modmapinfo backup
            call handlechangemapinfobackup(userindex)
        
        case egmcommands.changemapinforestricted '/modmapinfo restringir
            call handlechangemapinforestricted(userindex)
        
        case egmcommands.changemapinfonomagic    '/modmapinfo magiasinefecto
            call handlechangemapinfonomagic(userindex)
        
        case egmcommands.changemapinfonoinvi     '/modmapinfo invisinefecto
            call handlechangemapinfonoinvi(userindex)
        
        case egmcommands.changemapinfonoresu     '/modmapinfo resusinefecto
            call handlechangemapinfonoresu(userindex)
        
        case egmcommands.changemapinfoland       '/modmapinfo terreno
            call handlechangemapinfoland(userindex)
        
        case egmcommands.changemapinfozone       '/modmapinfo zona
            call handlechangemapinfozone(userindex)
        
        case egmcommands.savechars               '/grabar
            call handlesavechars(userindex)
        
        case egmcommands.cleansos                '/borrar sos
            call handlecleansos(userindex)
        
        case egmcommands.showserverform          '/show int
            call handleshowserverform(userindex)
        
        case egmcommands.night                   '/noche
            call handlenight(userindex)
        
        case egmcommands.kickallchars            '/echartodospjs
            call handlekickallchars(userindex)
        
        case egmcommands.reloadnpcs              '/reloadnpcs
            call handlereloadnpcs(userindex)
        
        case egmcommands.reloadserverini         '/reloadsini
            call handlereloadserverini(userindex)
        
        case egmcommands.reloadspells            '/reloadhechizos
            call handlereloadspells(userindex)
        
        case egmcommands.reloadobjects           '/reloadobj
            call handlereloadobjects(userindex)
        
        case egmcommands.restart                 '/reiniciar
            call handlerestart(userindex)
        
        case egmcommands.resetautoupdate         '/autoupdate
            call handleresetautoupdate(userindex)
        
        case egmcommands.chatcolor               '/chatcolor
            call handlechatcolor(userindex)
        
        case egmcommands.ignored                 '/ignorado
            call handleignored(userindex)
        
        case egmcommands.checkslot               '/slot
            call handlecheckslot(userindex)
        
        case egmcommands.setinivar               '/setinivar llave clave valor
            call handlesetinivar(userindex)
    end select
end with

exit sub

errhandler:
    call logerror("error en gmcommands. error: " & err.number & " - " & err.description & _
                  ". paquete: " & command)

end sub

''
' handles the "home" message.
'
' @param    userindex the index of the user sending the message.
private sub handlehome(byval userindex as integer)
'***************************************************
'author: budi
'creation date: 06/01/2010
'last modification: 05/06/10
'pato - 05/06/10: add the ucase$ to prevent problems.
'***************************************************
with userlist(userindex)
    call .incomingdata.readbyte
    if .flags.targetnpctipo = enpctype.gobernador then
        call sethome(userindex, npclist(.flags.targetnpc).ciudad, .flags.targetnpc)
    else
        if .flags.muerto = 1 then
            'si es un mapa com�n y no est� en cana
            if ucase$(mapinfo(.pos.map).restringir) = "no" and .counters.pena = 0 then
                if .flags.traveling = 0 then
                    if ciudades(.hogar).map <> .pos.map then
                        call gohome(userindex)
                    else
                        call writeconsolemsg(userindex, "ya te encuentras en tu hogar.", fonttypenames.fonttype_info)
                    end if
                else
                    call writemultimessage(userindex, emessages.cancelhome)
                    .flags.traveling = 0
                    .counters.gohome = 0
                end if
            else
                call writeconsolemsg(userindex, "no puedes usar este comando aqu�.", fonttypenames.fonttype_fight)
            end if
        else
            call writeconsolemsg(userindex, "debes estar muerto para utilizar este comando.", fonttypenames.fonttype_info)
        end if
    end if
end with
end sub

''
' handles the "loginexistingchar" message.
'
' @param    userindex the index of the user sending the message.

private sub handleloginexistingchar(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
#if seguridadalkon then
    if userlist(userindex).incomingdata.length < 53 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
#else
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
#end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
        call buffer.copybuffer(userlist(userindex).incomingdata)
    
    'remove packet id
    call buffer.readbyte

    dim username as string
    dim password as string
    dim version as string
    
    username = buffer.readasciistring()
    
#if seguridadalkon then
    password = buffer.readasciistringfixed(32)
#else
    password = buffer.readasciistring()
#end if
    
    'convert version number to string
    version = cstr(buffer.readbyte()) & "." & cstr(buffer.readbyte()) & "." & cstr(buffer.readbyte())
    
    if not asciivalidos(username) then
        call writeerrormsg(userindex, "nombre inv�lido.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        
        exit sub
    end if
    
    if not personajeexiste(username) then
        call writeerrormsg(userindex, "el personaje no existe.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        
        exit sub
    end if
        
#if seguridadalkon then
    if not md5ok(buffer.readasciistringfixed(16)) then
        call writeerrormsg(userindex, "el cliente est� da�ado, por favor descarguelo nuevamente desde www.argentumonline.com.ar")
    else
#end if
        
        if bancheck(username) then
            call writeerrormsg(userindex, "se te ha prohibido la entrada a argentum online debido a tu mal comportamiento. puedes consultar el reglamento y el sistema de soporte desde www.argentumonline.com.ar")
        elseif not versionok(version) then
            call writeerrormsg(userindex, "esta versi�n del juego es obsoleta, la versi�n correcta es la " & ultimaversion & ". la misma se encuentra disponible en www.argentumonline.com.ar")
        else
            call connectuser(userindex, username, password)
        end if
#if seguridadalkon then
    end if
#end if
    
    'if we got here then packet is complete, copy data back to original queue
    call userlist(userindex).incomingdata.copybuffer(buffer)
    
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
' handles the "throwdices" message.
'
' @param    userindex the index of the user sending the message.

private sub handlethrowdices(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    with userlist(userindex).stats
        .useratributos(eatributos.fuerza) = maximoint(15, 13 + randomnumber(0, 3) + randomnumber(0, 2))
        .useratributos(eatributos.agilidad) = maximoint(15, 12 + randomnumber(0, 3) + randomnumber(0, 3))
        .useratributos(eatributos.inteligencia) = maximoint(16, 13 + randomnumber(0, 3) + randomnumber(0, 2))
        .useratributos(eatributos.carisma) = maximoint(15, 12 + randomnumber(0, 3) + randomnumber(0, 3))
        .useratributos(eatributos.constitucion) = 16 + randomnumber(0, 1) + randomnumber(0, 1)
    end with
    
    call writediceroll(userindex)
end sub

''
' handles the "loginnewchar" message.
'
' @param    userindex the index of the user sending the message.

private sub handleloginnewchar(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
#if seguridadalkon then
    if userlist(userindex).incomingdata.length < 62 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
#else
    if userlist(userindex).incomingdata.length < 15 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
#end if
    
on error goto errhandler
    'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
    dim buffer as new clsbytequeue
    call buffer.copybuffer(userlist(userindex).incomingdata)
    
    'remove packet id
    call buffer.readbyte

    dim username as string
    dim password as string
    dim version as string
    dim race as eraza
    dim gender as egenero
    dim homeland as eciudad
    dim class as eclass
    dim head as integer
    dim mail as string
    
#if seguridadalkon then
    dim md5 as string
#end if
    
    if puedecrearpersonajes = 0 then
        call writeerrormsg(userindex, "la creaci�n de personajes en este servidor se ha deshabilitado.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        
        exit sub
    end if
    
    if serversologms <> 0 then
        call writeerrormsg(userindex, "servidor restringido a administradores. consulte la p�gina oficial o el foro oficial para m�s informaci�n.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        
        exit sub
    end if
    
    if aclon.maxpersonajes(userlist(userindex).ip) then
        call writeerrormsg(userindex, "has creado demasiados personajes.")
        call flushbuffer(userindex)
        call closesocket(userindex)
        
        exit sub
    end if
    
    username = buffer.readasciistring()
    
#if seguridadalkon then
    password = buffer.readasciistringfixed(32)
#else
    password = buffer.readasciistring()
#end if
    
    'convert version number to string
    version = cstr(buffer.readbyte()) & "." & cstr(buffer.readbyte()) & "." & cstr(buffer.readbyte())
        
#if seguridadalkon then
    md5 = buffer.readasciistringfixed(16)
#end if
    
    race = buffer.readbyte()
    gender = buffer.readbyte()
    class = buffer.readbyte()
    head = buffer.readinteger
    mail = buffer.readasciistring()
    homeland = buffer.readbyte()
    
#if seguridadalkon then
    if not md5ok(md5) then
        call writeerrormsg(userindex, "el cliente est� da�ado, por favor descarguelo nuevamente desde www.argentumonline.com.ar")
    else
#end if
        
        if not versionok(version) then
            call writeerrormsg(userindex, "esta versi�n del juego es obsoleta, la versi�n correcta es la " & ultimaversion & ". la misma se encuentra disponible en www.argentumonline.com.ar")
        else
            call connectnewuser(userindex, username, password, race, gender, class, mail, homeland, head)
        end if
#if seguridadalkon then
    end if
#end if

    'if we got here then packet is complete, copy data back to original queue
    call userlist(userindex).incomingdata.copybuffer(buffer)
    
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
' handles the "talk" message.
'
' @param    userindex the index of the user sending the message.

private sub handletalk(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 13/01/2010
'15/07/2009: zama - now invisible admins talk by console.
'23/09/2009: zama - now invisible admins can't send empty chat.
'13/01/2010: zama - now hidden on boat pirats recover the proper boat body.
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
    
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim chat as string
        
        chat = buffer.readasciistring()
        
        '[consejeros & gms]
        if .flags.privilegios and (playertype.consejero or playertype.semidios) then
            call loggm(.name, "dijo: " & chat)
        end if
        
        'i see you....
        if .flags.oculto > 0 then
            .flags.oculto = 0
            .counters.tiempooculto = 0
            
            if .flags.navegando = 1 then
                if .clase = eclass.pirat then
                    ' pierde la apariencia de fragata fantasmal
                    call toogleboatbody(userindex)
                    call writeconsolemsg(userindex, "�has recuperado tu apariencia normal!", fonttypenames.fonttype_info)
                    call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, _
                                        ningunescudo, ninguncasco)
                end if
            else
                if .flags.invisible = 0 then
                    call usuarios.setinvisible(userindex, userlist(userindex).char.charindex, false)
                    call writeconsolemsg(userindex, "�has vuelto a ser visible!", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        if lenb(chat) <> 0 then
            'analize chat...
            call statistics.parsechat(chat)
            
            if not (.flags.admininvisible = 1) then
                if .flags.muerto = 1 then
                    call senddata(sendtarget.todeadarea, userindex, preparemessagechatoverhead(chat, .char.charindex, chat_color_dead_char))
                else
                    call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead(chat, .char.charindex, .flags.chatcolor))
                end if
            else
                if rtrim(chat) <> "" then
                    call senddata(sendtarget.topcarea, userindex, preparemessageconsolemsg("gm> " & chat, fonttypenames.fonttype_gm))
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "yell" message.
'
' @param    userindex the index of the user sending the message.

private sub handleyell(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 13/01/2010 (zama)
'15/07/2009: zama - now invisible admins yell by console.
'13/01/2010: zama - now hidden on boat pirats recover the proper boat body.
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
    
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim chat as string
        
        chat = buffer.readasciistring()
        

        '[consejeros & gms]
        if .flags.privilegios and (playertype.consejero or playertype.semidios) then
            call loggm(.name, "grito: " & chat)
        end if
            
        'i see you....
        if .flags.oculto > 0 then
            .flags.oculto = 0
            .counters.tiempooculto = 0
            
            if .flags.navegando = 1 then
                if .clase = eclass.pirat then
                    ' pierde la apariencia de fragata fantasmal
                    call toogleboatbody(userindex)
                    call writeconsolemsg(userindex, "�has recuperado tu apariencia normal!", fonttypenames.fonttype_info)
                    call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, _
                                        ningunescudo, ninguncasco)
                end if
            else
                if .flags.invisible = 0 then
                    call usuarios.setinvisible(userindex, .char.charindex, false)
                    call writeconsolemsg(userindex, "�has vuelto a ser visible!", fonttypenames.fonttype_info)
                end if
            end if
        end if
            
        if lenb(chat) <> 0 then
            'analize chat...
            call statistics.parsechat(chat)
                
            if .flags.privilegios and playertype.user then
                if userlist(userindex).flags.muerto = 1 then
                    call senddata(sendtarget.todeadarea, userindex, preparemessagechatoverhead(chat, .char.charindex, chat_color_dead_char))
                else
                    call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead(chat, .char.charindex, vbred))
                end if
            else
                if not (.flags.admininvisible = 1) then
                    call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead(chat, .char.charindex, chat_color_gm_yell))
                else
                    call senddata(sendtarget.topcarea, userindex, preparemessageconsolemsg("gm> " & chat, fonttypenames.fonttype_gm))
                end if
            end if
        end if
        
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "whisper" message.
'
' @param    userindex the index of the user sending the message.

private sub handlewhisper(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 15/07/2009
'28/05/2009: zama - now it doesn't appear any message when private talking to an invisible admin
'15/07/2009: zama - now invisible admins wisper by console.
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim chat as string
        dim targetcharindex as integer
        dim targetuserindex as integer
        dim targetpriv as playertype
        
        targetcharindex = buffer.readinteger()
        chat = buffer.readasciistring()
        
        targetuserindex = charindextouserindex(targetcharindex)
        
        if .flags.muerto then
            call writeconsolemsg(userindex, "��est�s muerto!! los muertos no pueden comunicarse con el mundo de los vivos. ", fonttypenames.fonttype_info)
        else
            if targetuserindex = invalid_index then
                call writeconsolemsg(userindex, "usuario inexistente.", fonttypenames.fonttype_info)
            else
                targetpriv = userlist(targetuserindex).flags.privilegios
                'a los dioses y admins no vale susurrarles si no sos uno vos mismo (as� no pueden ver si est�n conectados o no)
                if (targetpriv and (playertype.dios or playertype.admin)) <> 0 and (.flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios)) <> 0 then
                    ' controlamos que no este invisible
                    if userlist(targetuserindex).flags.admininvisible <> 1 then
                        call writeconsolemsg(userindex, "no puedes susurrarle a los dioses y admins.", fonttypenames.fonttype_info)
                    end if
                'a los consejeros y semidioses no vale susurrarles si sos un pj com�n.
                elseif (.flags.privilegios and playertype.user) <> 0 and (not targetpriv and playertype.user) <> 0 then
                    ' controlamos que no este invisible
                    if userlist(targetuserindex).flags.admininvisible <> 1 then
                        call writeconsolemsg(userindex, "no puedes susurrarle a los gms.", fonttypenames.fonttype_info)
                    end if
                elseif not estapcarea(userindex, targetuserindex) then
                    call writeconsolemsg(userindex, "est�s muy lejos del usuario.", fonttypenames.fonttype_info)
                
                else
                    '[consejeros & gms]
                    if .flags.privilegios and (playertype.consejero or playertype.semidios) then
                        call loggm(.name, "le dijo a '" & userlist(targetuserindex).name & "' " & chat)
                    end if
                    
                    if lenb(chat) <> 0 then
                        'analize chat...
                        call statistics.parsechat(chat)
                        
                        if not (.flags.admininvisible = 1) then
                            call writechatoverhead(userindex, chat, .char.charindex, vbblue)
                            call writechatoverhead(targetuserindex, chat, .char.charindex, vbblue)
                            call flushbuffer(targetuserindex)
                            
                            '[cdt 17-02-2004]
                            if .flags.privilegios and (playertype.user or playertype.consejero) then
                                call senddata(sendtarget.toadminsareabutconsejeros, userindex, preparemessagechatoverhead("a " & userlist(targetuserindex).name & "> " & chat, .char.charindex, vbyellow))
                            end if
                        else
                            call writeconsolemsg(userindex, "susurraste> " & chat, fonttypenames.fonttype_gm)
                            if userindex <> targetuserindex then call writeconsolemsg(targetuserindex, "gm susurra> " & chat, fonttypenames.fonttype_gm)
                            
                            if .flags.privilegios and (playertype.user or playertype.consejero) then
                                call senddata(sendtarget.toadminsareabutconsejeros, userindex, preparemessageconsolemsg("gm dijo a " & userlist(targetuserindex).name & "> " & chat, fonttypenames.fonttype_gm))
                            end if
                        end if
                    end if
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "walk" message.
'
' @param    userindex the index of the user sending the message.

private sub handlewalk(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 13/01/2010 (zama)
'11/19/09 pato - now the class bandit can walk hidden.
'13/01/2010: zama - now hidden on boat pirats recover the proper boat body.
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    dim dummy as long
    dim temptick as long
    dim heading as eheading
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        heading = .incomingdata.readbyte()
        
        'prevent speedhack
        if .flags.timeswalk >= 30 then
            temptick = gettickcount and &h7fffffff
            dummy = (temptick - .flags.startwalk)
            
            ' 5800 is actually less than what would be needed in perfect conditions to take 30 steps
            '(it's about 193 ms per step against the over 200 needed in perfect conditions)
            if dummy < 5800 then
                if temptick - .flags.countsh > 30000 then
                    .flags.countsh = 0
                end if
                
                if not .flags.countsh = 0 then
                    if dummy <> 0 then _
                        dummy = 126000 \ dummy
                    
                    call loghackattemp("tramposo sh: " & .name & " , " & dummy)
                    call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("servidor> " & .name & " ha sido echado por el servidor por posible uso de sh.", fonttypenames.fonttype_server))
                    call closesocket(userindex)
                    
                    exit sub
                else
                    .flags.countsh = temptick
                end if
            end if
            .flags.startwalk = temptick
            .flags.timeswalk = 0
        end if
        
        .flags.timeswalk = .flags.timeswalk + 1
        
        'if exiting, cancel
        call cancelexit(userindex)
        
        'todo: deber�a decirle por consola que no puede?
        'esta usando el /hogar, no se puede mover
        if .flags.traveling = 1 then exit sub
        
        if .flags.paralizado = 0 then
            if .flags.meditando then
                'stop meditating, next action will start movement.
                .flags.meditando = false
                .char.fx = 0
                .char.loops = 0
                
                call writemeditatetoggle(userindex)
                call writeconsolemsg(userindex, "dejas de meditar.", fonttypenames.fonttype_info)
                
                call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, 0, 0))
            else
                'move user
                call moveuserchar(userindex, heading)
                
                'stop resting if needed
                if .flags.descansar then
                    .flags.descansar = false
                    
                    call writerestok(userindex)
                    call writeconsolemsg(userindex, "has dejado de descansar.", fonttypenames.fonttype_info)
                end if
            end if
        else    'paralized
            if not .flags.ultimomensaje = 1 then
                .flags.ultimomensaje = 1
                
                call writeconsolemsg(userindex, "no puedes moverte porque est�s paralizado.", fonttypenames.fonttype_info)
            end if
            
            .flags.countsh = 0
        end if
        
        'can't move while hidden except he is a thief
        if .flags.oculto = 1 and .flags.admininvisible = 0 then
            if .clase <> eclass.thief and .clase <> eclass.bandit then
                .flags.oculto = 0
                .counters.tiempooculto = 0
            
                if .flags.navegando = 1 then
                    if .clase = eclass.pirat then
                        ' pierde la apariencia de fragata fantasmal
                        call toogleboatbody(userindex)
                        call writeconsolemsg(userindex, "�has recuperado tu apariencia normal!", fonttypenames.fonttype_info)
                        call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, _
                                        ningunescudo, ninguncasco)
                    end if
                else
                    'if not under a spell effect, show char
                    if .flags.invisible = 0 then
                        call writeconsolemsg(userindex, "has vuelto a ser visible.", fonttypenames.fonttype_info)
                        call usuarios.setinvisible(userindex, .char.charindex, false)
                    end if
                end if
            end if
        end if
    end with
end sub

''
' handles the "requestpositionupdate" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestpositionupdate(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    userlist(userindex).incomingdata.readbyte
    
    call writeposupdate(userindex)
end sub

''
' handles the "attack" message.
'
' @param    userindex the index of the user sending the message.

private sub handleattack(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 13/01/2010
'last modified by: zama
'10/01/2008: tavo - se cancela la salida del juego si el user esta saliendo.
'13/11/2009: zama - se cancela el estado no atacable al atcar.
'13/01/2010: zama - now hidden on boat pirats recover the proper boat body.
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'if dead, can't attack
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'if user meditates, can't attack
        if .flags.meditando then
            exit sub
        end if
        
        'if equiped weapon is ranged, can't attack this way
        if .invent.weaponeqpobjindex > 0 then
            if objdata(.invent.weaponeqpobjindex).proyectil = 1 then
                call writeconsolemsg(userindex, "no puedes usar as� este arma.", fonttypenames.fonttype_info)
                exit sub
            end if
        end if
        
        'if exiting, cancel
        call cancelexit(userindex)
        
        'attack!
        call usuarioataca(userindex)
        
        'now you can be atacked
        .flags.nopuedeseratacado = false
        
        'i see you...
        if .flags.oculto > 0 and .flags.admininvisible = 0 then
            .flags.oculto = 0
            .counters.tiempooculto = 0
            
            if .flags.navegando = 1 then
                if .clase = eclass.pirat then
                    ' pierde la apariencia de fragata fantasmal
                    call toogleboatbody(userindex)
                    call writeconsolemsg(userindex, "�has recuperado tu apariencia normal!", fonttypenames.fonttype_info)
                    call changeuserchar(userindex, .char.body, .char.head, .char.heading, ningunarma, _
                                        ningunescudo, ninguncasco)
                end if
            else
                if .flags.invisible = 0 then
                    call usuarios.setinvisible(userindex, .char.charindex, false)
                    call writeconsolemsg(userindex, "�has vuelto a ser visible!", fonttypenames.fonttype_info)
                end if
            end if
        end if
    end with
end sub

''
' handles the "pickup" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepickup(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/25/09
'02/26/2006: marco - agregu� un checkeo por si el usuario trata de agarrar un item mientras comercia.
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'if dead, it can't pick up objects
        if .flags.muerto = 1 then exit sub
        
        'if user is trading items and attempts to pickup an item, he's cheating, so we kick him.
        if .flags.comerciando then exit sub
        
        'lower rank administrators can't pick up items
        if .flags.privilegios and playertype.consejero then
            if not .flags.privilegios and playertype.rolemaster then
                call writeconsolemsg(userindex, "no puedes tomar ning�n objeto.", fonttypenames.fonttype_info)
                exit sub
            end if
        end if
        
        call getobj(userindex)
    end with
end sub

''
' handles the "safetoggle" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesafetoggle(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.seguro then
            call writemultimessage(userindex, emessages.safemodeoff) 'call writesafemodeoff(userindex)
        else
            call writemultimessage(userindex, emessages.safemodeon) 'call writesafemodeon(userindex)
        end if
        
        .flags.seguro = not .flags.seguro
    end with
end sub

''
' handles the "resuscitationsafetoggle" message.
'
' @param    userindex the index of the user sending the message.

private sub handleresuscitationtoggle(byval userindex as integer)
'***************************************************
'author: rapsodius
'creation date: 10/10/07
'***************************************************
    with userlist(userindex)
        call .incomingdata.readbyte
        
        .flags.seguroresu = not .flags.seguroresu
        
        if .flags.seguroresu then
            call writemultimessage(userindex, emessages.resuscitationsafeon) 'call writeresuscitationsafeon(userindex)
        else
            call writemultimessage(userindex, emessages.resuscitationsafeoff) 'call writeresuscitationsafeoff(userindex)
        end if
    end with
end sub

''
' handles the "requestguildleaderinfo" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestguildleaderinfo(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    userlist(userindex).incomingdata.readbyte
    
    call modguilds.sendguildleaderinfo(userindex)
end sub

''
' handles the "requestatributes" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestatributes(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call writeattributes(userindex)
end sub

''
' handles the "requestfame" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestfame(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call enviarfama(userindex)
end sub

''
' handles the "requestskills" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestskills(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call writesendskills(userindex)
end sub

''
' handles the "requestministats" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestministats(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call writeministats(userindex)
end sub

''
' handles the "commerceend" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecommerceend(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    'user quits commerce mode
    userlist(userindex).flags.comerciando = false
    call writecommerceend(userindex)
end sub

''
' handles the "usercommerceend" message.
'
' @param    userindex the index of the user sending the message.

private sub handleusercommerceend(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 11/03/2010
'11/03/2010: zama - le avisa por consola al que cencela que dejo de comerciar.
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'quits commerce mode with user
        if .comusu.destusu > 0 then
            if userlist(.comusu.destusu).comusu.destusu = userindex then
                call writeconsolemsg(.comusu.destusu, .name & " ha dejado de comerciar con vos.", fonttypenames.fonttype_talk)
                call fincomerciarusu(.comusu.destusu)
                
                'send data in the outgoing buffer of the other user
                call flushbuffer(.comusu.destusu)
            end if
        end if
        
        call fincomerciarusu(userindex)
        call writeconsolemsg(userindex, "has dejado de comerciar.", fonttypenames.fonttype_talk)
    end with
end sub

''
' handles the "usercommerceconfirm" message.
'
' @param    userindex the index of the user sending the message.
private sub handleusercommerceconfirm(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 14/12/2009
'
'***************************************************
    
    'remove packet id
    call userlist(userindex).incomingdata.readbyte

    'validate the commerce
    if puedeseguircomerciando(userindex) then
        'tell the other user the confirmation of the offer
        call writeuserofferconfirm(userlist(userindex).comusu.destusu)
        userlist(userindex).comusu.confirmo = true
    end if
    
end sub

private sub handlecommercechat(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 03/12/2009
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
    
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim chat as string
        
        chat = buffer.readasciistring()
        
        if lenb(chat) <> 0 then
            if puedeseguircomerciando(userindex) then
                'analize chat...
                call statistics.parsechat(chat)
                
                chat = userlist(userindex).name & "> " & chat
                call writecommercechat(userindex, chat, fonttypenames.fonttype_party)
                call writecommercechat(userlist(userindex).comusu.destusu, chat, fonttypenames.fonttype_party)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "bankend" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebankend(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'user exits banking mode
        .flags.comerciando = false
        call writebankend(userindex)
    end with
end sub

''
' handles the "usercommerceok" message.
'
' @param    userindex the index of the user sending the message.

private sub handleusercommerceok(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    'trade accepted
    call aceptarcomerciousu(userindex)
end sub

''
' handles the "usercommercereject" message.
'
' @param    userindex the index of the user sending the message.

private sub handleusercommercereject(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim otheruser as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        otheruser = .comusu.destusu
        
        'offer rejected
        if otheruser > 0 then
            if userlist(otheruser).flags.userlogged then
                call writeconsolemsg(otheruser, .name & " ha rechazado tu oferta.", fonttypenames.fonttype_talk)
                call fincomerciarusu(otheruser)
                
                'send data in the outgoing buffer of the other user
                call flushbuffer(otheruser)
            end if
        end if
        
        call writeconsolemsg(userindex, "has rechazado la oferta del otro usuario.", fonttypenames.fonttype_talk)
        call fincomerciarusu(userindex)
    end with
end sub

''
' handles the "drop" message.
'
' @param    userindex the index of the user sending the message.

private sub handledrop(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/25/09
'07/25/09: marco - agregu� un checkeo para patear a los usuarios que tiran items mientras comercian.
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    dim slot as byte
    dim amount as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte

        slot = .incomingdata.readbyte()
        amount = .incomingdata.readinteger()
        

        'low rank admins can't drop item. neither can the dead nor those sailing.
        if .flags.navegando = 1 or _
           .flags.muerto = 1 or _
           ((.flags.privilegios and playertype.consejero) <> 0 and (not .flags.privilegios and playertype.rolemaster) <> 0) then exit sub

        'if the user is trading, he can't drop items => he's cheating, we kick him.
        if .flags.comerciando then exit sub

        'are we dropping gold or other items??
        if slot = flagoro then
            if amount > 10000 then exit sub 'don't drop too much gold

            call tiraroro(amount, userindex)
            
            call writeupdategold(userindex)
        else
            'only drop valid slots
            if slot <= max_inventory_slots and slot > 0 then
                if .invent.object(slot).objindex = 0 then
                    exit sub
                end if
                
                call dropobj(userindex, slot, amount, .pos.map, .pos.x, .pos.y)
            end if
        end if
    end with
end sub

''
' handles the "castspell" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecastspell(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'13/11/2009: zama - ahora los npcs pueden atacar al usuario si quizo castear un hechizo
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim spell as byte
        
        spell = .incomingdata.readbyte()
        
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'now you can be atacked
        .flags.nopuedeseratacado = false
        
        if spell < 1 then
            .flags.hechizo = 0
            exit sub
        elseif spell > maxuserhechizos then
            .flags.hechizo = 0
            exit sub
        end if
        
        .flags.hechizo = .stats.userhechizos(spell)
    end with
end sub

''
' handles the "leftclick" message.
'
' @param    userindex the index of the user sending the message.

private sub handleleftclick(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex).incomingdata
        'remove packet id
        call .readbyte
        
        dim x as byte
        dim y as byte
        
        x = .readbyte()
        y = .readbyte()
        
        call lookattile(userindex, userlist(userindex).pos.map, x, y)
    end with
end sub

''
' handles the "doubleclick" message.
'
' @param    userindex the index of the user sending the message.

private sub handledoubleclick(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex).incomingdata
        'remove packet id
        call .readbyte
        
        dim x as byte
        dim y as byte
        
        x = .readbyte()
        y = .readbyte()
        
        call accion(userindex, userlist(userindex).pos.map, x, y)
    end with
end sub

''
' handles the "work" message.
'
' @param    userindex the index of the user sending the message.

private sub handlework(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 13/01/2010 (zama)
'13/01/2010: zama - el pirata se puede ocultar en barca
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim skill as eskill
        
        skill = .incomingdata.readbyte()
        
        if userlist(userindex).flags.muerto = 1 then exit sub
        
        'if exiting, cancel
        call cancelexit(userindex)
        
        select case skill
            case robar, magia, domar
                call writemultimessage(userindex, emessages.workrequesttarget, skill) 'call writeworkrequesttarget(userindex, skill)
            case ocultarse
            
                if .flags.enconsulta then
                    call writeconsolemsg(userindex, "no puedes ocultarte si est�s en consulta.", fonttypenames.fonttype_info)
                    exit sub
                end if
            
                if .flags.navegando = 1 then
                    if .clase <> eclass.pirat then
                        '[cdt 17-02-2004]
                        if not .flags.ultimomensaje = 3 then
                            call writeconsolemsg(userindex, "no puedes ocultarte si est�s navegando.", fonttypenames.fonttype_info)
                            .flags.ultimomensaje = 3
                        end if
                        '[/cdt]
                        exit sub
                    end if
                end if
                
                if .flags.oculto = 1 then
                    '[cdt 17-02-2004]
                    if not .flags.ultimomensaje = 2 then
                        call writeconsolemsg(userindex, "ya est�s oculto.", fonttypenames.fonttype_info)
                        .flags.ultimomensaje = 2
                    end if
                    '[/cdt]
                    exit sub
                end if
                
                call doocultarse(userindex)
        end select
    end with
end sub

''
' handles the "initcrafting" message.
'
' @param    userindex the index of the user sending the message.

private sub handleinitcrafting(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 29/01/2010
'
'***************************************************
    dim totalitems as long
    dim itemsporciclo as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        totalitems = .incomingdata.readlong
        itemsporciclo = .incomingdata.readinteger
        
        if totalitems > 0 then
            
            .construir.cantidad = totalitems
            .construir.porciclo = minimoint(maxitemsconstruibles(userindex), itemsporciclo)
            
        end if
    end with
end sub

''
' handles the "usespellmacro" message.
'
' @param    userindex the index of the user sending the message.

private sub handleusespellmacro(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        call senddata(sendtarget.toadmins, userindex, preparemessageconsolemsg(.name & " fue expulsado por anti-macro de hechizos.", fonttypenames.fonttype_veneno))
        call writeerrormsg(userindex, "has sido expulsado por usar macro de hechizos. recomendamos leer el reglamento sobre el tema macros.")
        call flushbuffer(userindex)
        call closesocket(userindex)
    end with
end sub

''
' handles the "useitem" message.
'
' @param    userindex the index of the user sending the message.

private sub handleuseitem(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim slot as byte
        
        slot = .incomingdata.readbyte()
        
        if slot <= .currentinventoryslots and slot > 0 then
            if .invent.object(slot).objindex = 0 then exit sub
        end if
        
        if .flags.meditando then
            exit sub    'the error message should have been provided by the client.
        end if
        
        call useinvitem(userindex, slot)
    end with
end sub

''
' handles the "craftblacksmith" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecraftblacksmith(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex).incomingdata
        'remove packet id
        call .readbyte
        
        dim item as integer
        
        item = .readinteger()
        
        if item < 1 then exit sub
        
        if objdata(item).skherreria = 0 then exit sub
        
        call herreroconstruiritem(userindex, item)
    end with
end sub

''
' handles the "craftcarpenter" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecraftcarpenter(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex).incomingdata
        'remove packet id
        call .readbyte
        
        dim item as integer
        
        item = .readinteger()
        
        if item < 1 then exit sub
        
        if objdata(item).skcarpinteria = 0 then exit sub
        
        call carpinteroconstruiritem(userindex, item)
    end with
end sub

''
' handles the "workleftclick" message.
'
' @param    userindex the index of the user sending the message.

private sub handleworkleftclick(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 14/01/2010 (zama)
'16/11/2009: zama - agregada la posibilidad de extraer madera elfica.
'12/01/2010: zama - ahora se admiten armas arrojadizas (proyectiles sin municiones).
'14/01/2010: zama - ya no se pierden municiones al atacar npcs con due�o.
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim x as byte
        dim y as byte
        dim skill as eskill
        dim dummyint as integer
        dim tu as integer   'target user
        dim tn as integer   'target npc
        
        x = .incomingdata.readbyte()
        y = .incomingdata.readbyte()
        
        skill = .incomingdata.readbyte()
        
        
        if .flags.muerto = 1 or .flags.descansar or .flags.meditando _
        or not inmapbounds(.pos.map, x, y) then exit sub

        if not inrangovision(userindex, x, y) then
            call writeposupdate(userindex)
            exit sub
        end if
        
        'if exiting, cancel
        call cancelexit(userindex)
        
        select case skill
            case eskill.proyectiles
            
                'check attack interval
                if not intervalopermiteatacar(userindex, false) then exit sub
                'check magic interval
                if not intervalopermitelanzarspell(userindex, false) then exit sub
                'check bow's interval
                if not intervalopermiteusararcos(userindex) then exit sub
                
                dim atacked as boolean
                atacked = true
                
                'make sure the item is valid and there is ammo equipped.
                with .invent
                    ' tiene arma equipada?
                    if .weaponeqpobjindex = 0 then
                        dummyint = 1
                    ' en un slot v�lido?
                    elseif .weaponeqpslot < 1 or .weaponeqpslot > userlist(userindex).currentinventoryslots then
                        dummyint = 1
                    ' usa munici�n? (si no la usa, puede ser un arma arrojadiza)
                    elseif objdata(.weaponeqpobjindex).municion = 1 then
                        ' la municion esta equipada en un slot valido?
                        if .municioneqpslot < 1 or .municioneqpslot > userlist(userindex).currentinventoryslots then
                            dummyint = 1
                        ' tiene munici�n?
                        elseif .municioneqpobjindex = 0 then
                            dummyint = 1
                        ' son flechas?
                        elseif objdata(.municioneqpobjindex).objtype <> eobjtype.otflechas then
                            dummyint = 1
                        ' tiene suficientes?
                        elseif .object(.municioneqpslot).amount < 1 then
                            dummyint = 1
                        end if
                    ' es un arma de proyectiles?
                    elseif objdata(.weaponeqpobjindex).proyectil <> 1 then
                        dummyint = 2
                    end if
                    
                    if dummyint <> 0 then
                        if dummyint = 1 then
                            call writeconsolemsg(userindex, "no tienes municiones.", fonttypenames.fonttype_info)
                            
                            call desequipar(userindex, .weaponeqpslot)
                        end if
                        
                        call desequipar(userindex, .municioneqpslot)
                        exit sub
                    end if
                end with
                
                'quitamos stamina
                if .stats.minsta >= 10 then
                    call quitarsta(userindex, randomnumber(1, 10))
                else
                    if .genero = egenero.hombre then
                        call writeconsolemsg(userindex, "est�s muy cansado para luchar.", fonttypenames.fonttype_info)
                    else
                        call writeconsolemsg(userindex, "est�s muy cansada para luchar.", fonttypenames.fonttype_info)
                    end if
                    exit sub
                end if
                
                call lookattile(userindex, .pos.map, x, y)
                
                tu = .flags.targetuser
                tn = .flags.targetnpc
                
                'validate target
                if tu > 0 then
                    'only allow to atack if the other one can retaliate (can see us)
                    if abs(userlist(tu).pos.y - .pos.y) > rango_vision_y then
                        call writeconsolemsg(userindex, "est�s demasiado lejos para atacar.", fonttypenames.fonttype_warning)
                        exit sub
                    end if
                    
                    'prevent from hitting self
                    if tu = userindex then
                        call writeconsolemsg(userindex, "�no puedes atacarte a vos mismo!", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    'attack!
                    atacked = usuarioatacausuario(userindex, tu)
                    
                elseif tn > 0 then
                    'only allow to atack if the other one can retaliate (can see us)
                    if abs(npclist(tn).pos.y - .pos.y) > rango_vision_y and abs(npclist(tn).pos.x - .pos.x) > rango_vision_x then
                        call writeconsolemsg(userindex, "est�s demasiado lejos para atacar.", fonttypenames.fonttype_warning)
                        exit sub
                    end if
                    
                    'is it attackable???
                    if npclist(tn).attackable <> 0 then
                        
                        'attack!
                        atacked = usuarioatacanpc(userindex, tn)
                    end if
                end if
                
                ' solo pierde la munici�n si pudo atacar al target, o tiro al aire
                if atacked then
                    with .invent
                        ' tiene equipado arco y flecha?
                        if objdata(.weaponeqpobjindex).municion = 1 then
                            dummyint = .municioneqpslot
                        
                            
                            'take 1 arrow away - we do it after hitting, since if ammo slot is 0 it gives a rt9 and kicks players
                            call quitaruserinvitem(userindex, dummyint, 1)
                            
                            if .object(dummyint).amount > 0 then
                                'quitaruserinvitem unequips the ammo, so we equip it again
                                .municioneqpslot = dummyint
                                .municioneqpobjindex = .object(dummyint).objindex
                                .object(dummyint).equipped = 1
                            else
                                .municioneqpslot = 0
                                .municioneqpobjindex = 0
                            end if
                        ' tiene equipado un arma arrojadiza
                        else
                            dummyint = .weaponeqpslot
                            
                            'take 1 knife away
                            call quitaruserinvitem(userindex, dummyint, 1)
                            
                            if .object(dummyint).amount > 0 then
                                'quitaruserinvitem unequips the weapon, so we equip it again
                                .weaponeqpslot = dummyint
                                .weaponeqpobjindex = .object(dummyint).objindex
                                .object(dummyint).equipped = 1
                            else
                                .weaponeqpslot = 0
                                .weaponeqpobjindex = 0
                            end if
                            
                        end if
                        
                        call updateuserinv(false, userindex, dummyint)
                    end with
               end if
            
            case eskill.magia
                'check the map allows spells to be casted.
                if mapinfo(.pos.map).magiasinefecto > 0 then
                    call writeconsolemsg(userindex, "una fuerza oscura te impide canalizar tu energ�a.", fonttypenames.fonttype_fight)
                    exit sub
                end if
                
                'target whatever is in that tile
                call lookattile(userindex, .pos.map, x, y)
                
                'if it's outside range log it and exit
                if abs(.pos.x - x) > rango_vision_x or abs(.pos.y - y) > rango_vision_y then
                    call logcheating("ataque fuera de rango de " & .name & "(" & .pos.map & "/" & .pos.x & "/" & .pos.y & ") ip: " & .ip & " a la posici�n (" & .pos.map & "/" & x & "/" & y & ")")
                    exit sub
                end if
                
                'check bow's interval
                if not intervalopermiteusararcos(userindex, false) then exit sub
                
                
                'check spell-hit interval
                if not intervalopermitegolpemagia(userindex) then
                    'check magic interval
                    if not intervalopermitelanzarspell(userindex) then
                        exit sub
                    end if
                end if
                
                
                'check intervals and cast
                if .flags.hechizo > 0 then
                    call lanzarhechizo(.flags.hechizo, userindex)
                    .flags.hechizo = 0
                else
                    call writeconsolemsg(userindex, "�primero selecciona el hechizo que quieres lanzar!", fonttypenames.fonttype_info)
                end if
            
            case eskill.pesca
                dummyint = .invent.weaponeqpobjindex
                if dummyint = 0 then exit sub
                
                'check interval
                if not intervalopermitetrabajar(userindex) then exit sub
                
                'basado en la idea de barrin
                'comentario por barrin: jah, "basado", caradura ! ^^
                if mapdata(.pos.map, .pos.x, .pos.y).trigger = 1 then
                    call writeconsolemsg(userindex, "no puedes pescar desde donde te encuentras.", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if hayagua(.pos.map, x, y) then
                    select case dummyint
                        case ca�a_pesca
                            call dopescar(userindex)
                        
                        case red_pesca
                            if abs(.pos.x - x) + abs(.pos.y - y) > 2 then
                                call writeconsolemsg(userindex, "est�s demasiado lejos para pescar.", fonttypenames.fonttype_info)
                                exit sub
                            end if
                            
                            call dopescarred(userindex)
                        
                        case else
                            exit sub    'invalid item!
                    end select
                    
                    'play sound!
                    call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_pescar, .pos.x, .pos.y))
                else
                    call writeconsolemsg(userindex, "no hay agua donde pescar. busca un lago, r�o o mar.", fonttypenames.fonttype_info)
                end if
            
            case eskill.robar
                'does the map allow us to steal here?
                if mapinfo(.pos.map).pk then
                    
                    'check interval
                    if not intervalopermitetrabajar(userindex) then exit sub
                    
                    'target whatever is in that tile
                    call lookattile(userindex, userlist(userindex).pos.map, x, y)
                    
                    tu = .flags.targetuser
                    
                    if tu > 0 and tu <> userindex then
                        'can't steal administrative players
                        if userlist(tu).flags.privilegios and playertype.user then
                            if userlist(tu).flags.muerto = 0 then
                                 if abs(.pos.x - x) + abs(.pos.y - y) > 1 then
                                     call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
                                     exit sub
                                 end if
                                 
                                 '17/09/02
                                 'check the trigger
                                 if mapdata(userlist(tu).pos.map, x, y).trigger = etrigger.zonasegura then
                                     call writeconsolemsg(userindex, "no puedes robar aqu�.", fonttypenames.fonttype_warning)
                                     exit sub
                                 end if
                                 
                                 if mapdata(.pos.map, .pos.x, .pos.y).trigger = etrigger.zonasegura then
                                     call writeconsolemsg(userindex, "no puedes robar aqu�.", fonttypenames.fonttype_warning)
                                     exit sub
                                 end if
                                 
                                 call dorobar(userindex, tu)
                            end if
                        end if
                    else
                        call writeconsolemsg(userindex, "�no hay a quien robarle!", fonttypenames.fonttype_info)
                    end if
                else
                    call writeconsolemsg(userindex, "�no puedes robar en zonas seguras!", fonttypenames.fonttype_info)
                end if
            
            case eskill.talar
                'check interval
                if not intervalopermitetrabajar(userindex) then exit sub
                
                if .invent.weaponeqpobjindex = 0 then
                    call writeconsolemsg(userindex, "deber�as equiparte el hacha.", fonttypenames.fonttype_info)
                    exit sub
                end if
                
                if .invent.weaponeqpobjindex <> hacha_le�ador and _
                    .invent.weaponeqpobjindex <> hacha_le�a_elfica then
                    ' podemos llegar ac� si el user equip� el anillo dsp de la u y antes del click
                    exit sub
                end if
                
                dummyint = mapdata(.pos.map, x, y).objinfo.objindex
                
                if dummyint > 0 then
                    if abs(.pos.x - x) + abs(.pos.y - y) > 2 then
                        call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    'barrin 29/9/03
                    if .pos.x = x and .pos.y = y then
                        call writeconsolemsg(userindex, "no puedes talar desde all�.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    '�hay un arbol donde clickeo?
                    if objdata(dummyint).objtype = eobjtype.otarboles and .invent.weaponeqpobjindex = hacha_le�ador then
                        call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_talar, .pos.x, .pos.y))
                        call dotalar(userindex)
                    elseif objdata(dummyint).objtype = eobjtype.otarbolelfico and .invent.weaponeqpobjindex = hacha_le�a_elfica then
                        if .invent.weaponeqpobjindex = hacha_le�a_elfica then
                            call senddata(sendtarget.topcarea, userindex, preparemessageplaywave(snd_talar, .pos.x, .pos.y))
                            call dotalar(userindex, true)
                        else
                            call writeconsolemsg(userindex, "el hacha utilizado no es suficientemente poderosa.", fonttypenames.fonttype_info)
                        end if
                    end if
                else
                    call writeconsolemsg(userindex, "no hay ning�n �rbol ah�.", fonttypenames.fonttype_info)
                end if
            
            case eskill.mineria
                if not intervalopermitetrabajar(userindex) then exit sub
                                
                if .invent.weaponeqpobjindex = 0 then exit sub
                
                if .invent.weaponeqpobjindex <> piquete_minero then
                    ' podemos llegar ac� si el user equip� el anillo dsp de la u y antes del click
                    exit sub
                end if
                
                'target whatever is in the tile
                call lookattile(userindex, .pos.map, x, y)
                
                dummyint = mapdata(.pos.map, x, y).objinfo.objindex
                
                if dummyint > 0 then
                    'check distance
                    if abs(.pos.x - x) + abs(.pos.y - y) > 2 then
                        call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
                        exit sub
                    end if
                    
                    dummyint = mapdata(.pos.map, x, y).objinfo.objindex 'check
                    '�hay un yacimiento donde clickeo?
                    if objdata(dummyint).objtype = eobjtype.otyacimiento then
                        call domineria(userindex)
                    else
                        call writeconsolemsg(userindex, "ah� no hay ning�n yacimiento.", fonttypenames.fonttype_info)
                    end if
                else
                    call writeconsolemsg(userindex, "ah� no hay ning�n yacimiento.", fonttypenames.fonttype_info)
                end if
            
            case eskill.domar
                'modificado 25/11/02
                'optimizado y solucionado el bug de la doma de
                'criaturas hostiles.
                
                'target whatever is that tile
                call lookattile(userindex, .pos.map, x, y)
                tn = .flags.targetnpc
                
                if tn > 0 then
                    if npclist(tn).flags.domable > 0 then
                        if abs(.pos.x - x) + abs(.pos.y - y) > 2 then
                            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
                            exit sub
                        end if
                        
                        if lenb(npclist(tn).flags.attackedby) <> 0 then
                            call writeconsolemsg(userindex, "no puedes domar una criatura que est� luchando con un jugador.", fonttypenames.fonttype_info)
                            exit sub
                        end if
                        
                        call dodomar(userindex, tn)
                    else
                        call writeconsolemsg(userindex, "no puedes domar a esa criatura.", fonttypenames.fonttype_info)
                    end if
                else
                    call writeconsolemsg(userindex, "�no hay ninguna criatura all�!", fonttypenames.fonttype_info)
                end if
            
            case fundirmetal    'ugly!!! this is a constant, not a skill!!
                'check interval
                if not intervalopermitetrabajar(userindex) then exit sub
                
                'check there is a proper item there
                if .flags.targetobj > 0 then
                    if objdata(.flags.targetobj).objtype = eobjtype.otfragua then
                        'validate other items
                        if .flags.targetobjinvslot < 1 or .flags.targetobjinvslot > .currentinventoryslots then
                            exit sub
                        end if
                        
                        ''chequeamos que no se zarpe duplicando oro
                        if .invent.object(.flags.targetobjinvslot).objindex <> .flags.targetobjinvindex then
                            if .invent.object(.flags.targetobjinvslot).objindex = 0 or .invent.object(.flags.targetobjinvslot).amount = 0 then
                                call writeconsolemsg(userindex, "no tienes m�s minerales.", fonttypenames.fonttype_info)
                                exit sub
                            end if
                            
                            ''fuiste
                            call writeerrormsg(userindex, "has sido expulsado por el sistema anti cheats.")
                            call flushbuffer(userindex)
                            call closesocket(userindex)
                            exit sub
                        end if
                        if objdata(.flags.targetobjinvindex).objtype = eobjtype.otminerales then
                            call fundirmineral(userindex)
                        elseif objdata(.flags.targetobjinvindex).objtype = eobjtype.otweapon then
                            call fundirarmas(userindex)
                        end if
                    else
                        call writeconsolemsg(userindex, "ah� no hay ninguna fragua.", fonttypenames.fonttype_info)
                    end if
                else
                    call writeconsolemsg(userindex, "ah� no hay ninguna fragua.", fonttypenames.fonttype_info)
                end if
            
            case eskill.herreria
                'target wehatever is in that tile
                call lookattile(userindex, .pos.map, x, y)
                
                if .flags.targetobj > 0 then
                    if objdata(.flags.targetobj).objtype = eobjtype.otyunque then
                        call enivararmasconstruibles(userindex)
                        call enivararmadurasconstruibles(userindex)
                        call writeshowblacksmithform(userindex)
                    else
                        call writeconsolemsg(userindex, "ah� no hay ning�n yunque.", fonttypenames.fonttype_info)
                    end if
                else
                    call writeconsolemsg(userindex, "ah� no hay ning�n yunque.", fonttypenames.fonttype_info)
                end if
        end select
    end with
end sub

''
' handles the "createnewguild" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecreatenewguild(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/11/09
'05/11/09: pato - ahora se quitan los espacios del principio y del fin del nombre del clan
'***************************************************
    if userlist(userindex).incomingdata.length < 9 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim desc as string
        dim guildname as string
        dim site as string
        dim codex() as string
        dim errorstr as string
        
        desc = buffer.readasciistring()
        guildname = trim$(buffer.readasciistring())
        site = buffer.readasciistring()
        codex = split(buffer.readasciistring(), separator)
        
        if modguilds.crearnuevoclan(userindex, desc, guildname, site, codex, .fundandoguildalineacion, errorstr) then
            call senddata(sendtarget.toall, userindex, preparemessageconsolemsg(.name & " fund� el clan " & guildname & " de alineaci�n " & modguilds.guildalignment(.guildindex) & ".", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toall, 0, preparemessageplaywave(44, no_3d_sound, no_3d_sound))

            
            'update tag
             call refreshcharstatus(userindex)
        else
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "spellinfo" message.
'
' @param    userindex the index of the user sending the message.

private sub handlespellinfo(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim spellslot as byte
        dim spell as integer
        
        spellslot = .incomingdata.readbyte()
        
        'validate slot
        if spellslot < 1 or spellslot > maxuserhechizos then
            call writeconsolemsg(userindex, "�primero selecciona el hechizo!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate spell in the slot
        spell = .stats.userhechizos(spellslot)
        if spell > 0 and spell < numerohechizos + 1 then
            with hechizos(spell)
                'send information
                call writeconsolemsg(userindex, "%%%%%%%%%%%% info del hechizo %%%%%%%%%%%%" & vbcrlf _
                                               & "nombre:" & .nombre & vbcrlf _
                                               & "descripci�n:" & .desc & vbcrlf _
                                               & "skill requerido: " & .minskill & " de magia." & vbcrlf _
                                               & "man� necesario: " & .manarequerido & vbcrlf _
                                               & "energ�a necesaria: " & .starequerido & vbcrlf _
                                               & "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%", fonttypenames.fonttype_info)
            end with
        end if
    end with
end sub

''
' handles the "equipitem" message.
'
' @param    userindex the index of the user sending the message.

private sub handleequipitem(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim itemslot as byte
        
        itemslot = .incomingdata.readbyte()
        
        'dead users can't equip items
        if .flags.muerto = 1 then exit sub
        
        'validate item slot
        if itemslot > .currentinventoryslots or itemslot < 1 then exit sub
        
        if .invent.object(itemslot).objindex = 0 then exit sub
        
        call equiparinvitem(userindex, itemslot)
    end with
end sub

''
' handles the "changeheading" message.
'
' @param    userindex the index of the user sending the message.

private sub handlechangeheading(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 06/28/2008
'last modified by: niconz
' 10/01/2008: tavo - se cancela la salida del juego si el user esta saliendo
' 06/28/2008: niconz - s�lo se puede cambiar si est� inmovilizado.
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim heading as eheading
        dim posx as integer
        dim posy as integer
                
        heading = .incomingdata.readbyte()
        
        if .flags.paralizado = 1 and .flags.inmovilizado = 0 then
            select case heading
                case eheading.north
                    posy = -1
                case eheading.east
                    posx = 1
                case eheading.south
                    posy = 1
                case eheading.west
                    posx = -1
            end select
            
                if legalpos(.pos.map, .pos.x + posx, .pos.y + posy, cbool(.flags.navegando), not cbool(.flags.navegando)) then
                    exit sub
                end if
        end if
        
        'validate heading (vb won't say invalid cast if not a valid index like .net languages would do... *sigh*)
        if heading > 0 and heading < 5 then
            .char.heading = heading
            call changeuserchar(userindex, .char.body, .char.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
        end if
    end with
end sub

''
' handles the "modifyskills" message.
'
' @param    userindex the index of the user sending the message.

private sub handlemodifyskills(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 11/19/09
'11/19/09: pato - adapting to new skills system.
'***************************************************
    if userlist(userindex).incomingdata.length < 1 + numskills then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim i as long
        dim count as integer
        dim points(1 to numskills) as byte
        
        'codigo para prevenir el hackeo de los skills
        '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        for i = 1 to numskills
            points(i) = .incomingdata.readbyte()
            
            if points(i) < 0 then
                call loghackattemp(.name & " ip:" & .ip & " trat� de hackear los skills.")
                .stats.skillpts = 0
                call closesocket(userindex)
                exit sub
            end if
            
            count = count + points(i)
        next i
        
        if count > .stats.skillpts then
            call loghackattemp(.name & " ip:" & .ip & " trat� de hackear los skills.")
            call closesocket(userindex)
            exit sub
        end if
        '<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
        
        .counters.asignedskills = minimoint(10, .counters.asignedskills + count)
        
        with .stats
            for i = 1 to numskills
                if points(i) > 0 then
                    .skillpts = .skillpts - points(i)
                    .userskills(i) = .userskills(i) + points(i)
                    
                    'client should prevent this, but just in case...
                    if .userskills(i) > 100 then
                        .skillpts = .skillpts + .userskills(i) - 100
                        .userskills(i) = 100
                    end if
                    
                    call checkeluskill(userindex, i, true)
                end if
            next i
        end with
    end with
end sub

''
' handles the "train" message.
'
' @param    userindex the index of the user sending the message.

private sub handletrain(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim spawnednpc as integer
        dim petindex as byte
        
        petindex = .incomingdata.readbyte()
        
        if .flags.targetnpc = 0 then exit sub
        
        if npclist(.flags.targetnpc).npctype <> enpctype.entrenador then exit sub
        
        if npclist(.flags.targetnpc).mascotas < maxmascotasentrenador then
            if petindex > 0 and petindex < npclist(.flags.targetnpc).nrocriaturas + 1 then
                'create the creature
                spawnednpc = spawnnpc(npclist(.flags.targetnpc).criaturas(petindex).npcindex, npclist(.flags.targetnpc).pos, true, false)
                
                if spawnednpc > 0 then
                    npclist(spawnednpc).maestronpc = .flags.targetnpc
                    npclist(.flags.targetnpc).mascotas = npclist(.flags.targetnpc).mascotas + 1
                end if
            end if
        else
            call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead("no puedo traer m�s criaturas, mata las existentes.", npclist(.flags.targetnpc).char.charindex, vbwhite))
        end if
    end with
end sub

''
' handles the "commercebuy" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecommercebuy(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim slot as byte
        dim amount as integer
        
        slot = .incomingdata.readbyte()
        amount = .incomingdata.readinteger()
        
        'dead people can't commerce...
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        '�el target es un npc valido?
        if .flags.targetnpc < 1 then exit sub
            
        '�el npc puede comerciar?
        if npclist(.flags.targetnpc).comercia = 0 then
            call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead("no tengo ning�n inter�s en comerciar.", npclist(.flags.targetnpc).char.charindex, vbwhite))
            exit sub
        end if
        
        'only if in commerce mode....
        if not .flags.comerciando then
            call writeconsolemsg(userindex, "no est�s comerciando.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'user compra el item
        call comercio(emodocomercio.compra, userindex, .flags.targetnpc, slot, amount)
    end with
end sub

''
' handles the "bankextractitem" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebankextractitem(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim slot as byte
        dim amount as integer
        
        slot = .incomingdata.readbyte()
        amount = .incomingdata.readinteger()
        
        'dead people can't commerce
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        '�el target es un npc valido?
        if .flags.targetnpc < 1 then exit sub
        
        '�es el banquero?
        if npclist(.flags.targetnpc).npctype <> enpctype.banquero then
            exit sub
        end if
        
        'user retira el item del slot
        call userretiraitem(userindex, slot, amount)
    end with
end sub

''
' handles the "commercesell" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecommercesell(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim slot as byte
        dim amount as integer
        
        slot = .incomingdata.readbyte()
        amount = .incomingdata.readinteger()
        
        'dead people can't commerce...
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        '�el target es un npc valido?
        if .flags.targetnpc < 1 then exit sub
        
        '�el npc puede comerciar?
        if npclist(.flags.targetnpc).comercia = 0 then
            call senddata(sendtarget.topcarea, userindex, preparemessagechatoverhead("no tengo ning�n inter�s en comerciar.", npclist(.flags.targetnpc).char.charindex, vbwhite))
            exit sub
        end if
        
        'user compra el item del slot
        call comercio(emodocomercio.venta, userindex, .flags.targetnpc, slot, amount)
    end with
end sub

''
' handles the "bankdeposit" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebankdeposit(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim slot as byte
        dim amount as integer
        
        slot = .incomingdata.readbyte()
        amount = .incomingdata.readinteger()
        
        'dead people can't commerce...
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        '�el target es un npc valido?
        if .flags.targetnpc < 1 then exit sub
        
        '�el npc puede comerciar?
        if npclist(.flags.targetnpc).npctype <> enpctype.banquero then
            exit sub
        end if
        
        'user deposita el item del slot rdata
        call userdepositaitem(userindex, slot, amount)
    end with
end sub

''
' handles the "forumpost" message.
'
' @param    userindex the index of the user sending the message.

private sub handleforumpost(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 02/01/2010
'02/01/2010: zama - implemento nuevo sistema de foros
'***************************************************
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim forummsgtype as eforummsgtype
        
        dim file as string
        dim title as string
        dim post as string
        dim forumindex as integer
        dim postfile as string
        dim forumtype as byte
                
        forummsgtype = buffer.readbyte()
        
        title = buffer.readasciistring()
        post = buffer.readasciistring()
        
        if .flags.targetobj > 0 then
            forumtype = forumalignment(forummsgtype)
            
            select case forumtype
            
                case eforumtype.iegeneral
                    forumindex = getforumindex(objdata(.flags.targetobj).foroid)
                    
                case eforumtype.iereal
                    forumindex = getforumindex(foro_real_id)
                    
                case eforumtype.iecaos
                    forumindex = getforumindex(foro_caos_id)
                    
            end select
            
            call addpost(forumindex, post, .name, title, esanuncio(forummsgtype))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "movespell" message.
'
' @param    userindex the index of the user sending the message.

private sub handlemovespell(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex).incomingdata
        'remove packet id
        call .readbyte
        
        dim dir as integer
        
        if .readboolean() then
            dir = 1
        else
            dir = -1
        end if
        
        call desplazarhechizo(userindex, dir, .readbyte())
    end with
end sub

''
' handles the "movebank" message.
'
' @param    userindex the index of the user sending the message.

private sub handlemovebank(byval userindex as integer)
'***************************************************
'author: torres patricio (pato)
'last modification: 06/14/09
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex).incomingdata
        'remove packet id
        call .readbyte
        
        dim dir as integer
        dim slot as byte
        dim tempitem as obj
        
        if .readboolean() then
            dir = 1
        else
            dir = -1
        end if
        
        slot = .readbyte()
    end with
        
    with userlist(userindex)
        tempitem.objindex = .bancoinvent.object(slot).objindex
        tempitem.amount = .bancoinvent.object(slot).amount
        
        if dir = 1 then 'mover arriba
            .bancoinvent.object(slot) = .bancoinvent.object(slot - 1)
            .bancoinvent.object(slot - 1).objindex = tempitem.objindex
            .bancoinvent.object(slot - 1).amount = tempitem.amount
        else 'mover abajo
            .bancoinvent.object(slot) = .bancoinvent.object(slot + 1)
            .bancoinvent.object(slot + 1).objindex = tempitem.objindex
            .bancoinvent.object(slot + 1).amount = tempitem.amount
        end if
    end with
    
    call updatebanuserinv(true, userindex, 0)
    call updateventanabanco(userindex)

end sub

''
' handles the "clancodexupdate" message.
'
' @param    userindex the index of the user sending the message.

private sub handleclancodexupdate(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim desc as string
        dim codex() as string
        
        desc = buffer.readasciistring()
        codex = split(buffer.readasciistring(), separator)
        
        call modguilds.changecodexanddesc(desc, codex, .guildindex)
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "usercommerceoffer" message.
'
' @param    userindex the index of the user sending the message.

private sub handleusercommerceoffer(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 24/11/2009
'24/11/2009: zama - nuevo sistema de comercio
'***************************************************
    if userlist(userindex).incomingdata.length < 7 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim amount as long
        dim slot as byte
        dim tuser as integer
        dim offerslot as byte
        dim objindex as integer
        
        slot = .incomingdata.readbyte()
        amount = .incomingdata.readlong()
        offerslot = .incomingdata.readbyte()
        
        'get the other player
        tuser = .comusu.destusu
        
        ' if he's already confirmed his offer, but now tries to change it, then he's cheating
        if userlist(userindex).comusu.confirmo = true then
            
            ' finish the trade
            call fincomerciarusu(userindex)
        
            if tuser <= 0 or tuser > maxusers then
                call fincomerciarusu(tuser)
                call protocol.flushbuffer(tuser)
            end if
        
            exit sub
        end if
        
        'if slot is invalid and it's not gold or it's not 0 (substracting), then ignore it.
        if ((slot < 0 or slot > userlist(userindex).currentinventoryslots) and slot <> flagoro) then exit sub
        
        'if offerslot is invalid, then ignore it.
        if offerslot < 1 or offerslot > max_offer_slots + 1 then exit sub
        
        ' can be negative if substracted from the offer, but never 0.
        if amount = 0 then exit sub
        
        'has he got enough??
        if slot = flagoro then
            ' can't offer more than he has
            if amount > .stats.gld - .comusu.goldamount then
                call writecommercechat(userindex, "no tienes esa cantidad de oro para agregar a la oferta.", fonttypenames.fonttype_talk)
                exit sub
            end if
        else
            'if modifing a filled offerslot, we already got the objindex, then we don't need to know it
            if slot <> 0 then objindex = .invent.object(slot).objindex
            ' can't offer more than he has
            if not tieneobjetos(objindex, _
                totalofferitems(objindex, userindex) + amount, userindex) then
                
                call writecommercechat(userindex, "no tienes esa cantidad.", fonttypenames.fonttype_talk)
                exit sub
            end if
            
            if itemnewbie(objindex) then
                call writecancelofferitem(userindex, offerslot)
                exit sub
            end if
            
            'don't allow to sell boats if they are equipped (you can't take them off in the water and causes trouble)
            if .flags.navegando = 1 then
                if .invent.barcoslot = slot then
                    call writecommercechat(userindex, "no puedes vender tu barco mientras lo est�s usando.", fonttypenames.fonttype_talk)
                    exit sub
                end if
            end if
            
            if .invent.mochilaeqpslot > 0 then
                if .invent.mochilaeqpslot = slot then
                    call writecommercechat(userindex, "no puedes vender tu mochila mientras la est�s usando.", fonttypenames.fonttype_talk)
                    exit sub
                end if
            end if
        end if
        
        
                
        call agregaroferta(userindex, offerslot, objindex, amount, slot = flagoro)
        
        call enviaroferta(tuser, offerslot)
    end with
end sub

''
' handles the "guildacceptpeace" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildacceptpeace(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim errorstr as string
        dim otherclanindex as string
        
        guild = buffer.readasciistring()
        
        otherclanindex = modguilds.r_aceptarpropuestadepaz(userindex, guild, errorstr)
        
        if otherclanindex = 0 then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageconsolemsg("tu clan ha firmado la paz con " & guild & ".", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, otherclanindex, preparemessageconsolemsg("tu clan ha firmado la paz con " & modguilds.guildname(.guildindex) & ".", fonttypenames.fonttype_guild))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildrejectalliance" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildrejectalliance(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim errorstr as string
        dim otherclanindex as string
        
        guild = buffer.readasciistring()
        
        otherclanindex = modguilds.r_rechazarpropuestadealianza(userindex, guild, errorstr)
        
        if otherclanindex = 0 then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageconsolemsg("tu clan rechazado la propuesta de alianza de " & guild, fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, otherclanindex, preparemessageconsolemsg(modguilds.guildname(.guildindex) & " ha rechazado nuestra propuesta de alianza con su clan.", fonttypenames.fonttype_guild))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildrejectpeace" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildrejectpeace(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim errorstr as string
        dim otherclanindex as string
        
        guild = buffer.readasciistring()
        
        otherclanindex = modguilds.r_rechazarpropuestadepaz(userindex, guild, errorstr)
        
        if otherclanindex = 0 then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageconsolemsg("tu clan rechazado la propuesta de paz de " & guild & ".", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, otherclanindex, preparemessageconsolemsg(modguilds.guildname(.guildindex) & " ha rechazado nuestra propuesta de paz con su clan.", fonttypenames.fonttype_guild))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildacceptalliance" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildacceptalliance(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim errorstr as string
        dim otherclanindex as string
        
        guild = buffer.readasciistring()
        
        otherclanindex = modguilds.r_aceptarpropuestadealianza(userindex, guild, errorstr)
        
        if otherclanindex = 0 then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageconsolemsg("tu clan ha firmado la alianza con " & guild & ".", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, otherclanindex, preparemessageconsolemsg("tu clan ha firmado la paz con " & modguilds.guildname(.guildindex) & ".", fonttypenames.fonttype_guild))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildofferpeace" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildofferpeace(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim proposal as string
        dim errorstr as string
        
        guild = buffer.readasciistring()
        proposal = buffer.readasciistring()
        
        if modguilds.r_clangenerapropuesta(userindex, guild, relaciones_guild.paz, proposal, errorstr) then
            call writeconsolemsg(userindex, "propuesta de paz enviada.", fonttypenames.fonttype_guild)
        else
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildofferalliance" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildofferalliance(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim proposal as string
        dim errorstr as string
        
        guild = buffer.readasciistring()
        proposal = buffer.readasciistring()
        
        if modguilds.r_clangenerapropuesta(userindex, guild, relaciones_guild.aliados, proposal, errorstr) then
            call writeconsolemsg(userindex, "propuesta de alianza enviada.", fonttypenames.fonttype_guild)
        else
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildalliancedetails" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildalliancedetails(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim errorstr as string
        dim details as string
        
        guild = buffer.readasciistring()
        
        details = modguilds.r_verpropuesta(userindex, guild, relaciones_guild.aliados, errorstr)
        
        if lenb(details) = 0 then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            call writeofferdetails(userindex, details)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildpeacedetails" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildpeacedetails(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim errorstr as string
        dim details as string
        
        guild = buffer.readasciistring()
        
        details = modguilds.r_verpropuesta(userindex, guild, relaciones_guild.paz, errorstr)
        
        if lenb(details) = 0 then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            call writeofferdetails(userindex, details)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildrequestjoinerinfo" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildrequestjoinerinfo(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim user as string
        dim details as string
        
        user = buffer.readasciistring()
        
        details = modguilds.a_detallesaspirante(userindex, user)
        
        if lenb(details) = 0 then
            call writeconsolemsg(userindex, "el personaje no ha mandado solicitud, o no est�s habilitado para verla.", fonttypenames.fonttype_guild)
        else
            call writeshowuserrequest(userindex, details)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildallianceproplist" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildallianceproplist(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call writealianceproposalslist(userindex, r_listadepropuestas(userindex, relaciones_guild.aliados))
end sub

''
' handles the "guildpeaceproplist" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildpeaceproplist(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call writepeaceproposalslist(userindex, r_listadepropuestas(userindex, relaciones_guild.paz))
end sub

''
' handles the "guilddeclarewar" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguilddeclarewar(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim errorstr as string
        dim otherguildindex as integer
        
        guild = buffer.readasciistring()
        
        otherguildindex = modguilds.r_declararguerra(userindex, guild, errorstr)
        
        if otherguildindex = 0 then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            'war shall be!
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageconsolemsg("tu clan ha entrado en guerra con " & guild & ".", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, otherguildindex, preparemessageconsolemsg(modguilds.guildname(.guildindex) & " le declara la guerra a tu clan.", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageplaywave(45, no_3d_sound, no_3d_sound))
            call senddata(sendtarget.toguildmembers, otherguildindex, preparemessageplaywave(45, no_3d_sound, no_3d_sound))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildnewwebsite" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildnewwebsite(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        call modguilds.actualizarwebsite(userindex, buffer.readasciistring())
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildacceptnewmember" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildacceptnewmember(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim errorstr as string
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if not modguilds.a_aceptaraspirante(userindex, username, errorstr) then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            tuser = nameindex(username)
            if tuser > 0 then
                call modguilds.m_conectarmiembroaclan(tuser, .guildindex)
                call refreshcharstatus(tuser)
            end if
            
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageconsolemsg(username & " ha sido aceptado como miembro del clan.", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageplaywave(43, no_3d_sound, no_3d_sound))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildrejectnewmember" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildrejectnewmember(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/08/07
'last modification by: (liquid)
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim errorstr as string
        dim username as string
        dim reason as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        reason = buffer.readasciistring()
        
        if not modguilds.a_rechazaraspirante(userindex, username, errorstr) then
            call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
            tuser = nameindex(username)
            
            if tuser > 0 then
                call writeconsolemsg(tuser, errorstr & " : " & reason, fonttypenames.fonttype_guild)
            else
                'hay que grabar en el char su rechazo
                call modguilds.a_rechazaraspirantechar(username, .guildindex, reason)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildkickmember" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildkickmember(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim guildindex as integer
        
        username = buffer.readasciistring()
        
        guildindex = modguilds.m_echarmiembrodeclan(userindex, username)
        
        if guildindex > 0 then
            call senddata(sendtarget.toguildmembers, guildindex, preparemessageconsolemsg(username & " fue expulsado del clan.", fonttypenames.fonttype_guild))
            call senddata(sendtarget.toguildmembers, guildindex, preparemessageplaywave(45, no_3d_sound, no_3d_sound))
        else
            call writeconsolemsg(userindex, "no puedes expulsar ese personaje del clan.", fonttypenames.fonttype_guild)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildupdatenews" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildupdatenews(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        call modguilds.actualizarnoticias(userindex, buffer.readasciistring())
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildmemberinfo" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildmemberinfo(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        call modguilds.senddetallespersonaje(userindex, buffer.readasciistring())
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildopenelections" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildopenelections(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim error as string
        
        if not modguilds.v_abrirelecciones(userindex, error) then
            call writeconsolemsg(userindex, error, fonttypenames.fonttype_guild)
        else
            call senddata(sendtarget.toguildmembers, .guildindex, preparemessageconsolemsg("�han comenzado las elecciones del clan! puedes votar escribiendo /voto seguido del nombre del personaje, por ejemplo: /voto " & .name, fonttypenames.fonttype_guild))
        end if
    end with
end sub

''
' handles the "guildrequestmembership" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildrequestmembership(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim application as string
        dim errorstr as string
        
        guild = buffer.readasciistring()
        application = buffer.readasciistring()
        
        if not modguilds.a_nuevoaspirante(userindex, guild, application, errorstr) then
           call writeconsolemsg(userindex, errorstr, fonttypenames.fonttype_guild)
        else
           call writeconsolemsg(userindex, "tu solicitud ha sido enviada. espera prontas noticias del l�der de " & guild & ".", fonttypenames.fonttype_guild)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildrequestdetails" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildrequestdetails(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        call modguilds.sendguilddetails(userindex, buffer.readasciistring())
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "online" message.
'
' @param    userindex the index of the user sending the message.

private sub handleonline(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as long
    dim count as long
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        for i = 1 to lastuser
            if lenb(userlist(i).name) <> 0 then
                if userlist(i).flags.privilegios and (playertype.user or playertype.consejero) then _
                    count = count + 1
            end if
        next i
        
        call writeconsolemsg(userindex, "n�mero de usuarios: " & cstr(count), fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "quit" message.
'
' @param    userindex the index of the user sending the message.

private sub handlequit(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/15/2008 (niconz)
'if user is invisible, it automatically becomes
'visible before doing the countdown to exit
'04/15/2008 - no se reseteaban lso contadores de invi ni de ocultar. (niconz)
'***************************************************
    dim tuser as integer
    dim isnotvisible as boolean
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.paralizado = 1 then
            call writeconsolemsg(userindex, "no puedes salir estando paralizado.", fonttypenames.fonttype_warning)
            exit sub
        end if
        
        'exit secure commerce
        if .comusu.destusu > 0 then
            tuser = .comusu.destusu
            
            if userlist(tuser).flags.userlogged then
                if userlist(tuser).comusu.destusu = userindex then
                    call writeconsolemsg(tuser, "comercio cancelado por el otro usuario.", fonttypenames.fonttype_talk)
                    call fincomerciarusu(tuser)
                end if
            end if
            
            call writeconsolemsg(userindex, "comercio cancelado.", fonttypenames.fonttype_talk)
            call fincomerciarusu(userindex)
        end if
        
        call cerrar_usuario(userindex)
    end with
end sub

''
' handles the "guildleave" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildleave(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim guildindex as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'obtengo el guildindex
        guildindex = m_echarmiembrodeclan(userindex, .name)
        
        if guildindex > 0 then
            call writeconsolemsg(userindex, "dejas el clan.", fonttypenames.fonttype_guild)
            call senddata(sendtarget.toguildmembers, guildindex, preparemessageconsolemsg(.name & " deja el clan.", fonttypenames.fonttype_guild))
        else
            call writeconsolemsg(userindex, "t� no puedes salir de este clan.", fonttypenames.fonttype_guild)
        end if
    end with
end sub

''
' handles the "requestaccountstate" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestaccountstate(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim earnings as integer
    dim percentage as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead people can't check their accounts
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if distancia(npclist(.flags.targetnpc).pos, .pos) > 3 then
            call writeconsolemsg(userindex, "est�s demasiado lejos del vendedor.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        select case npclist(.flags.targetnpc).npctype
            case enpctype.banquero
                call writechatoverhead(userindex, "tienes " & .stats.banco & " monedas de oro en tu cuenta.", npclist(.flags.targetnpc).char.charindex, vbwhite)
            
            case enpctype.timbero
                if not .flags.privilegios and playertype.user then
                    earnings = apuestas.ganancias - apuestas.perdidas
                    
                    if earnings >= 0 and apuestas.ganancias <> 0 then
                        percentage = int(earnings * 100 / apuestas.ganancias)
                    end if
                    
                    if earnings < 0 and apuestas.perdidas <> 0 then
                        percentage = int(earnings * 100 / apuestas.perdidas)
                    end if
                    
                    call writeconsolemsg(userindex, "entradas: " & apuestas.ganancias & " salida: " & apuestas.perdidas & " ganancia neta: " & earnings & " (" & percentage & "%) jugadas: " & apuestas.jugadas, fonttypenames.fonttype_info)
                end if
        end select
    end with
end sub

''
' handles the "petstand" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepetstand(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead people can't use pets
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make sure it's close enough
        if distancia(npclist(.flags.targetnpc).pos, .pos) > 10 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make sure it's his pet
        if npclist(.flags.targetnpc).maestrouser <> userindex then exit sub
        
        'do it!
        npclist(.flags.targetnpc).movement = tipoai.estatico
        
        call expresar(.flags.targetnpc, userindex)
    end with
end sub

''
' handles the "petfollow" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepetfollow(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead users can't use pets
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make sure it's close enough
        if distancia(npclist(.flags.targetnpc).pos, .pos) > 10 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make usre it's the user's pet
        if npclist(.flags.targetnpc).maestrouser <> userindex then exit sub
        
        'do it
        call followamo(.flags.targetnpc)
        
        call expresar(.flags.targetnpc, userindex)
    end with
end sub


''
' handles the "releasepet" message.
'
' @param    userindex the index of the user sending the message.

private sub handlereleasepet(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 18/11/2009
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead users can't use pets
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make sure it's close enough
        if distancia(npclist(.flags.targetnpc).pos, .pos) > 10 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make usre it's the user's pet
        if npclist(.flags.targetnpc).maestrouser <> userindex then exit sub
        
        'do it
        call quitarpet(userindex, .flags.targetnpc)
            
    end with
end sub

''
' handles the "trainlist" message.
'
' @param    userindex the index of the user sending the message.

private sub handletrainlist(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead users can't use pets
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make sure it's close enough
        if distancia(npclist(.flags.targetnpc).pos, .pos) > 10 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'make sure it's the trainer
        if npclist(.flags.targetnpc).npctype <> enpctype.entrenador then exit sub
        
        call writetrainercreaturelist(userindex, .flags.targetnpc)
    end with
end sub

''
' handles the "rest" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerest(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead users can't use pets
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!! solo puedes usar �tems cuando est�s vivo.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if hayobjarea(.pos, fogata) then
            call writerestok(userindex)
            
            if not .flags.descansar then
                call writeconsolemsg(userindex, "te acomod�s junto a la fogata y comienzas a descansar.", fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "te levantas.", fonttypenames.fonttype_info)
            end if
            
            .flags.descansar = not .flags.descansar
        else
            if .flags.descansar then
                call writerestok(userindex)
                call writeconsolemsg(userindex, "te levantas.", fonttypenames.fonttype_info)
                
                .flags.descansar = false
                exit sub
            end if
            
            call writeconsolemsg(userindex, "no hay ninguna fogata junto a la cual descansar.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "meditate" message.
'
' @param    userindex the index of the user sending the message.

private sub handlemeditate(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/15/08 (niconz)
'arregl� un bug que mandaba un index de la meditacion diferente
'al que decia el server.
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead users can't use pets
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!! s�lo puedes meditar cuando est�s vivo.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'can he meditate?
        if .stats.maxman = 0 then
             call writeconsolemsg(userindex, "s�lo las clases m�gicas conocen el arte de la meditaci�n.", fonttypenames.fonttype_info)
             exit sub
        end if
        
        'admins don't have to wait :d
        if not .flags.privilegios and playertype.user then
            .stats.minman = .stats.maxman
            call writeconsolemsg(userindex, "man� restaurado.", fonttypenames.fonttype_veneno)
            call writeupdatemana(userindex)
            exit sub
        end if
        
        call writemeditatetoggle(userindex)
        
        if .flags.meditando then _
           call writeconsolemsg(userindex, "dejas de meditar.", fonttypenames.fonttype_info)
        
        .flags.meditando = not .flags.meditando
        
        'barrin 3/10/03 tiempo de inicio al meditar
        if .flags.meditando then
            .counters.tiniciomeditar = gettickcount() and &h7fffffff
            
            call writeconsolemsg(userindex, "te est�s concentrando. en " & fix(tiempo_iniciomeditar / 1000) & " segundos comenzar�s a meditar.", fonttypenames.fonttype_info)
            
            .char.loops = infinite_loops
            
            'show proper fx according to level
            if .stats.elv < 13 then
                .char.fx = fxids.fxmeditarchico
            
            elseif .stats.elv < 25 then
                .char.fx = fxids.fxmeditarmediano
            
            elseif .stats.elv < 35 then
                .char.fx = fxids.fxmeditargrande
            
            elseif .stats.elv < 42 then
                .char.fx = fxids.fxmeditarxgrande
            
            else
                .char.fx = fxids.fxmeditarxxgrande
            end if
            
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, .char.fx, infinite_loops))
        else
            .counters.bpuedemeditar = false
            
            .char.fx = 0
            .char.loops = 0
            call senddata(sendtarget.topcarea, userindex, preparemessagecreatefx(.char.charindex, 0, 0))
        end if
    end with
end sub

''
' handles the "resucitate" message.
'
' @param    userindex the index of the user sending the message.

private sub handleresucitate(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'se asegura que el target es un npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate npc and make sure player is dead
        if (npclist(.flags.targetnpc).npctype <> enpctype.revividor _
            and (npclist(.flags.targetnpc).npctype <> enpctype.resucitadornewbie or not esnewbie(userindex))) _
            or .flags.muerto = 0 then exit sub
        
        'make sure it's close enough
        if distancia(.pos, npclist(.flags.targetnpc).pos) > 10 then
            call writeconsolemsg(userindex, "el sacerdote no puede resucitarte debido a que est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        call revivirusuario(userindex)
        call writeconsolemsg(userindex, "��has sido resucitado!!", fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "consultation" message.
'
' @param    userindex the index of the user sending the message.

private sub handleconsultation(byval userindex as string)
'***************************************************
'author: zama
'last modification: 01/05/2010
'habilita/deshabilita el modo consulta.
'01/05/2010: zama - agrego validaciones.
'***************************************************
    
    dim userconsulta as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        ' comando exclusivo para gms
        if not esgm(userindex) then exit sub
        
        userconsulta = .flags.targetuser
        
        'se asegura que el target es un usuario
        if userconsulta = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un usuario, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        ' no podes ponerte a vos mismo en modo consulta.
        if userconsulta = userindex then exit sub
        
        ' no podes estra en consulta con otro gm
        if esgm(userconsulta) then
            call writeconsolemsg(userindex, "no puedes iniciar el modo consulta con otro administrador.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        dim username as string
        username = userlist(userconsulta).name
        
        ' si ya estaba en consulta, termina la consulta
        if userlist(userconsulta).flags.enconsulta then
            call writeconsolemsg(userindex, "has terminado el modo consulta con " & username & ".", fonttypenames.fonttype_infobold)
            call writeconsolemsg(userconsulta, "has terminado el modo consulta.", fonttypenames.fonttype_infobold)
            call loggm(.name, "termino consulta con " & username)
            
            userlist(userconsulta).flags.enconsulta = false
        
        ' sino la inicia
        else
            call writeconsolemsg(userindex, "has iniciado el modo consulta con " & username & ".", fonttypenames.fonttype_infobold)
            call writeconsolemsg(userconsulta, "has iniciado el modo consulta.", fonttypenames.fonttype_infobold)
            call loggm(.name, "inicio consulta con " & username)
            
            with userlist(userconsulta)
                .flags.enconsulta = true
                
                ' pierde invi u ocu
                if .flags.invisible = 1 or .flags.oculto = 1 then
                    .flags.oculto = 0
                    .flags.invisible = 0
                    .counters.tiempooculto = 0
                    .counters.invisibilidad = 0
                    
                    call usuarios.setinvisible(userconsulta, userlist(userconsulta).char.charindex, false)
                end if
            end with
        end if
        
        call usuarios.setconsulatmode(userconsulta)
    end with

end sub

''
' handles the "heal" message.
'
' @param    userindex the index of the user sending the message.

private sub handleheal(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'se asegura que el target es un npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if (npclist(.flags.targetnpc).npctype <> enpctype.revividor _
            and npclist(.flags.targetnpc).npctype <> enpctype.resucitadornewbie) _
            or .flags.muerto <> 0 then exit sub
        
        if distancia(.pos, npclist(.flags.targetnpc).pos) > 10 then
            call writeconsolemsg(userindex, "el sacerdote no puede curarte debido a que est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        .stats.minhp = .stats.maxhp
        
        call writeupdatehp(userindex)
        
        call writeconsolemsg(userindex, "��has sido curado!!", fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "requeststats" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequeststats(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call senduserstatstxt(userindex, userindex)
end sub

''
' handles the "help" message.
'
' @param    userindex the index of the user sending the message.

private sub handlehelp(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call sendhelp(userindex)
end sub

''
' handles the "commercestart" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecommercestart(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as integer
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead people can't commerce
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'is it already in commerce mode??
        if .flags.comerciando then
            call writeconsolemsg(userindex, "ya est�s comerciando.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc > 0 then
            'does the npc want to trade??
            if npclist(.flags.targetnpc).comercia = 0 then
                if lenb(npclist(.flags.targetnpc).desc) <> 0 then
                    call writechatoverhead(userindex, "no tengo ning�n inter�s en comerciar.", npclist(.flags.targetnpc).char.charindex, vbwhite)
                end if
                
                exit sub
            end if
            
            if distancia(npclist(.flags.targetnpc).pos, .pos) > 3 then
                call writeconsolemsg(userindex, "est�s demasiado lejos del vendedor.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'start commerce....
            call iniciarcomercionpc(userindex)
        '[alejo]
        elseif .flags.targetuser > 0 then
            'user commerce...
            'can he commerce??
            if .flags.privilegios and playertype.consejero then
                call writeconsolemsg(userindex, "no puedes vender �tems.", fonttypenames.fonttype_warning)
                exit sub
            end if
            
            'is the other one dead??
            if userlist(.flags.targetuser).flags.muerto = 1 then
                call writeconsolemsg(userindex, "��no puedes comerciar con los muertos!!", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'is it me??
            if .flags.targetuser = userindex then
                call writeconsolemsg(userindex, "��no puedes comerciar con vos mismo!!", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'check distance
            if distancia(userlist(.flags.targetuser).pos, .pos) > 3 then
                call writeconsolemsg(userindex, "est�s demasiado lejos del usuario.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'is he already trading?? is it with me or someone else??
            if userlist(.flags.targetuser).flags.comerciando = true and _
                userlist(.flags.targetuser).comusu.destusu <> userindex then
                call writeconsolemsg(userindex, "no puedes comerciar con el usuario en este momento.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'initialize some variables...
            .comusu.destusu = .flags.targetuser
            .comusu.destnick = userlist(.flags.targetuser).name
            for i = 1 to max_offer_slots
                .comusu.cant(i) = 0
                .comusu.objeto(i) = 0
            next i
            .comusu.goldamount = 0
            
            .comusu.acepto = false
            .comusu.confirmo = false
            
            'rutina para comerciar con otro usuario
            call iniciarcomercioconusuario(userindex, .flags.targetuser)
        else
            call writeconsolemsg(userindex, "primero haz click izquierdo sobre el personaje.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "bankstart" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebankstart(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead people can't commerce
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if .flags.comerciando then
            call writeconsolemsg(userindex, "ya est�s comerciando.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc > 0 then
            if distancia(npclist(.flags.targetnpc).pos, .pos) > 3 then
                call writeconsolemsg(userindex, "est�s demasiado lejos del vendedor.", fonttypenames.fonttype_info)
                exit sub
            end if
            
            'if it's the banker....
            if npclist(.flags.targetnpc).npctype = enpctype.banquero then
                call iniciardeposito(userindex)
            end if
        else
            call writeconsolemsg(userindex, "primero haz click izquierdo sobre el personaje.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "enlist" message.
'
' @param    userindex the index of the user sending the message.

private sub handleenlist(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if npclist(.flags.targetnpc).npctype <> enpctype.noble _
            or .flags.muerto <> 0 then exit sub
        
        if distancia(.pos, npclist(.flags.targetnpc).pos) > 4 then
            call writeconsolemsg(userindex, "debes acercarte m�s.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if npclist(.flags.targetnpc).flags.faccion = 0 then
            call enlistararmadareal(userindex)
        else
            call enlistarcaos(userindex)
        end if
    end with
end sub

''
' handles the "information" message.
'
' @param    userindex the index of the user sending the message.

private sub handleinformation(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim matados as integer
    dim nextrecom as integer
    dim diferencia as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if npclist(.flags.targetnpc).npctype <> enpctype.noble _
                or .flags.muerto <> 0 then exit sub
        
        if distancia(.pos, npclist(.flags.targetnpc).pos) > 4 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        
        nextrecom = .faccion.nextrecompensa
        
        if npclist(.flags.targetnpc).flags.faccion = 0 then
            if .faccion.armadareal = 0 then
                call writechatoverhead(userindex, "��no perteneces a las tropas reales!!", npclist(.flags.targetnpc).char.charindex, vbwhite)
                exit sub
            end if
            
            matados = .faccion.criminalesmatados
            diferencia = nextrecom - matados
            
            if diferencia > 0 then
                call writechatoverhead(userindex, "tu deber es combatir criminales, mata " & diferencia & " criminales m�s y te dar� una recompensa.", npclist(.flags.targetnpc).char.charindex, vbwhite)
            else
                call writechatoverhead(userindex, "tu deber es combatir criminales, y ya has matado los suficientes como para merecerte una recompensa.", npclist(.flags.targetnpc).char.charindex, vbwhite)
            end if
        else
            if .faccion.fuerzascaos = 0 then
                call writechatoverhead(userindex, "��no perteneces a la legi�n oscura!!", npclist(.flags.targetnpc).char.charindex, vbwhite)
                exit sub
            end if
            
            matados = .faccion.ciudadanosmatados
            diferencia = nextrecom - matados
            
            if diferencia > 0 then
                call writechatoverhead(userindex, "tu deber es sembrar el caos y la desesperanza, mata " & diferencia & " ciudadanos m�s y te dar� una recompensa.", npclist(.flags.targetnpc).char.charindex, vbwhite)
            else
                call writechatoverhead(userindex, "tu deber es sembrar el caos y la desesperanza, y creo que est�s en condiciones de merecer una recompensa.", npclist(.flags.targetnpc).char.charindex, vbwhite)
            end if
        end if
    end with
end sub

''
' handles the "reward" message.
'
' @param    userindex the index of the user sending the message.

private sub handlereward(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if npclist(.flags.targetnpc).npctype <> enpctype.noble _
            or .flags.muerto <> 0 then exit sub
        
        if distancia(.pos, npclist(.flags.targetnpc).pos) > 4 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if npclist(.flags.targetnpc).flags.faccion = 0 then
             if .faccion.armadareal = 0 then
                 call writechatoverhead(userindex, "��no perteneces a las tropas reales!!", npclist(.flags.targetnpc).char.charindex, vbwhite)
                 exit sub
             end if
             call recompensaarmadareal(userindex)
        else
             if .faccion.fuerzascaos = 0 then
                 call writechatoverhead(userindex, "��no perteneces a la legi�n oscura!!", npclist(.flags.targetnpc).char.charindex, vbwhite)
                 exit sub
             end if
             call recompensacaos(userindex)
        end if
    end with
end sub

''
' handles the "requestmotd" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestmotd(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call sendmotd(userindex)
end sub

''
' handles the "uptime" message.
'
' @param    userindex the index of the user sending the message.

private sub handleuptime(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/10/08
'01/10/2008 - marcos martinez (byval) - automatic restart removed from the server along with all their assignments and varibles
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    dim time as long
    dim uptimestr as string
    
    'get total time in seconds
    time = ((gettickcount() and &h7fffffff) - tinicioserver) \ 1000
    
    'get times in dd:hh:mm:ss format
    uptimestr = (time mod 60) & " segundos."
    time = time \ 60
    
    uptimestr = (time mod 60) & " minutos, " & uptimestr
    time = time \ 60
    
    uptimestr = (time mod 24) & " horas, " & uptimestr
    time = time \ 24
    
    if time = 1 then
        uptimestr = time & " d�a, " & uptimestr
    else
        uptimestr = time & " d�as, " & uptimestr
    end if
    
    call writeconsolemsg(userindex, "server online: " & uptimestr, fonttypenames.fonttype_info)
end sub

''
' handles the "partyleave" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartyleave(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call mdparty.salirdeparty(userindex)
end sub

''
' handles the "partycreate" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartycreate(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    if not mdparty.puedecrearparty(userindex) then exit sub
    
    call mdparty.crearparty(userindex)
end sub

''
' handles the "partyjoin" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartyjoin(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call mdparty.solicitaringresoaparty(userindex)
end sub

''
' handles the "sharenpc" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesharenpc(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 15/04/2010
'shares owned npcs with other user
'***************************************************
    
    dim targetuserindex as integer
    dim sharinguserindex as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        ' didn't target any user
        targetuserindex = .flags.targetuser
        if targetuserindex = 0 then exit sub
        
        ' can't share with admins
        if esgm(targetuserindex) then
            call writeconsolemsg(userindex, "no puedes compartir npcs con administradores!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        ' pk or caos?
        if criminal(userindex) then
            ' caos can only share with other caos
            if escaos(userindex) then
                if not escaos(targetuserindex) then
                    call writeconsolemsg(userindex, "solo puedes compartir npcs con miembros de tu misma facci�n!!", fonttypenames.fonttype_info)
                    exit sub
                end if
                
            ' pks don't need to share with anyone
            else
                exit sub
            end if
        
        ' ciuda or army?
        else
            ' can't share
            if criminal(targetuserindex) then
                call writeconsolemsg(userindex, "no puedes compartir npcs con criminales!!", fonttypenames.fonttype_info)
                exit sub
            end if
        end if
        
        ' already sharing with target
        sharinguserindex = .flags.sharenpcwith
        if sharinguserindex = targetuserindex then exit sub
        
        ' aviso al usuario anterior que dejo de compartir
        if sharinguserindex <> 0 then
            call writeconsolemsg(sharinguserindex, .name & " ha dejado de compartir sus npcs contigo.", fonttypenames.fonttype_info)
            call writeconsolemsg(userindex, "has dejado de compartir tus npcs con " & userlist(sharinguserindex).name & ".", fonttypenames.fonttype_info)
        end if
        
        .flags.sharenpcwith = targetuserindex
        
        call writeconsolemsg(targetuserindex, .name & " ahora comparte sus npcs contigo.", fonttypenames.fonttype_info)
        call writeconsolemsg(userindex, "ahora compartes tus npcs con " & userlist(targetuserindex).name & ".", fonttypenames.fonttype_info)
        
    end with
    
end sub

''
' handles the "stopsharingnpc" message.
'
' @param    userindex the index of the user sending the message.

private sub handlestopsharingnpc(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 15/04/2010
'stop sharing owned npcs with other user
'***************************************************
    
    dim sharinguserindex as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        sharinguserindex = .flags.sharenpcwith
        
        if sharinguserindex <> 0 then
            
            ' aviso al que compartia y al que le compartia.
            call writeconsolemsg(sharinguserindex, .name & " ha dejado de compartir sus npcs contigo.", fonttypenames.fonttype_info)
            call writeconsolemsg(sharinguserindex, "has dejado de compartir tus npcs con " & userlist(sharinguserindex).name & ".", fonttypenames.fonttype_info)
            
            .flags.sharenpcwith = 0
        end if
        
    end with

end sub

''
' handles the "inquiry" message.
'
' @param    userindex the index of the user sending the message.

private sub handleinquiry(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    consultapopular.sendinfoencuesta (userindex)
end sub

''
' handles the "guildmessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildmessage(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 15/07/2009
'02/03/2009: zama - arreglado un indice mal pasado a la funcion de cartel de clanes overhead.
'15/07/2009: zama - now invisible admins only speak by console
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim chat as string
        
        chat = buffer.readasciistring()
        
        if lenb(chat) <> 0 then
            'analize chat...
            call statistics.parsechat(chat)
            
            if .guildindex > 0 then
                call senddata(sendtarget.todiosesyclan, .guildindex, preparemessageguildchat(.name & "> " & chat))
                
                if not (.flags.admininvisible = 1) then _
                    call senddata(sendtarget.toclanarea, userindex, preparemessagechatoverhead("< " & chat & " >", .char.charindex, vbyellow))
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "partymessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartymessage(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim chat as string
        
        chat = buffer.readasciistring()
        
        if lenb(chat) <> 0 then
            'analize chat...
            call statistics.parsechat(chat)
            
            call mdparty.broadcastparty(userindex, chat)
'todo : con la 0.12.1 se debe definir si esto vuelve o se borra (/cmsg overhead)
            'call senddata(sendtarget.topartyarea, userindex, userlist(userindex).pos.map, "||" & vbyellow & "�< " & mid$(rdata, 7) & " >�" & cstr(userlist(userindex).char.charindex))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "centinelreport" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecentinelreport(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        call centinelacheckclave(userindex, .incomingdata.readinteger())
    end with
end sub

''
' handles the "guildonline" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildonline(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim onlinelist as string
        
        onlinelist = modguilds.m_listademiembrosonline(userindex, .guildindex)
        
        if .guildindex <> 0 then
            call writeconsolemsg(userindex, "compa�eros de tu clan conectados: " & onlinelist, fonttypenames.fonttype_guildmsg)
        else
            call writeconsolemsg(userindex, "no pertences a ning�n clan.", fonttypenames.fonttype_guildmsg)
        end if
    end with
end sub

''
' handles the "partyonline" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartyonline(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    'remove packet id
    call userlist(userindex).incomingdata.readbyte
    
    call mdparty.onlineparty(userindex)
end sub

''
' handles the "councilmessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecouncilmessage(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim chat as string
        
        chat = buffer.readasciistring()
        
        if lenb(chat) <> 0 then
            'analize chat...
            call statistics.parsechat(chat)
            
            if .flags.privilegios and playertype.royalcouncil then
                call senddata(sendtarget.toconsejo, userindex, preparemessageconsolemsg("(consejero) " & .name & "> " & chat, fonttypenames.fonttype_consejo))
            elseif .flags.privilegios and playertype.chaoscouncil then
                call senddata(sendtarget.toconsejocaos, userindex, preparemessageconsolemsg("(consejero) " & .name & "> " & chat, fonttypenames.fonttype_consejocaos))
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "rolemasterrequest" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerolemasterrequest(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim request as string
        
        request = buffer.readasciistring()
        
        if lenb(request) <> 0 then
            call writeconsolemsg(userindex, "su solicitud ha sido enviada.", fonttypenames.fonttype_info)
            call senddata(sendtarget.torolesmasters, 0, preparemessageconsolemsg(.name & " pregunta rol: " & request, fonttypenames.fonttype_guildmsg))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "gmrequest" message.
'
' @param    userindex the index of the user sending the message.

private sub handlegmrequest(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if not ayuda.existe(.name) then
            call writeconsolemsg(userindex, "el mensaje ha sido entregado, ahora s�lo debes esperar que se desocupe alg�n gm.", fonttypenames.fonttype_info)
            call ayuda.push(.name)
        else
            call ayuda.quitar(.name)
            call ayuda.push(.name)
            call writeconsolemsg(userindex, "ya hab�as mandado un mensaje, tu mensaje ha sido movido al final de la cola de mensajes.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "bugreport" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebugreport(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        dim n as integer
        
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim bugreport as string
        
        bugreport = buffer.readasciistring()
        
        n = freefile
        open app.path & "\logs\bugs.log" for append shared as n
        print #n, "usuario:" & .name & "  fecha:" & date & "    hora:" & time
        print #n, "bug:"
        print #n, bugreport
        print #n, "########################################################################"
        close #n
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "changedescription" message.
'
' @param    userindex the index of the user sending the message.

private sub handlechangedescription(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim description as string
        
        description = buffer.readasciistring()
        
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "no puedes cambiar la descripci�n estando muerto.", fonttypenames.fonttype_info)
        else
            if not asciivalidos(description) then
                call writeconsolemsg(userindex, "la descripci�n tiene caracteres inv�lidos.", fonttypenames.fonttype_info)
            else
                .desc = trim$(description)
                call writeconsolemsg(userindex, "la descripci�n ha cambiado.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildvote" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildvote(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim vote as string
        dim errorstr as string
        
        vote = buffer.readasciistring()
        
        if not modguilds.v_usuariovota(userindex, vote, errorstr) then
            call writeconsolemsg(userindex, "voto no contabilizado: " & errorstr, fonttypenames.fonttype_guild)
        else
            call writeconsolemsg(userindex, "voto contabilizado.", fonttypenames.fonttype_guild)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "showguildnews" message.
'
' @param    userindex the index of the user sending the message.

private sub handleshowguildnews(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 05/17/06
'
'***************************************************
    
    with userlist(userindex)
        
        'remove packet id
        call .incomingdata.readbyte
        
        call modguilds.sendguildnews(userindex)
    end with
end sub

''
' handles the "punishments" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepunishments(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 25/08/2009
'25/08/2009: zama - now only admins can see other admins' punishment list
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim name as string
        dim count as integer
        
        name = buffer.readasciistring()
        
        if lenb(name) <> 0 then
            if (instrb(name, "\") <> 0) then
                name = replace(name, "\", "")
            end if
            if (instrb(name, "/") <> 0) then
                name = replace(name, "/", "")
            end if
            if (instrb(name, ":") <> 0) then
                name = replace(name, ":", "")
            end if
            if (instrb(name, "|") <> 0) then
                name = replace(name, "|", "")
            end if
            
            if (esadmin(name) or esdios(name) or essemidios(name) or esconsejero(name) or esrolesmaster(name)) and (userlist(userindex).flags.privilegios and playertype.user) then
                call writeconsolemsg(userindex, "no puedes ver las penas de los administradores.", fonttypenames.fonttype_info)
            else
                if fileexist(charpath & name & ".chr", vbnormal) then
                    count = val(getvar(charpath & name & ".chr", "penas", "cant"))
                    if count = 0 then
                        call writeconsolemsg(userindex, "sin prontuario..", fonttypenames.fonttype_info)
                    else
                        while count > 0
                            call writeconsolemsg(userindex, count & " - " & getvar(charpath & name & ".chr", "penas", "p" & count), fonttypenames.fonttype_info)
                            count = count - 1
                        wend
                    end if
                else
                    call writeconsolemsg(userindex, "personaje """ & name & """ inexistente.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "changepassword" message.
'
' @param    userindex the index of the user sending the message.

private sub handlechangepassword(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'creation date: 10/10/07
'last modified by: rapsodius
'***************************************************
#if seguridadalkon then
    if userlist(userindex).incomingdata.length < 65 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
#else
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
#end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        dim oldpass as string
        dim newpass as string
        dim oldpass2 as string
        
        'remove packet id
        call buffer.readbyte
        
#if seguridadalkon then
        oldpass = ucase$(buffer.readasciistringfixed(32))
        newpass = ucase$(buffer.readasciistringfixed(32))
#else
        oldpass = ucase$(buffer.readasciistring())
        newpass = ucase$(buffer.readasciistring())
#end if
        
        if lenb(newpass) = 0 then
            call writeconsolemsg(userindex, "debes especificar una contrase�a nueva, int�ntalo de nuevo.", fonttypenames.fonttype_info)
        else
            oldpass2 = ucase$(getvar(charpath & userlist(userindex).name & ".chr", "init", "password"))
            
            if oldpass2 <> oldpass then
                call writeconsolemsg(userindex, "la contrase�a actual proporcionada no es correcta. la contrase�a no ha sido cambiada, int�ntalo de nuevo.", fonttypenames.fonttype_info)
            else
                call writevar(charpath & userlist(userindex).name & ".chr", "init", "password", newpass)
                call writeconsolemsg(userindex, "la contrase�a fue cambiada con �xito.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "gamble" message.
'
' @param    userindex the index of the user sending the message.

private sub handlegamble(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim amount as integer
        
        amount = .incomingdata.readinteger()
        
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
        elseif .flags.targetnpc = 0 then
            'validate target npc
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
        elseif distancia(npclist(.flags.targetnpc).pos, .pos) > 10 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
        elseif npclist(.flags.targetnpc).npctype <> enpctype.timbero then
            call writechatoverhead(userindex, "no tengo ning�n inter�s en apostar.", npclist(.flags.targetnpc).char.charindex, vbwhite)
        elseif amount < 1 then
            call writechatoverhead(userindex, "el m�nimo de apuesta es 1 moneda.", npclist(.flags.targetnpc).char.charindex, vbwhite)
        elseif amount > 5000 then
            call writechatoverhead(userindex, "el m�ximo de apuesta es 5000 monedas.", npclist(.flags.targetnpc).char.charindex, vbwhite)
        elseif .stats.gld < amount then
            call writechatoverhead(userindex, "no tienes esa cantidad.", npclist(.flags.targetnpc).char.charindex, vbwhite)
        else
            if randomnumber(1, 100) <= 47 then
                .stats.gld = .stats.gld + amount
                call writechatoverhead(userindex, "�felicidades! has ganado " & cstr(amount) & " monedas de oro.", npclist(.flags.targetnpc).char.charindex, vbwhite)
                
                apuestas.perdidas = apuestas.perdidas + amount
                call writevar(datpath & "apuestas.dat", "main", "perdidas", cstr(apuestas.perdidas))
            else
                .stats.gld = .stats.gld - amount
                call writechatoverhead(userindex, "lo siento, has perdido " & cstr(amount) & " monedas de oro.", npclist(.flags.targetnpc).char.charindex, vbwhite)
                
                apuestas.ganancias = apuestas.ganancias + amount
                call writevar(datpath & "apuestas.dat", "main", "ganancias", cstr(apuestas.ganancias))
            end if
            
            apuestas.jugadas = apuestas.jugadas + 1
            
            call writevar(datpath & "apuestas.dat", "main", "jugadas", cstr(apuestas.jugadas))
            
            call writeupdategold(userindex)
        end if
    end with
end sub

''
' handles the "inquiryvote" message.
'
' @param    userindex the index of the user sending the message.

private sub handleinquiryvote(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim opt as byte
        
        opt = .incomingdata.readbyte()
        
        call writeconsolemsg(userindex, consultapopular.dovotar(userindex, opt), fonttypenames.fonttype_guild)
    end with
end sub

''
' handles the "bankextractgold" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebankextractgold(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim amount as long
        
        amount = .incomingdata.readlong()
        
        'dead people can't leave a faction.. they can't talk...
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc = 0 then
             call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
             exit sub
        end if
        
        if npclist(.flags.targetnpc).npctype <> enpctype.banquero then exit sub
        
        if distancia(.pos, npclist(.flags.targetnpc).pos) > 10 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if amount > 0 and amount <= .stats.banco then
             .stats.banco = .stats.banco - amount
             .stats.gld = .stats.gld + amount
             call writechatoverhead(userindex, "ten�s " & .stats.banco & " monedas de oro en tu cuenta.", npclist(.flags.targetnpc).char.charindex, vbwhite)
        else
            call writechatoverhead(userindex, "no tienes esa cantidad.", npclist(.flags.targetnpc).char.charindex, vbwhite)
        end if
        
        call writeupdategold(userindex)
        call writeupdatebankgold(userindex)
    end with
end sub

''
' handles the "leavefaction" message.
'
' @param    userindex the index of the user sending the message.

private sub handleleavefaction(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************

    dim talktoking as boolean
    dim talktodemon as boolean
    dim npcindex as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        'dead people can't leave a faction.. they can't talk...
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        ' chequea si habla con el rey o el demonio. puede salir sin hacerlo, pero si lo hace le reponden los npcs
        npcindex = .flags.targetnpc
        if npcindex <> 0 then
            ' es rey o domonio?
            if npclist(npcindex).npctype = enpctype.noble then
                'rey?
                if npclist(npcindex).flags.faccion = 0 then
                    talktoking = true
                ' demonio
                else
                    talktodemon = true
                end if
            end if
        end if
               
        'quit the royal army?
        if .faccion.armadareal = 1 then
            ' si le pidio al demonio salir de la armada, este le responde.
            if talktodemon then
                call writechatoverhead(userindex, "���sal de aqu� buf�n!!!", _
                                       npclist(npcindex).char.charindex, vbwhite)
            
            else
                ' si le pidio al rey salir de la armada, le responde.
                if talktoking then
                    call writechatoverhead(userindex, "ser�s bienvenido a las fuerzas imperiales si deseas regresar.", _
                                           npclist(npcindex).char.charindex, vbwhite)
                end if
                
                call expulsarfaccionreal(userindex, false)
                
            end if
        
        'quit the chaos legion?
        elseif .faccion.fuerzascaos = 1 then
            ' si le pidio al rey salir del caos, le responde.
            if talktoking then
                call writechatoverhead(userindex, "���sal de aqu� maldito criminal!!!", _
                                       npclist(npcindex).char.charindex, vbwhite)
            else
                ' si le pidio al demonio salir del caos, este le responde.
                if talktodemon then
                    call writechatoverhead(userindex, "ya volver�s arrastrandote.", _
                                           npclist(npcindex).char.charindex, vbwhite)
                end if
                
                call expulsarfaccioncaos(userindex, false)
            end if
        ' no es faccionario
        else
        
            ' si le hablaba al rey o demonio, le repsonden ellos
            if npcindex > 0 then
                call writechatoverhead(userindex, "�no perteneces a ninguna facci�n!", _
                                       npclist(npcindex).char.charindex, vbwhite)
            else
                call writeconsolemsg(userindex, "�no perteneces a ninguna facci�n!", fonttypenames.fonttype_fight)
            end if
        
        end if
        
    end with
    
end sub

''
' handles the "bankdepositgold" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebankdepositgold(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim amount as long
        
        amount = .incomingdata.readlong()
        
        'dead people can't leave a faction.. they can't talk...
        if .flags.muerto = 1 then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_info)
            exit sub
        end if
        
        'validate target npc
        if .flags.targetnpc = 0 then
            call writeconsolemsg(userindex, "primero tienes que seleccionar un personaje, haz click izquierdo sobre �l.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if distancia(npclist(.flags.targetnpc).pos, .pos) > 10 then
            call writeconsolemsg(userindex, "est�s demasiado lejos.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if npclist(.flags.targetnpc).npctype <> enpctype.banquero then exit sub
        
        if amount > 0 and amount <= .stats.gld then
            .stats.banco = .stats.banco + amount
            .stats.gld = .stats.gld - amount
            call writechatoverhead(userindex, "ten�s " & .stats.banco & " monedas de oro en tu cuenta.", npclist(.flags.targetnpc).char.charindex, vbwhite)
            
            call writeupdategold(userindex)
            call writeupdatebankgold(userindex)
        else
            call writechatoverhead(userindex, "no ten�s esa cantidad.", npclist(.flags.targetnpc).char.charindex, vbwhite)
        end if
    end with
end sub

''
' handles the "denounce" message.
'
' @param    userindex the index of the user sending the message.

private sub handledenounce(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim text as string
        
        text = buffer.readasciistring()
        
        if .flags.silenciado = 0 then
            'analize chat...
            call statistics.parsechat(text)
            
            call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg(lcase$(.name) & " denuncia: " & text, fonttypenames.fonttype_guildmsg))
            call writeconsolemsg(userindex, "denuncia enviada, espere..", fonttypenames.fonttype_info)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildfundate" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildfundate(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 14/12/2009
'
'***************************************************
    if userlist(userindex).incomingdata.length < 1 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        call .incomingdata.readbyte
        
        if hasfound(.name) then
            call writeconsolemsg(userindex, "�ya has fundado un clan, no puedes fundar otro!", fonttypenames.fonttype_infobold)
            exit sub
        end if
        
        call writeshowguildalign(userindex)
    end with
end sub
    
''
' handles the "guildfundation" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildfundation(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 14/12/2009
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim clantype as eclantype
        dim error as string
        
        clantype = .incomingdata.readbyte()
        
        if hasfound(.name) then
            call writeconsolemsg(userindex, "�ya has fundado un clan, no puedes fundar otro!", fonttypenames.fonttype_infobold)
            call logcheating("el usuario " & .name & " ha intentado fundar un clan ya habiendo fundado otro desde la ip " & .ip)
            exit sub
        end if
        
        select case ucase$(trim(clantype))
            case eclantype.ct_royalarmy
                .fundandoguildalineacion = alineacion_armada
            case eclantype.ct_evil
                .fundandoguildalineacion = alineacion_legion
            case eclantype.ct_neutral
                .fundandoguildalineacion = alineacion_neutro
            case eclantype.ct_gm
                .fundandoguildalineacion = alineacion_master
            case eclantype.ct_legal
                .fundandoguildalineacion = alineacion_ciuda
            case eclantype.ct_criminal
                .fundandoguildalineacion = alineacion_criminal
            case else
                call writeconsolemsg(userindex, "alineaci�n inv�lida.", fonttypenames.fonttype_guild)
                exit sub
        end select
        
        if modguilds.puedefundarunclan(userindex, .fundandoguildalineacion, error) then
            call writeshowguildfundationform(userindex)
        else
            .fundandoguildalineacion = 0
            call writeconsolemsg(userindex, error, fonttypenames.fonttype_guild)
        end if
    end with
end sub

''
' handles the "partykick" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartykick(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/05/09
'last modification by: marco vanotti (marco)
'- 05/05/09: now it uses "userpuedeejecutarcomandos" to check if the user can use party commands
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if userpuedeejecutarcomandos(userindex) then
            tuser = nameindex(username)
            
            if tuser > 0 then
                call mdparty.expulsardeparty(userindex, tuser)
            else
                if instr(username, "+") then
                    username = replace(username, "+", " ")
                end if
                
                call writeconsolemsg(userindex, lcase(username) & " no pertenece a tu party.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "partysetleader" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartysetleader(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/05/09
'last modification by: marco vanotti (markoxx)
'- 05/05/09: now it uses "userpuedeejecutarcomandos" to check if the user can use party commands
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
'on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim rank as integer
        rank = playertype.admin or playertype.dios or playertype.semidios or playertype.consejero
        
        username = buffer.readasciistring()
        if userpuedeejecutarcomandos(userindex) then
            tuser = nameindex(username)
            if tuser > 0 then
                'don't allow users to spoof online gms
                if (userdarprivilegiolevel(username) and rank) <= (.flags.privilegios and rank) then
                    call mdparty.transformarenlider(userindex, tuser)
                else
                    call writeconsolemsg(userindex, lcase(userlist(tuser).name) & " no pertenece a tu party.", fonttypenames.fonttype_info)
                end if
                
            else
                if instr(username, "+") then
                    username = replace(username, "+", " ")
                end if
                call writeconsolemsg(userindex, lcase(username) & " no pertenece a tu party.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "partyacceptmember" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartyacceptmember(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/05/09
'last modification by: marco vanotti (marco)
'- 05/05/09: now it uses "userpuedeejecutarcomandos" to check if the user can use party commands
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim rank as integer
        dim buservivo as boolean
        
        rank = playertype.admin or playertype.dios or playertype.semidios or playertype.consejero
        
        username = buffer.readasciistring()
        if userlist(userindex).flags.muerto then
            call writeconsolemsg(userindex, "��est�s muerto!!", fonttypenames.fonttype_party)
        else
            buservivo = true
        end if
        
        if mdparty.userpuedeejecutarcomandos(userindex) and buservivo then
            tuser = nameindex(username)
            if tuser > 0 then
                'validate administrative ranks - don't allow users to spoof online gms
                if (userlist(tuser).flags.privilegios and rank) <= (.flags.privilegios and rank) then
                    call mdparty.aprobaringresoaparty(userindex, tuser)
                else
                    call writeconsolemsg(userindex, "no puedes incorporar a tu party a personajes de mayor jerarqu�a.", fonttypenames.fonttype_info)
                end if
            else
                if instr(username, "+") then
                    username = replace(username, "+", " ")
                end if
                
                'don't allow users to spoof online gms
                if (userdarprivilegiolevel(username) and rank) <= (.flags.privilegios and rank) then
                    call writeconsolemsg(userindex, lcase(username) & " no ha solicitado ingresar a tu party.", fonttypenames.fonttype_party)
                else
                    call writeconsolemsg(userindex, "no puedes incorporar a tu party a personajes de mayor jerarqu�a.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "guildmemberlist" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildmemberlist(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        dim membercount as integer
        dim i as long
        dim username as string
        
        guild = buffer.readasciistring()
        
        if .flags.privilegios and (playertype.admin or playertype.dios) then
            if (instrb(guild, "\") <> 0) then
                guild = replace(guild, "\", "")
            end if
            if (instrb(guild, "/") <> 0) then
                guild = replace(guild, "/", "")
            end if
            
            if not fileexist(app.path & "\guilds\" & guild & "-members.mem") then
                call writeconsolemsg(userindex, "no existe el clan: " & guild, fonttypenames.fonttype_info)
            else
                membercount = val(getvar(app.path & "\guilds\" & guild & "-members" & ".mem", "init", "nromembers"))
                
                for i = 1 to membercount
                    username = getvar(app.path & "\guilds\" & guild & "-members" & ".mem", "members", "member" & i)
                    
                    call writeconsolemsg(userindex, username & "<" & guild & ">", fonttypenames.fonttype_info)
                next i
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "gmmessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handlegmmessage(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/08/07
'last modification by: (liquid)
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        
        message = buffer.readasciistring()
        
        if not .flags.privilegios and playertype.user then
            call loggm(.name, "mensaje a gms:" & message)
        
            if lenb(message) <> 0 then
                'analize chat...
                call statistics.parsechat(message)
            
                call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg(.name & "> " & message, fonttypenames.fonttype_gmmsg))
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "showname" message.
'
' @param    userindex the index of the user sending the message.

private sub handleshowname(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
            .showname = not .showname 'show / hide the name
            
            call refreshcharstatus(userindex)
        end if
    end with
end sub

''
' handles the "onlineroyalarmy" message.
'
' @param    userindex the index of the user sending the message.

private sub handleonlineroyalarmy(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        .incomingdata.readbyte
        
        if .flags.privilegios and playertype.user then exit sub
    
        dim i as long
        dim list as string

        for i = 1 to lastuser
            if userlist(i).connid <> -1 then
                if userlist(i).faccion.armadareal = 1 then
                    if userlist(i).flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) or _
                      .flags.privilegios and (playertype.dios or playertype.admin) then
                        list = list & userlist(i).name & ", "
                    end if
                end if
            end if
        next i
    end with
    
    if len(list) > 0 then
        call writeconsolemsg(userindex, "reales conectados: " & left$(list, len(list) - 2), fonttypenames.fonttype_info)
    else
        call writeconsolemsg(userindex, "no hay reales conectados.", fonttypenames.fonttype_info)
    end if
end sub

''
' handles the "onlinechaoslegion" message.
'
' @param    userindex the index of the user sending the message.

private sub handleonlinechaoslegion(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        .incomingdata.readbyte
        
        if .flags.privilegios and playertype.user then exit sub
    
        dim i as long
        dim list as string

        for i = 1 to lastuser
            if userlist(i).connid <> -1 then
                if userlist(i).faccion.fuerzascaos = 1 then
                    if userlist(i).flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) or _
                      .flags.privilegios and (playertype.dios or playertype.admin) then
                        list = list & userlist(i).name & ", "
                    end if
                end if
            end if
        next i
    end with

    if len(list) > 0 then
        call writeconsolemsg(userindex, "caos conectados: " & left$(list, len(list) - 2), fonttypenames.fonttype_info)
    else
        call writeconsolemsg(userindex, "no hay caos conectados.", fonttypenames.fonttype_info)
    end if
end sub

''
' handles the "gonearby" message.
'
' @param    userindex the index of the user sending the message.

private sub handlegonearby(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/10/07
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        
        username = buffer.readasciistring()
        
        dim tindex as integer
        dim x as long
        dim y as long
        dim i as long
        dim found as boolean
        
        tindex = nameindex(username)
        
        'check the user has enough powers
        if .flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios or playertype.consejero) then
            'si es dios o admins no podemos salvo que nosotros tambi�n lo seamos
            if not (esdios(username) or esadmin(username)) or (.flags.privilegios and (playertype.dios or playertype.admin)) then
                if tindex <= 0 then 'existe el usuario destino?
                    call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
                else
                    for i = 2 to 5 'esto for sirve ir cambiando la distancia destino
                        for x = userlist(tindex).pos.x - i to userlist(tindex).pos.x + i
                            for y = userlist(tindex).pos.y - i to userlist(tindex).pos.y + i
                                if mapdata(userlist(tindex).pos.map, x, y).userindex = 0 then
                                    if legalpos(userlist(tindex).pos.map, x, y, true, true) then
                                        call warpuserchar(userindex, userlist(tindex).pos.map, x, y, true)
                                        call loggm(.name, "/ircerca " & username & " mapa:" & userlist(tindex).pos.map & " x:" & userlist(tindex).pos.x & " y:" & userlist(tindex).pos.y)
                                        found = true
                                        exit for
                                    end if
                                end if
                            next y
                            
                            if found then exit for  ' feo, pero hay que abortar 3 fors sin usar goto
                        next x
                        
                        if found then exit for  ' feo, pero hay que abortar 3 fors sin usar goto
                    next i
                    
                    'no space found??
                    if not found then
                        call writeconsolemsg(userindex, "todos los lugares est�n ocupados.", fonttypenames.fonttype_info)
                    end if
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "comment" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecomment(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim comment as string
        comment = buffer.readasciistring()
        
        if not .flags.privilegios and playertype.user then
            call loggm(.name, "comentario: " & comment)
            call writeconsolemsg(userindex, "comentario salvado...", fonttypenames.fonttype_info)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "servertime" message.
'
' @param    userindex the index of the user sending the message.

private sub handleservertime(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/08/07
'last modification by: (liquid)
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
    
        if .flags.privilegios and playertype.user then exit sub
    
        call loggm(.name, "hora.")
    end with
    
    call modsenddata.senddata(sendtarget.toall, 0, preparemessageconsolemsg("hora: " & time & " " & date, fonttypenames.fonttype_info))
end sub

''
' handles the "where" message.
'
' @param    userindex the index of the user sending the message.

private sub handlewhere(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if not .flags.privilegios and playertype.user then
            tuser = nameindex(username)
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
            else
                if (userlist(tuser).flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios)) <> 0 or ((userlist(tuser).flags.privilegios and (playertype.dios or playertype.admin) <> 0) and (.flags.privilegios and (playertype.dios or playertype.admin)) <> 0) then
                    call writeconsolemsg(userindex, "ubicaci�n  " & username & ": " & userlist(tuser).pos.map & ", " & userlist(tuser).pos.x & ", " & userlist(tuser).pos.y & ".", fonttypenames.fonttype_info)
                    call loggm(.name, "/donde " & username)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "creaturesinmap" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecreaturesinmap(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 30/07/06
'pablo (toxicwaste): modificaciones generales para simplificar la visualizaci�n.
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim map as integer
        dim i, j as long
        dim npccount1, npccount2 as integer
        dim npccant1() as integer
        dim npccant2() as integer
        dim list1() as string
        dim list2() as string
        
        map = .incomingdata.readinteger()
        
        if .flags.privilegios and playertype.user then exit sub
        
        if mapavalido(map) then
            for i = 1 to lastnpc
                'vb isn't lazzy, so we put more restrictive condition first to speed up the process
                if npclist(i).pos.map = map then
                    '�esta vivo?
                    if npclist(i).flags.npcactive and npclist(i).hostile = 1 and npclist(i).stats.alineacion = 2 then
                        if npccount1 = 0 then
                            redim list1(0) as string
                            redim npccant1(0) as integer
                            npccount1 = 1
                            list1(0) = npclist(i).name & ": (" & npclist(i).pos.x & "," & npclist(i).pos.y & ")"
                            npccant1(0) = 1
                        else
                            for j = 0 to npccount1 - 1
                                if left$(list1(j), len(npclist(i).name)) = npclist(i).name then
                                    list1(j) = list1(j) & ", (" & npclist(i).pos.x & "," & npclist(i).pos.y & ")"
                                    npccant1(j) = npccant1(j) + 1
                                    exit for
                                end if
                            next j
                            if j = npccount1 then
                                redim preserve list1(0 to npccount1) as string
                                redim preserve npccant1(0 to npccount1) as integer
                                npccount1 = npccount1 + 1
                                list1(j) = npclist(i).name & ": (" & npclist(i).pos.x & "," & npclist(i).pos.y & ")"
                                npccant1(j) = 1
                            end if
                        end if
                    else
                        if npccount2 = 0 then
                            redim list2(0) as string
                            redim npccant2(0) as integer
                            npccount2 = 1
                            list2(0) = npclist(i).name & ": (" & npclist(i).pos.x & "," & npclist(i).pos.y & ")"
                            npccant2(0) = 1
                        else
                            for j = 0 to npccount2 - 1
                                if left$(list2(j), len(npclist(i).name)) = npclist(i).name then
                                    list2(j) = list2(j) & ", (" & npclist(i).pos.x & "," & npclist(i).pos.y & ")"
                                    npccant2(j) = npccant2(j) + 1
                                    exit for
                                end if
                            next j
                            if j = npccount2 then
                                redim preserve list2(0 to npccount2) as string
                                redim preserve npccant2(0 to npccount2) as integer
                                npccount2 = npccount2 + 1
                                list2(j) = npclist(i).name & ": (" & npclist(i).pos.x & "," & npclist(i).pos.y & ")"
                                npccant2(j) = 1
                            end if
                        end if
                    end if
                end if
            next i
            
            call writeconsolemsg(userindex, "npcs hostiles en mapa: ", fonttypenames.fonttype_warning)
            if npccount1 = 0 then
                call writeconsolemsg(userindex, "no hay npcs hostiles.", fonttypenames.fonttype_info)
            else
                for j = 0 to npccount1 - 1
                    call writeconsolemsg(userindex, npccant1(j) & " " & list1(j), fonttypenames.fonttype_info)
                next j
            end if
            call writeconsolemsg(userindex, "otros npcs en mapa: ", fonttypenames.fonttype_warning)
            if npccount2 = 0 then
                call writeconsolemsg(userindex, "no hay m�s npcs.", fonttypenames.fonttype_info)
            else
                for j = 0 to npccount2 - 1
                    call writeconsolemsg(userindex, npccant2(j) & " " & list2(j), fonttypenames.fonttype_info)
                next j
            end if
            call loggm(.name, "numero enemigos en mapa " & map)
        end if
    end with
end sub

''
' handles the "warpmetotarget" message.
'
' @param    userindex the index of the user sending the message.

private sub handlewarpmetotarget(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 26/03/09
'26/03/06: zama - chequeo que no se teletransporte donde haya un char o npc
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim x as integer
        dim y as integer
        
        if .flags.privilegios and playertype.user then exit sub
        
        x = .flags.targetx
        y = .flags.targety
        
        call findlegalpos(userindex, .flags.targetmap, x, y)
        call warpuserchar(userindex, .flags.targetmap, x, y, true)
        call loggm(.name, "/teleploc a x:" & .flags.targetx & " y:" & .flags.targety & " map:" & .pos.map)
    end with
end sub

''
' handles the "warpchar" message.
'
' @param    userindex the index of the user sending the message.

private sub handlewarpchar(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 26/03/2009
'26/03/2009: zama -  chequeo que no se teletransporte a un tile donde haya un char o npc.
'***************************************************
    if userlist(userindex).incomingdata.length < 7 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim map as integer
        dim x as integer
        dim y as integer
        dim tuser as integer
        
        username = buffer.readasciistring()
        map = buffer.readinteger()
        x = buffer.readbyte()
        y = buffer.readbyte()
        
        if not .flags.privilegios and playertype.user then
            if mapavalido(map) and lenb(username) <> 0 then
                if ucase$(username) <> "yo" then
                    if not .flags.privilegios and playertype.consejero then
                        tuser = nameindex(username)
                    end if
                else
                    tuser = userindex
                end if
            
                if tuser <= 0 then
                    call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
                elseif inmapbounds(map, x, y) then
                    call findlegalpos(tuser, map, x, y)
                    call warpuserchar(tuser, map, x, y, true, true)
                    call writeconsolemsg(userindex, userlist(tuser).name & " transportado.", fonttypenames.fonttype_info)
                    call loggm(.name, "transport� a " & userlist(tuser).name & " hacia " & "mapa" & map & " x:" & x & " y:" & y)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "silence" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesilence(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if not .flags.privilegios and playertype.user then
            tuser = nameindex(username)
        
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
            else
                if userlist(tuser).flags.silenciado = 0 then
                    userlist(tuser).flags.silenciado = 1
                    call writeconsolemsg(userindex, "usuario silenciado.", fonttypenames.fonttype_info)
                    call writeshowmessagebox(tuser, "estimado usuario, ud. ha sido silenciado por los administradores. sus denuncias ser�n ignoradas por el servidor de aqu� en m�s. utilice /gm para contactar un administrador.")
                    call loggm(.name, "/silenciar " & userlist(tuser).name)
                
                    'flush the other user's buffer
                    call flushbuffer(tuser)
                else
                    userlist(tuser).flags.silenciado = 0
                    call writeconsolemsg(userindex, "usuario des silenciado.", fonttypenames.fonttype_info)
                    call loggm(.name, "/dessilenciar " & userlist(tuser).name)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "sosshowlist" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesosshowlist(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and playertype.user then exit sub
        call writeshowsosform(userindex)
    end with
end sub

''
' handles the "requestpartyform" message.
'
' @param    userindex the index of the user sending the message.

private sub handlepartyform(byval userindex as integer)
'***************************************************
'author: budi
'last modification: 11/26/09
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        if .partyindex > 0 then
            call writeshowpartyform(userindex)
            
        else
            call writeconsolemsg(userindex, "no perteneces a ning�n grupo!", fonttypenames.fonttype_infobold)
        end if
    end with
end sub

''
' handles the "itemupgrade" message.
'
' @param    userindex the index of the user sending the message.

private sub handleitemupgrade(byval userindex as integer)
'***************************************************
'author: torres patricio
'last modification: 12/09/09
'
'***************************************************
    with userlist(userindex)
        dim itemindex as integer
        
        'remove packet id
        call .incomingdata.readbyte
        
        itemindex = .incomingdata.readinteger()
        
        if itemindex <= 0 then exit sub
        if not tieneobjetos(itemindex, 1, userindex) then exit sub
        
        call doupgrade(userindex, itemindex)
    end with
end sub

''
' handles the "sosremove" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesosremove(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        username = buffer.readasciistring()
        
        if not .flags.privilegios and playertype.user then _
            call ayuda.quitar(username)
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "gotochar" message.
'
' @param    userindex the index of the user sending the message.

private sub handlegotochar(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 26/03/2009
'26/03/2009: zama -  chequeo que no se teletransporte a un tile donde haya un char o npc.
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim x as integer
        dim y as integer
        
        username = buffer.readasciistring()
        tuser = nameindex(username)
        
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.semidios or playertype.consejero) then
            'si es dios o admins no podemos salvo que nosotros tambi�n lo seamos
            if not (esdios(username) or esadmin(username)) or (.flags.privilegios and (playertype.dios or playertype.admin)) <> 0 then
                if tuser <= 0 then
                    call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
                else
                    x = userlist(tuser).pos.x
                    y = userlist(tuser).pos.y + 1
                    call findlegalpos(userindex, userlist(tuser).pos.map, x, y)
                    
                    call warpuserchar(userindex, userlist(tuser).pos.map, x, y, true)
                    
                    if .flags.admininvisible = 0 then
                        call writeconsolemsg(tuser, .name & " se ha trasportado hacia donde te encuentras.", fonttypenames.fonttype_info)
                        call flushbuffer(tuser)
                    end if
                    
                    call loggm(.name, "/ira " & username & " mapa:" & userlist(tuser).pos.map & " x:" & userlist(tuser).pos.x & " y:" & userlist(tuser).pos.y)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "invisible" message.
'
' @param    userindex the index of the user sending the message.

private sub handleinvisible(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and playertype.user then exit sub
        
        call doadmininvisible(userindex)
        call loggm(.name, "/invisible")
    end with
end sub

''
' handles the "gmpanel" message.
'
' @param    userindex the index of the user sending the message.

private sub handlegmpanel(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and playertype.user then exit sub
        
        call writeshowgmpanelform(userindex)
    end with
end sub

''
' handles the "gmpanel" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestuserlist(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/09/07
'last modified by: lucas tavolaro ortiz (tavo)
'i haven`t found a solution to split, so i make an array of names
'***************************************************
    dim i as long
    dim names() as string
    dim count as long
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.rolemaster) then exit sub
        
        redim names(1 to lastuser) as string
        count = 1
        
        for i = 1 to lastuser
            if (lenb(userlist(i).name) <> 0) then
                if userlist(i).flags.privilegios and playertype.user then
                    names(count) = userlist(i).name
                    count = count + 1
                end if
            end if
        next i
        
        if count > 1 then call writeusernamelist(userindex, names(), count - 1)
    end with
end sub

''
' handles the "working" message.
'
' @param    userindex the index of the user sending the message.

private sub handleworking(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as long
    dim users as string
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.rolemaster) then exit sub
        
        for i = 1 to lastuser
            if userlist(i).flags.userlogged and userlist(i).counters.trabajando > 0 then
                users = users & ", " & userlist(i).name
                
                ' display the user being checked by the centinel
                if modcentinela.centinela.revisandouserindex = i then _
                    users = users & " (*)"
            end if
        next i
        
        if lenb(users) <> 0 then
            users = right$(users, len(users) - 2)
            call writeconsolemsg(userindex, "usuarios trabajando: " & users, fonttypenames.fonttype_info)
        else
            call writeconsolemsg(userindex, "no hay usuarios trabajando.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "hiding" message.
'
' @param    userindex the index of the user sending the message.

private sub handlehiding(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    dim i as long
    dim users as string
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.rolemaster) then exit sub
        
        for i = 1 to lastuser
            if (lenb(userlist(i).name) <> 0) and userlist(i).counters.ocultando > 0 then
                users = users & userlist(i).name & ", "
            end if
        next i
        
        if lenb(users) <> 0 then
            users = left$(users, len(users) - 2)
            call writeconsolemsg(userindex, "usuarios ocultandose: " & users, fonttypenames.fonttype_info)
        else
            call writeconsolemsg(userindex, "no hay usuarios ocultandose.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "jail" message.
'
' @param    userindex the index of the user sending the message.

private sub handlejail(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim reason as string
        dim jailtime as byte
        dim count as byte
        dim tuser as integer
        
        username = buffer.readasciistring()
        reason = buffer.readasciistring()
        jailtime = buffer.readbyte()
        
        if instr(1, username, "+") then
            username = replace(username, "+", " ")
        end if
        
        '/carcel nick@motivo@<tiempo>
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (not .flags.privilegios and playertype.user) <> 0 then
            if lenb(username) = 0 or lenb(reason) = 0 then
                call writeconsolemsg(userindex, "utilice /carcel nick@motivo@tiempo", fonttypenames.fonttype_info)
            else
                tuser = nameindex(username)
                
                if tuser <= 0 then
                    call writeconsolemsg(userindex, "el usuario no est� online.", fonttypenames.fonttype_info)
                else
                    if not userlist(tuser).flags.privilegios and playertype.user then
                        call writeconsolemsg(userindex, "no puedes encarcelar a administradores.", fonttypenames.fonttype_info)
                    elseif jailtime > 60 then
                        call writeconsolemsg(userindex, "no pued�s encarcelar por m�s de 60 minutos.", fonttypenames.fonttype_info)
                    else
                        if (instrb(username, "\") <> 0) then
                            username = replace(username, "\", "")
                        end if
                        if (instrb(username, "/") <> 0) then
                            username = replace(username, "/", "")
                        end if
                        
                        if fileexist(charpath & username & ".chr", vbnormal) then
                            count = val(getvar(charpath & username & ".chr", "penas", "cant"))
                            call writevar(charpath & username & ".chr", "penas", "cant", count + 1)
                            call writevar(charpath & username & ".chr", "penas", "p" & count + 1, lcase$(.name) & ": carcel " & jailtime & "m, motivo: " & lcase$(reason) & " " & date & " " & time)
                        end if
                        
                        call encarcelar(tuser, jailtime, .name)
                        call loggm(.name, " encarcel� a " & username)
                    end if
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "killnpc" message.
'
' @param    userindex the index of the user sending the message.

private sub handlekillnpc(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/22/08 (niconz)
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and playertype.user then exit sub
        
        dim tnpc as integer
        dim auxnpc as npc
        
        'los consejeros no pueden rmatar a nada en el mapa pretoriano
        if .flags.privilegios and playertype.consejero then
            if .pos.map = mapa_pretoriano then
                call writeconsolemsg(userindex, "los consejeros no pueden usar este comando en el mapa pretoriano.", fonttypenames.fonttype_info)
                exit sub
            end if
        end if
        
        tnpc = .flags.targetnpc
        
        if tnpc > 0 then
            call writeconsolemsg(userindex, "rmatas (con posible respawn) a: " & npclist(tnpc).name, fonttypenames.fonttype_info)
            
            auxnpc = npclist(tnpc)
            call quitarnpc(tnpc)
            call respawnnpc(auxnpc)
            
            .flags.targetnpc = 0
        else
            call writeconsolemsg(userindex, "antes debes hacer click sobre el npc.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "warnuser" message.
'
' @param    userindex the index of the user sending the message.

private sub handlewarnuser(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/26/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim reason as string
        dim privs as playertype
        dim count as byte
        
        username = buffer.readasciistring()
        reason = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (not .flags.privilegios and playertype.user) <> 0 then
            if lenb(username) = 0 or lenb(reason) = 0 then
                call writeconsolemsg(userindex, "utilice /advertencia nick@motivo", fonttypenames.fonttype_info)
            else
                privs = userdarprivilegiolevel(username)
                
                if not privs and playertype.user then
                    call writeconsolemsg(userindex, "no puedes advertir a administradores.", fonttypenames.fonttype_info)
                else
                    if (instrb(username, "\") <> 0) then
                            username = replace(username, "\", "")
                    end if
                    if (instrb(username, "/") <> 0) then
                            username = replace(username, "/", "")
                    end if
                    
                    if fileexist(charpath & username & ".chr", vbnormal) then
                        count = val(getvar(charpath & username & ".chr", "penas", "cant"))
                        call writevar(charpath & username & ".chr", "penas", "cant", count + 1)
                        call writevar(charpath & username & ".chr", "penas", "p" & count + 1, lcase$(.name) & ": advertencia por: " & lcase$(reason) & " " & date & " " & time)
                        
                        call writeconsolemsg(userindex, "has advertido a " & ucase$(username) & ".", fonttypenames.fonttype_info)
                        call loggm(.name, " advirtio a " & username)
                    end if
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "editchar" message.
'
' @param    userindex the index of the user sending the message.

private sub handleeditchar(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 11/06/2009
'02/03/2009: zama - cuando editas nivel, chequea si el pj puede permanecer en clan faccionario
'11/06/2009: zama - todos los comandos se pueden usar aunque el pj este offline
'***************************************************
    if userlist(userindex).incomingdata.length < 8 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim opcion as byte
        dim arg1 as string
        dim arg2 as string
        dim valido as boolean
        dim loopc as byte
        dim commandstring as string
        dim n as byte
        dim usercharpath as string
        dim var as long
        
        
        username = replace(buffer.readasciistring(), "+", " ")
        
        if ucase$(username) = "yo" then
            tuser = userindex
        else
            tuser = nameindex(username)
        end if
        
        opcion = buffer.readbyte()
        arg1 = buffer.readasciistring()
        arg2 = buffer.readasciistring()
        
        if .flags.privilegios and playertype.rolemaster then
            select case .flags.privilegios and (playertype.dios or playertype.semidios or playertype.consejero)
                case playertype.consejero
                    ' los rms consejeros s�lo se pueden editar su head, body y level
                    valido = tuser = userindex and _
                            (opcion = eeditoptions.eo_body or opcion = eeditoptions.eo_head or opcion = eeditoptions.eo_level)
                
                case playertype.semidios
                    ' los rms s�lo se pueden editar su level y el head y body de cualquiera
                    valido = (opcion = eeditoptions.eo_level and tuser = userindex) _
                            or opcion = eeditoptions.eo_body or opcion = eeditoptions.eo_head
                
                case playertype.dios
                    ' los drms pueden aplicar los siguientes comandos sobre cualquiera
                    ' pero si quiere modificar el level s�lo lo puede hacer sobre s� mismo
                    valido = (opcion = eeditoptions.eo_level and tuser = userindex) or _
                            opcion = eeditoptions.eo_body or _
                            opcion = eeditoptions.eo_head or _
                            opcion = eeditoptions.eo_citicenskilled or _
                            opcion = eeditoptions.eo_criminalskilled or _
                            opcion = eeditoptions.eo_class or _
                            opcion = eeditoptions.eo_skills or _
                            opcion = eeditoptions.eo_addgold
            end select
            
        elseif .flags.privilegios and (playertype.admin or playertype.dios) then   'si no es rm debe ser dios para poder usar este comando
            valido = true
        end if

        if valido then
            usercharpath = charpath & username & ".chr"
            if tuser <= 0 and not fileexist(usercharpath) then
                call writeconsolemsg(userindex, "est�s intentando editar un usuario inexistente.", fonttypenames.fonttype_info)
                call loggm(.name, "intent� editar un usuario inexistente.")
            else
                'for making the log
                commandstring = "/mod "
                
                select case opcion
                    case eeditoptions.eo_gold
                        if val(arg1) <= max_oro_edit then
                            if tuser <= 0 then ' esta offline?
                                call writevar(usercharpath, "stats", "gld", val(arg1))
                                call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                            else ' online
                                userlist(tuser).stats.gld = val(arg1)
                                call writeupdategold(tuser)
                            end if
                        else
                            call writeconsolemsg(userindex, "no est� permitido utilizar valores mayores a " & max_oro_edit & ". su comando ha quedado en los logs del juego.", fonttypenames.fonttype_info)
                        end if
                    
                        ' log it
                        commandstring = commandstring & "oro "
                
                    case eeditoptions.eo_experience
                        if val(arg1) > 20000000 then
                                arg1 = 20000000
                        end if
                        
                        if tuser <= 0 then ' offline
                            var = getvar(usercharpath, "stats", "exp")
                            call writevar(usercharpath, "stats", "exp", var + val(arg1))
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else ' online
                            userlist(tuser).stats.exp = userlist(tuser).stats.exp + val(arg1)
                            call checkuserlevel(tuser)
                            call writeupdateexp(tuser)
                        end if
                        
                        ' log it
                        commandstring = commandstring & "exp "
                    
                    case eeditoptions.eo_body
                        if tuser <= 0 then
                            call writevar(usercharpath, "init", "body", arg1)
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else
                            call changeuserchar(tuser, val(arg1), userlist(tuser).char.head, userlist(tuser).char.heading, userlist(tuser).char.weaponanim, userlist(tuser).char.shieldanim, userlist(tuser).char.cascoanim)
                        end if
                        
                        ' log it
                        commandstring = commandstring & "body "
                    
                    case eeditoptions.eo_head
                        if tuser <= 0 then
                            call writevar(usercharpath, "init", "head", arg1)
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else
                            call changeuserchar(tuser, userlist(tuser).char.body, val(arg1), userlist(tuser).char.heading, userlist(tuser).char.weaponanim, userlist(tuser).char.shieldanim, userlist(tuser).char.cascoanim)
                        end if
                        
                        ' log it
                        commandstring = commandstring & "head "
                    
                    case eeditoptions.eo_criminalskilled
                        var = iif(val(arg1) > maxusermatados, maxusermatados, val(arg1))
                        
                        if tuser <= 0 then ' offline
                            call writevar(usercharpath, "facciones", "crimmatados", var)
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else ' online
                            userlist(tuser).faccion.criminalesmatados = var
                        end if
                        
                        ' log it
                        commandstring = commandstring & "cri "
                    
                    case eeditoptions.eo_citicenskilled
                        var = iif(val(arg1) > maxusermatados, maxusermatados, val(arg1))
                        
                        if tuser <= 0 then ' offline
                            call writevar(usercharpath, "facciones", "ciudmatados", var)
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else ' online
                            userlist(tuser).faccion.ciudadanosmatados = var
                        end if
                        
                        ' log it
                        commandstring = commandstring & "ciu "
                    
                    case eeditoptions.eo_level
                        if val(arg1) > stat_maxelv then
                            arg1 = cstr(stat_maxelv)
                            call writeconsolemsg(userindex, "no puedes tener un nivel superior a " & stat_maxelv & ".", fonttype_info)
                        end if
                        
                        ' chequeamos si puede permanecer en el clan
                        if val(arg1) >= 25 then
                            
                            dim gi as integer
                            if tuser <= 0 then
                                gi = getvar(usercharpath, "guild", "guildindex")
                            else
                                gi = userlist(tuser).guildindex
                            end if
                            
                            if gi > 0 then
                                if modguilds.guildalignment(gi) = "del mal" or modguilds.guildalignment(gi) = "real" then
                                    'we get here, so guild has factionary alignment, we have to expulse the user
                                    call modguilds.m_echarmiembrodeclan(-1, username)
                                    
                                    call senddata(sendtarget.toguildmembers, gi, preparemessageconsolemsg(username & " deja el clan.", fonttypenames.fonttype_guild))
                                    ' si esta online le avisamos
                                    if tuser > 0 then _
                                        call writeconsolemsg(tuser, "�ya tienes la madurez suficiente como para decidir bajo que estandarte pelear�s! por esta raz�n, hasta tanto no te enlistes en la facci�n bajo la cual tu clan est� alineado, estar�s exclu�do del mismo.", fonttypenames.fonttype_guild)
                                end if
                            end if
                        end if
                        
                        if tuser <= 0 then ' offline
                            call writevar(usercharpath, "stats", "elv", val(arg1))
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else ' online
                            userlist(tuser).stats.elv = val(arg1)
                            call writeupdateuserstats(tuser)
                        end if
                    
                        ' log it
                        commandstring = commandstring & "level "
                    
                    case eeditoptions.eo_class
                        for loopc = 1 to numclases
                            if ucase$(listaclases(loopc)) = ucase$(arg1) then exit for
                        next loopc
                            
                        if loopc > numclases then
                            call writeconsolemsg(userindex, "clase desconocida. intente nuevamente.", fonttypenames.fonttype_info)
                        else
                            if tuser <= 0 then ' offline
                                call writevar(usercharpath, "init", "clase", loopc)
                                call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                            else ' online
                                userlist(tuser).clase = loopc
                            end if
                        end if
                    
                        ' log it
                        commandstring = commandstring & "clase "
                        
                    case eeditoptions.eo_skills
                        for loopc = 1 to numskills
                            if ucase$(replace$(skillsnames(loopc), " ", "+")) = ucase$(arg1) then exit for
                        next loopc
                        
                        if loopc > numskills then
                            call writeconsolemsg(userindex, "skill inexistente!", fonttypenames.fonttype_info)
                        else
                            if tuser <= 0 then ' offline
                                call writevar(usercharpath, "skills", "sk" & loopc, arg2)
                                call writevar(usercharpath, "skills", "expsk" & loopc, 0)
                                
                                if arg2 < maxskillpoints then
                                    call writevar(usercharpath, "skills", "elusk" & loopc, elu_skill_inicial * 1.05 ^ arg2)
                                else
                                    call writevar(usercharpath, "skills", "elusk" & loopc, 0)
                                end if
    
                                call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                            else ' online
                                userlist(tuser).stats.userskills(loopc) = val(arg2)
                                call checkeluskill(tuser, loopc, true)
                            end if
                        end if
                        
                        ' log it
                        commandstring = commandstring & "skills "
                    
                    case eeditoptions.eo_skillpointsleft
                        if tuser <= 0 then ' offline
                            call writevar(usercharpath, "stats", "skillptslibres", arg1)
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else ' online
                            userlist(tuser).stats.skillpts = val(arg1)
                        end if
                        
                        ' log it
                        commandstring = commandstring & "skillslibres "
                    
                    case eeditoptions.eo_nobleza
                        var = iif(val(arg1) > maxrep, maxrep, val(arg1))
                        
                        if tuser <= 0 then ' offline
                            call writevar(usercharpath, "rep", "nobles", var)
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else ' online
                            userlist(tuser).reputacion.noblerep = var
                        end if
                    
                        ' log it
                        commandstring = commandstring & "nob "
                        
                    case eeditoptions.eo_asesino
                        var = iif(val(arg1) > maxrep, maxrep, val(arg1))
                        
                        if tuser <= 0 then ' offline
                            call writevar(usercharpath, "rep", "asesino", var)
                            call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                        else ' online
                            userlist(tuser).reputacion.asesinorep = var
                        end if
                        
                        ' log it
                        commandstring = commandstring & "ase "
                    
                    case eeditoptions.eo_sex
                        dim sex as byte
                        sex = iif(ucase(arg1) = "mujer", egenero.mujer, 0) ' mujer?
                        sex = iif(ucase(arg1) = "hombre", egenero.hombre, sex) ' hombre?
                        
                        if sex <> 0 then ' es hombre o mujer?
                            if tuser <= 0 then ' offline
                                call writevar(usercharpath, "init", "genero", sex)
                                call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                            else ' online
                                userlist(tuser).genero = sex
                            end if
                        else
                            call writeconsolemsg(userindex, "genero desconocido. intente nuevamente.", fonttypenames.fonttype_info)
                        end if
                        
                        ' log it
                        commandstring = commandstring & "sex "
                    
                    case eeditoptions.eo_raza
                        dim raza as byte
                        
                        arg1 = ucase$(arg1)
                        select case arg1
                            case "humano"
                                raza = eraza.humano
                            case "elfo"
                                raza = eraza.elfo
                            case "drow"
                                raza = eraza.drow
                            case "enano"
                                raza = eraza.enano
                            case "gnomo"
                                raza = eraza.gnomo
                            case else
                                raza = 0
                        end select
                        
                            
                        if raza = 0 then
                            call writeconsolemsg(userindex, "raza desconocida. intente nuevamente.", fonttypenames.fonttype_info)
                        else
                            if tuser <= 0 then
                                call writevar(usercharpath, "init", "raza", raza)
                                call writeconsolemsg(userindex, "charfile alterado: " & username, fonttypenames.fonttype_info)
                            else
                                userlist(tuser).raza = raza
                            end if
                        end if
                            
                        ' log it
                        commandstring = commandstring & "raza "
                        
                    case eeditoptions.eo_addgold
                    
                        dim bankgold as long
                        
                        if abs(arg1) > max_oro_edit then
                            call writeconsolemsg(userindex, "no est� permitido utilizar valores mayores a " & max_oro_edit & ".", fonttypenames.fonttype_info)
                        else
                            if tuser <= 0 then
                                bankgold = getvar(charpath & username & ".chr", "stats", "banco")
                                call writevar(usercharpath, "stats", "banco", iif(bankgold + val(arg1) <= 0, 0, bankgold + val(arg1)))
                                call writeconsolemsg(userindex, "se le ha agregado " & arg1 & " monedas de oro a " & username & ".", fonttype_talk)
                            else
                                userlist(tuser).stats.banco = iif(userlist(tuser).stats.banco + val(arg1) <= 0, 0, userlist(tuser).stats.banco + val(arg1))
                                call writeconsolemsg(tuser, standard_bounty_hunter_message, fonttype_talk)
                            end if
                        end if
                        
                        ' log it
                        commandstring = commandstring & "agregar "
                        
                    case else
                        call writeconsolemsg(userindex, "comando no permitido.", fonttypenames.fonttype_info)
                        commandstring = commandstring & "unkown "
                        
                end select
                
                commandstring = commandstring & arg1 & " " & arg2
                call loggm(.name, commandstring & " " & username)
                
            end if
        end if
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "requestcharinfo" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestcharinfo(byval userindex as integer)
'***************************************************
'author: fredy horacio treboux (liquid)
'last modification: 01/08/07
'last modification by: (liquid).. alto bug zapallo..
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
                
        dim targetname as string
        dim targetindex as integer
        
        targetname = replace$(buffer.readasciistring(), "+", " ")
        targetindex = nameindex(targetname)
        
        
        if .flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios) then
            'is the player offline?
            if targetindex <= 0 then
                'don't allow to retrieve administrator's info
                if not (esdios(targetname) or esadmin(targetname)) then
                    call writeconsolemsg(userindex, "usuario offline, buscando en charfile.", fonttypenames.fonttype_info)
                    call senduserstatstxtoff(userindex, targetname)
                end if
            else
                'don't allow to retrieve administrator's info
                if userlist(targetindex).flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then
                    call senduserstatstxt(userindex, targetindex)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "requestcharstats" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestcharstats(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            call loggm(.name, "/stat " & username)
            
            tuser = nameindex(username)
            
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline. leyendo charfile... ", fonttypenames.fonttype_info)
                
                call senduserministatstxtfromchar(userindex, username)
            else
                call senduserministatstxt(userindex, tuser)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "requestchargold" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestchargold(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        tuser = nameindex(username)
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            call loggm(.name, "/bal " & username)
            
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline. leyendo charfile... ", fonttypenames.fonttype_talk)
                
                call senduserorotxtfromchar(userindex, username)
            else
                call writeconsolemsg(userindex, "el usuario " & username & " tiene " & userlist(tuser).stats.banco & " en el banco.", fonttypenames.fonttype_talk)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "requestcharinventory" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestcharinventory(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        tuser = nameindex(username)
        
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            call loggm(.name, "/inv " & username)
            
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline. leyendo del charfile...", fonttypenames.fonttype_talk)
                
                call senduserinvtxtfromchar(userindex, username)
            else
                call senduserinvtxt(userindex, tuser)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "requestcharbank" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestcharbank(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        tuser = nameindex(username)
        
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            call loggm(.name, "/bov " & username)
            
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline. leyendo charfile... ", fonttypenames.fonttype_talk)
                
                call senduserbovedatxtfromchar(userindex, username)
            else
                call senduserbovedatxt(userindex, tuser)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "requestcharskills" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerequestcharskills(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim loopc as long
        dim message as string
        
        username = buffer.readasciistring()
        tuser = nameindex(username)
        
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            call loggm(.name, "/stats " & username)
            
            if tuser <= 0 then
                if (instrb(username, "\") <> 0) then
                        username = replace(username, "\", "")
                end if
                if (instrb(username, "/") <> 0) then
                        username = replace(username, "/", "")
                end if
                
                for loopc = 1 to numskills
                    message = message & "char>" & skillsnames(loopc) & " = " & getvar(charpath & username & ".chr", "skills", "sk" & loopc) & vbcrlf
                next loopc
                
                call writeconsolemsg(userindex, message & "char> libres:" & getvar(charpath & username & ".chr", "stats", "skillptslibres"), fonttypenames.fonttype_info)
            else
                call senduserskillstxt(userindex, tuser)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "revivechar" message.
'
' @param    userindex the index of the user sending the message.

private sub handlerevivechar(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 11/03/2010
'11/03/2010: zama - al revivir con el comando, si esta navegando le da cuerpo e barca.
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim loopc as byte
        
        username = buffer.readasciistring()
        
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            if ucase$(username) <> "yo" then
                tuser = nameindex(username)
            else
                tuser = userindex
            end if
            
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
            else
                with userlist(tuser)
                    'if dead, show him alive (naked).
                    if .flags.muerto = 1 then
                        .flags.muerto = 0
                        
                        if .flags.navegando = 1 then
                            call toogleboatbody(userindex)
                        else
                            call darcuerpodesnudo(tuser)
                        end if
                        
                        if .flags.traveling = 1 then
                            .flags.traveling = 0
                            .counters.gohome = 0
                            call writemultimessage(tuser, emessages.cancelhome)
                        end if
                        
                        call changeuserchar(tuser, .char.body, .origchar.head, .char.heading, .char.weaponanim, .char.shieldanim, .char.cascoanim)
                        
                        call writeconsolemsg(tuser, userlist(userindex).name & " te ha resucitado.", fonttypenames.fonttype_info)
                    else
                        call writeconsolemsg(tuser, userlist(userindex).name & " te ha curado.", fonttypenames.fonttype_info)
                    end if
                    
                    .stats.minhp = .stats.maxhp
                    
                    if .flags.traveling = 1 then
                        .counters.gohome = 0
                        .flags.traveling = 0
                        call writemultimessage(tuser, emessages.cancelhome)
                    end if
                    
                end with
                
                call writeupdatehp(tuser)
                
                call flushbuffer(tuser)
                
                call loggm(.name, "resucito a " & username)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "onlinegm" message.
'
' @param    userindex the index of the user sending the message.

private sub handleonlinegm(byval userindex as integer)
'***************************************************
'author: fredy horacio treboux (liquid)
'last modification: 12/28/06
'
'***************************************************
    dim i as long
    dim list as string
    dim priv as playertype
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then exit sub

        priv = playertype.consejero or playertype.semidios
        if .flags.privilegios and (playertype.dios or playertype.admin) then priv = priv or playertype.dios or playertype.admin
        
        for i = 1 to lastuser
            if userlist(i).flags.userlogged then
                if userlist(i).flags.privilegios and priv then _
                    list = list & userlist(i).name & ", "
            end if
        next i
        
        if lenb(list) <> 0 then
            list = left$(list, len(list) - 2)
            call writeconsolemsg(userindex, list & ".", fonttypenames.fonttype_info)
        else
            call writeconsolemsg(userindex, "no hay gms online.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "onlinemap" message.
'
' @param    userindex the index of the user sending the message.

private sub handleonlinemap(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 23/03/2009
'23/03/2009: zama - ahora no requiere estar en el mapa, sino que por defecto se toma en el que esta, pero se puede especificar otro
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim map as integer
        map = .incomingdata.readinteger
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then exit sub
        
        dim loopc as long
        dim list as string
        dim priv as playertype
        
        priv = playertype.user or playertype.consejero or playertype.semidios
        if .flags.privilegios and (playertype.dios or playertype.admin) then priv = priv + (playertype.dios or playertype.admin)
        
        for loopc = 1 to lastuser
            if lenb(userlist(loopc).name) <> 0 and userlist(loopc).pos.map = map then
                if userlist(loopc).flags.privilegios and priv then _
                    list = list & userlist(loopc).name & ", "
            end if
        next loopc
        
        if len(list) > 2 then list = left$(list, len(list) - 2)
        
        call writeconsolemsg(userindex, "usuarios en el mapa: " & list, fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "forgive" message.
'
' @param    userindex the index of the user sending the message.

private sub handleforgive(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            tuser = nameindex(username)
            
            if tuser > 0 then
                if esnewbie(tuser) then
                    call volverciudadano(tuser)
                else
                    call loggm(.name, "intento perdonar un personaje de nivel avanzado.")
                    call writeconsolemsg(userindex, "s�lo se permite perdonar newbies.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "kick" message.
'
' @param    userindex the index of the user sending the message.

private sub handlekick(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim rank as integer
        
        rank = playertype.admin or playertype.dios or playertype.semidios or playertype.consejero
        
        username = buffer.readasciistring()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            tuser = nameindex(username)
            
            if tuser <= 0 then
                call writeconsolemsg(userindex, "el usuario no est� online.", fonttypenames.fonttype_info)
            else
                if (userlist(tuser).flags.privilegios and rank) > (.flags.privilegios and rank) then
                    call writeconsolemsg(userindex, "no puedes echar a alguien con jerarqu�a mayor a la tuya.", fonttypenames.fonttype_info)
                else
                    call senddata(sendtarget.toall, 0, preparemessageconsolemsg(.name & " ech� a " & username & ".", fonttypenames.fonttype_info))
                    call closesocket(tuser)
                    call loggm(.name, "ech� a " & username)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "execute" message.
'
' @param    userindex the index of the user sending the message.

private sub handleexecute(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            tuser = nameindex(username)
            
            if tuser > 0 then
                if not userlist(tuser).flags.privilegios and playertype.user then
                    call writeconsolemsg(userindex, "��est�s loco?? ��c�mo vas a pi�atear un gm?? :@", fonttypenames.fonttype_info)
                else
                    call userdie(tuser)
                    call senddata(sendtarget.toall, 0, preparemessageconsolemsg(.name & " ha ejecutado a " & username & ".", fonttypenames.fonttype_ejecucion))
                    call loggm(.name, " ejecuto a " & username)
                end if
            else
                call writeconsolemsg(userindex, "no est� online.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "banchar" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebanchar(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim reason as string
        
        username = buffer.readasciistring()
        reason = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            call bancharacter(userindex, username, reason)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "unbanchar" message.
'
' @param    userindex the index of the user sending the message.

private sub handleunbanchar(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim cantpenas as byte
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            if (instrb(username, "\") <> 0) then
                username = replace(username, "\", "")
            end if
            if (instrb(username, "/") <> 0) then
                username = replace(username, "/", "")
            end if
            
            if not fileexist(charpath & username & ".chr", vbnormal) then
                call writeconsolemsg(userindex, "charfile inexistente (no use +).", fonttypenames.fonttype_info)
            else
                if (val(getvar(charpath & username & ".chr", "flags", "ban")) = 1) then
                    call unban(username)
                
                    'penas
                    cantpenas = val(getvar(charpath & username & ".chr", "penas", "cant"))
                    call writevar(charpath & username & ".chr", "penas", "cant", cantpenas + 1)
                    call writevar(charpath & username & ".chr", "penas", "p" & cantpenas + 1, lcase$(.name) & ": unban. " & date & " " & time)
                
                    call loggm(.name, "/unban a " & username)
                    call writeconsolemsg(userindex, username & " unbanned.", fonttypenames.fonttype_info)
                else
                    call writeconsolemsg(userindex, username & " no est� baneado. imposible unbanear.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "npcfollow" message.
'
' @param    userindex the index of the user sending the message.

private sub handlenpcfollow(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then exit sub
        
        if .flags.targetnpc > 0 then
            call dofollow(.flags.targetnpc, .name)
            npclist(.flags.targetnpc).flags.inmovilizado = 0
            npclist(.flags.targetnpc).flags.paralizado = 0
            npclist(.flags.targetnpc).contadores.paralisis = 0
        end if
    end with
end sub

''
' handles the "summonchar" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesummonchar(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 26/03/2009
'26/03/2009: zama - chequeo que no se teletransporte donde haya un char o npc
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim x as integer
        dim y as integer
        
        username = buffer.readasciistring()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            tuser = nameindex(username)
            
            if tuser <= 0 then
                call writeconsolemsg(userindex, "el jugador no est� online.", fonttypenames.fonttype_info)
            else
                if (.flags.privilegios and (playertype.dios or playertype.admin)) <> 0 or _
                  (userlist(tuser).flags.privilegios and (playertype.consejero or playertype.user)) <> 0 then
                    call writeconsolemsg(tuser, .name & " te ha trasportado.", fonttypenames.fonttype_info)
                    x = .pos.x
                    y = .pos.y + 1
                    call findlegalpos(tuser, .pos.map, x, y)
                    call warpuserchar(tuser, .pos.map, x, y, true, true)
                    call loggm(.name, "/sum " & username & " map:" & .pos.map & " x:" & .pos.x & " y:" & .pos.y)
                else
                    call writeconsolemsg(userindex, "no puedes invocar a dioses y admins.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "spawnlistrequest" message.
'
' @param    userindex the index of the user sending the message.

private sub handlespawnlistrequest(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then exit sub
        
        call enviarspawnlist(userindex)
    end with
end sub

''
' handles the "spawncreature" message.
'
' @param    userindex the index of the user sending the message.

private sub handlespawncreature(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim npc as integer
        npc = .incomingdata.readinteger()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            if npc > 0 and npc <= ubound(declaraciones.spawnlist()) then _
              call spawnnpc(declaraciones.spawnlist(npc).npcindex, .pos, true, false)
            
            call loggm(.name, "sumoneo " & declaraciones.spawnlist(npc).npcname)
        end if
    end with
end sub

''
' handles the "resetnpcinventory" message.
'
' @param    userindex the index of the user sending the message.

private sub handleresetnpcinventory(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.rolemaster) then exit sub
        if .flags.targetnpc = 0 then exit sub
        
        call resetnpcinv(.flags.targetnpc)
        call loggm(.name, "/resetinv " & npclist(.flags.targetnpc).name)
    end with
end sub

''
' handles the "cleanworld" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecleanworld(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte

        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.rolemaster) then exit sub
        
        call limpiarmundo
    end with
end sub

''
' handles the "servermessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handleservermessage(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        message = buffer.readasciistring()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) then
            if lenb(message) <> 0 then
                call loggm(.name, "mensaje broadcast:" & message)
                call senddata(sendtarget.toall, 0, preparemessageconsolemsg(userlist(userindex).name & "> " & message, fonttypenames.fonttype_talk))
                ''''''''''''''''solo para el testeo'''''''
                ''''''''''se usa para comunicarse con el server'''''''''''
                frmmain.txtchat.text = frmmain.txtchat.text & vbnewline & userlist(userindex).name & " > " & message
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "nicktoip" message.
'
' @param    userindex the index of the user sending the message.

private sub handlenicktoip(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 24/07/07
'pablo (toxicwaste): agrego para uqe el /nick2ip tambien diga los nicks en esa ip por pedido de la dgm.
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim priv as playertype
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            tuser = nameindex(username)
            call loggm(.name, "nick2ip solicito la ip de " & username)

            if .flags.privilegios and (playertype.dios or playertype.admin) then
                priv = playertype.user or playertype.consejero or playertype.semidios or playertype.dios or playertype.admin
            else
                priv = playertype.user
            end if
            
            if tuser > 0 then
                if userlist(tuser).flags.privilegios and priv then
                    call writeconsolemsg(userindex, "el ip de " & username & " es " & userlist(tuser).ip, fonttypenames.fonttype_info)
                    dim ip as string
                    dim lista as string
                    dim loopc as long
                    ip = userlist(tuser).ip
                    for loopc = 1 to lastuser
                        if userlist(loopc).ip = ip then
                            if lenb(userlist(loopc).name) <> 0 and userlist(loopc).flags.userlogged then
                                if userlist(loopc).flags.privilegios and priv then
                                    lista = lista & userlist(loopc).name & ", "
                                end if
                            end if
                        end if
                    next loopc
                    if lenb(lista) <> 0 then lista = left$(lista, len(lista) - 2)
                    call writeconsolemsg(userindex, "los personajes con ip " & ip & " son: " & lista, fonttypenames.fonttype_info)
                end if
            else
                call writeconsolemsg(userindex, "no hay ning�n personaje con ese nick.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "iptonick" message.
'
' @param    userindex the index of the user sending the message.

private sub handleiptonick(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim ip as string
        dim loopc as long
        dim lista as string
        dim priv as playertype
        
        ip = .incomingdata.readbyte() & "."
        ip = ip & .incomingdata.readbyte() & "."
        ip = ip & .incomingdata.readbyte() & "."
        ip = ip & .incomingdata.readbyte()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.rolemaster) then exit sub
        
        call loggm(.name, "ip2nick solicito los nicks de ip " & ip)
        
        if .flags.privilegios and (playertype.dios or playertype.admin) then
            priv = playertype.user or playertype.consejero or playertype.semidios or playertype.dios or playertype.admin
        else
            priv = playertype.user
        end if

        for loopc = 1 to lastuser
            if userlist(loopc).ip = ip then
                if lenb(userlist(loopc).name) <> 0 and userlist(loopc).flags.userlogged then
                    if userlist(loopc).flags.privilegios and priv then
                        lista = lista & userlist(loopc).name & ", "
                    end if
                end if
            end if
        next loopc
        
        if lenb(lista) <> 0 then lista = left$(lista, len(lista) - 2)
        call writeconsolemsg(userindex, "los personajes con ip " & ip & " son: " & lista, fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "guildonlinemembers" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildonlinemembers(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guildname as string
        dim tguild as integer
        
        guildname = buffer.readasciistring()
        
        if (instrb(guildname, "+") <> 0) then
            guildname = replace(guildname, "+", " ")
        end if
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            tguild = guildindex(guildname)
            
            if tguild > 0 then
                call writeconsolemsg(userindex, "clan " & ucase(guildname) & ": " & _
                  modguilds.m_listademiembrosonline(userindex, tguild), fonttypenames.fonttype_guildmsg)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "teleportcreate" message.
'
' @param    userindex the index of the user sending the message.

private sub handleteleportcreate(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 22/03/2010
'15/11/2009: zama - ahora se crea un teleport con un radio especificado.
'22/03/2010: zama - harcodeo los teleps y radios en el dat, para evitar mapas bugueados.
'***************************************************
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim mapa as integer
        dim x as byte
        dim y as byte
        dim radio as byte
        
        mapa = .incomingdata.readinteger()
        x = .incomingdata.readbyte()
        y = .incomingdata.readbyte()
        radio = .incomingdata.readbyte()
        
        radio = minimoint(radio, 6)
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        call loggm(.name, "/ct " & mapa & "," & x & "," & y & "," & radio)
        
        if not mapavalido(mapa) or not inmapbounds(mapa, x, y) then _
            exit sub
        
        if mapdata(.pos.map, .pos.x, .pos.y - 1).objinfo.objindex > 0 then _
            exit sub
        
        if mapdata(.pos.map, .pos.x, .pos.y - 1).tileexit.map > 0 then _
            exit sub
        
        if mapdata(mapa, x, y).objinfo.objindex > 0 then
            call writeconsolemsg(userindex, "hay un objeto en el piso en ese lugar.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        if mapdata(mapa, x, y).tileexit.map > 0 then
            call writeconsolemsg(userindex, "no puedes crear un teleport que apunte a la entrada de otro.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        dim et as obj
        et.amount = 1
        ' es el numero en el dat. el indice es el comienzo + el radio, todo harcodeado :(.
        et.objindex = telep_obj_index + radio
        
        with mapdata(.pos.map, .pos.x, .pos.y - 1)
            .tileexit.map = mapa
            .tileexit.x = x
            .tileexit.y = y
        end with
        
        call makeobj(et, .pos.map, .pos.x, .pos.y - 1)
    end with
end sub

''
' handles the "teleportdestroy" message.
'
' @param    userindex the index of the user sending the message.

private sub handleteleportdestroy(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    with userlist(userindex)
        dim mapa as integer
        dim x as byte
        dim y as byte
        
        'remove packet id
        call .incomingdata.readbyte
        
        '/dt
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        mapa = .flags.targetmap
        x = .flags.targetx
        y = .flags.targety
        
        if not inmapbounds(mapa, x, y) then exit sub
        
        with mapdata(mapa, x, y)
            if .objinfo.objindex = 0 then exit sub
            
            if objdata(.objinfo.objindex).objtype = eobjtype.otteleport and .tileexit.map > 0 then
                call loggm(userlist(userindex).name, "/dt: " & mapa & "," & x & "," & y)
                
                call eraseobj(.objinfo.amount, mapa, x, y)
                
                if mapdata(.tileexit.map, .tileexit.x, .tileexit.y).objinfo.objindex = 651 then
                    call eraseobj(1, .tileexit.map, .tileexit.x, .tileexit.y)
                end if
                
                .tileexit.map = 0
                .tileexit.x = 0
                .tileexit.y = 0
            end if
        end with
    end with
end sub

''
' handles the "raintoggle" message.
'
' @param    userindex the index of the user sending the message.

private sub handleraintoggle(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then exit sub
        
        call loggm(.name, "/lluvia")
        lloviendo = not lloviendo
        
        call senddata(sendtarget.toall, 0, preparemessageraintoggle())
    end with
end sub

''
' handles the "setchardescription" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesetchardescription(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim tuser as integer
        dim desc as string
        
        desc = buffer.readasciistring()
        
        if (.flags.privilegios and (playertype.dios or playertype.admin)) <> 0 or (.flags.privilegios and playertype.rolemaster) <> 0 then
            tuser = .flags.targetuser
            if tuser > 0 then
                userlist(tuser).descrm = desc
            else
                call writeconsolemsg(userindex, "haz click sobre un personaje antes.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "forcemiditomap" message.
'
' @param    userindex the index of the user sending the message.

private sub hanldeforcemiditomap(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim midiid as byte
        dim mapa as integer
        
        midiid = .incomingdata.readbyte
        mapa = .incomingdata.readinteger
        
        'solo dioses, admins y rms
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
            'si el mapa no fue enviado tomo el actual
            if not inmapbounds(mapa, 50, 50) then
                mapa = .pos.map
            end if
        
            if midiid = 0 then
                'ponemos el default del mapa
                call senddata(sendtarget.tomap, mapa, preparemessageplaymidi(mapinfo(.pos.map).music))
            else
                'ponemos el pedido por el gm
                call senddata(sendtarget.tomap, mapa, preparemessageplaymidi(midiid))
            end if
        end if
    end with
end sub

''
' handles the "forcewavetomap" message.
'
' @param    userindex the index of the user sending the message.

private sub handleforcewavetomap(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim waveid as byte
        dim mapa as integer
        dim x as byte
        dim y as byte
        
        waveid = .incomingdata.readbyte()
        mapa = .incomingdata.readinteger()
        x = .incomingdata.readbyte()
        y = .incomingdata.readbyte()
        
        'solo dioses, admins y rms
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
        'si el mapa no fue enviado tomo el actual
            if not inmapbounds(mapa, x, y) then
                mapa = .pos.map
                x = .pos.x
                y = .pos.y
            end if
            
            'ponemos el pedido por el gm
            call senddata(sendtarget.tomap, mapa, preparemessageplaywave(waveid, x, y))
        end if
    end with
end sub

''
' handles the "royalarmymessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handleroyalarmymessage(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        message = buffer.readasciistring()
        
        'solo dioses, admins y rms
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
            call senddata(sendtarget.torealyrms, 0, preparemessageconsolemsg("ej�rcito real> " & message, fonttypenames.fonttype_talk))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "chaoslegionmessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handlechaoslegionmessage(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        message = buffer.readasciistring()
        
        'solo dioses, admins y rms
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
            call senddata(sendtarget.tocaosyrms, 0, preparemessageconsolemsg("fuerzas del caos> " & message, fonttypenames.fonttype_talk))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "citizenmessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecitizenmessage(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        message = buffer.readasciistring()
        
        'solo dioses, admins y rms
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
            call senddata(sendtarget.tociudadanosyrms, 0, preparemessageconsolemsg("ciudadanos> " & message, fonttypenames.fonttype_talk))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "criminalmessage" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecriminalmessage(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        message = buffer.readasciistring()
        
        'solo dioses, admins y rms
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
            call senddata(sendtarget.tocriminalesyrms, 0, preparemessageconsolemsg("criminales> " & message, fonttypenames.fonttype_talk))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "talkasnpc" message.
'
' @param    userindex the index of the user sending the message.

private sub handletalkasnpc(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/29/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        message = buffer.readasciistring()
        
        'solo dioses, admins y rms
        if .flags.privilegios and (playertype.dios or playertype.admin or playertype.rolemaster) then
            'asegurarse haya un npc seleccionado
            if .flags.targetnpc > 0 then
                call senddata(sendtarget.tonpcarea, .flags.targetnpc, preparemessagechatoverhead(message, npclist(.flags.targetnpc).char.charindex, vbwhite))
            else
                call writeconsolemsg(userindex, "debes seleccionar el npc por el que quieres hablar antes de usar este comando.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "destroyallitemsinarea" message.
'
' @param    userindex the index of the user sending the message.

private sub handledestroyallitemsinarea(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        dim x as long
        dim y as long
        dim bisexit as boolean
        
        for y = .pos.y - minyborder + 1 to .pos.y + minyborder - 1
            for x = .pos.x - minxborder + 1 to .pos.x + minxborder - 1
                if x > 0 and y > 0 and x < 101 and y < 101 then
                    if mapdata(.pos.map, x, y).objinfo.objindex > 0 then
                        bisexit = mapdata(.pos.map, x, y).tileexit.map > 0
                        if itemnoesdemapa(mapdata(.pos.map, x, y).objinfo.objindex, bisexit) then
                            call eraseobj(max_inventory_objs, .pos.map, x, y)
                        end if
                    end if
                end if
            next x
        next y
        
        call loggm(userlist(userindex).name, "/massdest")
    end with
end sub

''
' handles the "acceptroyalcouncilmember" message.
'
' @param    userindex the index of the user sending the message.

private sub handleacceptroyalcouncilmember(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim loopc as byte
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            tuser = nameindex(username)
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline", fonttypenames.fonttype_info)
            else
                call senddata(sendtarget.toall, 0, preparemessageconsolemsg(username & " fue aceptado en el honorable consejo real de banderbill.", fonttypenames.fonttype_consejo))
                with userlist(tuser)
                    if .flags.privilegios and playertype.chaoscouncil then .flags.privilegios = .flags.privilegios - playertype.chaoscouncil
                    if not .flags.privilegios and playertype.royalcouncil then .flags.privilegios = .flags.privilegios + playertype.royalcouncil
                    
                    call warpuserchar(tuser, .pos.map, .pos.x, .pos.y, false)
                end with
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "chaoscouncilmember" message.
'
' @param    userindex the index of the user sending the message.

private sub handleacceptchaoscouncilmember(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim loopc as byte
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            tuser = nameindex(username)
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline", fonttypenames.fonttype_info)
            else
                call senddata(sendtarget.toall, 0, preparemessageconsolemsg(username & " fue aceptado en el concilio de las sombras.", fonttypenames.fonttype_consejo))
                
                with userlist(tuser)
                    if .flags.privilegios and playertype.royalcouncil then .flags.privilegios = .flags.privilegios - playertype.royalcouncil
                    if not .flags.privilegios and playertype.chaoscouncil then .flags.privilegios = .flags.privilegios + playertype.chaoscouncil

                    call warpuserchar(tuser, .pos.map, .pos.x, .pos.y, false)
                end with
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "itemsinthefloor" message.
'
' @param    userindex the index of the user sending the message.

private sub handleitemsinthefloor(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        dim tobj as integer
        dim lista as string
        dim x as long
        dim y as long
        
        for x = 5 to 95
            for y = 5 to 95
                tobj = mapdata(.pos.map, x, y).objinfo.objindex
                if tobj > 0 then
                    if objdata(tobj).objtype <> eobjtype.otarboles then
                        call writeconsolemsg(userindex, "(" & x & "," & y & ") " & objdata(tobj).name, fonttypenames.fonttype_info)
                    end if
                end if
            next y
        next x
    end with
end sub

''
' handles the "makedumb" message.
'
' @param    userindex the index of the user sending the message.

private sub handlemakedumb(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if ((.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 or ((.flags.privilegios and (playertype.semidios or playertype.rolemaster)) = (playertype.semidios or playertype.rolemaster))) then
            tuser = nameindex(username)
            'para deteccion de aoice
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
            else
                call writedumb(tuser)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "makedumbnomore" message.
'
' @param    userindex the index of the user sending the message.

private sub handlemakedumbnomore(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if ((.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 or ((.flags.privilegios and (playertype.semidios or playertype.rolemaster)) = (playertype.semidios or playertype.rolemaster))) then
            tuser = nameindex(username)
            'para deteccion de aoice
            if tuser <= 0 then
                call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_info)
            else
                call writedumbnomore(tuser)
                call flushbuffer(tuser)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "dumpiptables" message.
'
' @param    userindex the index of the user sending the message.

private sub handledumpiptables(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        call securityip.dumptables
    end with
end sub

''
' handles the "councilkick" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecouncilkick(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            tuser = nameindex(username)
            if tuser <= 0 then
                if fileexist(charpath & username & ".chr") then
                    call writeconsolemsg(userindex, "usuario offline, echando de los consejos.", fonttypenames.fonttype_info)
                    call writevar(charpath & username & ".chr", "consejo", "pertenece", 0)
                    call writevar(charpath & username & ".chr", "consejo", "pertenececaos", 0)
                else
                    call writeconsolemsg(userindex, "no se encuentra el charfile " & charpath & username & ".chr", fonttypenames.fonttype_info)
                end if
            else
                with userlist(tuser)
                    if .flags.privilegios and playertype.royalcouncil then
                        call writeconsolemsg(tuser, "has sido echado del consejo de banderbill.", fonttypenames.fonttype_talk)
                        .flags.privilegios = .flags.privilegios - playertype.royalcouncil
                        
                        call warpuserchar(tuser, .pos.map, .pos.x, .pos.y, false)
                        call senddata(sendtarget.toall, 0, preparemessageconsolemsg(username & " fue expulsado del consejo de banderbill.", fonttypenames.fonttype_consejo))
                    end if
                    
                    if .flags.privilegios and playertype.chaoscouncil then
                        call writeconsolemsg(tuser, "has sido echado del concilio de las sombras.", fonttypenames.fonttype_talk)
                        .flags.privilegios = .flags.privilegios - playertype.chaoscouncil
                        
                        call warpuserchar(tuser, .pos.map, .pos.x, .pos.y, false)
                        call senddata(sendtarget.toall, 0, preparemessageconsolemsg(username & " fue expulsado del concilio de las sombras.", fonttypenames.fonttype_consejo))
                    end if
                end with
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "settrigger" message.
'
' @param    userindex the index of the user sending the message.

private sub handlesettrigger(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim ttrigger as byte
        dim tlog as string
        
        ttrigger = .incomingdata.readbyte()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        if ttrigger >= 0 then
            mapdata(.pos.map, .pos.x, .pos.y).trigger = ttrigger
            tlog = "trigger " & ttrigger & " en mapa " & .pos.map & " " & .pos.x & "," & .pos.y
            
            call loggm(.name, tlog)
            call writeconsolemsg(userindex, tlog, fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "asktrigger" message.
'
' @param    userindex the index of the user sending the message.

private sub handleasktrigger(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 04/13/07
'
'***************************************************
    dim ttrigger as byte
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        ttrigger = mapdata(.pos.map, .pos.x, .pos.y).trigger
        
        call loggm(.name, "miro el trigger en " & .pos.map & "," & .pos.x & "," & .pos.y & ". era " & ttrigger)
        
        call writeconsolemsg(userindex, _
            "trigger " & ttrigger & " en mapa " & .pos.map & " " & .pos.x & ", " & .pos.y _
            , fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "bannediplist" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebannediplist(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        dim lista as string
        dim loopc as long
        
        call loggm(.name, "/baniplist")
        
        for loopc = 1 to banips.count
            lista = lista & banips.item(loopc) & ", "
        next loopc
        
        if lenb(lista) <> 0 then lista = left$(lista, len(lista) - 2)
        
        call writeconsolemsg(userindex, lista, fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "bannedipreload" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebannedipreload(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call banipguardar
        call banipcargar
    end with
end sub

''
' handles the "guildban" message.
'
' @param    userindex the index of the user sending the message.

private sub handleguildban(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guildname as string
        dim cantmembers as integer
        dim loopc as long
        dim member as string
        dim count as byte
        dim tindex as integer
        dim tfile as string
        
        guildname = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            tfile = app.path & "\guilds\" & guildname & "-members.mem"
            
            if not fileexist(tfile) then
                call writeconsolemsg(userindex, "no existe el clan: " & guildname, fonttypenames.fonttype_info)
            else
                call senddata(sendtarget.toall, 0, preparemessageconsolemsg(.name & " bane� al clan " & ucase$(guildname), fonttypenames.fonttype_fight))
                
                'baneamos a los miembros
                call loggm(.name, "banclan a " & ucase$(guildname))
                
                cantmembers = val(getvar(tfile, "init", "nromembers"))
                
                for loopc = 1 to cantmembers
                    member = getvar(tfile, "members", "member" & loopc)
                    'member es la victima
                    call ban(member, "administracion del servidor", "clan banned")
                    
                    call senddata(sendtarget.toall, 0, preparemessageconsolemsg("   " & member & "<" & guildname & "> ha sido expulsado del servidor.", fonttypenames.fonttype_fight))
                    
                    tindex = nameindex(member)
                    if tindex > 0 then
                        'esta online
                        userlist(tindex).flags.ban = 1
                        call closesocket(tindex)
                    end if
                    
                    'ponemos el flag de ban a 1
                    call writevar(charpath & member & ".chr", "flags", "ban", "1")
                    'ponemos la pena
                    count = val(getvar(charpath & member & ".chr", "penas", "cant"))
                    call writevar(charpath & member & ".chr", "penas", "cant", count + 1)
                    call writevar(charpath & member & ".chr", "penas", "p" & count + 1, lcase$(.name) & ": ban al clan: " & guildname & " " & date & " " & time)
                next loopc
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "banip" message.
'
' @param    userindex the index of the user sending the message.

private sub handlebanip(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 07/02/09
'agregado un copybuffer porque se producia un bucle
'inifito al intentar banear una ip ya baneada. (niconz)
'07/02/09 pato - ahora no es posible saber si un gm est� o no online.
'***************************************************
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim bannedip as string
        dim tuser as integer
        dim reason as string
        dim i as long
        
        ' is it by ip??
        if buffer.readboolean() then
            bannedip = buffer.readbyte() & "."
            bannedip = bannedip & buffer.readbyte() & "."
            bannedip = bannedip & buffer.readbyte() & "."
            bannedip = bannedip & buffer.readbyte()
        else
            tuser = nameindex(buffer.readasciistring())
            
            if tuser > 0 then bannedip = userlist(tuser).ip
        end if
        
        reason = buffer.readasciistring()
        
        
        if .flags.privilegios and (playertype.admin or playertype.dios) then
            if lenb(bannedip) > 0 then
                call loggm(.name, "/banip " & bannedip & " por " & reason)
                
                if banipbuscar(bannedip) > 0 then
                    call writeconsolemsg(userindex, "la ip " & bannedip & " ya se encuentra en la lista de bans.", fonttypenames.fonttype_info)
                else
                    call banipagrega(bannedip)
                    call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg(.name & " bane� la ip " & bannedip & " por " & reason, fonttypenames.fonttype_fight))
                    
                    'find every player with that ip and ban him!
                    for i = 1 to lastuser
                        if userlist(i).connidvalida then
                            if userlist(i).ip = bannedip then
                                call bancharacter(userindex, userlist(i).name, "ip por " & reason)
                            end if
                        end if
                    next i
                end if
            elseif tuser <= 0 then
                call writeconsolemsg(userindex, "el personaje no est� online.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "unbanip" message.
'
' @param    userindex the index of the user sending the message.

private sub handleunbanip(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim bannedip as string
        
        bannedip = .incomingdata.readbyte() & "."
        bannedip = bannedip & .incomingdata.readbyte() & "."
        bannedip = bannedip & .incomingdata.readbyte() & "."
        bannedip = bannedip & .incomingdata.readbyte()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        if banipquita(bannedip) then
            call writeconsolemsg(userindex, "la ip """ & bannedip & """ se ha quitado de la lista de bans.", fonttypenames.fonttype_info)
        else
            call writeconsolemsg(userindex, "la ip """ & bannedip & """ no se encuentra en la lista de bans.", fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handles the "createitem" message.
'
' @param    userindex the index of the user sending the message.

private sub handlecreateitem(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte

        dim tobj as integer
        dim tstr as string
        tobj = .incomingdata.readinteger()

        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
            
        call loggm(.name, "/ci: " & tobj)
        
        if mapdata(.pos.map, .pos.x, .pos.y - 1).objinfo.objindex > 0 then _
            exit sub
        
        if mapdata(.pos.map, .pos.x, .pos.y - 1).tileexit.map > 0 then _
            exit sub
        
        if tobj < 1 or tobj > numobjdatas then _
            exit sub
        
        'is the object not null?
        if lenb(objdata(tobj).name) = 0 then exit sub
        
        dim objeto as obj
        call writeconsolemsg(userindex, "��atenci�n: fueron creados ***100*** �tems, tire y /dest los que no necesite!!", fonttypenames.fonttype_guild)
        
        objeto.amount = 100
        objeto.objindex = tobj
        call makeobj(objeto, .pos.map, .pos.x, .pos.y - 1)
    end with
end sub

''
' handles the "destroyitems" message.
'
' @param    userindex the index of the user sending the message.

private sub handledestroyitems(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        if mapdata(.pos.map, .pos.x, .pos.y).objinfo.objindex = 0 then exit sub
        
        call loggm(.name, "/dest")
        
        if objdata(mapdata(.pos.map, .pos.x, .pos.y).objinfo.objindex).objtype = eobjtype.otteleport and _
            mapdata(.pos.map, .pos.x, .pos.y).tileexit.map > 0 then
            
            call writeconsolemsg(userindex, "no puede destruir teleports as�. utilice /dt.", fonttypenames.fonttype_info)
            exit sub
        end if
        
        call eraseobj(10000, .pos.map, .pos.x, .pos.y)
    end with
end sub

''
' handles the "chaoslegionkick" message.
'
' @param    userindex the index of the user sending the message.

private sub handlechaoslegionkick(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            if (instrb(username, "\") <> 0) then
                username = replace(username, "\", "")
            end if
            if (instrb(username, "/") <> 0) then
                username = replace(username, "/", "")
            end if
            tuser = nameindex(username)
            
            call loggm(.name, "echo del caos a: " & username)
    
            if tuser > 0 then
                call expulsarfaccioncaos(tuser, true)
                userlist(tuser).faccion.reenlistadas = 200
                call writeconsolemsg(userindex, username & " expulsado de las fuerzas del caos y prohibida la reenlistada.", fonttypenames.fonttype_info)
                call writeconsolemsg(tuser, .name & " te ha expulsado en forma definitiva de las fuerzas del caos.", fonttypenames.fonttype_fight)
                call flushbuffer(tuser)
            else
                if fileexist(charpath & username & ".chr") then
                    call writevar(charpath & username & ".chr", "facciones", "ejercitocaos", 0)
                    call writevar(charpath & username & ".chr", "facciones", "reenlistadas", 200)
                    call writevar(charpath & username & ".chr", "facciones", "extra", "expulsado por " & .name)
                    call writeconsolemsg(userindex, username & " expulsado de las fuerzas del caos y prohibida la reenlistada.", fonttypenames.fonttype_info)
                else
                    call writeconsolemsg(userindex, username & ".chr inexistente.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "royalarmykick" message.
'
' @param    userindex the index of the user sending the message.

private sub handleroyalarmykick(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            if (instrb(username, "\") <> 0) then
                username = replace(username, "\", "")
            end if
            if (instrb(username, "/") <> 0) then
                username = replace(username, "/", "")
            end if
            tuser = nameindex(username)
            
            call loggm(.name, "ech� de la real a: " & username)
            
            if tuser > 0 then
                call expulsarfaccionreal(tuser, true)
                userlist(tuser).faccion.reenlistadas = 200
                call writeconsolemsg(userindex, username & " expulsado de las fuerzas reales y prohibida la reenlistada.", fonttypenames.fonttype_info)
                call writeconsolemsg(tuser, .name & " te ha expulsado en forma definitiva de las fuerzas reales.", fonttypenames.fonttype_fight)
                call flushbuffer(tuser)
            else
                if fileexist(charpath & username & ".chr") then
                    call writevar(charpath & username & ".chr", "facciones", "ejercitoreal", 0)
                    call writevar(charpath & username & ".chr", "facciones", "reenlistadas", 200)
                    call writevar(charpath & username & ".chr", "facciones", "extra", "expulsado por " & .name)
                    call writeconsolemsg(userindex, username & " expulsado de las fuerzas reales y prohibida la reenlistada.", fonttypenames.fonttype_info)
                else
                    call writeconsolemsg(userindex, username & ".chr inexistente.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "forcemidiall" message.
'
' @param    userindex the index of the user sending the message.

private sub handleforcemidiall(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte

        dim midiid as byte
        midiid = .incomingdata.readbyte()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        call senddata(sendtarget.toall, 0, preparemessageconsolemsg(.name & " broadcast m�sica: " & midiid, fonttypenames.fonttype_server))
        
        call senddata(sendtarget.toall, 0, preparemessageplaymidi(midiid))
    end with
end sub

''
' handles the "forcewaveall" message.
'
' @param    userindex the index of the user sending the message.

private sub handleforcewaveall(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte

        dim waveid as byte
        waveid = .incomingdata.readbyte()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        call senddata(sendtarget.toall, 0, preparemessageplaywave(waveid, no_3d_sound, no_3d_sound))
    end with
end sub

''
' handles the "removepunishment" message.
'
' @param    userindex the index of the user sending the message.

private sub handleremovepunishment(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 1/05/07
'pablo (toxicwaste): 1/05/07, you can now edit the punishment.
'***************************************************
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim punishment as byte
        dim newtext as string
        
        username = buffer.readasciistring()
        punishment = buffer.readbyte
        newtext = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            if lenb(username) = 0 then
                call writeconsolemsg(userindex, "utilice /borrarpena nick@numerodepena@nuevapena", fonttypenames.fonttype_info)
            else
                if (instrb(username, "\") <> 0) then
                        username = replace(username, "\", "")
                end if
                if (instrb(username, "/") <> 0) then
                        username = replace(username, "/", "")
                end if
                
                if fileexist(charpath & username & ".chr", vbnormal) then
                    call loggm(.name, " borro la pena: " & punishment & "-" & _
                      getvar(charpath & username & ".chr", "penas", "p" & punishment) _
                      & " de " & username & " y la cambi� por: " & newtext)
                    
                    call writevar(charpath & username & ".chr", "penas", "p" & punishment, lcase$(.name) & ": <" & newtext & "> " & date & " " & time)
                    
                    call writeconsolemsg(userindex, "pena modificada.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "tileblockedtoggle" message.
'
' @param    userindex the index of the user sending the message.

private sub handletileblockedtoggle(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub

        call loggm(.name, "/bloq")
        
        if mapdata(.pos.map, .pos.x, .pos.y).blocked = 0 then
            mapdata(.pos.map, .pos.x, .pos.y).blocked = 1
        else
            mapdata(.pos.map, .pos.x, .pos.y).blocked = 0
        end if
        
        call bloquear(true, .pos.map, .pos.x, .pos.y, mapdata(.pos.map, .pos.x, .pos.y).blocked)
    end with
end sub

''
' handles the "killnpcnorespawn" message.
'
' @param    userindex the index of the user sending the message.

private sub handlekillnpcnorespawn(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        if .flags.targetnpc = 0 then exit sub
        
        call quitarnpc(.flags.targetnpc)
        call loggm(.name, "/mata " & npclist(.flags.targetnpc).name)
    end with
end sub

''
' handles the "killallnearbynpcs" message.
'
' @param    userindex the index of the user sending the message.

private sub handlekillallnearbynpcs(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        dim x as long
        dim y as long
        
        for y = .pos.y - minyborder + 1 to .pos.y + minyborder - 1
            for x = .pos.x - minxborder + 1 to .pos.x + minxborder - 1
                if x > 0 and y > 0 and x < 101 and y < 101 then
                    if mapdata(.pos.map, x, y).npcindex > 0 then call quitarnpc(mapdata(.pos.map, x, y).npcindex)
                end if
            next x
        next y
        call loggm(.name, "/masskill")
    end with
end sub

''
' handles the "lastip" message.
'
' @param    userindex the index of the user sending the message.

private sub handlelastip(byval userindex as integer)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 12/30/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim lista as string
        dim loopc as byte
        dim priv as integer
        dim validcheck as boolean
        
        priv = playertype.admin or playertype.dios or playertype.semidios or playertype.consejero
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios)) <> 0 then
            'handle special chars
            if (instrb(username, "\") <> 0) then
                username = replace(username, "\", "")
            end if
            if (instrb(username, "\") <> 0) then
                username = replace(username, "/", "")
            end if
            if (instrb(username, "+") <> 0) then
                username = replace(username, "+", " ")
            end if
            
            'only gods and admins can see the ips of adminsitrative characters. all others can be seen by every adminsitrative char.
            if nameindex(username) > 0 then
                validcheck = (userlist(nameindex(username)).flags.privilegios and priv) = 0 or (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0
            else
                validcheck = (userdarprivilegiolevel(username) and priv) = 0 or (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0
            end if
            
            if validcheck then
                call loggm(.name, "/lastip " & username)
                
                if fileexist(charpath & username & ".chr", vbnormal) then
                    lista = "las ultimas ips con las que " & username & " se conect� son:"
                    for loopc = 1 to 5
                        lista = lista & vbcrlf & loopc & " - " & getvar(charpath & username & ".chr", "init", "lastip" & loopc)
                    next loopc
                    call writeconsolemsg(userindex, lista, fonttypenames.fonttype_info)
                else
                    call writeconsolemsg(userindex, "charfile """ & username & """ inexistente.", fonttypenames.fonttype_info)
                end if
            else
                call writeconsolemsg(userindex, username & " es de mayor jerarqu�a que vos.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "chatcolor" message.
'
' @param    userindex the index of the user sending the message.

public sub handlechatcolor(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'last modified by: juan mart�n sotuyo dodero (maraxus)
'change the user`s chat color
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim color as long
        
        color = rgb(.incomingdata.readbyte(), .incomingdata.readbyte(), .incomingdata.readbyte())
        
        if (.flags.privilegios and (playertype.admin or playertype.dios or playertype.rolemaster)) then
            .flags.chatcolor = color
        end if
    end with
end sub

''
' handles the "ignored" message.
'
' @param    userindex the index of the user sending the message.

public sub handleignored(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'ignore the user
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios or playertype.consejero) then
            .flags.adminperseguible = not .flags.adminperseguible
        end if
    end with
end sub

''
' handles the "checkslot" message.
'
' @param    userindex the index of the user sending the message.

public sub handlecheckslot(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 09/09/2008 (niconz)
'check one users slot in particular from inventory
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if

on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        'reads the username and slot packets
        dim username as string
        dim slot as byte
        dim tindex as integer
        
        username = buffer.readasciistring() 'que username?
        slot = buffer.readbyte() 'que slot?
        
        if .flags.privilegios and (playertype.admin or playertype.semidios or playertype.dios) then
            tindex = nameindex(username)  'que user index?
            
            call loggm(.name, .name & " checke� el slot " & slot & " de " & username)
               
            if tindex > 0 then
                if slot > 0 and slot <= userlist(tindex).currentinventoryslots then
                    if userlist(tindex).invent.object(slot).objindex > 0 then
                        call writeconsolemsg(userindex, " objeto " & slot & ") " & objdata(userlist(tindex).invent.object(slot).objindex).name & " cantidad:" & userlist(tindex).invent.object(slot).amount, fonttypenames.fonttype_info)
                    else
                        call writeconsolemsg(userindex, "no hay ning�n objeto en slot seleccionado.", fonttypenames.fonttype_info)
                    end if
                else
                    call writeconsolemsg(userindex, "slot inv�lido.", fonttypenames.fonttype_talk)
                end if
            else
                call writeconsolemsg(userindex, "usuario offline.", fonttypenames.fonttype_talk)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handles the "resetautoupdate" message.
'
' @param    userindex the index of the user sending the message.

public sub handleresetautoupdate(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'reset the autoupdate
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        if ucase$(.name) <> "maraxus" then exit sub
        
        call writeconsolemsg(userindex, "tid: " & cstr(reiniciarautoupdate()), fonttypenames.fonttype_info)
    end with
end sub

''
' handles the "restart" message.
'
' @param    userindex the index of the user sending the message.

public sub handlerestart(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'restart the game
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
    
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        if ucase$(.name) <> "maraxus" then exit sub
        
        'time and time bug!
        call loggm(.name, .name & " reinici� el mundo.")
        
        call reiniciarservidor(true)
    end with
end sub

''
' handles the "reloadobjects" message.
'
' @param    userindex the index of the user sending the message.

public sub handlereloadobjects(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'reload the objects
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha recargado los objetos.")
        
        call loadobjdata
    end with
end sub

''
' handles the "reloadspells" message.
'
' @param    userindex the index of the user sending the message.

public sub handlereloadspells(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'reload the spells
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha recargado los hechizos.")
        
        call cargarhechizos
    end with
end sub

''
' handle the "reloadserverini" message.
'
' @param userindex the index of the user sending the message

public sub handlereloadserverini(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'reload the server`s ini
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha recargado los inits.")
        
        call loadsini
    end with
end sub

''
' handle the "reloadnpcs" message
'
' @param userindex the index of the user sending the message

public sub handlereloadnpcs(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'reload the server`s npc
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
         
        call loggm(.name, .name & " ha recargado los npcs.")
    
        call carganpcsdat
    
        call writeconsolemsg(userindex, "npcs.dat recargado.", fonttypenames.fonttype_info)
    end with
end sub

''
' handle the "kickallchars" message
'
' @param userindex the index of the user sending the message

public sub handlekickallchars(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'kick all the chars that are online
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha echado a todos los personajes.")
        
        call echarpjsnoprivilegiados
    end with
end sub

''
' handle the "night" message
'
' @param userindex the index of the user sending the message

public sub handlenight(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'last modified by: juan mart�n sotuyo dodero (maraxus)
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        if ucase$(.name) <> "maraxus" then exit sub
        
        denoche = not denoche
        
        dim i as long
        
        for i = 1 to numusers
            if userlist(i).flags.userlogged and userlist(i).connid > -1 then
                call enviarnoche(i)
            end if
        next i
    end with
end sub

''
' handle the "showserverform" message
'
' @param userindex the index of the user sending the message

public sub handleshowserverform(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'show the server form
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha solicitado mostrar el formulario del servidor.")
        call frmmain.mnumostrar_click
    end with
end sub

''
' handle the "cleansos" message
'
' @param userindex the index of the user sending the message

public sub handlecleansos(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'clean the sos
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha borrado los sos.")
        
        call ayuda.reset
    end with
end sub

''
' handle the "savechars" message
'
' @param userindex the index of the user sending the message

public sub handlesavechars(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/23/06
'save the characters
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha guardado todos los chars.")
        
        call mdparty.actualizaexperiencias
        call guardarusuarios
    end with
end sub

''
' handle the "changemapinfobackup" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinfobackup(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/24/06
'last modified by: juan mart�n sotuyo dodero (maraxus)
'change the backup`s info of the map
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim dothebackup as boolean
        
        dothebackup = .incomingdata.readboolean()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) = 0 then exit sub
        
        call loggm(.name, .name & " ha cambiado la informaci�n sobre el backup.")
        
        'change the boolean to byte in a fast way
        if dothebackup then
            mapinfo(.pos.map).backup = 1
        else
            mapinfo(.pos.map).backup = 0
        end if
        
        'change the boolean to string in a fast way
        call writevar(app.path & mappath & "mapa" & .pos.map & ".dat", "mapa" & .pos.map, "backup", mapinfo(.pos.map).backup)
        
        call writeconsolemsg(userindex, "mapa " & .pos.map & " backup: " & mapinfo(.pos.map).backup, fonttypenames.fonttype_info)
    end with
end sub

''
' handle the "changemapinfopk" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinfopk(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/24/06
'last modified by: juan mart�n sotuyo dodero (maraxus)
'change the pk`s info of the  map
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim ismappk as boolean
        
        ismappk = .incomingdata.readboolean()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) = 0 then exit sub
        
        call loggm(.name, .name & " ha cambiado la informaci�n sobre si es pk el mapa.")
        
        mapinfo(.pos.map).pk = ismappk
        
        'change the boolean to string in a fast way
        call writevar(app.path & mappath & "mapa" & .pos.map & ".dat", "mapa" & .pos.map, "pk", iif(ismappk, "1", "0"))

        call writeconsolemsg(userindex, "mapa " & .pos.map & " pk: " & mapinfo(.pos.map).pk, fonttypenames.fonttype_info)
    end with
end sub

''
' handle the "changemapinforestricted" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinforestricted(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'restringido -> options: "newbie", "no", "armada", "caos", "faccion".
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    dim tstr as string
    
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        tstr = buffer.readasciistring()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            if tstr = "newbie" or tstr = "no" or tstr = "armada" or tstr = "caos" or tstr = "faccion" then
                call loggm(.name, .name & " ha cambiado la informaci�n sobre si es restringido el mapa.")
                mapinfo(userlist(userindex).pos.map).restringir = tstr
                call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "restringir", tstr)
                call writeconsolemsg(userindex, "mapa " & .pos.map & " restringido: " & mapinfo(.pos.map).restringir, fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "opciones para restringir: 'newbie', 'no', 'armada', 'caos', 'faccion'", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "changemapinfonomagic" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinfonomagic(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'magiasinefecto -> options: "1" , "0".
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    dim nomagic as boolean
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        nomagic = .incomingdata.readboolean
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            call loggm(.name, .name & " ha cambiado la informaci�n sobre si est� permitido usar la magia el mapa.")
            mapinfo(userlist(userindex).pos.map).magiasinefecto = nomagic
            call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "magiasinefecto", nomagic)
            call writeconsolemsg(userindex, "mapa " & .pos.map & " magiasinefecto: " & mapinfo(.pos.map).magiasinefecto, fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handle the "changemapinfonoinvi" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinfonoinvi(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'invisinefecto -> options: "1", "0"
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    dim noinvi as boolean
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        noinvi = .incomingdata.readboolean()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            call loggm(.name, .name & " ha cambiado la informaci�n sobre si est� permitido usar la invisibilidad en el mapa.")
            mapinfo(userlist(userindex).pos.map).invisinefecto = noinvi
            call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "invisinefecto", noinvi)
            call writeconsolemsg(userindex, "mapa " & .pos.map & " invisinefecto: " & mapinfo(.pos.map).invisinefecto, fonttypenames.fonttype_info)
        end if
    end with
end sub
            
''
' handle the "changemapinfonoresu" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinfonoresu(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'resusinefecto -> options: "1", "0"
'***************************************************
    if userlist(userindex).incomingdata.length < 2 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    dim noresu as boolean
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        noresu = .incomingdata.readboolean()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            call loggm(.name, .name & " ha cambiado la informaci�n sobre si est� permitido usar el resucitar en el mapa.")
            mapinfo(userlist(userindex).pos.map).resusinefecto = noresu
            call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "resusinefecto", noresu)
            call writeconsolemsg(userindex, "mapa " & .pos.map & " resusinefecto: " & mapinfo(.pos.map).resusinefecto, fonttypenames.fonttype_info)
        end if
    end with
end sub

''
' handle the "changemapinfoland" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinfoland(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'terreno -> opciones: "bosque", "nieve", "desierto", "ciudad", "campo", "dungeon".
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    dim tstr as string
    
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        tstr = buffer.readasciistring()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            if tstr = "bosque" or tstr = "nieve" or tstr = "desierto" or tstr = "ciudad" or tstr = "campo" or tstr = "dungeon" then
                call loggm(.name, .name & " ha cambiado la informaci�n del terreno del mapa.")
                mapinfo(userlist(userindex).pos.map).terreno = tstr
                call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "terreno", tstr)
                call writeconsolemsg(userindex, "mapa " & .pos.map & " terreno: " & mapinfo(.pos.map).terreno, fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "opciones para terreno: 'bosque', 'nieve', 'desierto', 'ciudad', 'campo', 'dungeon'", fonttypenames.fonttype_info)
                call writeconsolemsg(userindex, "igualmente, el �nico �til es 'nieve' ya que al ingresarlo, la gente muere de fr�o en el mapa.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "changemapinfozone" message
'
' @param userindex the index of the user sending the message

public sub handlechangemapinfozone(byval userindex as integer)
'***************************************************
'author: pablo (toxicwaste)
'last modification: 26/01/2007
'zona -> opciones: "bosque", "nieve", "desierto", "ciudad", "campo", "dungeon".
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    dim tstr as string
    
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        tstr = buffer.readasciistring()
        
        if (.flags.privilegios and (playertype.admin or playertype.dios)) <> 0 then
            if tstr = "bosque" or tstr = "nieve" or tstr = "desierto" or tstr = "ciudad" or tstr = "campo" or tstr = "dungeon" then
                call loggm(.name, .name & " ha cambiado la informaci�n de la zona del mapa.")
                mapinfo(userlist(userindex).pos.map).zona = tstr
                call writevar(app.path & mappath & "mapa" & userlist(userindex).pos.map & ".dat", "mapa" & userlist(userindex).pos.map, "zona", tstr)
                call writeconsolemsg(userindex, "mapa " & .pos.map & " zona: " & mapinfo(.pos.map).zona, fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "opciones para terreno: 'bosque', 'nieve', 'desierto', 'ciudad', 'campo', 'dungeon'", fonttypenames.fonttype_info)
                call writeconsolemsg(userindex, "igualmente, el �nico �til es 'dungeon' ya que al ingresarlo, no se sentir� el efecto de la lluvia en este mapa.", fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "savemap" message
'
' @param userindex the index of the user sending the message

public sub handlesavemap(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/24/06
'saves the map
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha guardado el mapa " & cstr(.pos.map))
        
        call grabarmapa(.pos.map, app.path & "\worldbackup\mapa" & .pos.map)
        
        call writeconsolemsg(userindex, "mapa guardado.", fonttypenames.fonttype_info)
    end with
end sub

''
' handle the "showguildmessages" message
'
' @param userindex the index of the user sending the message

public sub handleshowguildmessages(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/24/06
'last modified by: juan mart�n sotuyo dodero (maraxus)
'allows admins to read guild messages
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim guild as string
        
        guild = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            call modguilds.gmescuchaclan(userindex, guild)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "dobackup" message
'
' @param userindex the index of the user sending the message

public sub handledobackup(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/24/06
'show guilds messages
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, .name & " ha hecho un backup.")
        
        call es.dobackup 'sino lo confunde con la id del paquete
    end with
end sub

''
' handle the "togglecentinelactivated" message
'
' @param userindex the index of the user sending the message

public sub handletogglecentinelactivated(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/26/06
'last modified by: juan mart�n sotuyo dodero (maraxus)
'activate or desactivate the centinel
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        centinelaactivado = not centinelaactivado
        
        with centinela
            .revisandouserindex = 0
            .clave = 0
            .tiemporestante = 0
        end with
    
        if centinelanpcindex then
            call quitarnpc(centinelanpcindex)
            centinelanpcindex = 0
        end if
        
        if centinelaactivado then
            call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("el centinela ha sido activado.", fonttypenames.fonttype_server))
        else
            call senddata(sendtarget.toadmins, 0, preparemessageconsolemsg("el centinela ha sido desactivado.", fonttypenames.fonttype_server))
        end if
    end with
end sub

''
' handle the "altername" message
'
' @param userindex the index of the user sending the message

public sub handlealtername(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/26/06
'change user name
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        'reads the username and newuser packets
        dim username as string
        dim newname as string
        dim changenameui as integer
        dim guildindex as integer
        
        username = buffer.readasciistring()
        newname = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            if lenb(username) = 0 or lenb(newname) = 0 then
                call writeconsolemsg(userindex, "usar: /aname origen@destino", fonttypenames.fonttype_info)
            else
                changenameui = nameindex(username)
                
                if changenameui > 0 then
                    call writeconsolemsg(userindex, "el pj est� online, debe salir para hacer el cambio.", fonttypenames.fonttype_warning)
                else
                    if not fileexist(charpath & username & ".chr") then
                        call writeconsolemsg(userindex, "el pj " & username & " es inexistente.", fonttypenames.fonttype_info)
                    else
                        guildindex = val(getvar(charpath & username & ".chr", "guild", "guildindex"))
                        
                        if guildindex > 0 then
                            call writeconsolemsg(userindex, "el pj " & username & " pertenece a un clan, debe salir del mismo con /salirclan para ser transferido.", fonttypenames.fonttype_info)
                        else
                            if not fileexist(charpath & newname & ".chr") then
                                call filecopy(charpath & username & ".chr", charpath & ucase$(newname) & ".chr")
                                
                                call writeconsolemsg(userindex, "transferencia exitosa.", fonttypenames.fonttype_info)
                                
                                call writevar(charpath & username & ".chr", "flags", "ban", "1")
                                
                                dim cantpenas as byte
                                
                                cantpenas = val(getvar(charpath & username & ".chr", "penas", "cant"))
                                
                                call writevar(charpath & username & ".chr", "penas", "cant", cstr(cantpenas + 1))
                                
                                call writevar(charpath & username & ".chr", "penas", "p" & cstr(cantpenas + 1), lcase$(.name) & ": ban por cambio de nick a " & ucase$(newname) & " " & date & " " & time)
                                
                                call loggm(.name, "ha cambiado de nombre al usuario " & username & ". ahora se llama " & newname)
                            else
                                call writeconsolemsg(userindex, "el nick solicitado ya existe.", fonttypenames.fonttype_info)
                            end if
                        end if
                    end if
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "altername" message
'
' @param userindex the index of the user sending the message

public sub handlealtermail(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/26/06
'change user password
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim newmail as string
        
        username = buffer.readasciistring()
        newmail = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            if lenb(username) = 0 or lenb(newmail) = 0 then
                call writeconsolemsg(userindex, "usar /aemail <pj>-<nuevomail>", fonttypenames.fonttype_info)
            else
                if not fileexist(charpath & username & ".chr") then
                    call writeconsolemsg(userindex, "no existe el charfile " & username & ".chr", fonttypenames.fonttype_info)
                else
                    call writevar(charpath & username & ".chr", "contacto", "email", newmail)
                    call writeconsolemsg(userindex, "email de " & username & " cambiado a: " & newmail, fonttypenames.fonttype_info)
                end if
                
                call loggm(.name, "le ha cambiado el mail a " & username)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "alterpassword" message
'
' @param userindex the index of the user sending the message

public sub handlealterpassword(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/26/06
'change user password
'***************************************************
    if userlist(userindex).incomingdata.length < 5 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim copyfrom as string
        dim password as string
        
        username = replace(buffer.readasciistring(), "+", " ")
        copyfrom = replace(buffer.readasciistring(), "+", " ")
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            call loggm(.name, "ha alterado la contrase�a de " & username)
            
            if lenb(username) = 0 or lenb(copyfrom) = 0 then
                call writeconsolemsg(userindex, "usar /apass <pjsinpass>@<pjconpass>", fonttypenames.fonttype_info)
            else
                if not fileexist(charpath & username & ".chr") or not fileexist(charpath & copyfrom & ".chr") then
                    call writeconsolemsg(userindex, "alguno de los pjs no existe " & username & "@" & copyfrom, fonttypenames.fonttype_info)
                else
                    password = getvar(charpath & copyfrom & ".chr", "init", "password")
                    call writevar(charpath & username & ".chr", "init", "password", password)
                    
                    call writeconsolemsg(userindex, "password de " & username & " ha cambiado por la de " & copyfrom, fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "handlecreatenpc" message
'
' @param userindex the index of the user sending the message

public sub handlecreatenpc(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/24/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim npcindex as integer
        
        npcindex = .incomingdata.readinteger()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        npcindex = spawnnpc(npcindex, .pos, true, false)
        
        if npcindex <> 0 then
            call loggm(.name, "sumone� a " & npclist(npcindex).name & " en mapa " & .pos.map)
        end if
    end with
end sub


''
' handle the "createnpcwithrespawn" message
'
' @param userindex the index of the user sending the message

public sub handlecreatenpcwithrespawn(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/24/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim npcindex as integer
        
        npcindex = .incomingdata.readinteger()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios) then exit sub
        
        npcindex = spawnnpc(npcindex, .pos, true, true)
        
        if npcindex <> 0 then
            call loggm(.name, "sumone� con respawn " & npclist(npcindex).name & " en mapa " & .pos.map)
        end if
    end with
end sub

''
' handle the "imperialarmour" message
'
' @param userindex the index of the user sending the message

public sub handleimperialarmour(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/24/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim index as byte
        dim objindex as integer
        
        index = .incomingdata.readbyte()
        objindex = .incomingdata.readinteger()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        select case index
            case 1
                armaduraimperial1 = objindex
            
            case 2
                armaduraimperial2 = objindex
            
            case 3
                armaduraimperial3 = objindex
            
            case 4
                tunicamagoimperial = objindex
        end select
    end with
end sub

''
' handle the "chaosarmour" message
'
' @param userindex the index of the user sending the message

public sub handlechaosarmour(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/24/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 4 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        dim index as byte
        dim objindex as integer
        
        index = .incomingdata.readbyte()
        objindex = .incomingdata.readinteger()
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        select case index
            case 1
                armaduracaos1 = objindex
            
            case 2
                armaduracaos2 = objindex
            
            case 3
                armaduracaos3 = objindex
            
            case 4
                tunicamagocaos = objindex
        end select
    end with
end sub

''
' handle the "navigatetoggle" message
'
' @param userindex the index of the user sending the message

public sub handlenavigatetoggle(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 01/12/07
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero) then exit sub
        
        if .flags.navegando = 1 then
            .flags.navegando = 0
        else
            .flags.navegando = 1
        end if
        
        'tell the client that we are navigating.
        call writenavigatetoggle(userindex)
    end with
end sub

''
' handle the "serveropentouserstoggle" message
'
' @param userindex the index of the user sending the message

public sub handleserveropentouserstoggle(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/24/06
'
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        if serversologms > 0 then
            call writeconsolemsg(userindex, "servidor habilitado para todos.", fonttypenames.fonttype_info)
            serversologms = 0
        else
            call writeconsolemsg(userindex, "servidor restringido a administradores.", fonttypenames.fonttype_info)
            serversologms = 1
        end if
    end with
end sub

''
' handle the "turnoffserver" message
'
' @param userindex the index of the user sending the message

public sub handleturnoffserver(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/24/06
'turns off the server
'***************************************************
    dim handle as integer
    
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if .flags.privilegios and (playertype.user or playertype.consejero or playertype.semidios or playertype.rolemaster) then exit sub
        
        call loggm(.name, "/apagar")
        call senddata(sendtarget.toall, 0, preparemessageconsolemsg("���" & .name & " va a apagar el servidor!!!", fonttypenames.fonttype_fight))
        
        'log
        handle = freefile
        open app.path & "\logs\main.log" for append shared as #handle
        
        print #handle, date & " " & time & " server apagado por " & .name & ". "
        
        close #handle
        
        unload frmmain
    end with
end sub

''
' handle the "turncriminal" message
'
' @param userindex the index of the user sending the message

public sub handleturncriminal(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/26/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            call loggm(.name, "/conden " & username)
            
            tuser = nameindex(username)
            if tuser > 0 then _
                call volvercriminal(tuser)
        end if
                
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "resetfactions" message
'
' @param userindex the index of the user sending the message

public sub handleresetfactions(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 06/09/09
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim tuser as integer
        dim char as string
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            call loggm(.name, "/rajar " & username)
            
            tuser = nameindex(username)
            
            if tuser > 0 then
                call resetfacciones(tuser)
            else
                char = charpath & username & ".chr"
                
                if fileexist(char, vbnormal) then
                    call writevar(char, "facciones", "ejercitoreal", 0)
                    call writevar(char, "facciones", "ciudmatados", 0)
                    call writevar(char, "facciones", "crimmatados", 0)
                    call writevar(char, "facciones", "ejercitocaos", 0)
                    call writevar(char, "facciones", "fechaingreso", "no ingres� a ninguna facci�n")
                    call writevar(char, "facciones", "rarcaos", 0)
                    call writevar(char, "facciones", "rarreal", 0)
                    call writevar(char, "facciones", "rexcaos", 0)
                    call writevar(char, "facciones", "rexreal", 0)
                    call writevar(char, "facciones", "reccaos", 0)
                    call writevar(char, "facciones", "recreal", 0)
                    call writevar(char, "facciones", "reenlistadas", 0)
                    call writevar(char, "facciones", "nivelingreso", 0)
                    call writevar(char, "facciones", "matadosingreso", 0)
                    call writevar(char, "facciones", "nextrecompensa", 0)
                else
                    call writeconsolemsg(userindex, "el personaje " & username & " no existe.", fonttypenames.fonttype_info)
                end if
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "removecharfromguild" message
'
' @param userindex the index of the user sending the message

public sub handleremovecharfromguild(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/26/06
'
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim guildindex as integer
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            call loggm(.name, "/rajarclan " & username)
            
            guildindex = modguilds.m_echarmiembrodeclan(userindex, username)
            
            if guildindex = 0 then
                call writeconsolemsg(userindex, "no pertenece a ning�n clan o es fundador.", fonttypenames.fonttype_info)
            else
                call writeconsolemsg(userindex, "expulsado.", fonttypenames.fonttype_info)
                call senddata(sendtarget.toguildmembers, guildindex, preparemessageconsolemsg(username & " ha sido expulsado del clan por los administradores del servidor.", fonttypenames.fonttype_guild))
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "requestcharmail" message
'
' @param userindex the index of the user sending the message

public sub handlerequestcharmail(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/26/06
'request user mail
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim username as string
        dim mail as string
        
        username = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            if fileexist(charpath & username & ".chr") then
                mail = getvar(charpath & username & ".chr", "contacto", "email")
                
                call writeconsolemsg(userindex, "last email de " & username & ":" & mail, fonttypenames.fonttype_info)
            end if
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "systemmessage" message
'
' @param userindex the index of the user sending the message

public sub handlesystemmessage(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/29/06
'send a message to all the users
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim message as string
        message = buffer.readasciistring()
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            call loggm(.name, "mensaje de sistema:" & message)
            
            call senddata(sendtarget.toall, 0, preparemessageshowmessagebox(message))
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "setmotd" message
'
' @param userindex the index of the user sending the message

public sub handlesetmotd(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 03/31/07
'set the motd
'modified by: juan mart�n sotuyo dodero (maraxus)
'   - fixed a bug that prevented from properly setting the new number of lines.
'   - fixed a bug that caused the player to be kicked.
'***************************************************
    if userlist(userindex).incomingdata.length < 3 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if
    
on error goto errhandler
    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        call buffer.copybuffer(.incomingdata)
        
        'remove packet id
        call buffer.readbyte
        
        dim newmotd as string
        dim auxiliarystring() as string
        dim loopc as long
        
        newmotd = buffer.readasciistring()
        auxiliarystring = split(newmotd, vbcrlf)
        
        if (not .flags.privilegios and playertype.rolemaster) <> 0 and (.flags.privilegios and (playertype.admin or playertype.dios)) then
            call loggm(.name, "ha fijado un nuevo motd")
            
            maxlines = ubound(auxiliarystring()) + 1
            
            redim motd(1 to maxlines)
            
            call writevar(app.path & "\dat\motd.ini", "init", "numlines", cstr(maxlines))
            
            for loopc = 1 to maxlines
                call writevar(app.path & "\dat\motd.ini", "motd", "line" & cstr(loopc), auxiliarystring(loopc - 1))
                
                motd(loopc).texto = auxiliarystring(loopc - 1)
            next loopc
            
            call writeconsolemsg(userindex, "se ha cambiado el motd con �xito.", fonttypenames.fonttype_info)
        end if
        
        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' handle the "changemotd" message
'
' @param userindex the index of the user sending the message

public sub handlechangemotd(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/29/06
'change the motd
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        if (.flags.privilegios and (playertype.rolemaster or playertype.user or playertype.consejero or playertype.semidios)) then
            exit sub
        end if
        
        dim auxiliarystring as string
        dim loopc as long
        
        for loopc = lbound(motd()) to ubound(motd())
            auxiliarystring = auxiliarystring & motd(loopc).texto & vbcrlf
        next loopc
        
        if len(auxiliarystring) >= 2 then
            if right$(auxiliarystring, 2) = vbcrlf then
                auxiliarystring = left$(auxiliarystring, len(auxiliarystring) - 2)
            end if
        end if
        
        call writeshowmotdeditionform(userindex, auxiliarystring)
    end with
end sub

''
' handle the "ping" message
'
' @param userindex the index of the user sending the message

public sub handleping(byval userindex as integer)
'***************************************************
'author: lucas tavolaro ortiz (tavo)
'last modification: 12/24/06
'show guilds messages
'***************************************************
    with userlist(userindex)
        'remove packet id
        call .incomingdata.readbyte
        
        call writepong(userindex)
    end with
end sub

''
' handle the "setinivar" message
'
' @param userindex the index of the user sending the message

public sub handlesetinivar(byval userindex as integer)
'***************************************************
'author: brian chaia (brianpr)
'last modification: 01/23/10 (marco)
'modify server.ini
'***************************************************
    if userlist(userindex).incomingdata.length < 6 then
        err.raise userlist(userindex).incomingdata.notenoughdataerrcode
        exit sub
    end if

on error goto errhandler

    with userlist(userindex)
        'this packet contains strings, make a copy of the data to prevent losses if it's not complete yet...
        dim buffer as new clsbytequeue
        
        call buffer.copybuffer(.incomingdata)

        'remove packet id
        call buffer.readbyte

        dim sllave as string
        dim sclave as string
        dim svalor as string

        'obtengo los par�metros
        sllave = buffer.readasciistring()
        sclave = buffer.readasciistring()
        svalor = buffer.readasciistring()

        if .flags.privilegios and (playertype.admin or playertype.dios) then
            dim stmp as string

            'no podemos modificar [init]dioses ni [dioses]*
            if (ucase$(sllave) = "init" and ucase$(sclave) = "dioses") or ucase$(sllave) = "dioses" then
                call writeconsolemsg(userindex, "�no puedes modificar esa informaci�n desde aqu�!", fonttypenames.fonttype_info)
            else
                'obtengo el valor seg�n llave y clave
                stmp = getvar(inipath & "server.ini", sllave, sclave)

                'si obtengo un valor escribo en el server.ini
                if lenb(stmp) then
                    call writevar(inipath & "server.ini", sllave, sclave, svalor)
                    call loggm(.name, "modific� en server.ini (" & sllave & " " & sclave & ") el valor " & stmp & " por " & svalor)
                    call writeconsolemsg(userindex, "modific� " & sllave & " " & sclave & " a " & svalor & ". valor anterior " & stmp, fonttypenames.fonttype_info)
                else
                    call writeconsolemsg(userindex, "no existe la llave y/o clave", fonttypenames.fonttype_info)
                end if
            end if
        end if

        'if we got here then packet is complete, copy data back to original queue
        call .incomingdata.copybuffer(buffer)
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
' writes the "logged" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeloggedmessage(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "logged" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.logged)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "removedialogs" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeremovealldialogs(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "removedialogs" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.removedialogs)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "removechardialog" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    charindex character whose dialog will be removed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeremovechardialog(byval userindex as integer, byval charindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "removechardialog" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageremovechardialog(charindex))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "navigatetoggle" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writenavigatetoggle(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "navigatetoggle" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.navigatetoggle)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "disconnect" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedisconnect(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "disconnect" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.disconnect)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "userofferconfirm" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeuserofferconfirm(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 14/12/2009
'writes the "userofferconfirm" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.userofferconfirm)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub


''
' writes the "commerceend" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecommerceend(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "commerceend" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.commerceend)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "bankend" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankend(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankend" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.bankend)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "commerceinit" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecommerceinit(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "commerceinit" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.commerceinit)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "bankinit" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankinit(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankinit" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.bankinit)
    call userlist(userindex).outgoingdata.writelong(userlist(userindex).stats.banco)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "usercommerceinit" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercommerceinit(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "usercommerceinit" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.usercommerceinit)
    call userlist(userindex).outgoingdata.writeasciistring(userlist(userindex).comusu.destnick)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "usercommerceend" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercommerceend(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "usercommerceend" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.usercommerceend)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showblacksmithform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowblacksmithform(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showblacksmithform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.showblacksmithform)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showcarpenterform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowcarpenterform(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showcarpenterform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.showcarpenterform)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updatesta" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatesta(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "updatemana" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatesta)
        call .writeinteger(userlist(userindex).stats.minsta)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updatemana" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatemana(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "updatemana" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatemana)
        call .writeinteger(userlist(userindex).stats.minman)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updatehp" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatehp(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "updatemana" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatehp)
        call .writeinteger(userlist(userindex).stats.minhp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updategold" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdategold(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "updategold" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updategold)
        call .writelong(userlist(userindex).stats.gld)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updatebankgold" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatebankgold(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 14/12/2009
'writes the "updatebankgold" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatebankgold)
        call .writelong(userlist(userindex).stats.banco)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub


''
' writes the "updateexp" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdateexp(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "updateexp" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updateexp)
        call .writelong(userlist(userindex).stats.exp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updatestrenghtanddexterity" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatestrenghtanddexterity(byval userindex as integer)
'***************************************************
'author: budi
'last modification: 11/26/09
'writes the "updatestrenghtanddexterity" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatestrenghtanddexterity)
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.fuerza))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.agilidad))
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

' writes the "updatestrenghtanddexterity" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatedexterity(byval userindex as integer)
'***************************************************
'author: budi
'last modification: 11/26/09
'writes the "updatestrenghtanddexterity" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatedexterity)
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.agilidad))
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

' writes the "updatestrenghtanddexterity" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatestrenght(byval userindex as integer)
'***************************************************
'author: budi
'last modification: 11/26/09
'writes the "updatestrenghtanddexterity" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatestrenght)
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.fuerza))
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "changemap" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    map the new map to load.
' @param    version the version of the map in the server to check if client is properly updated.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangemap(byval userindex as integer, byval map as integer, byval version as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "changemap" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.changemap)
        call .writeinteger(map)
        call .writeinteger(version)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "posupdate" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeposupdate(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "posupdate" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.posupdate)
        call .writebyte(userlist(userindex).pos.x)
        call .writebyte(userlist(userindex).pos.y)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "chatoverhead" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    chat text to be displayed over the char's head.
' @param    charindex the character uppon which the chat will be displayed.
' @param    color the color to be used when displaying the chat.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechatoverhead(byval userindex as integer, byval chat as string, byval charindex as integer, byval color as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "chatoverhead" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagechatoverhead(chat, charindex, color))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "consolemsg" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    chat text to be displayed over the char's head.
' @param    fontindex index of the fonttype structure to use.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeconsolemsg(byval userindex as integer, byval chat as string, byval fontindex as fonttypenames)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "consolemsg" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageconsolemsg(chat, fontindex))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

public sub writecommercechat(byval userindex as integer, byval chat as string, byval fontindex as fonttypenames)
'***************************************************
'author: zama
'last modification: 05/17/06
'writes the "consolemsg" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparecommerceconsolemsg(chat, fontindex))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub
            
''
' writes the "guildchat" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    chat text to be displayed over the char's head.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildchat(byval userindex as integer, byval chat as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildchat" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageguildchat(chat))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showmessagebox" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    message text to be displayed in the message box.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowmessagebox(byval userindex as integer, byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showmessagebox" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.showmessagebox)
        call .writeasciistring(message)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "userindexinserver" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeuserindexinserver(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "userindexinserver" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.userindexinserver)
        call .writeinteger(userindex)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "usercharindexinserver" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusercharindexinserver(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "userindexinserver" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.usercharindexinserver)
        call .writeinteger(userlist(userindex).char.charindex)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "charactercreate" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    body body index of the new character.
' @param    head head index of the new character.
' @param    heading heading in which the new character is looking.
' @param    charindex the index of the new character.
' @param    x x coord of the new character's position.
' @param    y y coord of the new character's position.
' @param    weapon weapon index of the new character.
' @param    shield shield index of the new character.
' @param    fx fx index to be displayed over the new character.
' @param    fxloops number of times the fx should be rendered.
' @param    helmet helmet index of the new character.
' @param    name name of the new character.
' @param    criminal determines if the character is a criminal or not.
' @param    privileges sets if the character is a normal one or any kind of administrative character.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecharactercreate(byval userindex as integer, byval body as integer, byval head as integer, byval heading as eheading, _
                                byval charindex as integer, byval x as byte, byval y as byte, byval weapon as integer, byval shield as integer, _
                                byval fx as integer, byval fxloops as integer, byval helmet as integer, byval name as string, byval nickcolor as byte, _
                                byval privileges as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "charactercreate" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagecharactercreate(body, head, heading, charindex, x, y, weapon, shield, fx, fxloops, _
                                                            helmet, name, nickcolor, privileges))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "characterremove" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    charindex character to be removed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecharacterremove(byval userindex as integer, byval charindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "characterremove" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagecharacterremove(charindex))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "charactermove" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    charindex character which is moving.
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecharactermove(byval userindex as integer, byval charindex as integer, byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "charactermove" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagecharactermove(charindex, x, y))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

public sub writeforcecharmove(byval userindex, byval direccion as eheading)
'***************************************************
'author: zama
'last modification: 26/03/2009
'writes the "forcecharmove" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageforcecharmove(direccion))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "characterchange" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    body body index of the new character.
' @param    head head index of the new character.
' @param    heading heading in which the new character is looking.
' @param    charindex the index of the new character.
' @param    weapon weapon index of the new character.
' @param    shield shield index of the new character.
' @param    fx fx index to be displayed over the new character.
' @param    fxloops number of times the fx should be rendered.
' @param    helmet helmet index of the new character.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecharacterchange(byval userindex as integer, byval body as integer, byval head as integer, byval heading as eheading, _
                                byval charindex as integer, byval weapon as integer, byval shield as integer, _
                                byval fx as integer, byval fxloops as integer, byval helmet as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "characterchange" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagecharacterchange(body, head, heading, charindex, weapon, shield, fx, fxloops, helmet))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "objectcreate" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    grhindex grh of the object.
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeobjectcreate(byval userindex as integer, byval grhindex as integer, byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "objectcreate" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageobjectcreate(grhindex, x, y))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "objectdelete" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeobjectdelete(byval userindex as integer, byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "objectdelete" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageobjectdelete(x, y))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "blockposition" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @param    blocked true if the position is blocked.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeblockposition(byval userindex as integer, byval x as byte, byval y as byte, byval blocked as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "blockposition" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.blockposition)
        call .writebyte(x)
        call .writebyte(y)
        call .writeboolean(blocked)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "playmidi" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    midi the midi to be played.
' @param    loops number of repets for the midi.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeplaymidi(byval userindex as integer, byval midi as byte, optional byval loops as integer = -1)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "playmidi" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageplaymidi(midi, loops))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "playwave" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    wave the wave to be played.
' @param    x the x position in map coordinates from where the sound comes.
' @param    y the y position in map coordinates from where the sound comes.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeplaywave(byval userindex as integer, byval wave as byte, byval x as byte, byval y as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/08/07
'last modified by: rapsodius
'added x and y positions for 3d sounds
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageplaywave(wave, x, y))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "guildlist" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    guildlist list of guilds to be sent.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildlist(byval userindex as integer, byref guildlist() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildlist" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim tmp as string
    dim i as long
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.guildlist)
        
        ' prepare guild name's list
        for i = lbound(guildlist()) to ubound(guildlist())
            tmp = tmp & guildlist(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "areachanged" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeareachanged(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "areachanged" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.areachanged)
        call .writebyte(userlist(userindex).pos.x)
        call .writebyte(userlist(userindex).pos.y)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "pausetoggle" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepausetoggle(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "pausetoggle" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagepausetoggle())
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "raintoggle" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeraintoggle(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "raintoggle" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageraintoggle())
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "createfx" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    charindex character upon which the fx will be created.
' @param    fx fx index to be displayed over the new character.
' @param    fxloops number of times the fx should be rendered.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecreatefx(byval userindex as integer, byval charindex as integer, byval fx as integer, byval fxloops as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "createfx" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagecreatefx(charindex, fx, fxloops))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updateuserstats" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdateuserstats(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "updateuserstats" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updateuserstats)
        call .writeinteger(userlist(userindex).stats.maxhp)
        call .writeinteger(userlist(userindex).stats.minhp)
        call .writeinteger(userlist(userindex).stats.maxman)
        call .writeinteger(userlist(userindex).stats.minman)
        call .writeinteger(userlist(userindex).stats.maxsta)
        call .writeinteger(userlist(userindex).stats.minsta)
        call .writelong(userlist(userindex).stats.gld)
        call .writebyte(userlist(userindex).stats.elv)
        call .writelong(userlist(userindex).stats.elu)
        call .writelong(userlist(userindex).stats.exp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "workrequesttarget" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    skill the skill for which we request a target.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeworkrequesttarget(byval userindex as integer, byval skill as eskill)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "workrequesttarget" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.workrequesttarget)
        call .writebyte(skill)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "changeinventoryslot" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    slot inventory slot which needs to be updated.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangeinventoryslot(byval userindex as integer, byval slot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 3/12/09
'writes the "changeinventoryslot" message to the given user's outgoing data buffer
'3/12/09: budi - ahora se envia maxdef y mindef en lugar de def
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.changeinventoryslot)
        call .writebyte(slot)
        
        dim objindex as integer
        dim obdata as objdata
        
        objindex = userlist(userindex).invent.object(slot).objindex
        
        if objindex > 0 then
            obdata = objdata(objindex)
        end if
        
        call .writeinteger(objindex)
        call .writeasciistring(obdata.name)
        call .writeinteger(userlist(userindex).invent.object(slot).amount)
        call .writeboolean(userlist(userindex).invent.object(slot).equipped)
        call .writeinteger(obdata.grhindex)
        call .writebyte(obdata.objtype)
        call .writeinteger(obdata.maxhit)
        call .writeinteger(obdata.minhit)
        call .writeinteger(obdata.maxdef)
        call .writeinteger(obdata.mindef)
        call .writesingle(saleprice(objindex))
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

public sub writeaddslots(byval userindex as integer, byval mochila as emochilas)
'***************************************************
'author: budi
'last modification: 01/12/09
'writes the "addslots" message to the given user's outgoing data buffer
'***************************************************
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.addslots)
        call .writebyte(mochila)
    end with
end sub


''
' writes the "changebankslot" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    slot inventory slot which needs to be updated.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangebankslot(byval userindex as integer, byval slot as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/03/09
'writes the "changebankslot" message to the given user's outgoing data buffer
'12/03/09: budi - ahora se envia maxdef y mindef en lugar de s�lo def
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.changebankslot)
        call .writebyte(slot)
        
        dim objindex as integer
        dim obdata as objdata
        
        objindex = userlist(userindex).bancoinvent.object(slot).objindex
        
        call .writeinteger(objindex)
        
        if objindex > 0 then
            obdata = objdata(objindex)
        end if
        
        call .writeasciistring(obdata.name)
        call .writeinteger(userlist(userindex).bancoinvent.object(slot).amount)
        call .writeinteger(obdata.grhindex)
        call .writebyte(obdata.objtype)
        call .writeinteger(obdata.maxhit)
        call .writeinteger(obdata.minhit)
        call .writeinteger(obdata.maxdef)
        call .writeinteger(obdata.mindef)
        call .writelong(obdata.valor)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "changespellslot" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    slot spell slot to update.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangespellslot(byval userindex as integer, byval slot as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "changespellslot" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.changespellslot)
        call .writebyte(slot)
        call .writeinteger(userlist(userindex).stats.userhechizos(slot))
        
        if userlist(userindex).stats.userhechizos(slot) > 0 then
            call .writeasciistring(hechizos(userlist(userindex).stats.userhechizos(slot)).nombre)
        else
            call .writeasciistring("(none)")
        end if
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "atributes" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeattributes(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "atributes" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.atributes)
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.fuerza))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.agilidad))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.inteligencia))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.carisma))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.constitucion))
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "blacksmithweapons" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeblacksmithweapons(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/15/2008 (niconz) habia un error al fijarse los skills del personaje
'writes the "blacksmithweapons" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim obj as objdata
    dim validindexes() as integer
    dim count as integer
    
    redim validindexes(1 to ubound(armasherrero()))
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.blacksmithweapons)
        
        for i = 1 to ubound(armasherrero())
            ' can the user create this object? if so add it to the list....
            if objdata(armasherrero(i)).skherreria <= round(userlist(userindex).stats.userskills(eskill.herreria) / modherreria(userlist(userindex).clase), 0) then
                count = count + 1
                validindexes(count) = i
            end if
        next i
        
        ' write the number of objects in the list
        call .writeinteger(count)
        
        ' write the needed data of each object
        for i = 1 to count
            obj = objdata(armasherrero(validindexes(i)))
            call .writeasciistring(obj.name)
            call .writeinteger(obj.grhindex)
            call .writeinteger(obj.lingh)
            call .writeinteger(obj.lingp)
            call .writeinteger(obj.lingo)
            call .writeinteger(armasherrero(validindexes(i)))
            call .writeinteger(obj.upgrade)
        next i
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "blacksmitharmors" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeblacksmitharmors(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/15/2008 (niconz) habia un error al fijarse los skills del personaje
'writes the "blacksmitharmors" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim obj as objdata
    dim validindexes() as integer
    dim count as integer
    
    redim validindexes(1 to ubound(armadurasherrero()))
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.blacksmitharmors)
        
        for i = 1 to ubound(armadurasherrero())
            ' can the user create this object? if so add it to the list....
            if objdata(armadurasherrero(i)).skherreria <= round(userlist(userindex).stats.userskills(eskill.herreria) / modherreria(userlist(userindex).clase), 0) then
                count = count + 1
                validindexes(count) = i
            end if
        next i
        
        ' write the number of objects in the list
        call .writeinteger(count)
        
        ' write the needed data of each object
        for i = 1 to count
            obj = objdata(armadurasherrero(validindexes(i)))
            call .writeasciistring(obj.name)
            call .writeinteger(obj.grhindex)
            call .writeinteger(obj.lingh)
            call .writeinteger(obj.lingp)
            call .writeinteger(obj.lingo)
            call .writeinteger(armadurasherrero(validindexes(i)))
            call .writeinteger(obj.upgrade)
        next i
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "carpenterobjects" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecarpenterobjects(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "carpenterobjects" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim obj as objdata
    dim validindexes() as integer
    dim count as integer
    
    redim validindexes(1 to ubound(objcarpintero()))
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.carpenterobjects)
        
        for i = 1 to ubound(objcarpintero())
            ' can the user create this object? if so add it to the list....
            if objdata(objcarpintero(i)).skcarpinteria <= userlist(userindex).stats.userskills(eskill.carpinteria) \ modcarpinteria(userlist(userindex).clase) then
                count = count + 1
                validindexes(count) = i
            end if
        next i
        
        ' write the number of objects in the list
        call .writeinteger(count)
        
        ' write the needed data of each object
        for i = 1 to count
            obj = objdata(objcarpintero(validindexes(i)))
            call .writeasciistring(obj.name)
            call .writeinteger(obj.grhindex)
            call .writeinteger(obj.madera)
            call .writeinteger(obj.maderaelfica)
            call .writeinteger(objcarpintero(validindexes(i)))
            call .writeinteger(obj.upgrade)
        next i
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "restok" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writerestok(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "restok" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.restok)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "errormsg" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    message the error message to be displayed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeerrormsg(byval userindex as integer, byval message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "errormsg" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessageerrormsg(message))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "blind" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeblind(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "blind" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.blind)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "dumb" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedumb(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "dumb" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.dumb)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showsignal" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    objindex index of the signal to be displayed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowsignal(byval userindex as integer, byval objindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showsignal" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.showsignal)
        call .writeasciistring(objdata(objindex).texto)
        call .writeinteger(objdata(objindex).grhsecundario)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "changenpcinventoryslot" message to the given user's outgoing data buffer.
'
' @param    userindex   user to which the message is intended.
' @param    slot        the inventory slot in which this item is to be placed.
' @param    obj         the object to be set in the npc's inventory window.
' @param    price       the value the npc asks for the object.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangenpcinventoryslot(byval userindex as integer, byval slot as byte, byref obj as obj, byval price as single)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/03/09
'last modified by: budi
'writes the "changenpcinventoryslot" message to the given user's outgoing data buffer
'12/03/09: budi - ahora se envia maxdef y mindef en lugar de s�lo def
'***************************************************
on error goto errhandler
    dim objinfo as objdata
    
    if obj.objindex >= lbound(objdata()) and obj.objindex <= ubound(objdata()) then
        objinfo = objdata(obj.objindex)
    end if
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.changenpcinventoryslot)
        call .writebyte(slot)
        call .writeasciistring(objinfo.name)
        call .writeinteger(obj.amount)
        call .writesingle(price)
        call .writeinteger(objinfo.grhindex)
        call .writeinteger(obj.objindex)
        call .writebyte(objinfo.objtype)
        call .writeinteger(objinfo.maxhit)
        call .writeinteger(objinfo.minhit)
        call .writeinteger(objinfo.maxdef)
        call .writeinteger(objinfo.mindef)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "updatehungerandthirst" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeupdatehungerandthirst(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "updatehungerandthirst" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.updatehungerandthirst)
        call .writebyte(userlist(userindex).stats.maxagu)
        call .writebyte(userlist(userindex).stats.minagu)
        call .writebyte(userlist(userindex).stats.maxham)
        call .writebyte(userlist(userindex).stats.minham)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "fame" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writefame(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "fame" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.fame)
        
        call .writelong(userlist(userindex).reputacion.asesinorep)
        call .writelong(userlist(userindex).reputacion.bandidorep)
        call .writelong(userlist(userindex).reputacion.burguesrep)
        call .writelong(userlist(userindex).reputacion.ladronesrep)
        call .writelong(userlist(userindex).reputacion.noblerep)
        call .writelong(userlist(userindex).reputacion.pleberep)
        call .writelong(userlist(userindex).reputacion.promedio)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "ministats" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeministats(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "ministats" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.ministats)
        
        call .writelong(userlist(userindex).faccion.ciudadanosmatados)
        call .writelong(userlist(userindex).faccion.criminalesmatados)
        
'todo : este valor es calculable, no deber�a ni existir, ya sea en el servidor ni en el cliente!!!
        call .writelong(userlist(userindex).stats.usuariosmatados)
        
        call .writeinteger(userlist(userindex).stats.npcsmuertos)
        
        call .writebyte(userlist(userindex).clase)
        call .writelong(userlist(userindex).counters.pena)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "levelup" message to the given user's outgoing data buffer.
'
' @param    skillpoints the number of free skill points the player has.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writelevelup(byval userindex as integer, byval skillpoints as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "levelup" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.levelup)
        call .writeinteger(skillpoints)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "addforummsg" message to the given user's outgoing data buffer.
'
' @param    title the title of the message to display.
' @param    message the message to be displayed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeaddforummsg(byval userindex as integer, byval forumtype as eforumtype, _
                    byref title as string, byref author as string, byref message as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 02/01/2010
'writes the "addforummsg" message to the given user's outgoing data buffer
'02/01/2010: zama - now sends author and forum type
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.addforummsg)
        call .writebyte(forumtype)
        call .writeasciistring(title)
        call .writeasciistring(author)
        call .writeasciistring(message)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showforumform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowforumform(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showforumform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler

    dim visibilidad as byte
    dim canmakesticky as byte
    
    with userlist(userindex)
        call .outgoingdata.writebyte(serverpacketid.showforumform)
        
        visibilidad = eforumvisibility.iegeneral_member
        
        if escaos(userindex) or esgm(userindex) then
            visibilidad = visibilidad or eforumvisibility.iecaos_member
        end if
        
        if esarmada(userindex) or esgm(userindex) then
            visibilidad = visibilidad or eforumvisibility.iereal_member
        end if
        
        call .outgoingdata.writebyte(visibilidad)
        
        ' pueden mandar sticky los gms o los del consejo de armada/caos
        if esgm(userindex) then
            canmakesticky = 2
        elseif (.flags.privilegios and playertype.chaoscouncil) <> 0 then
            canmakesticky = 1
        elseif (.flags.privilegios and playertype.royalcouncil) <> 0 then
            canmakesticky = 1
        end if
        
        call .outgoingdata.writebyte(canmakesticky)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "setinvisible" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    charindex the char turning visible / invisible.
' @param    invisible true if the char is no longer visible, false otherwise.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesetinvisible(byval userindex as integer, byval charindex as integer, byval invisible as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "setinvisible" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writeasciistringfixed(preparemessagesetinvisible(charindex, invisible))
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "diceroll" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writediceroll(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "diceroll" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.diceroll)
        
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.fuerza))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.agilidad))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.inteligencia))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.carisma))
        call .writebyte(userlist(userindex).stats.useratributos(eatributos.constitucion))
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "meditatetoggle" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writemeditatetoggle(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "meditatetoggle" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.meditatetoggle)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "blindnomore" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeblindnomore(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "blindnomore" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.blindnomore)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "dumbnomore" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writedumbnomore(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "dumbnomore" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.dumbnomore)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "sendskills" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesendskills(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 11/19/09
'writes the "sendskills" message to the given user's outgoing data buffer
'11/19/09: pato - now send the percentage of progress of the skills.
'***************************************************
on error goto errhandler
    dim i as long
    
    with userlist(userindex)
        call .outgoingdata.writebyte(serverpacketid.sendskills)
        call .outgoingdata.writebyte(.clase)
        
        for i = 1 to numskills
            call .outgoingdata.writebyte(userlist(userindex).stats.userskills(i))
            if .stats.userskills(i) < maxskillpoints then
                call .outgoingdata.writebyte(int(.stats.expskills(i) * 100 / .stats.eluskills(i)))
            else
                call .outgoingdata.writebyte(0)
            end if
        next i
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "trainercreaturelist" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    npcindex the index of the requested trainer.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetrainercreaturelist(byval userindex as integer, byval npcindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "trainercreaturelist" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim str as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.trainercreaturelist)
        
        for i = 1 to npclist(npcindex).nrocriaturas
            str = str & npclist(npcindex).criaturas(i).npcname & separator
        next i
        
        if lenb(str) > 0 then _
            str = left$(str, len(str) - 1)
        
        call .writeasciistring(str)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "guildnews" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    guildnews the guild's news.
' @param    enemies the list of the guild's enemies.
' @param    allies the list of the guild's allies.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildnews(byval userindex as integer, byval guildnews as string, byref enemies() as string, byref allies() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildnews" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.guildnews)
        
        call .writeasciistring(guildnews)
        
        'prepare enemies' list
        for i = lbound(enemies()) to ubound(enemies())
            tmp = tmp & enemies(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
        
        tmp = vbnullstring
        'prepare allies' list
        for i = lbound(allies()) to ubound(allies())
            tmp = tmp & allies(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "offerdetails" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    details th details of the peace proposition.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeofferdetails(byval userindex as integer, byval details as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "offerdetails" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.offerdetails)
        
        call .writeasciistring(details)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "alianceproposalslist" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    guilds the list of guilds which propossed an alliance.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writealianceproposalslist(byval userindex as integer, byref guilds() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "alianceproposalslist" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.alianceproposalslist)
        
        ' prepare guild's list
        for i = lbound(guilds()) to ubound(guilds())
            tmp = tmp & guilds(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "peaceproposalslist" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    guilds the list of guilds which propossed peace.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepeaceproposalslist(byval userindex as integer, byref guilds() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "peaceproposalslist" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.peaceproposalslist)
                
        ' prepare guilds' list
        for i = lbound(guilds()) to ubound(guilds())
            tmp = tmp & guilds(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "characterinfo" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    charname the requested char's name.
' @param    race the requested char's race.
' @param    class the requested char's class.
' @param    gender the requested char's gender.
' @param    level the requested char's level.
' @param    gold the requested char's gold.
' @param    reputation the requested char's reputation.
' @param    previouspetitions the requested char's previous petitions to enter guilds.
' @param    currentguild the requested char's current guild.
' @param    previousguilds the requested char's previous guilds.
' @param    royalarmy true if tha char belongs to the royal army.
' @param    caoslegion true if tha char belongs to the caos legion.
' @param    citicenskilled the number of citicens killed by the requested char.
' @param    criminalskilled the number of criminals killed by the requested char.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writecharacterinfo(byval userindex as integer, byval charname as string, byval race as eraza, byval class as eclass, _
                            byval gender as egenero, byval level as byte, byval gold as long, byval bank as long, byval reputation as long, _
                            byval previouspetitions as string, byval currentguild as string, byval previousguilds as string, byval royalarmy as boolean, _
                            byval caoslegion as boolean, byval citicenskilled as long, byval criminalskilled as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "characterinfo" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.characterinfo)
        
        call .writeasciistring(charname)
        call .writebyte(race)
        call .writebyte(class)
        call .writebyte(gender)
        
        call .writebyte(level)
        call .writelong(gold)
        call .writelong(bank)
        call .writelong(reputation)
        
        call .writeasciistring(previouspetitions)
        call .writeasciistring(currentguild)
        call .writeasciistring(previousguilds)
        
        call .writeboolean(royalarmy)
        call .writeboolean(caoslegion)
        
        call .writelong(citicenskilled)
        call .writelong(criminalskilled)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "guildleaderinfo" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    guildlist the list of guild names.
' @param    memberlist the list of the guild's members.
' @param    guildnews the guild's news.
' @param    joinrequests the list of chars which requested to join the clan.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildleaderinfo(byval userindex as integer, byref guildlist() as string, byref memberlist() as string, _
                            byval guildnews as string, byref joinrequests() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guildleaderinfo" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.guildleaderinfo)
        
        ' prepare guild name's list
        for i = lbound(guildlist()) to ubound(guildlist())
            tmp = tmp & guildlist(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
        
        ' prepare guild member's list
        tmp = vbnullstring
        for i = lbound(memberlist()) to ubound(memberlist())
            tmp = tmp & memberlist(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
        
        ' store guild news
        call .writeasciistring(guildnews)
        
        ' prepare the join request's list
        tmp = vbnullstring
        for i = lbound(joinrequests()) to ubound(joinrequests())
            tmp = tmp & joinrequests(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "guildleaderinfo" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    guildlist the list of guild names.
' @param    memberlist the list of the guild's members.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguildmemberinfo(byval userindex as integer, byref guildlist() as string, byref memberlist() as string)
'***************************************************
'author: zama
'last modification: 21/02/2010
'writes the "guildmemberinfo" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.guildmemberinfo)
        
        ' prepare guild name's list
        for i = lbound(guildlist()) to ubound(guildlist())
            tmp = tmp & guildlist(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
        
        ' prepare guild member's list
        tmp = vbnullstring
        for i = lbound(memberlist()) to ubound(memberlist())
            tmp = tmp & memberlist(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "guilddetails" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    guildname the requested guild's name.
' @param    founder the requested guild's founder.
' @param    foundationdate the requested guild's foundation date.
' @param    leader the requested guild's current leader.
' @param    url the requested guild's website.
' @param    membercount the requested guild's member count.
' @param    electionsopen true if the clan is electing it's new leader.
' @param    alignment the requested guild's alignment.
' @param    enemiescount the requested guild's enemy count.
' @param    alliescount the requested guild's ally count.
' @param    antifactionpoints the requested guild's number of antifaction acts commited.
' @param    codex the requested guild's codex.
' @param    guilddesc the requested guild's description.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeguilddetails(byval userindex as integer, byval guildname as string, byval founder as string, byval foundationdate as string, _
                            byval leader as string, byval url as string, byval membercount as integer, byval electionsopen as boolean, _
                            byval alignment as string, byval enemiescount as integer, byval alliescount as integer, _
                            byval antifactionpoints as string, byref codex() as string, byval guilddesc as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "guilddetails" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim temp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.guilddetails)
        
        call .writeasciistring(guildname)
        call .writeasciistring(founder)
        call .writeasciistring(foundationdate)
        call .writeasciistring(leader)
        call .writeasciistring(url)
        
        call .writeinteger(membercount)
        call .writeboolean(electionsopen)
        
        call .writeasciistring(alignment)
        
        call .writeinteger(enemiescount)
        call .writeinteger(alliescount)
        
        call .writeasciistring(antifactionpoints)
        
        for i = lbound(codex()) to ubound(codex())
            temp = temp & codex(i) & separator
        next i
        
        if len(temp) > 1 then _
            temp = left$(temp, len(temp) - 1)
        
        call .writeasciistring(temp)
        
        call .writeasciistring(guilddesc)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub


''
' writes the "showguildalign" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowguildalign(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 14/12/2009
'writes the "showguildalign" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.showguildalign)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showguildfundationform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowguildfundationform(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showguildfundationform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.showguildfundationform)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "paralizeok" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeparalizeok(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/12/07
'last modified by: lucas tavolaro ortiz (tavo)
'writes the "paralizeok" message to the given user's outgoing data buffer
'and updates user position
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.paralizeok)
    call writeposupdate(userindex)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showuserrequest" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    details details of the char's request.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowuserrequest(byval userindex as integer, byval details as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showuserrequest" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.showuserrequest)
        
        call .writeasciistring(details)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "tradeok" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writetradeok(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "tradeok" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.tradeok)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "bankok" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writebankok(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "bankok" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.bankok)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "changeusertradeslot" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    objindex the object's index.
' @param    amount the number of objects offered.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writechangeusertradeslot(byval userindex as integer, byval offerslot as byte, byval objindex as integer, byval amount as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/03/09
'writes the "changeusertradeslot" message to the given user's outgoing data buffer
'25/11/2009: zama - now sends the specific offer slot to be modified.
'12/03/09: budi - ahora se envia maxdef y mindef en lugar de s�lo def
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.changeusertradeslot)
        
        call .writebyte(offerslot)
        call .writeinteger(objindex)
        call .writelong(amount)
        
        if objindex > 0 then
            call .writeinteger(objdata(objindex).grhindex)
            call .writebyte(objdata(objindex).objtype)
            call .writeinteger(objdata(objindex).maxhit)
            call .writeinteger(objdata(objindex).minhit)
            call .writeinteger(objdata(objindex).maxdef)
            call .writeinteger(objdata(objindex).mindef)
            call .writelong(saleprice(objindex))
            call .writeasciistring(objdata(objindex).name)
        else ' borra el item
            call .writeinteger(0)
            call .writebyte(0)
            call .writeinteger(0)
            call .writeinteger(0)
            call .writeinteger(0)
            call .writeinteger(0)
            call .writelong(0)
            call .writeasciistring("")
        end if
    end with
exit sub


errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "sendnight" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writesendnight(byval userindex as integer, byval night as boolean)
'***************************************************
'author: fredy horacio treboux (liquid)
'last modification: 01/08/07
'writes the "sendnight" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.sendnight)
        call .writeboolean(night)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "spawnlist" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    npcnames the names of the creatures that can be spawned.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writespawnlist(byval userindex as integer, byref npcnames() as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "spawnlist" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.spawnlist)
        
        for i = lbound(npcnames()) to ubound(npcnames())
            tmp = tmp & npcnames(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showsosform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowsosform(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showsosform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.showsosform)
        
        for i = 1 to ayuda.longitud
            tmp = tmp & ayuda.verelemento(i) & separator
        next i
        
        if lenb(tmp) <> 0 then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub


''
' writes the "showsosform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowpartyform(byval userindex as integer)
'***************************************************
'author: budi
'last modification: 11/26/09
'writes the "showpartyform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    dim pi as integer
    dim members(party_maxmembers) as integer
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.showpartyform)
        
        pi = userlist(userindex).partyindex
        call .writebyte(cbyte(parties(pi).espartyleader(userindex)))
        
        if pi > 0 then
            call parties(pi).obtenermiembrosonline(members())
            for i = 1 to party_maxmembers
                if members(i) > 0 then
                    tmp = tmp & userlist(members(i)).name & " (" & fix(parties(pi).miexperiencia(members(i))) & ")" & separator
                end if
            next i
        end if
        
        if lenb(tmp) <> 0 then _
            tmp = left$(tmp, len(tmp) - 1)
            
        call .writeasciistring(tmp)
        call .writelong(parties(pi).obtenerexperienciatotal)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showmotdeditionform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    currentmotd the current message of the day.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowmotdeditionform(byval userindex as integer, byval currentmotd as string)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showmotdeditionform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.showmotdeditionform)
        
        call .writeasciistring(currentmotd)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "showgmpanelform" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeshowgmpanelform(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "showgmpanelform" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.showgmpanelform)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "usernamelist" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    usernamelist list of user names.
' @param    cant number of names to send.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writeusernamelist(byval userindex as integer, byref usernameslist() as string, byval cant as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06 nigo:
'writes the "usernamelist" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    dim i as long
    dim tmp as string
    
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.usernamelist)
        
        ' prepare user's names list
        for i = 1 to cant
            tmp = tmp & usernameslist(i) & separator
        next i
        
        if len(tmp) then _
            tmp = left$(tmp, len(tmp) - 1)
        
        call .writeasciistring(tmp)
    end with
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "pong" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public sub writepong(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "pong" message to the given user's outgoing data buffer
'***************************************************
on error goto errhandler
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.pong)
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' flushes the outgoing data buffer of the user.
'
' @param    userindex user whose outgoing data buffer will be flushed.

public sub flushbuffer(byval userindex as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'sends all data existing in the buffer
'***************************************************
    dim snddata as string
    
    with userlist(userindex).outgoingdata
        if .length = 0 then _
            exit sub
        
        snddata = .readasciistringfixed(.length)
        
        call enviardatosaslot(userindex, snddata)
    end with
end sub

''
' prepares the "setinvisible" message and returns it.
'
' @param    charindex the char turning visible / invisible.
' @param    invisible true if the char is no longer visible, false otherwise.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the message is written to no outgoing buffer, but only prepared in a single string to be easily sent to several clients.

public function preparemessagesetinvisible(byval charindex as integer, byval invisible as boolean) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "setinvisible" message and returns it.
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.setinvisible)
        
        call .writeinteger(charindex)
        call .writeboolean(invisible)
        
        preparemessagesetinvisible = .readasciistringfixed(.length)
    end with
end function

public function preparemessagecharacterchangenick(byval charindex as integer, byval newnick as string) as string
'***************************************************
'author: budi
'last modification: 07/23/09
'prepares the "change nick" message and returns it.
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.characterchangenick)
        
        call .writeinteger(charindex)
        call .writeasciistring(newnick)
        
        preparemessagecharacterchangenick = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "chatoverhead" message and returns it.
'
' @param    chat text to be displayed over the char's head.
' @param    charindex the character uppon which the chat will be displayed.
' @param    color the color to be used when displaying the chat.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the message is written to no outgoing buffer, but only prepared in a single string to be easily sent to several clients.

public function preparemessagechatoverhead(byval chat as string, byval charindex as integer, byval color as long) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "chatoverhead" message and returns it.
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.chatoverhead)
        call .writeasciistring(chat)
        call .writeinteger(charindex)
        
        ' write rgb channels and save one byte from long :d
        call .writebyte(color and &hff)
        call .writebyte((color and &hff00&) \ &h100&)
        call .writebyte((color and &hff0000) \ &h10000)
        
        preparemessagechatoverhead = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "consolemsg" message and returns it.
'
' @param    chat text to be displayed over the char's head.
' @param    fontindex index of the fonttype structure to use.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageconsolemsg(byval chat as string, byval fontindex as fonttypenames) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "consolemsg" message and returns it.
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.consolemsg)
        call .writeasciistring(chat)
        call .writebyte(fontindex)
        
        preparemessageconsolemsg = .readasciistringfixed(.length)
    end with
end function

public function preparecommerceconsolemsg(byref chat as string, byval fontindex as fonttypenames) as string
'***************************************************
'author: zama
'last modification: 03/12/2009
'prepares the "commerceconsolemsg" message and returns it.
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.commercechat)
        call .writeasciistring(chat)
        call .writebyte(fontindex)
        
        preparecommerceconsolemsg = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "createfx" message and returns it.
'
' @param    userindex user to which the message is intended.
' @param    charindex character upon which the fx will be created.
' @param    fx fx index to be displayed over the new character.
' @param    fxloops number of times the fx should be rendered.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessagecreatefx(byval charindex as integer, byval fx as integer, byval fxloops as integer) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "createfx" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.createfx)
        call .writeinteger(charindex)
        call .writeinteger(fx)
        call .writeinteger(fxloops)
        
        preparemessagecreatefx = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "playwave" message and returns it.
'
' @param    wave the wave to be played.
' @param    x the x position in map coordinates from where the sound comes.
' @param    y the y position in map coordinates from where the sound comes.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageplaywave(byval wave as byte, byval x as byte, byval y as byte) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 08/08/07
'last modified by: rapsodius
'added x and y positions for 3d sounds
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.playwave)
        call .writebyte(wave)
        call .writebyte(x)
        call .writebyte(y)
        
        preparemessageplaywave = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "guildchat" message and returns it.
'
' @param    chat text to be displayed over the char's head.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageguildchat(byval chat as string) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "guildchat" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.guildchat)
        call .writeasciistring(chat)
        
        preparemessageguildchat = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "showmessagebox" message and returns it.
'
' @param    message text to be displayed in the message box.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageshowmessagebox(byval chat as string) as string
'***************************************************
'author: fredy horacio treboux (liquid)
'last modification: 01/08/07
'prepares the "showmessagebox" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.showmessagebox)
        call .writeasciistring(chat)
        
        preparemessageshowmessagebox = .readasciistringfixed(.length)
    end with
end function


''
' prepares the "playmidi" message and returns it.
'
' @param    midi the midi to be played.
' @param    loops number of repets for the midi.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageplaymidi(byval midi as byte, optional byval loops as integer = -1) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "guildchat" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.playmidi)
        call .writebyte(midi)
        call .writeinteger(loops)
        
        preparemessageplaymidi = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "pausetoggle" message and returns it.
'
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessagepausetoggle() as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "pausetoggle" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.pausetoggle)
        preparemessagepausetoggle = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "raintoggle" message and returns it.
'
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageraintoggle() as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "raintoggle" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.raintoggle)
        
        preparemessageraintoggle = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "objectdelete" message and returns it.
'
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageobjectdelete(byval x as byte, byval y as byte) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "objectdelete" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.objectdelete)
        call .writebyte(x)
        call .writebyte(y)
        
        preparemessageobjectdelete = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "blockposition" message and returns it.
'
' @param    x x coord of the tile to block/unblock.
' @param    y y coord of the tile to block/unblock.
' @param    blocked blocked status of the tile
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageblockposition(byval x as byte, byval y as byte, byval blocked as boolean) as string
'***************************************************
'author: fredy horacio treboux (liquid)
'last modification: 01/08/07
'prepares the "blockposition" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.blockposition)
        call .writebyte(x)
        call .writebyte(y)
        call .writeboolean(blocked)
        
        preparemessageblockposition = .readasciistringfixed(.length)
    end with
    
end function

''
' prepares the "objectcreate" message and returns it.
'
' @param    grhindex grh of the object.
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageobjectcreate(byval grhindex as integer, byval x as byte, byval y as byte) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "objectcreate" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.objectcreate)
        call .writebyte(x)
        call .writebyte(y)
        call .writeinteger(grhindex)
        
        preparemessageobjectcreate = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "characterremove" message and returns it.
'
' @param    charindex character to be removed.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessagecharacterremove(byval charindex as integer) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "characterremove" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.characterremove)
        call .writeinteger(charindex)
        
        preparemessagecharacterremove = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "removechardialog" message and returns it.
'
' @param    charindex character whose dialog will be removed.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageremovechardialog(byval charindex as integer) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'writes the "removechardialog" message to the given user's outgoing data buffer
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.removechardialog)
        call .writeinteger(charindex)
        
        preparemessageremovechardialog = .readasciistringfixed(.length)
    end with
end function

''
' writes the "charactercreate" message to the given user's outgoing data buffer.
'
' @param    body body index of the new character.
' @param    head head index of the new character.
' @param    heading heading in which the new character is looking.
' @param    charindex the index of the new character.
' @param    x x coord of the new character's position.
' @param    y y coord of the new character's position.
' @param    weapon weapon index of the new character.
' @param    shield shield index of the new character.
' @param    fx fx index to be displayed over the new character.
' @param    fxloops number of times the fx should be rendered.
' @param    helmet helmet index of the new character.
' @param    name name of the new character.
' @param    nickcolor determines if the character is a criminal or not, and if can be atacked by someone
' @param    privileges sets if the character is a normal one or any kind of administrative character.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessagecharactercreate(byval body as integer, byval head as integer, byval heading as eheading, _
                                byval charindex as integer, byval x as byte, byval y as byte, byval weapon as integer, byval shield as integer, _
                                byval fx as integer, byval fxloops as integer, byval helmet as integer, byval name as string, byval nickcolor as byte, _
                                byval privileges as byte) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "charactercreate" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.charactercreate)
        
        call .writeinteger(charindex)
        call .writeinteger(body)
        call .writeinteger(head)
        call .writebyte(heading)
        call .writebyte(x)
        call .writebyte(y)
        call .writeinteger(weapon)
        call .writeinteger(shield)
        call .writeinteger(helmet)
        call .writeinteger(fx)
        call .writeinteger(fxloops)
        call .writeasciistring(name)
        call .writebyte(nickcolor)
        call .writebyte(privileges)
        
        preparemessagecharactercreate = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "characterchange" message and returns it.
'
' @param    body body index of the new character.
' @param    head head index of the new character.
' @param    heading heading in which the new character is looking.
' @param    charindex the index of the new character.
' @param    weapon weapon index of the new character.
' @param    shield shield index of the new character.
' @param    fx fx index to be displayed over the new character.
' @param    fxloops number of times the fx should be rendered.
' @param    helmet helmet index of the new character.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessagecharacterchange(byval body as integer, byval head as integer, byval heading as eheading, _
                                byval charindex as integer, byval weapon as integer, byval shield as integer, _
                                byval fx as integer, byval fxloops as integer, byval helmet as integer) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "characterchange" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.characterchange)
        
        call .writeinteger(charindex)
        call .writeinteger(body)
        call .writeinteger(head)
        call .writebyte(heading)
        call .writeinteger(weapon)
        call .writeinteger(shield)
        call .writeinteger(helmet)
        call .writeinteger(fx)
        call .writeinteger(fxloops)
        
        preparemessagecharacterchange = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "charactermove" message and returns it.
'
' @param    charindex character which is moving.
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessagecharactermove(byval charindex as integer, byval x as byte, byval y as byte) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "charactermove" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.charactermove)
        call .writeinteger(charindex)
        call .writebyte(x)
        call .writebyte(y)
        
        preparemessagecharactermove = .readasciistringfixed(.length)
    end with
end function

public function preparemessageforcecharmove(byval direccion as eheading) as string
'***************************************************
'author: zama
'last modification: 26/03/2009
'prepares the "forcecharmove" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.forcecharmove)
        call .writebyte(direccion)
        
        preparemessageforcecharmove = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "updatetagandstatus" message and returns it.
'
' @param    charindex character which is moving.
' @param    x x coord of the character's new position.
' @param    y y coord of the character's new position.
' @return   the formated message ready to be writen as is on outgoing buffers.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageupdatetagandstatus(byval userindex as integer, byval nickcolor as byte, _
                                                byref tag as string) as string
'***************************************************
'author: alejandro salvo (salvito)
'last modification: 04/07/07
'last modified by: juan mart�n sotuyo dodero (maraxus)
'prepares the "updatetagandstatus" message and returns it
'15/01/2010: zama - now sends the nick color instead of the status.
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.updatetagandstatus)
        
        call .writeinteger(userlist(userindex).char.charindex)
        call .writebyte(nickcolor)
        call .writeasciistring(tag)
        
        preparemessageupdatetagandstatus = .readasciistringfixed(.length)
    end with
end function

''
' prepares the "errormsg" message and returns it.
'
' @param    message the error message to be displayed.
' @remarks  the data is not actually sent until the buffer is properly flushed.

public function preparemessageerrormsg(byval message as string) as string
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/17/06
'prepares the "errormsg" message and returns it
'***************************************************
    with auxiliarbuffer
        call .writebyte(serverpacketid.errormsg)
        call .writeasciistring(message)
        
        preparemessageerrormsg = .readasciistringfixed(.length)
    end with
end function

''
' writes the "stopworking" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.

public sub writestopworking(byval userindex as integer)
'***************************************************
'author: zama
'last modification: 21/02/2010
'
'***************************************************
on error goto errhandler
    
    call userlist(userindex).outgoingdata.writebyte(serverpacketid.stopworking)
        
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub

''
' writes the "cancelofferitem" message to the given user's outgoing data buffer.
'
' @param    userindex user to which the message is intended.
' @param    slot      the slot to cancel.

public sub writecancelofferitem(byval userindex as integer, byval slot as byte)
'***************************************************
'author: torres patricio (pato)
'last modification: 05/03/2010
'
'***************************************************
on error goto errhandler
    with userlist(userindex).outgoingdata
        call .writebyte(serverpacketid.cancelofferitem)
        call .writebyte(slot)
    end with
    
exit sub

errhandler:
    if err.number = userlist(userindex).outgoingdata.notenoughspaceerrcode then
        call flushbuffer(userindex)
        resume
    end if
end sub
