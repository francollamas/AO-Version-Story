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


''
' controls all audio using directsound and directmusic 7.
'
' @file     clsaudio.cls
' @author   juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version  1.1.0
' @date     20070303

option explicit

''
' maximum number of sound buffers to hold in memory at any time.
private const numsoundbuffers as byte = 30

''
' custom sound buffer structure.
'
' @param    filename    the name of the file loaded in this buffer
' @param    looping     set to true if the sound will loop until stopped
' @param    buffer      the directsoundbuffer object to wich the file is loaded
private type soundbuffer
    filename as string
    looping as boolean
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
'autor: juan mart�n sotuyo dodero (maraxus)
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
    
    call directsound.setcooperativelevel(displayformhwnd, dsscl_priority)
    
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
'autor: juan mart�n sotuyo dodero (maraxus)
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
' @param    loopsound   the loop state for the sound.
'
' @return   the buffer index in which the sound is playing, or 0 in case of error.

public function playwave(byval filename as string, optional byval loopsound as loopstyle = loopstyle.default) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 10/04/06
'loads a new wave to memory (if it isn't already loaded) and starts playing it
'returns the index in which the sound is playing
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
    end with
    
    playwave = bufferindex
exit function

errhandler:
end function

''
' loads a new wave file.
'
' @param    filename    the path to the file to be loaded. must be a relative path from the default path set at initialization.
' @param    looping     the loop state for the sound.
'
' @return   the buffer index in which the sound is playing, or 0 in case of error.

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
            if dsbuffers(i).buffer.getstatus = 0 or dsbuffers(i).buffer.getstatus() = dsbstatus_bufferlost then
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
'autor: juan mart�n sotuyo dodero (maraxus)
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
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 16/03/04
'returns true if there is at least one sound playing
'***************************************************
    dim i as long
    
    for i = 1 to numsoundbuffers
        if dsbuffers(i).buffer.getstatus() and dsbstatus_playing then
            playingsound = true
            exit property
        end if
    next i
end property

''
' sets the volume of sound.
'
' @param    volume  new value to be set, in percentage (0 to 100).

public property let soundvolume(byval volume as byte)
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
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
'autor: juan mart�n sotuyo dodero (maraxus)
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
'autor: juan mart�n sotuyo dodero (maraxus)
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
    dim i as long
    
    if sactivated = nvalue then exit property
    
    sactivated = nvalue
    
    if not nvalue then
        call stopwave
    end if
end property
