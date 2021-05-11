attribute vb_name = "modconsole"
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
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

private type nmhdr
    hwndfrom as long
    idfrom as long
    code as long
end type

private type charrange
    cpmin as long
    cpmax as long
end type

private type enlink
    hdr as nmhdr
    msg as long
    wparam as long
    lparam as long
    chrg as charrange
end type

private type textrange
    chrg as charrange
    lpstrtext as string
end type

private declare function setwindowlong lib "user32" alias "setwindowlonga" _
    (byval hwnd as long, byval nindex as long, byval dwnewlong as long) as long
private declare function callwindowproc lib "user32" alias "callwindowproca" _
    (byval lpprevwndfunc as long, byval hwnd as long, byval msg as long, _
    byval wparam as long, byval lparam as long) as long
private declare function sendmessage lib "user32" alias "sendmessagea" _
    (byval hwnd as long, byval wmsg as long, byval wparam as long, lparam as any) as long
private declare sub copymemory lib "kernel32" alias "rtlmovememory" _
    (destination as any, source as any, byval length as long)
private declare function shellexecute lib "shell32" alias "shellexecutea" _
    (byval hwnd as long, byval lpoperation as string, byval lpfile as string, _
    byval lpparameters as string, byval lpdirectory as string, byval nshowcmd as long) as long

private const wm_notify = &h4e
private const em_seteventmask = &h445
private const em_geteventmask = &h43b
private const em_gettextrange = &h44b
private const em_autourldetect = &h45b
private const en_link = &h70b
private const wm_lbuttondown = &h201

private const enm_link = &h4000000
private const gwl_wndproc = (-4)
private const sw_show = 5

private loldproc as long
private hwndrtb as long
private hwndparent as long

public sub enableurldetect(byval hwndrichtextbox as long, byval hwndowner as long)
'***************************************************
'author: zama
'last modification: 18/11/2010
'enables url detection in richtexbox.
'***************************************************
    sendmessage hwndrichtextbox, em_seteventmask, 0, byval enm_link or sendmessage(hwndrichtextbox, em_geteventmask, 0, 0)
    sendmessage hwndrichtextbox, em_autourldetect, 1, byval 0
    
    hwndparent = hwndowner
    hwndrtb = hwndrichtextbox
end sub

public sub disableurldetect()
'***************************************************
'author: zama
'last modification: 18/11/2010
'disables url detection in richtexbox.
'***************************************************
    sendmessage hwndrtb, em_autourldetect, 0, byval 0
    stopcheckinglinks
end sub

public sub startcheckinglinks()
'***************************************************
'author: zama
'last modification: 18/11/2010
'starts checking links (in console range)
'***************************************************
    if loldproc = 0 then
        loldproc = setwindowlong(hwndparent, gwl_wndproc, addressof wndproc)
    end if
end sub

public sub stopcheckinglinks()
'***************************************************
'author: zama
'last modification: 18/11/2010
'stops checking links (out of console range)
'***************************************************
    if loldproc then
        setwindowlong hwndparent, gwl_wndproc, loldproc
        loldproc = 0
    end if
end sub

public function wndproc(byval hwnd as long, byval umsg as long, byval wparam as long, byval lparam as long) as long
'***************************************************
'author: zama
'last modification: 18/11/2010
'get "click" event on link and open browser.
'***************************************************
    dim uhead as nmhdr
    dim elink as enlink
    dim etext as textrange
    dim stext as string
    dim llen as long
    
    if umsg = wm_notify then
        copymemory uhead, byval lparam, len(uhead)
        if (uhead.hwndfrom = hwndrtb) and (uhead.code = en_link) then
            copymemory elink, byval lparam, len(elink)
            
            select case elink.msg
                case wm_lbuttondown
                    etext.chrg.cpmin = elink.chrg.cpmin
                    etext.chrg.cpmax = elink.chrg.cpmax
                    etext.lpstrtext = space$(1024)
                    
                    llen = sendmessage(hwndrtb, em_gettextrange, 0, etext)
                    
                    stext = left$(etext.lpstrtext, llen)
                    shellexecute hwndparent, vbnullstring, stext, vbnullstring, vbnullstring, sw_show
            end select
        end if
    end if
    
    wndproc = callwindowproc(loldproc, hwnd, umsg, wparam, lparam)
end function

