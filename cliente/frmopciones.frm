version 5.00
object = "{831fdd16-0c5c-11d2-a9fc-0000f8754da1}#2.0#0"; "mscomctl.ocx"
begin vb.form frmopciones 
   backcolor       =   &h8000000a&
   borderstyle     =   0  'none
   clientheight    =   7185
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   4830
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
   icon            =   "frmopciones.frx":0000
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   479
   scalemode       =   3  'pixel
   scalewidth      =   322
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txtcantmensajes 
      alignment       =   2  'center
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
      height          =   255
      left            =   2340
      maxlength       =   1
      tabindex        =   3
      text            =   "5"
      top             =   2415
      width           =   255
   end
   begin vb.textbox txtlevel 
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
      height          =   255
      left            =   3480
      maxlength       =   2
      tabindex        =   2
      text            =   "40"
      top             =   4110
      width           =   255
   end
   begin mscomctllib.slider slider1 
      height          =   255
      index           =   0
      left            =   1380
      tabindex        =   0
      top             =   960
      width           =   3015
      _extentx        =   5318
      _extenty        =   450
      _version        =   393216
      borderstyle     =   1
      max             =   100
      tickstyle       =   3
   end
   begin mscomctllib.slider slider1 
      height          =   255
      index           =   1
      left            =   1380
      tabindex        =   1
      top             =   1260
      width           =   3015
      _extentx        =   5318
      _extenty        =   450
      _version        =   393216
      borderstyle     =   1
      largechange     =   10
      max             =   100
      tickstyle       =   3
   end
   begin vb.image imgchkdesactivarfragshooter 
      height          =   225
      left            =   435
      top             =   4740
      width           =   210
   end
   begin vb.image imgchkalmorir 
      height          =   225
      left            =   435
      top             =   4425
      width           =   210
   end
   begin vb.image imgchkrequiredlvl 
      height          =   225
      left            =   435
      top             =   4110
      width           =   210
   end
   begin vb.image imgchknomostrarnews 
      height          =   225
      left            =   2475
      top             =   3315
      width           =   210
   end
   begin vb.image imgchkmostrarnews 
      height          =   225
      left            =   435
      top             =   3315
      width           =   210
   end
   begin vb.image imgchkpantalla 
      height          =   225
      left            =   1950
      top             =   2430
      width           =   210
   end
   begin vb.image imgchkconsola 
      height          =   225
      left            =   435
      top             =   2430
      width           =   210
   end
   begin vb.image imgchkefectossonido 
      height          =   225
      left            =   435
      top             =   1545
      width           =   210
   end
   begin vb.image imgchksonidos 
      height          =   225
      left            =   435
      top             =   1260
      width           =   210
   end
   begin vb.image imgchkmusica 
      height          =   225
      left            =   435
      top             =   990
      width           =   210
   end
   begin vb.image imgtutorial 
      height          =   285
      left            =   2520
      top             =   6240
      width           =   2010
   end
   begin vb.image imgsoporte 
      height          =   285
      left            =   360
      top             =   6240
      width           =   2010
   end
   begin vb.image imgradio 
      height          =   285
      left            =   2520
      top             =   5880
      width           =   2010
   end
   begin vb.image imgmanual 
      height          =   285
      left            =   360
      top             =   5880
      width           =   2010
   end
   begin vb.image imgcambiarpasswd 
      height          =   285
      left            =   2520
      top             =   5520
      width           =   2010
   end
   begin vb.image imgmapa 
      height          =   285
      left            =   360
      top             =   5520
      width           =   2010
   end
   begin vb.image imgmsgpersonalizado 
      height          =   285
      left            =   2520
      top             =   5160
      width           =   2010
   end
   begin vb.image imgconfigteclas 
      height          =   285
      left            =   360
      top             =   5160
      width           =   2010
   end
   begin vb.image imgsalir 
      height          =   285
      left            =   1440
      top             =   6600
      width           =   2010
   end
end
attribute vb_name = "frmopciones"
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

private cbotonconfigteclas as clsgraphicalbutton
private cbotonmsgpersonalizado as clsgraphicalbutton
private cbotonmapa as clsgraphicalbutton
private cbotoncambiarpasswd as clsgraphicalbutton
private cbotonmanual as clsgraphicalbutton
private cbotonradio as clsgraphicalbutton
private cbotonsoporte as clsgraphicalbutton
private cbotontutorial as clsgraphicalbutton
private cbotonsalir as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

private piccheckbox as picture

private bmusicactivated as boolean
private bsoundactivated as boolean
private bsoundeffectsactivated as boolean

private loading as boolean

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub imgcambiarpasswd_click()
    call frmnewpassword.show(vbmodal, me)
end sub

private sub imgchkalmorir_click()
    clientsetup.bdie = not clientsetup.bdie
    
    if clientsetup.bdie then
        imgchkalmorir.picture = piccheckbox
    else
        set imgchkalmorir.picture = nothing
    end if
end sub

private sub imgchkdesactivarfragshooter_click()
    clientsetup.bactive = not clientsetup.bactive
    
    if clientsetup.bactive then
        set imgchkdesactivarfragshooter.picture = nothing
    else
        imgchkdesactivarfragshooter.picture = piccheckbox
    end if
end sub

private sub imgchkrequiredlvl_click()
    clientsetup.bkill = not clientsetup.bkill
    
    if clientsetup.bkill then
        imgchkrequiredlvl.picture = piccheckbox
    else
        set imgchkrequiredlvl.picture = nothing
    end if
end sub

private sub txtcantmensajes_change()
    txtcantmensajes.text = val(txtcantmensajes.text)
    
    if txtcantmensajes.text > 0 then
        dialogosclanes.cantidaddialogos = txtcantmensajes.text
    else
        txtcantmensajes.text = 5
    end if
end sub

private sub txtlevel_change()
    if not isnumeric(txtlevel) then txtlevel = 0
    txtlevel = trim$(txtlevel)
    clientsetup.bymurderedlevel = cbyte(txtlevel)
end sub

private sub imgchkconsola_click()
    dialogosclanes.activo = false
    
    imgchkconsola.picture = piccheckbox
    set imgchkpantalla.picture = nothing
end sub

private sub imgchkefectossonido_click()

    if loading then exit sub
    
    call audio.playwave(snd_click)
        
    bsoundeffectsactivated = not bsoundeffectsactivated
    
    audio.soundeffectsactivated = bsoundeffectsactivated
    
    if bsoundeffectsactivated then
        imgchkefectossonido.picture = piccheckbox
    else
        set imgchkefectossonido.picture = nothing
    end if
            
end sub

private sub imgchkmostrarnews_click()
    clientsetup.bguildnews = true
    
    imgchkmostrarnews.picture = piccheckbox
    set imgchknomostrarnews.picture = nothing
end sub

private sub imgchkmusica_click()

    if loading then exit sub
    
    call audio.playwave(snd_click)
    
    bmusicactivated = not bmusicactivated
            
    if not bmusicactivated then
        audio.musicactivated = false
        slider1(0).enabled = false
        set imgchkmusica.picture = nothing
    else
        if not audio.musicactivated then  'prevent the music from reloading
            audio.musicactivated = true
            slider1(0).enabled = true
            slider1(0).value = audio.musicvolume
        end if
        
        imgchkmusica.picture = piccheckbox
    end if

end sub

private sub imgchknomostrarnews_click()
    clientsetup.bguildnews = false
    
    imgchknomostrarnews.picture = piccheckbox
    set imgchkmostrarnews.picture = nothing
end sub

private sub imgchkpantalla_click()
    dialogosclanes.activo = true
    
    imgchkpantalla.picture = piccheckbox
    set imgchkconsola.picture = nothing
end sub

private sub imgchksonidos_click()

    if loading then exit sub
    
    call audio.playwave(snd_click)
    
    bsoundactivated = not bsoundactivated
    
    if not bsoundactivated then
        audio.soundactivated = false
        rainbufferindex = 0
        frmmain.isplaying = playloop.plnone
        slider1(1).enabled = false
        
        set imgchksonidos.picture = nothing
    else
        audio.soundactivated = true
        slider1(1).enabled = true
        slider1(1).value = audio.soundvolume
        
        imgchksonidos.picture = piccheckbox
    end if
end sub

private sub imgconfigteclas_click()
    if not loading then _
        call audio.playwave(snd_click)
    call frmcustomkeys.show(vbmodal, me)
end sub

private sub imgmanual_click()
    if not loading then _
        call audio.playwave(snd_click)
    call shellexecute(0, "open", "http://ao.alkon.com.ar/manual/", "", app.path, sw_shownormal)
end sub

private sub imgmapa_click()
    call frmmapa.show(vbmodal, me)
end sub

private sub imgmsgpersonalizado_click()
    call frmmessagetxt.show(vbmodeless, me)
end sub

private sub imgradio_click()
    if not loading then _
        call audio.playwave(snd_click)

    call shellexecute(0, "open", "http://www.radioargentum.com/repro.html", "", app.path, sw_shownormal)
end sub

private sub imgsalir_click()
    unload me
    frmmain.setfocus
end sub

private sub imgsoporte_click()
    
    if not loading then _
        call audio.playwave(snd_click)
    
    call shellexecute(0, "open", "http://www.aostaff.com.ar/soporte/", "", app.path, sw_shownormal)
end sub

private sub imgtutorial_click()
    frmtutorial.show
end sub

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanaopciones.jpg")
    loadbuttons
    
    loading = true      'prevent sounds when setting check's values
    loaduserconfig
    loading = false     'enable sounds when setting check's values
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonconfigteclas = new clsgraphicalbutton
    set cbotonmsgpersonalizado = new clsgraphicalbutton
    set cbotonmapa = new clsgraphicalbutton
    set cbotoncambiarpasswd = new clsgraphicalbutton
    set cbotonmanual = new clsgraphicalbutton
    set cbotonradio = new clsgraphicalbutton
    set cbotonsoporte = new clsgraphicalbutton
    set cbotontutorial = new clsgraphicalbutton
    set cbotonsalir = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    call cbotonconfigteclas.initialize(imgconfigteclas, grhpath & "botonconfigurarteclas.jpg", _
                                    grhpath & "botonconfigurarteclasrollover.jpg", _
                                    grhpath & "botonconfigurarteclasclick.jpg", me)
                                    
    call cbotonmsgpersonalizado.initialize(imgmsgpersonalizado, grhpath & "botonmsgpersonalizadoteclas.jpg", _
                                    grhpath & "botonmsgpersonalizadorollover.jpg", _
                                    grhpath & "botonmsgpersonalizadoclick.jpg", me)
                                    
    call cbotonmapa.initialize(imgmapa, grhpath & "botonmapaao.jpg", _
                                    grhpath & "botonmapaaorollover.jpg", _
                                    grhpath & "botonmapaaoclick.jpg", me)
                                    
    call cbotoncambiarpasswd.initialize(imgcambiarpasswd, grhpath & "botoncambiarcontrasenia.jpg", _
                                    grhpath & "botoncambiarcontraseniarollover.jpg", _
                                    grhpath & "botoncambiarcontraseniaclick.jpg", me)
                                    
    call cbotonmanual.initialize(imgmanual, grhpath & "botonmanualao.jpg", _
                                    grhpath & "botonmanualaorollover.jpg", _
                                    grhpath & "botonmanualaoclick.jpg", me)
                                    
    call cbotonradio.initialize(imgradio, grhpath & "botonescucharradioao.jpg", _
                                    grhpath & "botonescucharradioaorollover.jpg", _
                                    grhpath & "botonescucharradioaoclick.jpg", me)
                                    
    call cbotonsoporte.initialize(imgsoporte, grhpath & "botonsoporte.jpg", _
                                    grhpath & "botonsoporterollover.jpg", _
                                    grhpath & "botonsoporteclick.jpg", me)
                                    
    call cbotontutorial.initialize(imgtutorial, grhpath & "botontutorial.jpg", _
                                    grhpath & "botontutorialrollover.jpg", _
                                    grhpath & "botontutorialclick.jpg", me)
                                    
    call cbotonsalir.initialize(imgsalir, grhpath & "botonsaliropciones.jpg", _
                                    grhpath & "botonsalirrolloveropciones.jpg", _
                                    grhpath & "botonsalirclickopciones.jpg", me)
                                    
    set piccheckbox = loadpicture(grhpath & "checkboxopciones.jpg")
end sub

private sub loaduserconfig()

    ' load music config
    bmusicactivated = audio.musicactivated
    slider1(0).enabled = bmusicactivated
    
    if bmusicactivated then
        imgchkmusica.picture = piccheckbox
        
        slider1(0).value = audio.musicvolume
    end if
    
    
    ' load sound config
    bsoundactivated = audio.soundactivated
    slider1(1).enabled = bsoundactivated
    
    if bsoundactivated then
        imgchksonidos.picture = piccheckbox
        
        slider1(1).value = audio.soundvolume
    end if
    
    
    ' load sound effects config
    bsoundeffectsactivated = audio.soundeffectsactivated
    if bsoundeffectsactivated then imgchkefectossonido.picture = piccheckbox
    
    txtcantmensajes.text = cstr(dialogosclanes.cantidaddialogos)
    
    if dialogosclanes.activo then
        imgchkpantalla.picture = piccheckbox
    else
        imgchkconsola.picture = piccheckbox
    end if
    
    if clientsetup.bguildnews then
        imgchkmostrarnews.picture = piccheckbox
    else
        imgchknomostrarnews.picture = piccheckbox
    end if
        
    if clientsetup.bkill then imgchkrequiredlvl.picture = piccheckbox
    if clientsetup.bdie then imgchkalmorir.picture = piccheckbox
    if not clientsetup.bactive then imgchkdesactivarfragshooter.picture = piccheckbox
    
    txtlevel = clientsetup.bymurderedlevel
end sub

private sub slider1_change(index as integer)
    select case index
        case 0
            audio.musicvolume = slider1(0).value
        case 1
            audio.soundvolume = slider1(1).value
    end select
end sub

private sub slider1_scroll(index as integer)
    select case index
        case 0
            audio.musicvolume = slider1(0).value
        case 1
            audio.soundvolume = slider1(1).value
    end select
end sub
