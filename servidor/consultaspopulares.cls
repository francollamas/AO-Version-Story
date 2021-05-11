version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "consultaspopulares"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'argentum online 0.11.20
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
'modulo de consultas popluares
'en realidad el modulo inicial guardaba los datos de las votaciones
'en memoria, pero no le vi el punto, las votaciones son de vez en cuando nomas
'y el query a un .ini que registra todos los mails q ya votaron, es soportable
'si cuando uno vota y averiguo que el mail ya voto pero el pj no, entonces seteo
'el flag de yavoto en el charfile ese tambien agregando redundancia para velocidad,
'por lo que la busqueda secuencial en el .dat que tiene todos los mails q ya votaron
'se hara .. 1 vez por pj nomas.
'
'hecha por el oso (ositear@yahoo.com.ar)


private const archivomails = "\logs\votaron.dat"
private const archivoconfig = "\dat\consultas.dat"

private pencuestaactualnum as integer
private pencuestaactualtex as string
private pnivelrequerido as integer
private popciones() as integer


public property let numero(byval numencuesta as integer)
    pencuestaactualnum = numencuesta
end property

public property get numero() as integer
    numero = pencuestaactualnum
end property

public property let texto(byval descripcion as string)
    pencuestaactualtex = descripcion
end property

public property get texto() as string
    texto = pencuestaactualtex
end property


public sub loaddata()
dim cantopciones as integer
dim i as integer

    pencuestaactualnum = val(getvar(app.path & archivoconfig, "init", "consultaactual"))
    pencuestaactualtex = getvar(app.path & archivoconfig, "init", "consultaactualtexto")
    pnivelrequerido = getvar(app.path & archivoconfig, "init", "nivelrequerido")

    if pencuestaactualnum > 0 then
       'cargo todas las opciones
        cantopciones = val(getvar(app.path & archivoconfig, "encuesta" & pencuestaactualnum, "cantopciones"))
        redim popciones(1 to cantopciones) as integer
        for i = 1 to cantopciones
            popciones(i) = val(getvar(app.path & archivoconfig, "encuesta" & pencuestaactualnum, "opcion" & i))
        next i
    end if
end sub

public function dovotar(byval userindex as integer, opcion as integer) as string
on error goto errorh
dim yavoto as boolean
dim charfile as string
dim sufragio as integer

    'revisar q no haya votado
    'grabar en el charfile el numero de encuesta
    'actualizar resultados encuesta
    if pencuestaactualnum = 0 then
        dovotar = "no hay consultas populares abiertas"
        exit function
    end if

    charfile = charpath & userlist(userindex).name & ".chr"
    
    
    
    if (userlist(userindex).stats.elv >= pnivelrequerido) then
        if (opcionvalida(opcion)) then
            yavoto = val(getvar(charfile, "consultas", "voto")) >= pencuestaactualnum
            if not yavoto then
                if not mailyavoto(userlist(userindex).email) then
                    'pj apto para votar
                    sufragio = clng(val(getvar(app.path & archivoconfig, "resultados" & pencuestaactualnum, "v" & opcion)))
                    sufragio = sufragio + 1
                    call writevar(app.path & archivoconfig, "resultados" & pencuestaactualnum, "v" & opcion, str(sufragio))
                    dovotar = "tu voto ha sido computado. opcion: " & opcion
                    call marcarpjcomoqueyavoto(userindex)
                    call marcarmailcomoqueyavoto(userlist(userindex).email)
                else
                    call marcarpjcomoqueyavoto(userindex)
                    dovotar = "este email ya voto en la consulta: " & pencuestaactualtex
                end if
            else
                dovotar = "este personaje ya voto en la consulta: " & pencuestaactualtex
            end if
        else
            dovotar = "esa no es una opcion para votar"
        end if
    else
        dovotar = "para votar en esta consulta debes ser nivel " & pnivelrequerido & " o superior"
    end if
   

exit function
errorh:
call logerror("error en consultaspopularse.dovotar: " & err.description)

end function


public function sendinfoencuesta(byval userindex as integer) as string
dim i as integer
    call senddata(toindex, userindex, 0, "||consulta popular numero " & pencuestaactualnum & fonttype_guild)
    call senddata(toindex, userindex, 0, "||" & pencuestaactualtex & fonttype_guild)
    call senddata(toindex, userindex, 0, "|| opciones de voto: " & fonttype_guildmsg)
    for i = 1 to ubound(popciones)
        call senddata(toindex, userindex, 0, "||(opcion " & i & "): " & getvar(app.path & archivoconfig, "encuesta" & pencuestaactualnum, "opcion" & i) & fonttype_guildmsg)
    next i
    call senddata(toindex, userindex, 0, "|| para votar una opcion, escribe /encuesta numerodeopcion, por ejemplo para votar la opcion 1, escribe /encuesta 1. tu voto no podra ser cambiado." & fonttype_veneno)
end function


private sub marcarpjcomoqueyavoto(byval userindex as integer)
    call writevar(charpath & userlist(userindex).name & ".chr", "consultas", "voto", str(pencuestaactualnum))
end sub


private function mailyavoto(byval email as string) as boolean
'abro el archivo, while not eof levnato 1 linea y comparo. si da true, cierro
dim archn as integer
dim tmp as string

mailyavoto = false

archn = freefile()

open app.path & archivomails for input as #archn

do while not eof(archn)
    line input #archn, tmp
    if email = tmp then
        mailyavoto = true
        close #archn
        exit function
    end if
loop

close #archn
end function


private sub marcarmailcomoqueyavoto(byval email as string)
dim archn as integer

archn = freefile()

open app.path & archivomails for append as #archn
print #archn, email

close #archn

end sub


private function opcionvalida(byval opcion as integer) as boolean
    opcionvalida = opcion > 0 and opcion <= ubound(popciones)
end function

private function dameopcion(byval opcion as integer) as string
    if opcionvalida(opcion) then
        dameopcion = getvar(app.path & archivoconfig, "encuesta" & pencuestaactualnum, "opcion" & opcion)
    else
        dameopcion = "error"
    end if
end function
