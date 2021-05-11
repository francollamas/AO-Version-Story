attribute vb_name = "wsksock"
'**************************************************************
' wsksock.bas
'
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

#if usarquesocket = 1 then

'date stamp: sept 1, 1996 (for version control, please don't remove)

'visual basic 4.0 winsock "header"
'   alot of the information contained inside this file was originally
'   obtained from alt.winsock.programming and most of it has since been
'   modified in some way.
'
'disclaimer: this file is public domain, updated periodically by
'   topaz, sigsegv@mail.utexas.edu, use it at your own risk.
'   neither myself(topaz) or anyone related to alt.programming.winsock
'   may be held liable for its use, or misuse.
'
'declare check aug 27, 1996. (topaz, sigsegv@mail.utexas.edu)
'   all 16 bit declarations appear correct, even the odd ones that
'   pass longs inplace of in_addr and char buffers. 32 bit functions
'   also appear correct. some are declared to return integers instead of
'   longs (breaking ms's rules.) however after testing these functions i
'   have come to the conclusion that they do not work properly when declared
'   following ms's rules.
'
'notes:
'   (1) i have never used ws_select (select), therefore i must warn that i do
'       not know if fd_set and timeval are properly defined.
'   (2) alot of the functions are declared with "buf as any", when calling these
'       functions you may either pass strings, byte arrays or udt's. for 32bit i
'       i recommend byte arrays and the use of memcopy to copy the data back out
'   (3) the async functions (wsaasync*) require the use of a message hook or
'       message window control to capture messages sent by the winsock stack. this
'       is not to be confused with a callback control, the only function that uses
'       callbacks is wsasetblockinghook()
'   (4) alot of "helper" functions are provided in the file for various things
'       before attempting to figure out how to call a function, look and see if
'       there is already a helper function for it.
'   (5) data types (hostent etc) have kept there 16bit definitions, even under 32bit
'       windows due to the problem of them not working when redfined following the
'       suggested rules.
option explicit

public const fd_setsize = 64
type fd_set
    fd_count as integer
    fd_array(fd_setsize) as integer
end type

type timeval
    tv_sec as long
    tv_usec as long
end type

type hostent
    h_name as long
    h_aliases as long
    h_addrtype as integer
    h_length as integer
    h_addr_list as long
end type
public const hostent_size = 16

type servent
    s_name as long
    s_aliases as long
    s_port as integer
    s_proto as long
end type
public const servent_size = 14

type protoent
    p_name as long
    p_aliases as long
    p_proto as integer
end type
public const protoent_size = 10

public const ipproto_tcp = 6
public const ipproto_udp = 17

public const inaddr_none = &hffffffff
public const inaddr_any = &h0

type sockaddr
    sin_family as integer
    sin_port as integer
    sin_addr as long
    sin_zero as string * 8
end type
public const sockaddr_size = 16
public sazero as sockaddr


public const wsa_descriptionlen = 256
public const wsa_descriptionsize = wsa_descriptionlen + 1

public const wsa_sys_status_len = 128
public const wsa_sysstatussize = wsa_sys_status_len + 1

type wsadatatype
    wversion as integer
    whighversion as integer
    szdescription as string * wsa_descriptionsize
    szsystemstatus as string * wsa_sysstatussize
    imaxsockets as integer
    imaxudpdg as integer
    lpvendorinfo as long
end type

'agregado por maraxus
type wsabuf
    dwbufferlen as long
    lpbuffer    as long
end type

'agregado por maraxus
type flowspec
    tokenrate           as long     'in bytes/sec
    tokenbucketsize     as long     'in bytes
    peakbandwidth       as long     'in bytes/sec
    latency             as long     'in microseconds
    delayvariation      as long     'in microseconds
    servicetype         as integer  'guaranteed, predictive,
                                    'best effort, etc.
    maxsdusize          as long     'in bytes
    minimumpolicedsize  as long     'in bytes
end type

'agregado por maraxus
public const wsa_flag_overlapped = &h1

'agregados por maraxus
public const cf_accept = &h0
public const cf_reject = &h1

'agregado por maraxus
public const sd_receive as long = &h0&
public const sd_send as long = &h1&
public const sd_both as long = &h2&

public const invalid_socket = -1
public const socket_error = -1

public const sock_stream = 1
public const sock_dgram = 2

public const maxgethoststruct = 1024

public const af_inet = 2
public const pf_inet = 2

type lingertype
    l_onoff as integer
    l_linger as integer
end type
' windows sockets definitions of regular microsoft c error constants
global const wsaeintr = 10004
global const wsaebadf = 10009
global const wsaeacces = 10013
global const wsaefault = 10014
global const wsaeinval = 10022
global const wsaemfile = 10024
' windows sockets definitions of regular berkeley error constants
global const wsaewouldblock = 10035
global const wsaeinprogress = 10036
global const wsaealready = 10037
global const wsaenotsock = 10038
global const wsaedestaddrreq = 10039
global const wsaemsgsize = 10040
global const wsaeprototype = 10041
global const wsaenoprotoopt = 10042
global const wsaeprotonosupport = 10043
global const wsaesocktnosupport = 10044
global const wsaeopnotsupp = 10045
global const wsaepfnosupport = 10046
global const wsaeafnosupport = 10047
global const wsaeaddrinuse = 10048
global const wsaeaddrnotavail = 10049
global const wsaenetdown = 10050
global const wsaenetunreach = 10051
global const wsaenetreset = 10052
global const wsaeconnaborted = 10053
global const wsaeconnreset = 10054
global const wsaenobufs = 10055
global const wsaeisconn = 10056
global const wsaenotconn = 10057
global const wsaeshutdown = 10058
global const wsaetoomanyrefs = 10059
global const wsaetimedout = 10060
global const wsaeconnrefused = 10061
global const wsaeloop = 10062
global const wsaenametoolong = 10063
global const wsaehostdown = 10064
global const wsaehostunreach = 10065
global const wsaenotempty = 10066
global const wsaeproclim = 10067
global const wsaeusers = 10068
global const wsaedquot = 10069
global const wsaestale = 10070
global const wsaeremote = 10071
' extended windows sockets error constant definitions
global const wsasysnotready = 10091
global const wsavernotsupported = 10092
global const wsanotinitialised = 10093
global const wsahost_not_found = 11001
global const wsatry_again = 11002
global const wsano_recovery = 11003
global const wsano_data = 11004
global const wsano_address = 11004
'---ioctl constants
    public const fionread = &h8004667f
    public const fionbio = &h8004667e
    public const fioasync = &h8004667d

#if win16 then
'---windows system functions
    public declare function postmessage lib "user" (byval hwnd as integer, byval wmsg as integer, byval wparam as integer, lparam as any) as integer
    public declare sub memcopy lib "kernel" alias "hmemcpy" (dest as any, src as any, byval cb&)
    public declare function lstrlen lib "kernel" (byval lpstring as any) as integer
'---async notification constants
    public const sol_socket = &hffff
    public const so_linger = &h80
    public const so_rcvbuffer = &h1002              ' agregado por maraxus
    public const so_sndbuffer = &h1001              ' agregado por maraxus
    public const so_conditional_accept = &h3002    ' agregado por maraxus
    public const fd_read = &h1
    public const fd_write = &h2
    public const fd_oob = &h4
    public const fd_accept = &h8
    public const fd_connect = &h10
    public const fd_close = &h20
'---socket functions
    public declare function accept lib "ws2_32.dll" (byval s as integer, addr as sockaddr, addrlen as integer) as integer
    public declare function bind lib "ws2_32.dll" (byval s as integer, addr as sockaddr, byval namelen as integer) as integer
    public declare function apiclosesocket lib "ws2_32.dll" alias "closesocket" (byval s as integer) as integer
    public declare function connect lib "ws2_32.dll" (byval s as integer, addr as sockaddr, byval namelen as integer) as integer
    public declare function ioctlsocket lib "ws2_32.dll" (byval s as integer, byval cmd as long, argp as long) as integer
    public declare function getpeername lib "ws2_32.dll" (byval s as integer, sname as sockaddr, namelen as integer) as integer
    public declare function getsockname lib "ws2_32.dll" (byval s as integer, sname as sockaddr, namelen as integer) as integer
    public declare function getsockopt lib "ws2_32.dll" (byval s as integer, byval level as integer, byval optname as integer, optval as any, optlen as integer) as integer
    public declare function htonl lib "ws2_32.dll" (byval hostlong as long) as long
    public declare function htons lib "ws2_32.dll" (byval hostshort as integer) as integer
    public declare function inet_addr lib "ws2_32.dll" (byval cp as string) as long
    public declare function inet_ntoa lib "ws2_32.dll" (byval inn as long) as long
    public declare function listen lib "ws2_32.dll" (byval s as integer, byval backlog as integer) as integer
    public declare function ntohl lib "ws2_32.dll" (byval netlong as long) as long
    public declare function ntohs lib "ws2_32.dll" (byval netshort as integer) as integer
    public declare function recv lib "ws2_32.dll" (byval s as integer, byref buf as any, byval buflen as integer, byval flags as integer) as integer
    public declare function recvfrom lib "ws2_32.dll" (byval s as integer, buf as any, byval buflen as integer, byval flags as integer, from as sockaddr, fromlen as integer) as integer
    public declare function ws_select lib "ws2_32.dll" alias "select" (byval nfds as integer, readfds as any, writefds as any, exceptfds as any, timeout as timeval) as integer
    public declare function send lib "ws2_32.dll" (byval s as integer, buf as any, byval buflen as integer, byval flags as integer) as integer
    public declare function sendto lib "ws2_32.dll" (byval s as integer, buf as any, byval buflen as integer, byval flags as integer, to_addr as sockaddr, byval tolen as integer) as integer
    public declare function setsockopt lib "ws2_32.dll" (byval s as integer, byval level as integer, byval optname as integer, optval as any, byval optlen as integer) as integer
    public declare function shutdown lib "ws2_32.dll" alias "shutdown" (byval s as integer, byval how as integer) as integer
    public declare function socket lib "ws2_32.dll" alias "socket" (byval af as integer, byval s_type as integer, byval protocol as integer) as integer
'---database functions
    public declare function gethostbyaddr lib "ws2_32.dll" (addr as long, byval addr_len as integer, byval addr_type as integer) as long
    public declare function gethostbyname lib "ws2_32.dll" (byval host_name as string) as long
    public declare function gethostname lib "ws2_32.dll" (byval host_name as string, byval namelen as integer) as integer
    public declare function getservbyport lib "ws2_32.dll" (byval port as integer, byval proto as string) as long
    public declare function getservbyname lib "ws2_32.dll" (byval serv_name as string, byval proto as string) as long
    public declare function getprotobynumber lib "ws2_32.dll" (byval proto as integer) as long
    public declare function getprotobyname lib "ws2_32.dll" (byval proto_name as string) as long
'---windows extensions
    public declare function wsastartup lib "ws2_32.dll" (byval wvr as integer, lpwsad as wsadatatype) as integer
    public declare function wsacleanup lib "ws2_32.dll" () as integer
    public declare sub wsasetlasterror lib "ws2_32.dll" (byval ierror as integer)
    public declare function wsagetlasterror lib "ws2_32.dll" () as integer
    public declare function wsaisblocking lib "ws2_32.dll" () as integer
    public declare function wsaunhookblockinghook lib "ws2_32.dll" () as integer
    public declare function wsasetblockinghook lib "ws2_32.dll" (byval lpblockfunc as long) as long
    public declare function wsacancelblockingcall lib "ws2_32.dll" () as integer
    public declare function wsaasyncgetservbyname lib "ws2_32.dll" (byval hwnd as integer, byval wmsg as integer, byval serv_name as string, byval proto as string, buf as any, byval buflen as integer) as integer
    public declare function wsaasyncgetservbyport lib "ws2_32.dll" (byval hwnd as integer, byval wmsg as integer, byval port as integer, byval proto as string, buf as any, byval buflen as integer) as integer
    public declare function wsaasyncgetprotobyname lib "ws2_32.dll" (byval hwnd as integer, byval wmsg as integer, byval proto_name as string, buf as any, byval buflen as integer) as integer
    public declare function wsaasyncgetprotobynumber lib "ws2_32.dll" (byval hwnd as integer, byval wmsg as integer, byval number as integer, buf as any, byval buflen as integer) as integer
    public declare function wsaasyncgethostbyname lib "ws2_32.dll" (byval hwnd as integer, byval wmsg as integer, byval host_name as string, buf as any, byval buflen as integer) as integer
    public declare function wsaasyncgethostbyaddr lib "ws2_32.dll" (byval hwnd as integer, byval wmsg as integer, addr as long, byval addr_len as integer, byval addr_type as integer, buf as any, byval buflen as integer) as integer
    public declare function wsacancelasyncrequest lib "ws2_32.dll" (byval hasynctaskhandle as integer) as integer
    public declare function wsaasyncselect lib "ws2_32.dll" (byval s as integer, byval hwnd as integer, byval wmsg as integer, byval levent as long) as integer
    public declare function wsarecvex lib "ws2_32.dll" (byval s as integer, buf as any, byval buflen as integer, byval flags as integer) as integer
'agregado por maraxus
    declare function wsaaccept lib "ws2_32.dll" (byval s as integer, psockaddr as sockaddr, addrlen as integer, byval lpfncondition as long, byval dwcallbackdata as long) as integer
    
    public const somaxconn as integer = &h7fff            ' agregado por maraxus

#elseif win32 then
'---windows system functions
    public declare function postmessage lib "user32" alias "postmessagea" (byval hwnd as long, byval wmsg as long, byval wparam as long, byval lparam as long) as long
    public declare sub memcopy lib "kernel32" alias "rtlmovememory" (dest as any, src as any, byval cb&)
    public declare function lstrlen lib "kernel32" alias "lstrlena" (byval lpstring as any) as long
'---async notification constants
    public const sol_socket = &hffff&
    public const so_linger = &h80&
    public const so_rcvbuffer = &h1002&             ' agregado por maraxus
    public const so_sndbuffer = &h1001&              ' agregado por maraxus
    public const so_conditional_accept = &h3002&    ' agregado por maraxus
    public const fd_read = &h1&
    public const fd_write = &h2&
    public const fd_oob = &h4&
    public const fd_accept = &h8&
    public const fd_connect = &h10&
    public const fd_close = &h20&
'---socket functions
    public declare function accept lib "wsock32.dll" (byval s as long, addr as sockaddr, addrlen as long) as long
    public declare function bind lib "wsock32.dll" (byval s as long, addr as sockaddr, byval namelen as long) as long
    public declare function apiclosesocket lib "wsock32.dll" alias "closesocket" (byval s as long) as long
    public declare function connect lib "wsock32.dll" (byval s as long, addr as sockaddr, byval namelen as long) as long
    public declare function ioctlsocket lib "wsock32.dll" (byval s as long, byval cmd as long, argp as long) as long
    public declare function getpeername lib "wsock32.dll" (byval s as long, sname as sockaddr, namelen as long) as long
    public declare function getsockname lib "wsock32.dll" (byval s as long, sname as sockaddr, namelen as long) as long
    public declare function getsockopt lib "wsock32.dll" (byval s as long, byval level as long, byval optname as long, optval as any, optlen as long) as long
    public declare function htonl lib "wsock32.dll" (byval hostlong as long) as long
    public declare function htons lib "wsock32.dll" (byval hostshort as long) as integer
    public declare function inet_addr lib "wsock32.dll" (byval cp as string) as long
    public declare function inet_ntoa lib "wsock32.dll" (byval inn as long) as long
    public declare function listen lib "wsock32.dll" (byval s as long, byval backlog as long) as long
    public declare function ntohl lib "wsock32.dll" (byval netlong as long) as long
    public declare function ntohs lib "wsock32.dll" (byval netshort as long) as integer
    public declare function recv lib "wsock32.dll" (byval s as long, byref buf as any, byval buflen as long, byval flags as long) as long
    public declare function recvfrom lib "wsock32.dll" (byval s as long, buf as any, byval buflen as long, byval flags as long, from as sockaddr, fromlen as long) as long
    public declare function ws_select lib "wsock32.dll" alias "select" (byval nfds as long, readfds as fd_set, writefds as fd_set, exceptfds as fd_set, timeout as timeval) as long
    public declare function send lib "wsock32.dll" (byval s as long, buf as any, byval buflen as long, byval flags as long) as long
    public declare function sendto lib "wsock32.dll" (byval s as long, buf as any, byval buflen as long, byval flags as long, to_addr as sockaddr, byval tolen as long) as long
    public declare function setsockopt lib "wsock32.dll" (byval s as long, byval level as long, byval optname as long, optval as any, byval optlen as long) as long
    public declare function shutdown lib "wsock32.dll" alias "shutdown" (byval s as long, byval how as long) as long
    public declare function socket lib "wsock32.dll" alias "socket" (byval af as long, byval s_type as long, byval protocol as long) as long
'---database functions
    public declare function gethostbyaddr lib "wsock32.dll" (addr as long, byval addr_len as long, byval addr_type as long) as long
    public declare function gethostbyname lib "wsock32.dll" (byval host_name as string) as long
    public declare function gethostname lib "wsock32.dll" (byval host_name as string, byval namelen as long) as long
    public declare function getservbyport lib "wsock32.dll" (byval port as long, byval proto as string) as long
    public declare function getservbyname lib "wsock32.dll" (byval serv_name as string, byval proto as string) as long
    public declare function getprotobynumber lib "wsock32.dll" (byval proto as long) as long
    public declare function getprotobyname lib "wsock32.dll" (byval proto_name as string) as long
'---windows extensions
    public declare function wsastartup lib "wsock32.dll" (byval wvr as long, lpwsad as wsadatatype) as long
    public declare function wsacleanup lib "wsock32.dll" () as long
    public declare sub wsasetlasterror lib "wsock32.dll" (byval ierror as long)
    public declare function wsagetlasterror lib "wsock32.dll" () as long
    public declare function wsaisblocking lib "wsock32.dll" () as long
    public declare function wsaunhookblockinghook lib "wsock32.dll" () as long
    public declare function wsasetblockinghook lib "wsock32.dll" (byval lpblockfunc as long) as long
    public declare function wsacancelblockingcall lib "wsock32.dll" () as long
    public declare function wsaasyncgetservbyname lib "wsock32.dll" (byval hwnd as long, byval wmsg as long, byval serv_name as string, byval proto as string, buf as any, byval buflen as long) as long
    public declare function wsaasyncgetservbyport lib "wsock32.dll" (byval hwnd as long, byval wmsg as long, byval port as long, byval proto as string, buf as any, byval buflen as long) as long
    public declare function wsaasyncgetprotobyname lib "wsock32.dll" (byval hwnd as long, byval wmsg as long, byval proto_name as string, buf as any, byval buflen as long) as long
    public declare function wsaasyncgetprotobynumber lib "wsock32.dll" (byval hwnd as long, byval wmsg as long, byval number as long, buf as any, byval buflen as long) as long
    public declare function wsaasyncgethostbyname lib "wsock32.dll" (byval hwnd as long, byval wmsg as long, byval host_name as string, buf as any, byval buflen as long) as long
    public declare function wsaasyncgethostbyaddr lib "wsock32.dll" (byval hwnd as long, byval wmsg as long, addr as long, byval addr_len as long, byval addr_type as long, buf as any, byval buflen as long) as long
    public declare function wsacancelasyncrequest lib "wsock32.dll" (byval hasynctaskhandle as long) as long
    public declare function wsaasyncselect lib "wsock32.dll" (byval s as long, byval hwnd as long, byval wmsg as long, byval levent as long) as long
    public declare function wsarecvex lib "wsock32.dll" (byval s as long, buf as any, byval buflen as long, byval flags as long) as long
'agregado por maraxus
    declare function wsaaccept lib "ws2_32.dll" (byval s as long, psockaddr as sockaddr, addrlen as long, byval lpfncondition as long, byval dwcallbackdata as long) as long
    public const somaxconn as long = &h7fffffff            ' agregado por maraxus


#end if


'some stuff i added
public mysocket%
public sockreadbuffer$
public const wsa_noname = "unknown"
public wsastartedup as boolean     'flag to keep track of whether winsock wsastartup wascalled


public function wsagetasyncbuflen(byval lparam as long) as long
    if (lparam and &hffff&) > &h7fff then
        wsagetasyncbuflen = (lparam and &hffff&) - &h10000
    else
        wsagetasyncbuflen = lparam and &hffff&
    end if
end function

public function wsagetselectevent(byval lparam as long) as integer
    if (lparam and &hffff&) > &h7fff then
        wsagetselectevent = (lparam and &hffff&) - &h10000
    else
        wsagetselectevent = lparam and &hffff&
    end if
end function



public function wsagetasyncerror(byval lparam as long) as integer
    wsagetasyncerror = (lparam and &hffff0000) \ &h10000
end function



public function addrtoip(byval addrorip$) as string
dim t() as string
dim tmp as string

tmp = getascip(gethostbynamealias(addrorip$))
t = split(tmp, ".")
addrtoip = t(3) & "." & t(2) & "." & t(1) & "." & t(0)

end function

'this function should work on 16 and 32 bit systems
#if win16 then
    function connectsock(byval host$, byval port%, retipport$, byval hwndtomsg%, byval async%) as integer
    dim s%, selectops%, dummy%
#elseif win32 then
    function connectsock(byval host$, byval port&, retipport$, byval hwndtomsg&, byval async%) as long
    dim s&, selectops&, dummy&
#end if
    dim sockin as sockaddr
    sockreadbuffer$ = vbnullstring
    sockin = sazero
    sockin.sin_family = af_inet
    sockin.sin_port = htons(port)
    if sockin.sin_port = invalid_socket then
        connectsock = invalid_socket
        exit function
    end if

    sockin.sin_addr = gethostbynamealias(host$)
    if sockin.sin_addr = inaddr_none then
        connectsock = invalid_socket
        exit function
    end if
    retipport$ = getascip$(sockin.sin_addr) & ":" & ntohs(sockin.sin_port)

    s = socket(pf_inet, sock_stream, ipproto_tcp)
    if s < 0 then
        connectsock = invalid_socket
        exit function
    end if
    if setsocklinger(s, 1, 0) = socket_error then
        if s > 0 then
            dummy = apiclosesocket(s)
        end if
        connectsock = invalid_socket
        exit function
    end if
    if not async then
        if not connect(s, sockin, sockaddr_size) = 0 then
            if s > 0 then
                dummy = apiclosesocket(s)
            end if
            connectsock = invalid_socket
            exit function
        end if
        if hwndtomsg <> 0 then
            selectops = fd_read or fd_write or fd_connect or fd_close
            if wsaasyncselect(s, hwndtomsg, byval 1025, byval selectops) then
                if s > 0 then
                    dummy = apiclosesocket(s)
                end if
                connectsock = invalid_socket
                exit function
            end if
        end if
    else
        selectops = fd_read or fd_write or fd_connect or fd_close
        if wsaasyncselect(s, hwndtomsg, byval 1025, byval selectops) then
            if s > 0 then
                dummy = apiclosesocket(s)
            end if
            connectsock = invalid_socket
            exit function
        end if
        if connect(s, sockin, sockaddr_size) <> -1 then
            if s > 0 then
                dummy = apiclosesocket(s)
            end if
            connectsock = invalid_socket
            exit function
        end if
    end if
    connectsock = s
end function

#if win32 then
    public function setsocklinger(byval socknum&, byval onoff%, byval lingertime%) as long
#else
    public function setsocklinger(byval socknum%, byval onoff%, byval lingertime%) as integer
#end if
    dim linger as lingertype
    linger.l_onoff = onoff
    linger.l_linger = lingertime
    if setsockopt(socknum, sol_socket, so_linger, linger, 4) then
        debug.print "error setting linger info: " & wsagetlasterror()
        setsocklinger = socket_error
    else
        if getsockopt(socknum, sol_socket, so_linger, linger, 4) then
            debug.print "error getting linger info: " & wsagetlasterror()
            setsocklinger = socket_error
        else
            debug.print "linger is on if nonzero: "; linger.l_onoff
            debug.print "linger time if linger is on: "; linger.l_linger
        end if
    end if
end function

sub endwinsock()
    dim ret&
    if wsaisblocking() then
        ret = wsacancelblockingcall()
    end if
    ret = wsacleanup()
    wsastartedup = false
end sub

public function getascip(byval inn as long) as string
    #if win32 then
        dim nstr&
    #else
        dim nstr%
    #end if
    dim lpstr&
    dim retstring$
    retstring = string(32, 0)
    lpstr = inet_ntoa(inn)
    if lpstr then
        nstr = lstrlen(lpstr)
        if nstr > 32 then nstr = 32
        memcopy byval retstring, byval lpstr, nstr
        retstring = left$(retstring, nstr)
        getascip = retstring
    else
        getascip = "255.255.255.255"
    end if
end function

public function gethostbyaddress(byval addr as long) as string
    dim phe&
    dim hedesthost as hostent
    dim hostname$
    phe = gethostbyaddr(addr, 4, pf_inet)
    if phe then
        memcopy hedesthost, byval phe, hostent_size
        hostname = string(256, 0)
        memcopy byval hostname, byval hedesthost.h_name, 256
        gethostbyaddress = left$(hostname, instr(hostname, chr$(0)) - 1)
    else
        gethostbyaddress = wsa_noname
    end if
end function

'returns ip as long, in network byte order
public function gethostbynamealias(byval hostname$) as long
    'return ip address as a long, in network byte order
    dim phe&
    dim hedesthost as hostent
    dim addrlist&
    dim retip&
    retip = inet_addr(hostname$)
    if retip = inaddr_none then
        phe = gethostbyname(hostname$)
        if phe <> 0 then
            memcopy hedesthost, byval phe, hostent_size
            memcopy addrlist, byval hedesthost.h_addr_list, 4
            memcopy retip, byval addrlist, hedesthost.h_length
        else
            retip = inaddr_none
        end if
    end if
    gethostbynamealias = retip
end function

'returns your local machines name
public function getlocalhostname() as string
    dim sname$
    sname = string(256, 0)
    if gethostname(sname, 256) then
        sname = wsa_noname
    else
        if instr(sname, chr$(0)) then
            sname = left$(sname, instr(sname, chr$(0)) - 1)
        end if
    end if
    getlocalhostname = sname
end function

#if win16 then
    public function getpeeraddress(byval s%) as string
    dim addrlen%
#elseif win32 then
    public function getpeeraddress(byval s&) as string
    dim addrlen&
#end if
    dim sa as sockaddr
    addrlen = sockaddr_size
    if getpeername(s, sa, addrlen) then
        getpeeraddress = vbnullstring
    else
        getpeeraddress = sockaddresstostring(sa)
    end if
end function

#if win16 then
    public function getportfromstring(byval portstr$) as integer
#elseif win32 then
    public function getportfromstring(byval portstr$) as long
#end if
    'sometimes users provide ports outside the range of a vb
    'integer, so this function returns an integer for a string
    'just to keep an error from happening, it converts the
    'number to a negative if needed
    if val(portstr$) > 32767 then
        getportfromstring = cint(val(portstr$) - &h10000)
    else
        getportfromstring = val(portstr$)
    end if
    if err then getportfromstring = 0
end function

#if win16 then
    function getprotocolbyname(byval protocol$) as integer
    dim tmpshort%
#elseif win32 then
    function getprotocolbyname(byval protocol$) as long
    dim tmpshort&
#end if
    dim ppe&
    dim pedestprot as protoent
    ppe = getprotobyname(protocol)
    if ppe then
        memcopy pedestprot, byval ppe, protoent_size
        getprotocolbyname = pedestprot.p_proto
    else
        tmpshort = val(protocol)
        if tmpshort then
            getprotocolbyname = htons(tmpshort)
        else
            getprotocolbyname = socket_error
        end if
    end if
end function

#if win16 then
    function getservicebyname(byval service$, byval protocol$) as integer
    dim serv%
#elseif win32 then
    function getservicebyname(byval service$, byval protocol$) as long
    dim serv&
#end if
    dim pse&
    dim sedestserv as servent
    pse = getservbyname(service, protocol)
    if pse then
        memcopy sedestserv, byval pse, servent_size
        getservicebyname = sedestserv.s_port
    else
        serv = val(service)
        if serv then
            getservicebyname = htons(serv)
        else
            getservicebyname = invalid_socket
        end if
    end if
end function

'this function does work on 16 and 32 bit systems
#if win16 then
    function getsockaddress(byval s%) as string
    dim addrlen%
    dim ret%
#elseif win32 then
    function getsockaddress(byval s&) as string
    dim addrlen&
    dim ret&
#end if
    dim sa as sockaddr
    dim szret$
    szret = string(32, 0)
    addrlen = sockaddr_size
    if getsockname(s, sa, addrlen) then
        getsockaddress = vbnullstring
    else
        getsockaddress = sockaddresstostring(sa)
    end if
end function

'this function should work on 16 and 32 bit systems
function getwsaerrorstring(byval errnum&) as string
    on error resume next
    select case errnum
        case 10004: getwsaerrorstring = "interrupted system call."
        case 10009: getwsaerrorstring = "bad file number."
        case 10013: getwsaerrorstring = "permission denied."
        case 10014: getwsaerrorstring = "bad address."
        case 10022: getwsaerrorstring = "invalid argument."
        case 10024: getwsaerrorstring = "too many open files."
        case 10035: getwsaerrorstring = "operation would block."
        case 10036: getwsaerrorstring = "operation now in progress."
        case 10037: getwsaerrorstring = "operation already in progress."
        case 10038: getwsaerrorstring = "socket operation on nonsocket."
        case 10039: getwsaerrorstring = "destination address required."
        case 10040: getwsaerrorstring = "message too long."
        case 10041: getwsaerrorstring = "protocol wrong type for socket."
        case 10042: getwsaerrorstring = "protocol not available."
        case 10043: getwsaerrorstring = "protocol not supported."
        case 10044: getwsaerrorstring = "socket type not supported."
        case 10045: getwsaerrorstring = "operation not supported on socket."
        case 10046: getwsaerrorstring = "protocol family not supported."
        case 10047: getwsaerrorstring = "address family not supported by protocol family."
        case 10048: getwsaerrorstring = "address already in use."
        case 10049: getwsaerrorstring = "can't assign requested address."
        case 10050: getwsaerrorstring = "network is down."
        case 10051: getwsaerrorstring = "network is unreachable."
        case 10052: getwsaerrorstring = "network dropped connection."
        case 10053: getwsaerrorstring = "software caused connection abort."
        case 10054: getwsaerrorstring = "connection reset by peer."
        case 10055: getwsaerrorstring = "no buffer space available."
        case 10056: getwsaerrorstring = "socket is already connected."
        case 10057: getwsaerrorstring = "socket is not connected."
        case 10058: getwsaerrorstring = "can't send after socket shutdown."
        case 10059: getwsaerrorstring = "too many references: can't splice."
        case 10060: getwsaerrorstring = "connection timed out."
        case 10061: getwsaerrorstring = "connection refused."
        case 10062: getwsaerrorstring = "too many levels of symbolic links."
        case 10063: getwsaerrorstring = "file name too long."
        case 10064: getwsaerrorstring = "host is down."
        case 10065: getwsaerrorstring = "no route to host."
        case 10066: getwsaerrorstring = "directory not empty."
        case 10067: getwsaerrorstring = "too many processes."
        case 10068: getwsaerrorstring = "too many users."
        case 10069: getwsaerrorstring = "disk quota exceeded."
        case 10070: getwsaerrorstring = "stale nfs file handle."
        case 10071: getwsaerrorstring = "too many levels of remote in path."
        case 10091: getwsaerrorstring = "network subsystem is unusable."
        case 10092: getwsaerrorstring = "winsock dll cannot support this application."
        case 10093: getwsaerrorstring = "winsock not initialized."
        case 10101: getwsaerrorstring = "disconnect."
        case 11001: getwsaerrorstring = "host not found."
        case 11002: getwsaerrorstring = "nonauthoritative host not found."
        case 11003: getwsaerrorstring = "nonrecoverable error."
        case 11004: getwsaerrorstring = "valid name, no data record of requested type."
        case else:
    end select
end function

'this function does work on 16 and 32 bit systems
function iptoaddr(byval addrorip$) as string
    on error resume next
    iptoaddr = gethostbyaddress(gethostbynamealias(addrorip$))
    if err then iptoaddr = wsa_noname
end function

'this function does work on 16 and 32 bit systems
function ircgetascip(byval ipl$) as string
    'this function is irc specific, it expects a long ip stored in network byte order, in a string
    'the kind that would be parsed out of a dcc command string
    on error goto ircgetasciperror:
    dim lpstr&
#if win16 then
    dim nstr%
#elseif win32 then
    dim nstr&
#end if
    dim retstring$
    dim inn&
    if val(ipl) > 2147483647 then
        inn = val(ipl) - 4294967296#
    else
        inn = val(ipl)
    end if
    inn = ntohl(inn)
    retstring = string(32, 0)
    lpstr = inet_ntoa(inn)
    if lpstr = 0 then
        ircgetascip = "0.0.0.0"
        exit function
    end if
    nstr = lstrlen(lpstr)
    if nstr > 32 then nstr = 32
    memcopy byval retstring, byval lpstr, nstr
    retstring = left$(retstring, nstr)
    ircgetascip = retstring
    exit function
ircgetasciperror:
    ircgetascip = "0.0.0.0"
    exit function
    resume
end function

public function getlongip(byval ips as string) as long
    getlongip = inet_addr(ips)
end function


'this function does work on 16 and 32 bit systems
function ircgetlongip(byval ascip$) as string
    'this function converts an ascii ip string into a long ip in network byte order
    'and stick it in a string suitable for use in a dcc command.
    on error goto ircgetlongiperror:
    dim inn&
    inn = inet_addr(ascip)
    inn = htonl(inn)
    if inn < 0 then
        ircgetlongip = cvar(inn + 4294967296#)
        exit function
    else
        ircgetlongip = cvar(inn)
        exit function
    end if
    exit function
ircgetlongiperror:
    ircgetlongip = "0"
    exit function
    resume
end function

'this function should work on 16 and 32 bit systems
#if win16 then
public function listenforconnect(byval port%, byval hwndtomsg%, byval enlazar as string) as integer
    dim s%, dummy%
    dim selectops%
#elseif win32 then
public function listenforconnect(byval port&, byval hwndtomsg&, byval enlazar as string) as long
    dim s&, dummy&
    dim selectops&
#end if
    dim sockin as sockaddr
    sockin = sazero     'zero out the structure
    sockin.sin_family = af_inet
    sockin.sin_port = htons(port)
    if sockin.sin_port = invalid_socket then
        listenforconnect = invalid_socket
        exit function
    end if
    if lenb(enlazar) = 0 then
        sockin.sin_addr = htonl(inaddr_any)
    else
        sockin.sin_addr = inet_addr(enlazar)
    end if
    if sockin.sin_addr = inaddr_none then
        listenforconnect = invalid_socket
        exit function
    end if
    s = socket(pf_inet, sock_stream, 0)
    if s < 0 then
        listenforconnect = invalid_socket
        exit function
    end if
    
'agregado por maraxus
    'if setsockopt(s, sol_socket, so_conditional_accept, true, 2) then
    '    logapisock ("error seteando conditional accept")
    '    debug.print "error seteando conditional accept"
    'else
    '    logapisock ("conditional accept seteado")
    '    debug.print "conditional accept seteado ^^"
    'end if
    
    if bind(s, sockin, sockaddr_size) then
        if s > 0 then
            dummy = apiclosesocket(s)
        end if
        listenforconnect = invalid_socket
        exit function
    end if
'    selectops = fd_read or fd_write or fd_close or fd_accept
    selectops = fd_read or fd_close or fd_accept
    if wsaasyncselect(s, hwndtomsg, byval 1025, byval selectops) then
        if s > 0 then
            dummy = apiclosesocket(s)
        end if
        listenforconnect = socket_error
        exit function
    end if
    
    'if listen(s, 5) then
    if listen(s, somaxconn) then
        if s > 0 then
            dummy = apiclosesocket(s)
        end if
        listenforconnect = invalid_socket
        exit function
    end if
    listenforconnect = s
end function

'this function should work on 16 and 32 bit systems
#if win16 then
public function ksenddata(byval s%, vmessage as variant) as integer
#elseif win32 then
public function ksenddata(byval s&, vmessage as variant) as long
#end if
    dim themsg() as byte, stemp$
    themsg = vbnullstring
    select case vartype(vmessage)
        case 8209   'byte array
            stemp = vmessage
            themsg = stemp
        case 8      'string, if we recieve a string, its assumed we are linemode
            #if win32 then
                stemp = strconv(vmessage, vbfromunicode)
            #else
                stemp = vmessage
            #end if
        case else
            stemp = cstr(vmessage)
            #if win32 then
                stemp = strconv(vmessage, vbfromunicode)
            #else
                stemp = vmessage
            #end if
    end select
    themsg = stemp
    if ubound(themsg) > -1 then
        ksenddata = send(s, themsg(0), ubound(themsg) + 1, 0)
    end if
end function

public function sockaddresstostring(sa as sockaddr) as string
    sockaddresstostring = getascip(sa.sin_addr) & ":" & ntohs(sa.sin_port)
end function

public function startwinsock(sdescription as string) as boolean
    dim startupdata as wsadatatype
    if not wsastartedup then
        'if not wsastartup(&h101, startupdata) then
        if not wsastartup(&h202, startupdata) then  'use sockets v2.2 instead of 1.1 (maraxus)
            wsastartedup = true
'            debug.print "wversion="; startupdata.wversion, "whighversion="; startupdata.whighversion
'            debug.print "if wversion == 257 then everything is kewl"
'            debug.print "szdescription="; startupdata.szdescription
'            debug.print "szsystemstatus="; startupdata.szsystemstatus
'            debug.print "imaxsockets="; startupdata.imaxsockets, "imaxudpdg="; startupdata.imaxudpdg
            sdescription = startupdata.szdescription
        else
            wsastartedup = false
        end if
    end if
    startwinsock = wsastartedup
end function

public function wsamakeselectreply(theevent%, theerror%) as long
    wsamakeselectreply = (theerror * &h10000) + (theevent and &hffff&)
end function

#end if
