version 5.00
begin vb.form frmraza 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   4395
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   6435
   linktopic       =   "form1"
   scaleheight     =   293
   scalemode       =   3  'pixel
   scalewidth      =   429
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.combobox clraza 
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
      itemdata        =   "frmraza.frx":0000
      left            =   2385
      list            =   "frmraza.frx":0002
      sorted          =   -1  'true
      style           =   2  'dropdown list
      tabindex        =   0
      top             =   645
      width           =   3045
   end
   begin vb.image image1 
      height          =   495
      index           =   0
      left            =   4305
      top             =   3300
      width           =   960
   end
   begin vb.image image1 
      height          =   495
      index           =   1
      left            =   990
      top             =   3315
      width           =   960
   end
   begin vb.label ldesc 
      backstyle       =   0  'transparent
      caption         =   "raza"
      beginproperty font 
         name            =   "ms serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   1530
      left            =   810
      tabindex        =   1
      top             =   1395
      width           =   4710
   end
end
attribute vb_name = "frmraza"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
private sub clraza_click()
select case clraza.text
    case "humano"
      ldesc.caption = "los humanos son la raza mas comun en argentum. son muy buenos comerciantes y guerreros."
    case "elfo"
      ldesc.caption = "los elfos pueblan los bosques de argentum. son exelentes ladrones y cazadores"
    case "elfo oscuro"
      ldesc.caption = "en general son malvados, son muy odiados a lo largo de todo argentum. son muy buenos con las armas."
    case "gnomo"
      ldesc.caption = "son una raza extra�a, tienen mucha suerte y ciertos gnomos tiene propiedades magicas"
    case "enano"
      ldesc.caption = "son muy bueno luchadores. habitan las zonas monta�osas. existe una gran enemistad entre gnomos y enanos"
end select
end sub



private sub form_load()
me.picture = loadpicture(app.path & "\graficos\raza.jpg")
image1(1).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
image1(0).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")

dim j
for each j in image1()
    j.tag = "0"
next


ldesc.wordwrap = true
dim i as integer
for i = lbound(listarazas) to ubound(listarazas)
 clraza.additem listarazas(i)
next i
clraza.text = clraza.list(lbound(listarazas))
call clraza_click
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
        userraza = clraza.text
        me.visible = false
        frmsexo.show vbmodal
    case 1
        unload me
        frmcrearcaracter.show vbmodal
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

