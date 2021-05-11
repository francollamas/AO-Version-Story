version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clinkedlist"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'coded by gulfas morgolock
'morgolock@speedy.com.ar

option explicit

private const max = 300

private type tnodo
        data as object
        next as integer
end type

private m_linkedlist(1 to max) as tnodo
private m_size as integer
private m_head as integer
private m_tail as integer

public sub clearlist()

dim k as integer

for k = 1 to max
    set m_linkedlist(k).data = nothing
    m_linkedlist(k).next = 0
next k

m_size = 0
m_head = 0
m_tail = 0

end sub

public function size() as integer
size = m_size
end function

private function getfreeindex() as integer

dim k as integer

for k = 1 to max
    if m_linkedlist(k).data is nothing then
                getfreeindex = k
                exit function
    end if
next k

end function

public sub insert(byref obj as object)

if me.size = 0 then
    set m_linkedlist(1).data = obj
    m_linkedlist(1).next = 0
    m_head = 1
    m_tail = 1
else
    if m_size < max then
        dim j as integer
        j = getfreeindex
        set m_linkedlist(j).data = obj
        m_linkedlist(j).next = 0
        m_linkedlist(m_tail).next = j
        m_tail = j
    end if
end if

m_size = m_size + 1

end sub

public function includes(byval obj as object) as boolean

if m_size > 0 then
    dim k as integer
    k = m_head
    do
        if m_linkedlist(k).data.equal(obj) then
            includes = true
            exit function
        end if
        
        k = m_linkedlist(k).next
        
    loop while k <> 0
else
    includes = false
end if

end function

public function getobjbyindex(byval index as integer) as object

if m_size > 0 and index > 0 then
    if index = 1 then
        set getobjbyindex = m_linkedlist(m_head).data
        exit function
    else
        dim k as integer, ant as integer, cont as integer
        k = m_head
        cont = 0
        do
            ant = k
            k = m_linkedlist(k).next
            cont = cont + 1
        loop while k <> 0 and cont < index
        set getobjbyindex = m_linkedlist(ant).data
    end if
end if



end function

public function getbutonat(byval x as single, byval y as single) as object

dim j as integer, myobj as object
for j = 1 to m_size
    set myobj = me.getobjbyindex(j)
    if myobj.clicked(x, y) then
            set getbutonat = myobj
            exit function
    end if
next j

set getbutonat = nothing
    
end function


public sub remove(byref obj as object)

if m_size > 0 then
    dim k as integer, ant as integer
    k = m_head
    ant = k
    do
        if m_linkedlist(k).data.equal(obj) then
            if m_head = k then m_head = m_linkedlist(k).next
            if m_tail = k then m_tail = ant
            m_linkedlist(ant).next = m_linkedlist(k).next
            set m_linkedlist(k).data = nothing
            m_linkedlist(k).next = 0
            m_size = m_size - 1
            exit sub
        end if
        ant = k
        k = m_linkedlist(k).next
    loop while k <> 0
end if

end sub
