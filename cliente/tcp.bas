attribute vb_name = "mod_tcp"
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
'
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
public warping as boolean
public llegaronskills as boolean
public llegaronatrib as boolean
public llegofama as boolean



public function puedoquitarfoco() as boolean
puedoquitarfoco = true
'puedoquitarfoco = not frmestadisticas.visible and _
'                 not frmguildadm.visible and _
'                 not frmguilddetails.visible and _
'                 not frmguildbrief.visible and _
'                 not frmguildfoundation.visible and _
'                 not frmguildleader.visible and _
'                 not frmcharinfo.visible and _
'                 not frmguildnews.visible and _
'                 not frmguildsol.visible and _
'                 not frmcommet.visible and _
'                 not frmpeaceprop.visible
'
end function

sub login()
    if estadologin = e_modo.normal then
        call writeloginexistingchar
    elseif estadologin = e_modo.crearnuevopj then
        call writeloginnewchar
    end if
    
    doevents
    
    call flushbuffer
end sub
