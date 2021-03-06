version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsantimassclon"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'argentum online 0.12.2
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

private const maximopersonajesporip = 15
private m_coleccion as collection

public function maxpersonajes(sip as string) as boolean
    dim i as long

    for i = 1 to m_coleccion.count
        if m_coleccion.item(i).ip = sip then
            m_coleccion.item(i).personajescreados = m_coleccion.item(i).personajescreados + 1
            maxpersonajes = (m_coleccion.item(i).personajescreados > maximopersonajesporip)
            if maxpersonajes then m_coleccion.item(i).personajescreados = 16
            exit function
        end if
    next i

#if seguridadalkon then
    dim oip as useripadress
    set oip = new useripadress
    oip.ip = sip
    oip.personajescreados = 1
    m_coleccion.add oip
#end if

    maxpersonajes = false
    exit function
end function

public function vaciarcoleccion()

on error goto errhandler

dim i as integer

for i = 1 to m_coleccion.count
   call m_coleccion.remove(1)
next


exit function
errhandler:
    call logerror("error en restarconexion " & err.description)
end function


private sub class_initialize()
    set m_coleccion = new collection
end sub
