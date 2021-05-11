version 5.00
begin vb.form frmbinderedit 
   borderstyle     =   4  'fixed toolwindow
   caption         =   "agregar macro"
   clientheight    =   5250
   clientleft      =   45
   clienttop       =   285
   clientwidth     =   3705
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   5250
   scalewidth      =   3705
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.frame frmcomm 
      caption         =   "escribe el comando:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   615
      left            =   120
      tabindex        =   6
      top             =   4080
      width           =   3495
      begin vb.textbox txtcommand 
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   400
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   285
         left            =   120
         tabindex        =   7
         text            =   "/"
         top             =   240
         width           =   3255
      end
   end
   begin vb.frame frmcommcomp 
      caption         =   "escribe el comando compuesto:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   615
      left            =   120
      tabindex        =   14
      top             =   4080
      visible         =   0   'false
      width           =   3495
      begin vb.textbox txtcommcomp 
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   400
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   285
         left            =   120
         tabindex        =   15
         text            =   "-"
         top             =   240
         width           =   3255
      end
   end
   begin vb.optionbutton optaction 
      caption         =   "comando compuesto (ej: /desc gran guerrero, amigo de... o /depositar 1000)"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   555
      index           =   2
      left            =   240
      mouseicon       =   "frmbinderadd.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   13
      top             =   2220
      width           =   3195
   end
   begin vb.frame frmfunc 
      caption         =   "selecciona la funci�n:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   615
      left            =   120
      tabindex        =   8
      top             =   4080
      visible         =   0   'false
      width           =   3495
      begin vb.combobox cmbfunc 
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   400
            underline       =   0   'false
            italic          =   0   'false
            strikethrough   =   0   'false
         endproperty
         height          =   315
         itemdata        =   "frmbinderadd.frx":0152
         left            =   120
         list            =   "frmbinderadd.frx":0177
         mouseicon       =   "frmbinderadd.frx":02bd
         mousepointer    =   99  'custom
         style           =   2  'dropdown list
         tabindex        =   9
         top             =   240
         width           =   3255
      end
   end
   begin vb.optionbutton optaction 
      caption         =   "funci�n predefinida (ej: activar modo combate, apagar sonidos)"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      index           =   1
      left            =   240
      mouseicon       =   "frmbinderadd.frx":040f
      mousepointer    =   99  'custom
      tabindex        =   12
      top             =   2880
      width           =   3195
   end
   begin vb.commandbutton cmdcancel 
      cancel          =   -1  'true
      caption         =   "&cancelar"
      height          =   315
      left            =   1620
      mouseicon       =   "frmbinderadd.frx":0561
      mousepointer    =   99  'custom
      tabindex        =   11
      top             =   4860
      width           =   975
   end
   begin vb.commandbutton cmdadd 
      caption         =   "&agregar"
      height          =   315
      left            =   2640
      mouseicon       =   "frmbinderadd.frx":06b3
      mousepointer    =   99  'custom
      tabindex        =   10
      top             =   4860
      width           =   975
   end
   begin vb.optionbutton optaction 
      caption         =   "comando (ej: /comerciar o /balance)"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   315
      index           =   0
      left            =   240
      mouseicon       =   "frmbinderadd.frx":0805
      mousepointer    =   99  'custom
      tabindex        =   4
      top             =   1800
      value           =   -1  'true
      width           =   3195
   end
   begin vb.combobox cmbshift 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   315
      itemdata        =   "frmbinderadd.frx":0957
      left            =   240
      list            =   "frmbinderadd.frx":0964
      mouseicon       =   "frmbinderadd.frx":0977
      mousepointer    =   99  'custom
      style           =   2  'dropdown list
      tabindex        =   2
      top             =   720
      width           =   1215
   end
   begin vb.combobox cmbkey 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   315
      itemdata        =   "frmbinderadd.frx":0ac9
      left            =   1500
      list            =   "frmbinderadd.frx":0b39
      mouseicon       =   "frmbinderadd.frx":0ba9
      mousepointer    =   99  'custom
      style           =   2  'dropdown list
      tabindex        =   1
      top             =   720
      width           =   1935
   end
   begin vb.line line3 
      x1              =   60
      x2              =   3660
      y1              =   4800
      y2              =   4800
   end
   begin vb.label label3 
      alignment       =   2  'center
      caption         =   $"frmbinderadd.frx":0cfb
      beginproperty font 
         name            =   "small fonts"
         size            =   6.75
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   495
      left            =   180
      tabindex        =   5
      top             =   3420
      width           =   3315
   end
   begin vb.line line2 
      x1              =   60
      x2              =   3600
      y1              =   4020
      y2              =   4020
   end
   begin vb.label label2 
      alignment       =   2  'center
      caption         =   "selecciona la acci�n que desarrollar� este macro:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   435
      left            =   180
      tabindex        =   3
      top             =   1260
      width           =   3315
   end
   begin vb.line line1 
      x1              =   60
      x2              =   3600
      y1              =   1200
      y2              =   1200
   end
   begin vb.label label1 
      alignment       =   2  'center
      caption         =   "seleccion� la letra o combinaci�n que utilizaras para este macro:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   435
      left            =   180
      tabindex        =   0
      top             =   180
      width           =   3315
   end
end
attribute vb_name = "frmbinderedit"
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

public lshift as long, lkey as long, laction as long, _
       lfunc as long, scommand as string, scommcomp as string, _
       beditmode as boolean

private sub cmdadd_click()
    'on error resume next
        dim smacro as string, ival as integer
        smacro = iif(cmbshift.text = "", cmbkey.text, cmbshift.text & "+" & cmbkey.text)
        
        if lvwcompare(smacro, frmbinder.lvwmacros) then
            call unselectall(frmbinder.lvwmacros)
            frmbinder.lvwmacros.listitems(smacro & "a").selected = true
            frmbinder.lvwmacros.listitems(smacro & "a").ensurevisible
            ival = msgbox("el macro ya existe, �desea sobre-escribirlo?", vbapplicationmodal + vbquestion + vbyesno, "el macro ya fue definido")
            if ival = vbno then
                exit sub
            else
                beditmode = true
            end if
        end if
        
        if beditmode then
            call frmbinder.lvwmacros.listitems.remove(frmbinder.lvwmacros.selecteditem.key)
        '    frmbinder.lvwmacros.selecteditem.key = smacro
        '    frmbinder.lvwmacros.listitems(smacro).text = smacro
        end if
        'else
            frmbinder.lvwmacros.listitems.add , smacro & "a", smacro
        'end if
        
        if cmbfunc.visible = true then
            dim sstring as string, lpos as long
            lpos = instr(cmbfunc.text, "(") + 1
            sstring = mid(cmbfunc.text, lpos, len(cmbfunc.text) - lpos)
            frmbinder.lvwmacros.listitems(smacro & "a").subitems(1) = sstring
        elseif frmcommcomp.visible = true then
            frmbinder.lvwmacros.listitems(smacro & "a").subitems(1) = txtcommcomp.text
        else
            frmbinder.lvwmacros.listitems(smacro & "a").subitems(1) = txtcommand.text
        end if
        frmbinder.lvwmacros.listitems(smacro & "a").ensurevisible
    on error goto 0
    
    frmbinder.bchangesmade = true
    
    'clearvalues
    call unload(me)
end sub

private sub cmdcancel_click()
    'clearvalues
    call unload(me)
end sub

private sub form_load()
    call initvalues
end sub

private sub optaction_click(index as integer)
    select case index
        case 0
            frmfunc.visible = false
            frmcomm.visible = true
            frmcommcomp.visible = false
        case 1
            frmfunc.visible = true
            frmcomm.visible = false
            frmcommcomp.visible = false
        case 2
            frmcommcomp.visible = true
            frmcomm.visible = false
            frmfunc.visible = false
    end select
end sub

public sub initvalues(optional editmode as boolean = false)
    cmbshift.listindex = lshift
    cmbkey.listindex = lkey
    cmbfunc.listindex = lfunc
    'optaction(iif(laction = 0, 0, 1)).value = true
    txtcommand.text = iif(scommand = "", "/", scommand)
    txtcommcomp.text = iif(scommcomp = "", "-", scommcomp)
    
    beditmode = editmode
    if beditmode = true then
        cmdadd.caption = "modificar"
    else
        cmdadd.caption = "agregar"
    end if
end sub

public sub clearvalues()
    cmbshift.listindex = 0
    cmbkey.listindex = 0
    cmbfunc.listindex = 0
    txtcommand.text = ""
end sub
