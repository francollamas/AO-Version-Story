version 5.00
begin vb.form frmguildmember 
   backcolor       =   &h8000000b&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   5640
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   5985
   linktopic       =   "form1"
   scaleheight     =   376
   scalemode       =   3  'pixel
   scalewidth      =   399
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.listbox lstmiembros 
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
      height          =   2565
      left            =   3075
      tabindex        =   3
      top             =   675
      width           =   2610
   end
   begin vb.listbox lstclanes 
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
      height          =   2565
      left            =   195
      tabindex        =   2
      top             =   690
      width           =   2610
   end
   begin vb.textbox txtsearch 
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
      height          =   225
      left            =   225
      tabindex        =   1
      top             =   3630
      width           =   2550
   end
   begin vb.label lblcantmiembros 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      caption         =   "1"
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
      left            =   4635
      tabindex        =   0
      top             =   3510
      width           =   360
   end
   begin vb.image imgcerrar 
      height          =   495
      left            =   3000
      top             =   4920
      width           =   2775
   end
   begin vb.image imgnoticias 
      height          =   495
      left            =   150
      top             =   4920
      width           =   2775
   end
   begin vb.image imgdetalles 
      height          =   375
      left            =   150
      top             =   4200
      width           =   2655
   end
end
attribute vb_name = "frmguildmember"
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

private cbotonnoticias as clsgraphicalbutton
private cbotondetalles as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

private sub form_load()

    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me

    me.picture = loadpicture(dirgraficos & "ventanamiembroclan.jpg")
    
    call loadbuttons
    
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonnoticias = new clsgraphicalbutton
    set cbotondetalles = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotondetalles.initialize(imgdetalles, grhpath & "botondetallesmiembroclan.jpg", _
                                    grhpath & "botondetallesrollovermiembroclan.jpg", _
                                    grhpath & "botondetallesclickmiembroclan.jpg", me)

    call cbotonnoticias.initialize(imgnoticias, grhpath & "botonnoticiasmiembroclan.jpg", _
                                    grhpath & "botonnoticiasrollovermiembroclan.jpg", _
                                    grhpath & "botonnoticiasclickmiembroclan.jpg", me)

    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarmimebroclan.jpg", _
                                    grhpath & "botoncerrarrollovermimebroclan.jpg", _
                                    grhpath & "botoncerrarclickmimebroclan.jpg", me)

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgdetalles_click()
    if lstclanes.listindex = -1 then exit sub
    
    frmguildbrief.esleader = false

    call writeguildrequestdetails(lstclanes.list(lstclanes.listindex))
end sub

private sub imgnoticias_click()
    call writeshowguildnews
end sub

private sub txtsearch_change()
    call filtrarlistaclanes(txtsearch.text)
end sub

private sub txtsearch_gotfocus()
    with txtsearch
        .selstart = 0
        .sellength = len(.text)
    end with
end sub

public sub filtrarlistaclanes(byref scompare as string)

    dim lindex as long
    
    if ubound(guildnames) <> 0 then
        with lstclanes
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

