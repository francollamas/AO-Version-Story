version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "ccola"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'argentum online 0.11.6
'copyright (c) 2002 m�rquez pablo ignacio
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
'                    metodos publicos
'
' public sub push(byval i as variant) mete el elemento i
' al final de la cola.
'
' public function pop as variant: quita de la cola el primer elem
' y lo devuelve
'
' public function verelemento(byval index as integer) as variant
' muestra el elemento numero index de la cola sin quitarlo
'
' public function popbyval() as variant: muestra el primer
' elemento de la cola sin quitarlo
'
' public property get longitud() as integer: devuelve la
' cantidad de elementos que tiene la cola.

private const frente = 1

private cola as collection

public sub reset()
on error resume next

dim i as integer
for i = 1 to me.longitud
    cola.remove frente
next i

end sub

public property get longitud() as integer
longitud = cola.count
end property

private function indexvalido(byval i as integer) as boolean
indexvalido = i >= 1 and i <= me.longitud
end function

private sub class_initialize()
set cola = new collection
end sub

public function verelemento(byval index as integer) as string
on error resume next
    if indexvalido(index) then
        'pablo
        verelemento = ucase$(cola.item(index))
        '/pablo
        'verelemento = cola(index)
    else
        verelemento = 0
    end if
end function


public sub push(byval nombre as string)
on error resume next
'mete elemento en la cola
'pablo
dim aux as string
aux = time$ + " " + ucase$(nombre)
call cola.add(aux)
'/pablo

'call cola.add(ucase$(nombre))
end sub

public function pop() as string
on error resume next
'quita elemento de la cola
if cola.count > 0 then
    pop = cola(frente)
    call cola.remove(frente)
else
    pop = 0
end if
end function

public function popbyval() as string
on error resume next
'call logtarea("popbyval sos")

'quita elemento de la cola
if cola.count > 0 then
    popbyval = cola.item(1)
else
    popbyval = 0
end if

end function

public function existe(byval nombre as string) as boolean
on error resume next
  
 dim v as string
 dim i as integer
 dim nombreenmayusculas as string
 nombreenmayusculas = ucase$(nombre)
 
 for i = 1 to me.longitud
        'pablo
        v = mid$(me.verelemento(i), 10, len(me.verelemento(i)))
        '/pablo
        'v = me.verelemento(i)
        if v = nombreenmayusculas then
            existe = true
            exit function
        end if
 next
 existe = false

end function

public sub quitar(byval nombre as string)
on error resume next
dim v as string
dim i as integer
dim nombreenmayusculas as string
 
nombreenmayusculas = ucase$(nombre)
 
for i = 1 to me.longitud
    'pablo
    v = mid$(me.verelemento(i), 10, len(me.verelemento(i)))
    '/pablo
    'v = me.verelemento(i)
    if v = nombreenmayusculas then
        call cola.remove(i)
        exit sub
    end if
next i
 
end sub

public sub quitarindex(byval index as integer)
on error resume next
if indexvalido(index) then call cola.remove(index)
end sub


private sub class_terminate()
'destruimos el objeto cola
set cola = nothing
end sub
