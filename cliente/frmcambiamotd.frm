version 5.00
begin vb.form frmcambiamotd 
   borderstyle     =   0  'none
   caption         =   """zmotd"""
   clientheight    =   5415
   clientleft      =   0
   clienttop       =   -105
   clientwidth     =   5175
   clipcontrols    =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   361
   scalemode       =   3  'pixel
   scalewidth      =   345
   showintaskbar   =   0   'false
   startupposition =   3  'windows default
   begin vb.textbox txtmotd 
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
      height          =   2250
      left            =   435
      multiline       =   -1  'true
      scrollbars      =   3  'both
      tabindex        =   0
      top             =   795
      width           =   4290
   end
   begin vb.image imgoptcursiva 
      height          =   255
      index           =   1
      left            =   3360
      top             =   4320
      width           =   615
   end
   begin vb.image imgoptnegrita 
      height          =   255
      index           =   1
      left            =   1440
      top             =   4320
      width           =   615
   end
   begin vb.image imgoptcursiva 
      height          =   195
      index           =   0
      left            =   3060
      top             =   4380
      width           =   180
   end
   begin vb.image imgoptnegrita 
      height          =   195
      index           =   0
      left            =   1170
      top             =   4380
      width           =   180
   end
   begin vb.image imgaceptar 
      height          =   375
      left            =   480
      top             =   4800
      width           =   4350
   end
   begin vb.image imgmarron 
      height          =   375
      left            =   3720
      top             =   3720
      width           =   855
   end
   begin vb.image imgverde 
      height          =   375
      left            =   2640
      top             =   3720
      width           =   855
   end
   begin vb.image imgmorado 
      height          =   375
      left            =   1560
      top             =   3720
      width           =   855
   end
   begin vb.image imgamarillo 
      height          =   375
      left            =   480
      top             =   3720
      width           =   855
   end
   begin vb.image imggris 
      height          =   375
      left            =   3720
      top             =   3240
      width           =   855
   end
   begin vb.image imgblanco 
      height          =   375
      left            =   2640
      top             =   3240
      width           =   855
   end
   begin vb.image imgrojo 
      height          =   375
      left            =   1560
      top             =   3240
      width           =   855
   end
   begin vb.image imgazul 
      height          =   375
      left            =   480
      top             =   3240
      width           =   855
   end
end
attribute vb_name = "frmcambiamotd"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmcambiarmotd.frm
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

private cbotonazul as clsgraphicalbutton
private cbotonrojo as clsgraphicalbutton
private cbotonblanco as clsgraphicalbutton
private cbotongris as clsgraphicalbutton
private cbotonamarillo as clsgraphicalbutton
private cbotonmorado as clsgraphicalbutton
private cbotonverde as clsgraphicalbutton
private cbotonmarron as clsgraphicalbutton
private cbotonaceptar as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private picnegrita as picture
private piccursiva as picture

private ynegrita as byte
private ycursiva as byte

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(dirgraficos & "ventanacambiomotd.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonazul = new clsgraphicalbutton
    set cbotonrojo = new clsgraphicalbutton
    set cbotonblanco = new clsgraphicalbutton
    set cbotongris = new clsgraphicalbutton
    set cbotonamarillo = new clsgraphicalbutton
    set cbotonmorado = new clsgraphicalbutton
    set cbotonverde = new clsgraphicalbutton
    set cbotonmarron = new clsgraphicalbutton
    set cbotonaceptar = new clsgraphicalbutton
    
    set lastbuttonpressed = new clsgraphicalbutton
    
    
    call cbotonazul.initialize(imgazul, grhpath & "botonazul.jpg", _
                                    grhpath & "botonazulrollover.jpg", _
                                    grhpath & "botonazulclick.jpg", me)

    call cbotonrojo.initialize(imgrojo, grhpath & "botonrojo.jpg", _
                                    grhpath & "botonrojorollover.jpg", _
                                    grhpath & "botonrojoclick.jpg", me)

    call cbotonblanco.initialize(imgblanco, grhpath & "botonblanco.jpg", _
                                    grhpath & "botonblancorollover.jpg", _
                                    grhpath & "botonblancoclick.jpg", me)

    call cbotongris.initialize(imggris, grhpath & "botongris.jpg", _
                                    grhpath & "botongrisrollover.jpg", _
                                    grhpath & "botongrisclick.jpg", me)
                                    
    call cbotonamarillo.initialize(imgamarillo, grhpath & "botonamarillo.jpg", _
                                    grhpath & "botonamarillorollover.jpg", _
                                    grhpath & "botonamarilloclick.jpg", me)

    call cbotonmorado.initialize(imgmorado, grhpath & "botonmorado.jpg", _
                                    grhpath & "botonmoradorollover.jpg", _
                                    grhpath & "botonmoradoclick.jpg", me)

    call cbotonverde.initialize(imgverde, grhpath & "botonverde.jpg", _
                                    grhpath & "botonverderollover.jpg", _
                                    grhpath & "botonverdeclick.jpg", me)

    call cbotonmarron.initialize(imgmarron, grhpath & "botonmarron.jpg", _
                                    grhpath & "botonmarronrollover.jpg", _
                                    grhpath & "botonmarronclick.jpg", me)

    call cbotonaceptar.initialize(imgaceptar, grhpath & "botonaceptarmotd.jpg", _
                                    grhpath & "botonaceptarrollovermotd.jpg", _
                                    grhpath & "botonaceptarclickmotd.jpg", me)
                                    
    set picnegrita = loadpicture(dirgraficos & "opcionprendidan.jpg")
    set piccursiva = loadpicture(dirgraficos & "opcionprendidac.jpg")
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgaceptar_click()
    dim t() as string
    dim i as long, n as long, pos as long
    
    if len(txtmotd.text) >= 2 then
        if right$(txtmotd.text, 2) = vbcrlf then txtmotd.text = left$(txtmotd.text, len(txtmotd.text) - 2)
    end if
    
    t = split(txtmotd.text, vbcrlf)
    
    for i = lbound(t) to ubound(t)
        n = 0
        pos = instr(1, t(i), "~")
        do while pos > 0 and pos < len(t(i))
            n = n + 1
            pos = instr(pos + 1, t(i), "~")
        loop
        if n <> 5 then
            msgbox "error en el formato de la linea " & i + 1 & "."
            exit sub
        end if
    next i
    
    call writesetmotd(txtmotd.text)
    unload me

end sub

private sub imgamarillo_click()
    txtmotd.text = txtmotd & "~244~244~0~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub

private sub imgazul_click()
    txtmotd.text = txtmotd & "~50~70~250~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub

private sub imgblanco_click()
    txtmotd.text = txtmotd & "~255~255~255~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub

private sub imggris_click()
    txtmotd.text = txtmotd & "~157~157~157~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub

private sub imgmarron_click()
    txtmotd.text = txtmotd & "~97~58~31~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub

private sub imgmorado_click()
    txtmotd.text = txtmotd & "~128~0~128~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub

private sub imgoptcursiva_click(index as integer)
    
    if ycursiva = 0 then
        imgoptcursiva(0).picture = piccursiva
        ycursiva = 1
    else
        set imgoptcursiva(0).picture = nothing
        ycursiva = 0
    end if

end sub

private sub imgoptcursiva_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgoptnegrita_click(index as integer)
    
    if ynegrita = 0 then
        imgoptnegrita(0).picture = picnegrita
        ynegrita = 1
    else
        set imgoptnegrita(0).picture = nothing
        ynegrita = 0
    end if
    
end sub

private sub imgoptnegrita_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub imgrojo_click()
    txtmotd.text = txtmotd & "~255~0~0~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub

private sub imgverde_click()
    txtmotd.text = txtmotd & "~23~104~26~" & cstr(ynegrita) & "~" & cstr(ycursiva)
end sub
