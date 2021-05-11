version 5.00
begin vb.form frmforo 
   backcolor       =   &h00e0e0e0&
   borderstyle     =   0  'none
   clientheight    =   6855
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   6210
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   457
   scalemode       =   3  'pixel
   scalewidth      =   414
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox txttitulo 
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
      height          =   315
      left            =   1140
      maxlength       =   35
      tabindex        =   2
      top             =   900
      visible         =   0   'false
      width           =   4620
   end
   begin vb.textbox txtpost 
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
      height          =   3960
      left            =   780
      multiline       =   -1  'true
      tabindex        =   1
      text            =   "frmforo.frx":0000
      top             =   1935
      visible         =   0   'false
      width           =   4770
   end
   begin vb.listbox lsttitulos 
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
      height          =   5100
      left            =   765
      tabindex        =   0
      top             =   825
      width           =   4785
   end
   begin vb.label lbltitulo 
      appearance      =   0  'flat
      backcolor       =   &h80000005&
      backstyle       =   0  'transparent
      caption         =   "label1"
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
      left            =   1125
      tabindex        =   4
      top             =   960
      width           =   4695
   end
   begin vb.image imgmarcotexto 
      height          =   465
      left            =   1095
      top             =   840
      width           =   4725
   end
   begin vb.image imgcerrar 
      height          =   255
      left            =   4080
      top             =   6060
      width           =   1455
   end
   begin vb.image imglistamsg 
      height          =   255
      left            =   2400
      top             =   6060
      width           =   1455
   end
   begin vb.image imgdejarmsg 
      height          =   255
      left            =   720
      top             =   6060
      width           =   1455
   end
   begin vb.label lblautor 
      appearance      =   0  'flat
      backcolor       =   &h80000005&
      backstyle       =   0  'transparent
      caption         =   "nombre"
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
      left            =   1125
      tabindex        =   3
      top             =   1455
      width           =   4650
   end
   begin vb.image imgtab 
      height          =   255
      index           =   2
      left            =   4320
      top             =   360
      width           =   1575
   end
   begin vb.image imgtab 
      height          =   255
      index           =   1
      left            =   2520
      top             =   360
      width           =   1575
   end
   begin vb.image imgtab 
      height          =   255
      index           =   0
      left            =   960
      top             =   360
      width           =   1575
   end
   begin vb.image imgdejaranuncio 
      height          =   255
      left            =   2400
      top             =   6060
      width           =   1455
   end
end
attribute vb_name = "frmforo"
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

private cbotondejaranuncio as clsgraphicalbutton
private cbotondejarmsg as clsgraphicalbutton
private cbotoncerrar as clsgraphicalbutton
private cbotonlistamsg as clsgraphicalbutton
public lastpressed as clsgraphicalbutton

' para controlar las imagenes de fondo y el envio de posteos
private foroactual as eforumtype
private verlistamsg as boolean
private lectura as boolean

public forolimpio as boolean
private sticky as boolean

' para restringir la visibilidad de los foros
public privilegios as byte
public forosvisibles as eforumtype
public canpoststicky as byte

' imagenes de fondo
private fondosdejarmsg(0 to 2) as picture
private fondoslistamsg(0 to 2) as picture

private sub form_unload(cancel as integer)
    mirandoforo = false
    privilegios = 0
end sub

private sub imgdejaranuncio_click()
    lectura = false
    verlistamsg = false
    sticky = true
    
    'switch to proper background
    tooglescreen
end sub

private sub imgdejarmsg_click()
    if not cbotondejarmsg.isenabled then exit sub
    
    dim poststyle as byte
    
    if not verlistamsg then
        if not lectura then
        
            if sticky then
                poststyle = getstickypost
            else
                poststyle = getnormalpost
            end if

            call writeforumpost(txttitulo.text, txtpost.text, poststyle)
            
            ' actualizo localmente
            call clsforos.addpost(foroactual, txttitulo.text, username, txtpost.text, sticky)
            call updatelist
            
            verlistamsg = true
        end if
    else
        verlistamsg = false
        sticky = false
    end if
    
    lectura = false
    
    'switch to proper background
    tooglescreen
end sub

private sub imgcerrar_click()
    unload me
end sub

private sub imglistamsg_click()
    verlistamsg = true
    tooglescreen
end sub


private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    call loadbuttons
    
    ' initial config
    foroactual = eforumtype.iegeneral
    verlistamsg = true
    updatelist
    
    ' default background
    tooglescreen
    
    forolimpio = false
    mirandoforo = true
    
    ' si no es caos o gms, no puede ver el tab de caos.
    if (privilegios and eforumvisibility.iecaos_member) = 0 then imgtab(2).visible = false
    
    ' si no es armada o gm, no puede ver el tab de armadas.
    if (privilegios and eforumvisibility.iereal_member) = 0 then imgtab(1).visible = false
    
end sub

private sub loadbuttons()

    dim grhpath as string
    grhpath = dirgraficos
    
    ' load pictures
    set fondoslistamsg(eforumtype.iegeneral) = loadpicture(grhpath & "forogeneral.jpg")
    set fondoslistamsg(eforumtype.iereal) = loadpicture(grhpath & "fororeal.jpg")
    set fondoslistamsg(eforumtype.iecaos) = loadpicture(grhpath & "forocaos.jpg")
    
    set fondosdejarmsg(eforumtype.iegeneral) = loadpicture(grhpath & "foromsggeneral.jpg")
    set fondosdejarmsg(eforumtype.iereal) = loadpicture(grhpath & "foromsgreal.jpg")
    set fondosdejarmsg(eforumtype.iecaos) = loadpicture(grhpath & "foromsgcaos.jpg")
    
    imgmarcotexto.picture = loadpicture(grhpath & "marcotextbox.jpg")

    set cbotondejaranuncio = new clsgraphicalbutton
    set cbotondejarmsg = new clsgraphicalbutton
    set cbotoncerrar = new clsgraphicalbutton
    set cbotonlistamsg = new clsgraphicalbutton

    set lastpressed = new clsgraphicalbutton

    ' initialize buttons
    call cbotondejaranuncio.initialize(imgdejaranuncio, grhpath & "botondejaranuncioforo.jpg", _
                                            grhpath & "botondejaranunciorolloverforo.jpg", _
                                            grhpath & "botondejaranuncioclickforo.jpg", me)
                                            
    call cbotondejarmsg.initialize(imgdejarmsg, grhpath & "botondejarmsgforo.jpg", _
                                            grhpath & "botondejarmsgrolloverforo.jpg", _
                                            grhpath & "botondejarmsgclickforo.jpg", me, _
                                            grhpath & "botondejarmsgdisabledforo.jpg")
                                            
    call cbotoncerrar.initialize(imgcerrar, grhpath & "botoncerrarforo.jpg", _
                                            grhpath & "botoncerrarrolloverforo.jpg", _
                                            grhpath & "botoncerrarclickforo.jpg", me)
                                            
    call cbotonlistamsg.initialize(imglistamsg, grhpath & "botonlistamsgforo.jpg", _
                                            grhpath & "botonlistamsgrolloverforo.jpg", _
                                            grhpath & "botonlistamsgclickforo.jpg", me)

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub imgtab_click(index as integer)

    call audio.playwave(snd_click)
    
    if index <> foroactual then
        foroactual = index
        verlistamsg = true
        lectura = false
        updatelist
        tooglescreen
    else
        if not verlistamsg then
            verlistamsg = true
            lectura = false
            tooglescreen
        end if
    end if
end sub

private sub tooglescreen()
    
    dim postoffset as integer
    
    imgmarcotexto.visible = not verlistamsg and not lectura
    txttitulo.visible = not verlistamsg and not lectura
    lbltitulo.visible = not verlistamsg and lectura
    
    call cbotondejarmsg.enablebutton(verlistamsg or lectura)
    
    txtpost.visible = not verlistamsg
    
    imgdejaranuncio.visible = verlistamsg and puededejaranuncios
    imglistamsg.visible = not verlistamsg
    lsttitulos.visible = verlistamsg
    
    if verlistamsg then
        me.picture = fondoslistamsg(foroactual)
    else
        if lectura then
            with lsttitulos
                postoffset = .itemdata(.listindex)
                
                ' normal post?
                if postoffset < sticky_forum_offset then
                    lbltitulo.caption = foros(foroactual).generaltitle(postoffset)
                    txtpost.text = foros(foroactual).generalpost(postoffset)
                    lblautor.caption = foros(foroactual).generalauthor(postoffset)
                
                ' sticky post
                else
                    postoffset = postoffset - sticky_forum_offset
                    
                    lbltitulo.caption = foros(foroactual).stickytitle(postoffset)
                    txtpost.text = foros(foroactual).stickypost(postoffset)
                    lblautor.caption = foros(foroactual).stickyauthor(postoffset)
                end if
            end with
        else
            lblautor.caption = username
            txttitulo.text = vbnullstring
            txtpost.text = vbnullstring
            
            txttitulo.setfocus
        end if
        
        txtpost.locked = lectura
        me.picture = fondosdejarmsg(foroactual)
    end if
    
end sub

private function puededejaranuncios() as boolean
    
    ' no puede
    if canpoststicky = 0 then exit function

    if foroactual = eforumtype.iegeneral then
        ' solo puede dejar en el general si es gm
        if canpoststicky <> 2 then exit function
    end if
    
    puededejaranuncios = true
    
end function

private sub lsttitulos_click()
    verlistamsg = false
    lectura = true
    tooglescreen
end sub

private sub lsttitulos_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub txtpost_change()
    if lectura then exit sub
    
    call cbotondejarmsg.enablebutton(len(txttitulo.text) <> 0 and len(txtpost.text) <> 0)
end sub

private sub txtpost_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub txttitulo_change()
    if lectura then exit sub
    
    call cbotondejarmsg.enablebutton(len(txttitulo.text) <> 0 and len(txtpost.text) <> 0)
end sub

private sub updatelist()
    dim postindex as long
    
    lsttitulos.clear
    
    with lsttitulos
        ' sticky first
        for postindex = 1 to clsforos.getnrosticky(foroactual)
            .additem "[anuncio] " & foros(foroactual).stickytitle(postindex) & " (" & foros(foroactual).stickyauthor(postindex) & ")"
            .itemdata(.newindex) = sticky_forum_offset + postindex
        next postindex
    
        ' then normal posts
        for postindex = 1 to clsforos.getnropost(foroactual)
            .additem foros(foroactual).generaltitle(postindex) & " (" & foros(foroactual).generalauthor(postindex) & ")"
            .itemdata(.newindex) = postindex
        next postindex
    end with
    
end sub

private function getstickypost() as byte
    select case foroactual
        case 0
            getstickypost = eforummsgtype.iegeneral_sticky
            
        case 1
            getstickypost = eforummsgtype.iereal_sticky
            
        case 2
            getstickypost = eforummsgtype.iecaos_sticky
            
    end select
    
end function

private function getnormalpost() as byte
    select case foroactual
        case 0
            getnormalpost = eforummsgtype.iegeneral
            
        case 1
            getnormalpost = eforummsgtype.iereal
            
        case 2
            getnormalpost = eforummsgtype.iecaos
            
    end select
    
end function
