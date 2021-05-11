version 5.00
begin vb.form frmuserlist 
   backcolor       =   &h00ffc0c0&
   borderstyle     =   1  'fixed single
   caption         =   "debug de userlist"
   clientheight    =   4665
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   5520
   linktopic       =   "form1"
   maxbutton       =   0   'false
   scaleheight     =   4665
   scalewidth      =   5520
   startupposition =   2  'centerscreen
   begin vb.commandbutton command2 
      backcolor       =   &h00ffc0c0&
      caption         =   "echar todos los no logged"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   2400
      style           =   1  'graphical
      tabindex        =   4
      top             =   4200
      width           =   3015
   end
   begin vb.textbox text2 
      backcolor       =   &h00c0ffff&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   1095
      left            =   2400
      locked          =   -1  'true
      multiline       =   -1  'true
      scrollbars      =   2  'vertical
      tabindex        =   3
      top             =   3000
      width           =   3015
   end
   begin vb.textbox text1 
      backcolor       =   &h00c0ffff&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   2775
      left            =   2400
      locked          =   -1  'true
      multiline       =   -1  'true
      scrollbars      =   2  'vertical
      tabindex        =   2
      top             =   120
      width           =   3015
   end
   begin vb.commandbutton command1 
      backcolor       =   &h00ffc0c0&
      caption         =   "actualiza"
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   375
      left            =   120
      style           =   1  'graphical
      tabindex        =   1
      top             =   4200
      width           =   2175
   end
   begin vb.listbox list1 
      backcolor       =   &h00c0ffff&
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      height          =   3960
      left            =   120
      tabindex        =   0
      top             =   120
      width           =   2175
   end
end
attribute vb_name = "frmuserlist"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'**************************************************************
' frmuserlist.frm
'
'**************************************************************

'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the affero general public license;
'either version 1 of the license, or any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the affero general public license
'along with this program; if not, you can find it at http://www.affero.org/oagpl.html
'**************************************************************************

option explicit

private sub command1_click()
dim loopc as integer

text2.text = "maxusers: " & maxusers & vbcrlf
text2.text = text2.text & "lastuser: " & lastuser & vbcrlf
text2.text = text2.text & "numusers: " & numusers & vbcrlf
'text2.text = text2.text & "" & vbcrlf

list1.clear

for loopc = 1 to maxusers
    list1.additem format(loopc, "000") & " " & iif(userlist(loopc).flags.userlogged, userlist(loopc).name, "")
    list1.itemdata(list1.newindex) = loopc
next loopc


end sub

private sub command2_click()
dim loopc as integer

for loopc = 1 to maxusers
    if userlist(loopc).connid <> -1 and not userlist(loopc).flags.userlogged then
        call closesocket(loopc)
    end if
next loopc

end sub

private sub list1_click()
dim userindex as integer
if list1.listindex <> -1 then
    userindex = list1.itemdata(list1.listindex)
    if userindex > 0 and userindex <= maxusers then
        with userlist(userindex)
            text1.text = "userlogged: " & .flags.userlogged & vbcrlf
            text1.text = text1.text & "idlecount: " & .counters.idlecount & vbcrlf
            text1.text = text1.text & "connid: " & .connid & vbcrlf
            text1.text = text1.text & "connidvalida: " & .connidvalida & vbcrlf
        end with
    end if
end if

end sub
