version 5.00
begin vb.form frmeligealineacion 
   backcolor       =   &h00c0c0c0&
   borderstyle     =   1  'fixed single
   clientheight    =   5265
   clientleft      =   15
   clienttop       =   15
   clientwidth     =   6720
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   5265
   scalewidth      =   6720
   startupposition =   1  'centerowner
   begin vb.image imgreal 
      height          =   765
      left            =   795
      tag             =   "1"
      top             =   300
      width           =   5745
   end
   begin vb.image imgneutral 
      height          =   570
      left            =   810
      tag             =   "1"
      top             =   2220
      width           =   5730
   end
   begin vb.image imglegal 
      height          =   705
      left            =   810
      tag             =   "1"
      top             =   1320
      width           =   5715
   end
   begin vb.image imgcaos 
      height          =   675
      left            =   822
      tag             =   "1"
      top             =   4117
      width           =   5700
   end
   begin vb.image imgcriminal 
      height          =   705
      left            =   818
      tag             =   "1"
      top             =   3150
      width           =   5865
   end
   begin vb.image imgsalir 
      height          =   315
      left            =   5520
      tag             =   "1"
      top             =   4800
      width           =   930
   end
end
attribute vb_name = "frmeligealineacion"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmeligealineacion.frm
'
'**************************************************************

'**************************************************************************
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
'**************************************************************************

option explicit

private clsformulario as clsformmovementmanager

private cbotoncriminal as clsgraphicalbutton
private cbotoncaos as clsgraphicalbutton
private cbotonlegal as clsgraphicalbutton
private cbotonneutral as clsgraphicalbutton
private cbotonreal as clsgraphicalbutton
private cbotonsalir as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private enum ealineacion
    iereal = 0
    iecaos = 1
    ieneutral = 2
    ielegal = 4
    iecriminal = 5
end enum

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanafundarclan.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotoncriminal = new clsgraphicalbutton
    set cbotoncaos = new clsgraphicalbutton
    set cbotonlegal = new clsgraphicalbutton
    set cbotonneutral = new clsgraphicalbutton
    set cbotonreal = new clsgraphicalbutton
    set cbotonsalir = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotoncriminal.initialize(imgcriminal, "", _
                                    grhpath & "botoncriminal.jpg", _
                                    grhpath & "botoncriminal.jpg", me)

    call cbotoncaos.initialize(imgcaos, "", _
                                    grhpath & "botoncaos.jpg", _
                                    grhpath & "botoncaos.jpg", me)

    call cbotonlegal.initialize(imglegal, "", _
                                    grhpath & "botonlegal.jpg", _
                                    grhpath & "botonlegal.jpg", me)

    call cbotonneutral.initialize(imgneutral, "", _
                                    grhpath & "botonneutral.jpg", _
                                    grhpath & "botonneutral.jpg", me)

    call cbotonreal.initialize(imgreal, "", _
                                    grhpath & "botonreal.jpg", _
                                    grhpath & "botonreal.jpg", me)
                                    
    call cbotonsalir.initialize(imgsalir, grhpath & "botonsaliralineacion.jpg", _
                                    grhpath & "botonsalirrolloveralineacion.jpg", _
                                    grhpath & "botonsalirclickalineacion.jpg", me)


end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgcaos_click()
    call writeguildfundation(ealineacion.iecaos)
    unload me
end sub

private sub imgcriminal_click()
    call writeguildfundation(ealineacion.iecriminal)
    unload me
end sub

private sub imglegal_click()
    call writeguildfundation(ealineacion.ielegal)
    unload me
end sub

private sub imgneutral_click()
    call writeguildfundation(ealineacion.ieneutral)
    unload me
end sub

private sub imgreal_click()
    call writeguildfundation(ealineacion.iereal)
    unload me
end sub

private sub imgsalir_click()
    unload me
end sub
