attribute vb_name = "modsenddata"
'**************************************************************
' senddata.bas - has all methods to send data to different user groups.
' makes use of the modareas module.
'
' implemented by juan mart�n sotuyo dodero (maraxus) (juansotuyo@gmail.com)
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
' contains all methods to send data to different user groups.
' makes use of the modareas module.
'
' @author juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version 1.0.0
' @date 20070107

option explicit

public enum sendtarget
    toall = 1
    tomap
    topcarea
    toallbutindex
    tomapbutindex
    togm
    tonpcarea
    toguildmembers
    toadmins
    topcareabutindex
    toadminsareabutconsejeros
    todiosesyclan
    toconsejo
    toclanarea
    toconsejocaos
    torolesmasters
    todeadarea
    tociudadanos
    tocriminales
    topartyarea
    toreal
    tocaos
    tociudadanosyrms
    tocriminalesyrms
    torealyrms
    tocaosyrms
end enum

public sub senddata(byval sndroute as sendtarget, byval sndindex as integer, byval snddata as string)
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus) - rewrite of original
'last modify date: 01/08/2007
'last modified by: (liquid)
'**************************************************************
on error resume next
    dim loopc as long
    dim map as integer
    
    select case sndroute
        case sendtarget.topcarea
            call sendtouserarea(sndindex, snddata)
            exit sub
        
        case sendtarget.toadmins
            for loopc = 1 to lastuser
                if userlist(loopc).connid <> -1 then
                    if userlist(loopc).flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios or playertype.consejero) then
                        call enviardatosaslot(loopc, snddata)
                   end if
                end if
            next loopc
            exit sub
        
        case sendtarget.toall
            for loopc = 1 to lastuser
                if userlist(loopc).connid <> -1 then
                    if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.toallbutindex
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) and (loopc <> sndindex) then
                    if userlist(loopc).flags.userlogged then 'esta logeado como usuario?
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.tomap
            call sendtomap(sndindex, snddata)
            exit sub
          
        case sendtarget.tomapbutindex
            call sendtomapbutindex(sndindex, snddata)
            exit sub
        
        case sendtarget.toguildmembers
            loopc = modguilds.m_iterador_proximouserindex(sndindex)
            while loopc > 0
                if (userlist(loopc).connid <> -1) then
                    call enviardatosaslot(loopc, snddata)
                end if
                loopc = modguilds.m_iterador_proximouserindex(sndindex)
            wend
            exit sub
        
        case sendtarget.todeadarea
            call sendtodeaduserarea(sndindex, snddata)
            exit sub
        
        case sendtarget.topcareabutindex
            call sendtouserareabutindex(sndindex, snddata)
            exit sub
        
        case sendtarget.toclanarea
            call sendtouserguildarea(sndindex, snddata)
            exit sub
        
        case sendtarget.topartyarea
            call sendtouserpartyarea(sndindex, snddata)
            exit sub
        
        case sendtarget.toadminsareabutconsejeros
            call sendtoadminsbutconsejerosarea(sndindex, snddata)
            exit sub
        
        case sendtarget.tonpcarea
            call sendtonpcarea(sndindex, snddata)
            exit sub
        
        case sendtarget.todiosesyclan
            loopc = modguilds.m_iterador_proximouserindex(sndindex)
            while loopc > 0
                if (userlist(loopc).connid <> -1) then
                    call enviardatosaslot(loopc, snddata)
                end if
                loopc = modguilds.m_iterador_proximouserindex(sndindex)
            wend
            
            loopc = modguilds.iterador_proximogm(sndindex)
            while loopc > 0
                if (userlist(loopc).connid <> -1) then
                    call enviardatosaslot(loopc, snddata)
                end if
                loopc = modguilds.iterador_proximogm(sndindex)
            wend
            
            exit sub
        
        case sendtarget.toconsejo
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if userlist(loopc).flags.privilegios and playertype.royalcouncil then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.toconsejocaos
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if userlist(loopc).flags.privilegios and playertype.chaoscouncil then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.torolesmasters
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if userlist(loopc).flags.privilegios and playertype.rolemaster then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.tociudadanos
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if not criminal(loopc) then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.tocriminales
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if criminal(loopc) then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.toreal
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if userlist(loopc).faccion.armadareal = 1 then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.tocaos
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if userlist(loopc).faccion.fuerzascaos = 1 then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.tociudadanosyrms
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if not criminal(loopc) or (userlist(loopc).flags.privilegios and playertype.rolemaster) <> 0 then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.tocriminalesyrms
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if criminal(loopc) or (userlist(loopc).flags.privilegios and playertype.rolemaster) <> 0 then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.torealyrms
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if userlist(loopc).faccion.armadareal = 1 or (userlist(loopc).flags.privilegios and playertype.rolemaster) <> 0 then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
        
        case sendtarget.tocaosyrms
            for loopc = 1 to lastuser
                if (userlist(loopc).connid <> -1) then
                    if userlist(loopc).faccion.fuerzascaos = 1 or (userlist(loopc).flags.privilegios and playertype.rolemaster) <> 0 then
                        call enviardatosaslot(loopc, snddata)
                    end if
                end if
            next loopc
            exit sub
    end select
end sub

private sub sendtouserarea(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey
    
    if not mapavalido(map) then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if userlist(tempindex).areasinfo.arearecivex and areax then  'esta en el area?
            if userlist(tempindex).areasinfo.arearecivey and areay then
                if userlist(tempindex).connidvalida then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

private sub sendtouserareabutindex(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempint as integer
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey

    if not mapavalido(map) then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
            
        tempint = userlist(tempindex).areasinfo.arearecivex and areax
        if tempint then  'esta en el area?
            tempint = userlist(tempindex).areasinfo.arearecivey and areay
            if tempint then
                if tempindex <> userindex then
                    if userlist(tempindex).connidvalida then
                        call enviardatosaslot(tempindex, sddata)
                    end if
                end if
            end if
        end if
    next loopc
end sub

private sub sendtodeaduserarea(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey
    
    if not mapavalido(map) then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if userlist(tempindex).areasinfo.arearecivex and areax then  'esta en el area?
            if userlist(tempindex).areasinfo.arearecivey and areay then
                'dead and admins read
                if userlist(tempindex).connidvalida = true and (userlist(tempindex).flags.muerto = 1 or (userlist(tempindex).flags.privilegios and (playertype.admin or playertype.dios or playertype.semidios or playertype.consejero)) <> 0) then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

private sub sendtouserguildarea(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey
    
    if not mapavalido(map) then exit sub
    
    if userlist(userindex).guildindex = 0 then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if userlist(tempindex).areasinfo.arearecivex and areax then  'esta en el area?
            if userlist(tempindex).areasinfo.arearecivey and areay then
                if userlist(tempindex).connidvalida and userlist(tempindex).guildindex = userlist(userindex).guildindex then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

private sub sendtouserpartyarea(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey
    
    if not mapavalido(map) then exit sub
    
    if userlist(userindex).partyindex = 0 then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if userlist(tempindex).areasinfo.arearecivex and areax then  'esta en el area?
            if userlist(tempindex).areasinfo.arearecivey and areay then
                if userlist(tempindex).connidvalida and userlist(tempindex).partyindex = userlist(userindex).partyindex then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

private sub sendtoadminsbutconsejerosarea(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = userlist(userindex).pos.map
    areax = userlist(userindex).areasinfo.areapertenecex
    areay = userlist(userindex).areasinfo.areapertenecey
    
    if not mapavalido(map) then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if userlist(tempindex).areasinfo.arearecivex and areax then  'esta en el area?
            if userlist(tempindex).areasinfo.arearecivey and areay then
                if userlist(tempindex).connidvalida then
                    if userlist(tempindex).flags.privilegios and (playertype.semidios or playertype.dios or playertype.admin) then _
                        call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

private sub sendtonpcarea(byval npcindex as long, byval sddata as string)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempint as integer
    dim tempindex as integer
    
    dim map as integer
    dim areax as integer
    dim areay as integer
    
    map = npclist(npcindex).pos.map
    areax = npclist(npcindex).areasinfo.areapertenecex
    areay = npclist(npcindex).areasinfo.areapertenecey
    
    if not mapavalido(map) then exit sub
    
    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        tempint = userlist(tempindex).areasinfo.arearecivex and areax
        if tempint then  'esta en el area?
            tempint = userlist(tempindex).areasinfo.arearecivey and areay
            if tempint then
                if userlist(tempindex).connidvalida then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

public sub sendtoareabypos(byval map as integer, byval areax as integer, byval areay as integer, byval sddata as string)
'**************************************************************
'author: lucio n. tourrilhes (dunga)
'last modify date: unknow
'
'**************************************************************
    dim loopc as long
    dim tempint as integer
    dim tempindex as integer
    
    areax = 2 ^ (areax \ 9)
    areay = 2 ^ (areay \ 9)
    
    if not mapavalido(map) then exit sub

    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
            
        tempint = userlist(tempindex).areasinfo.arearecivex and areax
        if tempint then  'esta en el area?
            tempint = userlist(tempindex).areasinfo.arearecivey and areay
            if tempint then
                if userlist(tempindex).connidvalida then
                    call enviardatosaslot(tempindex, sddata)
                end if
            end if
        end if
    next loopc
end sub

public sub sendtomap(byval map as integer, byval sddata as string)
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 5/24/2007
'
'**************************************************************
    dim loopc as long
    dim tempindex as integer
    
    if not mapavalido(map) then exit sub

    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if userlist(tempindex).connidvalida then
            call enviardatosaslot(tempindex, sddata)
        end if
    next loopc
end sub

public sub sendtomapbutindex(byval userindex as integer, byval sddata as string)
'**************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 5/24/2007
'
'**************************************************************
    dim loopc as long
    dim map as integer
    dim tempindex as integer
    
    map = userlist(userindex).pos.map
    
    if not mapavalido(map) then exit sub

    for loopc = 1 to conngroups(map).countentrys
        tempindex = conngroups(map).userentrys(loopc)
        
        if tempindex <> userindex and userlist(tempindex).connidvalida then
            call enviardatosaslot(tempindex, sddata)
        end if
    next loopc
end sub
