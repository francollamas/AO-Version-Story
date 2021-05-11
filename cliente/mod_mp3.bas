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

public bbass as boolean

public function initializebass()
    ' check that bass 1.0 was loaded
    if bass_getstringversion <> "1.1" then
        logerror "wrong bass version number -> 1.1"
        bbass = false
    end if
    ' initialize digital sound - default device, 44100hz, stereo, 16 bits
    if bass_init(-1, 44100, bass_device_leavevol, frmmain.hwnd) = bassfalse then
        logerror "can't init sound system"
        bbass = false
        exit function
    end if
    ' start digital output
    if bass_start = bassfalse then
        logerror "can't start digital output"
        bbass = false
        exit function
    end if
    
    bbass = true
end function

public function shutdownbass()
    if bbass then
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
    end if
end function

public sub loadsounds()
    if bbass then
        dim ix as integer
        dim streamhandle as long
        frmcargando.mp3files.pattern = "*.mp3"
        frmcargando.mp3files.path = dirsound
        
        'load mp3s
        for ix = 0 to frmcargando.mp3files.listcount - 1
            streamhandle = bass_streamcreatefile(bassfalse, dirsound & frmcargando.mp3files.list(ix), 0, 0, 0)
            if streamhandle = 0 then
                logerror "can't create stream: " & frmcargando.mp3files.list(ix)
            else
                call cstrm.add(streamhandle, frmcargando.mp3files.list(ix))
            end if
        next ix
        
        'load wavs
        frmcargando.mp3files.pattern = "*.wav"
        for ix = 0 to frmcargando.mp3files.listcount - 1
            streamhandle = bass_streamcreatefile(bassfalse, dirsound & frmcargando.mp3files.list(ix), 0, 0, 0)
            if streamhandle = 0 then
                logerror "can't create stream: " & frmcargando.mp3files.list(ix)
            else
                call cstrm.add(streamhandle, frmcargando.mp3files.list(ix))
            end if
        next ix
    end if
end sub

public function playsound(sfile as string, optional bloop as boolean)
    if bbass and fx = 0 then
        'play stream, not flushed
        if bloop then
            if bass_channelisactive(cstrm(sfile)) = bassfalse then
                if bass_streamplay(cstrm(sfile), bassfalse, bass_sample_loop) = bassfalse then _
                    logerror "can't play stream: " & sfile
            end if
        else
            call bass_channelstop(cstrm(sfile))
            if bass_streamplay(cstrm(sfile), bassfalse, 0) = bassfalse then _
                logerror "can't play stream: " & sfile
        end if
    end if
end function

public function stopsound(sfile as string)
    if bbass then
        ' stop the stream
        if bass_channelisactive(cstrm(sfile)) = basstrue then
            call bass_channelstop(cstrm(sfile))
        end if
    end if
end function
