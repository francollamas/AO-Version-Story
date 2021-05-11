version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "diccionario"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'clase diccionario
'basico, plain sin queso ni papa fritas


'mi idea cuando hice esto, lo encontre en el rigido :p. hecha por el oso

option explicit

private const max_elem = 100

private type diccelem
    clave as string
    def as variant
end type

private p_elementos(1 to max_elem) as diccelem 'visual basic es una mierda para usar memoria dinamica, asi que uso esto
private p_cant as integer

public sub class_initialize()
'constructor
    p_cant = 0
end sub

public sub class_terminate()
'destructor
    'destruir los variants?????
end sub

public property get cantelem() as integer
    cantelem = p_cant
end property

public function atput(byval clave as string, byref elem as variant) as boolean
dim i as integer

atput = false

if clave = "" then exit function

clave = ucase$(clave)

if p_cant = max_elem then
    atput = false
else
    for i = 1 to p_cant
        if clave = p_elementos(i).clave then
            p_elementos(i).def = elem
            atput = true
            exit for    ' epa ;)
        end if
    next i
    if not atput then
        p_cant = p_cant + 1
        p_elementos(p_cant).def = elem
        p_elementos(p_cant).clave = clave
        atput = true
    end if

end if
end function

public function at(byval clave as string) as variant
dim i as integer

clave = ucase$(clave)

    at = null
    for i = 1 to p_cant
        if clave = p_elementos(i).clave then
            at = p_elementos(i).def
            exit function
        end if
    next i

end function

public function atindex(byval i as integer) as string
    atindex = p_elementos(i).clave
end function


public function mayorvalor(byref cant as integer) as string
'parchecito para el ao, me da la clave con mayor valor en valor
'y la cantidad de claves con ese valor (por si hay empate)
dim i as integer
dim max as integer
dim clave as string
    max = -1
    cant = 0
    clave = vbnullstring
    for i = 1 to p_cant
        if max <= cint(p_elementos(i).def) then
            cant = iif(max = cint(p_elementos(i).def), cant + 1, 1)
            clave = iif(max = cint(p_elementos(i).def), clave & "," & p_elementos(i).clave, p_elementos(i).clave)
            max = cint(p_elementos(i).def)
        end if
    next i

    mayorvalor = clave

end function

public sub dumpall()
dim i as integer

for i = 1 to max_elem
    p_elementos(i).clave = ""
    p_elementos(i).def = null
next i
p_cant = 0

end sub
