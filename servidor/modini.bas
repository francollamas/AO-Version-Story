attribute vb_name = "modini"
'argentum online 0.11.20
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

''modulo para utilizar la dll leeinis.dll
''creado por alejandro santos
'
''int dllimport inidarerror();
''unsigned int dllimport inicarga (const char* arch);
''unsigned int dllimport inidescarga (unsigned int pa);
''int dllimport inidarnumsecciones(unsigned int a);
''int dllimport inidarnombreseccion(unsigned int a, int n, char* buff, int tam);
''int dllimport inibuscarseccion(unsigned int a, const char* buff);
''long dllimport inidarclave(unsigned int a, long n, const char* clave, const char* buff, long tam);
''long dllimport inidarclaveint(unsigned int a, long n, const char* clave);
''long dllimport inidarnumclaves(unsigned int a, long n);
''long dllimport inidarnombreclave(unsigned int a, long n, long clave, char* buff, long tam);
''long dllimport iniconf(unsigned int a, long defint, const char* defstr, long casesensitive);
'
'public declare function inicarga lib "leeinis.dll" (byval arch as string) as long
'public declare function inidescarga lib "leeinis.dll" (byval a as long) as long
'public declare function inidarerror lib "leeinis.dll" () as long
'
'public declare function inidarnumsecciones lib "leeinis.dll" (byval a as long) as long
'public declare function inidarnombreseccion lib "leeinis.dll" (byval a as long, byval n as long, byval buff as string, byval tam as long) as long
'public declare function inibuscarseccion lib "leeinis.dll" (byval a as long, byval buff as string) as long
'
'public declare function inidarclave lib "leeinis.dll" (byval a as long, byval n as long, byval clave as string, byval buff as string, byval tam as long) as long
'public declare function inidarclaveint lib "leeinis.dll" (byval a as long, byval n as long, byval clave as string) as long
'public declare function inidarnumclaves lib "leeinis.dll" (byval a as long, byval n as long) as long
'public declare function inidarnombreclave lib "leeinis.dll" (byval a as long, byval n as long, byval clave as long, byval buff as string, byval tam as long) as long
'
'public declare function iniconf lib "leeinis.dll" (byval a as long, byval defectoint as long, byval defectostr as string, byval casesensitive as long) as long
'
'
'public function inidarclavestr(a as long, seccion as long, clave as string) as string
'dim tmp as string
'dim p as long, r as long
'
'tmp = space(3000)
'r = inidarclave(a, seccion, clave, tmp, 3000)
'p = instr(1, tmp, chr(0))
'if p > 0 then
'    tmp = left(tmp, p - 1)
'    'tmp = replace(tmp, chr(34), "")
'    inidarclavestr = tmp
'end if
'
'end function
'
'public function inidarnombreseccionstr(a as long, seccion as long) as string
'dim tmp as string
'dim p as long, r as long
'
'tmp = space(3000)
'r = inidarnombreseccion(a, seccion, tmp, 3000)
'p = instr(1, tmp, chr(0))
'if p > 0 then
'    tmp = left(tmp, p - 1)
'    inidarnombreseccionstr = tmp
'end if
'
'end function
'
'public function inidarnombreclavestr(a as long, seccion as long, clave as long) as string
'dim tmp as string
'dim p as long, r as long
'
'tmp = space(3000)
'r = inidarnombreclave(a, seccion, clave, tmp, 3000)
'p = instr(1, tmp, chr(0))
'if p > 0 then
'    tmp = left(tmp, p - 1)
'    inidarnombreclavestr = tmp
'end if
'
'end function
'
