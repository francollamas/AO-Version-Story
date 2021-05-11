version 5.00
begin vb.form frmcommet 
   borderstyle     =   0  'none
   caption         =   "oferta de paz o alianza"
   clientheight    =   3270
   clientleft      =   0
   clienttop       =   -105
   clientwidth     =   5055
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
   scaleheight     =   218
   scalemode       =   3  'pixel
   scalewidth      =   337
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox text1 
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
      height          =   1935
      left            =   240
      multiline       =   -1  'true
      tabindex        =   0
      top             =   480
      width           =   4575
   end
   begin vb.image imgcerrar 
      height          =   480
      left            =   2880
      top             =   2520
      width           =   960
   end
   begin vb.image imgenviar 
      height          =   480
      left            =   1080
      top             =   2520
      width           =   960
   end
end
attribute vb_name = "frmcommet"
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
private const max_proposal_length as integer = 520

private cbotonenviar as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

public nombre as string

public t as tipo

public enum tipo
    alianza = 1
    paz = 2
    rechazopj = 3
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

    set cbotonenviar = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotonenviar.initialize(imgenviar, grhpath & "botonenviarsolicitud.jpg", _
                                    grhpath & "botonenviarrolloversolicitud.jpg", _
                                    grhpath & "botonenviarclicksolicitud.jpg", me)

    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarsolicitud.jpg", _
                                    grhpath & "botoncerrarrolloversolicitud.jpg", _
                                    grhpath & "botoncerrarclicksolicitud.jpg", me)
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgenviar_click()

    if text1 = "" then
        if t = paz or t = alianza then
            msgbox "debes redactar un mensaje solicitando la paz o alianza al l�der de " & nombre
        else
            msgbox "debes indicar el motivo por el cual rechazas la membres�a de " & nombre
        end if
        
        exit sub
    end if
    
    if t = paz then
        call writeguildofferpeace(nombre, replace(text1, vbcrlf, "�"))
        
    elseif t = alianza then
        call writeguildofferalliance(nombre, replace(text1, vbcrlf, "�"))
        
    elseif t = rechazopj then
        call writeguildrejectnewmember(nombre, replace(replace(text1.text, ",", " "), vbcrlf, " "))
        'sacamos el char de la lista de aspirantes
        dim i as long
        
        for i = 0 to frmguildleader.solicitudes.listcount - 1
            if frmguildleader.solicitudes.list(i) = nombre then
                frmguildleader.solicitudes.removeitem i
                exit for
            end if
        next i
        
        me.hide
        unload frmcharinfo
    end if
    
    unload me

end sub

private sub text1_change()
    if len(text1.text) > max_proposal_length then _
        text1.text = left$(text1.text, max_proposal_length)
end sub

private sub loadbackground()

    select case t
        case tipo.alianza
            me.picture = loadpicture(dirgraficos & "ventanapropuestaalianza.jpg")
            
        case tipo.paz
            me.picture = loadpicture(dirgraficos & "ventanapropuestapaz.jpg")
            
        case tipo.rechazopj
            me.picture = loadpicture(dirgraficos & "ventanamotivorechazo.jpg")
            
    end select
    
end sub

private sub text1_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub
