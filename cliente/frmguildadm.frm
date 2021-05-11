version 5.00
begin vb.form frmguildadm 
   borderstyle     =   0  'none
   caption         =   "lista de clanes registrados"
   clientheight    =   5535
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   4065
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
   scaleheight     =   369
   scalemode       =   3  'pixel
   scalewidth      =   271
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txtbuscar 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   240
      left            =   495
      tabindex        =   1
      top             =   4650
      width           =   3105
   end
   begin vb.listbox guildslist 
      appearance      =   0  'flat
      backcolor       =   &h00000000&
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   3540
      itemdata        =   "frmguildadm.frx":0000
      left            =   495
      list            =   "frmguildadm.frx":0002
      tabindex        =   0
      top             =   570
      width           =   3075
   end
   begin vb.image imgdetalles 
      height          =   375
      left            =   2280
      tag             =   "1"
      top             =   5025
      width           =   1335
   end
   begin vb.image imgcerrar 
      height          =   375
      left            =   480
      tag             =   "1"
      top             =   5025
      width           =   855
   end
end
attribute vb_name = "frmguildadm"
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
private cbotondetalles as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
        
    me.picture = loadpicture(app.path & "\graficos\ventanalistaclanes.jpg")
    
    call loadbuttons
    
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotoncerrar = new clsgraphicalbutton
    set cbotondetalles = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarlistaclanes.jpg", _
                                    grhpath & "botoncerrarrolloverlistaclanes.jpg", _
                                    grhpath & "botoncerrarclicklistaclanes.jpg", me)

    call cbotondetalles.initialize(imgdetalles, grhpath & "botondetalleslistaclanes.jpg", _
                                    grhpath & "botondetallesrolloverlistaclanes.jpg", _
                                    grhpath & "botondetallesclicklistaclanes.jpg", me)

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub guildslist_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgcerrar_click()
    unload me
    frmmain.setfocus
end sub

private sub imgdetalles_click()
    frmguildbrief.esleader = false

    call writeguildrequestdetails(guildslist.list(guildslist.listindex))
end sub

private sub txtbuscar_change()
    call filtrarlistaclanes(txtbuscar.text)
end sub

private sub txtbuscar_gotfocus()
    with txtbuscar
        .selstart = 0
        .sellength = len(.text)
    end with
end sub

public sub filtrarlistaclanes(byref scompare as string)

    dim lindex as long
    
    if ubound(guildnames) <> 0 then
        with guildslist
            'limpio la lista
            .clear
            
            .visible = false
            
            ' recorro los arrays
            for lindex = 0 to ubound(guildnames)
                ' si coincide con los patrones
                if instr(1, ucase$(guildnames(lindex)), ucase$(scompare)) then
                    ' lo agrego a la lista
                    .additem guildnames(lindex)
                end if
            next lindex
            
            .visible = true
        end with
    end if

end sub
