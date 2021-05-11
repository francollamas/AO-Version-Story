version 5.00
begin vb.form frmuserlist 
   caption         =   "form1"
   clientheight    =   4665
   clientleft      =   60
   clienttop       =   345
   clientwidth     =   5520
   linktopic       =   "form1"
   scaleheight     =   4665
   scalewidth      =   5520
   startupposition =   3  'windows default
   begin vb.commandbutton command2 
      caption         =   "echar todos los no logged"
      height          =   375
      left            =   120
      tabindex        =   4
      top             =   4200
      width           =   2175
   end
   begin vb.textbox text2 
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
      caption         =   "actualiza"
      height          =   375
      left            =   120
      tabindex        =   1
      top             =   3720
      width           =   2175
   end
   begin vb.listbox list1 
      height          =   3570
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
