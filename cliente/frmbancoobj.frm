version 5.00
begin vb.form frmbancoobj 
   backcolor       =   &h80000000&
   borderstyle     =   0  'none
   clientheight    =   7950
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   6915
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   forecolor       =   &h8000000f&
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   530
   scalemode       =   0  'user
   scalewidth      =   461
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox cantidadoro 
      alignment       =   2  'center
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   270
      left            =   3525
      maxlength       =   7
      tabindex        =   7
      text            =   "1"
      top             =   1410
      width           =   1035
   end
   begin vb.textbox cantidad 
      alignment       =   2  'center
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   270
      left            =   3195
      maxlength       =   5
      tabindex        =   6
      text            =   "1"
      top             =   3930
      width           =   615
   end
   begin vb.picturebox picbancoinv 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
      forecolor       =   &h80000008&
      height          =   3795
      left            =   540
      scaleheight     =   3765
      scalewidth      =   2400
      tabindex        =   4
      top             =   2400
      width           =   2430
   end
   begin vb.picturebox picinv 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
      forecolor       =   &h80000008&
      height          =   3795
      left            =   4020
      scaleheight     =   16.617
      scalemode       =   0  'user
      scalewidth      =   825.806
      tabindex        =   3
      top             =   2400
      width           =   2430
   end
   begin vb.label lblusergld 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "0"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   240
      left            =   3600
      tabindex        =   5
      top             =   945
      width           =   135
   end
   begin vb.image imgdepositaroro 
      height          =   930
      left            =   1560
      tag             =   "0"
      top             =   945
      width           =   1050
   end
   begin vb.image imgretiraroro 
      height          =   765
      left            =   4695
      tag             =   "0"
      top             =   945
      width           =   945
   end
   begin vb.image imgcerrar 
      height          =   255
      left            =   6150
      tag             =   "0"
      top             =   360
      width           =   255
   end
   begin vb.image image1 
      height          =   255
      index           =   1
      left            =   3360
      mousepointer    =   99  'custom
      top             =   3480
      width           =   255
   end
   begin vb.image image1 
      height          =   255
      index           =   0
      left            =   3360
      mousepointer    =   99  'custom
      top             =   4440
      width           =   255
   end
   begin vb.image cmdmoverbov 
      height          =   375
      index           =   1
      left            =   0
      top             =   4200
      visible         =   0   'false
      width           =   570
   end
   begin vb.image cmdmoverbov 
      height          =   375
      index           =   0
      left            =   0
      top             =   4560
      visible         =   0   'false
      width           =   570
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   1
      left            =   2160
      tabindex        =   2
      top             =   6990
      visible         =   0   'false
      width           =   750
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   2
      left            =   2160
      tabindex        =   1
      top             =   7245
      visible         =   0   'false
      width           =   750
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   195
      index           =   0
      left            =   2160
      tabindex        =   0
      top             =   6750
      width           =   750
   end
end
attribute vb_name = "frmbancoobj"
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

'[code]:matux
'
'    le puse el iconito de la manito a los botones ^_^ y
'   le puse borde a la ventana.
'
'[end]'

'<-------------------------nuevo-------------------------->
'<-------------------------nuevo-------------------------->
'<-------------------------nuevo-------------------------->

private clsformulario as clsformmovementmanager

private cbotonretiraroro as clsgraphicalbutton
private cbotondepositaroro as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton

public lastpressed as clsgraphicalbutton


public lasactionbuy as boolean
public lastindex1 as integer
public lastindex2 as integer
public nopuedemover as boolean

private sub cantidad_change()

    if val(cantidad.text) < 1 then
        cantidad.text = 1
    end if
    
    if val(cantidad.text) > max_inventory_objs then
        cantidad.text = max_inventory_objs
    end if

end sub

private sub cantidad_keypress(keyascii as integer)
    if (keyascii <> 8) then
        if (keyascii <> 6) and (keyascii < 48 or keyascii > 57) then
            keyascii = 0
        end if
    end if
end sub

private sub cantidadoro_change()
    if val(cantidadoro.text) < 1 then
        cantidad.text = 1
    end if
end sub

private sub cantidadoro_keypress(keyascii as integer)
    if (keyascii <> 8) then
        if (keyascii <> 6) and (keyascii < 48 or keyascii > 57) then
            keyascii = 0
        end if
    end if
end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me

    'cargamos la interfase
    me.picture = loadpicture(app.path & "\graficos\boveda.jpg")
    
    call loadbuttons
    
end sub

private sub loadbuttons()

    dim grhpath as string
    
    grhpath = dirgraficos
    'cmdmoverbov(1).picture = loadpicture(app.path & "\graficos\flechasubirobjeto.jpg") ' www.gs-zone.org
    'cmdmoverbov(0).picture = loadpicture(app.path & "\graficos\flechabajarobjeto.jpg") ' www.gs-zone.org
    
    set cbotonretiraroro = new clsgraphicalbutton
    set cbotondepositaroro = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton


    call cbotondepositaroro.initialize(imgdepositaroro, "", grhpath & "botondepositaoroapretado.jpg", grhpath & "botondepositaoroapretado.jpg", me)
    call cbotonretiraroro.initialize(imgretiraroro, "", grhpath & "botonretiraroroapretado.jpg", grhpath & "botonretiraroroapretado.jpg", me)
    call cbotoncerrar.initialize(imgcerrar, "", grhpath & "xprendida.bmp", grhpath & "xprendida.bmp", me)
    
    image1(0).mouseicon = picmouseicon
    image1(1).mouseicon = picmouseicon
    
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    call lastpressed.toggletonormal
end sub

private sub image1_click(index as integer)
    
    call audio.playwave(snd_click)
    
    if invbanco(index).selecteditem = 0 then exit sub
    
    if not isnumeric(cantidad.text) then exit sub
    
    select case index
        case 0
            lastindex1 = invbanco(0).selecteditem
            lasactionbuy = true
            call writebankextractitem(invbanco(0).selecteditem, cantidad.text)
            
       case 1
            lastindex2 = invbanco(1).selecteditem
            lasactionbuy = false
            call writebankdeposit(invbanco(1).selecteditem, cantidad.text)
    end select

end sub


private sub imgdepositaroro_click()
    call writebankdepositgold(val(cantidadoro.text))
end sub

private sub imgretiraroro_click()
    call writebankextractgold(val(cantidadoro.text))
end sub

private sub picbancoinv_click()

    if invbanco(0).selecteditem <> 0 then
        with userbancoinventory(invbanco(0).selecteditem)
            label1(0).caption = .name
            
            select case .objtype
                case 2, 32
                    label1(1).caption = "m�x golpe:" & .maxhit
                    label1(2).caption = "m�n golpe:" & .minhit
                    label1(1).visible = true
                    label1(2).visible = true
                    
                case 3, 16, 17
                    label1(1).caption = "m�x defensa:" & .maxdef
                    label1(2).caption = "m�n defensa:" & .mindef
                    label1(1).visible = true
                    label1(2).visible = true
                    
                case else
                    label1(1).visible = false
                    label1(2).visible = false
                    
            end select
            
        end with
        
    else
        label1(0).caption = ""
        label1(1).visible = false
        label1(2).visible = false
    end if

end sub

private sub picbancoinv_mousemove(button as integer, shift as integer, x as single, y as single)
    call lastpressed.toggletonormal
end sub

private sub picinv_click()
    
    if invbanco(1).selecteditem <> 0 then
        with inventario
            label1(0).caption = .itemname(invbanco(1).selecteditem)
            
            select case .objtype(invbanco(1).selecteditem)
                case eobjtype.otweapon, eobjtype.otflechas
                    label1(1).caption = "m�x golpe:" & .maxhit(invbanco(1).selecteditem)
                    label1(2).caption = "m�n golpe:" & .minhit(invbanco(1).selecteditem)
                    label1(1).visible = true
                    label1(2).visible = true
                    
                case eobjtype.otcasco, eobjtype.otarmadura, eobjtype.otescudo ' 3, 16, 17
                    label1(1).caption = "m�x defensa:" & .maxdef(invbanco(1).selecteditem)
                    label1(2).caption = "m�n defensa:" & .mindef(invbanco(1).selecteditem)
                    label1(1).visible = true
                    label1(2).visible = true
                    
                case else
                    label1(1).visible = false
                    label1(2).visible = false
                    
            end select
            
        end with
    else
        label1(0).caption = ""
        label1(1).visible = false
        label1(2).visible = false
    end if
end sub

private sub picinv_mousemove(button as integer, shift as integer, x as single, y as single)
    call lastpressed.toggletonormal
end sub

private sub imgcerrar_click()
    call writebankend
    nopuedemover = false
end sub
