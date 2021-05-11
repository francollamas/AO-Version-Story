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
'affero general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************

'16/03/2004 - juan mart�n sotuyo dodero (maraxus) - (juansotuyo@gmail.com)
'   - first release
'
'03/03/2007 - juan mart�n sotuyo dodero (maraxus) - (juansotuyo@gmail.com)
'   - add: sound and music activation / deactivation from within the class.
'   - add: documentation
'   - change: volume is no longer the db amplification / atenuation to be
'           applied but a percentage for easier interaction with user.
'
'30/03/2008 - juan mart�n sotuyo dodero (maraxus) - (juansotuyo@gmail.com)
'   - add: 3d-like sound effects by altering frequency to emulate doppler effect,
'           volume to emulate distance and panning for position.
'
'28/07/2008 - franco zeoli (noich) - (zeolifranco@gmail.com)
'   -add: optional sound effects
'
'23/03/2010 - torres patricio(pato) - (paatoo.torres@gmail.com)
'   -add: ore code to reproduce mp3

''
' controls all audio using directsound and directmusic 7.
'
' @file     clsaudio.cls
' @author   juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version  1.2.1
' @date     20070303

option explicit

''
' maximum number of sound buffers to hold in memory at any time.
private const numsoundbuffers as byte = 30

''
' the distance at which the sound is inaudible.
private const max_distance_to_source as integer = 150

''
' the frequency variation coefficient for doppler effect simulation.
private const delta_fq as integer = 75

''
' custom sound buffer structure.
'
' @param    filename    the name of the file loaded in this buffer
' @param    looping     set to true if the sound will loop until stopped
' @param    x           the x position of the sound in map coordinates
' @param    y           the y position of the sound in map coordinates
' @param    normalfq    the frequency of the sound when not affected by doppler effect.
' @param    buffer      the directsoundbuffer object to wich the file is loaded
private type soundbuffer
    filename as string
    looping as boolean
    x as byte
    y as byte
    normalfq as long
    buffer as directsoundbuffer
end type

''
' states how to set a sound's looping state.
'
' @param    default     if wave is in memory use it's looping setting, otherwise false
' @param    disabled    never loop
' @param    enabled     loop until stopped
public enum loopstyle
    default = 0
    disabled = 1
    enabled = 2
end enum

''
' set to true once the object is created to prevent multiple initializations of the same object.
dim inited as boolean

''
'the one and only directsound object
dim directsound as directsound

''
'array of all existing sound buffers
dim dsbuffers(1 to numsoundbuffers) as soundbuffer

''
'directory from which to load sound files by default
dim soundpath as string

''
'the volume for sounds (fxs)
dim sndvolume as long

''
'directmusic's performance object
dim performance as directmusicperformance

''
'currently loaded segment
dim segment as directmusicsegment

''
'the one and only directmusic loader
dim loader as directmusicloader

''
'state of the currently loaded segment
dim segstate as directmusicsegmentstate

''
'states wether music is supported by hardware or not
dim music as boolean

''
'directory from which to load music files by default
dim musicpath as string

''
'last loaded music file. used to be able to load it when music gets activated
dim currentmusicfile as string

''
'states wether music is currently activated or not
dim mactivated as boolean

''
'states wether sound is currently activated or not
dim sactivated as boolean

''
'states the last position where the listener was in the x axis
dim lastposx as integer

''
'states the last position where the listener was in the y axis
dim lastposy as integer

''
'states wether sound effects are currently activated or not
dim seffectsactivated as boolean

'**** used by mp3 playing. *****
dim imc   as imediacontrol
dim iba   as ibasicaudio
dim ime   as imediaevent
dim impos as imediaposition

''
'constructor. performs no action at all.

private sub class_initialize()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'
'***************************************************
end sub

''
'destructor. releases all created objects assuring no memory-leaks.

private sub class_terminate()
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 12/31/09
'destroy's all directmusic and directsound objects
'12/31/09 - pato: use stopwave method to prevent errors.
'***************************************************
on local error resume next
    'stop every channel being used and destroy the buffer
    call stopwave
    
    'stop music
    call performance.stop(segment, segstate, 0, 0)
    
    call performance.closedown
    
    set directsound = nothing
    
    set segment = nothing
    set performance = nothing
    set loader = nothing
    
    inited = false
end sub

''
'initializes the clsaudio object.
'
' @param    dx          directx7 object to be used when creating the directsound and directmusic objects.
' @param    hwnd        handle to the window to be used by directmusic when playing midi files.
' @param    sound_path  directory in wich to search for sound files.
' @param    music_path  directory in wich to search for music files.
'
' @return   true if no errors occured, false otherwise.

public function initialize(byref dx as directx7, byval hwnd as long, byval sound_path as string, byval music_path as string) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'creates all ds and dm objects
'***************************************************
on error goto errhandler
    
    ' prevent multiple creations
    if inited then exit function
    
    'validate dx object
    if dx is nothing then goto errhandler
    
    'initialize directsound
    set directsound = dx.directsoundcreate("")
    
    call directsound.setcooperativelevel(hwnd, dsscl_priority)
    
    'set sound path
    soundpath = sound_path
    
    'set default volume
    sndvolume = 0
    
    'initialize directmusic
    music = initializedirectmusic(dx, hwnd)
    
    'set music path
    musicpath = music_path
    
    mactivated = true
    sactivated = true
    
    currentmusicfile = vbnullstring
    
    'set tempo to 0 and volume of music
    musictempo = 0
    call performance.setmastervolume(200)
    
    inited = true
    
    initialize = true
exit function

errhandler:
end function

''
' creates and configures all directmusic objects.
'
' @param    dx          directx7 object to be used when creating the directsound and directmusic objects.
' @param    hwnd        handle to the window to be used by directmusic when playing midi files.
'
' @return   true if no errors occured, false otherwise.

private function initializedirectmusic(byref dx as directx7, byval hwnd as long) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'initialize dm. returns false if music isn't supported by hw
'***************************************************
on error goto errhandler
    set loader = directx.directmusicloadercreate()
    
    set performance = dx.directmusicperformancecreate()
    call performance.init(directsound, hwnd)
    call performance.setmasterautodownload(true)        'enable auto download of instruments
    
    'set to port default, 1 channel group is enough for midis
    call performance.setport(-1, 1)
    
    initializedirectmusic = true
exit function

errhandler:
end function

''
' plays a new wave file.
'
' @param    filename    the path to the file to be loaded. must be a relative path from the default path set at initialization.
' @param    srcx        the x position of the sound source, in map coordinates. -1 if sound should not be altered by 3d alterations.
' @param    srcy        the y position of the sound source, in map coordinates. -1 if sound should not be altered by 3d alterations.
' @param    loopsound   the loop state for the sound.
'
' @return   the buffer index in which the sound is playing, or 0 in case of error.

public function playwave(byval filename as string, optional byval srcx as byte = 0, optional byval srcy as byte = 0, optional byval loopsound as loopstyle = loopstyle.default) as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 28/07/08
'last modified by: franco zeoli (noich)
'added support for 3d sound effects.
'***************************************************
on error goto errhandler
    dim bufferindex as long
    
    if not soundactivated then exit function
    
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
        
        'store position
        .x = srcx
        .y = srcy
        
        'get standard frequency
        .normalfq = .buffer.getfrequency()
    end with
    
    playwave = bufferindex
    
    if seffectsactivated then
        if srcx <> 0 and srcy <> 0 then
            call update3dsound(bufferindex, 0, 0)
        end if
    end if
exit function

errhandler:
end function

private sub resetsoundvalues()
'***************************************************
'author: torres patricio (pato)
'last modification: 03/04/10
'reset the frequency, volume and pan.
'***************************************************
    dim i as long
    
    for i = 1 to numsoundbuffers
        if not dsbuffers(i).buffer is nothing then
            with dsbuffers(i)
                call .buffer.setfrequency(.normalfq)
                call .buffer.setvolume(sndvolume)
                call .buffer.setpan(0)
            end with
        end if
    next i
end sub

private sub update3dsound(byval bufferindex as long, byval deltax as integer, byval deltay as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 05/09/09
'last modified by: marco vanotti (markoxx)
'fixed dopplers formula
'refreshes the sound's arguments.
'fixed the sndvolume formula
'***************************************************
    dim lineardistanceold as single
    dim lineardistancenew as single
    dim deltadistance as single
    dim distancexold as long
    dim distanceyold as long
    dim distancexnew as long
    dim distanceynew as long
    dim perceivedfq as long
    
    with dsbuffers(bufferindex)
        distancexold = .x - lastposx
        distanceyold = .y - lastposy
        
        distancexnew = distancexold + deltax
        distanceynew = distanceyold + deltay
        
        lineardistanceold = sqr(distancexold * distancexold + distanceyold * distanceyold)
        lineardistancenew = sqr(distancexnew * distancexnew + distanceynew * distanceynew)
        
        deltadistance = lineardistancenew - lineardistanceold
        
        'update frequency emulating doppler effect
        perceivedfq = .normalfq * (1 - deltadistance / delta_fq)
        if perceivedfq < dsbfrequency_min then perceivedfq = dsbfrequency_min
        
        call .buffer.setfrequency(perceivedfq)
        
        'set volumen amortiguation according to distance
        if lineardistancenew > max_distance_to_source then
            call .buffer.setvolume(sndvolume + (dsbvolume_min - sndvolume))
        else
            call .buffer.setvolume(sndvolume + (lineardistancenew / max_distance_to_source) * (dsbvolume_min - sndvolume))
        end if
        
        'prevent division by zero
        if lineardistancenew = 0 then lineardistancenew = 1
        
        'set panning according to relative position of the source to the listener
        call .buffer.setpan((distancexnew / lineardistancenew) * dsbpan_right)
    end with
end sub

''
' updates 3d sounds based on the movement of the listener.
'
' @param    x   the new coordinate of the listener in the x axis (consider 0 as the furthest point to the left).
' @param    y   the new coordinate of the listener in the y axis (consider 0 as the furthest point to the front).
'
' @return   the buffer index in which the sound is playing, or 0 in case of error.

public sub movelistener(byval x as integer, byval y as integer)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 28/07/08
'last modification by: franco zeoli (noich)
'moves the position of the listener updating all 3d sounds.
'***************************************************
    dim i as long
    dim deltax as integer
    dim deltay as integer
    
    if not seffectsactivated then exit sub
    
    deltax = x - lastposx
    deltay = y - lastposy
    
    for i = 1 to numsoundbuffers
        if not dsbuffers(i).buffer is nothing then
            if dsbuffers(i).buffer.getstatus and dsbstatus_playing then
                if dsbuffers(i).x <> 0 and dsbuffers(i).y <> 0 then
                    call update3dsound(i, deltax, deltay)
                end if
            end if
        end if
    next i
    
    lastposx = x
    lastposy = y
end sub

''
' loads a new wave file.
'
' @param    filename    the path to the file to be loaded. must be a relative path from the default path set at initialization.
' @param    looping     the loop state for the sound.
'
' @return   the buffer index in which the sound is playing, or 0 in case of error.

private function loadwave(byval filename as string, byval looping as loopstyle) as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/28/09
'last modification by: marco vanotti (markoxx)
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
            if dsbuffers(i).buffer.getstatus = 0 or dsbuffers(i).buffer.getstatus() = dsbstatus_bufferlost then
                'found it!!! we just play this one :)
                loadwave = i
                
                'set looping if needed
                if looping <> loopstyle.default then dsbuffers(i).looping = (looping = loopstyle.enabled)
                
                'reset default sound frecuency to avoid issues.
                call dsbuffers(i).buffer.setfrequency(dsbuffers(i).normalfq)
                
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
            if dsbuffers(i).buffer.getstatus() = dsbstatus_bufferlost or dsbuffers(i).buffer.getstatus() = 0 then
                exit for
            end if
        next i
    end if
    
    'still no free buffers?? get the first non-looping sound
    if i > numsoundbuffers then
        for i = 1 to numsoundbuffers
            if not (dsbuffers(i).buffer.getstatus() and dsbstatus_looping) then
                call dsbuffers(i).buffer.stop
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

''
' stops a given sound or all of them.
'
' @param    bufferindex     the index of the sound file to stop playing. if 0, all sounds are stopped.

public sub stopwave(optional byval bufferindex as long = 0)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'stops the sound in the given buffer index, or every sound if
'index is 0
'***************************************************
    if bufferindex > 0 and bufferindex <= numsoundbuffers then
        if dsbuffers(bufferindex).buffer.getstatus() and dsbstatus_playing then
            call dsbuffers(bufferindex).buffer.stop
        end if
    elseif bufferindex = 0 then
        dim i as long
        for i = 1 to numsoundbuffers
            if not dsbuffers(i).buffer is nothing then
                if dsbuffers(i).buffer.getstatus() <> 0 and dsbuffers(i).buffer.getstatus() <> dsbstatus_bufferlost then
                    call dsbuffers(i).buffer.stop
                end if
            end if
        next i
    end if
end sub

''
' retrieves wether there are sounds currentyl playing or not.
'
' @return   true if there is at least one sound playing, false otherwise.

public property get playingsound() as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns true if there is at least one sound playing
'***************************************************
    dim i as long
    
    for i = 1 to numsoundbuffers
        if not dsbuffers(i).buffer is nothing then
            if dsbuffers(i).buffer.getstatus() and dsbstatus_playing then
                playingsound = true
                exit property
            end if
        end if
    next i
end property

''
' sets the volume of sound.
'
' @param    volume  new value to be set, in percentage (0 to 100).

public property let soundvolume(byval volume as byte)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the sound's volume as a percentage
'***************************************************
    dim i as long
    
    if volume > 100 then exit property
    
    'take percentage to actual value
    sndvolume = volume * (dsbvolume_max - dsbvolume_min) / 100 + dsbvolume_min
    
    for i = 1 to numsoundbuffers
        if not dsbuffers(i).buffer is nothing then
            if dsbuffers(i).buffer.getstatus and dsbstatus_playing then
                call dsbuffers(i).buffer.setvolume(sndvolume)
            end if
        end if
    next i
end property

''
' gets the volume of sound.
'
' @return   the current sound volume in percentage.

public property get soundvolume() as byte
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the music's volume as a percentage
'***************************************************
    soundvolume = cbyte((sndvolume - dsbvolume_min) * 100 / (dsbvolume_max - dsbvolume_min))
end property

''
' plays a new midi file.
'
' @param    file    the path to the file to be loaded. must be a relative path from the default path set at initialization.
' @param    loops   number of times to loop sound. for eternal loops set it to -1.
'
' @return   true if file was properly loaded and started playing, false otherwise.

public function playmidi(optional byval file as string = "", optional byval loops as long = -1) as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'loads a midi and start to play it
'***************************************************
on error goto errhandler
    if lenb(file) > 0 then _
        currentmusicfile = file
    
    if not musicactivated then exit function
    
    if not music then exit function
    
    if playingmusic then stopmidi
    
    if lenb(file) > 0 then
        if not loadmidi(file) then exit function
    else
        'make sure we have a loaded segment
        if segment is nothing then exit function
    end if
    
    musicmp3stop
    
    'play it
    call segment.setrepeats(loops)
    
    set segstate = performance.playsegment(segment, 0, 0)
    
    playmidi = true
exit function

errhandler:
end function

''
' loads a new midi file.
'
' @param    file    the path to the file to be loaded. must be a relative path from the default path set at initialization.
'
' @return   true if file was properly loaded and started playing, false otherwise.

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
    
    call segment.setstandardmidifile
    
    loadmidi = true
exit function

errhandler:
end function

''
' stops playing the currently loaded midi file.

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

''
' sets the music's tempo.
'
' @param    tempo   new tempo value. must be in the range of 0.25 to 2.0

public property let musictempo(byval tempo as single)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the music's tempo
'***************************************************
    if not music then exit property
    
    if tempo < 0.25 or tempo > 2# then exit property
    
    call performance.setmastertempo(tempo)
end property

''
' sets the music's volume.
'
' @param    volume  percentage to wich to set the music volume.

public property let musicvolume(byval volume as long)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'sets the music's volume as a percentage
'***************************************************
    if not music then exit property
    
    if volume < 0 or volume > 100 then exit property
    
    ' volume ranges from -10000 to 10000
    call performance.setmastervolume(volume * 200 - 10000)
end property

''
' gets the music's tempo.
'
' @return   current music'tempo.

public property get musictempo() as single
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns the music's tempo
'***************************************************
    if not music then exit property
    
    musictempo = performance.getmastertempo()
end property

''
' gets the music's volume.
'
' @return   current music's volume as a percentage.

public property get musicvolume() as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns the music's volume as a percentage
'***************************************************
    if not music then exit property
    
    musicvolume = (performance.getmastervolume() + 10000) / 200
end property

''
' checks wether there is music currently playing.
'
' @return   true if there is a midi playing, false otherwise.

public property get playingmusic() as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns true if a midi is being played
'***************************************************
    if not music or segment is nothing then exit property
    
    playingmusic = performance.isplaying(segment, segstate)
end property

''
' retrieves the music's length.
'
' @return   current music's length.

public property get musiclenght() as long
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns the lenght of the current midi
'***************************************************
    if not music then exit property
    
    musiclenght = segment.getlength()
end property

''
' destroy the mp3 objects.
'
' @return   true if the objects were destroy.

public function musicmp3empty() as boolean
'**************************************
'* created by: fredrik alexandersson  *
'* modify date: 20/5/2003             *
'**************************************
    on error goto errorhandl
    
    if objptr(imc) > 0 then
        call musicmp3stop
    end if
    
    set iba = nothing
    set ime = nothing
    set impos = nothing
    set imc = nothing
    
    musicmp3empty = true
    exit function

errorhandl:
    musicmp3empty = false
    end
end function

''
' loads a new mp3 file.
'
' @param    filepath    the path to the file to be loaded.
' @return   true    if file was properly loaded and started playing, false otherwise.

public function musicmp3load(byval filepath as string, optional byval volume as long = 0, optional byval balance as long = 0) as boolean '**** loads a mp3 *****
'**************************************
'* created by: fredrik alexandersson  *
'* modify date: 20/5/2003             *
'**************************************
    on error goto errorhandl
    
    if not fileexist(filepath, vbarchive) then exit function
    
    if not musicmp3empty() = true then goto errorhandl
    
    set imc = new filgraphmanager
    call imc.renderfile(filepath)
    
    set iba = imc
    
    if soundvolume > 0 then soundvolume = 0
    if volume < -4000 then volume = -4000
    
    iba.volume = volume
    
    if balance > 5000 then balance = 5000
    if balance < -5000 then balance = -5000
    
    iba.balance = balance
    
    set ime = imc
    
    set impos = imc
    if objptr(impos) then impos.rate = 1#
    impos.currentposition = 0
    
    musicmp3load = true
    exit function

errorhandl:
    musicmp3load = false
end function

''
' plays a new mp3 file.
'
' @param    filepath    the path to the file to be loaded. if the path is null then play the loaded mp3.
'
' @return   true    if file was properly loaded and started playing, false otherwise.

public function musicmp3play(optional byval filepath as string = "") as boolean
'**************************************
'* created by: fredrik alexandersson  *
'* modify date: 20/5/2003             *
'**************************************
    on error goto errorhandl
    
    if not musicactivated then exit function
    
    if not music then exit function
    
    if lenb(filepath) > 0 then
        if not musicmp3load(filepath) then exit function
    else
        if imc is nothing then exit function
    end if
    
    stopmidi
    call imc.run
    
    musicmp3play = true
    exit function

errorhandl:
    musicmp3play = false
end function

''
' check if the song need looping.

public sub musicmp3getloop()
    on error goto errorhandl
    
    if impos.stoptime = impos.currentposition then
        musicmp3stop
        musicmp3play
    end if
errorhandl:
end sub

''
' stop a the current mp3 file.
'
' @return   true    if file was properly stop, false otherwise.

public function musicmp3stop() as boolean
'**************************************
'* created by: fredrik alexandersson  *
'* modify date: 20/5/2003             *
'**************************************
    on error goto errorhandl
    
    imc.stop
    impos.currentposition = 0
    
    musicmp3stop = true
    exit function

errorhandl:
    musicmp3stop = false
end function

''
' pause a the current mp3 file.
'
' @return   true    if file was properly pause, false otherwise.

public function musicmp3pause() as boolean
'***************************************************
' created by: juan mart�n sotuyo dodero
' modify date: 25/6/2004
'***************************************************
    on error goto errorhandl
    
    call imc.pause
    
    musicmp3pause = true
    exit function

errorhandl:
    musicmp3pause = false
end function

''
' set the volume to the current mp3.
'
' @param    soundvolume the new volume to the current mp3.
' @return   true    if the volume was properly change, false otherwise.

public function musicmp3volumeset(byval soundvolume as long) as boolean
'**************************************
'* created by: fredrik alexandersson  *
'* modify date: 20/5/2003             *
'**************************************
    on error goto errorhandl
    
    if soundvolume > 0 then soundvolume = 0
    if soundvolume < -4000 then soundvolume = -4000
    
    iba.volume = soundvolume

    musicmp3volumeset = true
    exit function

errorhandl:
    musicmp3volumeset = false
end function

''
' retrieves wether music is activated or not.
'
' @return   true if music is activated, false otherwise.

public property get musicactivated() as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 03/03/07
'retrieves wether the music is activated or not
'***************************************************
    musicactivated = mactivated
end property

''
' sets wether music is activated or not.
'
' @param    nvalue  true if music should be activated, false otherwise.

public property let musicactivated(byval nvalue as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 03/03/07
'sets wether the music is activated or not
'***************************************************
    if mactivated = nvalue then exit property
    
    mactivated = nvalue
    
    if nvalue then
        call playmidi(currentmusicfile)
    else
        call stopmidi
    end if
end property

''
' retrieves wether sound is activated or not.
'
' @return   true if sound is activated, false otherwise.

public property get soundactivated() as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 03/03/07
'retrieves wether the sound is activated or not
'***************************************************
    soundactivated = sactivated
end property

''
' sets wether sound is activated or not.
'
' @param    nvalue  true if sound should be activated, false otherwise.

public property let soundactivated(byval nvalue as boolean)
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modification: 03/03/07
'sets wether the sound is activated or not
'***************************************************
    if sactivated = nvalue then exit property
    
    sactivated = nvalue
    
    if not nvalue then
        call stopwave
    end if
end property

''
' sets wether sound effects are activated or not.
'
' @param nvalue true if sound effects should be activated, false otherwise.

public property let soundeffectsactivated(byval nvalue as boolean)
'***************************************************
'author: franco zeoli (noich)
'last modification: 03/04/10
'sets wether the sound effects are activated or not
'03/04/10 - pato: if sound effects are disable, then reset the frequency, volume and pan.
'***************************************************
    seffectsactivated = nvalue
    
    if not nvalue then
        call resetsoundvalues
    end if
end property

''
' retrieves wether sound effects are activated or not.
'
' @return   true if sound effects are activated, false otherwise.

public property get soundeffectsactivated() as boolean
'***************************************************
'author: franco zeoli (noich)
'last modification: 28/07/08
'retrieves wether the sound effects are activated or not
'***************************************************
    soundeffectsactivated = seffectsactivated
end property
