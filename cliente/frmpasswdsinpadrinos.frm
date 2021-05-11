version 5.00
begin vb.form frmpasswdsinpadrinos 
   borderstyle     =   3  'fixed dialog
   clientheight    =   4050
   clientleft      =   45
   clienttop       =   45
   clientwidth     =   5010
   controlbox      =   0   'false
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   moveable        =   0   'false
   scaleheight     =   4050
   scalewidth      =   5010
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.commandbutton command2 
      caption         =   "volver"
      height          =   420
      left            =   105
      mousepointer    =   99  'custom
      tabindex        =   9
      top             =   3495
      width           =   1080
   end
   begin vb.commandbutton command1 
      caption         =   "aceptar"
      height          =   420
      left            =   3885
      mousepointer    =   99  'custom
      tabindex        =   8
      top             =   3540
      width           =   1080
   end
   begin vb.textbox txtpasswdcheck 
      borderstyle     =   0  'none
      height          =   255
      left            =   765
      tabindex        =   7
      top             =   2910
      width           =   3510
   end
   begin vb.textbox txtpasswd 
      borderstyle     =   0  'none
      height          =   255
      left            =   765
      tabindex        =   5
      top             =   2295
      width           =   3510
   end
   begin vb.textbox txtcorreo 
      borderstyle     =   0  'none
      height          =   255
      left            =   765
      tabindex        =   3
      top             =   1710
      width           =   3510
   end
   begin vb.label label5 
      alignment       =   2  'center
      autosize        =   -1  'true
      caption         =   "verifiaci�n del password:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   195
      left            =   750
      tabindex        =   6
      top             =   2670
      width           =   3555
   end
   begin vb.label label4 
      alignment       =   2  'center
      autosize        =   -1  'true
      caption         =   "password:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   195
      left            =   750
      tabindex        =   4
      top             =   2040
      width           =   3555
   end
   begin vb.label label3 
      alignment       =   2  'center
      caption         =   "direcci�n de correo electronico:"
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   315
      left            =   750
      tabindex        =   2
      top             =   1455
      width           =   3555
   end
   begin vb.label label2 
      alignment       =   2  'center
      caption         =   $"frmpasswdsinpadrinos.frx":0000
      beginproperty font 
         name            =   "tahoma"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   810
      left            =   60
      tabindex        =   1
      top             =   405
      width           =   4890
   end
   begin vb.label label1 
      alignment       =   2  'center
      autosize        =   -1  'true
      caption         =   "�cuidado!"
      beginproperty font 
         name            =   "tahoma"
         size            =   9.75
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h000000c0&
      height          =   240
      left            =   1965
      tabindex        =   0
      top             =   105
      width           =   1035
   end
end
attribute vb_name = "frmpasswdsinpadrinos"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.2
'
'copyright (c) 2002 m�rquez pablo ignacio
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'gnu general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'
'argentum online is based on baronsoft's vb6 online rpg
'you can contact the original creator of ore at aaron@baronsoft.com
'for more information about ore please visit http://www.baronsoft.com/
'
'
'you can contact me at:
'morgolock@speedy.com.ar
'www.geocities.com/gmorgolock
'calle 3 n�mero 983 piso 7 dto a
'la plata - pcia, buenos aires - republica argentina
'c�digo postal 1900
'pablo ignacio m�rquez

option explicit

function checkdatos() as boolean

if txtpasswd.text <> txtpasswdcheck.text then
    msgbox "los passwords que tipeo no coinciden, por favor vuelva a ingresarlos."
    exit function
end if

checkdatos = true

end function
private sub command1_click()

if checkdatos() then
    userpassword = md5string(txtpasswd.text)
    useremail = txtcorreo.text
    
    if not checkmailstring(useremail) then
            msgbox "direccion de mail invalida."
            exit sub
    end if
    
#if usarwrench = 1 then
    frmmain.socket1.hostname = curserverip
    frmmain.socket1.remoteport = curserverport
#end if

    'sendnewchar = true
    estadologin = crearnuevopj
    
    me.mousepointer = 11
    
'    if not frmmain.socket1.connected then
'        frmmain.socket1.connect
'    else
'        call senddata("givemevalcode")
'    end if

    estadologin = crearnuevopj

#if usarwrench = 1 then
    if not frmmain.socket1.connected then
#else
    if frmmain.winsock1.state <> sckconnected then
#end if
        msgbox "error: se ha perdido la conexion con el server."
        unload me
        
    else
        call login(0)
    end if
end if

end sub

private sub command2_click()
unload me
end sub

