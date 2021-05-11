version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsleerinis"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'modulo para optimizar la lectura de archivos en
'formato ini
'
'creado por alejandro santos
'

option explicit

public enum tmodoleeini
    modo_cachear = 1    'usa el nuevo sistema de leeinis-o-matico
    modo_api = 2        'usa el viejo sistema de getprivateprofilestring
end enum

private msecciones as collection
private march as string
private mmodo as tmodoleeini

private declare function getprivateprofilestring lib "kernel32" alias "getprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpdefault as string, byval lpreturnedstring as string, byval nsize as long, byval lpfilename as string) as long

public sub abrir(arch as string, optional modo as tmodoleeini = modo_cachear)

if dir(arch, vbnormal) = "" then exit sub

mmodo = modo
march = arch
set msecciones = nothing

select case mmodo
case modo_cachear
    call abrircacheado(arch)
case modo_api
    ' ???
end select
end sub

public function darvalor(byval secc as string, byval clave as string) as string
select case mmodo
case modo_cachear
    darvalor = darvalorcacheado(secc, clave)
case modo_api
    darvalor = darvalorapi(secc, clave)
end select

end function

private sub abrircacheado(byval arch as string)
dim archnum as integer
dim linea as string
dim pos as long

dim seccion as string, clavevalor() as string
dim colseccion as collection

archnum = freefile()

set msecciones = nothing
set msecciones = new collection

on error goto hayerror
open arch for input as #archnum
on error goto 0

do while not eof(archnum)
    line input #archnum, linea
    if left(linea, 1) = "[" and len(linea) > 2 then
        pos = instr(1, linea, "]")
        if pos > 2 then
            seccion = ucase(trim(mid(linea, 2, pos - 2)))
        else
            seccion = ""
        end if
    elseif seccion <> "" then
        clavevalor = split(linea, "=", 2)
        if ubound(clavevalor) - lbound(clavevalor) = 1 then
            on local error resume next
            set colseccion = msecciones(seccion)
            if err then 'la seccion no existe
                set colseccion = new collection
                msecciones.add colseccion, seccion
            end if
            on local error goto 0
            
            'malditos inis, formato pedorrooooooo
            clavevalor(lbound(clavevalor)) = ucase(trim(clavevalor(lbound(clavevalor))))
            clavevalor(ubound(clavevalor)) = replace(clavevalor(ubound(clavevalor)), """", "")
            
            on local error resume next
            colseccion.add clavevalor(ubound(clavevalor)), clavevalor(lbound(clavevalor))
'            if err then
'                colseccion.remove clavevalor(ubound(clavevalor))
'                colseccion.add clavevalor(ubound(clavevalor)), clavevalor(lbound(clavevalor))
'            end if
            on local error goto 0
            
            set colseccion = nothing
        end if
    end if
loop

close #archnum
exit sub
hayerror:

end sub

private function darvalorcacheado(byval secc as string, byval clave as string) as string
dim ret as string

darvalorcacheado = ""
on local error resume next
darvalorcacheado = msecciones(ucase$(secc)).item(ucase$(clave))
on local error goto 0

end function

private function darvalorapi(byval secc as string, byval clave as string) as string

dim sspaces as string ' this will hold the input that the program will retrieve
dim szreturn as string ' this will be the defaul value if the string is not found
  
szreturn = ""
  
sspaces = space(5000) ' this tells the computer how long the longest string can be

getprivateprofilestring secc, clave, szreturn, sspaces, len(sspaces), march
  
sspaces = rtrim(sspaces)
darvalorapi = left$(sspaces, len(sspaces) - 1)

end function
