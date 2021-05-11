version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clscustomkeys"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clscustomkeys.cls - allows the user to customize keys.
'
' creation date: 08/03/07
' created and implemented by rapsodius
'**************************************************************

'**************************************************************************
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
'**************************************************************************

''
'customizes user keys.
'
'@author rapsodius
'@version 1.1.0
'@date 20080413

'03/08/2007 - rapsodius
'   - first release
'
'13/04/2008 - juan mart�n sotuyo dodero (maraxus) - (juansotuyo@gmail.com)
'   - removed lots of unwanted buggy features keeping it clean. revised documentation and coding standards.


option explicit

''
'number of customizable keys
private const num_custom_keys as byte = 27

''
'number of key configurations
private const num_custom_configs as byte = 9

''
'error raised in case the key file doesn't exist
private const error_no_key_file as long = vbobjecterror + 16

''
'the relative path from the application's location where the key config file is.
private const key_config_file as string = "\init\bindkeys.bin"

''
'array of mapped keys
private mappedkeys(0 to num_custom_configs, 1 to num_custom_keys) as integer

''
'active key configuration
private activeconfig as byte


''
'index of keys on array
'
'@param mkeyup key for moving character up
'@param mkeydown key for moving character down
'@param mkeyleft key for moving character left
'@param mkeyright key for moving character right
'@param mkeytogglemusic key for toggling background music
'@param mkeytogglesound key for toggling sound
'@param mkeytogglefxs key for togglig the 3d fxs
'@param mkeyrequestrefresh key for sending a request refreshing packet
'@param mkeytogglenames key for toggling characters' names
'@param mkeygetobject key for retrieving an object from the ground
'@param mkeyequipobject key for equiping an inventory object
'@param mkeytamanimal key for taming animals
'@param mkeysteal key for stealing other users' gold or objects
'@param mkeytogglesafemode key for toggling safe mode
'@param mkeytoggleresuscitationsafe key for toggling resuscitation safe
'@param mkeyhide key for hiding the character
'@param mkeydropobject key for dropping inventory objects
'@param mkeyuseobject key for using inventory objects
'@param mkeyattack key for attacking other users/npcs
'@param mkeytalk key for talking (to all)
'@param mkeytalkwithguild key for talking (only to guild members)
'@param mkeytakescreenshot key for taking a snapshot of the screen
'@param mkeyshowoptions key for showing the "options" form
'@param mkeymeditate key for start/stop meditation
'@param mkeycastspellmacro key for start/stop the cast spell macro
'@param mkeyworkmacro key for start/stop the work macro
'@param mkeyexitgame key for close the game
public enum ekeytype
    mkeyup = 1
    mkeydown
    mkeyleft
    mkeyright
    mkeytogglemusic
    mkeytogglesound
    mkeytogglefxs
    mkeyrequestrefresh
    mkeytogglenames
    mkeygetobject
    mkeyequipobject
    mkeytamanimal
    mkeysteal
    mkeytogglesafemode
    mkeytoggleresuscitationsafe
    mkeyhide
    mkeydropobject
    mkeyuseobject
    mkeyattack
    mkeytalk
    mkeytalkwithguild
    mkeytakescreenshot
    mkeyshowoptions
    mkeymeditate
    mkeycastspellmacro
    mkeyworkmacro
    mkeyexitgame
end enum

''
'shows a readable name for a specific key code
'
'@param keycode key code to process
'@return an user readable name for the key code or a null string if the key is not valid
'@remarks all keys not listed here are considered not valid

public function readablename(byval keycode as integer) as string
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
    select case keycode
        case keycodeconstants.vbkeya to keycodeconstants.vbkeyz
            readablename = chr$(keycode)
        
        case keycodeconstants.vbkeynumpad0 to keycodeconstants.vbkeynumpad9
            readablename = keycode - keycodeconstants.vbkeynumpad0 & " (teclado num�rico)"
        
        case keycodeconstants.vbkeyf1 to keycodeconstants.vbkeyf16
            readablename = "f" & (keycode - keycodeconstants.vbkeyf1 + 1)
        
        case keycodeconstants.vbkeymultiply
            readablename = "* (teclado numerico)"
        
        case keycodeconstants.vbkeyadd
            readablename = "+ (teclado numerico)"
        
        case keycodeconstants.vbkeyseparator
            'note: separator appears in msdn as the enter key for
            'the numpad, but ms recognizes it as the normal
            'enter key
            readablename = "enter (teclado num�rico)"
        
        case keycodeconstants.vbkeysubtract
            readablename = "- (teclado numerico)"
        
        case keycodeconstants.vbkeydecimal
            readablename = ". (teclado numerico)"
        
        case keycodeconstants.vbkeydivide
            readablename = "/ (teclado numerico)"
        
        case keycodeconstants.vbkeyshift
            readablename = "shift"
        
        case keycodeconstants.vbkeycontrol
            readablename = "control"
        
        case keycodeconstants.vbkeymenu 'alt
            readablename = "alt"
        
        case keycodeconstants.vbkeypause
            readablename = "pausa"
        
        case keycodeconstants.vbkeycapital
            readablename = "blq mayus"
        
        case keycodeconstants.vbkeyescape
            readablename = "esc"
        
        case keycodeconstants.vbkeypageup
            readablename = "ret pag"
        
        case keycodeconstants.vbkeypagedown
            readablename = "av pag"
        
        case keycodeconstants.vbkeyend
            readablename = "fin"
        
        case keycodeconstants.vbkeyhome
            readablename = "inicio"
        
        case keycodeconstants.vbkeyleft
            readablename = "izquierda"
        
        case keycodeconstants.vbkeyup
            readablename = "arriba"
        
        case keycodeconstants.vbkeyright
            readablename = "derecha"
        
        case keycodeconstants.vbkeydown
            readablename = "abajo"
        
        case keycodeconstants.vbkeyinsert
            readablename = "insertar"
        
        case keycodeconstants.vbkeynumlock
            readablename = "blq num"
        
        case keycodeconstants.vbkeyscrolllock
            readablename = "blq despl"
        
        case keycodeconstants.vbkeyspace
            readablename = "barra espaciadora"
        
        case keycodeconstants.vbkeyback
            readablename = "borrar"
        
        case keycodeconstants.vbkeyreturn
            readablename = "enter"
        
        case keycodeconstants.vbkeydelete
            readablename = "suprimir"
        
        case else
            'in all other cases, key is considered not valid.
            readablename = constants.vbnullstring
    end select
end function

''
'reads custom keys from a file.
'
'@remarks   if the custom keys file is not found error_no_key_file is raised.

public sub loadcustomkeys()
'***************************************************
'author: rapsodius
'last modification: 18/11/2010
'16/11/2010: amraphen - adapt� el procedimiento para cargar todas las configuraciones de teclas.
'18/11/2010: amraphen - modifiqu� la forma en que se cargan los bindings y ahora carga los del formato viejo.
'***************************************************
dim i as long
dim j as long
dim filenum as integer

     'si no existe el archivo lo creamos con los bindings default:
    if not fileexist(app.path & key_config_file, vbarchive) then
        for i = 0 to num_custom_configs
            call loaddefaults(i)
        next i
        
        activeconfig = 1
        
        call savecustomkeys
    else 'existe el archivo, verificamos qu� formato tiene:
        
        filenum = freefile
    
        if filelen(app.path & key_config_file) < (num_custom_configs * num_custom_keys * 2) + 1 then
            'formato viejo
            open app.path & key_config_file for binary access read lock read write as filenum
            
            activeconfig = 1
            
            for i = 0 to num_custom_configs
                call loaddefaults(i)
            next i
            
            for j = 1 to num_custom_keys
                get filenum, , mappedkeys(activeconfig, j)
            next j
        else
            'formato nuevo
            open app.path & key_config_file for binary access read lock read write as filenum
            
            get filenum, , activeconfig
            
            for i = 0 to num_custom_configs
                for j = 1 to num_custom_keys
                    get filenum, , mappedkeys(i, j)
                next j
            next i
        end if
        
        close filenum
        
        call savecustomkeys
    end if
end sub

''
' saves custom keys to a file

public sub savecustomkeys()
'***************************************************
'author: rapsodius
'last modification: 18/11/10
'16/11/2010: amraphen - adapt� el procedimiento para guardar todas las configuraciones de teclas.
'18/11/2010: amraphen - ahora se guarda la configuraci�n activa.
'***************************************************
dim i as long
dim j as long
dim filenum as integer

    filenum = freefile()
    
    open app.path & key_config_file for binary access write as filenum
    
    'guardo la configuraci�n activa:
    put filenum, , activeconfig
    
    'guardo las distintas configuraciones:
    for i = 0 to num_custom_configs
        for j = 1 to num_custom_keys
            put filenum, , mappedkeys(i, j)
        next j
    next i
    
    close filenum
end sub

''
'gets a key code
'
'@param index index of the key code to retrieve
'@return the key code that belongs to index

public property get bindedkey(byval index as ekeytype) as integer
'***************************************************
'author: rapsodius
'last modification: 16/11/2010
'16/11/2010: amraphen - adapt� la propiedad para que cargue el bind de la tecla en la configuraci�n activa.
'***************************************************
    if index < 1 or index > num_custom_keys then exit property
    
    bindedkey = mappedkeys(activeconfig, index)
end property

''
'sets a key code
'
'@param index index of the key to change
'@param newval new key code

public property let bindedkey(byval index as ekeytype, byval newval as integer)
'***************************************************
'author: rapsodius
'last modification: 16/11/2010
'16/11/2010: amraphen - adapt� la propiedad para que guarde el bind de la tecla en la configuraci�n activa.
'***************************************************
    if index < 1 or index > num_custom_keys then exit property
    
    if lenb(readablename(newval)) = 0 then 'if key is not valid...
        exit property                      'rejects the new assignment
    end if
    
    if keyassigned(newval) then 'also reject it in case key is already assigned
        exit property
    end if
    
    mappedkeys(activeconfig, index) = newval
end property

''
'loads default keys
'
'@param keyconfig index of the key configuration to change

public sub loaddefaults(byval keyconfig as byte)
'***************************************************
'author: rapsodius
'last modification: 16/11/2010
'16/11/2010: amraphen - adapt� el procedimiento para que cargue los bindings por default en una sola configuraci�n.
'***************************************************
    mappedkeys(keyconfig, ekeytype.mkeyup) = keycodeconstants.vbkeyup
    mappedkeys(keyconfig, ekeytype.mkeydown) = keycodeconstants.vbkeydown
    mappedkeys(keyconfig, ekeytype.mkeyleft) = keycodeconstants.vbkeyleft
    mappedkeys(keyconfig, ekeytype.mkeyright) = keycodeconstants.vbkeyright
    mappedkeys(keyconfig, ekeytype.mkeytogglemusic) = keycodeconstants.vbkeym
    mappedkeys(keyconfig, ekeytype.mkeytogglesound) = keycodeconstants.vbkeys
    mappedkeys(keyconfig, ekeytype.mkeytogglefxs) = keycodeconstants.vbkeyf
    mappedkeys(keyconfig, ekeytype.mkeyrequestrefresh) = keycodeconstants.vbkeyl
    mappedkeys(keyconfig, ekeytype.mkeytogglenames) = keycodeconstants.vbkeyn
    mappedkeys(keyconfig, ekeytype.mkeygetobject) = keycodeconstants.vbkeya
    mappedkeys(keyconfig, ekeytype.mkeyequipobject) = keycodeconstants.vbkeye
    mappedkeys(keyconfig, ekeytype.mkeytamanimal) = keycodeconstants.vbkeyd
    mappedkeys(keyconfig, ekeytype.mkeysteal) = keycodeconstants.vbkeyr
    mappedkeys(keyconfig, ekeytype.mkeytogglesafemode) = keycodeconstants.vbkeymultiply
    mappedkeys(keyconfig, ekeytype.mkeytoggleresuscitationsafe) = keycodeconstants.vbkeyend
    mappedkeys(keyconfig, ekeytype.mkeyhide) = keycodeconstants.vbkeyo
    mappedkeys(keyconfig, ekeytype.mkeydropobject) = keycodeconstants.vbkeyt
    mappedkeys(keyconfig, ekeytype.mkeyuseobject) = keycodeconstants.vbkeyu
    mappedkeys(keyconfig, ekeytype.mkeyattack) = keycodeconstants.vbkeycontrol
    mappedkeys(keyconfig, ekeytype.mkeytalk) = keycodeconstants.vbkeyreturn
    mappedkeys(keyconfig, ekeytype.mkeytalkwithguild) = keycodeconstants.vbkeydelete
    mappedkeys(keyconfig, ekeytype.mkeytakescreenshot) = keycodeconstants.vbkeyf2
    mappedkeys(keyconfig, ekeytype.mkeyshowoptions) = keycodeconstants.vbkeyf5
    mappedkeys(keyconfig, ekeytype.mkeymeditate) = keycodeconstants.vbkeyf6
    mappedkeys(keyconfig, ekeytype.mkeycastspellmacro) = keycodeconstants.vbkeyf7
    mappedkeys(keyconfig, ekeytype.mkeyworkmacro) = keycodeconstants.vbkeyf8
    mappedkeys(keyconfig, ekeytype.mkeyexitgame) = keycodeconstants.vbkeyf12
end sub

''
'returns whether a key is binded to an action
'
'@param keycode key code to check
'@return true if key is mapped, false otherwise

public function keyassigned(byval keycode as integer) as boolean
'***************************************************
'author: rapsodius
'last modification: 16/11/2010
'16/11/2010: amraphen - adapt� la funci�n para que trabaje sobre la configuraci�n activa.
'***************************************************
dim counter as long
    
    keyassigned = false
    
    for counter = 1 to num_custom_keys
        if mappedkeys(activeconfig, counter) = keycode then
            keyassigned = true
            exit for
        end if
    next counter
end function

''
'retrieves the number of customizable keys
'
'@return the number of customizable keys

public property get keycount() as byte
'***************************************************
'author: rapsodius
'last modification: 16/11/2010
'16/11/2010: amraphen - cambi� el nombre para evitar confusiones.
'***************************************************
    keycount = num_custom_keys
end property

'
'@return the number of customizable key configurations

public property get configcount() as byte
'***************************************************
'author: amraphen
'last modification: 16/11/2010
'
'***************************************************
    configcount = num_custom_configs
end property

''
'sets the currently active key configuration index
'
'@param newval new currently active key configuration index

public property let currentconfig(byval newval as byte)
'***************************************************
'author: amraphen
'last modification: 16/11/2010
'
'***************************************************
    if newval < 0 or newval > num_custom_configs then exit property
    
    activeconfig = newval
end property

''
'retrieves the currently active key configuration index
'
'@return the currently active key configuration index

public property get currentconfig() as byte
'***************************************************
'author: amraphen
'last modification: 16/11/2010
'
'***************************************************
    currentconfig = activeconfig
end property

''
'constructor. loads keys from file

private sub class_initialize()
'***************************************************
'author: rapsodius
'last modification: 18/11/2010
'16/11/2010: amraphen - adapt� el procedimiento para que trabaje sobre las distintas configuraciones de teclas.
'18/11/2010: amraphen - ahora el manejo de errores se hace desde el sub loadcustomkeys
'***************************************************

    call loadcustomkeys
end sub

''
'destructor. saves keys to file

private sub class_terminate()
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
    call savecustomkeys
end sub

