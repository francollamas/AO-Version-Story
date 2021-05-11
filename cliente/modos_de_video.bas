attribute vb_name = "mod_modos_de_video"
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

'testea si la maquina soporta un modo de video ;-)
function soportadisplay(dd as directdraw7, ddsdatestear as ddsurfacedesc2) as boolean
dim ddsd as ddsurfacedesc2
dim ddem as directdrawenummodes

set ddem = dd.getdisplaymodesenum(ddedm_default, ddsd)

dim loopc as integer
dim flag as boolean
loopc = 1
   
do while loopc <> ddem.getcount and not flag

    ddem.getitem loopc, ddsd
    flag = ddsd.lheight = ddsdatestear.lheight _
    and ddsd.lwidth = ddsdatestear.lwidth _
    and ddsd.ddpfpixelformat.lrgbbitcount = _
    ddsdatestear.ddpfpixelformat.lrgbbitcount
    loopc = loopc + 1
loop
soportadisplay = flag
end function

function modosdevideoiguales(dd1 as ddsurfacedesc2, dd2 as ddsurfacedesc2) as boolean
modosdevideoiguales = _
    dd1.lheight = dd2.lheight _
    and dd1.lwidth = dd2.lwidth _
    and dd1.ddpfpixelformat.lrgbbitcount = _
    dd2.ddpfpixelformat.lrgbbitcount
end function


