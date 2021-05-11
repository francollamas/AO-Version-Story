version 5.00
object = "{831fdd16-0c5c-11d2-a9fc-0000f8754da1}#2.0#0"; "mscomctl.ocx"
begin vb.form frmbinder 
   borderstyle     =   1  'fixed single
   caption         =   "configuraci�n de macros"
   clientheight    =   7110
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   6105
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   icon            =   "frmbinder.frx":0000
   keypreview      =   -1  'true
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   7110
   scalewidth      =   6105
   startupposition =   1  'centerowner
   begin vb.commandbutton cmdrestore 
      caption         =   "restaurar configuraci�n original"
      height          =   495
      left            =   60
      mouseicon       =   "frmbinder.frx":000c
      mousepointer    =   99  'custom
      style           =   1  'graphical
      tabindex        =   9
      top             =   6540
      width           =   1755
   end
   begin vb.frame frame1 
      caption         =   "macros definidos"
      height          =   4275
      left            =   60
      tabindex        =   3
      top             =   2160
      width           =   5955
      begin vb.commandbutton cmdadd 
         height          =   375
         left            =   4320
         maskcolor       =   &h00000000&
         mouseicon       =   "frmbinder.frx":015e
         mousepointer    =   99  'custom
         picture         =   "frmbinder.frx":02b0
         style           =   1  'graphical
         tabindex        =   7
         tooltiptext     =   "agregar macro (insert)"
         top             =   3780
         usemaskcolor    =   -1  'true
         width           =   435
      end
      begin vb.commandbutton cmdedit 
         causesvalidation=   0   'false
         height          =   375
         left            =   4740
         maskcolor       =   &h00000000&
         mouseicon       =   "frmbinder.frx":0884
         mousepointer    =   99  'custom
         picture         =   "frmbinder.frx":09d6
         style           =   1  'graphical
         tabindex        =   6
         tooltiptext     =   "editar macro"
         top             =   3780
         usemaskcolor    =   -1  'true
         width           =   435
      end
      begin vb.commandbutton cmdremove 
         height          =   375
         left            =   5160
         maskcolor       =   &h00000000&
         mouseicon       =   "frmbinder.frx":0bda
         mousepointer    =   99  'custom
         picture         =   "frmbinder.frx":0d2c
         style           =   1  'graphical
         tabindex        =   5
         tooltiptext     =   "eliminar macro (del/supr)"
         top             =   3780
         usemaskcolor    =   -1  'true
         width           =   435
      end
      begin mscomctllib.listview lvwmacros 
         height          =   3975
         left            =   60
         tabindex        =   4
         top             =   240
         width           =   5835
         _extentx        =   10292
         _extenty        =   7011
         view            =   3
         labeledit       =   1
         sorted          =   -1  'true
         multiselect     =   -1  'true
         labelwrap       =   -1  'true
         hideselection   =   0   'false
         fullrowselect   =   -1  'true
         gridlines       =   -1  'true
         hottracking     =   -1  'true
         hoverselection  =   -1  'true
         _version        =   393217
         forecolor       =   -2147483640
         backcolor       =   -2147483643
         borderstyle     =   1
         appearance      =   1
         mouseicon       =   "frmbinder.frx":1300
         numitems        =   2
         beginproperty columnheader(1) {bdd1f052-858b-11d1-b16a-00c0f0283628} 
            text            =   "tecla(s)"
            object.width           =   2540
         endproperty
         beginproperty columnheader(2) {bdd1f052-858b-11d1-b16a-00c0f0283628} 
            subitemindex    =   1
            text            =   "comando"
            object.width           =   7056
         endproperty
      end
   end
   begin vb.commandbutton cmdsave 
      caption         =   "&guardar"
      height          =   315
      left            =   3540
      mouseicon       =   "frmbinder.frx":1462
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   6540
      width           =   975
   end
   begin vb.commandbutton cmdsaveclose 
      caption         =   "g&uardar y cerrar"
      height          =   315
      left            =   4560
      mouseicon       =   "frmbinder.frx":15b4
      mousepointer    =   99  'custom
      tabindex        =   1
      top             =   6540
      width           =   1455
   end
   begin vb.commandbutton cmdclose 
      cancel          =   -1  'true
      caption         =   "&cerrar"
      height          =   315
      left            =   2520
      mouseicon       =   "frmbinder.frx":1706
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   6540
      width           =   975
   end
   begin vb.line line2 
      x1              =   1920
      x2              =   1920
      y1              =   6480
      y2              =   7080
   end
   begin vb.line line1 
      x1              =   60
      x2              =   6000
      y1              =   1440
      y2              =   1440
   end
   begin vb.label label3 
      caption         =   "lee con atenci�n:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   195
      left            =   60
      tabindex        =   11
      top             =   60
      width           =   2295
   end
   begin vb.label label2 
      alignment       =   2  'center
      caption         =   $"frmbinder.frx":1858
      height          =   1035
      left            =   60
      tabindex        =   10
      top             =   300
      width           =   5955
   end
   begin vb.label label1 
      alignment       =   2  'center
      caption         =   "utiliza los botones que se encuentran en la parte inferior del cuadro para agregar, editar y eliminar macros"
      height          =   555
      left            =   120
      tabindex        =   8
      top             =   1620
      width           =   5835
   end
end
attribute vb_name = "frmbinder"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.9.83
'copyright (c) 2001 m�rquez pablo ignacio
'
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
'argentum online is based in baronsoft's vb6 online rpg
'engine 9/08/2000 http://www.baronsoft.com/
'aaron@baronsoft.com
'
'contact info:
'pablo ignacio m�rquez
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'calle 3 n�mero 983 piso 7 dto a
'la plata - pcia, buenos aires - republica argentina
'c�digo postal 1900


option explicit

public bchangesmade as boolean

private sub cmdadd_click()
    call frmbinderedit.show(vbmodal, frmbinder)
end sub

private sub cmdclose_click()
    dim ival as integer
    if bchangesmade then
        ival = msgbox("se han hecho cambios a los macros, �desea guardarlos?", vbapplicationmodal + vbexclamation + vbyesno, "cerrar sin guardar")
        if ival = vbyes then
            call cmdsaveclose_click
        else
            call unload(me)
        end if
    end if
        
    call unload(me)
    frmmain.setfocus
end sub

private sub cmdedit_click()
    call load(frmbinderedit)
    dim lx as long, sletra as string, sshift as string, saction as string
    dim sbind as string: sbind = lvwmacros.selecteditem.text
    
    if len(sbind) > 1 then
        for lx = 1 to len(sbind)
            sletra = mid(sbind, lx, 1)
            if sletra = "+" then
                sshift = left(sbind, lx - 1)
                exit for
            end if
        next lx
        saction = right(sbind, 1)
    else
        saction = sbind
    end if
    
    with frmbinderedit
        .lshift = getindexfromcombostr(.cmbshift, sshift)
        .lkey = getindexfromcombostr(.cmbkey, saction)
        if left(lvwmacros.selecteditem.subitems(1), 1) = "/" then
            .scommand = lvwmacros.selecteditem.subitems(1)
            .optaction(0).value = true
        elseif left(lvwmacros.selecteditem.subitems(1), 1) = "-" then
            .scommcomp = lvwmacros.selecteditem.subitems(1)
            .optaction(2).value = true
        else
            .lfunc = getindexfromcombostr(.cmbfunc, lvwmacros.selecteditem.subitems(1), true)
            .optaction(1).value = true
        end if
    end with

    frmbinderedit.initvalues (true)
    call frmbinderedit.show(vbmodal, frmbinder)
end sub

private sub cmdremove_click()
    dim ix as integer: ix = 1
    
    do until ix = lvwmacros.listitems.count + 1
        if lvwmacros.listitems(ix).selected = true then
            call lvwmacros.listitems.remove(ix)
        else
            ix = ix + 1
        end if
    loop
    
    bchangesmade = true
end sub

private sub cmdrestore_click()
    lvwmacros.listitems.clear
    
    ' funciones predefinidas
    lvwmacros.listitems.add , "ca", "c": lvwmacros.listitems("ca").subitems(1) = "+modocombate"
    lvwmacros.listitems.add , "sa", "s": lvwmacros.listitems("sa").subitems(1) = "+seguro"
    lvwmacros.listitems.add , "ma", "m": lvwmacros.listitems("ma").subitems(1) = "+musica"
    lvwmacros.listitems.add , "oa", "o": lvwmacros.listitems("oa").subitems(1) = "+ocultarse"
    lvwmacros.listitems.add , "ra", "r": lvwmacros.listitems("ra").subitems(1) = "+robar"
    lvwmacros.listitems.add , "aa", "a": lvwmacros.listitems("aa").subitems(1) = "+agarrar"
    lvwmacros.listitems.add , "ea", "e": lvwmacros.listitems("ea").subitems(1) = "+equipar"
    lvwmacros.listitems.add , "na", "n": lvwmacros.listitems("na").subitems(1) = "+nombres"
    lvwmacros.listitems.add , "da", "d": lvwmacros.listitems("da").subitems(1) = "+domar"
    lvwmacros.listitems.add , "ta", "t": lvwmacros.listitems("ta").subitems(1) = "+tirar"
    lvwmacros.listitems.add , "ua", "u": lvwmacros.listitems("ua").subitems(1) = "+usar"
    
    ' comandos
    lvwmacros.listitems.add , "ctrl+ca", "ctrl+c": lvwmacros.listitems("ctrl+ca").subitems(1) = "/comerciar"
    lvwmacros.listitems.add , "ctrl+xa", "ctrl+x": lvwmacros.listitems("ctrl+xa").subitems(1) = "/salir"
    lvwmacros.listitems.add , "ctrl+ma", "ctrl+m": lvwmacros.listitems("ctrl+ma").subitems(1) = "/meditar"
    lvwmacros.listitems.add , "ctrl+da", "ctrl+d": lvwmacros.listitems("ctrl+da").subitems(1) = "/descansar"
    lvwmacros.listitems.add , "ctrl+ea", "ctrl+e": lvwmacros.listitems("ctrl+ea").subitems(1) = "/enlistar"
    lvwmacros.listitems.add , "ctrl+ia", "ctrl+i": lvwmacros.listitems("ctrl+ia").subitems(1) = "/informacion"
    lvwmacros.listitems.add , "ctrl+ra", "ctrl+r": lvwmacros.listitems("ctrl+ra").subitems(1) = "/recompensa"
    lvwmacros.listitems.add , "ctrl+ga", "ctrl+g": lvwmacros.listitems("ctrl+ga").subitems(1) = "/gm ayuda"
    
    ' comandos compuestos
    lvwmacros.listitems.add , "shift+ba", "shift+b": lvwmacros.listitems("shift+ba").subitems(1) = "-bug "
    lvwmacros.listitems.add , "shift+da", "shift+d": lvwmacros.listitems("shift+da").subitems(1) = "-desc "
    lvwmacros.listitems.add , "shift+pa", "shift+p": lvwmacros.listitems("shift+pa").subitems(1) = "-passwd "
    lvwmacros.listitems.add , "shift+ra", "shift+r": lvwmacros.listitems("shift+ra").subitems(1) = "-retirar "
    lvwmacros.listitems.add , "shift+ea", "shift+e": lvwmacros.listitems("shift+ea").subitems(1) = "-depositar "
    
end sub

private sub cmdsave_click()
    call savebinds
end sub

private sub cmdsaveclose_click()
    call savebinds
    call unload(me)
    frmmain.setfocus
end sub

private sub form_keyup(keycode as integer, shift as integer)
    select case keycode
        case vbkeyinsert
            call cmdadd_click
        case vbkeydelete
            call cmdremove_click
    end select
end sub

private sub form_load()
    dim iopenpos as integer: iopenpos = freefile()
    dim sline as string
    
    'on error goto onerror
    
'[code 005]:matux
    open app.path & "\init\default.bnd" for input access read lock write as #iopenpos
'[end]
        on error resume next
        call lookfor("[binds]", iopenpos)
        do until eof(iopenpos)
            line input #iopenpos, sline
            call parsebind(sline)
        loop
        on error goto 0
    close #iopenpos

onerror:
    bchangesmade = false
    'close #iopenpos
    'on error goto 0
    'err.clear
end sub

private sub savebinds()
    dim iopenpos as integer: iopenpos = freefile()
    dim lx as long
    
'[code 005]:matux
    open app.path & "\init\default.bnd" for output access write lock write as #iopenpos
'[end]
        'call lookfor("[binds]", iopenpos)
        print #iopenpos, "//"
        print #iopenpos, "// no modificar este archivo a menos que"
        print #iopenpos, "// se est� seguro de lo que se hace!"
        print #iopenpos, "//"
        print #iopenpos,
        print #iopenpos, "[binds]"
        
        for lx = 1 to lvwmacros.listitems.count
            print #iopenpos, lvwmacros.listitems(lx).text & "=" & lvwmacros.listitems(lx).subitems(1)
        next lx
    close #iopenpos
end sub

private function parsebind(sbind as string) as long
    'cogemos la letra y su combinaci�n, t�o
    dim sletra as string, lx as long
    dim sshift as string, saction as string
    
    on error goto errhnd:
    
    for lx = 1 to len(sbind)
        sletra = mid(sbind, lx, 1)
        if sletra = "=" then
            sshift = left(sbind, lx - 1)
            exit for
        end if
    next lx
    saction = right(sbind, len(sbind) - (lx))
    
    if sshift = "" or saction = "" then _
        call err.raise(1)

    lvwmacros.listitems.add , sshift & "a", sshift
    lvwmacros.listitems(sshift & "a").subitems(1) = saction

    parsebind = 0
    exit function
        
errhnd:
    parsebind = -1

end function

public function getindexfromcombostr(cmbcombo as combobox, sstring as string, optional useinstr as boolean = false) as long
    dim ix as long
    
    if not useinstr then
        do until lcase(cmbcombo.list(ix)) = lcase(sstring)
            ix = ix + 1
        loop
    else
        do until instr(lcase(cmbcombo.list(ix)), lcase(sstring))
            ix = ix + 1
        loop
    end if
    
    getindexfromcombostr = ix
end function
