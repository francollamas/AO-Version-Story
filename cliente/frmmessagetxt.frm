version 5.00
begin vb.form frmmessagetxt 
   backcolor       =   &h00000000&
   borderstyle     =   1  'fixed single
   caption         =   "mensajes predefinidos"
   clientheight    =   4695
   clientleft      =   45
   clienttop       =   435
   clientwidth     =   4680
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   4695
   scalewidth      =   4680
   startupposition =   3  'windows default
   begin vb.commandbutton cancelcmd 
      caption         =   "cancelar"
      height          =   495
      left            =   2400
      tabindex        =   21
      top             =   3960
      width           =   2055
   end
   begin vb.commandbutton okcmd 
      caption         =   "guardar"
      height          =   495
      left            =   120
      tabindex        =   20
      top             =   3960
      width           =   2055
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   9
      left            =   1080
      tabindex        =   10
      top             =   3440
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   8
      left            =   1080
      tabindex        =   9
      top             =   3080
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   7
      left            =   1080
      tabindex        =   8
      top             =   2720
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   6
      left            =   1080
      tabindex        =   7
      top             =   2360
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   5
      left            =   1080
      tabindex        =   6
      top             =   2000
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   4
      left            =   1080
      tabindex        =   5
      top             =   1640
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   3
      left            =   1080
      tabindex        =   4
      top             =   1280
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   2
      left            =   1080
      tabindex        =   3
      top             =   920
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   1
      left            =   1080
      tabindex        =   2
      top             =   560
      width           =   3400
   end
   begin vb.textbox messagetxt 
      height          =   285
      index           =   0
      left            =   1080
      tabindex        =   1
      top             =   200
      width           =   3400
   end
   begin vb.label label10 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 10:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   19
      top             =   3480
      width           =   870
   end
   begin vb.label label9 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 9:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   18
      top             =   3120
      width           =   780
   end
   begin vb.label label8 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 8:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   17
      top             =   2760
      width           =   780
   end
   begin vb.label label7 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 7:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   16
      top             =   2400
      width           =   780
   end
   begin vb.label label6 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 6:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   15
      top             =   2040
      width           =   780
   end
   begin vb.label label5 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 5:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   14
      top             =   1680
      width           =   780
   end
   begin vb.label label4 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 4:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   13
      top             =   1320
      width           =   780
   end
   begin vb.label label3 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 3:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   12
      top             =   960
      width           =   780
   end
   begin vb.label label2 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 2:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   11
      top             =   600
      width           =   780
   end
   begin vb.label label1 
      autosize        =   -1  'true
      backcolor       =   &h00000000&
      caption         =   "mensaje 1:"
      forecolor       =   &h00ffffff&
      height          =   195
      left            =   120
      tabindex        =   0
      top             =   240
      width           =   780
   end
end
attribute vb_name = "frmmessagetxt"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private sub cancelcmd_click()
    unload me
end sub

private sub form_load()
    dim i as long
    
    for i = 0 to 9
        messagetxt(i) = custommessages.message(i)
    next i
end sub

private sub okcmd_click()
on error goto errhandler
    dim i as long
    
    for i = 0 to 9
        custommessages.message(i) = messagetxt(i)
    next i
    
    unload me
exit sub

errhandler:
    'did detected an invalid message??
    if err.number = custommessages.invalidmessageerrcode then
        call msgbox("el mensaje " & cstr(i + 1) & " es inv�lido. modifiquelo por favor.")
    end if
end sub
