version 5.00
begin vb.form frmciudad 
   backcolor       =   &h00000000&
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   5085
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   5310
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   5085
   scalewidth      =   5310
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.combobox list1 
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
      itemdata        =   "frmciudad.frx":0000
      left            =   1080
      list            =   "frmciudad.frx":0002
      style           =   2  'dropdown list
      tabindex        =   0
      top             =   840
      width           =   3000
   end
   begin vb.image image1 
      height          =   495
      index           =   0
      left            =   4035
      top             =   4200
      width           =   960
   end
   begin vb.image image1 
      height          =   495
      index           =   1
      left            =   735
      top             =   4215
      width           =   960
   end
   begin vb.label descrip 
      backstyle       =   0  'transparent
      caption         =   "seleccione su hogar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   1995
      left            =   1080
      tabindex        =   2
      top             =   1560
      width           =   2985
      wordwrap        =   -1  'true
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backstyle       =   0  'transparent
      caption         =   "seleccione su hogar"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   400
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000ff&
      height          =   195
      left            =   1800
      tabindex        =   1
      top             =   480
      width           =   1425
   end
end
attribute vb_name = "frmciudad"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
private sub form_load()
dim i as integer

for i = 1 to numciudades
 list1.additem ciudades(i)
next i

list1.text = list1.list(1)
image1(1).picture = loadpicture(app.path & "\graficos\bot�nvolver.jpg")
image1(0).picture = loadpicture(app.path & "\graficos\bot�nsiguiente.jpg")
end sub

private sub list1_click()
descrip.caption = citydesc(list1.listindex + 1)
end sub
