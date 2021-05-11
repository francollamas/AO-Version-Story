version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "cdialogos"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
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

private const max_dialogos = 300
private const maxlong = 15

private type tdialogo
    formato()  as string
    formateado as boolean
    texto     as string
    delay     as integer
    x         as integer
    y         as integer
    vida      as integer
    userindex as integer
    color     as long
end type

'vector que contiene los dialogos
private dialogos(1 to max_dialogos) as tdialogo
'tiempo de vida de cada mensaje
private delay as integer
'apunta a el ultimo mensaje
public ultimodialogo as integer
'contiene la cantidad de mensajes activos
public cantidaddialogos as integer


private function primerindicevacio() as integer
on error resume next
dim i as integer, j as integer
dim flag as boolean

i = 1
j = 1

do while i <= max_dialogos and not flag
     if (dialogos(i).vida < dialogos(j).vida) then
         j = i
     end if
    flag = (dialogos(i).vida = 0)
    if not flag then i = i + 1
loop

if flag then
    primerindicevacio = i
else
    primerindicevacio = j
end if

end function


'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
'�?�?�?�?�?�?�?�?�?�?�?�?formatea la cadena s�?�?�?�?�?�?�?�?
'�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?�?
private function darformato(s as string, i as integer, k as integer, anti as integer, dialgi as integer)
on error resume next
if anti + i <= len(s) + 1 then
    if ((i >= maxlong) and mid$(s, anti + i, 1) = " ") or (anti + i = len(s)) then
        dialogos(dialgi).formato(k) = mid(s, anti, i + 1)
        k = k + 1
        anti = anti + i + 1
        i = 0
    else
        i = i + 1
    end if
    call darformato(s, i, k, anti, dialgi)
end if

end function

private function hayespacio(s as string) as boolean
on error resume next
if instr(1, s, " ") <> 0 then
    hayespacio = true
else
    hayespacio = false
end if
end function

private sub darleformatotxt(dialgi as integer)
on error resume next
 'le damos formato al txt
  if (len(dialogos(dialgi).texto) > maxlong) and hayespacio(dialogos(dialgi).texto) then
                dim j as integer
                redim dialogos(dialgi).formato(0 to (len(dialogos(dialgi).texto) \ (maxlong \ 2)))
                dim i as integer, k as integer, anti as integer
                anti = 1
                k = 0
                i = 0
                call darformato(dialogos(dialgi).texto, i, k, anti, dialgi)
                i = 0
                do while dialogos(dialgi).formato(i) <> "" and i < ubound(dialogos(dialgi).formato)
                 i = i + 1
                loop
                redim preserve dialogos(dialgi).formato(0 to i - 1)
                dialogos(dialgi).formateado = true
  end if
end sub
public sub creardialogo(txt as string, byval user as integer, color as long)
on error resume next
dim miuserindex as integer
dim indicelibre as integer

if buscaruserindex(user, miuserindex) then
    dialogos(miuserindex).vida = 0
    dialogos(miuserindex).color = color
    dialogos(miuserindex).formateado = false
    dialogos(miuserindex).texto = txt
    dialogos(miuserindex).delay = delay
    dialogos(miuserindex).userindex = user
    dialogos(miuserindex).vida = delay
    darleformatotxt miuserindex
else
    indicelibre = primerindicevacio
    dialogos(indicelibre).color = color
    dialogos(indicelibre).formateado = false
    dialogos(indicelibre).texto = txt
    dialogos(indicelibre).delay = delay
    dialogos(indicelibre).userindex = user
    dialogos(indicelibre).vida = delay
    darleformatotxt indicelibre
    if ultimodialogo > indicelibre then
        ultimodialogo = indicelibre
    end if
end if
    
cantidaddialogos = cantidaddialogos + 1
  
end sub
private function buscaruserindex(user as integer, miuser as integer) as boolean
on error resume next
if cantidaddialogos > 0 then
    dim i as integer
    dim flag as boolean
    i = 1
    
    do while i <= max_dialogos and not flag
           flag = (dialogos(i).userindex = user)
           if not flag then i = i + 1
    loop
    
    if flag then
            miuser = i
            buscaruserindex = true
    else
            buscaruserindex = false
    end if
end if

end function

public sub update_dialog_pos(x as integer, y as integer, index as integer)
on error resume next
dim miuserindex as integer
if buscaruserindex(index, miuserindex) then
  if dialogos(miuserindex).vida > 0 then
        if dialogos(miuserindex).formateado then
            dialogos(miuserindex).x = x - (maxlong \ 2) * 3
            dialogos(miuserindex).y = y - (ubound(dialogos(miuserindex).formato) * 3)
        else
            dialogos(miuserindex).x = x - (len(dialogos(miuserindex).texto) \ 2) * 3
            dialogos(miuserindex).y = y
        end if
        if dialogos(miuserindex).vida > 0 then
           dialogos(miuserindex).vida = dialogos(miuserindex).vida - 1
        end if
        if dialogos(miuserindex).vida < 1 then
            if miuserindex = ultimodialogo then
                
                do while dialogos(ultimodialogo).vida = 0
                    ultimodialogo = ultimodialogo - 1
                    if ultimodialogo < 1 then
                        ultimodialogo = 0
                        cantidaddialogos = 0
                        exit sub
                    end if
                loop
                
            end if
             
            cantidaddialogos = cantidaddialogos - 1
        end if
  end if
end if
end sub
public sub drawtext(lngxpos as integer, lngypos as integer, strtext as string, lngcolor as long)
on error resume next

   if strtext <> "" then
        backbuffersurface.setfonttransparency true
        backbuffersurface.setforecolor vbblack
        backbuffersurface.setfont frmmain.font
        backbuffersurface.drawtext lngxpos - 2, lngypos - 1, strtext, false
        
        backbuffersurface.setfonttransparency true
        backbuffersurface.setforecolor lngcolor
        
        backbuffersurface.setfont frmmain.font
        
        
        backbuffersurface.drawtext lngxpos, lngypos, strtext, false
   end if
   
end sub

public sub drawtextbig(lngxpos as integer, lngypos as integer, strtext as string, lngcolor as long)
on error resume next

   if strtext <> "" then
        backbuffersurface.setfonttransparency true
        backbuffersurface.setforecolor vbblack
        backbuffersurface.setfont frmmain.font
        backbuffersurface.drawtext lngxpos - 2, lngypos - 1, strtext, false
        
        backbuffersurface.setfonttransparency true
        backbuffersurface.setforecolor lngcolor
        backbuffersurface.setfont frmmsg.font
        backbuffersurface.drawtext lngxpos, lngypos, strtext, false
   end if
   
end sub

public sub mostrartexto()
on error resume next
dim i as integer
'for i = 1 to cantidaddialogos
i = 1
do while i <= cantidaddialogos and i <= max_dialogos
    if dialogos(i).vida > 0 then
        if dialogos(i).formateado then
            dim j as integer, desp as integer
            desp = (-frmmain.font.size) * ubound(dialogos(i).formato) - 5
            for j = 0 to ubound(dialogos(i).formato)
             drawtext dialogos(i).x, dialogos(i).y + desp, dialogos(i).formato(j), dialogos(i).color
             desp = desp + (frmmain.font.size) + 5
            next
         else
            drawtext dialogos(i).x, dialogos(i).y, dialogos(i).texto, dialogos(i).color
         end if
    else
      dialogos(i).texto = ""
      dialogos(i).userindex = 0
      dialogos(i).formateado = false
      dialogos(i).delay = 0
    end if
    i = i + 1
loop
'next
end sub

public sub quitardialogo(byval charindex as integer)
on error resume next
dim i as integer

if buscaruserindex(charindex, i) then
      dialogos(i).vida = 0
      dialogos(i).texto = ""
      dialogos(i).userindex = 0
      dialogos(i).formateado = false
      dialogos(i).delay = 0
      cantidaddialogos = cantidaddialogos - 1
      
      if i = ultimodialogo then
        do while dialogos(i).vida = 0
                i = i - 1
                if i < 1 then
                    ultimodialogo = 0
                    cantidaddialogos = 0
                    exit sub
                end if
        loop
      end if
end if



end sub

public sub borrardialogos()

on error resume next

dim i as integer

for i = 1 to max_dialogos
      dialogos(i).vida = 0
      dialogos(i).texto = ""
      dialogos(i).userindex = 0
      dialogos(i).formateado = false
      dialogos(i).delay = 0
next i

end sub

private sub class_initialize()

delay = 300
ultimodialogo = 0
cantidaddialogos = 0

end sub
