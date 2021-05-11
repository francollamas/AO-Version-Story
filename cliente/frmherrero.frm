version 5.00
begin vb.form frmherrero 
   backcolor       =   &h8000000a&
   borderstyle     =   0  'none
   caption         =   "herrero"
   clientheight    =   5385
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   6675
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   359
   scalemode       =   3  'pixel
   scalewidth      =   445
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txtcantitems 
      alignment       =   2  'center
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
      height          =   255
      left            =   5175
      maxlength       =   5
      tabindex        =   14
      text            =   "1"
      top             =   2940
      width           =   1050
   end
   begin vb.picturebox picupgradeitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   1
      left            =   5430
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   13
      top             =   1545
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picupgradeitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   2
      left            =   5400
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   12
      top             =   2340
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picupgradeitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   3
      left            =   5430
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   11
      top             =   3135
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox picupgradeitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   4
      left            =   5430
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   10
      top             =   3930
      visible         =   0   'false
      width           =   480
   end
   begin vb.combobox cboitemsciclo 
      backcolor       =   &h80000006&
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
      left            =   5325
      style           =   2  'dropdown list
      tabindex        =   1
      top             =   4080
      width           =   735
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   4
      left            =   870
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   9
      top             =   3930
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox piclingotes3 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   480
      scalewidth      =   1440
      tabindex        =   8
      top             =   3930
      visible         =   0   'false
      width           =   1440
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   3
      left            =   870
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   7
      top             =   3135
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox piclingotes2 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   480
      scalewidth      =   1440
      tabindex        =   6
      top             =   3135
      visible         =   0   'false
      width           =   1440
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   2
      left            =   870
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   5
      top             =   2340
      visible         =   0   'false
      width           =   480
   end
   begin vb.picturebox piclingotes1 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   480
      scalewidth      =   1440
      tabindex        =   4
      top             =   2340
      visible         =   0   'false
      width           =   1440
   end
   begin vb.vscrollbar scroll 
      height          =   3135
      left            =   450
      tabindex        =   0
      top             =   1410
      visible         =   0   'false
      width           =   255
   end
   begin vb.picturebox piclingotes0 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      left            =   1710
      scaleheight     =   480
      scalewidth      =   1440
      tabindex        =   3
      top             =   1545
      visible         =   0   'false
      width           =   1440
   end
   begin vb.picturebox picitem 
      autoredraw      =   -1  'true
      backcolor       =   &h00000000&
      borderstyle     =   0  'none
      fillstyle       =   0  'solid
      height          =   480
      index           =   1
      left            =   870
      scaleheight     =   480
      scalewidth      =   480
      tabindex        =   2
      top             =   1545
      visible         =   0   'false
      width           =   480
   end
   begin vb.image imgcantidadciclo 
      height          =   645
      left            =   5160
      top             =   3435
      width           =   1110
   end
   begin vb.image imgmarcolingotes 
      height          =   780
      index           =   4
      left            =   1560
      top             =   3780
      visible         =   0   'false
      width           =   1740
   end
   begin vb.image imgmarcolingotes 
      height          =   780
      index           =   3
      left            =   1560
      top             =   2985
      visible         =   0   'false
      width           =   1740
   end
   begin vb.image imgmarcolingotes 
      height          =   780
      index           =   2
      left            =   1560
      top             =   2190
      visible         =   0   'false
      width           =   1740
   end
   begin vb.image imgmarcoupgrade 
      height          =   780
      index           =   1
      left            =   5280
      top             =   1395
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
      index           =   3
      left            =   5280
      top             =   2985
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcoupgrade 
      height          =   780
      index           =   4
      left            =   5280
      top             =   3780
      visible         =   0   'false
      width           =   780
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
   begin vb.image picmejorar1 
      height          =   420
      left            =   3360
      top             =   2370
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image picmejorar2 
      height          =   420
      left            =   3360
      top             =   3180
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgcerrar 
      height          =   360
      left            =   2760
      top             =   4650
      width           =   1455
   end
   begin vb.image picconstruir3 
      height          =   420
      left            =   3360
      top             =   3960
      width           =   1710
   end
   begin vb.image picconstruir2 
      height          =   420
      left            =   3360
      top             =   3180
      width           =   1710
   end
   begin vb.image picconstruir1 
      height          =   420
      left            =   3360
      top             =   2370
      width           =   1710
   end
   begin vb.image piccheckbox 
      height          =   420
      left            =   5415
      mousepointer    =   99  'custom
      top             =   1860
      width           =   435
   end
   begin vb.image picpestania 
      height          =   255
      index           =   2
      left            =   3240
      mousepointer    =   99  'custom
      top             =   480
      width           =   1095
   end
   begin vb.image picpestania 
      height          =   255
      index           =   1
      left            =   1680
      mousepointer    =   99  'custom
      top             =   480
      width           =   1455
   end
   begin vb.image picpestania 
      height          =   255
      index           =   0
      left            =   720
      mousepointer    =   99  'custom
      top             =   480
      width           =   975
   end
   begin vb.image picmejorar3 
      height          =   420
      left            =   3360
      top             =   3960
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image imgmarcoitem 
      height          =   780
      index           =   1
      left            =   720
      top             =   1395
      visible         =   0   'false
      width           =   780
   end
   begin vb.image imgmarcolingotes 
      height          =   780
      index           =   1
      left            =   1560
      top             =   1395
      visible         =   0   'false
      width           =   1740
   end
   begin vb.image picmejorar0 
      height          =   420
      left            =   3360
      top             =   1560
      visible         =   0   'false
      width           =   1710
   end
   begin vb.image picconstruir0 
      height          =   420
      left            =   3360
      top             =   1560
      width           =   1710
   end
end
attribute vb_name = "frmherrero"
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

private enum epestania
    iearmas
    iearmaduras
    iemejorar
end enum

private piccheck as picture
private picrecuadroitem as picture
private picrecuadrolingotes as picture

private pestanias(0 to 2) as picture
private ultimapestania as byte

private cpiccerrar as clsgraphicalbutton
private cpicconstruir(0 to 3) as clsgraphicalbutton
private cpicmejorar(0 to 3) as clsgraphicalbutton
public lastbuttonpressed as clsgraphicalbutton

private cargando as boolean

private usarmacro as boolean
private armas as boolean

private clsformulario as clsformmovementmanager

private sub cargarimagenes()
    dim imgpath as string
    dim index as integer
    
    imgpath = app.path & "\graficos\"

    set pestanias(epestania.iearmas) = loadpicture(imgpath & "ventanaherreriaarmas.jpg")
    set pestanias(epestania.iearmaduras) = loadpicture(imgpath & "ventanaherreriaarmaduras.jpg")
    set pestanias(epestania.iemejorar) = loadpicture(imgpath & "ventanaherreriamejorar.jpg")
    
    set piccheck = loadpicture(imgpath & "checkboxherreria.jpg")
    
    set picrecuadroitem = loadpicture(imgpath & "recuadroitemsherreria.jpg")
    set picrecuadrolingotes = loadpicture(imgpath & "recuadrolingotes.jpg")
    
    for index = 1 to max_list_items
        imgmarcoitem(index).picture = picrecuadroitem
        imgmarcoupgrade(index).picture = picrecuadroitem
        imgmarcolingotes(index).picture = picrecuadrolingotes
    next index
    
    set cpiccerrar = new clsgraphicalbutton
    set cpicconstruir(0) = new clsgraphicalbutton
    set cpicconstruir(1) = new clsgraphicalbutton
    set cpicconstruir(2) = new clsgraphicalbutton
    set cpicconstruir(3) = new clsgraphicalbutton
    set cpicmejorar(0) = new clsgraphicalbutton
    set cpicmejorar(1) = new clsgraphicalbutton
    set cpicmejorar(2) = new clsgraphicalbutton
    set cpicmejorar(3) = new clsgraphicalbutton

    set lastbuttonpressed = new clsgraphicalbutton
    
    call cpiccerrar.initialize(imgcerrar, imgpath & "botoncerrarherreria.jpg", imgpath & "botoncerrarrolloverherreria.jpg", imgpath & "botoncerrarclickherreria.jpg", me)
    call cpicconstruir(0).initialize(picconstruir0, imgpath & "botonconstruirherreria.jpg", imgpath & "botonconstruirrolloverherreria.jpg", imgpath & "botonconstruirclickherreria.jpg", me)
    call cpicconstruir(1).initialize(picconstruir1, imgpath & "botonconstruirherreria.jpg", imgpath & "botonconstruirrolloverherreria.jpg", imgpath & "botonconstruirclickherreria.jpg", me)
    call cpicconstruir(2).initialize(picconstruir2, imgpath & "botonconstruirherreria.jpg", imgpath & "botonconstruirrolloverherreria.jpg", imgpath & "botonconstruirclickherreria.jpg", me)
    call cpicconstruir(3).initialize(picconstruir3, imgpath & "botonconstruirherreria.jpg", imgpath & "botonconstruirrolloverherreria.jpg", imgpath & "botonconstruirclickherreria.jpg", me)
    call cpicmejorar(0).initialize(picmejorar0, imgpath & "botonmejorarherreria.jpg", imgpath & "botonmejorarrolloverherreria.jpg", imgpath & "botonmejorarclickherreria.jpg", me)
    call cpicmejorar(1).initialize(picmejorar1, imgpath & "botonmejorarherreria.jpg", imgpath & "botonmejorarrolloverherreria.jpg", imgpath & "botonmejorarclickherreria.jpg", me)
    call cpicmejorar(2).initialize(picmejorar2, imgpath & "botonmejorarherreria.jpg", imgpath & "botonmejorarrolloverherreria.jpg", imgpath & "botonmejorarclickherreria.jpg", me)
    call cpicmejorar(3).initialize(picmejorar3, imgpath & "botonmejorarherreria.jpg", imgpath & "botonmejorarrolloverherreria.jpg", imgpath & "botonmejorarclickherreria.jpg", me)

    imgcantidadciclo.picture = loadpicture(imgpath & "construirporciclo.jpg")
    
    picpestania(epestania.iearmas).mouseicon = picmouseicon
    picpestania(epestania.iearmaduras).mouseicon = picmouseicon
    picpestania(epestania.iemejorar).mouseicon = picmouseicon
    
    piccheckbox.mouseicon = picmouseicon
end sub

private sub construiritem(byval index as integer)
    dim itemindex as integer
    dim cantitemsciclo as integer
    
    if scroll.visible = true then itemindex = scroll.value
    itemindex = itemindex + index
    
    select case ultimapestania
        case epestania.iearmas
        
            if usarmacro then
                cantitemsciclo = val(cboitemsciclo.text)
                macrobltindex = armasherrero(itemindex).objindex
                frmmain.activarmacrotrabajo
            else
                ' que cosntruya el maximo, total si sobra no importa, valida el server
                cantitemsciclo = val(cboitemsciclo.list(cboitemsciclo.listcount - 1))
            end if
            
            call writeinitcrafting(val(txtcantitems.text), cantitemsciclo)
            call writecraftblacksmith(armasherrero(itemindex).objindex)
            
        case epestania.iearmaduras
        
            if usarmacro then
                cantitemsciclo = val(cboitemsciclo.text)
                macrobltindex = armadurasherrero(itemindex).objindex
                frmmain.activarmacrotrabajo
             else
                ' que cosntruya el maximo, total si sobra no importa, valida el server
                cantitemsciclo = val(cboitemsciclo.list(cboitemsciclo.listcount - 1))
            end if
            
            call writeinitcrafting(val(txtcantitems.text), cantitemsciclo)
            call writecraftblacksmith(armadurasherrero(itemindex).objindex)
        
        case epestania.iemejorar
            call writeitemupgrade(herreromejorar(itemindex).objindex)
    end select
    
    unload me

end sub

private sub form_load()
    dim maxconstitem as integer
    dim i as integer
    
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    cargarimagenes
    
    ' cargar imagenes
    set me.picture = pestanias(epestania.iearmas)
    piccheckbox.picture = piccheck
    
    cargando = true
    
    maxconstitem = cint((userlvl - 2) * 0.2)
    maxconstitem = iif(maxconstitem < 1, 1, maxconstitem)
    maxconstitem = iif(userclase = eclass.worker, maxconstitem, 1)
    
    for i = 1 to maxconstitem
        cboitemsciclo.additem i
    next i
    
    cboitemsciclo.listindex = 0
    
    cargando = false
    
    usarmacro = true
    armas = true
    ultimapestania = 0
end sub

public sub hideextracontrols(byval numitems as integer, optional byval upgrading as boolean = false)
    dim i as integer
    
    piclingotes0.visible = (numitems >= 1)
    piclingotes1.visible = (numitems >= 2)
    piclingotes2.visible = (numitems >= 3)
    piclingotes3.visible = (numitems >= 4)
    
    for i = 1 to max_list_items
        picitem(i).visible = (numitems >= i)
        imgmarcoitem(i).visible = (numitems >= i)
        imgmarcolingotes(i).visible = (numitems >= i)
        picupgradeitem(i).visible = (numitems >= i and upgrading)
        imgmarcoupgrade(i).visible = (numitems >= i and upgrading)
    next i
    
    picconstruir0.visible = (numitems >= 1 and not upgrading)
    picconstruir1.visible = (numitems >= 2 and not upgrading)
    picconstruir2.visible = (numitems >= 3 and not upgrading)
    picconstruir3.visible = (numitems >= 4 and not upgrading)
    
    picmejorar0.visible = (numitems >= 1 and upgrading)
    picmejorar1.visible = (numitems >= 2 and upgrading)
    picmejorar2.visible = (numitems >= 3 and upgrading)
    picmejorar3.visible = (numitems >= 4 and upgrading)
    
    piccheckbox.visible = not upgrading
    cboitemsciclo.visible = not upgrading and usarmacro
    imgcantidadciclo.visible = not upgrading and usarmacro
    txtcantitems.visible = not upgrading
    piccheckbox.visible = not upgrading
    
    if numitems > max_list_items then
        scroll.visible = true
        cargando = true
        scroll.max = numitems - max_list_items
        cargando = false
    else
        scroll.visible = false
    end if
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

public sub renderlist(byval inicio as integer, byval armas as boolean)
dim i as long
dim numitems as integer
dim objherrero() as titemsconstruibles

if armas then
    objherrero = armasherrero
else
    objherrero = armadurasherrero
end if

numitems = ubound(objherrero)
inicio = inicio - 1

for i = 1 to max_list_items
    if i + inicio <= numitems then
        with objherrero(i + inicio)
            ' agrego el item
            call renderitem(picitem(i), .grhindex)
            picitem(i).tooltiptext = .name
            
             ' inventariode lingotes
            call invlingosherreria(i).setitem(1, 0, .linh, 0, lh_grh, 0, 0, 0, 0, 0, 0, "lingotes de hierro")
            call invlingosherreria(i).setitem(2, 0, .linp, 0, lp_grh, 0, 0, 0, 0, 0, 0, "lingotes de plata")
            call invlingosherreria(i).setitem(3, 0, .lino, 0, lo_grh, 0, 0, 0, 0, 0, 0, "lingotes de oro")
        end with
    end if
next i
end sub

public sub renderupgradelist(byval inicio as integer)
dim i as long
dim numitems as integer

numitems = ubound(herreromejorar)
inicio = inicio - 1

for i = 1 to max_list_items
    if i + inicio <= numitems then
        with herreromejorar(i + inicio)
            ' agrego el item
            call renderitem(picitem(i), .grhindex)
            picitem(i).tooltiptext = .name
            
            call renderitem(picupgradeitem(i), .upgradegrhindex)
            picupgradeitem(i).tooltiptext = .upgradename
            
             ' inventariode lingotes
            call invlingosherreria(i).setitem(1, 0, .linh, 0, lh_grh, 0, 0, 0, 0, 0, 0, "lingotes de hierro")
            call invlingosherreria(i).setitem(2, 0, .linp, 0, lp_grh, 0, 0, 0, 0, 0, 0, "lingotes de plata")
            call invlingosherreria(i).setitem(3, 0, .lino, 0, lo_grh, 0, 0, 0, 0, 0, 0, "lingotes de oro")
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
        set invlingosherreria(i) = nothing
    next i
    
    mirandoherreria = false
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub piccheckbox_click()
    
    usarmacro = not usarmacro

    if usarmacro then
        piccheckbox.picture = piccheck
    else
        piccheckbox.picture = nothing
    end if
    
    cboitemsciclo.visible = usarmacro
    imgcantidadciclo.visible = usarmacro
end sub

private sub picconstruir0_click()
    call construiritem(1)
end sub

private sub picconstruir1_click()
    call construiritem(2)
end sub

private sub picconstruir2_click()
    call construiritem(3)
end sub

private sub picconstruir3_click()
    call construiritem(4)
end sub

private sub piclingotes0_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub piclingotes1_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub piclingotes2_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub piclingotes3_mousemove(button as integer, shift as integer, x as single, y as single)
    lastbuttonpressed.toggletonormal
end sub

private sub picmejorar0_click()
    call construiritem(1)
end sub

private sub picmejorar1_click()
    call construiritem(2)
end sub

private sub picmejorar2_click()
    call construiritem(3)
end sub

private sub picmejorar3_click()
    call construiritem(4)
end sub

private sub picpestania_click(index as integer)
    dim i as integer
    dim numitems as integer
    
    if cargando then exit sub
    if ultimapestania = index then exit sub
    
    scroll.value = 0
    
    select case index
        case epestania.iearmas
            ' background
            me.picture = pestanias(epestania.iearmas)
            
            numitems = ubound(armasherrero)
        
            call hideextracontrols(numitems)
            
            ' cargo inventarios e imagenes
            call renderlist(1, true)
            
            armas = true
            
        case epestania.iearmaduras
            ' background
            me.picture = pestanias(epestania.iearmaduras)
            
            numitems = ubound(armadurasherrero)
        
            call hideextracontrols(numitems)
            
            ' cargo inventarios e imagenes
            call renderlist(1, false)
            
            armas = false
            
        case epestania.iemejorar
            ' background
            me.picture = pestanias(epestania.iemejorar)
            
            numitems = ubound(herreromejorar)
            
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
        case epestania.iearmas
            call renderlist(i + 1, true)
        case epestania.iearmaduras
            call renderlist(i + 1, false)
        case epestania.iemejorar
            call renderupgradelist(i + 1)
    end select
end sub

private sub txtcantitems_change()
on error goto errhandler
    if val(txtcantitems.text) < 0 then
        txtcantitems.text = 1
    end if
    
    if val(txtcantitems.text) > max_inventory_objs then
        txtcantitems.text = max_inventory_objs
    end if
    
    exit sub
    
errhandler:
    'if we got here the user may have pasted (shift + insert) a really large number, causing an overflow, so we set amount back to 1
    txtcantitems.text = max_inventory_objs
end sub

private sub txtcantitems_keypress(keyascii as integer)
    if (keyascii <> 8) then
        if (keyascii < 48 or keyascii > 57) then
            keyascii = 0
        end if
    end if
end sub

