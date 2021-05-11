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
'error raised in case the key file doesn't exist
private const error_no_key_file as long = vbobjecterror + 16

''
'the relative path from the application's location where the key config file is.
private const key_config_file as string = "\init\bindkeys.bin"

''
'array of mapped keys
private mappedkeys(1 to num_custom_keys) as integer


''
'index of keys on array
'
'@param mkeyup key for moving character up
'@param mkeydown key for moving character down
'@param mkeyleft key for moving character left
'@param mkeyright key for moving character right
'@param mkeytogglemusic key for toggling background music
'@param mkeyrequestrefresh key for sending a request refreshing packet
'@param mkeytogglenames key for toggling characters' names
'@param mkeygetobject key for retrieving an object from the ground
'@param mkeytogglecombatmode key for toggling combat mode
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
'@param mkeytogglefps key for toggling the fps counter
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
    mkeyrequestrefresh
    mkeytogglenames
    mkeygetobject
    mkeytogglecombatmode
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
    mkeytogglefps
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
'last modification: 08/21/07
'
'***************************************************
    dim i as long
    dim filenum as integer
    filenum = freefile()
    
    'inits keyboard config with default configurations
    call loaddefaults
        
    open app.path & key_config_file for binary access read lock read write as filenum
    
    for i = 1 to num_custom_keys
        get filenum, , mappedkeys(i)
        if lenb(readablename(mappedkeys(i))) = 0 then
            close filenum
            call err.raise(error_no_key_file)
            exit sub
        end if
    next i
    
    close filenum
end sub

''
' saves custom keys to a file

public sub savecustomkeys()
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
    dim filenum as integer
    dim i as long
    filenum = freefile()
    
    open app.path & key_config_file for binary access write as filenum
    
    for i = 1 to num_custom_keys
        put filenum, , mappedkeys(i)
    next i
    
    close #filenum
end sub

''
'gets a key code
'
'@param index index of the key code to retrieve
'@return the key code that belongs to index

public property get bindedkey(byval index as ekeytype) as integer
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
    if index < 1 or index > num_custom_keys then exit property
    bindedkey = mappedkeys(index)
end property

''
'sets a key code
'
'@param index index of the key to change
'@param newval new key code

public property let bindedkey(byval index as ekeytype, byval newval as integer)
'***************************************************
'author: rapsodius
'last modification: 08/05/07
'
'***************************************************
    if index < 1 or index > num_custom_keys then exit property
    
    if lenb(readablename(newval)) = 0 then 'if key is not valid...
        exit property                      'rejects the new assignment
    end if
    
    if keyassigned(newval) then 'also reject it in case key is already assigned
        exit property
    end if
    
    mappedkeys(index) = newval
end property

''
'loads default keys

public sub loaddefaults()
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
    mappedkeys(ekeytype.mkeyup) = keycodeconstants.vbkeyup
    mappedkeys(ekeytype.mkeydown) = keycodeconstants.vbkeydown
    mappedkeys(ekeytype.mkeyleft) = keycodeconstants.vbkeyleft
    mappedkeys(ekeytype.mkeyright) = keycodeconstants.vbkeyright
    mappedkeys(ekeytype.mkeytogglemusic) = keycodeconstants.vbkeym
    mappedkeys(ekeytype.mkeyrequestrefresh) = keycodeconstants.vbkeyl
    mappedkeys(ekeytype.mkeytogglenames) = keycodeconstants.vbkeyn
    mappedkeys(ekeytype.mkeygetobject) = keycodeconstants.vbkeya
    mappedkeys(ekeytype.mkeytogglecombatmode) = keycodeconstants.vbkeyc
    mappedkeys(ekeytype.mkeyequipobject) = keycodeconstants.vbkeye
    mappedkeys(ekeytype.mkeytamanimal) = keycodeconstants.vbkeyd
    mappedkeys(ekeytype.mkeysteal) = keycodeconstants.vbkeyr
    mappedkeys(ekeytype.mkeytogglesafemode) = keycodeconstants.vbkeymultiply
    mappedkeys(ekeytype.mkeytoggleresuscitationsafe) = keycodeconstants.vbkeyend
    mappedkeys(ekeytype.mkeyhide) = keycodeconstants.vbkeyo
    mappedkeys(ekeytype.mkeydropobject) = keycodeconstants.vbkeyt
    mappedkeys(ekeytype.mkeyuseobject) = keycodeconstants.vbkeyu
    mappedkeys(ekeytype.mkeyattack) = keycodeconstants.vbkeycontrol
    mappedkeys(ekeytype.mkeytalk) = keycodeconstants.vbkeyreturn
    mappedkeys(ekeytype.mkeytalkwithguild) = keycodeconstants.vbkeydelete
    mappedkeys(ekeytype.mkeytogglefps) = keycodeconstants.vbkeyf4
    mappedkeys(ekeytype.mkeytakescreenshot) = keycodeconstants.vbkeyf2
    mappedkeys(ekeytype.mkeyshowoptions) = keycodeconstants.vbkeyf5
    mappedkeys(ekeytype.mkeymeditate) = keycodeconstants.vbkeyf6
    mappedkeys(ekeytype.mkeycastspellmacro) = keycodeconstants.vbkeyf7
    mappedkeys(ekeytype.mkeyworkmacro) = keycodeconstants.vbkeyf8
    mappedkeys(ekeytype.mkeyexitgame) = keycodeconstants.vbkeyf12
end sub

''
'returns whether a key is binded to an action
'
'@param keycode key code to check
'@return true if key is mapped, false otherwise

public function keyassigned(byval keycode as integer) as boolean
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
    dim counter as long
    
    keyassigned = false
    
    for counter = 1 to num_custom_keys
        if mappedkeys(counter) = keycode then
            keyassigned = true
            exit for
        end if
    next counter
end function

''
'retrieves the number of customizable keys
'
'@return the number of customizable keys

public property get count() as byte
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
    count = num_custom_keys
end property

''
'constructor. loads keys from file

private sub class_initialize()
'***************************************************
'author: rapsodius
'last modification: 08/04/07
'
'***************************************************
on error goto errhand:
    call loadcustomkeys
    exit sub
    
errhand:
    if err.number = error_no_key_file then
        call loaddefaults
        call savecustomkeys
        resume next
    end if
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
