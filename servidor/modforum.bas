attribute vb_name = "modforum"
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

public const max_mensajes_foro as byte = 30
public const max_anuncios_foro as byte = 5

public const foro_real_id as string = "real"
public const foro_caos_id as string = "caos"

public type tpost
    stitulo as string
    spost as string
    autor as string
end type

public type tforo
    vspost(1 to max_mensajes_foro) as tpost
    vsanuncio(1 to max_anuncios_foro) as tpost
    cantposts as byte
    cantanuncios as byte
    id as string
end type

private numforos as integer
private foros() as tforo


public sub addforum(byval sforoid as string)
'***************************************************
'author: zama
'last modification: 22/02/2010
'adds a forum to the list and fills it.
'***************************************************
    dim forumpath as string
    dim postpath as string
    dim postindex as integer
    dim fileindex as integer
    
    numforos = numforos + 1
    redim preserve foros(1 to numforos) as tforo
    
    forumpath = app.path & "\foros\" & sforoid & ".for"
    
    with foros(numforos)
    
        .id = sforoid
        
        if fileexist(forumpath, vbnormal) then
            .cantposts = val(getvar(forumpath, "info", "cantmsg"))
            .cantanuncios = val(getvar(forumpath, "info", "cantanuncios"))
            
            ' cargo posts
            for postindex = 1 to .cantposts
                fileindex = freefile
                postpath = app.path & "\foros\" & sforoid & postindex & ".for"

                open postpath for input shared as #fileindex
                
                ' titulo
                input #fileindex, .vspost(postindex).stitulo
                ' autor
                input #fileindex, .vspost(postindex).autor
                ' mensaje
                input #fileindex, .vspost(postindex).spost
                
                close #fileindex
            next postindex
            
            ' cargo anuncios
            for postindex = 1 to .cantanuncios
                fileindex = freefile
                postpath = app.path & "\foros\" & sforoid & postindex & "a.for"

                open postpath for input shared as #fileindex
                
                ' titulo
                input #fileindex, .vsanuncio(postindex).stitulo
                ' autor
                input #fileindex, .vsanuncio(postindex).autor
                ' mensaje
                input #fileindex, .vsanuncio(postindex).spost
                
                close #fileindex
            next postindex
        end if
        
    end with
    
end sub

public function getforumindex(byref sforoid as string) as integer
'***************************************************
'author: zama
'last modification: 22/02/2010
'returns the forum index.
'***************************************************
    
    dim forumindex as integer
    
    for forumindex = 1 to numforos
        if foros(forumindex).id = sforoid then
            getforumindex = forumindex
            exit function
        end if
    next forumindex
    
end function

public sub addpost(byval forumindex as integer, byref post as string, byref autor as string, _
                   byref titulo as string, byval banuncio as boolean)
'***************************************************
'author: zama
'last modification: 22/02/2010
'saves a new post into the forum.
'***************************************************

    with foros(forumindex)
        
        if banuncio then
            if .cantanuncios < max_anuncios_foro then _
                .cantanuncios = .cantanuncios + 1
            
            call movearray(forumindex, banuncio)
            
            ' agrego el anuncio
            with .vsanuncio(1)
                .stitulo = titulo
                .autor = autor
                .spost = post
            end with
            
        else
            if .cantposts < max_mensajes_foro then _
                .cantposts = .cantposts + 1
                
            call movearray(forumindex, banuncio)
            
            ' agrego el post
            with .vspost(1)
                .stitulo = titulo
                .autor = autor
                .spost = post
            end with
        
        end if
    end with
end sub

public sub saveforums()
'***************************************************
'author: zama
'last modification: 22/02/2010
'saves all forums into disk.
'***************************************************
    dim forumindex as integer

    for forumindex = 1 to numforos
        call saveforum(forumindex)
    next forumindex
end sub


private sub saveforum(byval forumindex as integer)
'***************************************************
'author: zama
'last modification: 22/02/2010
'saves a forum into disk.
'***************************************************

    dim postindex as integer
    dim fileindex as integer
    dim postpath as string
    
    call cleanforum(forumindex)
    
    with foros(forumindex)
        
        ' guardo info del foro
        call writevar(app.path & "\foros\" & .id & ".for", "info", "cantmsg", .cantposts)
        call writevar(app.path & "\foros\" & .id & ".for", "info", "cantanuncios", .cantanuncios)
        
        ' guardo posts
        for postindex = 1 to .cantposts
            
            postpath = app.path & "\foros\" & .id & postindex & ".for"
            fileindex = freefile()
            open postpath for output as fileindex
            
            with .vspost(postindex)
                print #fileindex, .stitulo
                print #fileindex, .autor
                print #fileindex, .spost
            end with
            
            close #fileindex
            
        next postindex
        
        ' guardo anuncios
        for postindex = 1 to .cantanuncios
            
            postpath = app.path & "\foros\" & .id & postindex & "a.for"
            fileindex = freefile()
            open postpath for output as fileindex
            
            with .vsanuncio(postindex)
                print #fileindex, .stitulo
                print #fileindex, .autor
                print #fileindex, .spost
            end with
            
            close #fileindex

        next postindex
        
    end with
    
end sub

public sub cleanforum(byval forumindex as integer)
'***************************************************
'author: zama
'last modification: 22/02/2010
'cleans a forum from disk.
'***************************************************
    dim postindex as integer
    dim numpost as integer
    dim forumpath as string

    with foros(forumindex)
    
        ' elimino todo
        forumpath = app.path & "\foros\" & .id & ".for"
        if fileexist(forumpath, vbnormal) then
    
            numpost = val(getvar(forumpath, "info", "cantmsg"))
            
            ' elimino los post viejos
            for postindex = 1 to numpost
                kill app.path & "\foros\" & .id & postindex & ".for"
            next postindex
            
            
            numpost = val(getvar(forumpath, "info", "cantanuncios"))
            
            ' elimino los post viejos
            for postindex = 1 to numpost
                kill app.path & "\foros\" & .id & postindex & "a.for"
            next postindex
            
            
            ' elimino el foro
            kill app.path & "\foros\" & .id & ".for"
    
        end if
    end with

end sub

public function sendposts(byval userindex as integer, byref foroid as string) as boolean
'***************************************************
'author: zama
'last modification: 22/02/2010
'sends all the posts of a required forum
'***************************************************
    
    dim forumindex as integer
    dim postindex as integer
    dim besgm as boolean
    
    forumindex = getforumindex(foroid)

    if forumindex > 0 then

        with foros(forumindex)
            
            ' send general posts
            for postindex = 1 to .cantposts
                with .vspost(postindex)
                    call writeaddforummsg(userindex, eforummsgtype.iegeneral, .stitulo, .autor, .spost)
                end with
            next postindex
            
            ' send sticky posts
            for postindex = 1 to .cantanuncios
                with .vsanuncio(postindex)
                    call writeaddforummsg(userindex, eforummsgtype.iegeneral_sticky, .stitulo, .autor, .spost)
                end with
            next postindex
            
        end with
        
        besgm = esgm(userindex)
        
        ' caos?
        if escaos(userindex) or besgm then
            
            forumindex = getforumindex(foro_caos_id)
            
            with foros(forumindex)
                
                ' send general caos posts
                for postindex = 1 to .cantposts
                
                    with .vspost(postindex)
                        call writeaddforummsg(userindex, eforummsgtype.iecaos, .stitulo, .autor, .spost)
                    end with
                    
                next postindex
                
                ' send sticky posts
                for postindex = 1 to .cantanuncios
                    with .vsanuncio(postindex)
                        call writeaddforummsg(userindex, eforummsgtype.iecaos_sticky, .stitulo, .autor, .spost)
                    end with
                next postindex
                
            end with
        end if
            
        ' caos?
        if esarmada(userindex) or besgm then
            
            forumindex = getforumindex(foro_real_id)
            
            with foros(forumindex)
                
                ' send general real posts
                for postindex = 1 to .cantposts
                
                    with .vspost(postindex)
                        call writeaddforummsg(userindex, eforummsgtype.iereal, .stitulo, .autor, .spost)
                    end with
                    
                next postindex
                
                ' send sticky posts
                for postindex = 1 to .cantanuncios
                    with .vsanuncio(postindex)
                        call writeaddforummsg(userindex, eforummsgtype.iereal_sticky, .stitulo, .autor, .spost)
                    end with
                next postindex
                
            end with
        end if
        
        sendposts = true
    end if
    
end function

public function esanuncio(byval forumtype as byte) as boolean
'***************************************************
'author: zama
'last modification: 22/02/2010
'returns true if the post is sticky.
'***************************************************
    select case forumtype
        case eforummsgtype.iecaos_sticky
            esanuncio = true
            
        case eforummsgtype.iegeneral_sticky
            esanuncio = true
            
        case eforummsgtype.iereal_sticky
            esanuncio = true
            
    end select
    
end function

public function forumalignment(byval yforumtype as byte) as byte
'***************************************************
'author: zama
'last modification: 01/03/2010
'returns the forum alignment.
'***************************************************
    select case yforumtype
        case eforummsgtype.iecaos, eforummsgtype.iecaos_sticky
            forumalignment = eforumtype.iecaos
            
        case eforummsgtype.iegeneral, eforummsgtype.iegeneral_sticky
            forumalignment = eforumtype.iegeneral
            
        case eforummsgtype.iereal, eforummsgtype.iereal_sticky
            forumalignment = eforumtype.iereal
            
    end select
    
end function

public sub resetforums()
'***************************************************
'author: zama
'last modification: 22/02/2010
'resets forum info
'***************************************************
    redim foros(1 to 1) as tforo
    numforos = 0
end sub

private sub movearray(byval forumindex as integer, byval sticky as boolean)
dim i as long

with foros(forumindex)
    if sticky then
        for i = .cantanuncios to 2 step -1
            .vsanuncio(i).stitulo = .vsanuncio(i - 1).stitulo
            .vsanuncio(i).spost = .vsanuncio(i - 1).spost
            .vsanuncio(i).autor = .vsanuncio(i - 1).autor
        next i
    else
        for i = .cantposts to 2 step -1
            .vspost(i).stitulo = .vspost(i - 1).stitulo
            .vspost(i).spost = .vspost(i - 1).spost
            .vspost(i).autor = .vspost(i - 1).autor
        next i
    end if
end with
end sub
