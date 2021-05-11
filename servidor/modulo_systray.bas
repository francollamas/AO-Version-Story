attribute vb_name = "systray"
'argentum online 0.11.6
'copyright (c) 2002 m�rquez pablo ignacio
'
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
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'                       systray
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'para minimizar a la barra de tareas
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�
'?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�

type cwpstruct
    lparam as long
    wparam as long
    message as long
    hwnd as long
end type

declare function callnexthookex lib "user32" (byval hhook as long, byval ncode as long, byval wparam as long, lparam as any) as long
declare sub copymemory lib "kernel32" alias "rtlmovememory" (hpvdest as any, hpvsource as any, byval cbcopy as long)
declare function setforegroundwindow lib "user32" (byval hwnd as long) as long
declare function setwindowshookex lib "user32" alias "setwindowshookexa" (byval idhook as long, byval lpfn as long, byval hmod as long, byval dwthreadid as long) as long
declare function unhookwindowshookex lib "user32" (byval hhook as long) as long

public const wh_callwndproc = 4
public const wm_create = &h1

public hhook as long

public function apphook(byval idhook as long, byval wparam as long, byval lparam as long) as long
    dim cwp as cwpstruct
    copymemory cwp, byval lparam, len(cwp)
    select case cwp.message
        case wm_create
            setforegroundwindow cwp.hwnd
            apphook = callnexthookex(hhook, idhook, wparam, byval lparam)
            unhookwindowshookex hhook
            hhook = 0
            exit function
    end select
    apphook = callnexthookex(hhook, idhook, wparam, byval lparam)
end function

