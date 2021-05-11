version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "ccolaarray"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'argentum online 0.9.0.2
'copyright (c) 2002 m�rquez pablo ignacio
'
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

private m_maxelem as long

private m_array() as string
private m_lastelem as integer
private m_firstelem as integer
private m_size as integer

public function isempty() as boolean
isempty = m_size = 0
end function

public function isfull() as boolean
'isfull = m_lastelem = m_maxelem
isfull = m_size = m_maxelem
end function

public function push(byval astring as string) as boolean

if not me.isfull then
    
    if me.isempty then m_firstelem = 1
    
    m_lastelem = m_lastelem + 1
    if (m_lastelem > m_maxelem) then m_lastelem = m_lastelem - m_maxelem
    m_size = m_size + 1
    m_array(m_lastelem) = astring
    
    push = true
else
    push = false
end if


end function

public function pop() as string

if not me.isempty then
    
    pop = m_array(m_firstelem)
    m_firstelem = m_firstelem + 1
    if (m_firstelem > m_maxelem) then m_firstelem = m_firstelem - m_maxelem
    m_size = m_size - 1
    
    'if m_firstelem > m_lastelem and m_size = 0 then
    if m_size = 0 then
            m_lastelem = 0
            m_firstelem = 0
            m_size = 0
    end if
else
    pop = ""
    
end if

end function

private sub class_initialize()
m_lastelem = 0
m_firstelem = 0
m_size = 0
m_maxelem = 300

redim m_array(1 to m_maxelem)
end sub

public property get maxelems() as long
maxelems = m_maxelem
end property

public property let maxelems(byval lnewvalue as long)
m_maxelem = lnewvalue
redim preserve m_array(1 to m_maxelem)

end property
