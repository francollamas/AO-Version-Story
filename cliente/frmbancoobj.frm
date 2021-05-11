version 5.00
begin vb.form frmbancoobj 
   backcolor       =   &h00000000&
   borderstyle     =   3  'fixed dialog
   clientheight    =   7290
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   6930
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   486
   scalemode       =   3  'pixel
   scalewidth      =   462
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox cantidad 
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
      left            =   3105
      tabindex        =   8
      text            =   "1"
      top             =   6690
      width           =   1080
   end
   begin vb.picturebox picture1 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      fillstyle       =   0  'solid
      height          =   600
      left            =   435
      scaleheight     =   540
      scalewidth      =   495
      tabindex        =   3
      top             =   750
      width           =   555
   end
   begin vb.commandbutton command2 
      caption         =   "ok"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   240
      left            =   6195
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   6780
      width           =   465
   end
   begin vb.listbox list1 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   3960
      index           =   1
      left            =   3855
      tabindex        =   1
      top             =   1800
      width           =   2490
   end
   begin vb.listbox list1 
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   3960
      index           =   0
      left            =   615
      tabindex        =   0
      top             =   1800
      width           =   2490
   end
   begin vb.label label2 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "cantidad"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h8000000e&
      height          =   195
      left            =   2265
      tabindex        =   9
      top             =   6750
      width           =   645
   end
   begin vb.image image1 
      height          =   330
      index           =   1
      left            =   3855
      mousepointer    =   99  'custom
      tag             =   "1"
      top             =   6165
      width           =   2460
   end
   begin vb.image image1 
      height          =   330
      index           =   0
      left            =   615
      mousepointer    =   99  'custom
      tag             =   "1"
      top             =   6150
      width           =   2460
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      forecolor       =   &h000000ff&
      height          =   195
      index           =   3
      left            =   3990
      tabindex        =   7
      top             =   975
      visible         =   0   'false
      width           =   45
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      forecolor       =   &h000000ff&
      height          =   195
      index           =   4
      left            =   3990
      tabindex        =   6
      top             =   630
      visible         =   0   'false
      width           =   45
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      forecolor       =   &h000000ff&
      height          =   195
      index           =   2
      left            =   2730
      tabindex        =   5
      top             =   1170
      width           =   45
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      forecolor       =   &h000000ff&
      height          =   195
      index           =   0
      left            =   1125
      tabindex        =   4
      top             =   450
      width           =   45
   end
end
attribute vb_name = "frmbancoobj"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
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

'[code]:matux
'
'    le puse el iconito de la manito a los botones ^_^ y
'   le puse borde a la ventana.
'
'[end]'

'<-------------------------nuevo-------------------------->
'<-------------------------nuevo-------------------------->
'<-------------------------nuevo-------------------------->
public lastindex1 as integer
public lastindex2 as integer




private sub cantidad_change()
if val(cantidad.text) < 0 then
    cantidad.text = 1
end if

if val(cantidad.text) > max_inventory_objs then
    cantidad.text = 1
end if

end sub

private sub cantidad_keypress(keyascii as integer)
if (keyascii <> 8) then
    if (keyascii <> 6) and (keyascii < 48 or keyascii > 57) then
        keyascii = 0
    end if
end if
end sub

private sub command2_click()
senddata ("finban")
end sub



private sub form_deactivate()
'me.setfocus
end sub


private sub form_load()
'cargamos la interfase
me.picture = loadpicture(app.path & "\graficos\comerciar.jpg")
image1(0).picture = loadpicture(app.path & "\graficos\bot�ncomprar.jpg")
image1(1).picture = loadpicture(app.path & "\graficos\bot�nvender.jpg")

end sub


private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
if image1(0).tag = 0 then
    image1(0).picture = loadpicture(app.path & "\graficos\bot�ncomprar.jpg")
    image1(0).tag = 1
end if
if image1(1).tag = 0 then
    image1(1).picture = loadpicture(app.path & "\graficos\bot�nvender.jpg")
    image1(1).tag = 1
end if
end sub

private sub image1_click(index as integer)

call playwaveds(snd_click)

if list1(index).list(list1(index).listindex) = "nada" or _
   list1(index).listindex < 0 then exit sub

select case index
    case 0
        frmbancoobj.list1(0).setfocus
        lastindex1 = list1(0).listindex
        
        senddata ("reti" & "," & list1(0).listindex + 1 & "," & cantidad.text)
                
   case 1
        lastindex2 = list1(1).listindex
        if userinventory(list1(1).listindex + 1).equipped = 0 then
            senddata ("depo" & "," & list1(1).listindex + 1 & "," & cantidad.text)
        else
            addtorichtextbox frmmain.rectxt, "no podes depositar el item porque lo estas usando.", 2, 51, 223, 1, 1
            exit sub
        end if
                
end select
list1(0).clear

list1(1).clear

npcinvdim = 0
end sub

private sub image1_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
select case index
    case 0
        if image1(0).tag = 1 then
                image1(0).picture = loadpicture(app.path & "\graficos\bot�ncomprarapretado.jpg")
                image1(0).tag = 0
                image1(1).picture = loadpicture(app.path & "\graficos\bot�nvender.jpg")
                image1(1).tag = 1
        end if
        
    case 1
        if image1(1).tag = 1 then
                image1(1).picture = loadpicture(app.path & "\graficos\bot�nvenderapretado.jpg")
                image1(1).tag = 0
                image1(0).picture = loadpicture(app.path & "\graficos\bot�ncomprar.jpg")
                image1(0).tag = 1
        end if
        
end select
end sub

private sub list1_click(index as integer)
dim sr as rect, dr as rect

sr.left = 0
sr.top = 0
sr.right = 32
sr.bottom = 32

dr.left = 0
dr.top = 0
dr.right = 32
dr.bottom = 32

select case index
    case 0
        label1(0).caption = userbancoinventory(list1(0).listindex + 1).name
        label1(2).caption = userbancoinventory(list1(0).listindex + 1).amount
        select case userbancoinventory(list1(0).listindex + 1).objtype
            case 2
                label1(3).caption = "max golpe:" & userbancoinventory(list1(0).listindex + 1).maxhit
                label1(4).caption = "min golpe:" & userbancoinventory(list1(0).listindex + 1).minhit
                label1(3).visible = true
                label1(4).visible = true
            case 3
                label1(3).visible = false
                label1(4).caption = "defensa:" & userbancoinventory(list1(0).listindex + 1).def
                label1(4).visible = true
        end select
        call drawgrhtohdc(picture1.hwnd, picture1.hdc, userbancoinventory(list1(0).listindex + 1).grhindex, sr, dr)
    case 1
        label1(0).caption = userinventory(list1(1).listindex + 1).name
        label1(2).caption = userinventory(list1(1).listindex + 1).amount
        select case userinventory(list1(1).listindex + 1).objtype
            case 2
                label1(3).caption = "max golpe:" & userinventory(list1(1).listindex + 1).maxhit
                label1(4).caption = "min golpe:" & userinventory(list1(1).listindex + 1).minhit
                label1(3).visible = true
                label1(4).visible = true
            case 3
                label1(3).visible = false
                label1(4).caption = "defensa:" & userinventory(list1(1).listindex + 1).def
                label1(4).visible = true
        end select
        call drawgrhtohdc(picture1.hwnd, picture1.hdc, userinventory(list1(1).listindex + 1).grhindex, sr, dr)
end select
picture1.refresh

end sub
'<-------------------------nuevo-------------------------->
'<-------------------------nuevo-------------------------->
'<-------------------------nuevo-------------------------->
private sub list1_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
if image1(0).tag = 0 then
    image1(0).picture = loadpicture(app.path & "\graficos\bot�ncomprar.jpg")
    image1(0).tag = 1
end if
if image1(1).tag = 0 then
    image1(1).picture = loadpicture(app.path & "\graficos\bot�nvender.jpg")
    image1(1).tag = 1
end if
end sub
