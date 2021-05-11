version 5.00
begin vb.form frmmsg 
   borderstyle     =   0  'none
   clientheight    =   3270
   clientleft      =   120
   clienttop       =   45
   clientwidth     =   2445
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   beginproperty font 
      name            =   "verdana"
      size            =   12
      charset         =   0
      weight          =   700
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   218
   scalemode       =   3  'pixel
   scalewidth      =   163
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.listbox list1 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
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
      height          =   1785
      left            =   300
      tabindex        =   0
      top             =   615
      width           =   1845
   end
   begin vb.image imgcerrar 
      height          =   420
      left            =   375
      tag             =   "1"
      top             =   2640
      width           =   1710
   end
   begin vb.menu menu_usuario 
      caption         =   "usuario"
      visible         =   0   'false
      begin vb.menu mnuir 
         caption         =   "ir donde esta el usuario"
      end
      begin vb.menu mnutraer 
         caption         =   "traer usuario"
      end
      begin vb.menu mnuborrar 
         caption         =   "borrar mensaje"
      end
   end
end
attribute vb_name = "frmmsg"
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

private clsformulario as clsformmovementmanager

private cbotoncerrar as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

private const max_gm_msg = 300

private mismsg(0 to max_gm_msg) as string
private apunt(0 to max_gm_msg) as integer

public sub creargmmsg(nick as string, msg as string)
if list1.listcount < max_gm_msg then
        list1.additem nick & "-" & list1.listcount
        mismsg(list1.listcount - 1) = msg
        apunt(list1.listcount - 1) = list1.listcount - 1
end if
end sub

private sub form_deactivate()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.visible = false
    list1.clear
end sub

private sub form_load()
    list1.clear
    
    me.picture = loadpicture(app.path & "\graficos\ventanashowsos.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotoncerrar = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarshowsos.jpg", _
                                    grhpath & "botoncerrarrollovershowsos.jpg", _
                                    grhpath & "botoncerrarclickshowsos.jpg", me)
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub imgcerrar_click()
    me.visible = false
    list1.clear
end sub

private sub list1_click()
    dim ind as integer
    ind = val(readfield(2, list1.list(list1.listindex), asc("-")))
end sub

private sub list1_mousedown(button as integer, shift as integer, x as single, y as single)
    if button = vbrightbutton then
        popupmenu menu_usuario
    end if

end sub

private sub list1_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub mnuborrar_click()
    if list1.listindex < 0 then exit sub
    'pablo (toxicwaste)
    dim aux as string
    aux = mid$(readfield(1, list1.list(list1.listindex), asc("-")), 10, len(readfield(1, list1.list(list1.listindex), asc("-"))))
    call writesosremove(aux)
    '/pablo (toxicwaste)
    'call writesosremove(list1.list(list1.listindex))
    
    list1.removeitem list1.listindex
end sub

private sub mnuir_click()
    'pablo (toxicwaste)
    dim aux as string
    aux = mid$(readfield(1, list1.list(list1.listindex), asc("-")), 10, len(readfield(1, list1.list(list1.listindex), asc("-"))))
    call writegotochar(aux)
    '/pablo (toxicwaste)
    'call writegotochar(readfield(1, list1.list(list1.listindex), asc("-")))
    
end sub

private sub mnutraer_click()
    'pablo (toxicwaste)
    dim aux as string
    aux = mid$(readfield(1, list1.list(list1.listindex), asc("-")), 10, len(readfield(1, list1.list(list1.listindex), asc("-"))))
    call writesummonchar(aux)
    'pablo (toxicwaste)
    'call writesummonchar(readfield(1, list1.list(list1.listindex), asc("-")))
end sub
