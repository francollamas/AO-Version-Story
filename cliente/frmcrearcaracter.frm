version 5.00
begin vb.form frmcrearcaracter 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   caption         =   "argentum"
   clientheight    =   3075
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   5910
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   205
   scalemode       =   3  'pixel
   scalewidth      =   394
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.textbox text1 
      appearance      =   0  'flat
      backcolor       =   &h00800000&
      beginproperty font 
         name            =   "ms serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   285
      imemode         =   3  'disable
      left            =   1815
      tabindex        =   3
      top             =   2085
      width           =   3735
   end
   begin vb.checkbox savepasschk 
      appearance      =   0  'flat
      backcolor       =   &h00000040&
      beginproperty font 
         name            =   "ms serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   225
      left            =   1920
      tabindex        =   2
      top             =   1305
      value           =   1  'checked
      visible         =   0   'false
      width           =   195
   end
   begin vb.textbox passwordtxt 
      appearance      =   0  'flat
      backcolor       =   &h00800000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "ms serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   195
      imemode         =   3  'disable
      left            =   1845
      passwordchar    =   "*"
      tabindex        =   1
      top             =   660
      width           =   3735
   end
   begin vb.textbox nametxt 
      appearance      =   0  'flat
      backcolor       =   &h00800000&
      borderstyle     =   0  'none
      beginproperty font 
         name            =   "ms serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   195
      left            =   1845
      tabindex        =   0
      top             =   270
      width           =   3735
   end
   begin vb.image image1 
      height          =   495
      index           =   1
      left            =   3660
      tag             =   "0"
      top             =   2475
      width           =   960
   end
   begin vb.image image1 
      height          =   495
      index           =   0
      left            =   1320
      tag             =   "0"
      top             =   2475
      width           =   960
   end
end
attribute vb_name = "frmcrearcaracter"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false


private sub command1_click(index as integer)
call playwaveds(snd_click)
select case index
    case 0
        'actualizamos la info
            username = nametxt.text
            userpassword = passwordtxt.text
            useremail = text1.text
            dim aux as string
            aux = userpassword
            userpassword = encryptini$(aux, seed)
        
        if checkuserdata(true) = true then
            me.visible = false
            frmraza.show vbmodal
        end if
    case 1
        me.visible = false
end select
    
end sub

private sub form_load()
me.picture = loadpicture(app.path & "\graficos\crearcaracter.jpg")

image1(0).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
image1(1).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")

username = ""
userpassword = ""
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
if image1(0).tag = 1 then
    image1(0).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
    image1(0).tag = 0
end if
if image1(1).tag = 1 then
    image1(1).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")
    image1(1).tag = 0
end if
  
end sub

private sub image1_click(index as integer)
call playwaveds(snd_click)

select case index
    case 0
        if musica = 0 then
            curmidi = dirmidi & "2.mid"
            loopmidi = 1
            call cargarmidi(curmidi)
            call play_midi
        end if
        
        frmconnect.fondo.picture = loadpicture(app.path & "\graficos\conectar.jpg")
        me.visible = false
        
    case 1
        'me.visible = false
        'actualizamos la info
            username = nametxt.text
            userpassword = passwordtxt.text
            useremail = text1.text
            dim aux as string
            aux = userpassword
            userpassword = encryptini$(aux, seed)
        
        if checkuserdata(true) = true then
            me.visible = false
            frmraza.show vbmodal
        end if
end select

end sub

private sub image1_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
select case index
case 0
    if image1(0).tag = 0 then
            call playwaveds(snd_over)
            image1(0).picture = loadpicture(app.path & "\graficos\bot�nvolverapretado.jpg")
            image1(0).tag = 1
    end if
case 1
    if image1(1).tag = 0 then
            call playwaveds(snd_over)
            image1(1).picture = loadpicture(app.path & "\graficos\bot�nsiguienteapretado.jpg")
            image1(1).tag = 1
    end if
    
end select
    
end sub

private sub text1_mousemove(button as integer, shift as integer, x as single, y as single)
  if image1(0).tag = 1 then
            image1(0).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
            image1(0).tag = 0
  end if
  if image1(1).tag = 1 then
    image1(1).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")
    image1(1).tag = 0
  end if

        
end sub
