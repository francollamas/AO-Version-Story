attribute vb_name = "mod_mp3"
option explicit

public const snd_sync = &h0 ' sincrono
public const snd_async = &h1 ' asincrono
public const snd_nodefault = &h2 ' silence not default, if sound not found
public const snd_loop = &h8 ' loop the sound until next sndplaysound
public const snd_nostop = &h10 ' don't stop any currently playing sound

public const snd_click = "click.mp3"
public const snd_over = "click2.mp3"
public const snd_dice = "cupdice.mp3"
public const snd_pasos1 = "23.mp3"
public const snd_pasos2 = "24.mp3"

dim cstrm as new collection

public function initializebass()
    ' check that bass 1.0 was loaded
    if bass_getstringversion <> "1.1" then _
        logerror "wrong bass version number -> 1.1"
    ' initialize digital sound - default device, 44100hz, stereo, 16 bits
    if bass_init(-1, 44100, bass_device_leavevol, frmmain.hwnd) = bassfalse then _
        logerror "can't init sound system"
    ' start digital output
    if bass_start = bassfalse then _
        logerror "can't start digital output"
end function

public function shutdownbass()
    dim ix as integer
    ' stop digital output
    bass_stop
    ' free the stream
    for ix = 1 to cstrm.count
        bass_streamfree cstrm(ix)
    next ix
    ' close digital sound system
    bass_free
    ' release hstream collection
    set cstrm = nothing
end function

public sub loadsounds()
    dim ix as integer
    dim streamhandle as long
    frmcargando.mp3files.path = dirsound
    
    for ix = 0 to frmcargando.mp3files.listcount - 1
        streamhandle = bass_streamcreatefile(bassfalse, dirsound & frmcargando.mp3files.list(ix), 0, 0, 0)
        if streamhandle = 0 then
            logerror "can't create stream: " & frmcargando.mp3files.list(ix)
        else
            call cstrm.add(streamhandle, frmcargando.mp3files.list(ix))
        end if
    next ix
end sub

public function playsound(sfile as string)
    'stop stream if it's being played
    call bass_channelstop(cstrm(sfile))
    'play stream, not flushed
    if bass_streamplay(cstrm(sfile), bassfalse, 0) = bassfalse then _
        logerror "can't play stream: " & sfile
end function

public function stopsound(sfile as string)
    ' stop the stream
    call bass_channelstop(cstrm(sfile))
end function
