version 5.00
begin vb.form frmskills 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   5265
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   6555
   linktopic       =   "form1"
   scaleheight     =   351
   scalemode       =   3  'pixel
   scalewidth      =   437
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.label text1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "label1"
      forecolor       =   &h8000000e&
      height          =   195
      index           =   4
      left            =   3405
      tabindex        =   4
      top             =   3420
      width           =   480
   end
   begin vb.label text1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "label1"
      forecolor       =   &h8000000e&
      height          =   195
      index           =   3
      left            =   3405
      tabindex        =   3
      top             =   2910
      width           =   480
   end
   begin vb.label text1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "label1"
      forecolor       =   &h8000000e&
      height          =   195
      index           =   2
      left            =   3405
      tabindex        =   2
      top             =   2310
      width           =   480
   end
   begin vb.label text1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "label1"
      forecolor       =   &h8000000e&
      height          =   195
      index           =   1
      left            =   3405
      tabindex        =   1
      top             =   1725
      width           =   480
   end
   begin vb.label text1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "label1"
      forecolor       =   &h8000000e&
      height          =   195
      index           =   0
      left            =   3405
      tabindex        =   0
      top             =   1125
      width           =   480
   end
   begin vb.image image1 
      height          =   600
      index           =   2
      left            =   2310
      top             =   3975
      width           =   1830
   end
   begin vb.image image1 
      height          =   495
      index           =   1
      left            =   465
      top             =   4485
      width           =   960
   end
   begin vb.image image1 
      height          =   495
      index           =   0
      left            =   5010
      top             =   4455
      width           =   960
   end
end
attribute vb_name = "frmskills"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit



private sub form_load()
me.picture = loadpicture(app.path & "\graficos\skills.jpg")
image1(1).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
image1(0).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")
image1(2).picture = loadpicture(app.path & "\graficos\tirardados.jpg")
dim j
for each j in image1()
    j.tag = "0"
next

call tirardados
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
if image1(2).tag = "1" then
            image1(2).tag = "0"
            image1(2).picture = loadpicture(app.path & "\graficos\tirardados.jpg")
end if
end sub

private sub image1_click(index as integer)
call playwaveds(snd_click)
select case index
    case 0
    case 1
        unload me
        frmciudad.show vbmodal
    case 2
        call playwaveds(snd_dice)
        call tirardados
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
    case 2
        if image1(2).tag = "0" then
            image1(2).tag = "1"
            call playwaveds(snd_over)
            image1(2).picture = loadpicture(app.path & "\graficos\tirardadosapretado.jpg")
        end if
end select
end sub
