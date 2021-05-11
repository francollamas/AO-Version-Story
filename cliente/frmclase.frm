version 5.00
begin vb.form frmclase 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   clientheight    =   4395
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   6435
   beginproperty font 
      name            =   "ms serif"
      size            =   6.75
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   scaleheight     =   293
   scalemode       =   3  'pixel
   scalewidth      =   429
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.image image1 
      height          =   495
      index           =   1
      left            =   990
      top             =   3300
      width           =   960
   end
   begin vb.image image1 
      height          =   495
      index           =   0
      left            =   4305
      top             =   3285
      width           =   960
   end
   begin vb.label ldesc 
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms serif"
         size            =   9.75
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   1530
      left            =   825
      tabindex        =   0
      top             =   1395
      width           =   4635
   end
end
attribute vb_name = "frmclase"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private sub form_load()
dim i as integer
for i = lbound(listaclases) to ubound(listaclases)
 list1.additem listaclases(i)
next i
list1.text = list1.list(lbound(listaclases))
me.picture = loadpicture(app.path & "\graficos\clase.jpg")
image1(1).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
image1(0).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")




end sub

private sub image1_click(index as integer)
call playwaveds(snd_click)
select case index
    case 0
        userclase = list1.text
        me.visible = false
        frmciudad.show vbmodal
    case 1
        unload me
        frmsexo.show vbmodal
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

