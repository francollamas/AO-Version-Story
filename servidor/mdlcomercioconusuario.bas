attribute vb_name = "mdlcomercioconusuario"
'**************************************************************
' mdlcomercioconusuarios.bas - allows players to commerce between themselves.
'
' designed and implemented by alejandro santos (alejolp)
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

'[alejo]
option explicit

private const max_oro_logueable as long = 50000
private const max_obj_logueable as long = 1000

public const max_offer_slots as integer = 30 '20
public const gold_offer_slot as integer = max_offer_slots + 1

public type tcomerciousuario
    destusu as integer 'el otro usuario
    destnick as string
    objeto(1 to max_offer_slots) as integer 'indice de los objetos que se desea dar
    goldamount as long
    
    cant(1 to max_offer_slots) as long 'cuantos objetos desea dar
    acepto as boolean
    confirmo as boolean
end type

'origen: origen de la transaccion, originador del comando
'destino: receptor de la transaccion
public sub iniciarcomercioconusuario(byval origen as integer, byval destino as integer)
'***************************************************
'autor: unkown
'last modification: 25/11/2009
'
'***************************************************
    on error goto errhandler
    
    'si ambos pusieron /comerciar entonces
    if userlist(origen).comusu.destusu = destino and _
       userlist(destino).comusu.destusu = origen then
        'actualiza el inventario del usuario
        call updateuserinv(true, origen, 0)
        'decirle al origen que abra la ventanita.
        call writeusercommerceinit(origen)
        userlist(origen).flags.comerciando = true
    
        'actualiza el inventario del usuario
        call updateuserinv(true, destino, 0)
        'decirle al origen que abra la ventanita.
        call writeusercommerceinit(destino)
        userlist(destino).flags.comerciando = true
    
        'call enviarobjetotransaccion(origen)
    else
        'es el primero que comercia ?
        call writeconsolemsg(destino, userlist(origen).name & " desea comerciar. si deseas aceptar, escribe /comerciar.", fonttypenames.fonttype_talk)
        userlist(destino).flags.targetuser = origen
        
    end if
    
    call flushbuffer(destino)
    
    exit sub
errhandler:
        call logerror("error en iniciarcomercioconusuario: " & err.description)
end sub

public sub enviaroferta(byval userindex as integer, byval offerslot as byte)
'***************************************************
'autor: unkown
'last modification: 25/11/2009
'sends the offer change to the other trading user
'25/11/2009: zama - implementado nuevo sistema de comercio con ofertas variables.
'***************************************************
    dim objindex as integer
    dim objamount as long
    
    with userlist(userindex)
        if offerslot = gold_offer_slot then
            objindex = ioro
            objamount = userlist(.comusu.destusu).comusu.goldamount
        else
            objindex = userlist(.comusu.destusu).comusu.objeto(offerslot)
            objamount = userlist(.comusu.destusu).comusu.cant(offerslot)
        end if
    end with
   
    call writechangeusertradeslot(userindex, offerslot, objindex, objamount)
    call flushbuffer(userindex)

end sub

public sub fincomerciarusu(byval userindex as integer)
'***************************************************
'autor: unkown
'last modification: 25/11/2009
'25/11/2009: zama - limpio los arrays (por el nuevo sistema)
'***************************************************
    dim i as long
    
    with userlist(userindex)
        if .comusu.destusu > 0 then
            call writeusercommerceend(userindex)
        end if
        
        .comusu.acepto = false
        .comusu.confirmo = false
        .comusu.destusu = 0
        
        for i = 1 to max_offer_slots
            .comusu.cant(i) = 0
            .comusu.objeto(i) = 0
        next i
        
        .comusu.goldamount = 0
        .comusu.destnick = vbnullstring
        .flags.comerciando = false
    end with
end sub

public sub aceptarcomerciousu(byval userindex as integer)
'***************************************************
'autor: unkown
'last modification: 25/11/2009
'25/11/2009: zama - ahora se traspasan hasta 5 items + oro al comerciar
'***************************************************
    dim tradingobj as obj
    dim otrouserindex as integer
    dim terminarahora as boolean
    dim offerslot as integer

    userlist(userindex).comusu.acepto = true
    
    otrouserindex = userlist(userindex).comusu.destusu
    
    if userlist(otrouserindex).comusu.acepto = false then
        exit sub
    end if
    
    ' envio los items a quien corresponde
    for offerslot = 1 to max_offer_slots + 1
        
        ' items del 1er usuario
        with userlist(userindex)
            ' le pasa el oro
            if offerslot = gold_offer_slot then
                ' quito la cantidad de oro ofrecida
                .stats.gld = .stats.gld - .comusu.goldamount
                ' log
                if .comusu.goldamount > max_oro_logueable then call logdesarrollo(.name & " solt� oro en comercio seguro con " & userlist(otrouserindex).name & ". cantidad: " & .comusu.goldamount)
                ' update usuario
                call writeupdateuserstats(userindex)
                ' se la doy al otro
                userlist(otrouserindex).stats.gld = userlist(otrouserindex).stats.gld + .comusu.goldamount
                ' update otro usuario
                call writeupdateuserstats(otrouserindex)
                
            ' le pasa lo ofertado de los slots con items
            elseif .comusu.objeto(offerslot) > 0 then
                tradingobj.objindex = .comusu.objeto(offerslot)
                tradingobj.amount = .comusu.cant(offerslot)
                
                'quita el objeto y se lo da al otro
                if not meteritemeninventario(otrouserindex, tradingobj) then
                    call tiraritemalpiso(userlist(otrouserindex).pos, tradingobj)
                end if
            
                call quitarobjetos(tradingobj.objindex, tradingobj.amount, userindex)
                
                'es un objeto que tenemos que loguear? pablo (toxicwaste) 07/09/07
                if objdata(tradingobj.objindex).log = 1 then
                    call logdesarrollo(.name & " le pas� en comercio seguro a " & userlist(otrouserindex).name & " " & tradingobj.amount & " " & objdata(tradingobj.objindex).name)
                end if
            
                'es mucha cantidad?
                if tradingobj.amount > max_obj_logueable then
                'si no es de los prohibidos de loguear, lo logueamos.
                    if objdata(tradingobj.objindex).nolog <> 1 then
                        call logdesarrollo(userlist(otrouserindex).name & " le pas� en comercio seguro a " & .name & " " & tradingobj.amount & " " & objdata(tradingobj.objindex).name)
                    end if
                end if
            end if
        end with
        
        ' items del 2do usuario
        with userlist(otrouserindex)
            ' le pasa el oro
            if offerslot = gold_offer_slot then
                ' quito la cantidad de oro ofrecida
                .stats.gld = .stats.gld - .comusu.goldamount
                ' log
                if .comusu.goldamount > max_oro_logueable then call logdesarrollo(.name & " solt� oro en comercio seguro con " & userlist(userindex).name & ". cantidad: " & .comusu.goldamount)
                ' update usuario
                call writeupdateuserstats(otrouserindex)
                'y se la doy al otro
                userlist(userindex).stats.gld = userlist(userindex).stats.gld + .comusu.goldamount
                if .comusu.goldamount > max_oro_logueable then call logdesarrollo(userlist(userindex).name & " recibi� oro en comercio seguro con " & .name & ". cantidad: " & .comusu.goldamount)
                ' update otro usuario
                call writeupdateuserstats(userindex)
                
            ' le pasa la oferta de los slots con items
            elseif .comusu.objeto(offerslot) > 0 then
                tradingobj.objindex = .comusu.objeto(offerslot)
                tradingobj.amount = .comusu.cant(offerslot)
                
                'quita el objeto y se lo da al otro
                if not meteritemeninventario(userindex, tradingobj) then
                    call tiraritemalpiso(userlist(userindex).pos, tradingobj)
                end if
            
                call quitarobjetos(tradingobj.objindex, tradingobj.amount, otrouserindex)
                
                'es un objeto que tenemos que loguear? pablo (toxicwaste) 07/09/07
                if objdata(tradingobj.objindex).log = 1 then
                    call logdesarrollo(.name & " le pas� en comercio seguro a " & userlist(userindex).name & " " & tradingobj.amount & " " & objdata(tradingobj.objindex).name)
                end if
            
                'es mucha cantidad?
                if tradingobj.amount > max_obj_logueable then
                'si no es de los prohibidos de loguear, lo logueamos.
                    if objdata(tradingobj.objindex).nolog <> 1 then
                        call logdesarrollo(.name & " le pas� en comercio seguro a " & userlist(userindex).name & " " & tradingobj.amount & " " & objdata(tradingobj.objindex).name)
                    end if
                end if
            end if
        end with
        
    next offerslot

    ' end trade
    call fincomerciarusu(userindex)
    call fincomerciarusu(otrouserindex)
 
end sub

public sub agregaroferta(byval userindex as integer, byval offerslot as byte, byval objindex as integer, byval amount as long, byval isgold as boolean)
'***************************************************
'autor: zama
'last modification: 24/11/2009
'adds gold or items to the user's offer
'***************************************************

    if puedeseguircomerciando(userindex) then
        with userlist(userindex).comusu
            ' si ya confirmo su oferta, no puede cambiarla!
            if not .confirmo then
                if isgold then
                ' agregamos (o quitamos) mas oro a la oferta
                    .goldamount = .goldamount + amount
                    
                    ' imposible que pase, pero por las dudas..
                    if .goldamount < 0 then .goldamount = 0
                else
                ' agreamos (o quitamos) el item y su cantidad en el slot correspondiente
                    ' si es 0 estoy modificando la cantidad, no agregando
                    if objindex > 0 then .objeto(offerslot) = objindex
                    .cant(offerslot) = .cant(offerslot) + amount
                    
                    'quit� todos los items de ese tipo
                    if .cant(offerslot) <= 0 then
                        ' removemos el objeto para evitar conflictos
                        .objeto(offerslot) = 0
                        .cant(offerslot) = 0
                    end if
                end if
            end if
        end with
    end if

end sub

public function puedeseguircomerciando(byval userindex as integer) as boolean
'***************************************************
'autor: zama
'last modification: 24/11/2009
'validates wether the conditions for the commerce to keep going are satisfied
'***************************************************
dim otrouserindex as integer
dim comercioinvalido as boolean

with userlist(userindex)
    ' usuario valido?
    if .comusu.destusu <= 0 or .comusu.destusu > maxusers then
        comercioinvalido = true
    end if
    
    otrouserindex = .comusu.destusu
    
    if not comercioinvalido then
        ' estan logueados?
        if userlist(otrouserindex).flags.userlogged = false or .flags.userlogged = false then
            comercioinvalido = true
        end if
    end if
    
    if not comercioinvalido then
        ' se estan comerciando el uno al otro?
        if userlist(otrouserindex).comusu.destusu <> userindex then
            comercioinvalido = true
        end if
    end if
    
    if not comercioinvalido then
        ' el nombre del otro es el mismo que al que le comercio?
        if userlist(otrouserindex).name <> .comusu.destnick then
            comercioinvalido = true
        end if
    end if
    
    if not comercioinvalido then
        ' mi nombre  es el mismo que al que el le comercia?
        if .name <> userlist(otrouserindex).comusu.destnick then
            comercioinvalido = true
        end if
    end if
    
    if not comercioinvalido then
        ' esta vivo?
        if userlist(otrouserindex).flags.muerto = 1 then
            comercioinvalido = true
        end if
    end if
    
    ' fin del comercio
    if comercioinvalido = true then
        call fincomerciarusu(userindex)
        
        if otrouserindex <= 0 or otrouserindex > maxusers then
            call fincomerciarusu(otrouserindex)
            call protocol.flushbuffer(otrouserindex)
        end if
        
        exit function
    end if
end with

puedeseguircomerciando = true

end function
