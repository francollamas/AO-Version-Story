version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsbytequeue"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************
' clsbytequeue.cls - fifo list of bytes.
' creates and manipulates byte arrays to be sent and received by both client and server
'
' designed and implemented by juan mart�n sotuyo dodero (maraxus)
' (juansotuyo@gmail.com)
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
' fifo list of bytes
' used to create and manipulate the byte arrays to be sent and received by both client and server
'
' @author juan mart�n sotuyo dodero (maraxus) juansotuyo@gmail.com
' @version 1.0.0
' @date 20060427

option explicit
option base 0       'it's the default, but we make it explicit just in case...

''
' the error number thrown when there is not enough data in
' the buffer to read the specified data type.
' it's 9 (subscript out of range) + the object error constant
private const not_enough_data as long = vbobjecterror + 9

''
' the error number thrown when there is not enough space in
' the buffer to write.
private const not_enough_space as long = vbobjecterror + 10


''
' default size of a data buffer (10 kbs)
'
' @see class_initialize
private const data_buffer as long = 10240

''
' the byte data
dim data() as byte

''
' how big the data array is
dim queuecapacity as long

''
' how far into the data array have we written
dim queuelength as long

''
' copymemory is the fastest way to copy memory blocks, so we abuse of it
'
' @param destination where the data will be copied.
' @param source the data to be copied.
' @param length number of bytes to be copied.

private declare sub copymemory lib "kernel32" alias "rtlmovememory" (byref destination as any, byref source as any, byval length as long)

''
' initializes the queue with the default queuecapacity
'
' @see data_buffer

private sub class_initialize()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'initializes the queue with the default queuecapacity
'***************************************************
    redim data(data_buffer - 1) as byte
    
    queuecapacity = data_buffer
end sub

''
' clean up and release resources

private sub class_terminate()
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'clean up
'***************************************************
    erase data
end sub

''
' copies another bytequeue's data into this object.
'
' @param source the bytequeue whose buffer will eb copied.
' @remarks  this method will resize the bytequeue's buffer to match
'           the source. all previous data on this object will be lost.

public sub copybuffer(byref source as clsbytequeue)
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'a visual basic equivalent of a copy contructor
'***************************************************
    if source.length = 0 then
        'clear the list and exit
        call removedata(length)
        exit sub
    end if
    
    ' set capacity and resize array - make sure all data is lost
    queuecapacity = source.capacity
    
    redim data(queuecapacity - 1) as byte
    
    ' read buffer
    dim buf() as byte
    redim buf(source.length - 1) as byte
    
    call source.peekblock(buf, source.length)
    
    queuelength = 0
    
    ' write buffer
    call writeblock(buf, source.length)
end sub

''
' returns the smaller of val1 and val2
'
' @param val1 first value to compare
' @param val2 second value to compare
' @return   the smaller of val1 and val2
' @remarks  this method is faster than iif() and cleaner, therefore it's used instead of it

private function min(byval val1 as long, byval val2 as long) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'it's faster than iif and i like it better
'***************************************************
    if val1 < val2 then
        min = val1
    else
        min = val2
    end if
end function

''
' writes a byte array at the end of the byte queue if there is enough space.
' otherwise it throws not_enough_data.
'
' @param buf byte array containing the data to be copied. must have 0 as the first index.
' @param datalength total number of elements in the array
' @return   the actual number of bytes copied
' @remarks  buf must be base 0
' @see removedata
' @see readdata
' @see not_enough_data

private function writedata(byref buf() as byte, byval datalength as long) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'if the queuecapacity allows it copyes a byte buffer to the queue, if not it throws not_enough_data
'***************************************************
    'check if there is enough free space
    if queuecapacity - queuelength - datalength < 0 then
        call err.raise(not_enough_space)
        exit function
    end if
    
    'copy data from buffer
    call copymemory(data(queuelength), buf(0), datalength)
    
    'update length of data
    queuelength = queuelength + datalength
    writedata = datalength
end function

''
' reads a byte array from the beginning of the byte queue if there is enough data available.
' otherwise it throws not_enough_data.
'
' @param buf byte array where to copy the data. must have 0 as the first index and already be sized properly.
' @param datalength total number of elements in the array
' @return   the actual number of bytes copied
' @remarks  buf must be base 0 and be already resized to be able to contain the requested bytes.
' this method performs no checks of such things as being a private method it's supposed that the consistency of the module is to be kept.
' if there is not enough data available it will read all available data.
' @see writedata
' @see removedata
' @see not_enough_data

private function readdata(byref buf() as byte, byval datalength as long) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'if enough memory is available, it copies the requested number of bytes to the buffer
'***************************************************
    'check if we can read the number of bytes requested
    if datalength > queuelength then
        call err.raise(not_enough_data)
        exit function
    end if
    
    'copy data to buffer
    call copymemory(buf(0), data(0), datalength)
    readdata = datalength
end function

''
' removes a given number of bytes from the beginning of the byte queue.
' if there is less data available than the requested amount it removes all data.
'
' @param datalength total number of bytes to remove
' @return   the actual number of bytes removed
' @see writedata
' @see readdata

private function removedata(byval datalength as long) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'moves forward the queue overwriting the first datalength bytes
'***************************************************
    'figure out how many bytes we can remove
    removedata = min(datalength, queuelength)
    
    'remove data - prevent rt9 when cleaning a full queue
    if removedata <> queuecapacity then _
        call copymemory(data(0), data(removedata), queuelength - removedata)
    
    'update length
    queuelength = queuelength - removedata
end function

''
' writes a single byte at the end of the queue
'
' @param value the value to be written
' @return   the number of bytes written
' @see peekbyte
' @see readbyte

public function writebyte(byval value as byte) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a byte to the queue
'***************************************************
    dim buf(0) as byte
    
    buf(0) = value
    
    writebyte = writedata(buf, 1)
end function

''
' writes an integer at the end of the queue
'
' @param value the value to be written
' @return   the number of bytes written
' @see peekinteger
' @see readinteger

public function writeinteger(byval value as integer) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes an integer to the queue
'***************************************************
    dim buf(1) as byte
    
    'copy data to temp buffer
    call copymemory(buf(0), value, 2)
    
    writeinteger = writedata(buf, 2)
end function

''
' writes a long at the end of the queue
'
' @param value the value to be written
' @return   the number of bytes written
' @see peeklong
' @see readlong

public function writelong(byval value as long) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a long to the queue
'***************************************************
    dim buf(3) as byte
    
    'copy data to temp buffer
    call copymemory(buf(0), value, 4)
    
    writelong = writedata(buf, 4)
end function

''
' writes a boolean value at the end of the queue
'
' @param value the value to be written
' @return   the number of bytes written
' @see peekboolean
' @see readboolean

public function writeboolean(byval value as boolean) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a byte to the queue
'***************************************************
    dim buf(0) as byte
    
    if value then buf(0) = 1
    
    writeboolean = writedata(buf, 1)
end function

''
' writes a fixed length ascii string at the end of the queue
'
' @param value the string to be written
' @return   the number of bytes written
' @see peekasciistringfixed
' @see readasciistringfixed

public function writeasciistringfixed(byval value as string) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a fixed length ascii string to the queue
'***************************************************
    dim buf() as byte
    redim buf(len(value) - 1) as byte
    
    'copy data to temp buffer
    call copymemory(buf(0), byval strptr(strconv(value, vbfromunicode)), len(value))
    
    writeasciistringfixed = writedata(buf, len(value))
end function

''
' writes a fixed length unicode string at the end of the queue
'
' @param value the string to be written
' @return   the number of bytes written
' @see peekunicodestringfixed
' @see readunicodestringfixed

public function writeunicodestringfixed(byval value as string) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a fixed length unicode string to the queue
'***************************************************
    dim buf() as byte
    redim buf(lenb(value)) as byte
    
    'copy data to temp buffer
    call copymemory(buf(0), byval strptr(value), lenb(value))
    
    writeunicodestringfixed = writedata(buf, lenb(value))
end function

''
' writes a variable length ascii string at the end of the queue
'
' @param value the string to be written
' @return   the number of bytes written
' @see peekasciistring
' @see readasciistring

public function writeasciistring(byval value as string) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a variable length ascii string to the queue
'***************************************************
    dim buf() as byte
    redim buf(len(value) + 1) as byte
    
    'copy length to temp buffer
    call copymemory(buf(0), cint(len(value)), 2)
    
    if len(value) > 0 then
        'copy data to temp buffer
        call copymemory(buf(2), byval strptr(strconv(value, vbfromunicode)), len(value))
    end if
    
    writeasciistring = writedata(buf, len(value) + 2)
end function

''
' writes a variable length unicode string at the end of the queue
'
' @param value the string to be written
' @return   the number of bytes written
' @see peekunicodestring
' @see readunicodestring

public function writeunicodestring(byval value as string) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a variable length unicode string to the queue
'***************************************************
    dim buf() as byte
    redim buf(lenb(value) + 1) as byte
    
    'copy length to temp buffer
    call copymemory(buf(0), cint(len(value)), 2)
    
    if len(value) > 0 then
        'copy data to temp buffer
        call copymemory(buf(2), byval strptr(value), lenb(value))
    end if
    
    writeunicodestring = writedata(buf, lenb(value) + 2)
end function

''
' writes a byte array at the end of the queue
'
' @param value the byte array to be written. must be base 0.
' @param length the number of elements to copy from the byte array. if less than 0 it will copy the whole array.
' @return   the number of bytes written
' @remarks  value() must be base 0.
' @see peekblock
' @see readblock

public function writeblock(byref value() as byte, optional byval length as long = -1) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'writes a byte array to the queue
'***************************************************
    'prevent from copying memory outside the array
    if length > ubound(value()) + 1 or length < 0 then length = ubound(value()) + 1
    
    writeblock = writedata(value, length)
end function

''
' reads a single byte from the begining of the queue and removes it
'
' @return   the read value
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' @see peekbyte
' @see writebyte

public function readbyte() as byte
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a byte from the queue and removes it
'***************************************************
    dim buf(0) as byte
    
    'read the data and remove it
    call removedata(readdata(buf, 1))
    
    readbyte = buf(0)
end function

''
' reads an integer from the begining of the queue and removes it
'
' @return   the read value
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' @see peekinteger
' @see writeinteger

public function readinteger() as integer
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads an integer from the queue and removes it
'***************************************************
    dim buf(1) as byte
    
    'read the data and remove it
    call removedata(readdata(buf, 2))
    
    'copy data to temp buffer
    call copymemory(readinteger, buf(0), 2)
end function

''
' reads a long from the begining of the queue and removes it
'
' @return   the read value
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' @see peeklong
' @see writelong

public function readlong() as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a long from the queue and removes it
'***************************************************
    dim buf(3) as byte
    
    'read the data and remove it
    call removedata(readdata(buf, 4))
    
    'copy data to temp buffer
    call copymemory(readlong, buf(0), 4)
end function

''
' reads a boolean from the begining of the queue and removes it
'
' @return   the read value
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' @see peekboolean
' @see writeboolean

public function readboolean() as boolean
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a boolean from the queue and removes it
'***************************************************
    dim buf(0) as byte
    
    'read the data and remove it
    call removedata(readdata(buf, 1))
    
    if buf(0) = 1 then readboolean = true
end function

''
' reads a fixed length ascii string from the begining of the queue and removes it
'
' @param length the length of the string to be read
' @return   the read string
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' if there is not enough data to read the complete string then nothing is removed and an empty string is returned
' @see peekasciistringfixed
' @see writeunicodestringfixed

public function readasciistringfixed(byval length as long) as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a fixed length ascii string from the queue and removes it
'***************************************************
    if length <= 0 then exit function
    
    if queuelength >= length then
        dim buf() as byte
        redim buf(length - 1) as byte
        
        'read the data and remove it
        call removedata(readdata(buf, length))
        
        readasciistringfixed = strconv(buf, vbunicode)
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a fixed length unicode string from the begining of the queue and removes it
'
' @param length the length of the string to be read.
' @return   the read string if enough data is available, an empty string otherwise.
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way.
' if there is not enough data to read the complete string then nothing is removed and an empty string is returned
' @see peekunicodestringfixed
' @see writeunicodestringfixed

public function readunicodestringfixed(byval length as long) as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a fixed length unicode string from the queue and removes it
'***************************************************
    if length <= 0 then exit function
    
    if queuelength >= length * 2 then
        dim buf() as byte
        redim buf(length * 2 - 1) as byte
        
        'read the data and remove it
        call removedata(readdata(buf, length * 2))
        
        readunicodestringfixed = buf
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a variable length ascii string from the begining of the queue and removes it
'
' @return   the read string
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' if there is not enough data to read the complete string then nothing is removed and an empty string is returned
' @see peekasciistring
' @see writeasciistring

public function readasciistring() as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a variable length ascii string from the queue and removes it
'***************************************************
    dim buf(1) as byte
    dim length as integer
    
    'make sure we can read a valid length
    if queuelength > 1 then
        'read the length
        call readdata(buf, 2)
        call copymemory(length, buf(0), 2)
        
        'make sure there are enough bytes
        if queuelength >= length + 2 then
            'remove the length
            call removedata(2)
            
            if length > 0 then
                dim buf2() as byte
                redim buf2(length - 1) as byte
                
                
                'read the data and remove it
                call removedata(readdata(buf2, length))
                
                readasciistring = strconv(buf2, vbunicode)
            end if
        else
            call err.raise(not_enough_data)
        end if
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a variable length unicode string from the begining of the queue and removes it
'
' @return   the read string if enough data is available, an empty string otherwise.
' @remarks  read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' if there is not enough data to read the complete string then nothing is removed and an empty string is returned
' @see peekunicodestring
' @see writeunicodestring

public function readunicodestring() as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a variable length unicode string from the queue and removes it
'***************************************************
    dim buf(1) as byte
    dim length as integer
    
    'make sure we can read a valid length
    if queuelength > 1 then
        'read the length
        call readdata(buf, 2)
        call copymemory(length, buf(0), 2)
        
        'make sure there are enough bytes
        if queuelength >= length * 2 + 2 then
            'remove the length
            call removedata(2)
            
            dim buf2() as byte
            redim buf2(length * 2 - 1) as byte
            
            'read the data and remove it
            call removedata(readdata(buf2, length * 2))
            
            readunicodestring = buf2
        else
            call err.raise(not_enough_data)
        end if
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a byte array from the begining of the queue and removes it
'
' @param block byte array which will contain the read data. must be base 0 and previously resized to contain the requested amount of bytes.
' @param datalength number of bytes to retrieve from the queue.
' @return   the number of read bytes.
' @remarks  the block() array must be base 0 and previously resized to be able to contain the requested bytes.
' read methods removes the data from the queue.
' data removed can't be recovered by the queue in any way
' @see peekblock
' @see writeblock

public function readblock(byref block() as byte, byval datalength as long) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a byte array from the queue and removes it
'***************************************************
    'read the data and remove it
    if datalength > 0 then _
        readblock = removedata(readdata(block(), datalength))
end function

''
' reads a single byte from the begining of the queue but does not remove it.
'
' @return   the read value.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' @see readbyte
' @see writebyte

public function peekbyte() as byte
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a byte from the queue but doesn't removes it
'***************************************************
    dim buf(0) as byte
    
    'read the data and remove it
    call readdata(buf, 1)
    
    peekbyte = buf(0)
end function

''
' reads an integer from the begining of the queue but does not remove it.
'
' @return   the read value.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' @see readinteger
' @see writeinteger

public function peekinteger() as integer
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads an integer from the queue but doesn't removes it
'***************************************************
    dim buf(1) as byte
    
    'read the data and remove it
    call readdata(buf, 2)
    
    'copy data to temp buffer
    call copymemory(peekinteger, buf(0), 2)
end function

''
' reads a long from the begining of the queue but does not remove it.
'
' @return   the read value.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' @see readlong
' @see writelong

public function peeklong() as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a long from the queue but doesn't removes it
'***************************************************
    dim buf(3) as byte
    
    'read the data and remove it
    call readdata(buf, 4)
    
    'copy data to temp buffer
    call copymemory(peeklong, buf(0), 4)
end function

''
' reads a bollean from the begining of the queue but does not remove it.
'
' @return   the read value.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' @see readboolean
' @see writeboolean

public function peekboolean() as boolean
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a boolean from the queue but doesn't removes it
'***************************************************
    dim buf(0) as byte
    
    'read the data and remove it
    call readdata(buf, 1)
    
    if buf(0) = 1 then peekboolean = true
end function

''
' reads a fixed length ascii string from the begining of the queue but does not remove it.
'
' @param length the length of the string to be read
' @return   the read string if enough data is available, an empty string otherwise.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' if there is not enough data to read the complete string then an empty string is returned
' @see readasciistringfixed
' @see writeasciistringfixed

public function peekasciistringfixed(byval length as long) as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a fixed length ascii string from the queue but doesn't removes it
'***************************************************
    if length <= 0 then exit function
    
    if queuelength >= length then
        dim buf() as byte
        redim buf(length - 1) as byte
        
        'read the data and remove it
        call readdata(buf, length)
        
        peekasciistringfixed = strconv(buf, vbunicode)
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a fixed length unicode string from the begining of the queue but does not remove it.
'
' @param length the length of the string to be read
' @return   the read string if enough data is available, an empty string otherwise.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' if there is not enough data to read the complete string then an empty string is returned
' @see readunicodestringfixed
' @see writeunicodestringfixed

public function peekunicodestringfixed(byval length as long) as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a fixed length unicode string from the queue but doesn't removes it
'***************************************************
    if length <= 0 then exit function
    
    if queuelength >= length * 2 then
        dim buf() as byte
        redim buf(length * 2 - 1) as byte
        
        'read the data and remove it
        call readdata(buf, length * 2)
        
        peekunicodestringfixed = buf
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a variable length ascii string from the begining of the queue but does not remove it.
'
' @return   the read string if enough data is available, an empty string otherwise.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' if there is not enough data to read the complete string then an empty string is returned
' @see readasciistring
' @see writeasciistring

public function peekasciistring() as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a variable length ascii string from the queue but doesn't removes it
'***************************************************
    dim buf(1) as byte
    dim length as integer
    
    'make sure we can read a valid length
    if queuelength > 1 then
        'read the length
        call readdata(buf, 2)
        call copymemory(length, buf(0), 2)
        
        'make sure there are enough bytes
        if queuelength >= length + 2 then
            dim buf2() as byte
            redim buf2(length + 1) as byte
            
            'read the data (we have to read the length again)
            call readdata(buf2, length + 2)
            
            if length > 0 then
                'get rid of the length
                dim buf3() as byte
                redim buf3(length - 1) as byte
                call copymemory(buf3(0), buf2(2), length)
                
                peekasciistring = strconv(buf3, vbunicode)
            end if
        else
            call err.raise(not_enough_data)
        end if
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a variable length unicode string from the begining of the queue but does not remove it.
'
' @return   the read string if enough data is available, an empty string otherwise.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' if there is not enough data to read the complete string then an empty string is returned
' @see readunicodestring
' @see writeunicodestring

public function peekunicodestring() as string
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a variable length unicode string from the queue but doesn't removes it
'***************************************************
    dim buf(1) as byte
    dim length as integer
    
    'make sure we can read a valid length
    if queuelength > 1 then
        'read the length
        call readdata(buf, 2)
        call copymemory(length, buf(0), 2)
        
        'make sure there are enough bytes
        if queuelength >= length * 2 + 2 then
            dim buf2() as byte
            redim buf2(length * 2 + 1) as byte
            
            'read the data (we need to read the length again)
            call readdata(buf2, length * 2 + 2)
            
            'get rid of the length bytes
            dim buf3() as byte
            redim buf3(length * 2 - 1) as byte
            call copymemory(buf3(0), buf2(2), length * 2)
            
            peekunicodestring = buf3
        else
            call err.raise(not_enough_data)
        end if
    else
        call err.raise(not_enough_data)
    end if
end function

''
' reads a byte array from the begining of the queue but does not remove it.
'
' @param block() byte array that will contain the read data. must be base 0 and previously resized to contain the requested amount of bytes.
' @param datalength number of bytes to be read
' @return   the actual number of read bytes.
' @remarks  peek methods, unlike read methods, don't remove the data from the queue.
' @see readblock
' @see writeblock

public function peekblock(byref block() as byte, byval datalength as long) as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'reads a byte array from the queue but doesn't removes it
'***************************************************
    'read the data
    if datalength > 0 then _
        peekblock = readdata(block(), datalength)
end function

''
' retrieves the current capacity of the queue.
'
' @return   the current capacity of the queue.

public property get capacity() as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'retrieves the current capacity of the queue
'***************************************************
    capacity = queuecapacity
end property

''
' sets the capacity of the queue.
'
' @param value the new capacity of the queue.
' @remarks if the new capacity is smaller than the current length, all exceeding data is lost.
' @see length

public property let capacity(byval value as long)
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'sets the current capacity of the queue.
'all data in the queue exceeding the new capacity is lost
'***************************************************
    'upate capacity
    queuecapacity = value
    
    'all extra data is lost
    if length > value then queuelength = value
    
    'resize the queue
    redim preserve data(queuecapacity - 1) as byte
end property

''
' retrieves the length of the total data in the queue.
'
' @return   the length of the total data in the queue.

public property get length() as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'retrieves the current number of bytes in the queue
'***************************************************
    length = queuelength
end property

''
' retrieves the not_enough_data error code.
'
' @return   not_enough_data.

public property get notenoughdataerrcode() as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'retrieves the not_enough_data error code
'***************************************************
    notenoughdataerrcode = not_enough_data
end property

''
' retrieves the not_enough_space error code.
'
' @return   not_enough_space.

public property get notenoughspaceerrcode() as long
'***************************************************
'autor: juan mart�n sotuyo dodero (maraxus)
'last modification: 04/27/06
'retrieves the not_enough_space error code
'***************************************************
    notenoughspaceerrcode = not_enough_space
end property

