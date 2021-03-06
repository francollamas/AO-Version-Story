attribute vb_name = "modscreencapture"
option explicit

' ==================================================================================
' author:      steve mcmahon
' date:        15 march 1999
' requires:    cdibsection.cls
'              ijl11.dll (intel)
'
' an interface to intel's ijl (intel jpg library) for use in vb.
'
' modifications
'  author: alejandro salvo
'  date: 5 february 2007
'  description: added screencapture method and removed usless things.
'
'  author: juan mart�n sotuyo dodero (maraxus)
'  date: 28 febraury 2007
'  description: changed screencapture to use the screenshots directory.
'               fixed a bug that caused the dc not to be allways released (added invalid_handle constant)
'
'  author: torres patricio (pato)
'  date: 25 august 2009
'  description: added fullscreencapture function.
'
'
' copyright.
' ijl.dll is a copyright � intel, which is a registered trade mark of the intel
' corporation.
'
'
' note.
' intel are not responsible for any errors in this code and should not be
' mentioned in any help, about or support in any product using the intel library.
'
'
'
' ==================================================================================

' ijl declares:

private enum ijlerr
  '// the following "error" values indicate an "ok" condition.
  ijl_ok = 0
  ijl_interrupt_ok = 1
  ijl_roi_ok = 2

  '// the following "error" values indicate an error has occurred.
  ijl_exception_detected = -1
  ijl_invalid_encoder = -2
  ijl_unsupported_subsampling = -3
  ijl_unsupported_bytes_per_pixel = -4
  ijl_memory_error = -5
  ijl_bad_huffman_table = -6
  ijl_bad_quant_table = -7
  ijl_invalid_jpeg_properties = -8
  ijl_err_fileclose = -9
  ijl_invalid_filename = -10
  ijl_error_eof = -11
  ijl_prog_not_supported = -12
  ijl_err_not_jpeg = -13
  ijl_err_comp = -14
  ijl_err_sof = -15
  ijl_err_dnl = -16
  ijl_err_no_huf = -17
  ijl_err_no_quan = -18
  ijl_err_no_frame = -19
  ijl_err_mult_frame = -20
  ijl_err_data = -21
  ijl_err_no_image = -22
  ijl_file_error = -23
  ijl_internal_error = -24
  ijl_bad_rst_marker = -25
  ijl_thumbnail_dib_too_small = -26
  ijl_thumbnail_dib_wrong_color = -27
  ijl_reserved = -99

end enum

private enum ijliotype
  ijl_setup = -1&
  ''// read jpeg parameters (i.e., height, width, channels,
  ''// sampling, etc.) from a jpeg bit stream.
  ijl_jfile_readparams = 0&
  ijl_jbuff_readparams = 1&
  ''// read a jpeg interchange format image.
  ijl_jfile_readwholeimage = 2&
  ijl_jbuff_readwholeimage = 3&
  ''// read jpeg tables from a jpeg abbreviated format bit stream.
  ijl_jfile_readheader = 4&
  ijl_jbuff_readheader = 5&
  ''// read image info from a jpeg abbreviated format bit stream.
  ijl_jfile_readentropy = 6&
  ijl_jbuff_readentropy = 7&
  ''// write an entire jfif bit stream.
  ijl_jfile_writewholeimage = 8&
  ijl_jbuff_writewholeimage = 9&
  ''// write a jpeg abbreviated format bit stream.
  ijl_jfile_writeheader = 10&
  ijl_jbuff_writeheader = 11&
  ''// write image info to a jpeg abbreviated format bit stream.
  ijl_jfile_writeentropy = 12&
  ijl_jbuff_writeentropy = 13&
  ''// scaled decoding options:
  ''// reads a jpeg image scaled to 1/2 size.
  ijl_jfile_readonehalf = 14&
  ijl_jbuff_readonehalf = 15&
  ''// reads a jpeg image scaled to 1/4 size.
  ijl_jfile_readonequarter = 16&
  ijl_jbuff_readonequarter = 17&
  ''// reads a jpeg image scaled to 1/8 size.
  ijl_jfile_readoneeighth = 18&
  ijl_jbuff_readoneeighth = 19&
  ''// reads an embedded thumbnail from a jfif bit stream.
  ijl_jfile_readthumbnail = 20&
  ijl_jbuff_readthumbnail = 21&

end enum

private type jpeg_core_properties_vb ' sadly, due to a limitation in vb (udt variable count)
                                     ' we can't encode the full jpeg_core_properties structure
  usejpegproperties as long                      '// default = 0

  '// dib specific i/o data specifiers.
  dibbytes as long ';                  '// default = null 4
  dibwidth as long ';                  '// default = 0 8
  dibheight as long ';                 '// default = 0 12
  dibpadbytes as long ';               '// default = 0 16
  dibchannels as long ';               '// default = 3 20
  dibcolor as long ';                  '// default = ijl_bgr 24
  dibsubsampling as long  ';            '// default = ijl_none 28

  '// jpeg specific i/o data specifiers.
  jpgfile as long 'lptstr              jpgfile;                32   '// default = null
  jpgbytes as long ';                  '// default = null 36
  jpgsizebytes as long ';              '// default = 0 40
  jpgwidth as long ';                  '// default = 0 44
  jpgheight as long ';                 '// default = 0 48
  jpgchannels as long ';               '// default = 3
  jpgcolor as long           ';                  '// default = ijl_ycbcr
  jpgsubsampling as long  ';            '// default = ijl_411
  jpgthumbwidth as long ' ;             '// default = 0
  jpgthumbheight as long ';            '// default = 0

  '// jpeg conversion properties.
  cconversion_reqd as long ';          '// default = true
  upsampling_reqd as long ';           '// default = true
  jquality as long ';                  '// default = 75.  100 is my preferred quality setting.

  '// low-level properties - 20,000 bytes.  if the whole structure
  ' is written out then vb fails with an obscure error message
  ' "too many local variables" !
  '
  ' these all default if they are not otherwise specified so there
  ' is no trouble to just assign a sufficient buffer in memory:
  jprops(0 to 19999) as byte

end type

'
private declare function getdc lib "user32" (byval hwnd as long) as long
private declare function releasedc lib "user32" (byval hwnd as long, byval hdc as long) as long
private declare sub copymemory lib "kernel32" alias "rtlmovememory" (byref dest as any, byref source as any, byval bytecount as long)

'

private declare function ijlinit lib "ijl11.dll" (jcprops as any) as long
private declare function ijlfree lib "ijl11.dll" (jcprops as any) as long
private declare function ijlread lib "ijl11.dll" (jcprops as any, byval iotype as long) as long
private declare function ijlwrite lib "ijl11.dll" (jcprops as any, byval iotype as long) as long

' stuff for replacing a file when you have to kill the original:
private const max_path = 260
private type filetime
   dwlowdatetime as long
   dwhighdatetime as long
end type
private type win32_find_data
   dwfileattributes as long
   ftcreationtime as filetime
   ftlastaccesstime as filetime
   ftlastwritetime as filetime
   nfilesizehigh as long
   nfilesizelow as long
   dwreserved0 as long
   dwreserved1 as long
   cfilename as string * max_path
   calternate as string * 14
end type
private declare function findfirstfile lib "kernel32" alias "findfirstfilea" (byval lpfilename as string, lpfindfiledata as win32_find_data) as long
private declare function lopen lib "kernel32" alias "_lopen" (byval lppathname as string, byval ireadwrite as long) as long
private declare function lclose lib "kernel32" alias "_lclose" (byval hfile as long) as long
private declare function setfiletime lib "kernel32" (byval hfile as long, lpcreationtime as filetime, lplastaccesstime as filetime, lplastwritetime as filetime) as long
private declare function setfileattributes lib "kernel32" alias "setfileattributesa" (byval lpfilename as string, byval dwfileattributes as long) as long
private const of_write = &h1
private const of_share_deny_write = &h20

private const invalid_handle as long = -1

'bltbit constant
private const srccopy = &hcc0020 ' (dword) dest = source

'good old bitblt
private declare function bitblt lib "gdi32" (byval hdestdc as long, byval x as long, byval y as long, byval nwidth as long, byval nheight as long, byval hsrcdc as long, byval xsrc as long, byval ysrc as long, byval dwrop as long) as long

public function loadjpg( _
      byref cdib as cdibsection, _
      byval sfile as string _
   ) as boolean
dim tj as jpeg_core_properties_vb
dim bfile() as byte
dim lr as long
dim lptr as long
dim ljpgwidth as long, ljpgheight as long

   lr = ijlinit(tj)
   if lr = ijl_ok then
      
      ' write the filename to the jcprops.jpgfile member:
      bfile = strconv(sfile, vbfromunicode)
      redim preserve bfile(0 to ubound(bfile) + 1) as byte
      bfile(ubound(bfile)) = 0
      lptr = varptr(bfile(0))
      copymemory tj.jpgfile, lptr, 4
      
      ' read the jpeg file parameters:
      lr = ijlread(tj, ijl_jfile_readparams)
      if lr <> ijl_ok then
         ' throw error
         msgbox "failed to read jpg", vbexclamation
      else
        ' set jpg color
         if tj.jpgchannels = 1 then
            tj.jpgcolor = 4& ' ijl_g
         else
            tj.jpgcolor = 3& ' ijl_ycbcr
         end if
            
         ' get the jpgwidth ...
         ljpgwidth = tj.jpgwidth
         ' .. & jpgheight member values:
         ljpgheight = tj.jpgheight
      
         ' create a buffer of sufficient size to hold the image:
         if cdib.create(ljpgwidth, ljpgheight) then
            ' store dibwidth:
            tj.dibwidth = ljpgwidth
            ' very important: tell ijl how many bytes extra there
            ' are on each dib scan line to pad to 32 bit boundaries:
            tj.dibpadbytes = cdib.bytesperscanline - ljpgwidth * 3
            ' store dibheight:
            tj.dibheight = -ljpgheight
            ' store channels:
            tj.dibchannels = 3&
            ' store dibbytes (pointer to uncompressed jpg data):
            tj.dibbytes = cdib.dibsectionbitsptr
            
            ' now decompress the jpg into the dibsection:
            lr = ijlread(tj, ijl_jfile_readwholeimage)
            if lr = ijl_ok then
               ' that's it!  cdib now contains the uncompressed jpg.
               loadjpg = true
            else
               ' throw error:
               msgbox "cannot read image data from file.", vbexclamation
            end if
         else
            ' failed to create the dib...
         end if
      end if
                        
      ' ensure we have freed memory:
      ijlfree tj
   else
      ' throw error:
      msgbox "failed to initialise the ijl library: " & lr, vbexclamation
   end if
   
   
end function
public function loadjpgfromptr( _
      byref cdib as cdibsection, _
      byval lptr as long, _
      byval lsize as long _
   ) as boolean
dim tj as jpeg_core_properties_vb
dim lr as long
dim ljpgwidth as long, ljpgheight as long

   lr = ijlinit(tj)
   if lr = ijl_ok then
            
      ' set jpeg buffer
      tj.jpgbytes = lptr
      tj.jpgsizebytes = lsize
            
      ' read the jpeg parameters:
      lr = ijlread(tj, ijl_jbuff_readparams)
      if lr <> ijl_ok then
         ' throw error
         msgbox "failed to read jpg", vbexclamation
      else
        ' set jpg color
         if tj.jpgchannels = 1 then
            tj.jpgcolor = 4& ' ijl_g
         else
            tj.jpgcolor = 3& ' ijl_ycbcr
         end if
      
         ' get the jpgwidth ...
         ljpgwidth = tj.jpgwidth
         ' .. & jpgheight member values:
         ljpgheight = tj.jpgheight
      
         ' create a buffer of sufficient size to hold the image:
         if cdib.create(ljpgwidth, ljpgheight) then
            ' store dibwidth:
            tj.dibwidth = ljpgwidth
            ' very important: tell ijl how many bytes extra there
            ' are on each dib scan line to pad to 32 bit boundaries:
            tj.dibpadbytes = cdib.bytesperscanline - ljpgwidth * 3
            ' store dibheight:
            tj.dibheight = -ljpgheight
            ' store channels:
            tj.dibchannels = 3&
            ' store dibbytes (pointer to uncompressed jpg data):
            tj.dibbytes = cdib.dibsectionbitsptr
            
            ' now decompress the jpg into the dibsection:
            lr = ijlread(tj, ijl_jbuff_readwholeimage)
            if lr = ijl_ok then
               ' that's it!  cdib now contains the uncompressed jpg.
               loadjpgfromptr = true
            else
               ' throw error:
               msgbox "cannot read image data from file.", vbexclamation
            end if
         else
            ' failed to create the dib...
         end if
      end if
                        
      ' ensure we have freed memory:
      ijlfree tj
   else
      ' throw error:
      msgbox "failed to initialise the ijl library: " & lr, vbexclamation
   end if
   
end function

public function savejpg( _
      byref cdib as cdibsection, _
      byval sfile as string, _
      optional byval lquality as long = 90 _
   ) as boolean
dim tj as jpeg_core_properties_vb
dim bfile() as byte
dim lptr as long
dim lr as long
dim tfnd as win32_find_data
dim hfile as long
dim bfileexisted as boolean
dim lfilesize as long
   
   hfile = -1
   
   lr = ijlinit(tj)
   if lr = ijl_ok then
      
      ' check if we're attempting to overwrite an existing file.
      ' if so hfile <> invalid_file_handle:
      bfileexisted = (findfirstfile(sfile, tfnd) <> -1)
      if bfileexisted then
         kill sfile
      end if
      
      ' set up the dib information:
      ' store dibwidth:
      tj.dibwidth = cdib.width
      ' store dibheight:
      tj.dibheight = -cdib.height
      ' store dibbytes (pointer to uncompressed jpg data):
      tj.dibbytes = cdib.dibsectionbitsptr
      ' very important: tell ijl how many bytes extra there
      ' are on each dib scan line to pad to 32 bit boundaries:
      tj.dibpadbytes = cdib.bytesperscanline - cdib.width * 3
      
      ' set up the jpeg information:
      
      ' store jpgfile:
      bfile = strconv(sfile, vbfromunicode)
      redim preserve bfile(0 to ubound(bfile) + 1) as byte
      bfile(ubound(bfile)) = 0
      lptr = varptr(bfile(0))
      copymemory tj.jpgfile, lptr, 4
      ' store jpgwidth:
      tj.jpgwidth = cdib.width
      ' .. & jpgheight member values:
      tj.jpgheight = cdib.height
      ' set the quality/compression to save:
      tj.jquality = lquality
            
      ' write the image:
      lr = ijlwrite(tj, ijl_jfile_writewholeimage)
      
      ' check for success:
      if lr = ijl_ok then
      
         ' now if we are replacing an existing file, then we want to
         ' put the file creation and archive information back again:
         if bfileexisted then
            
            hfile = lopen(sfile, of_write or of_share_deny_write)
            if hfile = 0 then
               ' problem
            else
               setfiletime hfile, tfnd.ftcreationtime, tfnd.ftlastaccesstime, tfnd.ftlastwritetime
               lclose hfile
               setfileattributes sfile, tfnd.dwfileattributes
            end if
            
         end if
         
         lfilesize = tj.jpgsizebytes - tj.jpgbytes
         
         ' success:
         savejpg = true
         
      else
         ' throw error
         err.raise 26001, "no se pudo guarrdar el jpg" & lr, vbexclamation
      end if
      
      ' ensure we have freed memory:
      ijlfree tj
   else
      ' throw error:
      err.raise 26001, app.exename & ".minteljpeglibrary", "no se pudo inicializar la libreria " & lr
   end if
   

end function

public function savejpgtoptr( _
      byref cdib as cdibsection, _
      byval lptr as long, _
      byref lbufsize as long, _
      optional byval lquality as long = 90 _
   ) as boolean
dim tj as jpeg_core_properties_vb
dim lr as long
dim hfile as long
   
   hfile = -1
   
   lr = ijlinit(tj)
   if lr = ijl_ok then
      
      ' set up the dib information:
      ' store dibwidth:
      tj.dibwidth = cdib.width
      ' store dibheight:
      tj.dibheight = -cdib.height
      ' store dibbytes (pointer to uncompressed jpg data):
      tj.dibbytes = cdib.dibsectionbitsptr
      ' very important: tell ijl how many bytes extra there
      ' are on each dib scan line to pad to 32 bit boundaries:
      tj.dibpadbytes = cdib.bytesperscanline - cdib.width * 3
      
      ' set up the jpeg information:
      ' store jpgwidth:
      tj.jpgwidth = cdib.width
      ' .. & jpgheight member values:
      tj.jpgheight = cdib.height
      ' set the quality/compression to save:
      tj.jquality = lquality
      ' set jpeg buffer
      tj.jpgbytes = lptr
      tj.jpgsizebytes = lbufsize
            
      ' write the image:
      lr = ijlwrite(tj, ijl_jbuff_writewholeimage)
            
      ' check for success:
      if lr = ijl_ok then
         
         lbufsize = tj.jpgsizebytes
         
         ' success:
         savejpgtoptr = true
         
      else
         ' throw error
         err.raise 26001, app.exename & ".minteljpeglibrary", "failed to save to jpg " & lr, vbexclamation
      end if
      
      ' ensure we have freed memory:
      ijlfree tj
   else
      ' throw error:
      err.raise 26001, app.exename & ".minteljpeglibrary", "failed to initialise the ijl library: " & lr
   end if
   

end function

public sub screencapture(optional byval autofragshooter as boolean = false)
'**************************************************************
'author: unknown
'last modify date: 11/16/2006
'11/16/2010: amraphen - now the fragshooter screenshots are stored in different directories.
'**************************************************************
on error goto err:
    dim hwnd as long
    dim file as string
    dim si as string
    dim c as cdibsection
    set c = new cdibsection
    dim i as long
    dim hdcc as long
    
    dim dirfile as string
    
    hdcc = getdc(frmmain.hwnd)
    
    frmscreenshots.picture1.autoredraw = true
    frmscreenshots.picture1.width = 12090
    frmscreenshots.picture1.height = 9075

    call bitblt(frmscreenshots.picture1.hdc, 0, 0, 800, 600, hdcc, 0, 0, srccopy)
    call releasedc(frmmain.hwnd, hdcc)
    
    hdcc = invalid_handle
    
    ' primero chequea si existe la carpeta screenshots
    dirfile = app.path & "\screenshots"
    if not fileexist(dirfile, vbdirectory) then call mkdir(dirfile)
    
    ' si es una imagen de autofragshooter, se fija si existe la carpeta.
    if autofragshooter then
        dirfile = dirfile & "\fragshooter"
        if not fileexist(dirfile, vbdirectory) then call mkdir(dirfile)
        
        'nuevos directorios del fragshooter:
        if fragshooterkilledsomeone then 'si mat� a alguien.
            dirfile = dirfile & "\frags"
        else 'si nos mat� alguien.
            dirfile = dirfile & "\muertes"
        end if
        if not fileexist(dirfile, vbdirectory) then call mkdir(dirfile)
        
        'nuevo formato de las screenshots del fragshooter: "victima/asesino(dd-mm-yyyy hh-mm-ss).jpg"
        file = dirfile & "\" & fragshooternickname & "(" & format(now, "dd-mm-yyyy hh-mm-ss") & ").jpg"
    else
        'si no es screenshot del fragshooter, entonces se usa el formato "dd-mm-yyyy hh-mm-ss.jpg"
        file = dirfile & "\" & format(now, "dd-mm-yyyy hh-mm-ss") & ".jpg"
    end if
    
    frmscreenshots.picture1.refresh
    frmscreenshots.picture1.picture = frmscreenshots.picture1.image
    
    c.createfrompicture frmscreenshots.picture1.picture
    
    savejpg c, file
    
    addtorichtextbox frmmain.rectxt, "screen capturada!", 200, 200, 200, false, false, true
exit sub

err:
    call addtorichtextbox(frmmain.rectxt, err.number & "-" & err.description, 200, 200, 200, false, false, true)
    
    if hdcc <> invalid_handle then _
        call releasedc(frmmain.hwnd, hdcc)
end sub

public function fullscreencapture(byval file as string) as boolean
'medio desprolijo donde pongo la pic, pero es lo que hay por ahora
    dim c as cdibsection
    set c = new cdibsection
    dim hdcc as long
    dim handle as long
    
    hdcc = getdc(handle)
    
    frmscreenshots.picture1.autoredraw = true
    
    if nores then
        frmscreenshots.picture1.width = screen.width
        frmscreenshots.picture1.height = screen.height
        
        call bitblt(frmscreenshots.picture1.hdc, 0, 0, screen.width / screen.twipsperpixelx, screen.height / screen.twipsperpixely, hdcc, 0, 0, srccopy)
    else
        frmscreenshots.picture1.width = 12000
        frmscreenshots.picture1.height = 9000
        
        call bitblt(frmscreenshots.picture1.hdc, 0, 0, 800, 600, hdcc, 0, 0, srccopy)
    end if
    
    call releasedc(handle, hdcc)
    
    hdcc = invalid_handle
    
    if not fileexist(app.path & "\temp", vbdirectory) then mkdir (app.path & "\temp")
    
    frmscreenshots.picture1.refresh
    frmscreenshots.picture1.picture = frmscreenshots.picture1.image
    
    c.createfrompicture frmscreenshots.picture1.picture
    
    savejpg c, file
    
    fullscreencapture = true
end function
