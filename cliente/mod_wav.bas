attribute vb_name = "mod_wav"
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

public const snd_sync = &h0 ' sincrono
public const snd_async = &h1 ' asincrono
public const snd_nodefault = &h2 ' silence not default, if sound not found
public const snd_loop = &h8 ' loop the sound until next sndplaysound
public const snd_nostop = &h10 ' don't stop any currently playing sound

'�?�?�?�?�?�?�?�?�?�?�?�?�?wavs�?�?�?�?�?�?�?�?�?�?�?�?
public const snd_click = "click.wav"

public const snd_pasos1 = "23.wav"
public const snd_pasos2 = "24.wav"
public const snd_navegando = "50.wav"
public const snd_over = "click2.wav"
public const snd_dice = "cupdice.wav"

function loadwavetodsbuffer(ds as directsound, dsb as directsoundbuffer, sfile as string) as boolean
    dim bufferdesc as dsbufferdesc
    dim waveformat as waveformatex

    bufferdesc.lflags = dsbcaps_ctrlfrequency or dsbcaps_ctrlpan or dsbcaps_ctrlvolume or dsbcaps_static

    waveformat.nformattag = wave_format_pcm
    waveformat.nchannels = 2
    waveformat.lsamplespersec = 22050
    waveformat.nbitspersample = 16
    waveformat.nblockalign = waveformat.nbitspersample / 8 * waveformat.nchannels
    waveformat.lavgbytespersec = waveformat.lsamplespersec * waveformat.nblockalign
    set dsb = ds.createsoundbufferfromfile(dirsound & sfile, bufferdesc, waveformat)

    if err.number <> 0 then
        exit function
    end if

    loadwavetodsbuffer = true
end function

sub playwaveds(file as string)
    if fx = 1 then exit sub

    lastsoundbufferused = lastsoundbufferused + 1
    if lastsoundbufferused > numsoundbuffers then
        lastsoundbufferused = 1
    end if

    if loadwavetodsbuffer(directsound, dsbuffers(lastsoundbufferused), file) then
        dsbuffers(lastsoundbufferused).play dsbplay_default
    end if
end sub
