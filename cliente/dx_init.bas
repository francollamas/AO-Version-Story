attribute vb_name = "mod_dx"
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

public directx as new directx7
public directdraw as directdraw7

public primarysurface as directdrawsurface7
public primaryclipper as directdrawclipper
public secundaryclipper as directdrawclipper
public backbuffersurface as directdrawsurface7

public oldresheight as long, oldreswidth as long
public bnoreschange as boolean

private sub iniciardxobject(dx as directx7)

err.clear

on error resume next

set dx = new directx7

if err then
    msgbox "no se puede iniciar directx. por favor asegurese de tener la ultima version correctamente instalada."
    logerror "error producido por set dx = new directx7"
    end
end if

end sub

private sub iniciarddobject(dd as directdraw7)
err.clear
on error resume next
set dd = directx.directdrawcreate("")
if err then
    msgbox "no se puede iniciar directdraw. por favor asegurese de tener la ultima version correctamente instalada."
    logerror "error producido en private sub iniciarddobject(dd as directdraw7)"
    end
end if
end sub

public sub iniciarobjetosdirectx()

on error resume next

call addtorichtextbox(frmcargando.status, "iniciando directx....", 0, 0, 0, 0, 0, true)
call iniciardxobject(directx)
call addtorichtextbox(frmcargando.status, "hecho", , , , 1, , false)

call addtorichtextbox(frmcargando.status, "iniciando directdraw....", 0, 0, 0, 0, 0, true)
call iniciarddobject(directdraw)
call addtorichtextbox(frmcargando.status, "hecho", , , , 1, , false)

call addtorichtextbox(frmcargando.status, "analizando y preparando la placa de video....", 0, 0, 0, 0, 0, true)

  
    
dim lres as long
dim midevm as typdevmode
lres = enumdisplaysettings(0, 0, midevm)
    
dim intwidth as integer
dim intheight as integer

oldreswidth = screen.width \ screen.twipsperpixelx
oldresheight = screen.height \ screen.twipsperpixely

dim cambiarresolucion as boolean

if nores then
    cambiarresolucion = (oldreswidth < 800 or oldresheight < 600)
else
    cambiarresolucion = (oldreswidth <> 800 or oldresheight <> 600)
end if

if cambiarresolucion then
      with midevm
            .dmfields = dm_pelswidth or dm_pelsheight or dm_bitsperpel
            .dmpelswidth = 800
            .dmpelsheight = 600
            .dmbitsperpel = 16
      end with
      lres = changedisplaysettings(midevm, cds_test)
else
      bnoreschange = true
end if

call addtorichtextbox(frmcargando.status, "�directx ok!", 0, 251, 0, 1, 0)

exit sub

end sub

public sub liberarobjetosdx()
err.clear
on error goto fin:
dim loopc as integer

set primarysurface = nothing
set primaryclipper = nothing
set backbuffersurface = nothing

set directdraw = nothing

set directx = nothing
exit sub
fin: logerror "error producido en public sub liberarobjetosdx()"
end sub

