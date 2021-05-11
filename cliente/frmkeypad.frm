version 5.00
begin vb.form frmkeypad 
   borderstyle     =   1  'fixed single
   clientheight    =   3945
   clientleft      =   15
   clienttop       =   15
   clientwidth     =   7350
   clipcontrols    =   0   'false
   controlbox      =   0   'false
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   scaleheight     =   3945
   scalewidth      =   7350
   startupposition =   1  'centerowner
   begin vb.textbox txtpassword 
      backcolor       =   &h00c0e0ff&
      beginproperty font 
         name            =   "courier"
         size            =   15
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000040&
      height          =   465
      imemode         =   3  'disable
      left            =   960
      passwordchar    =   "*"
      tabindex        =   0
      top             =   270
      width           =   5160
   end
   begin vb.label label1 
      backstyle       =   0  'transparent
      caption         =   "ingrese el password de su personaje y presione <enter>"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00000040&
      height          =   255
      left            =   615
      tabindex        =   1
      top             =   15
      width           =   6120
   end
   begin vb.image imgespacio 
      height          =   525
      left            =   2160
      top             =   3435
      width           =   3000
   end
   begin vb.image imgmin 
      height          =   570
      left            =   5835
      top             =   3390
      width           =   1440
   end
   begin vb.image imgmay 
      height          =   570
      left            =   90
      top             =   3390
      width           =   1305
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   45
      left            =   6030
      top             =   2760
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   44
      left            =   5490
      top             =   2805
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   43
      left            =   4935
      top             =   2805
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   42
      left            =   4350
      top             =   2790
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   41
      left            =   3780
      top             =   2820
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   40
      left            =   3240
      top             =   2820
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   39
      left            =   2700
      top             =   2820
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   38
      left            =   2160
      top             =   2835
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   37
      left            =   1590
      top             =   2835
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   36
      left            =   1035
      top             =   2820
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   35
      left            =   6315
      top             =   2175
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   34
      left            =   5760
      top             =   2235
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   33
      left            =   5205
      top             =   2205
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   32
      left            =   4680
      top             =   2205
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   31
      left            =   4125
      top             =   2220
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   30
      left            =   3555
      top             =   2175
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   29
      left            =   3000
      top             =   2220
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   28
      left            =   2430
      top             =   2205
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   27
      left            =   1890
      top             =   2205
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   26
      left            =   1335
      top             =   2235
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   25
      left            =   780
      top             =   2235
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   24
      left            =   6600
      top             =   1605
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   23
      left            =   6060
      top             =   1605
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   22
      left            =   5475
      top             =   1620
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   21
      left            =   4905
      top             =   1620
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   20
      left            =   4380
      top             =   1620
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   19
      left            =   3825
      top             =   1650
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   18
      left            =   3270
      top             =   1650
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   17
      left            =   2730
      top             =   1620
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   16
      left            =   2175
      top             =   1650
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   15
      left            =   1635
      top             =   1650
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   14
      left            =   1065
      top             =   1650
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   13
      left            =   510
      top             =   1650
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   12
      left            =   6825
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   11
      left            =   6285
      top             =   975
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   10
      left            =   5730
      top             =   1020
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   9
      left            =   5190
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   8
      left            =   4635
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   7
      left            =   4080
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   6
      left            =   3525
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   5
      left            =   2955
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   4
      left            =   2415
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   3
      left            =   1860
      top             =   960
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   2
      left            =   1305
      top             =   975
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   1
      left            =   750
      top             =   990
      width           =   570
   end
   begin vb.image imgkeypad 
      height          =   555
      index           =   0
      left            =   165
      top             =   975
      width           =   570
   end
end
attribute vb_name = "frmkeypad"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

private enum e_modo_keypad
    mayuscula = 1
    minuscula = 2
end enum

private const minindex = "1234567890-=\qwertyuiop[]asdfghjkl;'zxcvbnm,./"
private const mayindex = "!@#$%^&*()_+|qwertyuiop{}asdfghjkl:""zxcvbnm<>?"
private modo as e_modo_keypad

private sub form_activate()
dim i as integer
dim j as integer
    i = randomnumber(-2000, 2000)
    j = randomnumber(-350, 350)
    me.top = me.top + j
    me.left = me.left + i

end sub

private sub form_load()
    me.picture = loadpicture(app.path & "\graficos\keypadmin.bmp")
    modo = minuscula
end sub

private sub form_unload(cancel as integer)
    frmoldpersonaje.passwordtxt.text = me.txtpassword.text
end sub

private sub imgespacio_click()
    call audio.playwave(snd_click)
    me.txtpassword.text = me.txtpassword.text & " "
    me.txtpassword.setfocus
end sub

private sub imgkeypad_click(index as integer)
    call audio.playwave(snd_click)
    if modo = mayuscula then
        me.txtpassword.text = me.txtpassword.text & mid$(mayindex, index + 1, 1)
    else
        me.txtpassword.text = me.txtpassword.text & mid$(minindex, index + 1, 1)
    end if
    me.txtpassword.setfocus
end sub

private sub imgmay_click()
    call audio.playwave(snd_click)
    me.picture = loadpicture(app.path & "\graficos\keypadmay.bmp")
    modo = mayuscula
    me.txtpassword.setfocus
end sub

private sub imgmin_click()
    call audio.playwave(snd_click)
    me.picture = loadpicture(app.path & "\graficos\keypadmin.bmp")
    modo = minuscula
    me.txtpassword.setfocus
end sub

private sub txtpassword_keypress(keyascii as integer)
    if keyascii = 13 then
        frmoldpersonaje.passwordtxt.text = me.txtpassword.text
        unload me
    else
        me.txtpassword.text = vbnullstring
    end if
end sub
