attribute vb_name = "modbasslib"
'bass 1.0 multimedia library
'-----------------------------
'(c) 1999-2001 ian luck.
'please report bugs/suggestions/etc... to bass@un4seen.com

'note: this unit will only work with bass.dll version 1.0
'check http://www.un4seen.com/music for any later
'versions of bass.bas

'visual basic api version 1.0 by adam hoult / update by hendrik knaepen
'----------------------------------------------------------------------
'questions, suggestions, etc. regarding the visual basic api
'can be sent to admin@daedalusd.com

' history - uk dates (dd/mm/yyyy)
' -------------------------------
' 16/06/2001 bass.bas 1.0
'            (original code by adam hoult; update by hendrik knaepen)
'            fixed some bugs
'            added bass_musicgetnamestring function
'            added bass_getdevicedescriptionstring function
'            added bass_getdevicecount function
'
' 07/03/2000 bass.pas 0.8b
'            added bass_device_leavevol flag
'
' 12/01/2000 bass.bas 0.8
'            happy new year !! =) updated for bass 0.8
'            tons of stuff added, especially to do with
'            directsound objects etc plus some other
'            general enhancements.
'
' 22/09/1999 bass.bas 0.7
'            updated the bas file for use with the new
'            version of bass (0.7). added the extra a3d
'            calls, plus the new posreset flag. also
'            updated the needed functions.
'
' 07/09/1999 bass.bas 0.6
'            the first bass api for visual basic
'            tested with vb5, but should also work
'            properly under vb4 & vb6 (not sure about
'            vb3 due to the use of callbacks.)

global const basstrue as integer = 1   'use this instead of vb booleans
global const bassfalse as integer = 0  'use this instead of vb booleans

'***********************************************
'* error codes returned by bass_geterrorcode() *
'***********************************************
global const bass_ok = 0               'all is ok
global const bass_error_mem = 1        'memory error
global const bass_error_fileopen = 2   'can't open the file
global const bass_error_driver = 3     'can't find a free sound driver
global const bass_error_buflost = 4    'the sample buffer was lost - please report this!
global const bass_error_handle = 5     'invalid handle
global const bass_error_format = 6     'unsupported format
global const bass_error_position = 7   'invalid playback position
global const bass_error_init = 8       'bass_init has not been successfully called
global const bass_error_start = 9      'bass_start has not been successfully called
global const bass_error_initcd = 10    'can't initialize cd
global const bass_error_cdinit = 11    'bass_cdinit has not been successfully called
global const bass_error_nocd = 12      'no cd in drive
global const bass_error_cdtrack = 13   'can't play the selected cd track
global const bass_error_already = 14   'already initialized
global const bass_error_cdvol = 15     'cd has no volume control
global const bass_error_nopause = 16   'not paused
global const bass_error_notaudio = 17  'not an audio track
global const bass_error_nochan = 18    'can't get a free channel
global const bass_error_illtype = 19   'an illegal type was specified
global const bass_error_illparam = 20  'an illegal parameter was specified
global const bass_error_no3d = 21      'no 3d support
global const bass_error_noeax = 22     'no eax support
global const bass_error_device = 23    'illegal device number
global const bass_error_noplay = 24    'not playing
global const bass_error_freq = 25      'illegal sample rate
global const bass_error_noa3d = 26     'a3d.dll is not installed
global const bass_error_notfile = 27   'the stream is not a file stream (wav/mp3)
global const bass_error_nohw = 29      'no hardware voices available
global const bass_error_nosync = 30    'synchronizers have been disabled
global const bass_error_empty = 31     'the mod music has no sequence data
global const bass_error_nonet = 32     'no internet connection could be opened
global const bass_error_unknown = -1   'some other mystery error

'**********************
'* device setup flags *
'**********************
global const bass_device_8bits = 1     'use 8 bit resolution, else 16 bit
global const bass_device_mono = 2      'use mono, else stereo
global const bass_device_3d = 4        'enable 3d functionality
' if the bass_device_3d flag is not specified when initilizing bass,
' then the 3d flags (bass_sample_3d and bass_music_3d) are ignored when
' loading/creating a sample/stream/music.
global const bass_device_a3d = 8       'enable a3d functionality
global const bass_device_nosync = 16   'disable synchronizers
global const bass_device_leavevol = 32 'leave volume as it is

'***********************************
'* bass_info flags (from dsound.h) *
'***********************************
global const dscaps_continuousrate = 16
' supports all sample rates between min/maxrate
global const dscaps_emuldriver = 32
' device does not have hardware directsound support
global const dscaps_certified = 64
' device driver has been certified by microsoft
' the following flags tell what type of samples are supported by hardware
' mixing, all these formats are supported by software mixing
global const dscaps_secondarymono = 256    ' mono
global const dscaps_secondarystereo = 512  ' stereo
global const dscaps_secondary8bit = 1024   ' 8 bit
global const dscaps_secondary16bit = 2048  ' 16 bit

'***************
'* music flags *
'***************
global const bass_music_ramp = 1       ' normal ramping
global const bass_music_ramps = 2      ' sensitive ramping
' ramping doesn't take a lot of extra processing and improves
' the sound quality by removing "clicks". sensitive ramping will
' leave sharp attacked samples, unlike normal ramping.
global const bass_music_loop = 4       ' loop music
global const bass_music_ft2mod = 16    ' play .mod as fasttracker 2 does
global const bass_music_pt1mod = 32    ' play .mod as protracker 1 does
global const bass_music_mono = 64      ' force mono mixing (less cpu usage)
global const bass_music_3d = 128       ' enable 3d functionality
global const bass_music_posreset = 256 ' stop all notes when moving position
global const bass_music_surround = 512 'surround sound
global const bass_music_surround2 = 1024 'surround sound (mode 2)
global const bass_music_stopback = 2048 'stop the music on a backwards jump effect

'*********************
'* sample info flags *
'*********************
global const bass_sample_8bits = 1             ' 8 bit, else 16 bit
global const bass_sample_mono = 2              ' mono, else stereo
global const bass_sample_loop = 4              ' looped
global const bass_sample_3d = 8                ' 3d functionality enabled
global const bass_sample_software = 16         ' it's not using hardware mixing
global const bass_sample_mutemax = 32          ' muted at max distance (3d only)
global const bass_sample_vam = 64              ' uses the dx7 voice allocation & management
global const bass_sample_over_vol = 65536      ' override lowest volume
global const bass_sample_over_pos = 131072     ' override longest playing
global const bass_sample_over_dist = 196608    ' override furthest from listener (3d only)

global const bass_mp3_halfrate = 65536         ' reduced quality mp3 (half sample rate)
global const bass_mp3_setpos = 131072          ' enable bass_channelsetposition on the mp3
global const bass_stream_autofree = 262144     ' automatically free the stream when it stop/ends
global const bass_stream_restrate = 524288     ' restrict the download rate of internet file streams

'********************
'* 3d channel modes *
'********************
global const bass_3dmode_normal = 0
' normal 3d processing
global const bass_3dmode_relative = 1
' the channel's 3d position (position/velocity/orientation) are relative to
' the listener. when the listener's position/velocity/orientation is changed
' with bass_set3dposition, the channel's position relative to the listener does
' not change.
global const bass_3dmode_off = 2
' turn off 3d processing on the channel, the sound will be played
' in the center.


'****************************************************
'* eax environments, use with bass_seteaxparameters *
'****************************************************
global const eax_environment_generic = 0
global const eax_environment_paddedcell = 1
global const eax_environment_room = 2
global const eax_environment_bathroom = 3
global const eax_environment_livingroom = 4
global const eax_environment_stoneroom = 5
global const eax_environment_auditorium = 6
global const eax_environment_concerthall = 7
global const eax_environment_cave = 8
global const eax_environment_arena = 9
global const eax_environment_hangar = 10
global const eax_environment_carpetedhallway = 11
global const eax_environment_hallway = 12
global const eax_environment_stonecorridor = 13
global const eax_environment_alley = 14
global const eax_environment_forest = 15
global const eax_environment_city = 16
global const eax_environment_mountains = 17
global const eax_environment_quarry = 18
global const eax_environment_plain = 19
global const eax_environment_parkinglot = 20
global const eax_environment_sewerpipe = 21
global const eax_environment_underwater = 22
global const eax_environment_drugged = 23
global const eax_environment_dizzy = 24
global const eax_environment_psychotic = 25
' total number of environments
global const eax_environment_count = 26

'*************************************************************
'* eax presets, usage: bass_seteaxparametersvb(eax_preset_xxx) *
'*************************************************************
global const eax_preset_generic = 1
global const eax_preset_paddedcell = 2
global const eax_preset_room = 3
global const eax_preset_bathroom = 4
global const eax_preset_livingroom = 5
global const eax_preset_stoneroom = 6
global const eax_preset_auditorium = 7
global const eax_preset_concerthall = 8
global const eax_preset_cave = 9
global const eax_preset_arena = 10
global const eax_preset_hangar = 11
global const eax_preset_carpetedhallway = 12
global const eax_preset_hallway = 13
global const eax_preset_stonecorridor = 14
global const eax_preset_alley = 15
global const eax_preset_forest = 16
global const eax_preset_city = 17
global const eax_preset_mountains = 18
global const eax_preset_quarry = 19
global const eax_preset_plain = 20
global const eax_preset_parkinglot = 21
global const eax_preset_sewerpipe = 22
global const eax_preset_underwater = 23
global const eax_preset_drugged = 24
global const eax_preset_dizzy = 25
global const eax_preset_psychotic = 26

'******************************
'* a3d resource manager modes *
'******************************
global const a3d_resmode_off = 0                'off
global const a3d_resmode_notify = 1             'notify when there are no free hardware channels
global const a3d_resmode_dynamic = 2            'non-looping channels are managed
global const a3d_resmode_dynamic_loopers = 3    'all (inc. looping) channels are managed (req a3d 1.2)


'**********************************************************************
'* sync types (with bass_channelsetsync() "param" and syncproc "data" *
'* definitions) & flags.                                              *
'**********************************************************************
' sync when a music or stream reaches a position.
' if hmusic...
' param: loword=order (0=first, -1=all) hiword=row (0=first, -1=all)
' data : loword=order hiword=row
' if hstream...
' param: position in bytes
' data : not used
global const bass_sync_pos = 0
global const bass_sync_musicpos = 0
' sync when an instrument (sample for the non-instrument based formats)
' is played in a music (not including retrigs).
' param: loword=instrument (1=first) hiword=note (0=c0...119=b9, -1=all)
' data : loword=note hiword=volume (0-64)
global const bass_sync_musicinst = 1
' sync when a music or file stream reaches the end.
' param: not used
' data : not used
global const bass_sync_end = 2
' sync when the "sync" effect (xm/mtm/mod: e8x, it/s3m: s0x) is used.
' param: 0:data=pos, 1:data="x" value
' data : param=0: loword=order hiword=row, param=1: "x" value */
global const bass_sync_musicfx = 3
'flag: sync at mixtime, else at playtime
global const bass_sync_mixtime = 1073741824#
' flag: sync only once, else continuously
global const bass_sync_onetime = 2147483648#

global const cdchannel = 0                    ' cd channel, for use with bass_channel functions

'**************************************************************
'* directsound interfaces (for use with bass_getdsoundobject) *
'**************************************************************
global const bass_object_ds = 1                     ' directsound
global const bass_object_ds3dl = 2                  'idirectsound3dlistener

'******************************
'* dx7 voice allocation flags *
'******************************
' play the sample in hardware. if no hardware voices are available then
' the "play" call will fail
global const bass_vam_hardware = 1
' play the sample in software (ie. non-accelerated). no other vam flags
'may be used together with this flag.
global const bass_vam_software = 2

'******************************
'* dx7 voice management flags *
'******************************
' these flags enable hardware resource stealing... if the hardware has no
' available voices, a currently playing buffer will be stopped to make room for
' the new buffer. note: only samples loaded/created with the bass_sample_vam
' flag are considered for termination by the dx7 voice management.

' if there are no free hardware voices, the buffer to be terminated will be
' the one with the least time left to play.
global const bass_vam_term_time = 4
' if there are no free hardware voices, the buffer to be terminated will be
' one that was loaded/created with the bass_sample_mutemax flag and is beyond
' it 's max distance. if there are no buffers that match this criteria, then the
' "play" call will fail.
global const bass_vam_term_dist = 8
' if there are no free hardware voices, the buffer to be terminated will be
' the one with the lowest priority.
global const bass_vam_term_prio = 16

'**********************************************************************
'* software 3d mixing algorithm modes (used with bass_set3dalgorithm) *
'**********************************************************************
' default algorithm (currently translates to bass_3dalg_off)
global const bass_3dalg_default = 0
' uses normal left and right panning. the vertical axis is ignored except for
'scaling of volume due to distance. doppler shift and volume scaling are still
'applied, but the 3d filtering is not performed. this is the most cpu efficient
'software implementation, but provides no virtual 3d audio effect. head related
'transfer function processing will not be done. since only normal stereo panning
'is used, a channel using this algorithm may be accelerated by a 2d hardware
'voice if no free 3d hardware voices are available.
global const bass_3dalg_off = 1
' this algorithm gives the highest quality 3d audio effect, but uses more cpu.
' requires windows 98 2nd edition or windows 2000 that uses wdm drivers, if this
' mode is not available then bass_3dalg_off will be used instead.
global const bass_3dalg_full = 2
' this algorithm gives a good 3d audio effect, and uses less cpu than the full
' mode. requires windows 98 2nd edition or windows 2000 that uses wdm drivers, if
' this mode is not available then bass_3dalg_off will be used instead.
global const bass_3dalg_light = 3

type bass_info
    size as long                'size of this struct (set this before calling the function)
    flags as long               'device capabilities (dscaps_xxx flags)
    ' the following values are irrelevant if the device doesn't have hardware
    ' support (dscaps_emuldriver is specified in flags)
    hwsize as long              'size of total device hardware memory
    hwfree as long              'size of free device hardware memory
    freesam as long             'number of free sample slots in the hardware
    free3d as long              'number of free 3d sample slots in the hardware
    minrate as long             'min sample rate supported by the hardware
    maxrate as long             'max sample rate supported by the hardware
    eax as integer              'device supports eax? (always bassfalse if bass_device_3d was not used)
    a3d as long                 'a3d version (0=unsupported or bass_device_a3d was not used)
    dsver as long               'directsound version (use to check for dx5/7 functions)
end type

'*************************
'* sample info structure *
'*************************
type bass_sample
    freq as long                'default playback rate
    volume as long              'default volume (0-100)
    pan as integer              'default pan (-100=left, 0=middle, 100=right)
    flags as long               'bass_sample_xxx flags
    length as long              'length (in samples, not bytes)
    max as long ' maximum simultaneous playbacks
    ' the following are the sample's default 3d attributes (if the sample
    ' is 3d, bass_sample_3d is in flags) see bass_channelset3dattributes
    mode3d as long              'bass_3dmode_xxx mode
    mindist as single           'minimum distance
    maxdist as single           'maximum distance
    iangle as long              'angle of inside projection cone
    oangle as long              'angle of outside projection cone
    outvol as long              'delta-volume outside the projection cone
    ' the following are the defaults used if the sample uses the directx 7
    ' voice allocation/management features.
    vam as long                 'voice allocation/management flags (bass_vam_xxx)
    priority as long            'priority (0=lowest, 0xffffffff=highest)
end type

'********************************************************
'* 3d vector (for 3d positions/velocities/orientations) *
'********************************************************
type bass_3dvector
    x as single                 '+=right, -=left
    y as single                 '+=up, -=down
    z as single                 '+=front, -=behind
end type

private declare sub copymemory lib "kernel32" alias "rtlmovememory" _
(byref destination as any, _
byref source as any, _
byval length as long)

private declare function lstrlen lib "kernel32" alias "lstrlena" _
(byval lpstring as long) as long

' retrieve the version number of bass that is loaded. return : the bass version (loword.hiword)
declare function bass_getversion lib "bass.dll" () as long

' gets a pointer to the text description of a device. this function can be used to enumerate the available devices.
' devnum: the device(0 = first)
' desc: pointer to store pointer to text description
' note: use bass_getdevicedestriptionstring to get the text description
declare function bass_getdevicedescription lib "bass.dll" (byval devnum as long, byref desc as long) as integer

' set the amount that bass mixes ahead new musics/streams.
' changing this setting does not affect musics/streams
' that have already been loaded/created. increasing the
' buffer length, decreases the chance of the sound
' possibly breaking-up on slower computers, but also
' requires more memory. the default length is 0.5 secs.
' length : the buffer length in seconds (limited to 0.3-2.0s)

' note: this setting does not represent the latency
' (delay between playing and hearing the sound). the
' latency depends on the drivers, the power of the cpu,
' and the complexity of what's being mixed (eg. an it
' using filters requires more processing than a plain
' 4 channel mod). so the buffer length actually has no
' effect on the latency.
declare sub bass_setbufferlength lib "bass.dll" (byval length as single)

' set the global music/sample/stream volume levels.
' musvol : mod music global volume level (0-100, -1=leave current)
' samvol : sample global volume level (0-100, -1=leave current)
' strvol : stream global volume level (0-100, -1=leave current)
declare sub bass_setglobalvolumes lib "bass.dll" (byval musvol as long, byval samvol as long, byval strvol as long)

' retrive the global music/sample/stream volume levels.
' musvol : mod music global volume level (null=don't retrieve it)
' samvol : sample global volume level (null=don't retrieve it)
' strvol : stream global volume level (null=don't retrieve it)
declare sub bass_getglobalvolumes lib "bass.dll" (byref musvol as long, byref samvol as long, byref strvol as long)

' make the volume/panning values translate to a logarithmic curve,
' or a linear "curve" (the default)
' volume :   volume curve(bassfalse = linear, basstrue = log)
' pan    : panning curve (bassfalse=linear, basstrue=log) */
declare sub bass_setlogcurves lib "bass.dll" (byval volume as integer, byval pan as integer)

' set the 3d algorithm for software mixed 3d channels (does not affect
' hardware mixed channels). changing the mode only affects subsequently
' created or loaded samples/streams/musics, not those that already exist.
' requires directx 7 or above.
' algo : algorithm flag (bass_3dalg_xxx)
declare sub bass_set3dalgorithm lib "bass.dll" (byval algo as long)

' get the bass_error_xxx error code. use this function to get the reason for an error.
declare function bass_errorgetcode lib "bass.dll" () as long

' initialize the digital output. this must be called
' before all following bass functions (except cd functions).
' the volume is initially set to 100 (the maximum),
' use bass_setvolume() to adjust it.
' device : device to use (0=first, -1=default, -2=no sound)
' freq   : output sample rate
' flags:     bass_device_xxx flags
' win:       owner window (0=current foreground window)

' note: the "no sound" device (device=-2), allows loading
' and "playing" of mod musics only (all sample/stream
' functions and most other functions fail). this is so
' that you can still use the mod musics as synchronizers
' when there is no soundcard present. when using device -2,
' you should still set the other arguments as you would do
' normally.
declare function bass_init lib "bass.dll" (byval device as integer, byval freq as long, byval flags as long, byval win as long) as integer

' free all resources used by the digital output, including  all musics and samples.
declare sub bass_free lib "bass.dll" ()

' retrieve a pointer to a directsound interface. this can be used by
' advanced users to "plugin" external functionality.
' object : the interface to retrieve (bass_object_xxx)
' return : a pointer to the requested interface (null=error)
declare function bass_getdsoundobject lib "bass.dll" (byval object as long) as long

' retrieve some information on the device being used.
' info   : pointer to store info at
declare sub bass_getinfo lib "bass.dll" (byref info as bass_info)

' get the current cpu usage of bass. this includes the time taken to mix
' the mod musics and sample streams, and also the time taken by any user
' dsp functions. it does not include plain sample mixing which is done by
' the output device (hardware accelerated) or directsound (emulated). audio
' cd playback requires no cpu usage.
' return : the cpu usage percentage (floating-point)
declare function bass_getcpu lib "bass.dll" () as single

' start the digital output.
declare function bass_start lib "bass.dll" () as integer

' stop the digital output, stopping all musics/samples/streams.
declare function bass_stop lib "bass.dll" () as integer

' stop the digital output, pausing all musics/samples/
' streams. use bass_start to resume the digital output.
declare function bass_pause lib "bass.dll" () as integer

' set the digital output master volume.
' volume : desired volume level (0-100)
declare function bass_setvolume lib "bass.dll" (byval volume as long) as integer

' get the digital output master volume.
' return : the volume level (0-100, -1=error)
declare function bass_getvolume lib "bass.dll" () as long

' set the factors that affect the calculations of 3d sound.
' distf  : distance factor (0.0-10.0, 1.0=use meters, 0.3=use feet, <0.0=leave current)
'          by default bass measures distances in meters, you can change this
'          setting if you are using a different unit of measurement.
' roolf  : rolloff factor, how fast the sound quietens with distance
'          (0.0=no rolloff, 1.0=real world, 2.0=2x real... 10.0=max, <0.0=leave current)
' doppf  : doppler factor (0.0=no doppler, 1.0=real world, 2.0=2x real... 10.0=max, <0.0=leave current)
'          the doppler effect is the way a sound appears to change frequency when it is
'          moving towards or away from you. the listener and sound velocity settings are
'          used to calculate this effect, this "doppf" value can be used to lessen or
'          exaggerate the effect.
declare function bass_set3dfactors lib "bass.dll" (byval distf as single, byval rollf as single, byval doppf as single) as integer

' get the factors that affect the calculations of 3d sound.
' distf  : distance factor (null=don't get it)
' roolf  : rolloff factor (null=don't get it)
' doppf  : doppler factor (null=don't get it)
declare function bass_get3dfactors lib "bass.dll" (byref distf as single, byref rollf as single, byref doppf as single) as integer

' set the position/velocity/orientation of the listener (ie. the player/viewer).
' pos    : position of the listener (null=leave current)
' vel    : listener 's velocity, used to calculate doppler effect (null=leave current)
' front  : direction that listener's front is pointing (null=leave current)
' top    : direction that listener's top is pointing (null=leave current)
' note   : front & top must both be set in a single call
declare function bass_set3dposition lib "bass.dll" (byref pos as any, byref vel as any, byref front as any, byref top as any) as integer


' get the position/velocity/orientation of the listener.
' pos    : position of the listener (null=don't get it)
' vel    : listener 's velocity (null=don't get it)
' front  : direction that listener's front is pointing (null=don't get it)
' top    : direction that listener's top is pointing (null=don't get it)
' note   : front & top must both be retrieved in a single call
declare function bass_get3dposition lib "bass.dll" (byref pos as any, byref vel as any, byref front as any, byref top as any) as integer

' apply changes made to the 3d system. this must be called to apply any changes
' made with bass_set3dfactors, bass_set3dposition, bass_channelset3dattributes or
' bass_channelset3dposition. it improves performance to have directsound do all the
' required recalculating at the same time like this, rather than recalculating after
' every little change is made. note: this is automatically called when starting a 3d
' sample with bass_sampleplay3d/ex.
declare function bass_apply3d lib "bass.dll" () as integer

' set the type of eax environment and it's parameters. obviously, eax functions
' have no effect if no eax supporting device (ie. sb live) is used.
' env    : reverb environment (eax_environment_xxx, -1=leave current)
' vol    : volume of the reverb (0.0=off, 1.0=max, <0.0=leave current)
' decay  : time in seconds it takes the reverb to diminish by 60db (0.1-20.0, <0.0=leave current)
' damp   : the damping, high or low frequencies decay faster (0.0=high decays quickest,
'          1.0=low/high decay equally, 2.0=low decays quickest, <0.0=leave current)
declare function bass_seteaxparameters lib "bass.dll" (byval env as long, byval vol as single, byval decay as single, byval damp as single) as integer

' get the current eax parameters.
' env    : reverb environment (null=don't get it)
' vol    : reverb volume (null=don't get it)
' decay  : decay duration (null=don't get it)
' damp   : the damping (null=don't get it)
declare function bass_geteaxparameters lib "bass.dll" (byref env as long, byref vol as single, byref decay as single, byref damp as single) as integer

' set the a3d resource management mode.
' mode   : the mode (a3d_resmode_off=disable resource management,
' a3d_resmode_dynamic = enable resource manager but looping channels are not managed,
' a3d_resmode_dynamic_loopers = enable resource manager including looping channels,
' a3d_resmode_notify = plays will fail when there are no available resources)
declare function bass_seta3dresmanager lib "bass.dll" (byval mode as long) as integer

' get the a3d resource management mode.
' return : the mode (0xffffffff=error)
declare function bass_geta3dresmanager lib "bass.dll" () as long

' set the a3d high frequency absorbtion factor.
' factor  : absorbtion factor (0.0=disabled, <1.0=diminished, 1.0=default,
'           >1.0=exaggerated)
declare function bass_seta3dhfabsorbtion lib "bass.dll" (byval factor as single) as integer

' retrieve the current a3d high frequency absorbtion factor.
' factor  : the absorbtion factor
declare function bass_geta3dhfabsorbtion lib "bass.dll" (byref factor as single) as integer

' load a music (mo3/xm/mod/s3m/it/mtm). the amplification and pan
' seperation are initially set to 50, use bass_musicsetamplify()
' and bass_musicsetpansep() to adjust them.
' mem    : basstrue = load music from memory
' f      : filename (mem=bassfalse) or memory location (mem=basstrue)
' offset : file offset to load the music from (only used if mem=bassfalse)
' length : data length (only used if mem=bassfalse, 0=use to end of file)
' flags  :     bass_music_xxx flags
' return : the loaded music's handle (null=error)
declare function bass_musicload lib "bass.dll" (byval mem as integer, byval f as any, byval offset as long, byval length as long, byval flags as long) as long

'  free a music's resources. handle =  music handle
declare sub bass_musicfree lib "bass.dll" (byval handle as long)

' retrieves a pointer to music's name.
' handle :  music handle
' return : pointer to the music 's name (null=error)
' note: use the function bass_musicgetnamestring to get the actual name as a string.
declare function bass_musicgetname lib "bass.dll" (byval handle as long) as long

' retrieves the length of a music in patterns (ie. how many "orders"
' there are).
' handle :  music handle
' return : the length of the music (0xffffffff=error)
declare function bass_musicgetlength lib "bass.dll" (byval handle as long) as long

' play a music. playback continues from where it was last stopped/paused.
' multiple musics may be played simultaneously.
' handle : handle of music to play
declare function bass_musicplay lib "bass.dll" (byval handle as long) as integer

' play a music, specifying start position and playback flags.
' handle : handle of music to play
' pos    : position to start playback from, loword=order hiword=row
' flags  : bass_music_xxx flags. these flags overwrite the defaults
'          specified when the music was loaded. (-1=use current flags)
' reset  : basstrue = stop all current playing notes and reset bpm/etc...
declare function bass_musicplayex lib "bass.dll" (byval handle as long, byval pos as long, byval flags as long, byval reset as integer) as integer

' set a music's amplification level.
' handle:    music handle
' amp:       amplification level(0 - 100)
declare function bass_musicsetamplify lib "bass.dll" (byval handle as long, amp as long) as integer

' set a music's pan seperation.
' handle:    music handle
' pan:       pan seperation(0 - 100, 50 = linear)
declare function bass_musicsetpansep lib "bass.dll" (byval handle as long, pan as long) as integer

' set a music's "getposition" scaler
' when you call bass_channelgetposition, the "row" (hiword) will be
' scaled by this value. by using a higher scaler, you can get a more
' precise position indication.
' handle:    music handle
' scale: the scaler(1 - 256)
declare function bass_musicsetpositionscaler lib "bass.dll" (byval handle as long, byval pscale as long) as integer

' load a wav/mp3/mp2/mp1 sample. if you're loading a sample with 3d
' functionality, then you should use bass_getinfo and bass_setinfo to set
' the default 3d parameters. you can also use these two functions to set
' the sample's default frequency/volume/pan/looping.
' mem    : basstrue = load sample from memory
' f      : filename (mem=bassfalse) or memory location (mem=basstrue)
' offset : file offset to load the sample from (only used if mem=bassfalse)
' length : data length (only used if mem=bassfalse, 0=use to end of file)
' max    : maximum number of simultaneous playbacks (1-65535)
' flags  : bass_sample_xxx flags (only the loop/3d/software/defer/mutemax/over_xxx flags are used)
' return : the loaded sample's handle (null=error)
declare function bass_sampleload lib "bass.dll" (byval mem as integer, byval f as any, byval offset as long, byval length as long, byval max as long, byval flags as long) as long

' create a sample. this function allows you to generate custom samples, or
' load samples that are not in the wav format. a pointer is returned to the
' memory location at which you should write the sample's data. after writing
' the data, call bass_samplecreatedone to get the new sample's handle.
' length:    the sample 's length (in samples, not bytes)
' freq   : default sample rate
' max    : maximum number of simultaneous playbacks (1-65535)
' flags:     bass_sample_xxx flags
' return : memory location to write the sample's data (null=error)
declare function bass_samplecreate lib "bass.dll" (byval length as long, byval freq as long, byval max as long, byval flags as long) as long

' finished creating a new sample.
' return: the new sample 's handle (null=error)
declare function bass_samplecreatedone lib "bass.dll" () as long

' free a sample's resources.
' handle:    sample handle
declare sub bass_samplefree lib "bass.dll" (byval handle as long)

' retrieve a sample's current default attributes.
' handle:    sample handle
' info   : pointer to store sample info
declare function bass_samplegetinfo lib "bass.dll" (byval handle as long, byref info as bass_sample) as integer

'set a sample's default attributes.
' handle:    sample handle
' info   : sample info, only the freq/volume/pan/3d attributes and
'          looping/override method flags are used
declare function bass_samplesetinfo lib "bass.dll" (byval handle as long, byref info as bass_sample) as integer

' play a sample, using the sample's default attributes.
' handle : handle of sample to play
' return : handle of channel used to play the sample (null=error)
declare function bass_sampleplay lib "bass.dll" (byval handle as long) as long

' play a sample, using specified attributes.
' handle : handle of sample to play
' start  : playback start position (in samples, not bytes)
' freq:      playback rate(-1 = default)
' volume : volume (-1=default, 0=silent, 100=max)
' pan:       pan position(-101 = default, -100 = left, 0 = middle, 100 = right)
' loop   : 1 = loop sample (-1=default)
' return : handle of channel used to play the sample (null=error)
declare function bass_sampleplayex lib "bass.dll" (byval handle as long, byval start as long, byval freq as long, byval volume as long, byval pan as long, byval ploop as integer) as long

' play a 3d sample, setting it's 3d position, orientation and velocity.
' handle : handle of sample to play
' pos    : position of the sound (null = x/y/z=0.0)
' orient : orientation of the sound, this is irrelevant if it's an
'          omnidirectional sound source (null = x/y/z=0.0)
' vel    : velocity of the sound (null = x/y/z=0.0)
' return : handle of channel used to play the sample (null=error)
declare function bass_sampleplay3d lib "bass.dll" (byval handle as long, byref pos as any, byref orient as any, byref vel as any) as long

' play a 3d sample, using specified attributes.
' handle : handle of sample to play
' pos    : position of the sound (null = x/y/z=0.0)
' orient : orientation of the sound, this is irrelevant if it's an
'          omnidirectional sound source (null = x/y/z=0.0)
' vel    : velocity of the sound (null = x/y/z=0.0)
' start  : playback start position (in samples, not bytes)
' freq:      playback rate(-1 = default)
' volume : volume (-1=default, 0=silent, 100=max)
' loop   : 1 = loop sample (-1=default)
' return : handle of channel used to play the sample (null=error)
declare function bass_sampleplay3dex lib "bass.dll" (byval handle as long, byref pos as any, byref orient as any, byref vel as any, byval start as long, byval freq as long, byval volume as long, byval ploop as integer) as long

' stops all instances of a sample. for example, if a sample is playing
' simultaneously 3 times, calling this function will stop all 3 of them,
' which is obviously simpler than calling bass_channelstop() 3 times.
' handle : handle of sample to stop
declare function bass_samplestop lib "bass.dll" (byval handle as long) as integer

' create a user sample stream.
' freq   : stream playback rate
' flags  : bass_sample_xxx flags (only the 8bits/mono/3d flags are used)
' proc   : user defined stream writing function pass using "addressof streamproc"
' user   : the 'user' value passed to the callback function
' return : the created stream's handle (null=error)
declare function bass_streamcreate lib "bass.dll" (byval freq as long, byval flags as long, byval proc as long, byval user as long) as long

' create a sample stream from an mp3/mp2/mp1 or wav file.
' mem    : basstrue = stream file from memory
' f      : filename (mem=bassfalse) or memory location (mem=basstrue)
' offset : file offset of the stream data
' length : file length (0=use whole file if mem=bassfalse)
' flags  : bass_sample_3d and/or bass_mp3_lowq flags
' return : the created stream's handle (null=error)
declare function bass_streamcreatefile lib "bass.dll" (byval mem as integer, byval f as any, byval offset as long, byval length as long, byval flags as long) as long

' create a sample stream from an mp3/mp2/mp1 or wav file on the internet.
' url    : the url (beginning with "http://")
' flags  : bass_sample_3d/bass_sample_mono/bass_mp3_halfrate/bass_stream_restrate flags
' save   : filename to save the streamed file as locally (null=don't save)
' return : the created stream's handle (null=error)
declare function bass_streamcreateurl lib "bass.dll" (byval url as string, byval flags as long, byval save as string) as long

' free a sample stream's resources.
' stream:    stream handle
declare sub bass_streamfree lib "bass.dll" (byval handle as long)

' retrieves the playback length (in bytes) of a file stream. it's not always
' possible to 100% accurately guess the length of a stream, so the length returned
' may be only an approximation when using some wav codecs.
' handle :  stream handle
' return : the length (0xffffffff=error)
declare function bass_streamgetlength lib "bass.dll" (byval handle as long) as long

' play a sample stream, optionally flushing the buffer first.
' handle : handle of stream to play
' flush  : flush buffer contents. if you stop a stream and then want to
'          continue it from where it stopped, don't flush it. flushing
'          a file stream causes it to restart from the beginning.
' flags  : bass_sample_xxx flags (only affects file streams, and only the
'          loop flag is used)
declare function bass_streamplay lib "bass.dll" (byval handle as long, byval flush as integer, byval flags as long) as integer

' retrieves the file position of the decoding, the download (if streaming from
' the internet), or the end (total length). obviously only works with file streams.
' handle : stream handle
' mode   : the position to retrieve (0=decoding, 1=download, 2=end)
' return : the position (0xffffffff=error) */
declare function bass_streamgetfileposition lib "bass.dll" (byval handle as long, byval mode as long) as long

' initialize the cd functions, must be called before any other cd
' functions. the volume is initially set to 100 (the maximum), use
' bass_channelsetattributes() to adjust it.
' drive  : the cd drive, for example: "d:" (null=use default drive)
declare function bass_cdinit lib "bass.dll" (byval drive as any) as integer

' free resources used by the cd
declare sub bass_cdfree lib "bass.dll" ()

' check if there is a cd in the drive.
' return : 1 if cd in drive, 0 if not.
declare function bass_cdindrive lib "bass.dll" () as long

' retrieves the number of tracks on the cd
' return : the number of tracks (0xffffffff=error)
declare function bass_cdgettracks lib "bass.dll" () as long

' play a cd track.
' track  : track number to play (1=first)
' loop   : basstrue = loop the track
' wait   : basstrue = don't return until playback has started
'          (some drives will always wait anyway)
declare function bass_cdplay lib "bass.dll" (byval track as long, byval ploop as integer, byval wait as integer) as integer

' retrieves the playback length (in milliseconds) of a cd track.
' track  : the cd track (1=first)
' return : the length (0xffffffff=error)
declare function bass_cdgettracklength lib "bass.dll" (byval track as long) as long

'*************************************************************************
'* a "channel" can be a playing sample (hchannel), a mod music (hmusic), *
'* a sample stream (hstream), or the cd (cdchannel). the following       *
'* functions can be used with one or more of these channel types.        *
'*************************************************************************

' check if a channel is active (playing) or stalled.
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
' return : 0=not playing, 1=playing, 2=stalled(internet)
declare function bass_channelisactive lib "bass.dll" (byval handle as long) as integer

' get some info about a channel.
' handle:    channel handle(hchannel / hmusic / hstream)
' return : bass_sample_xxx flags (0xffffffff=error)
declare function bass_channelgetflags lib "bass.dll" (byval handle as long) as long

' stop a channel.
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
declare function bass_channelstop lib "bass.dll" (byval handle as long) as integer

' pause a channel.
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
declare function bass_channelpause lib "bass.dll" (byval handle as long) as integer

' resume a paused channel.
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
declare function bass_channelresume lib "bass.dll" (byval handle as long) as integer

' update a channel's attributes. the actual setting may not be exactly
' as specified, depending on the accuracy of the device and drivers.
' note: only the volume can be adjusted for the cd "channel", but not all
' soundcards allow controlling of the cd volume level.
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
' freq   : playback rate (-1=leave current)
' volume : volume (-1=leave current, 0=silent, 100=max)
' pan    : pan position(-101 = current, -100 = left, 0 = middle, 100 = right)
'          panning has no effect on 3d channels
declare function bass_channelsetattributes lib "bass.dll" (byval handle as long, byval freq as long, byval volume as long, byval pan as long) as integer

' retrieve a channel's attributes. only the volume is available for
' the cd "channel" (if allowed by the soundcard/drivers).
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
' freq   : pointer to store playback rate (null=don't retrieve it)
' volume : pointer to store volume (null=don't retrieve it)
' pan    : pointer to store pan position (null=don't retrieve it)
declare function bass_channelgetattributes lib "bass.dll" (byval handle as long, byref freq as long, byref volume as long, byref pan as long) as integer

' set a channel's 3d attributes.
' handle : channel handle(hchannel / hstream / hmusic)
' mode   : bass_3dmode_xxx mode (-1=leave current setting)
' min    : minimum distance, volume stops increasing within this distance (<0.0=leave current)
' max    : maximum distance, volume stops decreasing past this distance (<0.0=leave current)
' iangle : angle of inside projection cone in degrees (360=omnidirectional, -1=leave current)
' oangle : angle of outside projection cone in degrees (-1=leave current)
'          note: iangle & oangle must both be set in a single call
' outvol : delta-volume outside the projection cone (0=silent, 100=same as inside)
' the iangle/oangle angles decide how wide the sound is projected around the
' orientation angle. within the inside angle the volume level is the channel
' level as set with bass_channelsetattributes, from the inside to the outside
' angles the volume gradually changes by the "outvol" setting.
declare function bass_channelset3dattributes lib "bass.dll" (byval handle as long, byval mode as long, byval min as single, byval max as single, byval iangle as long, byval oangle as long, byval outvol as long) as integer

' retrieve a channel's 3d attributes.
' handle : channel handle(hchannel / hstream / hmusic)
' mode   : bass_3dmode_xxx mode (null=don't retrieve it)
' min    : minumum distance (null=don't retrieve it)
' max    : maximum distance (null=don't retrieve it)
' iangle : angle of inside projection cone (null=don't retrieve it)
' oangle : angle of outside projection cone (null=don't retrieve it)
'          note: iangle & oangle must both be retrieved in a single call
' outvol : delta-volume outside the projection cone (null=don't retrieve it)
declare function bass_channelget3dattributes lib "bass.dll" (byval handle as long, byref mode as long, byref min as single, byref max as single, byref iangle as long, byref oangle as long, byref outvol as long) as integer

' update a channel's 3d position, orientation and velocity. the velocity
' is only used to calculate the doppler effect.
' handle : channel handle(hchannel / hstream / hmusic)
' pos    : position of the sound (null=leave current)
' orient : orientation of the sound, this is irrelevant if it's an
'          omnidirectional sound source (null=leave current)
' vel    : velocity of the sound (null=leave current)
declare function bass_channelset3dposition lib "bass.dll" (byval handle as long, byref pos as any, byref orient as any, byref vel as any) as integer

' retrieve a channel's current 3d position, orientation and velocity.
' handle : channel handle(hchannel / hstream / hmusic)
' pos    : position of the sound (null=don't retrieve it)
' orient : orientation of the sound, this is irrelevant if it's an
'          omnidirectional sound source (null=don't retrieve it)
' vel    : velocity of the sound (null=don't retrieve it)
declare function bass_channelget3dposition lib "bass.dll" (byval handle as long, byref pos as any, byref orient as any, byref vel as any) as integer

' set the current playback position of a channel.
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
' pos    : the position
'          if hchannel: position in bytes
'          if hmusic: loword=order hiword=row ... use makelong(order,row)
'          if hstream: position in bytes, file streams (wav/mp3) only (mp3s require bass_mp3_setpos)
'          if cdchannel: position in milliseconds from start of track
declare function bass_channelsetposition lib "bass.dll" (byval handle as long, byval pos as long) as integer

' get the current playback position of a channel.
' handle : channel handle (hchannel/hmusic/hstream, or cdchannel)
' return : the position (0xffffffff=error)
'          if hchannel: position in bytes
'          if hmusic: loword=order hiword=row (use getloword(position), gethiword(position))
'          if hstream: total bytes played since the stream was last flushed
'          if cdchannel: position in milliseconds from start of track
declare function bass_channelgetposition lib "bass.dll" (byval handle as long) as long

' calculate a channel's current output level.
' handle : channel handle(hmusic / hstream)
' return : loword=left level (0-128) hiword=right level (0-128) (0xffffffff=error)
'          use getloword and gethiword functions on return function.
declare function bass_channelgetlevel lib "bass.dll" (byval handle as long) as long

' retrieves upto "length" bytes of the channel's current sample data. this is
' useful if you wish to "visualize" the sound.
' handle:  channel handle(hmusic / hstream)
' buffer : location to write the sample data
' length : number of bytes wanted
' return : number of bytes actually written to the buffer (0xffffffff=error) */
declare function bass_channelgetdata lib "bass.dll" (byval handle as long, byref buffer as any, byval length as long) as long

' setup a sync on a channel. multiple syncs may be used per channel.
' handle : channel handle (currently there are only hmusic syncs)
' atype  : sync type (bass_sync_xxx type & flags)
' param  : sync parameters (see the bass_sync_xxx type description)
' proc   : user defined callback function (use addressof syncproc)
' user   : the 'user' value passed to the callback function
' return : sync handle(null = error)
declare function bass_channelsetsync lib "bass.dll" (byval handle as long, byval atype as long, byval param as long, byval proc as long, byval user as long) as long

' remove a sync from a channel
' handle : channel handle(hmusic)
' sync   : handle of sync to remove
declare function bass_channelremovesync lib "bass.dll" (byval handle as long, byval sync as long) as integer

' setup a user dsp function on a channel. when multiple dsp functions
' are used on a channel, they are called in the order that they were added.
' handle:  channel handle(hmusic / hstream)
' proc   : user defined callback function
' user   : the 'user' value passed to the callback function
' return : dsp handle (null=error)
declare function bass_channelsetdsp lib "bass.dll" (byval handle as long, byval proc as long, byval user as long) as long

' remove a dsp function from a channel
' handle : channel handle(hmusic / hstream)
' dsp    : handle of dsp to remove */
' return : basstrue / bassfalse
declare function bass_channelremovedsp lib "bass.dll" (byval handle as long, byval dsp as long) as integer

' set the wet(reverb)/dry(no reverb) mix ratio on the channel. by default
' the distance of the sound from the listener is used to calculate the mix.
' note: the channel must have 3d functionality enabled for the eax environment
' to have any affect on it.
' handle : channel handle(hchannel / hstream / hmusic)
' mix    : the ratio (0.0=reverb off, 1.0=max reverb, -1.0=let eax calculate
'          the reverb mix based on the distance)
declare function bass_channelseteaxmix lib "bass.dll" (byval handle as long, byval mix as single) as integer

' get the wet(reverb)/dry(no reverb) mix ratio on the channel.
' handle:    channel handle(hchannel / hstream / hmusic)
' mix    : pointer to store the ratio at
declare function bass_channelgeteaxmix lib "bass.dll" (byval handle as long, byref mix as single) as integer

' gets the text description of a device. this function can be used to enumerate the available devices.
' devnum: the device(0 = first)
' return: device description
' note: use bass_getdevicecount to get the number of available devices
function bass_getdevicedescriptionstring(byval devnum as long) as string
dim pstring as long
dim sstring as string
on error resume next
bass_getdevicedescription devnum, pstring
if pstring then
    sstring = vbstrfromansiptr(pstring)
end if
bass_getdevicedescriptionstring = sstring
end function

' gets the number of available devices.
' since the first device is 0, the last device is (bass_getdevicecount - 1)
function bass_getdevicecount() as integer
dim count as integer
dim pstring as long
on error resume next
do while bass_getdevicedescription(count, pstring)
    count = count + 1
loop
bass_getdevicecount = count
end function

'retrieves a music's name.
'handle :  music handle
'return:   music's name
public function bass_musicgetnamestring(byval handle as long) as string
dim pstring as long
dim sstring as string
on error resume next
pstring = bass_musicgetname(handle)
if pstring then
    sstring = vbstrfromansiptr(pstring)
end if
bass_musicgetnamestring = sstring
end function


function streamproc(byval handle as long, byref buffer as long, byval length as long, byval user as long) as long
    
    'callback function !!!
    
    'in here you can write a function to write out to a file, or send over the
    'internet etc, and stream into a bass buffer on the client, its up to you.
    'this function must return the number of bytes written out, so that bass,
    'knows where to carry on sending from.

    ' note: a stream function should obviously be as quick
    ' as possible, other streams (and mod musics) can't be mixed until it's finished.
    ' handle : the stream that needs writing
    ' buffer : buffer to write the samples in
    ' length : number of bytes to write
    ' user   : the 'user' parameter value given when calling bass_streamcreate
    ' return : number of bytes written. if less than "length" then the
    '          stream is assumed to be at the end, and is stopped.
    
end function

sub syncproc(byval handle as long, byval channel as long, byval data as long, byval user as long)
    
    'callback function !!!
    
    'similarly in here, write what to do when sync function
    'is called, i.e screen flash etc.
    
    ' note: a sync callback function should be very
    ' quick (eg. just posting a message) as other syncs cannot be processed
    ' until it has finished.
    ' handle : the sync that has occured
    ' channel: channel that the sync occured in
    ' data   : additional data associated with the sync's occurance
    ' user   : the 'user' parameter given when calling bass_channelsetsync */
    
end sub

sub dspproc(byval handle as long, byval channel as long, byref buffer as long, byval length as long, byval user as long)

    'callback function !!!

    ' dsp callback function. note: a dsp function should obviously be as quick as
    ' possible... other dsp functions, streams and mod musics can not be processed
    ' until it's finished.
    ' handle : the dsp handle
    ' channel: channel that the dsp is being applied to
    ' buffer : buffer to apply the dsp to
    ' length : number of bytes in the buffer
    ' user   : the 'user' parameter given when calling bass_channelsetdsp
    
end sub

function bass_seteaxparametersvb(preset) as integer
' this function is a workaround, because vb doesn't support multiple comma seperated
' paramaters for each global const, simply pass the eax_preset_xxxx value to this function
' instead of bass_seteasparamaets as you would to in c++
select case preset
    case eax_preset_generic
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_generic, 0.5, 1.493, 0.5)
    case eax_preset_paddedcell
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_paddedcell, 0.25, 0.1, 0)
    case eax_preset_room
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_room, 0.417, 0.4, 0.666)
    case eax_preset_bathroom
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_bathroom, 0.653, 1.499, 0.166)
    case eax_preset_livingroom
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_livingroom, 0.208, 0.478, 0)
    case eax_preset_stoneroom
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_stoneroom, 0.5, 2.309, 0.888)
    case eax_preset_auditorium
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_auditorium, 0.403, 4.279, 0.5)
    case eax_preset_concerthall
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_concerthall, 0.5, 3.961, 0.5)
    case eax_preset_cave
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_cave, 0.5, 2.886, 1.304)
    case eax_preset_arena
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_arena, 0.361, 7.284, 0.332)
    case eax_preset_hangar
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_hangar, 0.5, 10, 0.3)
    case eax_preset_carpetedhallway
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_carpetedhallway, 0.153, 0.259, 2)
    case eax_preset_hallway
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_hallway, 0.361, 1.493, 0)
    case eax_preset_stonecorridor
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_stonecorridor, 0.444, 2.697, 0.638)
    case eax_preset_alley
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_alley, 0.25, 1.752, 0.776)
    case eax_preset_forest
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_forest, 0.111, 3.145, 0.472)
    case eax_preset_city
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_city, 0.111, 2.767, 0.224)
    case eax_preset_mountains
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_mountains, 0.194, 7.841, 0.472)
    case eax_preset_quarry
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_quarry, 1, 1.499, 0.5)
    case eax_preset_plain
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_plain, 0.097, 2.767, 0.224)
    case eax_preset_parkinglot
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_parkinglot, 0.208, 1.652, 1.5)
    case eax_preset_sewerpipe
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_sewerpipe, 0.652, 2.886, 0.25)
    case eax_preset_underwater
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_underwater, 1, 1.499, 0)
    case eax_preset_drugged
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_drugged, 0.875, 8.392, 1.388)
    case eax_preset_dizzy
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_dizzy, 0.139, 17.234, 0.666)
    case eax_preset_psychotic
        bass_seteaxparametersvb = bass_seteaxparameters(eax_environment_psychotic, 0.486, 7.563, 0.806)
end select
end function

function bass_getstringversion() as string
'this function will return the string version
'of the bass dll. for example the provided function within the dll
'"bass_getversion" will return 393216, whereas this function works
'out the actual version string as you would need to see it.
bass_getstringversion = trim(str(getloword(bass_getversion))) & "." & trim(str(gethiword(bass_getversion)))
end function

public function gethiword(lparam as long) as long
' this is the hiword of the lparam:
gethiword = lparam \ &h10000 and &hffff&
end function
public function getloword(lparam as long) as long
' this is the loword of the lparam:
getloword = lparam and &hffff&
end function

public function bass_geterrordescription(errorcode as long) as string
select case errorcode
    case bass_ok
        bass_geterrordescription = "all is ok"
    case bass_error_mem
        bass_geterrordescription = "memory error"
    case bass_error_fileopen
        bass_geterrordescription = "can't open the file"
    case bass_error_driver
        bass_geterrordescription = "can't find a free sound driver"
    case bass_error_buflost
        bass_geterrordescription = "the sample buffer was lost - please report this!"
    case bass_error_handle
        bass_geterrordescription = "invalid handle"
    case bass_error_format
        bass_geterrordescription = "unsupported format"
    case bass_error_position
        bass_geterrordescription = "invalid playback position"
    case bass_error_init
        bass_geterrordescription = "bass_init has not been successfully called"
    case bass_error_start
        bass_geterrordescription = "bass_start has not been successfully called"
    case bass_error_initcd
        bass_geterrordescription = "can't initialize cd"
    case bass_error_cdinit
        bass_geterrordescription = "bass_cdinit has not been successfully called"
    case bass_error_nocd
        bass_geterrordescription = "no cd in drive"
    case bass_error_cdtrack
        bass_geterrordescription = "can't play the selected cd track"
    case bass_error_already
        bass_geterrordescription = "already initialized"
    case bass_error_cdvol
        bass_geterrordescription = "cd has no volume control"
    case bass_error_nopause
        bass_geterrordescription = "not paused"
    case bass_error_notaudio
        bass_geterrordescription = "not an audio track"
    case bass_error_nochan
        bass_geterrordescription = "can't get a free channel"
    case bass_error_illtype
        bass_geterrordescription = "an illegal type was specified"
    case bass_error_illparam
        bass_geterrordescription = "an illegal parameter was specified"
    case bass_error_no3d
        bass_geterrordescription = "no 3d support"
    case bass_error_noeax
        bass_geterrordescription = "no eax support"
    case bass_error_device
        bass_geterrordescription = "illegal device number"
    case bass_error_noplay
        bass_geterrordescription = "not playing"
    case bass_error_freq
        bass_geterrordescription = "illegal sample rate"
    case bass_error_noa3d
        bass_geterrordescription = "a3d.dll is not installed"
    case bass_error_notfile
        bass_geterrordescription = "the stream is not a file stream (wav/mp3)"
    case bass_error_nohw
        bass_geterrordescription = "no hardware voices available"
    case bass_error_unknown
        bass_geterrordescription = "some other mystery error"
end select
end function

function makelong(loword as long, hiword as long) as long
'replacement for the c++ function makelong
'you need this to pass values to certain function calls.
'i.e bass_channelsetposition needs to pass a value
'using make long, i.e bass_channelsetposition handle,makelong(order,row)
makelong = loword or lshift(hiword, 16)
end function

public function lshift(byval lvalue as long, byval lnumberofbitstoshift as long) as long
    const kscallname as string = "lshift"
    on error goto procedure_error
    lshift = lvalue * (2 ^ lnumberofbitstoshift)
    
procedure_exit:
    exit function
    
procedure_error:
    err.raise err.number, kscallname, err.description, err.helpfile, err.helpcontext
    resume procedure_exit
end function

public function rshift(byval lvalue as long, byval lnumberofbitstoshift as long) as long

    const kscallname as string = "rshift"
    on error goto procedure_error
    rshift = lvalue \ (2 ^ lnumberofbitstoshift)
    
procedure_exit:
    exit function
    
procedure_error:
    err.raise err.number, kscallname, err.description, err.helpfile, err.helpcontext
    resume procedure_exit
end function

public function vbstrfromansiptr(byval lpstr as long) as string
dim bstr() as byte
dim cchars as long
on error resume next
' get the number of characters in the buffer
cchars = lstrlen(lpstr)

' resize the byte array
redim bstr(0 to cchars) as byte

' grab the ansi buffer
call copymemory(bstr(0), byval lpstr, cchars)

' now convert to a vb unicode string
vbstrfromansiptr = strconv(bstr, vbunicode)
end function

