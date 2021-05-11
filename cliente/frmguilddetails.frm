version 5.00
begin vb.form frmguilddetails 
   borderstyle     =   1  'fixed single
   caption         =   "detalles del clan"
   clientheight    =   6825
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   6840
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   6825
   scalewidth      =   6840
   startupposition =   1  'centerowner
   begin vb.commandbutton command1 
      caption         =   "aceptar"
      height          =   375
      index           =   1
      left            =   5160
      mouseicon       =   "frmguilddetails.frx":0000
      mousepointer    =   99  'custom
      tabindex        =   13
      top             =   6360
      width           =   1455
   end
   begin vb.commandbutton command1 
      cancel          =   -1  'true
      caption         =   "cancelar"
      height          =   375
      index           =   0
      left            =   120
      mouseicon       =   "frmguilddetails.frx":0152
      mousepointer    =   99  'custom
      tabindex        =   12
      top             =   6360
      width           =   1455
   end
   begin vb.frame frame1 
      caption         =   "codex"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   4215
      left            =   120
      tabindex        =   2
      top             =   2040
      width           =   6495
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   7
         left            =   360
         tabindex        =   11
         top             =   3720
         width           =   5655
      end
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   6
         left            =   360
         tabindex        =   10
         top             =   3360
         width           =   5655
      end
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   5
         left            =   360
         tabindex        =   9
         top             =   3000
         width           =   5655
      end
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   4
         left            =   360
         tabindex        =   8
         top             =   2640
         width           =   5655
      end
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   3
         left            =   360
         tabindex        =   7
         top             =   2280
         width           =   5655
      end
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   2
         left            =   360
         tabindex        =   6
         top             =   1920
         width           =   5655
      end
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   1
         left            =   360
         tabindex        =   5
         top             =   1560
         width           =   5655
      end
      begin vb.textbox txtcodex1 
         height          =   285
         index           =   0
         left            =   360
         tabindex        =   4
         top             =   1200
         width           =   5655
      end
      begin vb.label label1 
         alignment       =   2  'center
         caption         =   $"frmguilddetails.frx":02a4
         beginproperty font 
            name            =   "tahoma"
            size            =   8.25
            charset         =   0
            weight          =   400
            underline       =   0   'false
            italic          =   -1  'true
            strikethrough   =   0   'false
         endproperty
         height          =   855
         left            =   120
         tabindex        =   3
         top             =   240
         width           =   6255
      end
   end
   begin vb.frame frmdesc 
      caption         =   "descripci�n"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   1935
      left            =   120
      tabindex        =   0
      top             =   0
      width           =   6495
      begin vb.textbox txtdesc 
         height          =   1455
         left            =   120
         multiline       =   -1  'true
         tabindex        =   1
         top             =   360
         width           =   6135
      end
   end
end
attribute vb_name = "frmguilddetails"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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

private const max_desc_length as integer = 520
private const max_codex_length as integer = 100

private sub command1_click(index as integer)
    select case index
        case 0
            unload me
        
        case 1
            dim fdesc as string
            dim codex() as string
            dim k as byte
            dim cont as byte
    
            fdesc = replace(txtdesc, vbcrlf, "�", , , vbbinarycompare)
    
            '    if not asciivalidos(fdesc) then
            '        msgbox "la descripcion contiene caracteres invalidos"
            '        exit sub
            '    end if

            cont = 0
            for k = 0 to txtcodex1.ubound
            '    if not asciivalidos(txtcodex1(k)) then
            '        msgbox "el codex tiene invalidos"
            '        exit sub
            '    end if
                if lenb(txtcodex1(k).text) <> 0 then cont = cont + 1
            next k
            if cont < 4 then
                msgbox "debes definir al menos cuatro mandamientos."
                exit sub
            end if
                        
            redim codex(txtcodex1.ubound) as string
            for k = 0 to txtcodex1.ubound
                codex(k) = txtcodex1(k)
            next k
    
            if creandoclan then
                call writecreatenewguild(fdesc, clanname, site, codex)
            else
                call writeclancodexupdate(fdesc, codex)
            end if

            creandoclan = false
            unload me
            
    end select
end sub

private sub txtcodex1_change(index as integer)
    if len(txtcodex1.item(index).text) > max_codex_length then _
        txtcodex1.item(index).text = left$(txtcodex1.item(index).text, max_codex_length)
end sub

private sub txtdesc_change()
    if len(txtdesc.text) > max_desc_length then _
        txtdesc.text = left$(txtdesc.text, max_desc_length)
end sub
