attribute vb_name = "history"
option explicit

'alejoooooo yo quiero un sangucheeee

'9-5-2003 - v41
'1)arreglado un bug en el q se podia construir objetos que
'no aparecian en la lista de herreria.

'17-4-2003 - v40
'1) agregados los comandos /banip y /unbanip. sirven para
'banear por ip a alguien ;)
'  sintaxis c/ ejemplos:
'    /banip 1.1.1.1
'    /banip juanito
'    /unbanip 1.1.1.1

'9-4-2003 - v38
'1) ahora el manejo de sockets se realiza x medio de la
'api de winsock. funca muy lindo :) pero cuidado con
'iniciar desde modo debug, desde el entorno de vb, ya
'que cuando se pone 'cerrar servidor' se cierra vb6 tambien.
'osea, traten de no hacer cambios en el codigo desde tiempo
'de ejecucion. si quieren hacerlos, pongan 'stop' ('detener')
'en el entorno, guarden, cierren y abran vb (porque los
'sockets no se cierran y x lo tanto no puede escuchar en el
'puerto).
'2)segun pablo el problema del socketwrench es que el control
'no funciona bien y para cerrar hay que destruirlo y volverlo
'a crear (unload y load).
'3)si quieren usar el control viejo en vez de la api (fijense
'que todavia esta en el form), vayan a proyecto, propiedades
'gererar, argumentos de compilacion y pongan usarapi en = 0
'no lo he probado pero deberia andar... :p

'3-4-2003 - v37
'1) la verdad no se que pasa. hacen falta mas pruebas pero
'corremos riesgo de desbalanceo (extremista...)
'2) acabo de resetear la funcion closesocket a como esta
'en la version 22 (la ultima estable).
'3) cri cri

'1-4-203 - v36
'-------
'1) estuve revisando el problema de los cuelgues. al parecer
'es por un blucle infinito de ententos socket2_read. ni idea
'que lo ocasiona.
'2) elimin� el doevents de gametimer
'3) ahora los socket adem�s se cierran con .disconnect.
'espero que solucione el problema del bucle...
'4) agregu� un sistema para detectar los bucles esos con un
'contador. cuando lo detecta se graba en el log de errores,
'cierra y limpia el socket y el slot

'history log by cdt

'31-3-2003 - ver .35
'---------
'1) repar� conteo de users (mal funcionamiento debido a la
'restauracion de closesocket [olvide numusers = numusers -1]
'2) agrege ados.restarconeccion en pasarsegundo

'31-3-2003 - ver .34
'---------
'1) saqu� el unload frmmain.socket2, creo que esta trayendo
'problemas...verifiqu� y la forma de reutilizacion de socks
'es por userlist().flags.connid
'2) la funcion cerrar_usuario quedo solo para /salir y des_
'coneccion estando loggeado..devolv� al estado original la
'func closesocket (bueh..un poko modifikada ta)

'30-3-2003 (estamos laburadores hoy eh) - ver .33
'---------
'1) puse el autosalvado de pjes cada 30 minutos
'2) cuando se gravaban pjes se cambiaba la cara si estabas
'muerto...solved it
'3) los gms quedaban invisibles permanentemente con el /invisible
'4) aplicados los 10 segundos en todos los casos..no solo si
'estas paralizado
'5) identificador de /gmsg "nombre del gm> mensaje"

'logaritmo de hitoria por alejo (ya q todos dicen alguna boludex...)

'30-3-2003 - ver .32
'---------
'*version 32 :)
'1) agregados los comandos:
'   /ct mapa x y        permite crear un teleport con
'                       con destino a mapa, x, y,
'                       posicionado un tile mas arriba
'                       que el dios.
'   /dt                 destruir teleport de el ultimo
'                       click.

'history log by cdt

'30-3-2003 (mismo dia, distinta hora :p)
'---------
'1) errhand para el timer auditoria y que sea lo que dios quiera
'con respecto a este parche que ya cansa!, igualmente no creo
'que provoque un mal funcionamiento....tira que no existe el
'elemento en el array grgr i hate u
'2) parche para mantener la invisibilidad al pasar de mapa

'30-3-2003
'---------
'1) aplique un codigo para que cierre luego de 10 segundos el
'juego si estas paralizado..parece que hay problemas..no todo
'funciona bien..experiment� una caida, creo que el finok hacia
'que al desconectarse el cliente se llame de nuevo a closesocket
'espero que sea eso..habra que seguir experimentando :s estuve
'viendo el codigo y no encontre nada mal..no se :(
'2) agrege el comando /gmsg para mensajeria entre gms (toadmin)
'3) comando /rem para comentarios en los logs
'4) agrege un boton que guarde todos los chars...ya que los
'cierres de server son aprovechados para clonar items
'5) agrege la funcion que guarda los chars en un timer..lo mismo
'pero para prevenir caidas
'6) estuve arreglando un poco los forms..habia algunos feitos ;)

'26-3-2003
'---------
'1) apliqu� el color verde para los gms (lease..lookattile)
'2) los gms no muestran fxs cuando se mueven estando invisibles
'3) me com� un pancho en la plaza deboto..que ricos son esos panchos! (??)

'history log by morgolock

'13-2-2003
'---------
'1) modifiqu� todas las llamadas a las funciones mid, left y
'right por mid$, left$ y right$ para que devuelvan strings
'en vez de variants. se deberia ganar considerable velocidad.
'2) quite el comando /grabar ya que generaba problemas con
'las mascotas y no era demasiado �til ya que los usuarios
'consiguen el mismo efecto saliendo y volviendo a entrar
'en el juego.
'3) agregu� el motd, el servidor levanta el mensaje del archivo
'motd.ini del directorio dat del servidor, les envia el motd
'a los usuarios cuando entran al juego.

'12-2-2003
'---------
'1) limit� a tres la m�xima cantidad de mascotas
'2) a los newbies se les caen los objetos no newbies


