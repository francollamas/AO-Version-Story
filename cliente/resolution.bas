attribute vb_name = "resolution"
'**************************************************************
' resolution.bas - performs resolution changes.
'
' designed and implemented by juan mart�n sotuyo dodero (maraxus)
' (juansotuyo@gmail.com)
'**************************************************************

'**************************************************************************
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
'**************************************************************************

''
'handles all incoming / outgoing packets for client - server communications
'the binary prtocol here used was designed by juan mart�n sotuyo dodero.
'this is the first time it's used in alkon, though the second time it's coded.
'this implementation has several enhacements from the first design.
'
' @file     resolution.bas
' @author   juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version  1.1.0
' @date     20080329

'**************************************************************************
' - history
'       v1.0.0  -   initial release ( 2007/08/14 - juan mart�n sotuyo dodero )
'       v1.1.0  -   made it reset original depth and frequency at exit ( 2008/03/29 - juan mart�n sotuyo dodero )
'**************************************************************************

option explicit

private const ccdevicename as long = 32
private const ccformname as long = 32
private const dm_bitsperpel as long = &h40000
private const dm_pelswidth as long = &h80000
private const dm_pelsheight as long = &h100000
private const dm_displayfrequency as long = &h400000
private const cds_test as long = &h4
private const enum_current_settings as long = -1

private type typdevmode
    dmdevicename       as string * ccdevicename
    dmspecversion      as integer
    dmdriverversion    as integer
    dmsize             as integer
    dmdriverextra      as integer
    dmfields           as long
    dmorientation      as integer
    dmpapersize        as integer
    dmpaperlength      as integer
    dmpaperwidth       as integer
    dmscale            as integer
    dmcopies           as integer
    dmdefaultsource    as integer
    dmprintquality     as integer
    dmcolor            as integer
    dmduplex           as integer
    dmyresolution      as integer
    dmttoption         as integer
    dmcollate          as integer
    dmformname         as string * ccformname
    dmunusedpadding    as integer
    dmbitsperpel       as integer
    dmpelswidth        as long
    dmpelsheight       as long
    dmdisplayflags     as long
    dmdisplayfrequency as long
end type

private oldresheight as long
private oldreswidth as long
private olddepth as integer
private oldfrequency as long
private bnoreschange as boolean


private declare function enumdisplaysettings lib "user32" alias "enumdisplaysettingsa" (byval lpszdevicename as long, byval imodenum as long, lptypdevmode as any) as boolean
private declare function changedisplaysettings lib "user32" alias "changedisplaysettingsa" (lptypdevmode as any, byval dwflags as long) as long


'todo : change this to not depend on any external public variable using args instead!

public sub setresolution()
'***************************************************
'autor: unknown
'last modification: 03/29/08
'changes the display resolution if needed.
'last modified by: juan mart�n sotuyo dodero (maraxus)
' 03/29/2008: maraxus - retrieves current settings storing display depth and frequency for proper restoration.
'***************************************************
    dim lres as long
    dim midevm as typdevmode
    dim cambiarresolucion as boolean
    
    lres = enumdisplaysettings(0, enum_current_settings, midevm)
    
    oldreswidth = screen.width \ screen.twipsperpixelx
    oldresheight = screen.height \ screen.twipsperpixely
    
    if nores then
        cambiarresolucion = (oldreswidth < 800 or oldresheight < 600)
    else
        cambiarresolucion = (oldreswidth <> 800 or oldresheight <> 600)
    end if
    
    if cambiarresolucion then
        
        with midevm
            olddepth = .dmbitsperpel
            oldfrequency = .dmdisplayfrequency
            
            .dmfields = dm_pelswidth or dm_pelsheight or dm_bitsperpel
            .dmpelswidth = 800
            .dmpelsheight = 600
            .dmbitsperpel = 16
        end with
        
        lres = changedisplaysettings(midevm, cds_test)
    else
        bnoreschange = true
    end if
end sub

public sub resetresolution()
'***************************************************
'autor: unknown
'last modification: 03/29/08
'changes the display resolution if needed.
'last modified by: juan mart�n sotuyo dodero (maraxus)
' 03/29/2008: maraxus - properly restores display depth and frequency.
'***************************************************
    dim typdevm as typdevmode
    dim lres as long
    
    if not bnoreschange then
    
        lres = enumdisplaysettings(0, enum_current_settings, typdevm)
        
        with typdevm
            .dmfields = dm_pelswidth or dm_pelsheight or dm_bitsperpel or dm_displayfrequency
            .dmpelswidth = oldreswidth
            .dmpelsheight = oldresheight
            .dmbitsperpel = olddepth
            .dmdisplayfrequency = oldfrequency
        end with
        
        lres = changedisplaysettings(typdevm, cds_test)
    end if
end sub
