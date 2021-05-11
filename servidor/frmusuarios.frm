version 5.00
begin vb.form frmusuarios 
   backcolor       =   &h00000000&
   caption         =   "usuarios"
   clientheight    =   7035
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   5640
   controlbox      =   0   'false
   linktopic       =   "form1"
   scaleheight     =   7035
   scalewidth      =   5640
   startupposition =   3  'windows default
   begin vb.commandbutton command1 
      caption         =   "ok"
      height          =   255
      left            =   120
      tabindex        =   0
      top             =   6720
      width           =   5415
   end
   begin vb.shape shape1 
      bordercolor     =   &h00ffffff&
      height          =   6135
      left            =   120
      top             =   120
      width           =   5415
   end
end
attribute vb_name = "frmusuarios"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'-----------------------------------------------------
'               argentum online server
'                       por
'               pablo ignacio m�rquez
'        pablomarquez@argentum-online.com.ar
'
' el codigo fuente de argentum online no es de dominio
' publico, el codigo es propiedad intelectual de pablo
' ignacio m�rquez y esta terminantemente prohibido su
' uso, copia, modificacion o difusion.
'-----------------------------------------------------

private sub command1_click()
me.visible = false
end sub

private sub form_deactivate()
me.visible = false
end sub

