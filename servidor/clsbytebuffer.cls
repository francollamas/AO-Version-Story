version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsbytebuffer"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
option explicit

private declare sub copymemory lib "kernel32" alias "rtlmovememory" ( _
                                    byref destination as any, _
                                    byref source as any, _
                                    byval length as long)

private data() as byte

private currentpos as long
private lastpos as long
private hfile as long

private const invalid_file_handler as integer = -1
private const default_max_size_file as long = 65535
private const byte_size as byte = 1
private const bool_size as byte = 2
private const integer_size as byte = 2
private const long_size as byte = 4
private const single_size as byte = 4
private const double_size as byte = 8
private const string_length_size as byte = 2

public sub initializereader(byref arraybyte() as byte)
lastpos = ubound(arraybyte)
redim data(lastpos) as byte

call copymemory(data(0), arraybyte(0), lastpos + 1)
currentpos = 0
end sub

public sub initializewriter(byval filehandler as integer)
redim data(default_max_size_file * 20) as byte

hfile = filehandler
currentpos = 0
lastpos = -1
end sub

public sub getbytes(byref destination() as byte, optional byval length as long = -1)
if length >= 0 then
    call copymemory(destination(0), data(currentpos), length)
else
    call copymemory(destination(0), data(0), lastpos + 1)
end if
end sub

public function getbyte() as byte
getbyte = data(currentpos)
currentpos = currentpos + byte_size
end function

public function getboolean() as boolean
call copymemory(getboolean, data(currentpos), bool_size)
currentpos = currentpos + bool_size
end function

public function getinteger() as integer
call copymemory(getinteger, data(currentpos), integer_size)
currentpos = currentpos + integer_size
end function

public function getlong() as long
call copymemory(getlong, data(currentpos), long_size)
currentpos = currentpos + long_size
end function

public function getsingle() as single
call copymemory(getsingle, data(currentpos), single_size)
currentpos = currentpos + single_size
end function

public function getdouble() as double
call copymemory(getdouble, data(currentpos), double_size)
currentpos = currentpos + double_size
end function

public function getstring(optional byval length as integer = -1) as string
dim ret() as byte

if length < 0 then
    length = getinteger()
    getstring = getstring(length)
else
    if length > 0 then
        redim ret(length - 1) as byte
        
        call copymemory(ret(0), data(currentpos), length)
        
        getstring = strconv(ret, vbunicode)
        currentpos = currentpos + length
    end if
end if

end function

public sub putbyte(byval value as byte)
data(lastpos + 1) = value
lastpos = lastpos + byte_size
end sub

public sub putboolean(byval value as boolean)
call copymemory(data(lastpos + 1), value, bool_size)
lastpos = lastpos + bool_size
end sub

public sub putinteger(byval value as integer)
call copymemory(data(lastpos + 1), value, integer_size)
lastpos = lastpos + integer_size
end sub

public sub putlong(byval value as long)
call copymemory(data(lastpos + 1), value, long_size)
lastpos = lastpos + long_size
end sub

public sub putsingle(byval value as single)
call copymemory(data(lastpos + 1), value, single_size)
lastpos = lastpos + single_size
end sub

public sub putdouble(byval value as double)
call copymemory(data(lastpos + 1), value, double_size)
lastpos = lastpos + double_size
end sub

public sub putstring(byref str as string, optional byval withlength as boolean = true)
dim length as long

length = len(str)

if withlength then
    call putinteger(length)
    call putstring(str, false)
else
    if length > 0 then
        call copymemory(data(lastpos + 1), byval strptr(strconv(str, vbfromunicode)), length)
    
        lastpos = lastpos + length
    end if
end if
end sub

public sub getvoid(byval length as integer)
currentpos = currentpos + length
end sub

public sub putvoid(byval length as integer)
lastpos = lastpos + length
end sub

public sub cleardata()
redim data(default_max_size_file) as byte

currentpos = 0
lastpos = -1
hfile = -1
end sub

public function getlastpos() as long
getlastpos = lastpos
end function

public function getcurrentpos() as long
getcurrentpos = currentpos
end function

public function eof() as boolean
eof = (currentpos > ubound(data))
end function

public sub savebuffer()
dim buf() as byte

if hfile > 0 then
    redim buf(lastpos) as byte
    
    call copymemory(buf(0), data(0), lastpos + 1)
    put hfile, , buf
end if
end sub

private sub class_initialize()
hfile = invalid_file_handler
end sub

private sub class_terminate()
erase data()
end sub
