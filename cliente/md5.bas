attribute vb_name = "md5"
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
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



' md5.bas - wrapper for rsa md5 dll
'   derived from the rsa data security, inc. md5 message-digest algorithm
' functions:
'   md5string (some string) -> md5 digest of the given string as 32 bytes string
'   md5file (some filename) -> md5 digest of the file's content as a 32 bytes string
'      returns a null terminated "file not found" if unable to open the
'      given filename for input
' bugs, complaints, etc:
'   francisco carlos piragibe de almeida
'   piragibe@esquadro.com.br
' history
'       apr, 17 1999 - fixed the null byte problem
' contains public domain rsa c-code for md5 digest (see md5-original.txt file)
' the aamd532.dll dll must be somewhere in your search path
'   for this to work

private declare sub mdfile lib "aamd532.dll" (byval f as string, byval r as string)
private declare sub mdstringfix lib "aamd532.dll" (byval f as string, byval t as long, byval r as string)

public function md5string(p as string) as string
' compute md5 digest on a given string, returning the result
    dim r as string * 32, t as long
    r = space(32)
    t = len(p)
    mdstringfix p, t, r
    md5string = r
end function

public function md5file(f as string) as string
' compute md5 digest on o given file, returning the result
    dim r as string * 32
    r = space(32)
    mdfile f, r
    md5file = r
end function

