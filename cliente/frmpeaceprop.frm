version 5.00
begin vb.form frmpeaceprop 
   borderstyle     =   0  'none
   caption         =   "ofertas de paz"
   clientheight    =   3285
   clientleft      =   0
   clienttop       =   -105
   clientwidth     =   5070
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
   scaleheight     =   219
   scalemode       =   3  'pixel
   scalewidth      =   338
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.listbox lista 
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
      itemdata        =   "frmpeaceprop.frx":0000
      left            =   240
      list            =   "frmpeaceprop.frx":0002
      tabindex        =   0
      top             =   600
      width           =   4620
   end
   begin vb.image imgrechazar 
      height          =   480
      left            =   3840
      top             =   2520
      width           =   960
   end
   begin vb.image imgaceptar 
      height          =   480
      left            =   2640
      top             =   2520
      width           =   960
   end
   begin vb.image imgdetalle 
      height          =   480
      left            =   1440
      top             =   2520
      width           =   960
   end
   begin vb.image imgcerrar 
      height          =   480
      left            =   240
      top             =   2520
      width           =   960
   end
end
attribute vb_name = "frmpeaceprop"
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

private cbotonaceptar as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton
private cbotondetalles as clsgraphicalbutton
private cbotonrechazar as clsgraphicalbutton

public lastpressed as clsgraphicalbutton


private tipoprop as tipo_propuesta

public enum tipo_propuesta
    alianza = 1
    paz = 2
end enum


private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    call loadbackground
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonaceptar = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    set cbotondetalles = new clsgraphicalbutton
    set cbotonrechazar = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotonaceptar.initialize(imgaceptar, grhpath & "botonaceptaroferta.jpg", _
                                    grhpath & "botonaceptarrolloveroferta.jpg", _
                                    grhpath & "botonaceptarclickoferta.jpg", me)

    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerraroferta.jpg", _
                                    grhpath & "botoncerrarrolloveroferta.jpg", _
                                    grhpath & "botoncerrarclickoferta.jpg", me)

    call cbotondetalles.initialize(imgdetalle, grhpath & "botondetallesoferta.jpg", _
                                    grhpath & "botondetallesrolloveroferta.jpg", _
                                    grhpath & "botondetallesclickoferta.jpg", me)

    call cbotonrechazar.initialize(imgrechazar, grhpath & "botonrechazaroferta.jpg", _
                                    grhpath & "botonrechazarrolloveroferta.jpg", _
                                    grhpath & "botonrechazarclickoferta.jpg", me)


end sub

private sub loadbackground()
    if tipoprop = tipo_propuesta.alianza then
        me.picture = loadpicture(dirgraficos & "ventanaofertaalianza.jpg")
    else
        me.picture = loadpicture(dirgraficos & "ventanaofertapaz.jpg")
    end if
end sub

public property let proposaltype(byval nvalue as tipo_propuesta)
    tipoprop = nvalue
end property

private sub imgaceptar_click()

    if tipoprop = paz then
        call writeguildacceptpeace(lista.list(lista.listindex))
    else
        call writeguildacceptalliance(lista.list(lista.listindex))
    end if
    
    me.hide
    
    unload me

end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgdetalle_click()
    if tipoprop = paz then
        call writeguildpeacedetails(lista.list(lista.listindex))
    else
        call writeguildalliancedetails(lista.list(lista.listindex))
    end if
end sub

private sub imgrechazar_click()

    if tipoprop = paz then
        call writeguildrejectpeace(lista.list(lista.listindex))
    else
        call writeguildrejectalliance(lista.list(lista.listindex))
    end if
    
    me.hide
    
    unload me
end sub
