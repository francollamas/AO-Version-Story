version 5.00
begin vb.form frmnewpassword 
   borderstyle     =   0  'none
   caption         =   "cambiar contrase�a"
   clientheight    =   3555
   clientleft      =   0
   clienttop       =   -75
   clientwidth     =   4755
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   237
   scalemode       =   3  'pixel
   scalewidth      =   317
   showintaskbar   =   0   'false
   startupposition =   1  'centerowner
   begin vb.textbox text3 
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
      height          =   225
      imemode         =   3  'disable
      left            =   375
      passwordchar    =   "*"
      tabindex        =   2
      top             =   2265
      width           =   4005
   end
   begin vb.textbox text2 
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
      height          =   225
      imemode         =   3  'disable
      left            =   375
      passwordchar    =   "*"
      tabindex        =   1
      top             =   1545
      width           =   4005
   end
   begin vb.textbox text1 
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
      height          =   225
      imemode         =   3  'disable
      left            =   375
      passwordchar    =   "*"
      tabindex        =   0
      top             =   825
      width           =   4005
   end
   begin vb.image imgaceptar 
      height          =   495
      left            =   990
      tag             =   "1"
      top             =   2730
      width           =   2775
   end
end
attribute vb_name = "frmnewpassword"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private clsformulario as clsformmovementmanager

private cbotonaceptar as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

private sub form_load()
    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(app.path & "\graficos\ventanacambiarcontrasenia.jpg")
    
    call loadbuttons
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonaceptar = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotonaceptar.initialize(imgaceptar, grhpath & "botonaceptarcambiarcontrasenia.jpg", _
                                    grhpath & "botonaceptarrollovercambiarcontrasenia.jpg", _
                                    grhpath & "botonaceptarclickcambiarcontrasenia.jpg", me)
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub imgaceptar_click()
    if text2.text <> text3.text then
        call msgbox("las contrase�as no coinciden", vbcritical or vbokonly or vbapplicationmodal or vbdefaultbutton1, "cambiar contrase�a")
        exit sub
    end if
    
    call writechangepassword(text1.text, text2.text)
    unload me
end sub

private sub text3_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub
