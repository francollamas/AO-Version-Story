version 5.00
begin vb.form frmnewpassword 
   borderstyle     =   1  'fixed single
   caption         =   "cambiar contrase�a"
   clientheight    =   3195
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   213
   scalemode       =   3  'pixel
   scalewidth      =   312
   startupposition =   1  'centerowner
   begin vb.commandbutton command1 
      caption         =   "aceptar"
      default         =   -1  'true
      height          =   495
      left            =   293
      tabindex        =   3
      top             =   2400
      width           =   4095
   end
   begin vb.textbox text3 
      height          =   285
      imemode         =   3  'disable
      left            =   293
      passwordchar    =   "*"
      tabindex        =   2
      top             =   1920
      width           =   4095
   end
   begin vb.textbox text2 
      height          =   285
      imemode         =   3  'disable
      left            =   293
      passwordchar    =   "*"
      tabindex        =   1
      top             =   1200
      width           =   4095
   end
   begin vb.textbox text1 
      height          =   285
      imemode         =   3  'disable
      left            =   293
      passwordchar    =   "*"
      tabindex        =   0
      top             =   480
      width           =   4095
   end
   begin vb.label label3 
      caption         =   "confirmar contrase�a nueva:"
      height          =   255
      left            =   293
      tabindex        =   6
      top             =   1560
      width           =   4095
   end
   begin vb.label label2 
      caption         =   "contrase�a nueva:"
      height          =   255
      left            =   293
      tabindex        =   5
      top             =   840
      width           =   4095
   end
   begin vb.label label1 
      caption         =   "contrase�a anterior:"
      height          =   255
      left            =   293
      tabindex        =   4
      top             =   120
      width           =   4095
   end
end
attribute vb_name = "frmnewpassword"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private sub command1_click()
    if text2.text <> text3.text then
        call msgbox("las contrase�as no coinciden", vbcritical or vbokonly or vbapplicationmodal or vbdefaultbutton1, "cambiar contrase�a")
        exit sub
    end if
    
    call writechangepassword(text1.text, text2.text)
    unload me
end sub
