attribute vb_name = "api"
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

    public declare function findwindow lib "user32" alias "findwindowa" (byval lpclassname as string, byval lpwindowname as string) as long
    
    public const wm_settext = &hc
    public const wm_gettext = &hd
    public const wm_gettextlength = &he
    public const em_setreadonly = &hcf
    

public declare function enumdisplaysettings lib "user32" alias "enumdisplaysettingsa" (byval lpszdevicename as long, byval imodenum as long, lptypdevmode as any) as boolean
public declare function changedisplaysettings lib "user32" alias "changedisplaysettingsa" (lptypdevmode as any, byval dwflags as long) as long

'[matux] : 24 de marzo del 2002
    declare function setwindowpos& lib "user32" (byval hwnd as long, byval hwndinsertafter as long, byval x as long, byval y as long, byval cx as long, byval cy as long, byval wflags as long)
'[end]


public const ccdevicename = 32
public const ccformname = 32
public const dm_bitsperpel = &h40000
public const dm_pelswidth = &h80000
public const dm_pelsheight = &h100000
public const cds_updateregistry = &h1
public const cds_test = &h4
public const disp_change_successful = 0
public const disp_change_restart = 1

type typdevmode
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
