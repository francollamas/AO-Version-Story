attribute vb_name = "protocolcmdparse"
'argentum online
'
'copyright (c) 2006 juan mart�n sotuyo dodero (maraxus)
'copyright (c) 2006 alejandro santos (alejolp)

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

option explicit

public enum enumber_types
    ent_byte
    ent_integer
    ent_long
    ent_trigger
end enum

public sub auxwritewhisper(byval username as string, byval mensaje as string)
    if lenb(username) = 0 then exit sub
    
    dim i as long
    dim namelength as long
    
    if (instrb(username, "+") <> 0) then
        username = replace$(username, "+", " ")
    end if
    
    username = ucase$(username)
    namelength = len(username)
    
    i = 1
    do while i <= lastchar
        if ucase$(charlist(i).nombre) = username or ucase$(left$(charlist(i).nombre, namelength + 2)) = username & " <" then
            exit do
        else
            i = i + 1
        end if
    loop
    
    if i <= lastchar then
        call writewhisper(i, mensaje)
    end if
end sub

''
' interpreta, valida y ejecuta el comando ingresado .
'
' @param    rawcommand el comando en version string
' @remarks  none known.

public sub parseusercommand(byval rawcommand as string)
'***************************************************
'author: alejandro santos (alejolp)
'last modification: 26/03/2009
'interpreta, valida y ejecuta el comando ingresado
'26/03/2009: zama - flexibilizo la cantidad de parametros de /nene,  /onlinemap y /telep
'***************************************************
    dim tmpargos() as string
    
    dim comando as string
    dim argumentosall() as string
    dim argumentosraw as string
    dim argumentos2() as string
    dim argumentos3() as string
    dim argumentos4() as string
    dim cantidadargumentos as long
    dim notnullarguments as boolean
    
    dim tmparr() as string
    dim tmpint as integer
    
    ' tmpargs: un array de a lo sumo dos elementos,
    ' el primero es el comando (hasta el primer espacio)
    ' y el segundo elemento es el resto. si no hay argumentos
    ' devuelve un array de un solo elemento
    tmpargos = split(rawcommand, " ", 2)
    
    comando = trim$(ucase$(tmpargos(0)))
    
    if ubound(tmpargos) > 0 then
        ' el string en crudo que este despues del primer espacio
        argumentosraw = tmpargos(1)
        
        'veo que los argumentos no sean nulos
        notnullarguments = lenb(trim$(argumentosraw))
        
        ' un array separado por blancos, con tantos elementos como
        ' se pueda
        argumentosall = split(tmpargos(1), " ")
        
        ' cantidad de argumentos. en este punto el minimo es 1
        cantidadargumentos = ubound(argumentosall) + 1
        
        ' los siguientes arrays tienen a lo sumo, como maximo
        ' 2, 3 y 4 elementos respectivamente. eso significa
        ' que pueden tener menos, por lo que es imperativo
        ' preguntar por cantidadargumentos.
        
        argumentos2 = split(tmpargos(1), " ", 2)
        argumentos3 = split(tmpargos(1), " ", 3)
        argumentos4 = split(tmpargos(1), " ", 4)
    else
        cantidadargumentos = 0
    end if
    
    ' sacar cartel apesta!! (y es il�gico, est�s diciendo una pausa/espacio  :rolleyes: )
    if comando = "" then comando = " "
    
    if left$(comando, 1) = "/" then
        ' comando normal
        
        select case comando
            case "/seg"
                call writesafetoggle
                
            case "/online"
                call writeonline
                
            case "/salir"
                if userparalizado then 'inmo
                    with fonttypes(fonttypenames.fonttype_warning)
                        call showconsolemsg("no puedes salir estando paralizado.", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                if frmmain.macrotrabajo.enabled then frmmain.desactivarmacrotrabajo
                call writequit
                
            case "/salirclan"
                call writeguildleave
                
            case "/balance"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writerequestaccountstate
                
            case "/quieto"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writepetstand
                
            case "/acompa�ar"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writepetfollow
                
            case "/entrenar"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writetrainlist
                
            case "/descansar"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writerest
                
            case "/meditar"
                if userminman = usermaxman then exit sub
                
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writemeditate
        
            case "/resucitar"
                call writeresucitate
                
            case "/curar"
                call writeheal
                              
            case "/est"
                call writerequeststats
            
            case "/ayuda"
                call writehelp
                
            case "/comerciar"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                
                elseif comerciando then 'comerciando
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("ya est�s comerciando", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writecommercestart
                
            case "/boveda"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writebankstart
                
            case "/enlistar"
                call writeenlist
                    
            case "/informacion"
                call writeinformation
                
            case "/recompensa"
                call writereward
                
            case "/motd"
                call writerequestmotd
                
            case "/uptime"
                call writeuptime
                
            case "/salirparty"
                call writepartyleave
                
            case "/crearparty"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writepartycreate
                
            case "/party"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                call writepartyjoin
                
            case "/encuesta"
                if cantidadargumentos = 0 then
                    ' version sin argumentos: inquiry
                    call writeinquiry
                else
                    ' version con argumentos: inquiryvote
                    if validnumber(argumentosraw, enumber_types.ent_byte) then
                        call writeinquiryvote(argumentosraw)
                    else
                        'no es numerico
                        call showconsolemsg("para votar una opcion, escribe /encuesta numerodeopcion, por ejemplo para votar la opcion 1, escribe /encuesta 1.")
                    end if
                end if
        
            case "/cmsg"
                'ojo, no usar notnullarguments porque se usa el string vacio para borrar cartel.
                if cantidadargumentos > 0 then
                    call writeguildmessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
        
            case "/pmsg"
                'ojo, no usar notnullarguments porque se usa el string vacio para borrar cartel.
                if cantidadargumentos > 0 then
                    call writepartymessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
            
            case "/centinela"
                if notnullarguments then
                    if validnumber(argumentosraw, enumber_types.ent_integer) then
                        call writecentinelreport(cint(argumentosraw))
                    else
                        'no es numerico
                        call showconsolemsg("el c�digo de verificaci�n debe ser numerico. utilice /centinela x, siendo x el c�digo de verificaci�n.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /centinela x, siendo x el c�digo de verificaci�n.")
                end if
        
            case "/onlineclan"
                call writeguildonline
                
            case "/onlineparty"
                call writepartyonline
                
            case "/bmsg"
                if notnullarguments then
                    call writecouncilmessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
                
            case "/rol"
                if notnullarguments then
                    call writerolemasterrequest(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba una pregunta.")
                end if
                
            case "/gm"
                call writegmrequest
                
            case "/_bug"
                if notnullarguments then
                    call writebugreport(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba una descripci�n del bug.")
                end if
            
            case "/desc"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                
                call writechangedescription(argumentosraw)
            
            case "/voto"
                if notnullarguments then
                    call writeguildvote(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /voto nickname.")
                end if
               
            case "/penas"
                if notnullarguments then
                    call writepunishments(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /penas nickname.")
                end if
                
            case "/contrase�a"
                call frmnewpassword.show(vbmodal, frmmain)
            
            case "/apostar"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                if notnullarguments then
                    if validnumber(argumentosraw, enumber_types.ent_integer) then
                        call writegamble(argumentosraw)
                    else
                        'no es numerico
                        call showconsolemsg("cantidad incorrecta. utilice /apostar cantidad.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /apostar cantidad.")
                end if
                
            case "/retirar"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                if cantidadargumentos = 0 then
                    ' version sin argumentos: leavefaction
                    call writeleavefaction
                else
                    ' version con argumentos: bankextractgold
                    if validnumber(argumentosraw, enumber_types.ent_long) then
                        call writebankextractgold(argumentosraw)
                    else
                        'no es numerico
                        call showconsolemsg("cantidad incorrecta. utilice /retirar cantidad.")
                    end if
                end if
    
            case "/depositar"
                if userestado = 1 then 'muerto
                    with fonttypes(fonttypenames.fonttype_info)
                        call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
                    end with
                    exit sub
                end if
                
                if notnullarguments then
                    if validnumber(argumentosraw, enumber_types.ent_long) then
                        call writebankdepositgold(argumentosraw)
                    else
                        'no es numerico
                        call showconsolemsg("cantidad incorecta. utilice /depositar cantidad.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan paramtetros. utilice /depositar cantidad.")
                end if
                
            case "/denunciar"
                if notnullarguments then
                    call writedenounce(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("formule su denuncia.")
                end if
                
            case "/fundarclan"
                if userlvl >= 25 then
                    frmeligealineacion.show vbmodeless, frmmain
                else
                    call showconsolemsg("para fundar un clan ten�s que ser nivel 25 y tener 90 skills en liderazgo.")
                end if
            
            case "/fundarclangm"
                call writeguildfundate(eclantype.ct_gm)
            
            case "/echarparty"
                if notnullarguments then
                    call writepartykick(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /echarparty nickname.")
                end if
                
            case "/partylider"
                if notnullarguments then
                    call writepartysetleader(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /partylider nickname.")
                end if
                
            case "/acceptparty"
                if notnullarguments then
                    call writepartyacceptmember(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /acceptparty nickname.")
                end if

            '
            ' begin gm commands
            '
            
            case "/gmsg"
                if notnullarguments then
                    call writegmmessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
                
            case "/showname"
                call writeshowname
                
            case "/onlinereal"
                call writeonlineroyalarmy
                
            case "/onlinecaos"
                call writeonlinechaoslegion
                
            case "/ircerca"
                if notnullarguments then
                    call writegonearby(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ircerca nickname.")
                end if
                
            case "/rem"
                if notnullarguments then
                    call writecomment(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un comentario.")
                end if
            
            case "/hora"
                call protocol.writeservertime
            
            case "/donde"
                if notnullarguments then
                    call writewhere(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /donde nickname.")
                end if
                
            case "/nene"
                if notnullarguments then
                    if validnumber(argumentosraw, enumber_types.ent_integer) then
                        call writecreaturesinmap(argumentosraw)
                    else
                        'no es numerico
                        call showconsolemsg("mapa incorrecto. utilice /nene mapa.")
                    end if
                else
                    'por default, toma el mapa en el que esta
                    call writecreaturesinmap(usermap)
                end if
                
            case "/teleploc"
                call writewarpmetotarget
                
            case "/telep"
                if notnullarguments and cantidadargumentos >= 4 then
                    if validnumber(argumentosall(1), enumber_types.ent_integer) and validnumber(argumentosall(2), enumber_types.ent_byte) and validnumber(argumentosall(3), enumber_types.ent_byte) then
                        call writewarpchar(argumentosall(0), argumentosall(1), argumentosall(2), argumentosall(3))
                    else
                        'no es numerico
                        call showconsolemsg("valor incorrecto. utilice /telep nickname mapa x y.")
                    end if
                elseif cantidadargumentos = 3 then
                    if validnumber(argumentosall(0), enumber_types.ent_integer) and validnumber(argumentosall(1), enumber_types.ent_byte) and validnumber(argumentosall(2), enumber_types.ent_byte) then
                        'por defecto, si no se indica el nombre, se teletransporta el mismo usuario
                        call writewarpchar("yo", argumentosall(0), argumentosall(1), argumentosall(2))
                    elseif validnumber(argumentosall(1), enumber_types.ent_byte) and validnumber(argumentosall(2), enumber_types.ent_byte) then
                        'por defecto, si no se indica el mapa, se teletransporta al mismo donde esta el usuario
                        call writewarpchar(argumentosall(0), usermap, argumentosall(1), argumentosall(2))
                    else
                        'no uso ningun formato por defecto
                        call showconsolemsg("valor incorrecto. utilice /telep nickname mapa x y.")
                    end if
                elseif cantidadargumentos = 2 then
                    if validnumber(argumentosall(0), enumber_types.ent_byte) and validnumber(argumentosall(1), enumber_types.ent_byte) then
                        ' por defecto, se considera que se quiere unicamente cambiar las coordenadas del usuario, en el mismo mapa
                        call writewarpchar("yo", usermap, argumentosall(0), argumentosall(1))
                    else
                        'no uso ningun formato por defecto
                        call showconsolemsg("valor incorrecto. utilice /telep nickname mapa x y.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /telep nickname mapa x y.")
                end if
                
            case "/silenciar"
                if notnullarguments then
                    call writesilence(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /silenciar nickname.")
                end if
                
            case "/show"
                if notnullarguments then
                    select case ucase$(argumentosall(0))
                        case "sos"
                            call writesosshowlist
                            
                        case "int"
                            call writeshowserverform
                            
                    end select
                end if
                
            case "/ira"
                if notnullarguments then
                    call writegotochar(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ira nickname.")
                end if
        
            case "/invisible"
                call writeinvisible
                
            case "/panelgm"
                call writegmpanel
                
            case "/trabajando"
                call writeworking
                
            case "/ocultando"
                call writehiding
                
            case "/carcel"
                if notnullarguments then
                    tmparr = split(argumentosraw, "@")
                    if ubound(tmparr) = 2 then
                        if validnumber(tmparr(2), enumber_types.ent_byte) then
                            call writejail(tmparr(0), tmparr(1), tmparr(2))
                        else
                            'no es numerico
                            call showconsolemsg("tiempo incorrecto. utilice /carcel nickname@motivo@tiempo.")
                        end if
                    else
                        'faltan los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /carcel nickname@motivo@tiempo.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /carcel nickname@motivo@tiempo.")
                end if
                
            case "/rmata"
                call writekillnpc
                
            case "/advertencia"
                if notnullarguments then
                    tmparr = split(argumentosraw, "@", 2)
                    if ubound(tmparr) = 1 then
                        call writewarnuser(tmparr(0), tmparr(1))
                    else
                        'faltan los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /advertencia nickname@motivo.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /advertencia nickname@motivo.")
                end if
                
            case "/mod"
                if notnullarguments and cantidadargumentos >= 3 then
                    select case ucase$(argumentosall(1))
                        case "body"
                            tmpint = eeditoptions.eo_body
                        
                        case "head"
                            tmpint = eeditoptions.eo_head
                        
                        case "oro"
                            tmpint = eeditoptions.eo_gold
                        
                        case "level"
                            tmpint = eeditoptions.eo_level
                        
                        case "skills"
                            tmpint = eeditoptions.eo_skills
                        
                        case "skillslibres"
                            tmpint = eeditoptions.eo_skillpointsleft
                        
                        case "clase"
                            tmpint = eeditoptions.eo_class
                        
                        case "exp"
                            tmpint = eeditoptions.eo_experience
                        
                        case "cri"
                            tmpint = eeditoptions.eo_criminalskilled
                        
                        case "ciu"
                            tmpint = eeditoptions.eo_citicenskilled
                        
                        case "nob"
                            tmpint = eeditoptions.eo_nobleza
                        
                        case "ase"
                            tmpint = eeditoptions.eo_asesino
                        
                        case "sex"
                            tmpint = eeditoptions.eo_sex
                            
                        case "raza"
                            tmpint = eeditoptions.eo_raza
                        
                        case "agregar"
                            tmpint = eeditoptions.eo_addgold
                        
                        case else
                            tmpint = -1
                    end select
                    
                    if tmpint > 0 then
                        if cantidadargumentos = 3 then
                            call writeeditchar(argumentosall(0), tmpint, argumentosall(2), "")
                        else
                            call writeeditchar(argumentosall(0), tmpint, argumentosall(2), argumentosall(3))
                        end if
                    else
                        'avisar que no exite el comando
                        call showconsolemsg("comando incorrecto.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros.")
                end if
            
            case "/info"
                if notnullarguments then
                    call writerequestcharinfo(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /info nickname.")
                end if
                
            case "/stat"
                if notnullarguments then
                    call writerequestcharstats(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /stat nickname.")
                end if
                
            case "/bal"
                if notnullarguments then
                    call writerequestchargold(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /bal nickname.")
                end if
                
            case "/inv"
                if notnullarguments then
                    call writerequestcharinventory(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /inv nickname.")
                end if
                
            case "/bov"
                if notnullarguments then
                    call writerequestcharbank(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /bov nickname.")
                end if
                
            case "/skills"
                if notnullarguments then
                    call writerequestcharskills(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /skills nickname.")
                end if
                
            case "/revivir"
                if notnullarguments then
                    call writerevivechar(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /revivir nickname.")
                end if
                
            case "/onlinegm"
                call writeonlinegm
                
            case "/onlinemap"
                if notnullarguments then
                    if validnumber(argumentosall(0), enumber_types.ent_integer) then
                        call writeonlinemap(argumentosall(0))
                    else
                        call showconsolemsg("mapa incorrecto.")
                    end if
                else
                    call writeonlinemap(usermap)
                end if
                
            case "/perdon"
                if notnullarguments then
                    call writeforgive(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /perdon nickname.")
                end if
                
            case "/echar"
                if notnullarguments then
                    call writekick(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /echar nickname.")
                end if
                
            case "/ejecutar"
                if notnullarguments then
                    call writeexecute(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ejecutar nickname.")
                end if
                
            case "/ban"
                if notnullarguments then
                    tmparr = split(argumentosraw, "@", 2)
                    if ubound(tmparr) = 1 then
                        call writebanchar(tmparr(0), tmparr(1))
                    else
                        'faltan los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /ban nickname@motivo.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ban nickname@motivo.")
                end if
                
            case "/unban"
                if notnullarguments then
                    call writeunbanchar(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /unban nickname.")
                end if
                
            case "/seguir"
                call writenpcfollow
                
            case "/sum"
                if notnullarguments then
                    call writesummonchar(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /sum nickname.")
                end if
                
            case "/cc"
                call writespawnlistrequest
                
            case "/resetinv"
                call writeresetnpcinventory
                
            case "/limpiar"
                call writecleanworld
                
            case "/rmsg"
                if notnullarguments then
                    call writeservermessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
                
            case "/nick2ip"
                if notnullarguments then
                    call writenicktoip(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /nick2ip nickname.")
                end if
                
            case "/ip2nick"
                if notnullarguments then
                    if validipv4str(argumentosraw) then
                        call writeiptonick(str2ipv4l(argumentosraw))
                    else
                        'no es una ip
                        call showconsolemsg("ip incorrecta. utilice /ip2nick ip.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ip2nick ip.")
                end if
                
            case "/onclan"
                if notnullarguments then
                    call writeguildonlinemembers(argumentosraw)
                else
                    'avisar sintaxis incorrecta
                    call showconsolemsg("utilice /onclan nombre del clan.")
                end if
                
            case "/ct"
                if notnullarguments and cantidadargumentos = 3 then
                    if validnumber(argumentosall(0), enumber_types.ent_integer) and validnumber(argumentosall(1), enumber_types.ent_byte) and validnumber(argumentosall(2), enumber_types.ent_byte) then
                        call writeteleportcreate(argumentosall(0), argumentosall(1), argumentosall(2))
                    else
                        'no es numerico
                        call showconsolemsg("valor incorrecto. utilice /ct mapa x y.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ct mapa x y.")
                end if
                
            case "/dt"
                call writeteleportdestroy
                
            case "/lluvia"
                call writeraintoggle
                
            case "/setdesc"
                call writesetchardescription(argumentosraw)
            
            case "/forcemidimap"
                if notnullarguments then
                    'elegir el mapa es opcional
                    if cantidadargumentos = 1 then
                        if validnumber(argumentosall(0), enumber_types.ent_byte) then
                            'eviamos un mapa nulo para que tome el del usuario.
                            call writeforcemiditomap(argumentosall(0), 0)
                        else
                            'no es numerico
                            call showconsolemsg("midi incorrecto. utilice /forcemidimap midi mapa, siendo el mapa opcional.")
                        end if
                    else
                        if validnumber(argumentosall(0), enumber_types.ent_byte) and validnumber(argumentosall(1), enumber_types.ent_integer) then
                            call writeforcemiditomap(argumentosall(0), argumentosall(1))
                        else
                            'no es numerico
                            call showconsolemsg("valor incorrecto. utilice /forcemidimap midi mapa, siendo el mapa opcional.")
                        end if
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("utilice /forcemidimap midi mapa, siendo el mapa opcional.")
                end if
                
            case "/forcewavmap"
                if notnullarguments then
                    'elegir la posicion es opcional
                    if cantidadargumentos = 1 then
                        if validnumber(argumentosall(0), enumber_types.ent_byte) then
                            'eviamos una posicion nula para que tome la del usuario.
                            call writeforcewavetomap(argumentosall(0), 0, 0, 0)
                        else
                            'no es numerico
                            call showconsolemsg("utilice /forcewavmap wav map x y, siendo los �ltimos 3 opcionales.")
                        end if
                    elseif cantidadargumentos = 4 then
                        if validnumber(argumentosall(0), enumber_types.ent_byte) and validnumber(argumentosall(1), enumber_types.ent_integer) and validnumber(argumentosall(2), enumber_types.ent_byte) and validnumber(argumentosall(3), enumber_types.ent_byte) then
                            call writeforcewavetomap(argumentosall(0), argumentosall(1), argumentosall(2), argumentosall(3))
                        else
                            'no es numerico
                            call showconsolemsg("utilice /forcewavmap wav map x y, siendo los �ltimos 3 opcionales.")
                        end if
                    else
                        'avisar que falta el parametro
                        call showconsolemsg("utilice /forcewavmap wav map x y, siendo los �ltimos 3 opcionales.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("utilice /forcewavmap wav map x y, siendo los �ltimos 3 opcionales.")
                end if
                
            case "/realmsg"
                if notnullarguments then
                    call writeroyalarmymessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
                 
            case "/caosmsg"
                if notnullarguments then
                    call writechaoslegionmessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
                
            case "/ciumsg"
                if notnullarguments then
                    call writecitizenmessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
            
            case "/crimsg"
                if notnullarguments then
                    call writecriminalmessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
            
            case "/talkas"
                if notnullarguments then
                    call writetalkasnpc(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
        
            case "/massdest"
                call writedestroyallitemsinarea
    
            case "/aceptconse"
                if notnullarguments then
                    call writeacceptroyalcouncilmember(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /aceptconse nickname.")
                end if
                
            case "/aceptconsecaos"
                if notnullarguments then
                    call writeacceptchaoscouncilmember(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /aceptconsecaos nickname.")
                end if
                
            case "/piso"
                call writeitemsinthefloor
                
            case "/estupido"
                if notnullarguments then
                    call writemakedumb(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /estupido nickname.")
                end if
                
            case "/noestupido"
                if notnullarguments then
                    call writemakedumbnomore(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /noestupido nickname.")
                end if
                
            case "/dumpsecurity"
                call writedumpiptables
                
            case "/kickconse"
                if notnullarguments then
                    call writecouncilkick(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /kickconse nickname.")
                end if
                
            case "/trigger"
                if notnullarguments then
                    if validnumber(argumentosraw, enumber_types.ent_trigger) then
                        call writesettrigger(argumentosraw)
                    else
                        'no es numerico
                        call showconsolemsg("numero incorrecto. utilice /trigger numero.")
                    end if
                else
                    'version sin parametro
                    call writeasktrigger
                end if
                
            case "/baniplist"
                call writebannediplist
                
            case "/banipreload"
                call writebannedipreload
                
            case "/miembrosclan"
                if notnullarguments then
                    call writeguildmemberlist(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /miembrosclan guildname.")
                end if
                
            case "/banclan"
                if notnullarguments then
                    call writeguildban(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /banclan guildname.")
                end if
                
            case "/banip"
                if cantidadargumentos >= 2 then
                    if validipv4str(argumentosall(0)) then
                        call writebanip(true, str2ipv4l(argumentosall(0)), vbnullstring, right$(argumentosraw, len(argumentosraw) - len(argumentosall(0)) - 1))
                    else
                        'no es una ip, es un nick
                        call writebanip(false, str2ipv4l("0.0.0.0"), argumentosall(0), right$(argumentosraw, len(argumentosraw) - len(argumentosall(0)) - 1))
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /banip ip motivo o /banip nick motivo.")
                end if
                
            case "/unbanip"
                if notnullarguments then
                    if validipv4str(argumentosraw) then
                        call writeunbanip(str2ipv4l(argumentosraw))
                    else
                        'no es una ip
                        call showconsolemsg("ip incorrecta. utilice /unbanip ip.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /unbanip ip.")
                end if
                
            case "/ci"
                if notnullarguments then
                    if validnumber(argumentosall(0), enumber_types.ent_long) then
                        call writecreateitem(argumentosall(0))
                    else
                        'no es numerico
                        call showconsolemsg("objeto incorrecto. utilice /ci objeto.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ci objeto.")
                end if
                
            case "/dest"
                call writedestroyitems
                
            case "/nocaos"
                if notnullarguments then
                    call writechaoslegionkick(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /nocaos nickname.")
                end if
    
            case "/noreal"
                if notnullarguments then
                    call writeroyalarmykick(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /noreal nickname.")
                end if
    
            case "/forcemidi"
                if notnullarguments then
                    if validnumber(argumentosall(0), enumber_types.ent_byte) then
                        call writeforcemidiall(argumentosall(0))
                    else
                        'no es numerico
                        call showconsolemsg("midi incorrecto. utilice /forcemidi midi.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /forcemidi midi.")
                end if
    
            case "/forcewav"
                if notnullarguments then
                    if validnumber(argumentosall(0), enumber_types.ent_byte) then
                        call writeforcewaveall(argumentosall(0))
                    else
                        'no es numerico
                        call showconsolemsg("wav incorrecto. utilice /forcewav wav.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /forcewav wav.")
                end if
                
            case "/borrarpena"
                if notnullarguments then
                    tmparr = split(argumentosraw, "@", 3)
                    if ubound(tmparr) = 2 then
                        call writeremovepunishment(tmparr(0), tmparr(1), tmparr(2))
                    else
                        'faltan los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /borrarpena nick@pena@nuevapena.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /borrarpena nick@pena@nuevapena.")
                end if
                
            case "/bloq"
                call writetileblockedtoggle
                
            case "/mata"
                call writekillnpcnorespawn
        
            case "/masskill"
                call writekillallnearbynpcs
                
            case "/lastip"
                if notnullarguments then
                    call writelastip(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /lastip nickname.")
                end if
    
            case "/motdcambia"
                call writechangemotd
                
            case "/smsg"
                if notnullarguments then
                    call writesystemmessage(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("escriba un mensaje.")
                end if
                
            case "/acc"
                if notnullarguments then
                    if validnumber(argumentosall(0), enumber_types.ent_integer) then
                        call writecreatenpc(argumentosall(0))
                    else
                        'no es numerico
                        call showconsolemsg("npc incorrecto. utilice /acc npc.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /acc npc.")
                end if
                
            case "/racc"
                if notnullarguments then
                    if validnumber(argumentosall(0), enumber_types.ent_integer) then
                        call writecreatenpcwithrespawn(argumentosall(0))
                    else
                        'no es numerico
                        call showconsolemsg("npc incorrecto. utilice /racc npc.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /racc npc.")
                end if
        
            case "/ai" ' 1 - 4
                if notnullarguments and cantidadargumentos >= 2 then
                    if validnumber(argumentosall(0), enumber_types.ent_byte) and validnumber(argumentosall(1), enumber_types.ent_integer) then
                        call writeimperialarmour(argumentosall(0), argumentosall(1))
                    else
                        'no es numerico
                        call showconsolemsg("valor incorrecto. utilice /ai armadura objeto.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ai armadura objeto.")
                end if
                
            case "/ac" ' 1 - 4
                if notnullarguments and cantidadargumentos >= 2 then
                    if validnumber(argumentosall(0), enumber_types.ent_byte) and validnumber(argumentosall(1), enumber_types.ent_integer) then
                        call writechaosarmour(argumentosall(0), argumentosall(1))
                    else
                        'no es numerico
                        call showconsolemsg("valor incorrecto. utilice /ac armadura objeto.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /ac armadura objeto.")
                end if
                
            case "/nave"
                call writenavigatetoggle
        
            case "/habilitar"
                call writeserveropentouserstoggle
            
            case "/apagar"
                call writeturnoffserver
                
            case "/conden"
                if notnullarguments then
                    call writeturncriminal(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /conden nickname.")
                end if
                
            case "/rajar"
                if notnullarguments then
                    call writeresetfactions(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /rajar nickname.")
                end if
                
            case "/rajarclan"
                if notnullarguments then
                    call writeremovecharfromguild(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /rajarclan nickname.")
                end if
                
            case "/lastemail"
                if notnullarguments then
                    call writerequestcharmail(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /lastemail nickname.")
                end if
                
            case "/apass"
                if notnullarguments then
                    tmparr = split(argumentosraw, "@", 2)
                    if ubound(tmparr) = 1 then
                        call writealterpassword(tmparr(0), tmparr(1))
                    else
                        'faltan los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /apass pjsinpass@pjconpass.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /apass pjsinpass@pjconpass.")
                end if
                
            case "/aemail"
                if notnullarguments then
                    tmparr = aemailsplit(argumentosraw)
                    if lenb(tmparr(0)) = 0 then
                        'faltan los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /aemail nickname-nuevomail.")
                    else
                        call writealtermail(tmparr(0), tmparr(1))
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /aemail nickname-nuevomail.")
                end if
                
            case "/aname"
                if notnullarguments then
                    tmparr = split(argumentosraw, "@", 2)
                    if ubound(tmparr) = 1 then
                        call writealtername(tmparr(0), tmparr(1))
                    else
                        'faltan los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /aname origen@destino.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /aname origen@destino.")
                end if
                
            case "/slot"
                if notnullarguments then
                    tmparr = split(argumentosraw, "@", 2)
                    if ubound(tmparr) = 1 then
                        if validnumber(tmparr(1), enumber_types.ent_byte) then
                            call writecheckslot(tmparr(0), tmparr(1))
                        else
                            'faltan o sobran los parametros con el formato propio
                            call showconsolemsg("formato incorrecto. utilice /slot nick@slot.")
                        end if
                    else
                        'faltan o sobran los parametros con el formato propio
                        call showconsolemsg("formato incorrecto. utilice /slot nick@slot.")
                    end if
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /slot nick@slot.")
                end if
                
            case "/centinelaactivado"
                call writetogglecentinelactivated
                
            case "/dobackup"
                call writedobackup
                
            case "/showcmsg"
                if notnullarguments then
                    call writeshowguildmessages(argumentosraw)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /showcmsg guildname.")
                end if
                
            case "/guardamapa"
                call writesavemap
                
            case "/modmapinfo" ' pk, backup
                if cantidadargumentos > 1 then
                    select case ucase$(argumentosall(0))
                        case "pk" ' "/modmapinfo pk"
                            call writechangemapinfopk(argumentosall(1) = "1")
                        
                        case "backup" ' "/modmapinfo backup"
                            call writechangemapinfobackup(argumentosall(1) = "1")
                        
                        case "restringir" '/modmapinfo restringir
                            call writechangemapinforestricted(argumentosall(1))
                        
                        case "magiasinefecto" '/modmapinfo magiasinefecto
                            call writechangemapinfonomagic(argumentosall(1))
                        
                        case "invisinefecto" '/modmapinfo invisinefecto
                            call writechangemapinfonoinvi(argumentosall(1))
                        
                        case "resusinefecto" '/modmapinfo resusinefecto
                            call writechangemapinfonoresu(argumentosall(1))
                        
                        case "terreno" '/modmapinfo terreno
                            call writechangemapinfoland(argumentosall(1))
                        
                        case "zona" '/modmapinfo zona
                            call writechangemapinfozone(argumentosall(1))
                    end select
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan parametros. opciones: pk, backup, restringir, magiasinefecto, invisinefecto, resusinefecto, terreno, zona")
                end if
                
            case "/grabar"
                call writesavechars
                
            case "/borrar"
                if notnullarguments then
                    select case ucase(argumentosall(0))
                        case "sos" ' "/borrar sos"
                            call writecleansos
                            
                    end select
                end if
                
            case "/noche"
                call writenight
                
            case "/echartodospjs"
                call writekickallchars
                
            case "/reloadnpcs"
                call writereloadnpcs
                
            case "/reloadsini"
                call writereloadserverini
                
            case "/reloadhechizos"
                call writereloadspells
                
            case "/reloadobj"
                call writereloadobjects
                 
            case "/reiniciar"
                call writerestart
                
            case "/autoupdate"
                call writeresetautoupdate
            
            case "/chatcolor"
                if notnullarguments and cantidadargumentos >= 3 then
                    if validnumber(argumentosall(0), enumber_types.ent_byte) and validnumber(argumentosall(1), enumber_types.ent_byte) and validnumber(argumentosall(2), enumber_types.ent_byte) then
                        call writechatcolor(argumentosall(0), argumentosall(1), argumentosall(2))
                    else
                        'no es numerico
                        call showconsolemsg("valor incorrecto. utilice /chatcolor r g b.")
                    end if
                elseif not notnullarguments then    'go back to default!
                    call writechatcolor(0, 255, 0)
                else
                    'avisar que falta el parametro
                    call showconsolemsg("faltan par�metros. utilice /chatcolor r g b.")
                end if
            
            case "/ignorado"
                call writeignored
            
            case "/ping"
                call writeping
                
            case "/setinivar"
                if cantidadargumentos = 3 then
                    argumentosall(2) = replace(argumentosall(2), "+", " ")
                    call writesetinivar(argumentosall(0), argumentosall(1), argumentosall(2))
                else
                    call showconsolemsg("pr�metros incorrectos. utilice /setinivar llave clave valor")
                end if
            
#if seguridadalkon then
            case else
                call parseusercommandex(comando, cantidadargumentos, argumentosall, argumentosraw)
#end if
        end select
        
    elseif left$(comando, 1) = "\" then
        if userestado = 1 then 'muerto
            with fonttypes(fonttypenames.fonttype_info)
                call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
            end with
            exit sub
        end if
        ' mensaje privado
        call auxwritewhisper(mid$(comando, 2), argumentosraw)
        
    elseif left$(comando, 1) = "-" then
        if userestado = 1 then 'muerto
            with fonttypes(fonttypenames.fonttype_info)
                call showconsolemsg("��est�s muerto!!", .red, .green, .blue, .bold, .italic)
            end with
            exit sub
        end if
        ' gritar
        call writeyell(mid$(rawcommand, 2))
        
    else
        ' hablar
        call writetalk(rawcommand)
    end if
end sub

''
' show a console message.
'
' @param    message the message to be written.
' @param    red sets the font red color.
' @param    green sets the font green color.
' @param    blue sets the font blue color.
' @param    bold sets the font bold style.
' @param    italic sets the font italic style.

public sub showconsolemsg(byval message as string, optional byval red as integer = 255, optional byval green as integer = 255, optional byval blue as integer = 255, optional byval bold as boolean = false, optional byval italic as boolean = false)
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 01/03/07
'
'***************************************************
    call addtorichtextbox(frmmain.rectxt, message, red, green, blue, bold, italic)
end sub

''
' returns whether the number is correct.
'
' @param    numero the number to be checked.
' @param    tipo the acceptable type of number.

public function validnumber(byval numero as string, byval tipo as enumber_types) as boolean
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 01/06/07
'
'***************************************************
    dim minimo as long
    dim maximo as long
    
    if not isnumeric(numero) then _
        exit function
    
    select case tipo
        case enumber_types.ent_byte
            minimo = 0
            maximo = 255

        case enumber_types.ent_integer
            minimo = -32768
            maximo = 32767

        case enumber_types.ent_long
            minimo = -2147483648#
            maximo = 2147483647
        
        case enumber_types.ent_trigger
            minimo = 0
            maximo = 6
    end select
    
    if val(numero) >= minimo and val(numero) <= maximo then _
        validnumber = true
end function

''
' returns whether the ip format is correct.
'
' @param    ip the ip to be checked.

private function validipv4str(byval ip as string) as boolean
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 01/06/07
'
'***************************************************
    dim tmparr() as string
    
    tmparr = split(ip, ".")
    
    if ubound(tmparr) <> 3 then _
        exit function

    if not validnumber(tmparr(0), enumber_types.ent_byte) or _
      not validnumber(tmparr(1), enumber_types.ent_byte) or _
      not validnumber(tmparr(2), enumber_types.ent_byte) or _
      not validnumber(tmparr(3), enumber_types.ent_byte) then _
        exit function
    
    validipv4str = true
end function

''
' converts a string into the correct ip format.
'
' @param    ip the ip to be converted.

private function str2ipv4l(byval ip as string) as byte()
'***************************************************
'author: nicolas matias gonzalez (nigo)
'last modification: 07/26/07
'last modified by: rapsodius
'specify return type as array of bytes
'otherwise, the default is a variant or array of variants, that slows down
'the function
'***************************************************
    dim tmparr() as string
    dim barr(3) as byte
    
    tmparr = split(ip, ".")
    
    barr(0) = cbyte(tmparr(0))
    barr(1) = cbyte(tmparr(1))
    barr(2) = cbyte(tmparr(2))
    barr(3) = cbyte(tmparr(3))

    str2ipv4l = barr
end function

''
' do an split() in the /aemail in onother way
'
' @param text all the comand without the /aemail
' @return an bidimensional array with user and mail

private function aemailsplit(byref text as string) as string()
'***************************************************
'author: lucas tavolaro ortuz (tavo)
'useful for aemail bug fix
'last modification: 07/26/07
'last modified by: rapsodius
'specify return type as array of strings
'otherwise, the default is a variant or array of variants, that slows down
'the function
'***************************************************
    dim tmparr(0 to 1) as string
    dim pos as byte
    
    pos = instr(1, text, "-")
    
    if pos <> 0 then
        tmparr(0) = mid$(text, 1, pos - 1)
        tmparr(1) = mid$(text, pos + 1)
    else
        tmparr(0) = vbnullstring
    end if
    
    aemailsplit = tmparr
end function
