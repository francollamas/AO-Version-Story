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

'objetos p�blicos
public dialogosclanes as new clsguilddlg
public dialogos as new cdialogos
public audio as new clsaudio
public inventario as new clsgrapchicalinventory
public surfacedb as clssurfacemanager   'no va new porque es unainterfaz, el new se pone al decidir que clase de objeto es

#if seguridadalkon then
public md5 as new clsmd5
#end if

'sonidos
public const snd_click as string = "click.wav"
public const snd_pasos1 as string = "23.wav"
public const snd_pasos2 as string = "24.wav"
public const snd_navegando as string = "50.wav"
public const snd_over as string = "click2.wav"
public const snd_dice as string = "cupdice.wav"
public const snd_lluviainend as string = "lluviainend.wav"
public const snd_lluviaoutend as string = "lluviaoutend.wav"

'musica
public const midi_inicio as byte = 6

public rawserverslist as string

public type tcolor
    r as byte
    g as byte
    b as byte
end type

public colorespj(0 to 50) as tcolor


public type tserverinfo
    ip as string
    puerto as integer
    desc as string
    passrecport as integer
end type

public currentmidi as long

public serverslst() as tserverinfo
public serversrecibidos as boolean

public curserver as integer

public creandoclan as boolean
public clanname as string
public site as string

public userciego as boolean
public userestupido as boolean

public nores as boolean 'no cambiar la resolucion

public rainbufferindex as long
public fogatabufferindex as long

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

public numescudosanims as integer

public armasherrero(0 to 100) as integer
public armadurasherrero(0 to 100) as integer
public objcarpintero(0 to 100) as integer

public versiones(1 to 7) as integer

public usamacro as boolean
public cntd as byte
public secuenciamacrohechizos as byte



'[kevin]
public const max_bancoinventory_slots = 40
public userbancoinventory(1 to max_bancoinventory_slots) as inventory
'[/kevin]


public tips() as string * 255
public const loopadeternum = 999

'direcciones
public enum e_heading
    north = 1
    east = 2
    south = 3
    west = 4
end enum

'objetos
public const max_inventory_objs = 10000
public const max_inventory_slots = 20
public const max_npc_inventory_slots = 50
public const maxhechi = 35

public const maxskillpoints = 100

public const flagoro = 777

public const fogata = 1521

public enum skills
     suerte = 1
     magia = 2
     robar = 3
     tacticas = 4
     armas = 5
     meditar = 6
     apu�alar = 7
     ocultarse = 8
     supervivencia = 9
     talar = 10
     comerciar = 11
     defensa = 12
     pesca = 13
     mineria = 14
     carpinteria = 15
     herreria = 16
     liderazgo = 17 ' nota: solia decir "curacion"
     domar = 18
     proyectiles = 19
     wresterling = 20
     navegacion = 21
end enum

public const fundirmetal as integer = 88

'
' mensajes
'
' mensaje_*  --> mensajes de texto que se muestran en el cuadro de texto
'

public const mensaje_criatura_falla_golpe as string = "la criatura fallo el golpe!!!"
public const mensaje_criatura_matado as string = "la criatura te ha matado!!!"
public const mensaje_rechazo_ataque_escudo as string = "has rechazado el ataque con el escudo!!!"
public const mensaje_usuario_rechazo_ataque_escudo  as string = "el usuario rechazo el ataque con su escudo!!!"
public const mensaje_fallado_golpe as string = "has fallado el golpe!!!"
public const mensaje_seguro_activado as string = ">>seguro activado<<"
public const mensaje_seguro_desactivado as string = ">>seguro desactivado<<"
public const mensaje_pierde_nobleza as string = "��has perdido puntaje de nobleza y ganado puntaje de criminalidad!! si sigues ayudando a criminales te convertir�s en uno de ellos y ser�s perseguido por las tropas de las ciudades."
public const mensaje_usar_meditando as string = "�est�s meditando! debes dejar de meditar para usar objetos."

public const mensaje_golpe_cabeza as string = "��la criatura te ha pegado en la cabeza por "
public const mensaje_golpe_brazo_izq as string = "��la criatura te ha pegado el brazo izquierdo por "
public const mensaje_golpe_brazo_der as string = "��la criatura te ha pegado el brazo derecho por "
public const mensaje_golpe_pierna_izq as string = "��la criatura te ha pegado la pierna izquierda por "
public const mensaje_golpe_pierna_der as string = "��la criatura te ha pegado la pierna derecha por "
public const mensaje_golpe_torso  as string = "��la criatura te ha pegado en el torso por "

' mensaje_[12]: aparecen antes y despues del valor de los mensajes anteriores (mensaje_golpe_*)
public const mensaje_1 as string = "��"
public const mensaje_2 as string = "!!"

public const mensaje_golpe_criatura_1 as string = "��le has pegado a la criatura por "

public const mensaje_ataque_fallo as string = " te ataco y fallo!!"

public const mensaje_recive_impacto_cabeza as string = " te ha pegado en la cabeza por "
public const mensaje_recive_impacto_brazo_izq as string = " te ha pegado el brazo izquierdo por "
public const mensaje_recive_impacto_brazo_der as string = " te ha pegado el brazo derecho por "
public const mensaje_recive_impacto_pierna_izq as string = " te ha pegado la pierna izquierda por "
public const mensaje_recive_impacto_pierna_der as string = " te ha pegado la pierna derecha por "
public const mensaje_recive_impacto_torso as string = " te ha pegado en el torso por "

public const mensaje_produce_impacto_1 as string = "��le has pegado a "
public const mensaje_produce_impacto_cabeza as string = " en la cabeza por "
public const mensaje_produce_impacto_brazo_izq as string = " en el brazo izquierdo por "
public const mensaje_produce_impacto_brazo_der as string = " en el brazo derecho por "
public const mensaje_produce_impacto_pierna_izq as string = " en la pierna izquierda por "
public const mensaje_produce_impacto_pierna_der as string = " en la pierna derecha por "
public const mensaje_produce_impacto_torso as string = " en el torso por "

public const mensaje_trabajo_magia as string = "haz click sobre el objetivo..."
public const mensaje_trabajo_pesca as string = "haz click sobre el sitio donde quieres pescar..."
public const mensaje_trabajo_robar as string = "haz click sobre la victima..."
public const mensaje_trabajo_talar as string = "haz click sobre el �rbol..."
public const mensaje_trabajo_mineria as string = "haz click sobre el yacimiento..."
public const mensaje_trabajo_fundirmetal as string = "haz click sobre la fragua..."
public const mensaje_trabajo_proyectiles as string = "haz click sobre la victima..."

public const mensaje_entrar_party_1 as string = "si deseas entrar en una party con "
public const mensaje_entrar_party_2 as string = ", escribe /entrarparty"

public const mensaje_nene as string = "cantidad de npcs: "

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

type testadisticasusu
    ciudadanosmatados as long
    criminalesmatados as long
    usuariosmatados as long
    npcsmatados as long
    clase as string
    penacarcel as long
end type

public nombres as boolean

public mixedkey as long

'user status vars
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
public userestadisticas as testadisticasusu
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

public const numciudades as byte = 3
public const numskills as byte = 21
public const numatributos as byte = 5
public const numclases as byte = 16
public const numrazas as byte = 5

public userskills(1 to numskills) as integer
public skillsnames(1 to numskills) as string

public useratributos(1 to numatributos) as integer
public atributosnames(1 to numatributos) as string

public ciudades(1 to numciudades) as string
public citydesc(1 to numciudades) as string

public listarazas(1 to numrazas) as string
public listaclases(1 to numclases) as string

public musica as boolean
public sound as boolean

public skillpoints as integer
public alocados as integer
public flags() as integer
public oscuridad as integer
public logged as boolean
public nopuedeusar as boolean

'barrin 30/9/03
public userpuederefrescar as boolean

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
   
public enum fxmeditar
'    fxmeditarchico = 4
'    fxmeditarmediano = 5
'    fxmeditargrande = 6
'    fxmeditarxgrande = 16
    chico = 4
    mediano = 5
    grande = 6
    xgrande = 16
end enum


'server stuff
public requestpostimer as integer 'used in main loop
public stxtbuffer as string 'holds temp raw data from server
public stxtbuffercmsg as string 'holds temp raw data from server
public sendnewchar as boolean 'used during login
public connected as boolean 'true when connected to server
public downloadingmap as boolean 'currently downloading a map from server
public usermap as integer

'string contants
public const endc as string * 1 = vbnullchar    'endline character for talking with server
public const endl as string * 2 = vbcrlf        'holds the endline character for textboxes

'control
public prgrun as boolean 'when true the program ends

public ipdelservidor as string
public puertodelservidor as string

'
'********** funciones api ***********
'

public declare function gettickcount lib "kernel32" () as long

'para escribir y leer variables
public declare function writeprivateprofilestring lib "kernel32" alias "writeprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpstring as string, byval lpfilename as string) as long
public declare function getprivateprofilestring lib "kernel32" alias "getprivateprofilestringa" (byval lpapplicationname as string, byval lpkeyname as any, byval lpdefault as string, byval lpreturnedstring as string, byval nsize as long, byval lpfilename as string) as long

'teclado
public declare function getkeystate lib "user32" (byval nvirtkey as long) as integer
public declare function getasynckeystate lib "user32" (byval nvirtkey as long) as integer

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

