version 5.00
begin vb.form frmsexo 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   1410
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   4815
   linktopic       =   "form1"
   scaleheight     =   94
   scalemode       =   3  'pixel
   scalewidth      =   321
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.combobox clist1 
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
      forecolor       =   &h000000ff&
      height          =   315
      itemdata        =   "frmsexo.frx":0000
      left            =   1695
      list            =   "frmsexo.frx":0002
      sorted          =   -1  'true
      style           =   2  'dropdown list
      tabindex        =   0
      top             =   330
      width           =   2745
   end
   begin vb.image image1 
      height          =   375
      index           =   1
      left            =   375
      top             =   840
      width           =   780
   end
   begin vb.image image1 
      height          =   375
      index           =   0
      left            =   3480
      top             =   855
      width           =   780
   end
end
attribute vb_name = "frmsexo"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private sub form_load()
clist1.additem "hombre"
clist1.additem "mujer"
clist1.text = clist1.list(0)
me.picture = loadpicture(app.path & "\graficos\sexo.jpg")
image1(1).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
image1(0).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")
dim j
for each j in image1()
    j.tag = "0"
next

end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
if image1(0).tag = "1" then
            image1(0).tag = "0"
            image1(0).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")
end if
if image1(1).tag = "1" then
            image1(1).tag = "0"
            image1(1).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
end if
end sub

private sub image1_click(index as integer)
call playwaveds(snd_click)
select case index
    case 0
        usersexo = clist1.text
        me.visible = false
        frmclase.show vbmodal
    case 1
        unload me
        frmraza.show vbmodal
end select
end sub

private sub image1_mousemove(index as integer, button as integer, shift as integer, x as single, y as single)
select case index
    case 0
        if image1(0).tag = "0" then
            image1(0).tag = "1"
            call playwaveds(snd_over)
            image1(0).picture = loadpicture(app.path & "\graficos\bot�nsiguienteapretado.jpg")
        end if
    case 1
        if image1(1).tag = "0" then
            image1(1).tag = "1"
            call playwaveds(snd_over)
            image1(1).picture = loadpicture(app.path & "\graficos\bot�nvolverapretado.jpg")
        end if
end select
end sub

