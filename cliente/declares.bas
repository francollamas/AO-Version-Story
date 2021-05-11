attribute vb_name = "mod_declaraciones"
'argentum online 0.9.0.9
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
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

public rawserverslist as string

public type tserverinfo
    ip as string
    puerto as integer
    desc as string
    passrecport as integer
end type

public serverslst() as tserverinfo
public serversrecibidos as boolean

public curserver as integer

public creandoclan as boolean
public clanname as string
public site as string

public userciego as boolean
public userestupido as boolean


public const bcabeza = 1
public const bpiernaizquierda = 2
public const bpiernaderecha = 3
public const bbrazoderecho = 4
public const bbrazoizquierdo = 5
public const btorso = 6

'timers de gettickcount
public const tat = 2000
public const tus = 600

public const primerbodybarco = 84
public const ultimobodybarco = 87


public dialogos as new cdialogos
public numescudosanims as integer

public armasherrero(0 to 100) as integer
public armadurasherrero(0 to 100) as integer
public objcarpintero(0 to 100) as integer

'[kevin]
public const max_bancoinventory_slots = 40
public userbancoinventory(1 to max_bancoinventory_slots) as inventory
'[/kevin]


public tips() as string * 255
public const loopadeternum = 999

public const numciudades = 3

'direcciones
public const north = 1
public const east = 2
public const south = 3
public const west = 4

'objetos
public const max_inventory_objs = 10000
public const max_inventory_slots = 20
public const max_npc_inventory_slots = 50
public const maxhechi = 35

public const numskills = 21
public const numatributos = 5
public const numclases = 16
public const numrazas = 5

public const maxskillpoints = 100

public const flagoro = 777

public const fogata = 1521


public const suerte = 1
public const magia = 2
public const robar = 3
public const tacticas = 4
public const armas = 5
public const meditar = 6
public const apu�alar = 7
public const ocultarse = 8
public const supervivencia = 9
public const talar = 10
public const comerciar = 11
public const defensa = 12
public const pesca = 13
public const mineria = 14
public const carpinteria = 15
public const herreria = 16
public const curacion = 17
public const domar = 18
public const proyectiles = 19
public const wresterling = 20
public const navegacion = 21

public const fundirmetal = 88

'inventario
type inventory
    objindex as integer
    name as string
    grhindex as integer
    '[alejo]: tipo de datos ahora es long
    amount as long
    '[/alejo]
    equipped as byte
    valor as long
    objtype as integer
    def as integer
    maxhit as integer
    minhit as integer
end type

type npcinv
    objindex as integer
    name as string
    grhindex as integer
    amount as integer
    valor as long
    objtype as integer
    def as integer
    maxhit as integer
    minhit as integer
    c1 as string
    c2 as string
    c3 as string
    c4 as string
    c5 as string
    c6 as string
    c7 as string
    
end type

type treputacion 'fama del usuario
    noblerep as long
    burguesrep as long
    pleberep as long
    ladronesrep as long
    bandidorep as long
    asesinorep as long
    
    promedio as long
end type

public listarazas() as string
public listaclases() as string

public nombres as boolean

public mixedkey as long

'user status vars
public userinventory(1 to max_inventory_slots) as inventory
global otroinventario(1 to max_inventory_slots) as inventory

public userhechizos(1 to maxhechi) as integer

public npcinventory(1 to max_npc_inventory_slots) as npcinv
public npcinvdim as integer
public usermeditar as boolean
public username as string
public userpassword as string
public usermaxhp as integer
public userminhp as integer
public usermaxman as integer
public userminman as integer
public usermaxsta as integer
public userminsta as integer
public usergld as long
public userlvl as integer
public userport as integer
public userserverip as string
public usercanattack as integer
public userestado as byte '0 = vivo & 1 = muerto
public userpasarnivel as long
public userexp as long
public userreputacion as treputacion
public userdescansar as boolean
public tipf as string
public primeravez as boolean
public fpsflag as boolean
public pausa as boolean
public iscombate as boolean
public userparalizado as boolean
public usernavegando as boolean
public userhogar as string

'<-------------------------nuevo-------------------------->
public comerciando as boolean
'<-------------------------nuevo-------------------------->

public userclase as string
public usersexo as string
public userraza as string
public useremail as string

public userskills() as integer
public skillsnames() as string

public useratributos() as integer
public atributosnames() as string

public ciudades() as string
public citydesc() as string

public musica as byte
public fx as byte

public skillpoints as integer
public alocados as integer
public flags() as integer
public oscuridad as integer
public logged as boolean
public nopuedeusar as boolean

public usingskill as integer


public md5hushyo as string * 16

public enum e_modo
    normal = 1
    borrarpj = 2
    crearnuevopj = 3
    dados = 4
    recuperarpass = 5
end enum
public estadologin as e_modo

'server stuff
public requestpostimer as integer 'used in main loop
public stxtbuffer as string 'holds temp raw data from server
public sendnewchar as boolean 'used during login
public connected as boolean 'true when connected to server
public downloadingmap as boolean 'currently downloading a map from server
public usermap as integer

'string contants
public endc as string 'endline character for talking with server
public endl as string 'holds the endline character for textboxes

'control
public prgrun as boolean 'when true the program ends
public finpres as boolean

public ipdelservidor as string
public puertodelservidor as string

'********** funciones api ***********
public declare function gettickcount lib "kernel32" () as long

'para escribir y leer variables
public declare function writeprivateprofilestring lib "kernel32" alias "writeprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpstring as string, byval lpfilename as string) as long
public declare function getprivateprofilestring lib "kernel32" alias "getprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpdefault as string, byval lpreturnedstring as string, byval nsize as long, byval lpfilename as string) as long

'teclado
public declare function getkeystate lib "user32" (byval nvirtkey as long) as integer
public declare sub sleep lib "kernel32" (byval dwmilliseconds as long)

'lista de cabezas
public type tindicecabeza
    head(1 to 4) as integer
end type

public type tindicecuerpo
    body(1 to 4) as integer
    headoffsetx as integer
    headoffsety as integer
end type

public type tindicefx
    animacion as integer
    offsetx as integer
    offsety as integer
end type


