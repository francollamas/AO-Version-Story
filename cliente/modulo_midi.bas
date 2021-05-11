attribute vb_name = "mod_midi"
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
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

public const midi_inicio = 6

public curmidi as string
public loopmidi as byte '1 para repetir
public isplayingcheck as boolean

public getstarttime as long
public offset as long
public mttime as long
public mtlength as double
public dtempo as double


dim timesig as dmus_timesignature
dim portcaps as dmus_portcaps

dim msg as string
dim time as double
dim offset2 as long
dim elapsedtime2 as double
dim fispaused as boolean


public sub cargarmidi(archivo as string)

if musica = 1 then exit sub

on error goto fin
    
    if isplayingcheck then stop_midi
    if loader is nothing then set loader = directx.directmusicloadercreate()
    set seg = loader.loadsegment(archivo)
        
   
        
    set loader = nothing 'liberamos el cargador
    
    
    
    exit sub
fin:
    logerror "error producido en 'public sub cargarmidi' " & err.description & " " & err.number & " " & archivo

end sub

public sub stop_midi()

if isplayingcheck then
     isplayingcheck = false
     seg.setstartpoint (0)
     call perf.stop(seg, segstate, 0, 0)
     'seg.unload
     call perf.reset(0)
end if
end sub

public sub play_midi()
if musica = 1 then exit sub
on error goto fin
        
    
    set segstate = perf.playsegment(seg, 0, 0)
    
    isplayingcheck = true
    exit sub
fin:
    logerror "error producido en public sub play_midi()"

end sub

function sonando()
if musica = 1 then exit function
sonando = (perf.isplaying(seg, segstate) = true)
end function




