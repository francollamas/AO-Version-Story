attribute vb_name = "modcompression"
option explicit

public const grh_source_file_ext as string = ".bmp"
public const grh_resource_file as string = "graphics.ao"
public const grh_patch_file as string = "graphics.patch"

'this structure will describe our binary file's
'size, number and version of contained files
public type fileheader
    lngnumfiles as long                 'how many files are inside?
    lngfilesize as long                 'how big is this file? (used to check integrity)
    lngfileversion as long              'the resource version (used to patch)
end type

'this structure will describe each file contained
'in our binary file
public type infoheader
    lngfilesize as long             'how big is this chunk of stored data?
    lngfilestart as long            'where does the chunk start?
    strfilename as string * 16      'what's the name of the file this data came from?
    lngfilesizeuncompressed as long 'how big is the file compressed
    
#if seguridadalkon then
    lngchecksum as long
#end if
end type

private enum patchinstruction
    delete_file
    create_file
    modify_file
end enum

private declare function compress lib "zlib.dll" (dest as any, destlen as any, src as any, byval srclen as long) as long
private declare function uncompress lib "zlib.dll" (dest as any, destlen as any, src as any, byval srclen as long) as long

private declare sub copymemory lib "kernel32" alias "rtlmovememory" (byref dest as any, byref source as any, byval bytecount as long)

'bitmaps strucures
public type bitmapfileheader
    bftype as integer
    bfsize as long
    bfreserved1 as integer
    bfreserved2 as integer
    bfoffbits as long
end type
public type bitmapinfoheader
    bisize as long
    biwidth as long
    biheight as long
    biplanes as integer
    bibitcount as integer
    bicompression as long
    bisizeimage as long
    bixpelspermeter as long
    biypelspermeter as long
    biclrused as long
    biclrimportant as long
end type
public type rgbquad
    rgbblue as byte
    rgbgreen as byte
    rgbred as byte
    rgbreserved as byte
end type
public type bitmapinfo
    bmiheader as bitmapinfoheader
    bmicolors(255) as rgbquad
end type

private const bi_rgb as long = 0
private const bi_rle8 as long = 1
private const bi_rle4 as long = 2
private const bi_bitfields as long = 3
private const bi_jpg as long = 4
private const bi_png as long = 5


'to get free bytes in drive
private declare function getdiskfreespace lib "kernel32" alias "getdiskfreespaceexa" (byval lprootpathname as string, freebytestocaller as currency, bytestotal as currency, freebytestotal as currency) as long

private function general_drive_get_free_bytes(byval drivename as string) as currency
'**************************************************************
'author: juan mart�n sotuyo dodero
'last modify date: 6/07/2004
'
'**************************************************************
    dim retval as long
    dim fb as currency
    dim bt as currency
    dim fbt as currency
    
    retval = getdiskfreespace(left$(drivename, 2), fb, bt, fbt)
    
    general_drive_get_free_bytes = fb * 10000 'convert result to actual size in bytes
end function

''
' sorts the info headers by their file name. uses quicksort.
'
' @param    infohead() the array of headers to be ordered.
' @param    first the first index in the list.
' @param    last the last index in the list.

private sub sort_info_headers(byref infohead() as infoheader, byval first as long, byval last as long)
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/20/2007
'sorts the info headers by their file name using quicksort.
'*****************************************************************
    dim aux as infoheader
    dim min as long
    dim max as long
    dim comp as string
    
    min = first
    max = last
    
    comp = infohead((min + max) \ 2).strfilename
    
    do while min <= max
        do while infohead(min).strfilename < comp and min < last
            min = min + 1
        loop
        do while infohead(max).strfilename > comp and max > first
            max = max - 1
        loop
        if min <= max then
            aux = infohead(min)
            infohead(min) = infohead(max)
            infohead(max) = aux
            min = min + 1
            max = max - 1
        end if
    loop
    
    if first < max then call sort_info_headers(infohead, first, max)
    if min < last then call sort_info_headers(infohead, min, last)
end sub

''
' searches for the specified infoheader.
'
' @param    resourcefile a handler to the data file.
' @param    infohead the header searched.
' @param    firsthead the first head to look.
' @param    lasthead the last head to look.
' @param    fileheadersize the bytes size of a fileheader.
' @param    infoheadersize the bytes size of a infoheader.
'
' @return   true if found.
'
' @remark   file must be already open.
' @remark   infohead must have set its file name to perform the search.

private function binarysearch(byref resourcefile as integer, byref infohead as infoheader, byval firsthead as long, byval lasthead as long, byval fileheadersize as long, byval infoheadersize as long) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/21/2007
'searches for the specified infoheader
'*****************************************************************
    dim readinghead as long
    dim readinfohead as infoheader
    
    do until firsthead > lasthead
        readinghead = (firsthead + lasthead) \ 2

        get resourcefile, fileheadersize + infoheadersize * (readinghead - 1) + 1, readinfohead

        if infohead.strfilename = readinfohead.strfilename then
            infohead = readinfohead
            binarysearch = true
            exit function
        else
            if infohead.strfilename < readinfohead.strfilename then
                lasthead = readinghead - 1
            else
                firsthead = readinghead + 1
            end if
        end if
    loop
end function

''
' retrieves the infohead of the specified graphic file.
'
' @param    resourcepath the resource file folder.
' @param    filename the graphic file name.
' @param    infohead the infohead where data is returned.
'
' @return   true if found.

private function get_infoheader(byref resourcepath as string, byref filename as string, byref infohead as infoheader) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/21/2007
'retrieves the infohead of the specified graphic file
'*****************************************************************
    dim resourcefile as integer
    dim resourcefilepath as string
    dim filehead as fileheader
    
on local error goto errhandler

    resourcefilepath = resourcepath & grh_resource_file
    
    'set infoheader we are looking for
    infohead.strfilename = ucase$(filename)
    
#if seguridadalkon then
    call secure_info_header(infohead)
#end if
    
    'open the binary file
    resourcefile = freefile()
    open resourcefilepath for binary access read lock write as resourcefile
        'extract the fileheader
        get resourcefile, 1, filehead
        
#if seguridadalkon then
        call secure_file_header(filehead)
#end if
        
        'check the file for validity
        if lof(resourcefile) <> filehead.lngfilesize then
            msgbox "archivo de recursos da�ado. " & resourcefilepath, , "error"
            close resourcefile
            exit function
        end if
        
        'search for it!
        if binarysearch(resourcefile, infohead, 1, filehead.lngnumfiles, len(filehead), len(infohead)) then
#if seguridadalkon then
            call secure_info_header(infohead)
#end if
            
            get_infoheader = true
        end if
        
    close resourcefile
exit function

errhandler:
    close resourcefile
    
    call msgbox("error al intentar leer el archivo " & resourcefilepath & ". raz�n: " & err.number & " : " & err.description, vbokonly, "error")
end function

''
' compresses binary data avoiding data loses.
'
' @param    data() the data array.

private sub compress_data(byref data() as byte)
'*****************************************************************
'author: juan mart�n dotuyo dodero
'last modify date: 10/13/2004
'compresses binary data avoiding data loses
'*****************************************************************
    dim dimensions as long
    dim dimbuffer as long
    dim buftemp() as byte
    dim loopc as long
    
    dimensions = ubound(data) + 1
    
    ' the worst case scenario, compressed info is 1.06 times the original - see zlib's doc for more info.
    dimbuffer = dimensions * 1.06
    
    redim buftemp(dimbuffer)
    
    call compress(buftemp(0), dimbuffer, data(0), dimensions)
    
    erase data
    
    redim data(dimbuffer - 1)
    redim preserve buftemp(dimbuffer - 1)
    
    data = buftemp
    
    erase buftemp
    
#if seguridadalkon then
    call secure_compressed_data(data)
#end if
end sub

''
' decompresses binary data.
'
' @param    data() the data array.
' @param    origsize the original data size.

private sub decompress_data(byref data() as byte, byval origsize as long)
'*****************************************************************
'author: juan mart�n dotuyo dodero
'last modify date: 10/13/2004
'decompresses binary data
'*****************************************************************
    dim buftemp() as byte
    
    redim buftemp(origsize - 1)
    
#if seguridadalkon then
    call secure_compressed_data(data)
#end if
    
    call uncompress(buftemp(0), origsize, data(0), ubound(data) + 1)
    
    redim data(origsize - 1)
    
    data = buftemp
    
    erase buftemp
end sub

''
' compresses all graphic files to a resource file.
'
' @param    sourcepath the graphic files folder.
' @param    outputpath the resource file folder.
' @param    version the resource file version.
' @param    prgbar the control that shows the process state.
'
' @return   true if no error occurred.

public function compress_files(byref sourcepath as string, byref outputpath as string, byval version as long, byref prgbar as progressbar) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/19/2007
'compresses all graphic files to a resource file
'*****************************************************************
    dim sourcefilename as string
    dim outputfilepath as string
    dim sourcefile as long
    dim outputfile as long
    dim sourcedata() as byte
    dim filehead as fileheader
    dim infohead() as infoheader
    dim loopc as long

on local error goto errhandler
    outputfilepath = outputpath & grh_resource_file
    sourcefilename = dir(sourcepath & "*" & grh_source_file_ext, vbnormal)
    
    ' create list of all files to be compressed
    while sourcefilename <> ""
        filehead.lngnumfiles = filehead.lngnumfiles + 1
        
        redim preserve infohead(filehead.lngnumfiles - 1)
        infohead(filehead.lngnumfiles - 1).strfilename = ucase$(sourcefilename)
        
#if seguridadalkon then
        'we want the list ordered considering encryption
        call secure_info_header(infohead(filehead.lngnumfiles - 1))
#end if
        
        'search new file
        sourcefilename = dir()
    wend
    
    if filehead.lngnumfiles = 0 then
        msgbox "no se encontraron archivos de extenci�n " & grh_source_file_ext & " en " & sourcepath & ".", , "error"
        exit function
    end if
    
    if not prgbar is nothing then
        prgbar.max = filehead.lngnumfiles
        prgbar.value = 0
    end if
    
    'destroy file if it previuosly existed
    if dir(outputfilepath, vbnormal) <> "" then
        kill outputfilepath
    end if
    
    'finish setting the fileheader data
    filehead.lngfileversion = version
    filehead.lngfilesize = len(filehead) + filehead.lngnumfiles * len(infohead(0))
    
    'order the infoheads
    call sort_info_headers(infohead(), 0, filehead.lngnumfiles - 1)
    
    'open a new file
    outputfile = freefile()
    open outputfilepath for binary access read write as outputfile
        ' move to the end of the headers, where the file data will actually start
        seek outputfile, filehead.lngfilesize + 1
        
        ' process every file!
        for loopc = 0 to filehead.lngnumfiles - 1
            
#if seguridadalkon then
            call secure_info_header(infohead(loopc))
#end if
            
            sourcefile = freefile()
            open sourcepath & infohead(loopc).strfilename for binary access read lock write as sourcefile
                
                'find out how large the file is and resize the data array appropriately
                infohead(loopc).lngfilesizeuncompressed = lof(sourcefile)
                redim sourcedata(lof(sourcefile) - 1)
                
                'get the data from the file
                get sourcefile, , sourcedata
                
                'compress it
                call compress_data(sourcedata)
                
                'store it in the resource file
                put outputfile, , sourcedata
                
                with infohead(loopc)
                    'set up the info headers
                    .lngfilesize = ubound(sourcedata) + 1
                    .lngfilestart = filehead.lngfilesize + 1
                    
                    'update the file header
                    filehead.lngfilesize = filehead.lngfilesize + .lngfilesize
                end with
                
#if seguridadalkon then
                call secure_info_header(infohead(loopc))
#end if
                
                erase sourcedata
            
            close sourcefile
        
            'update progress bar
            if not prgbar is nothing then prgbar.value = prgbar.value + 1
            doevents
        next loopc
        
#if seguridadalkon then
        call secure_file_header(filehead)
#end if
        
        'store the headers in the file
        seek outputfile, 1
        put outputfile, , filehead
        put outputfile, , infohead
        
    'close the file
    close outputfile
    
    erase infohead
    erase sourcedata
    
    compress_files = true
exit function

errhandler:
    erase sourcedata
    erase infohead
    close outputfile
    
    call msgbox("no se pudo crear el archivo binario. raz�n: " & err.number & " : " & err.description, vbokonly, "error")
end function

''
' retrieves a byte array with the compressed data from the specified file.
'
' @param    resourcepath the resource file folder.
' @param    infohead the header specifiing the graphic file info.
' @param    data() the byte array to return data.
'
' @return   true if no error occurred.
'
' @remark   infohead must not be encrypted.
' @remark   data is not desencrypted.

public function get_file_rawdata(byref resourcepath as string, byref infohead as infoheader, byref data() as byte) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/24/2007
'retrieves a byte array with the compressed data from the specified file
'*****************************************************************
    dim resourcefilepath as string
    dim resourcefile as integer
    
on local error goto errhandler
    resourcefilepath = resourcepath & grh_resource_file
    
    'size the data array
    redim data(infohead.lngfilesize - 1)
    
    'open the binary file
    resourcefile = freefile
    open resourcefilepath for binary access read lock write as resourcefile
        'get the data
        get resourcefile, infohead.lngfilestart, data
    'close the binary file
    close resourcefile
    
    get_file_rawdata = true
exit function

errhandler:
    close resourcefile
end function

''
' extract the specific file from a resource file.
'
' @param    resourcepath the resource file folder.
' @param    infohead the header specifiing the graphic file info.
' @param    data() the byte array to return data.
'
' @return   true if no error occurred.
'
' @remark   data is desencrypted.

public function extract_file(byref resourcepath as string, byref infohead as infoheader, byref data() as byte) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/20/2007
'extract the specific file from a resource file
'*****************************************************************
on local error goto errhandler
    
    if get_file_rawdata(resourcepath, infohead, data) then
        'decompress all data
        if infohead.lngfilesize < infohead.lngfilesizeuncompressed then
            call decompress_data(data, infohead.lngfilesizeuncompressed)
        end if
        
        extract_file = true
    end if
exit function

errhandler:
    call msgbox("error al intentar decodificar recursos. razon: " & err.number & " : " & err.description, vbokonly, "error")
end function

''
' extracts all files from a resource file.
'
' @param    resourcepath the resource file folder.
' @param    outputpath the folder where graphic files will be extracted.
' @param    prgbar the control that shows the process state.
'
' @return   true if no error occurred.

public function extract_files(byref resourcepath as string, byref outputpath as string, byref prgbar as progressbar) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/20/2007
'extracts all files from a resource file
'*****************************************************************
    dim loopc as long
    dim resourcefile as integer
    dim resourcefilepath as string
    dim outputfile as integer
    dim sourcedata() as byte
    dim filehead as fileheader
    dim infohead() as infoheader
    dim requiredspace as currency
    
on local error goto errhandler
    resourcefilepath = resourcepath & grh_resource_file
    
    'open the binary file
    resourcefile = freefile()
    open resourcefilepath for binary access read lock write as resourcefile
        'extract the fileheader
        get resourcefile, 1, filehead
        
#if seguridadalkon then
        call secure_file_header(filehead)
#end if
        
        'check the file for validity
        if lof(resourcefile) <> filehead.lngfilesize then
            call msgbox("archivo de recursos da�ado. " & resourcefilepath, , "error")
            close resourcefile
            exit function
        end if
        
        'size the infohead array
        redim infohead(filehead.lngnumfiles - 1)
        
        'extract the infoheader
        get resourcefile, , infohead
        
        'check if there is enough hard drive space to extract all files
        for loopc = 0 to ubound(infohead)
#if seguridadalkon then
            call secure_info_header(infohead(loopc))
#end if
            
            requiredspace = requiredspace + infohead(loopc).lngfilesizeuncompressed
        next loopc
        
        if requiredspace >= general_drive_get_free_bytes(left$(app.path, 3)) then
            erase infohead
            close resourcefile
            call msgbox("no hay suficiente espacio en el disco para extraer los archivos.", , "error")
            exit function
        end if
    close resourcefile
    
    'update progress bar
    if not prgbar is nothing then
        prgbar.max = filehead.lngnumfiles
        prgbar.value = 0
    end if
    
    'extract all of the files from the binary file
    for loopc = 0 to ubound(infohead)
        'extract this file
        if extract_file(resourcepath, infohead(loopc), sourcedata) then
            'destroy file if it previuosly existed
            if fileexist(outputpath & infohead(loopc).strfilename, vbnormal) then
                call kill(outputpath & infohead(loopc).strfilename)
            end if
            
            'save it!
            outputfile = freefile()
            open outputpath & infohead(loopc).strfilename for binary as outputfile
                put outputfile, , sourcedata
            close outputfile
            
            erase sourcedata
        else
            erase sourcedata
            erase infohead
            
            call msgbox("no se pudo extraer el archivo " & infohead(loopc).strfilename, vbokonly, "error")
            exit function
        end if
            
        'update progress bar
        if not prgbar is nothing then prgbar.value = prgbar.value + 1
        doevents
    next loopc
    
    erase infohead
    extract_files = true
exit function

errhandler:
    close resourcefile
    erase sourcedata
    erase infohead
    
    call msgbox("no se pudo extraer el archivo binario correctamente. razon: " & err.number & " : " & err.description, vbokonly, "error")
end function

''
' retrieves a byte array with the specified file data.
'
' @param    resourcepath the resource file folder.
' @param    filename the graphic file name.
' @param    data() the byte array to return data.
'
' @return   true if no error occurred.
'
' @remark   data is desencrypted.

public function get_file_data(byref resourcepath as string, byref filename as string, byref data() as byte) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/21/2007
'retrieves a byte array with the specified file data
'*****************************************************************
    dim infohead as infoheader
    
    if get_infoheader(resourcepath, filename, infohead) then
        'extract!
        get_file_data = extract_file(resourcepath, infohead, data)
    else
        call msgbox("no se se encontro el recurso " & filename)
    end if
end function

''
' retrieves bitmap file data.
'
' @param    resourcepath the resource file folder.
' @param    filename the graphic file name.
' @param    bmpinfo the bitmap info structure.
' @param    data() the byte array to return data.
'
' @return   true if no error occurred.

public function get_bitmap(byref resourcepath as string, byref filename as string, byref bmpinfo as bitmapinfo, byref data() as byte) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 11/30/2007
'retrieves bitmap file data
'*****************************************************************
    dim infohead as infoheader
    dim rawdata() as byte
    dim offbits as long
    dim bitmapsize as long
    dim colorcount as long
    
    if get_infoheader(resourcepath, filename, infohead) then
        'extract the file and create the bitmap data from it.
        if extract_file(resourcepath, infohead, rawdata) then
            call copymemory(offbits, rawdata(10), 4)
            call copymemory(bmpinfo.bmiheader, rawdata(14), 40)
            
            with bmpinfo.bmiheader
                bitmapsize = alignscan(.biwidth, .bibitcount) * abs(.biheight)
                
                if .bibitcount < 24 or .bicompression = bi_bitfields or (.bicompression <> bi_rgb and .bibitcount = 32) then
                    if .biclrused < 1 then
                        colorcount = 2 ^ .bibitcount
                    else
                        colorcount = .biclrused
                    end if
                    
                    ' when using bitfields on 16 or 32 bits images, bmicolors has a 3-longs mask.
                    if .bibitcount >= 16 and .bicompression = bi_bitfields then colorcount = 3
                    
                    call copymemory(bmpinfo.bmicolors(0), rawdata(54), colorcount * 4)
                end if
            end with
            
            redim data(bitmapsize - 1) as byte
            call copymemory(data(0), rawdata(offbits), bitmapsize)
            
            get_bitmap = true
        end if
    else
        call msgbox("no se encontro el recurso " & filename)
    end if
end function

''
' compare two byte arrays to detect any difference.
'
' @param    data1() byte array.
' @param    data2() byte array.
'
' @return   true if are equals.

private function compare_datas(byref data1() as byte, byref data2() as byte) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 02/11/2007
'compare two byte arrays to detect any difference
'*****************************************************************
    dim length as long
    dim act as long
    
    length = ubound(data1) + 1
    
    if (ubound(data2) + 1) = length then
        while act < length
            if data1(act) xor data2(act) then exit function
            
            act = act + 1
        wend
        
        compare_datas = true
    end if
end function

''
' retrieves the next infoheader.
'
' @param    resourcefile a handler to the resource file.
' @param    filehead the reource file header.
' @param    infohead the returned header.
' @param    readfiles the number of headers that have already been read.
'
' @return   false if there are no more headers tu read.
'
' @remark   file must be already open.
' @remark   used to walk through the resource file info headers.
' @remark   the number of read files will increase although there is nothing else to read.
' @remark   infohead is encrypted.

private function readnext_infohead(byref resourcefile as integer, byref filehead as fileheader, byref infohead as infoheader, byref readfiles as long) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/24/2007
'reads the next infoheader
'*****************************************************************

    if readfiles < filehead.lngnumfiles then
        'read header
        get resourcefile, len(filehead) + len(infohead) * readfiles + 1, infohead
        
        'update
        readnext_infohead = true
    end if
    
    readfiles = readfiles + 1
end function

''
' retrieves the next bitmap.
'
' @param    resourcepath the resource file folder.
' @param    readfiles the number of bitmaps that have already been read.
' @param    bmpinfo the bitmap info structure.
' @param    data() the byte array to return data.
'
' @return   false if there are no more bitmaps tu get.
'
' @remark   used to walk through the resource file bitmaps.

public function getnext_bitmap(byref resourcepath as string, byref readfiles as long, byref bmpinfo as bitmapinfo, byref data() as byte, byref fileindex as long) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 12/02/2007
'reads the next infoheader
'*****************************************************************
on error resume next

    dim resourcefile as integer
    dim filehead as fileheader
    dim infohead as infoheader
    dim filename as string
    
    resourcefile = freefile
    open resourcepath & grh_resource_file for binary access read lock write as resourcefile
    get resourcefile, 1, filehead
    
#if seguridadalkon then
    call secure_file_header(filehead)
#end if
    
    if readnext_infohead(resourcefile, filehead, infohead, readfiles) then
#if seguridadalkon then
        call secure_info_header(infohead)
#end if
        
        call get_bitmap(resourcepath, infohead.strfilename, bmpinfo, data())
        filename = trim$(infohead.strfilename)
        fileindex = clng(left$(filename, len(filename) - 4))
        
        getnext_bitmap = true
    end if
    
    close resourcefile
end function

''
' compares two resource versions and makes a patch file.
'
' @param    newresourcepath the actual reource file folder.
' @param    oldresourcepath the previous reource file folder.
' @param    outputpath the patchs file folder.
' @param    prgbar the control that shows the process state.
'
' @return   true if no error occurred.

public function make_patch(byref newresourcepath as string, byref oldresourcepath as string, byref outputpath as string, byref prgbar as progressbar) as boolean
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/24/2007
'compares two resource versions and make a patch file
'*****************************************************************
    dim newresourcefile as integer
    dim newresourcefilepath as string
    dim newfilehead as fileheader
    dim newinfohead as infoheader
    dim newreadfiles as long
    dim newreadnext as boolean
    
    dim oldresourcefile as integer
    dim oldresourcefilepath as string
    dim oldfilehead as fileheader
    dim oldinfohead as infoheader
    dim oldreadfiles as long
    dim oldreadnext as boolean
    
    dim outputfile as integer
    dim outputfilepath as string
    dim data() as byte
    dim auxdata() as byte
    dim instruction as byte
    
'set up the error handler
'on local error goto errhandler

    newresourcefilepath = newresourcepath & grh_resource_file
    oldresourcefilepath = oldresourcepath & grh_resource_file
    outputfilepath = outputpath & grh_patch_file
    
    'open the old binary file
    oldresourcefile = freefile
    open oldresourcefilepath for binary access read lock write as oldresourcefile
        
        'get the old fileheader
        get oldresourcefile, 1, oldfilehead
        
#if seguridadalkon then
        call secure_file_header(oldfilehead)
#end if
        
        'check the file for validity
        if lof(oldresourcefile) <> oldfilehead.lngfilesize then
            call msgbox("archivo de recursos anterior da�ado. " & oldresourcefilepath, , "error")
            close oldresourcefile
            exit function
        end if
        
        'open the new binary file
        newresourcefile = freefile()
        open newresourcefilepath for binary access read lock write as newresourcefile
            
            'get the new fileheader
            get newresourcefile, 1, newfilehead
            
#if seguridadalkon then
            call secure_file_header(newfilehead)
#end if
            
            'check the file for validity
            if lof(newresourcefile) <> newfilehead.lngfilesize then
                call msgbox("archivo de recursos anterior da�ado. " & newresourcefilepath, , "error")
                close newresourcefile
                close oldresourcefile
                exit function
            end if
            
            'destroy file if it previuosly existed
            if dir(outputfilepath, vbnormal) <> "" then kill outputfilepath
            
            'open the patch file
            outputfile = freefile()
            open outputfilepath for binary access read write as outputfile
                
                if not prgbar is nothing then
                    prgbar.max = oldfilehead.lngnumfiles + newfilehead.lngnumfiles
                    prgbar.value = 0
                end if
                
                'put previous file version (unencrypted)
                put outputfile, , oldfilehead.lngfileversion
                
                'put the new file header
#if seguridadalkon then
                call secure_file_header(newfilehead)
#end if

                put outputfile, , newfilehead
                
#if seguridadalkon then
                call secure_file_header(newfilehead)
#end if
                
                'try to read old and new first files
                if readnext_infohead(oldresourcefile, oldfilehead, oldinfohead, oldreadfiles) _
                  and readnext_infohead(newresourcefile, newfilehead, newinfohead, newreadfiles) then
                    
                    'update
                    prgbar.value = prgbar.value + 2
                    
                    do 'main loop
                        'comparisons are between encrypted names, for ordering issues
                        if oldinfohead.strfilename = newinfohead.strfilename then
                        
#if seguridadalkon then
                            call secure_info_header(oldinfohead)
                            call secure_info_header(newinfohead)
#end if

                            'get old file data
                            call get_file_rawdata(oldresourcepath, oldinfohead, auxdata)
                            
                            'get new file data
                            call get_file_rawdata(newresourcepath, newinfohead, data)
                            
                            if not compare_datas(data, auxdata) then
                                'file was modified
                                instruction = patchinstruction.modify_file
                                put outputfile, , instruction
                                
                                'write header
#if seguridadalkon then
                                call secure_info_header(newinfohead)
#end if
                                put outputfile, , newinfohead
                                
                                'write data
                                put outputfile, , data
                            end if
                            
                            'read next oldresource
                            if not readnext_infohead(oldresourcefile, oldfilehead, oldinfohead, oldreadfiles) then
                                exit do
                            end if
                            
                            'read next newresource
                            if not readnext_infohead(newresourcefile, newfilehead, newinfohead, newreadfiles) then
                                'reread last oldinfohead
                                oldreadfiles = oldreadfiles - 1
                                exit do
                            end if
                            
                            'update
                            if not prgbar is nothing then prgbar.value = prgbar.value + 2
                        
                        elseif oldinfohead.strfilename < newinfohead.strfilename then
                            
                            'file was deleted
                            instruction = patchinstruction.delete_file
                            put outputfile, , instruction
                            put outputfile, , oldinfohead
                            
                            'read next oldresource
                            if not readnext_infohead(oldresourcefile, oldfilehead, oldinfohead, oldreadfiles) then
                                'reread last newinfohead
                                newreadfiles = newreadfiles - 1
                                exit do
                            end if
                            
                            'update
                            if not prgbar is nothing then prgbar.value = prgbar.value + 1
                        
                        else
                            
                            'new file
                            instruction = patchinstruction.create_file
                            put outputfile, , instruction
                            put outputfile, , newinfohead
                            
#if seguridadalkon then
                            call secure_info_header(newinfohead)
#end if
                            
                            'get file data
                            call get_file_rawdata(newresourcepath, newinfohead, data)
                            
                            'write data
                            put outputfile, , data
                            
                            'read next newresource
                            if not readnext_infohead(newresourcefile, newfilehead, newinfohead, newreadfiles) then
                                'reread last oldinfohead
                                oldreadfiles = oldreadfiles - 1
                                exit do
                            end if
                            
                            'update
                            if not prgbar is nothing then prgbar.value = prgbar.value + 1
                        end if
                        
                        doevents
                    loop
                
                else
                    'if at least one is empty
                    oldreadfiles = 0
                    newreadfiles = 0
                end if
                
                'read everything?
                while readnext_infohead(oldresourcefile, oldfilehead, oldinfohead, oldreadfiles)
                    'delete file
                    instruction = patchinstruction.delete_file
                    put outputfile, , instruction
                    put outputfile, , oldinfohead
                    
                    'update
                    if not prgbar is nothing then prgbar.value = prgbar.value + 1
                    doevents
                wend
                
                'read everything?
                while readnext_infohead(newresourcefile, newfilehead, newinfohead, newreadfiles)
                    'create file
                    instruction = patchinstruction.create_file
                    put outputfile, , instruction
                    put outputfile, , newinfohead
                    
                    'get file data
#if seguridadalkon then
                    call secure_info_header(newinfohead)
#end if
                    call get_file_rawdata(newresourcepath, newinfohead, data)
                    'write data
                    put outputfile, , data
                    
                    'update
                    if not prgbar is nothing then prgbar.value = prgbar.value + 1
                    doevents
                wend
            
            'close the patch file
            close outputfile
        
        'close the new binary file
        close newresourcefile
    
    'close the old binary file
    close oldresourcefile
    
    make_patch = true
exit function

errhandler:
    close outputfile
    close newresourcefile
    close oldresourcefile
    
    call msgbox("no se pudo terminar de crear el parche. razon: " & err.number & " : " & err.description, vbokonly, "error")
end function

''
' follows patches instructions to update a resource file.
'
' @param    resourcepath the reource file folder.
' @param    patchpath the patch file folder.
' @param    prgbar the control that shows the process state.
'
' @return   true if no error occurred.
#if seguridadalkon then
public function apply_patch(byref resourcepath as string, byref patchpath as string, byval checksum as string, byref prgbar as progressbar) as boolean
#else
public function apply_patch(byref resourcepath as string, byref patchpath as string, byref prgbar as progressbar) as boolean
#end if
'*****************************************************************
'author: nicolas matias gonzalez (nigo)
'last modify date: 08/24/2007
'follows patches instructions to update a resource file
'*****************************************************************
    dim resourcefile as integer
    dim resourcefilepath as string
    dim filehead as fileheader
    dim infohead as infoheader
    dim resourcereadfiles as long
    dim eoresource as boolean

    dim patchfile as integer
    dim patchfilepath as string
    dim patchfilehead as fileheader
    dim patchinfohead as infoheader
    dim instruction as byte
    dim oldresourceversion as long

    dim outputfile as integer
    dim outputfilepath as string
    dim data() as byte
    dim writtenfiles as long
    dim dataoutputpos as long

on local error goto errhandler

    resourcefilepath = resourcepath & grh_resource_file
    patchfilepath = patchpath & grh_patch_file
    outputfilepath = resourcepath & grh_resource_file & "tmp"
    
    'open the old binary file
    resourcefile = freefile()
    open resourcefilepath for binary access read lock write as resourcefile
        
        'read the old fileheader
        get resourcefile, , filehead
#if seguridadalkon then
        call secure_file_header(filehead)
#end if
        
        'check the file for validity
        if lof(resourcefile) <> filehead.lngfilesize then
            call msgbox("archivo de recursos anterior da�ado. " & resourcefilepath, , "error")
            close resourcefile
            exit function
        end if
        
        'open the patch file
        patchfile = freefile()
        open patchfilepath for binary access read lock write as patchfile
            
            'get previous file version
            get patchfile, , oldresourceversion
            
            'check the file version
            if oldresourceversion <> filehead.lngfileversion then
                call msgbox("incongruencia en versiones.", , "error")
                close resourcefile
                close patchfile
                exit function
            end if
            
            'read the new fileheader
            get patchfile, , patchfilehead
            
            'destroy file if it previuosly existed
            if fileexist(outputfilepath, vbnormal) then call kill(outputfilepath)
            
            'open the patch file
            outputfile = freefile()
            open outputfilepath for binary access read write as outputfile
                
                'save the file header
                put outputfile, , patchfilehead
#if seguridadalkon then
                call secure_file_header(patchfilehead)
#end if
                
                if not prgbar is nothing then
                    prgbar.max = patchfilehead.lngnumfiles
                    prgbar.value = 0
                end if
                
                'update
                dataoutputpos = len(filehead) + len(infohead) * patchfilehead.lngnumfiles + 1
                
                'process loop
                while loc(patchfile) < lof(patchfile)
                    
                    'get the instruction
                    get patchfile, , instruction
                    'get the infohead
                    get patchfile, , patchinfohead
                    
                    do
                        eoresource = not readnext_infohead(resourcefile, filehead, infohead, resourcereadfiles)
                        
                        'comparison is performed among encrypted names for ordering issues
                        if not eoresource and infohead.strfilename < patchinfohead.strfilename then
                            
#if seguridadalkon then
                            call secure_info_header(infohead)
#end if

                            'getdata and update infohead
                            call get_file_rawdata(resourcepath, infohead, data)
                            infohead.lngfilestart = dataoutputpos
                            
#if seguridadalkon then
                            call secure_info_header(infohead)
#end if
                            
                            'save file!
                            put outputfile, len(filehead) + len(infohead) * writtenfiles + 1, infohead
                            put outputfile, dataoutputpos, data
                            
                            'update
                            dataoutputpos = dataoutputpos + ubound(data) + 1
                            writtenfiles = writtenfiles + 1
                            if not prgbar is nothing then prgbar.value = writtenfiles
                        else
                            exit do
                        end if
                    loop
                    
                    select case instruction
                        'delete
                        case patchinstruction.delete_file
                            if infohead.strfilename <> patchinfohead.strfilename then
                                err.description = "incongruencia en archivos de recurso"
                                goto errhandler
                            end if
                        
                        'create
                        case patchinstruction.create_file
                            if (infohead.strfilename > patchinfohead.strfilename) or eoresource then
                                
#if seguridadalkon then
                                call secure_info_header(patchinfohead)
#end if

                                'get file data
                                redim data(patchinfohead.lngfilesize - 1)
                                get patchfile, , data
                                
#if seguridadalkon then
                                call secure_info_header(patchinfohead)
#end if
                                
                                'save it
                                put outputfile, len(filehead) + len(infohead) * writtenfiles + 1, patchinfohead
                                put outputfile, dataoutputpos, data
                                
                                'reanalize last resource infohead
                                eoresource = false
                                resourcereadfiles = resourcereadfiles - 1
                                
                                'update
                                dataoutputpos = dataoutputpos + ubound(data) + 1
                                writtenfiles = writtenfiles + 1
                                if not prgbar is nothing then prgbar.value = writtenfiles
                            else
                                err.description = "incongruencia en archivos de recurso"
                                goto errhandler
                            end if
                        
                        'modify
                        case patchinstruction.modify_file
                            if infohead.strfilename = patchinfohead.strfilename then
                            
#if seguridadalkon then
                                call secure_info_header(patchinfohead)
#end if

                                'get file data
                                redim data(patchinfohead.lngfilesize - 1)
                                get patchfile, , data
                                
#if seguridadalkon then
                                call secure_info_header(patchinfohead)
#end if
                                
                                'save it
                                put outputfile, len(filehead) + len(infohead) * writtenfiles + 1, patchinfohead
                                put outputfile, dataoutputpos, data
                                
                                'update
                                dataoutputpos = dataoutputpos + ubound(data) + 1
                                writtenfiles = writtenfiles + 1
                                if not prgbar is nothing then prgbar.value = writtenfiles
                            else
                                err.description = "incongruencia en archivos de recurso"
                                goto errhandler
                            end if
                    end select
                    
                    doevents
                wend
                
                'read everything?
                while readnext_infohead(resourcefile, filehead, infohead, resourcereadfiles)
#if seguridadalkon then
                    call secure_info_header(infohead)
#end if
                    'getdata and update infoheader
                    call get_file_rawdata(resourcepath, infohead, data)
                    infohead.lngfilestart = dataoutputpos
                    
#if seguridadalkon then
                    call secure_info_header(infohead)
#end if
                    
                    'save file!
                    put outputfile, len(filehead) + len(infohead) * writtenfiles + 1, infohead
                    put outputfile, dataoutputpos, data
                    
                    'update
                    dataoutputpos = dataoutputpos + ubound(data) + 1
                    writtenfiles = writtenfiles + 1
                    if not prgbar is nothing then prgbar.value = writtenfiles
                    doevents
                wend
            
            'close the patch file
            close outputfile
        
        'close the new binary file
        close patchfile
    
    'close the old binary file
    close resourcefile
    
    'check integrity
    if (patchfilehead.lngnumfiles = writtenfiles) then
#if seguridadalkon then
        dim md5 as new clsmd5
        md5.md5reset
        debug.print md5.getmd5file(outputfilepath)
        md5.md5reset
        if md5.getmd5file(outputfilepath) = checksum then
#end if
            'replace file
            call kill(resourcefilepath)
            name outputfilepath as resourcefilepath
#if seguridadalkon then
        else
            err.description = "checksum incorrecto"
            goto errhandler
        end if
#end if
    else
        err.description = "falla al procesar parche"
        goto errhandler
    end if
    
    apply_patch = true
exit function

errhandler:
    close outputfile
    close patchfile
    close resourcefile
    'destroy file if created
    if fileexist(outputfilepath, vbnormal) then call kill(outputfilepath)
    
    call msgbox("no se pudo parchear. razon: " & err.number & " : " & err.description, vbokonly, "error")
end function

private function alignscan(byval inwidth as long, byval indepth as integer) as long
'*****************************************************************
'author: unknown
'last modify date: unknown
'*****************************************************************
    alignscan = (((inwidth * indepth) + &h1f) and not &h1f&) \ &h8
end function

''
' retrieves the version number of a given resource file.
'
' @param    resourcefilepath the resource file complete path.
'
' @return   the version number of the given file.

public function getversion(byval resourcefilepath as string) as long
'*****************************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 11/23/2008
'
'*****************************************************************
    dim resourcefile as integer
    dim filehead as fileheader
    
    resourcefile = freefile()
    open resourcefilepath for binary access read lock write as resourcefile
        'extract the fileheader
        get resourcefile, 1, filehead
        
#if seguridadalkon then
        call secure_file_header(filehead)
#end if
    close resourcefile
    
    getversion = filehead.lngfileversion
end function
