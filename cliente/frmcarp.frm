version 5.00
begin vb.form frmcarp 
   backcolor       =   &h8000000b&
   borderstyle     =   0  'none
   caption         =   "carpintero"
   clientheight    =   5430
   clientleft      =   0
   clienttop       =   -105
   clientwidth     =   6705
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   362
   scalemode       =   3  'pixel
   scalewidth      =   447
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.picturebox picupgrade 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   4
      left            =   5430
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   14
      top             =   3930
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picupgrade 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   3
      left            =   5430
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   13
      top             =   3135
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picupgrade 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   2
      left            =   5430
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   12
      top             =   2340
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picupgrade 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   1
      left            =   5430
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   11
      top             =   1545
      visible         =   0   'false
      width           =   480
   end
   begin vb.textbox txtcantitems 
      alignment       =   2  'center
      appearance      =   0  'flat
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
      height          =   285
      left            =   5175
      maxlength       =   6
      tabindex        =   1
      text            =   "1"
      tooltiptext     =   "ingrese la cantidad total de items a construir."
      top             =   2925
      width           =   1050
   end
   begin vb.combobox cboitemsciclo 
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
      height          =   315
      left            =   5400
      style           =   2  'dropdown list
      tabindex        =   2
      top             =   4080
      width           =   735
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   1
      left            =   870
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   10
      top             =   1545
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picmaderas0 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   64
      tabindex        =   9
      top             =   1545
      visible         =   0   'false
      width           =   960
   end
   begin vb.vscrollbar scroll 
      height          =   3135
      left            =   450
      tabindex        =   0
      top             =   1410
      visible         =   0   'false
      width           =   255
   end
   begin vb.picturebox picmaderas1 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   64
      tabindex        =   8
      top             =   2340
      visible         =   0   'false
      width           =   960
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   2
      left            =   870
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   7
      top             =   2340
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picmaderas2 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   64
      tabindex        =   6
      top             =   3135
      visible         =   0   'false
      width           =   960
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   3
      left            =   870
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   5
      top             =   3135
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picmaderas3 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   64
      tabindex        =   4
      top             =   3930
      visible         =   0   'false
      width           =   960
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   4
      left            =   870
      scaleheight     =   32
      scalemode       =   3  'pixel
      scalewidth      =   32
      tabindex        =   3
      top             =   3930
      visible         =   0   'false
      width           =   480
   end
   begin vb.image imgcantidadciclo 
      height          =   645
      left            =   5160
      top             =   3435
      width           =   1110
   end
   begin vb.image imgpestania 
      height          =   255
      index           =   1
      left            =   1680
      mousepointer    =   99  'custom
      top             =   480
      width           =   1215
   end
   begin vb.image imgpestania 
      height          =   255
      index           =   0
      left            =   720
      mousepointer    =   99  'custom
      top             =   480
      width           =   975
   end
   begin vb.image imgmarcoupgrade 
      height          =   780
      index           =   4
      left            =   5280
      top             =   3780
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcoupgrade 
      height          =   780
      index           =   3
      left            =   5280
      top             =   2985
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcoupgrade 
      height          =   780
      index           =   2
      left            =   5280
      top             =   2190
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcoupgrade 
      height          =   780
      index           =   1
      left            =   5280
      top             =   1395
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcomaderas 
      height          =   780
      index           =   4
      left            =   1560
      top             =   3780
      visible         =   0   'false
      width           =   1260
   end
   begin vb.image imgmarcomaderas 
      height          =   780
      index           =   3
      left            =   1560
      top             =   2985
      visible         =   0   'false
      width           =   1260
   end
   begin vb.image imgmarcomaderas 
      height          =   780
      index           =   2
      left            =   1560
      top             =   2190
      visible         =   0   'false
      width           =   1260
   end
   begin vb.image imgmarcomaderas 
      height          =   780
      index           =   1
      left            =   1560
      top             =   1395
      visible         =   0   'false
      width           =   1260
   end
   begin vb.image imgmarcoitem 
      height          =   780
      index           =   4
      left            =   720
      top             =   3780
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcoitem 
      height          =   780
      index           =   3
      left            =   720
      top             =   2985
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcoitem 
      height          =   780
      index           =   2
      left            =   720
      top             =   2190
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcoitem 
      height          =   780
      index           =   1
      left            =   720
      top             =   1395
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgcerrar 
      height          =   360
      left            =   2760
      top             =   4650
      width           =   1455
   end
   begin vb.image imgconstruir3 
      height          =   420
      left            =   3150
      top             =   3960
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgconstruir2 
      height          =   420
      left            =   3150
      top             =   3180
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgconstruir1 
      height          =   420
      left            =   3150
      top             =   2370
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgconstruir0 
      height          =   420
      left            =   3150
      top             =   1560
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgchkmacro 
      height          =   420
      left            =   5415
      mousepointer    =   99  'custom
      top             =   1860
      width           =   435
   end
   begin vb.image imgmejorar0 
      height          =   420
      left            =   3150
      top             =   1560
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgmejorar1 
      height          =   420
      left            =   3150
      top             =   2370
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgmejorar2 
      height          =   420
      left            =   3150
      top             =   3180
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgmejorar3 
      height          =   420
      left            =   3150
      top             =   3960
      visible         =   0   'false
      width           =   1710
   end
end
attribute vb_name = "frmcarp"
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

dim cargando as boolean
private clsformulario as clsformmovementmanager

private enum epestania
    ieitems
    iemejorar
end enum

private piccheck as picture
private picrecuadroitem as picture
private picrecuadromaderas as picture

private pestanias(1) as picture
private ultimapestania as byte

private cbotoncerrar as clsgraphicalbutton
private cbotonconstruir(0 to 4) as clsgraphicalbutton
private cbotonmejorar(0 to 4) as clsgraphicalbutton

public lastbuttonpressed as clsgraphicalbutton

private usarmacro as boolean

private sub form_load()
    
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    call loaddefaultvalues
    
    me.picture = loadpicture(app.path & "\graficos\ventanacarpinteriaitems.jpg")
    loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    dim index as long
    
    grhpath = dirgraficos

    set pestanias(epestania.ieitems) = loadpicture(grhpath & "ventanacarpinteriaitems.jpg")
    set pestanias(epestania.iemejorar) = loadpicture(grhpath & "ventanacarpinteriamejorar.jpg")
    
    set piccheck = loadpicture(grhpath & "checkboxcarpinteria.jpg")
    
    set picrecuadroitem = loadpicture(grhpath & "recuadroitemscarpinteria.jpg")
    set picrecuadromaderas = loadpicture(grhpath & "recuadromadera.jpg")
    
    for index = 1 to max_list_items
        imgmarcoitem(index).picture = picrecuadroitem
        imgmarcoupgrade(index).picture = picrecuadroitem
        imgmarcomaderas(index).picture = picrecuadromaderas
    next index
    
    set cbotoncerrar = new clsgraphicalbutton
    set cbotonconstruir(0) = new clsgraphicalbutton
    set cbotonconstruir(1) = new clsgraphicalbutton
    set cbotonconstruir(2) = new clsgraphicalbutton
    set cbotonconstruir(3) = new clsgraphicalbutton
    set cbotonmejorar(0) = new clsgraphicalbutton
    set cbotonmejorar(1) = new clsgraphicalbutton
    set cbotonmejorar(2) = new clsgraphicalbutton
    set cbotonmejorar(3) = new clsgraphicalbutton

    set lastbuttonpressed = new clsgraphicalbutton
    
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarcarpinteria.jpg", _
                                    grhpath & "botoncerrarrollovercarpinteria.jpg", _
                                    grhpath & "botoncerrarclickcarpinteria.jpg", me)
                                    
    call cbotonconstruir(0).initialize(imgconstruir0, grhpath & "botonconstruircarpinteria.jpg", _
                                    grhpath & "botonconstruirrollovercarpinteria.jpg", _
                                    grhpath & "botonconstruirclickcarpinteria.jpg", me)
                                    
    call cbotonconstruir(1).initialize(imgconstruir1, grhpath & "botonconstruircarpinteria.jpg", _
                                    grhpath & "botonconstruirrollovercarpinteria.jpg", _
                                    grhpath & "botonconstruirclickcarpinteria.jpg", me)
                                    
    call cbotonconstruir(2).initialize(imgconstruir2, grhpath & "botonconstruircarpinteria.jpg", _
                                    grhpath & "botonconstruirrollovercarpinteria.jpg", _
                                    grhpath & "botonconstruirclickcarpinteria.jpg", me)
                                    
    call cbotonconstruir(3).initialize(imgconstruir3, grhpath & "botonconstruircarpinteria.jpg", _
                                    grhpath & "botonconstruirrollovercarpinteria.jpg", _
                                    grhpath & "botonconstruirclickcarpinteria.jpg", me)
    
    call cbotonmejorar(0).initialize(imgmejorar0, grhpath & "botonmejorarcarpinteria.jpg", _
                                    grhpath & "botonmejorarrollovercarpinteria.jpg", _
                                    grhpath & "botonmejorarclickcarpinteria.jpg", me)
    
    call cbotonmejorar(1).initialize(imgmejorar1, grhpath & "botonmejorarcarpinteria.jpg", _
                                    grhpath & "botonmejorarrollovercarpinteria.jpg", _
                                    grhpath & "botonmejorarclickcarpinteria.jpg", me)
    
    call cbotonmejorar(2).initialize(imgmejorar2, grhpath & "botonmejorarcarpinteria.jpg", _
                                    grhpath & "botonmejorarrollovercarpinteria.jpg", _
                                    grhpath & "botonmejorarclickcarpinteria.jpg", me)
    
    call cbotonmejorar(3).initialize(imgmejorar3, grhpath & "botonmejorarcarpinteria.jpg", _
                                    grhpath & "botonmejorarrollovercarpinteria.jpg", _
                                    grhpath & "botonmejorarclickcarpinteria.jpg", me)
                                    
    imgcantidadciclo.picture = loadpicture(grhpath & "construirporciclo.jpg")
    
    imgchkmacro.picture = piccheck
    
    imgpestania(epestania.ieitems).mouseicon = picmouseicon
    imgpestania(epestania.iemejorar).mouseicon = picmouseicon
    
    imgchkmacro.mouseicon = picmouseicon
end sub

private sub loaddefaultvalues()
    
    dim maxconstitem as integer
    dim i as integer

    cargando = true
    
    maxconstitem = cint((userlvl - 2) * 0.2)
    maxconstitem = iif(maxconstitem < 1, 1, maxconstitem)
    maxconstitem = iif(userclase = eclass.worker, maxconstitem, 1)
    
    for i = 1 to maxconstitem
        cboitemsciclo.additem i
    next i
    
    cboitemsciclo.listindex = 0
    
    scroll.value = 0
    
    usarmacro = true
    
    ultimapestania = epestania.ieitems
    
    cargando = false
end sub


private sub construir(byval index as integer)

    dim itemindex as integer
    dim cantitemsciclo as integer
    
    if scroll.visible = true then itemindex = scroll.value
    itemindex = itemindex + index
    
    select case ultimapestania
        case epestania.ieitems
        
            if usarmacro then
                cantitemsciclo = val(cboitemsciclo.text)
                macrobltindex = objcarpintero(itemindex).objindex
                frmmain.activarmacrotrabajo
            else
                ' que cosntruya el maximo, total si sobra no importa, valida el server
                cantitemsciclo = val(cboitemsciclo.list(cboitemsciclo.listcount - 1))
            end if
            
            call writeinitcrafting(val(txtcantitems.text), cantitemsciclo)
            call writecraftcarpenter(objcarpintero(itemindex).objindex)
            
        case epestania.iemejorar
            call writeitemupgrade(carpinteromejorar(itemindex).objindex)
    end select
        
    unload me

end sub

public sub hideextracontrols(byval numitems as integer, optional byval upgrading as boolean = false)
    dim i as integer
    
    picmaderas0.visible = (numitems >= 1)
    picmaderas1.visible = (numitems >= 2)
    picmaderas2.visible = (numitems >= 3)
    picmaderas3.visible = (numitems >= 4)
    
    imgconstruir0.visible = (numitems >= 1 and not upgrading)
    imgconstruir1.visible = (numitems >= 2 and not upgrading)
    imgconstruir2.visible = (numitems >= 3 and not upgrading)
    imgconstruir3.visible = (numitems >= 4 and not upgrading)
    
    imgmejorar0.visible = (numitems >= 1 and upgrading)
    imgmejorar1.visible = (numitems >= 2 and upgrading)
    imgmejorar2.visible = (numitems >= 3 and upgrading)
    imgmejorar3.visible = (numitems >= 4 and upgrading)

    
    for i = 1 to max_list_items
        picitem(i).visible = (numitems >= i)
        imgmarcoitem(i).visible = (numitems >= i)
        imgmarcomaderas(i).visible = (numitems >= i)

        ' upgrade
        imgmarcoupgrade(i).visible = (numitems >= i and upgrading)
        picupgrade(i).visible = (numitems >= i and upgrading)
    next i
    
    if numitems > max_list_items then
        scroll.visible = true
        cargando = true
        scroll.max = numitems - max_list_items
        cargando = false
    else
        scroll.visible = false
    end if
    
    txtcantitems.visible = not upgrading
    cboitemsciclo.visible = not upgrading and usarmacro
    imgchkmacro.visible = not upgrading
    imgcantidadciclo.visible = not upgrading and usarmacro
end sub

private sub renderitem(byref pic as picturebox, byval grhindex as long)
    dim sr as rect
    dim dr as rect
    
    with grhdata(grhindex)
        sr.left = .sx
        sr.top = .sy
        sr.right = sr.left + .pixelwidth
        sr.bottom = sr.top + .pixelheight
    end with
    
    dr.left = 0
    dr.top = 0
    dr.right = 32
    dr.bottom = 32
    
    call drawgrhtohdc(pic.hdc, grhindex, sr, dr)
    pic.refresh
end sub

public sub renderlist(byval inicio as integer)
dim i as long
dim numitems as integer

numitems = ubound(objcarpintero)
inicio = inicio - 1

for i = 1 to max_list_items
    if i + inicio <= numitems then
        with objcarpintero(i + inicio)
            ' agrego el item
            call renderitem(picitem(i), .grhindex)
            picitem(i).tooltiptext = .name
        
            ' inventario de le�os
            call invmaderascarpinteria(i).setitem(1, 0, .madera, 0, madera_grh, 0, 0, 0, 0, 0, 0, "le�a")
            call invmaderascarpinteria(i).setitem(2, 0, .maderaelfica, 0, madera_elfica_grh, 0, 0, 0, 0, 0, 0, "le�a �lfica")
        end with
    end if
next i
end sub

public sub renderupgradelist(byval inicio as integer)
dim i as long
dim numitems as integer

numitems = ubound(carpinteromejorar)
inicio = inicio - 1

for i = 1 to max_list_items
    if i + inicio <= numitems then
        with carpinteromejorar(i + inicio)
            ' agrego el item
            call renderitem(picitem(i), .grhindex)
            picitem(i).tooltiptext = .name
            
            call renderitem(picupgrade(i), .upgradegrhindex)
            picupgrade(i).tooltiptext = .upgradename
        
            ' inventario de le�os
            call invmaderascarpinteria(i).setitem(1, 0, .madera, 0, madera_grh, 0, 0, 0, 0, 0, 0, "le�a")
            call invmaderascarpinteria(i).setitem(2, 0, .maderaelfica, 0, madera_elfica_grh, 0, 0, 0, 0, 0, 0, "le�a �lfica")
        end with
    end if
next i
end sub


private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub form_unload(cancel as integer)
    dim i as long
    
    for i = 1 to max_list_items
        set invmaderascarpinteria(i) = nothing
    next i

    mirandocarpinteria = false
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imgchkmacro_click()
    usarmacro = not usarmacro
    
    if usarmacro then
        imgchkmacro.picture = piccheck
    else
        set imgchkmacro.picture = nothing
    end if
    
    cboitemsciclo.visible = usarmacro
    imgcantidadciclo.visible = usarmacro
end sub

private sub imgconstruir0_click()
    call construir(1)
end sub

private sub imgconstruir1_click()
    call construir(2)
end sub

private sub imgconstruir2_click()
    call construir(3)
end sub

private sub imgconstruir3_click()
    call construir(4)
end sub

private sub imgmejorar0_click()
    call construir(1)
end sub

private sub imgmejorar1_click()
    call construir(2)
end sub

private sub imgmejorar2_click()
    call construir(3)
end sub

private sub imgmejorar3_click()
    call construir(4)
end sub

private sub imgpestania_click(index as integer)
    dim i as integer
    dim numitems as integer
    
    if cargando then exit sub
    if ultimapestania = index then exit sub
    
    scroll.value = 0
    
    select case index
        case epestania.ieitems
            ' background
            me.picture = pestanias(epestania.ieitems)
            
            numitems = ubound(objcarpintero)
        
            call hideextracontrols(numitems)
            
            ' cargo inventarios e imagenes
            call renderlist(1)
            

        case epestania.iemejorar
            ' background
            me.picture = pestanias(epestania.iemejorar)
            
            numitems = ubound(carpinteromejorar)
            
            call hideextracontrols(numitems, true)
            
            call renderupgradelist(1)
    end select

    ultimapestania = index

end sub

private sub scroll_change()
    dim i as long
    
    if cargando then exit sub
    
    i = scroll.value
    ' cargo inventarios e imagenes
    
    select case ultimapestania
        case epestania.ieitems
            call renderlist(i + 1)
        case epestania.iemejorar
            call renderupgradelist(i + 1)
    end select
end sub
