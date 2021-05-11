version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsaudio"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clsaudio.cls - controls all audio using directsound and directmusic
'
' designed and implemented by juan mart�n sotuyo dodero (maraxus)
' (juansotuyo@hotmail.com)
'**************************************************************

'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'(at your option) any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'gnu general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************

option explicit

private const numsoundbuffers as byte = 30

'wave sounds
private type soundbuffer
    filename as string
    looping as boolean
    buffer as directsoundbuffer
end type

public enum loopstyle
    default = 0     'if wave is in memory use it's looping setting, otherwise false
    disabled = 1    'never loop
    enabled = 2     'loop
end enum

dim directsound as directsound
dim dsbuffers(1 to numsoundbuffers) as soundbuffer

dim soundpath as string

dim sndvolume as long   'sound volume

'music
dim performance as directmusicperformance
dim segment as directmusicsegment
dim loader as directmusicloader
dim segstate as directmusicsegmentstate

dim music as boolean        'true if music is supported by hw

dim musicpath as string

private sub class_initialize()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'
'***************************************************
end sub

private sub class_terminate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'destroy's all directmusic and directsound objects
'***************************************************
on local error resume next
    dim loopc as long
    
    'stop every channel being used and destroy the buffer
    for loopc = 1 to numsoundbuffers
        call dsbuffers(loopc).buffer.stop
        set dsbuffers(loopc).buffer = nothing
    next loopc
    
    'stop music
    call performance.stop(segment, segstate, 0, 0)
    
    call performance.closedown
    
    set directsound = nothing
    
    set segment = nothing
    set performance = nothing
    set loader = nothing
end sub

public function initialize(byref dx as directx7, byval hwnd as long, byval sound_path as string, byval music_path as string) as boolean
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'creates all ds and dm objects
'***************************************************
on error goto errhandler

    'validate dx object
    if dx is nothing then goto errhandler
    
    'initialize directsound
    set directsound = dx.directsoundcreate("")
    
    directsound.setcooperativelevel displayformhwnd, dsscl_priority
    
    'set sound path
    soundpath = sound_path
    
    'set default volume
    sndvolume = 0
    
    'initialize directmusic
    music = initializedirectmusic(dx, hwnd)
    
    'set music path
    musicpath = music_path
    
    initialize = true
exit function

errhandler:
end function

private function initializedirectmusic(byref dx as directx7, byval hwnd as long) as boolean
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'initialize dm. returns false if music isn't supported by hw
'***************************************************
on error goto errhandler
    set loader = directx.directmusicloadercreate()
    
    set performance = dx.directmusicperformancecreate()
    performance.init directsound, hwnd
    performance.setmasterautodownload true     'enable auto doanload of instruments
    
    'set to port default, 1 channel group is enough for midis
    performance.setport -1, 1
    
    initializedirectmusic = true
exit function

errhandler:
end function

public function playwave(byval filename as string, optional byval loopsound as loopstyle = loopstyle.default) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 10/04/06
'loads a new wave to memory (if it isn't already loaded) and starts playing it
'returns the index in which the sound is playing
'***************************************************
on error goto errhandler
    dim bufferindex as long
    
    'get the buffer index were wave was loaded
    bufferindex = loadwave(filename, loopsound)
    if bufferindex = 0 then exit function   'if an error ocurred abort
    
    with dsbuffers(bufferindex)
        if .looping then
            .buffer.play dsbplay_looping
        else
            .buffer.play dsbplay_default
        end if
        
        'apply volume
        call .buffer.setvolume(sndvolume)
    end with
    
    playwave = bufferindex
exit function

errhandler:
end function

private function loadwave(byval filename as string, byval looping as loopstyle) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 10/04/06
'loads a new wave into memory (if it's not already loaded) and returns
'the buffer index
'***************************************************
on error goto errhandler
    dim bufferdesc as dsbufferdesc
    dim waveformat as waveformatex
    dim i as long
    
    filename = ucase$(filename)
    
    if not fileexist(soundpath & filename, vbarchive) then _
        exit function
    
    'check if the buffer is in memory and not playing
    for i = 1 to numsoundbuffers
        if dsbuffers(i).filename = filename then
            if dsbuffers(i).buffer.getstatus = 0 or dsbuffers(i).buffer.getstatus = dsbstatus_bufferlost then
                'found it!!! we just play this one :)
                loadwave = i
                
                'set looping if needed
                if looping <> loopstyle.default then dsbuffers(i).looping = (looping = loopstyle.enabled)
                
                exit function
            end if
        end if
    next i
    
    'not in memory, search for an empty buffer
    for i = 1 to numsoundbuffers
        if dsbuffers(i).buffer is nothing then
            exit for
        end if
    next i
    
    'no empty buffers?? search for one not being played and use that slot
    if i > numsoundbuffers then
        for i = 1 to numsoundbuffers
            if dsbuffers(i).buffer.getstatus = dsbstatus_bufferlost or dsbuffers(i).buffer.getstatus = 0 then
                exit for
            end if
        next i
    end if
    
    'still no free buffers?? get the first non-looping sound
    if i > numsoundbuffers then
        for i = 1 to numsoundbuffers
            if not (dsbuffers(i).buffer.getstatus and dsbstatus_looping) then
                exit for
            end if
        next i
    end if
    
    'if every sound is looping, just ignore new sound unless it's looping too (in which case we set it at the first slot by default)
    if i > numsoundbuffers then
        if not looping then exit function
        i = 1
    end if
    
    'create new sound
    bufferdesc.lflags = dsbcaps_ctrlfrequency or dsbcaps_ctrlpan or dsbcaps_ctrlvolume or dsbcaps_static
    
    waveformat.nformattag = wave_format_pcm
    waveformat.nchannels = 2
    waveformat.lsamplespersec = 22050
    waveformat.nbitspersample = 16
    waveformat.nblockalign = waveformat.nbitspersample / 8 * waveformat.nchannels
    waveformat.lavgbytespersec = waveformat.lsamplespersec * waveformat.nblockalign
    
    with dsbuffers(i)
        set .buffer = nothing   'get rid of any previous data
        
        .filename = filename
        .looping = (looping = loopstyle.enabled)
        
        set .buffer = directsound.createsoundbufferfromfile(soundpath & filename, bufferdesc, waveformat)
    end with
    
    loadwave = i
exit function

errhandler:
end function

public sub stopwave(optional byval bufferindex as long = 0)
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'stops the sound in the given buffer index, or every sound if
'index is invalid
'***************************************************
    if bufferindex > 0 and bufferindex <= numsoundbuffers then
        if dsbuffers(bufferindex).buffer.getstatus and dsbstatus_playing then
            call dsbuffers(bufferindex).buffer.stop
        end if
    else
        dim i as long
        for i = 1 to numsoundbuffers
            if not dsbuffers(i).buffer is nothing then
                if dsbuffers(i).buffer.getstatus <> 0 and dsbuffers(i).buffer.getstatus <> dsbstatus_bufferlost then
                    call dsbuffers(i).buffer.stop
                end if
            end if
        next i
    end if
end sub

public property get playingsound() as boolean
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns true if there is at least one sound playing
'***************************************************
    dim i as long
    
    for i = 1 to numsoundbuffers
        if dsbuffers(i).buffer.getstatus and dsbstatus_playing then
            playingsound = true
            exit property
        end if
    next i
end property

public property let soundvolume(byval volume as long)
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the sound's volume
'***************************************************
    dim i as long
    
    for i = 1 to numsoundbuffers
        if dsbuffers(i).buffer.getstatus and dsbstatus_playing then
            call dsbuffers(i).buffer.setvolume(volume)
        end if
    next i
    
    sndvolume = volume
end property

public property get soundvolume() as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the music's volume
'***************************************************
    soundvolume = sndvolume
end property

public function playmidi(optional byval file as string = "", optional byval loops as long = -1) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'loads a midi and start to play it
'***************************************************
on error goto errhandler
    if not music then exit function
    
    if playingmusic then stopmidi
    
    if file <> "" then
        if not loadmidi(file) then exit function
    else
        'make sure we have a loaded segment
        if segment is nothing then exit function
    end if
    
    'play it
    segment.setrepeats loops
    
    set segstate = performance.playsegment(segment, 0, 0)
    
    'set tempo to 0 and volume to max
    musictempo = 0
    musicvolume = 200
    
    playmidi = true
exit function

errhandler:
end function

private function loadmidi(byval file as string) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'loads a midi to memory
'***************************************************
on error goto errhandler
    if not fileexist(musicpath & file, vbarchive) then exit function
    
    call stopmidi
    
    'destroy old object
    set segment = nothing
    
    set segment = loader.loadsegment(musicpath & file)
    
    if segment is nothing then
        exit function
    end if
    
    segment.setstandardmidifile
    
    loadmidi = true
exit function

errhandler:
end function

public sub stopmidi()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'stops playing a midi
'***************************************************
on error goto errhandler
    if playingmusic then
        call performance.stop(segment, segstate, 0, 0)
    end if
exit sub

errhandler:
end sub

public property let musictempo(byval tempo as single)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the music's tempo
'***************************************************
    if not music then exit property
    
    performance.setmastertempo tempo
end property

public property let musicvolume(byval volume as long)
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the music's volume
'***************************************************
    if not music then exit property
    
    performance.setmastervolume volume
end property

public property get musictempo() as single
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns the music's tempo
'***************************************************
    if not music then exit property
    
    musictempo = performance.getmastertempo
end property

public property get musicvolume() as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns the music's volume
'***************************************************
    if not music then exit property
    
    musicvolume = performance.getmastervolume
end property

public property get playingmusic() as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns true if a midi is being played
'***************************************************
    if not music or segment is nothing then exit property
    
    playingmusic = performance.isplaying(segment, segstate)
end property

public property get musiclenght() as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns the lenght of the current midi
'***************************************************
    if not music then exit property
    
    musiclenght = segment.getlength
end property
