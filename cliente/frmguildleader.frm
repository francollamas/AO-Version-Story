version 5.00
begin vb.form frmguildleader 
   borderstyle     =   0  'none
   caption         =   "administraci�n del clan"
   clientheight    =   7410
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   5985
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
   scaleheight     =   494
   scalemode       =   3  'pixel
   scalewidth      =   399
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.textbox txtfiltrarmiembros 
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
      height          =   225
      left            =   3075
      tabindex        =   6
      top             =   2340
      width           =   2580
   end
   begin vb.textbox txtfiltrarclanes 
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
      left            =   195
      tabindex        =   5
      top             =   2340
      width           =   2580
   end
   begin vb.textbox txtguildnews 
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
      height          =   690
      left            =   195
      multiline       =   -1  'true
      tabindex        =   4
      top             =   3435
      width           =   5475
   end
   begin vb.listbox solicitudes 
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
      height          =   810
      itemdata        =   "frmguildleader.frx":0000
      left            =   195
      list            =   "frmguildleader.frx":0002
      tabindex        =   2
      top             =   5100
      width           =   2595
   end
   begin vb.listbox members 
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
      height          =   1395
      itemdata        =   "frmguildleader.frx":0004
      left            =   3060
      list            =   "frmguildleader.frx":0006
      tabindex        =   1
      top             =   540
      width           =   2595
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
      height          =   1395
      itemdata        =   "frmguildleader.frx":0008
      left            =   180
      list            =   "frmguildleader.frx":000a
      tabindex        =   0
      top             =   540
      width           =   2595
   end
   begin vb.image imgcerrar 
      height          =   495
      left            =   3000
      tag             =   "1"
      top             =   6705
      width           =   2775
   end
   begin vb.image imgpropuestasalianzas 
      height          =   495
      left            =   3000
      tag             =   "1"
      top             =   6195
      width           =   2775
   end
   begin vb.image imgpropuestaspaz 
      height          =   495
      left            =   3000
      tag             =   "1"
      top             =   5685
      width           =   2775
   end
   begin vb.image imgeditarurl 
      height          =   495
      left            =   3000
      tag             =   "1"
      top             =   5175
      width           =   2775
   end
   begin vb.image imgeditarcodex 
      height          =   495
      left            =   3000
      tag             =   "1"
      top             =   4665
      width           =   2775
   end
   begin vb.image imgactualizar 
      height          =   390
      left            =   150
      tag             =   "1"
      top             =   4230
      width           =   5550
   end
   begin vb.image imgdetallessolicitudes 
      height          =   375
      left            =   120
      tag             =   "1"
      top             =   6045
      width           =   2655
   end
   begin vb.image imgdetallesmiembros 
      height          =   375
      left            =   3060
      tag             =   "1"
      top             =   2700
      width           =   2655
   end
   begin vb.image imgdetallesclan 
      height          =   375
      left            =   165
      tag             =   "1"
      top             =   2700
      width           =   2655
   end
   begin vb.image imgelecciones 
      height          =   375
      left            =   120
      tag             =   "1"
      top             =   6840
      width           =   2655
   end
   begin vb.label miembros 
      backstyle       =   0  'transparent
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
      height          =   255
      left            =   1815
      tabindex        =   3
      top             =   6510
      width           =   255
   end
end
attribute vb_name = "frmguildleader"
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

private const max_news_length as integer = 512
private clsformulario as clsformmovementmanager

private cbotonelecciones as clsgraphicalbutton
private cbotonactualizar as clsgraphicalbutton
private cbotondetallesclan as clsgraphicalbutton
private cbotondetallesmiembros as clsgraphicalbutton
private cbotondetallessolicitudes as clsgraphicalbutton
private cbotoneditarcodex as clsgraphicalbutton
private cbotoneditarurl as clsgraphicalbutton
private cbotonpropuestaspaz as clsgraphicalbutton
private cbotonpropuestasalianzas as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanaadministrarclan.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonelecciones = new clsgraphicalbutton
    set cbotonactualizar = new clsgraphicalbutton
    set cbotondetallesclan = new clsgraphicalbutton
    set cbotondetallesmiembros = new clsgraphicalbutton
    set cbotondetallessolicitudes = new clsgraphicalbutton
    set cbotoneditarcodex = new clsgraphicalbutton
    set cbotoneditarurl = new clsgraphicalbutton
    set cbotonpropuestaspaz = new clsgraphicalbutton
    set cbotonpropuestasalianzas = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotonelecciones.initialize(imgelecciones, grhpath & "botonelecciones.jpg", _
                                    grhpath & "botoneleccionesrollover.jpg", _
                                    grhpath & "botoneleccionesclick.jpg", me)

    call cbotonactualizar.initialize(imgactualizar, grhpath & "botonactualizar.jpg", _
                                    grhpath & "botonactualizarrollover.jpg", _
                                    grhpath & "botonactualizarclick.jpg", me)

    call cbotondetallesclan.initialize(imgdetallesclan, grhpath & "botondetallesadministrarclan.jpg", _
                                    grhpath & "botondetallesrolloveradministrarclan.jpg", _
                                    grhpath & "botondetallesclickadministrarclan.jpg", me)

    call cbotondetallesmiembros.initialize(imgdetallesmiembros, grhpath & "botondetallesadministrarclan.jpg", _
                                    grhpath & "botondetallesrolloveradministrarclan.jpg", _
                                    grhpath & "botondetallesclickadministrarclan.jpg", me)
                                    
    call cbotondetallessolicitudes.initialize(imgdetallessolicitudes, grhpath & "botondetallesadministrarclan.jpg", _
                                    grhpath & "botondetallesrolloveradministrarclan.jpg", _
                                    grhpath & "botondetallesclickadministrarclan.jpg", me)

    call cbotoneditarcodex.initialize(imgeditarcodex, grhpath & "botoneditarcodex.jpg", _
                                    grhpath & "botoneditarcodexrollover.jpg", _
                                    grhpath & "botoneditarcodexclick.jpg", me)

    call cbotoneditarurl.initialize(imgeditarurl, grhpath & "botoneditarurl.jpg", _
                                    grhpath & "botoneditarurlrollover.jpg", _
                                    grhpath & "botoneditarurlclick.jpg", me)

    call cbotonpropuestaspaz.initialize(imgpropuestaspaz, grhpath & "botonpropuestapaz.jpg", _
                                    grhpath & "botonpropuestapazrollover.jpg", _
                                    grhpath & "botonpropuestapazclick.jpg", me)

    call cbotonpropuestasalianzas.initialize(imgpropuestasalianzas, grhpath & "botonpropuestasalianzas.jpg", _
                                    grhpath & "botonpropuestasalianzasrollover.jpg", _
                                    grhpath & "botonpropuestasalianzasclick.jpg", me)

    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerraradministrarclan.jpg", _
                                    grhpath & "botoncerrarrolloveradministrarclan.jpg", _
                                    grhpath & "botoncerrarclickadministrarclan.jpg", me)


end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub guildslist_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgactualizar_click()
    dim k as string

    k = replace(txtguildnews, vbcrlf, "�")
    
    call writeguildupdatenews(k)
end sub

private sub imgcerrar_click()
    unload me
    frmmain.setfocus
end sub

private sub imgdetallesclan_click()
    frmguildbrief.esleader = true
    call writeguildrequestdetails(guildslist.list(guildslist.listindex))
end sub

private sub imgdetallesmiembros_click()
    if members.listindex = -1 then exit sub
    
    frmcharinfo.frmtype = charinfofrmtype.frmmembers
    call writeguildmemberinfo(members.list(members.listindex))
end sub

private sub imgdetallessolicitudes_click()
    if solicitudes.listindex = -1 then exit sub
    
    frmcharinfo.frmtype = charinfofrmtype.frmmembershiprequests
    call writeguildmemberinfo(solicitudes.list(solicitudes.listindex))
end sub

private sub imgeditarcodex_click()
    call frmguilddetails.show(vbmodal, frmguildleader)
end sub

private sub imgeditarurl_click()
    call frmguildurl.show(vbmodeless, frmguildleader)
end sub

private sub imgelecciones_click()
    call writeguildopenelections
    unload me
end sub

private sub imgpropuestasalianzas_click()
    call writeguildallianceproplist
end sub

private sub imgpropuestaspaz_click()
    call writeguildpeaceproplist
end sub

private sub members_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub solicitudes_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub txtguildnews_change()
    if len(txtguildnews.text) > max_news_length then _
        txtguildnews.text = left$(txtguildnews.text, max_news_length)
end sub

private sub txtguildnews_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub txtfiltrarclanes_change()
    call filtrarlistaclanes(txtfiltrarclanes.text)
end sub

private sub txtfiltrarclanes_gotfocus()
    with txtfiltrarclanes
        .selstart = 0
        .sellength = len(.text)
    end with
end sub

private sub filtrarlistaclanes(byref scompare as string)

    dim lindex as long
    
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

end sub

private sub txtfiltrarmiembros_change()
    call filtrarlistamiembros(txtfiltrarmiembros.text)
end sub

private sub txtfiltrarmiembros_gotfocus()
    with txtfiltrarmiembros
        .selstart = 0
        .sellength = len(.text)
    end with
end sub

private sub filtrarlistamiembros(byref scompare as string)

    dim lindex as long
    
    with members
        'limpio la lista
        .clear
        
        .visible = false
        
        ' recorro los arrays
        for lindex = 0 to ubound(guildmembers)
            ' si coincide con los patrones
            if instr(1, ucase$(guildmembers(lindex)), ucase$(scompare)) then
                ' lo agrego a la lista
                .additem guildmembers(lindex)
            end if
        next lindex
        
        .visible = true
    end with
end sub


