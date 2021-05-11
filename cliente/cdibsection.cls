version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "cdibsection"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
option explicit

private declare sub copymemory lib "kernel32" alias "rtlmovememory" ( _
    lpvdest as any, lpvsource as any, byval cbcopy as long)

private type safearraybound
    celements as long
    llbound as long
end type
private type safearray2d
    cdims as integer
    ffeatures as integer
    cbelements as long
    clocks as long
    pvdata as long
    bounds(0 to 1) as safearraybound
end type
private declare function varptrarray lib "msvbvm50.dll" alias "varptr" (ptr() as any) as long

private type rgbquad
    rgbblue as byte
    rgbgreen as byte
    rgbred as byte
    rgbreserved as byte
end type
private type bitmapinfoheader '40 bytes
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
private type bitmapinfo
    bmiheader as bitmapinfoheader
    bmicolors as rgbquad
end type
private declare function createcompatibledc lib "gdi32" (byval hdc as long) as long
private declare function getdc lib "user32" (byval hwnd as long) as long
private declare function getdesktopwindow lib "user32" () as long
' note - this is not the declare in the api viewer - modify lplpvoid to be
' byref so we get the pointer back:
private declare function createdibsection lib "gdi32" _
    (byval hdc as long, _
    pbitmapinfo as bitmapinfo, _
    byval un as long, _
    lplpvoid as long, _
    byval handle as long, _
    byval dw as long) as long
private declare function bitblt lib "gdi32" (byval hdestdc as long, byval x as long, byval y as long, byval nwidth as long, byval nheight as long, byval hsrcdc as long, byval xsrc as long, byval ysrc as long, byval dwrop as long) as long
private declare function selectobject lib "gdi32" (byval hdc as long, byval hobject as long) as long
private declare function deleteobject lib "gdi32" (byval hobject as long) as long
private declare function deletedc lib "gdi32" (byval hdc as long) as long
private declare function releasedc lib "user32" (byval hwnd as long, byval hdc as long) as long
private declare function loadimage lib "user32" alias "loadimagea" (byval hinst as long, byval lpsz as string, byval un1 as long, byval n1 as long, byval n2 as long, byval un2 as long) as long
private const bi_rgb = 0&
private const bi_rle4 = 2&
private const bi_rle8 = 1&
private const dib_rgb_colors = 0 '  color table in rgbs

private type bitmap
    bmtype as long
    bmwidth as long
    bmheight as long
    bmwidthbytes as long
    bmplanes as integer
    bmbitspixel as integer
    bmbits as long
end type
private declare function getobjectapi lib "gdi32" alias "getobjecta" (byval hobject as long, byval ncount as long, lpobject as any) as long
private declare function timegettime lib "winmm.dll" () as long
private declare function createcompatiblebitmap lib "gdi32" (byval hdc as long, byval nwidth as long, byval nheight as long) as long

' clipboard functions:
private declare function openclipboard lib "user32" (byval hwnd as long) as long
private declare function closeclipboard lib "user32" () as long
private declare function setclipboarddata lib "user32" (byval wformat as long, byval hmem as long) as long
private declare function emptyclipboard lib "user32" () as long
private const cf_bitmap = 2
private const cf_dib = 8

' handle to the current dibsection:
private m_hdib as long
' handle to the old bitmap in the dc, for clear up:
private m_hbmpold as long
' handle to the device context holding the dibsection:
private m_hdc as long
' address of memory pointing to the dibsection's bits:
private m_lptr as long
' type containing the bitmap information:
private m_tbi as bitmapinfo

public function copytoclipboard( _
        optional byval basdib as boolean = true _
    ) as boolean
dim lhdcdesktop as long
dim lhdc as long
dim lhbmpold as long
dim hobj as long
dim lfmt as long
dim b() as byte
dim tbi as bitmapinfo
dim lptr as long
dim hdibcopy as long

    lhdcdesktop = getdc(getdesktopwindow())
    if (lhdcdesktop <> 0) then
        lhdc = createcompatibledc(lhdcdesktop)
        if (lhdc <> 0) then
            if (basdib) then
               msgbox "i don't know how to put a dib on the clipboard! copy as bitmap instead!!!"
                ' create a duplicate dibsection and copy
                ' to the clipboard:
                'lset tbi = m_tbi
                'hdibcopy = createdibsection( _
                '        lhdc, _
                '        m_tbi, _
                '        dib_rgb_colors, _
                '        lptr, _
                '        0, 0)
                'if (hdibcopy <> 0) then
                '    lhbmpold = selectobject(lhdc, hobj)
                '    bitblt lhdc, 0, 0, width, height, m_hdc, 0, 0, vbsrccopy
                '    selectobject lhdc, lhbmpold
                '    lfmt = cf_dib
                '
                '     '....
                                    
                'else
                '    hobj = 0
                'end if
            else
                ' create a compatible bitmap and copy to
                ' the clipboard:
                hobj = createcompatiblebitmap(lhdcdesktop, width, height)
                if (hobj <> 0) then
                    lhbmpold = selectobject(lhdc, hobj)
                    paintpicture lhdc
                    selectobject lhdc, lhbmpold
                    lfmt = cf_bitmap
                    ' now set the clipboard to the bitmap:
                    if (openclipboard(0) <> 0) then
                        emptyclipboard
                        if (setclipboarddata(lfmt, hobj) <> 0) then
                            copytoclipboard = true
                        end if
                        closeclipboard
                    end if
                end if
            end if
            deletedc lhdc
        end if
        deletedc lhdcdesktop
    end if
end function

public function createdib( _
        byval lhdc as long, _
        byval lwidth as long, _
        byval lheight as long, _
        byref hdib as long _
    ) as boolean
    with m_tbi.bmiheader
        .bisize = len(m_tbi.bmiheader)
        .biwidth = lwidth
        .biheight = lheight
        .biplanes = 1
        .bibitcount = 24
        .bicompression = bi_rgb
        .bisizeimage = bytesperscanline * .biheight
    end with
    hdib = createdibsection( _
            lhdc, _
            m_tbi, _
            dib_rgb_colors, _
            m_lptr, _
            0, 0)
    createdib = (hdib <> 0)
end function
public function createfrompicture( _
        byref picthis as stdpicture _
    )
dim lhdc as long
dim lhdcdesktop as long
dim lhbmpold as long
dim tbmp as bitmap
dim lhwnd as long
    
    getobjectapi picthis.handle, len(tbmp), tbmp
    if (create(tbmp.bmwidth, tbmp.bmheight)) then
        lhwnd = getdesktopwindow()
        lhdcdesktop = getdc(lhwnd)
        if (lhdcdesktop <> 0) then
            lhdc = createcompatibledc(lhdcdesktop)
            releasedc lhwnd, lhdcdesktop
            if (lhdc <> 0) then
                lhbmpold = selectobject(lhdc, picthis.handle)
                loadpictureblt lhdc
                selectobject lhdc, lhbmpold
                deletedc lhdc
            end if
        end if
    end if
end function
public function create( _
        byval lwidth as long, _
        byval lheight as long _
    ) as boolean
    clearup
    m_hdc = createcompatibledc(0)
    if (m_hdc <> 0) then
        if (createdib(m_hdc, lwidth, lheight, m_hdib)) then
            m_hbmpold = selectobject(m_hdc, m_hdib)
            create = true
        else
            deletedc m_hdc
            m_hdc = 0
        end if
    end if
end function
public property get bytesperscanline() as long
    ' scans must align on dword boundaries:
    bytesperscanline = (m_tbi.bmiheader.biwidth * 3 + 3) and &hfffffffc
end property

public property get width() as long
    width = m_tbi.bmiheader.biwidth
end property
public property get height() as long
    height = m_tbi.bmiheader.biheight
end property

public sub loadpictureblt( _
        byval lhdc as long, _
        optional byval lsrcleft as long = 0, _
        optional byval lsrctop as long = 0, _
        optional byval lsrcwidth as long = -1, _
        optional byval lsrcheight as long = -1, _
        optional byval erop as rasteropconstants = vbsrccopy _
    )
    if lsrcwidth < 0 then lsrcwidth = m_tbi.bmiheader.biwidth
    if lsrcheight < 0 then lsrcheight = m_tbi.bmiheader.biheight
    bitblt m_hdc, 0, 0, lsrcwidth, lsrcheight, lhdc, lsrcleft, lsrctop, erop
end sub


public sub paintpicture( _
        byval lhdc as long, _
        optional byval ldestleft as long = 0, _
        optional byval ldesttop as long = 0, _
        optional byval ldestwidth as long = -1, _
        optional byval ldestheight as long = -1, _
        optional byval lsrcleft as long = 0, _
        optional byval lsrctop as long = 0, _
        optional byval erop as rasteropconstants = vbsrccopy _
    )
    if (ldestwidth < 0) then ldestwidth = m_tbi.bmiheader.biwidth
    if (ldestheight < 0) then ldestheight = m_tbi.bmiheader.biheight
    bitblt lhdc, ldestleft, ldesttop, ldestwidth, ldestheight, m_hdc, lsrcleft, lsrctop, erop
end sub

public property get hdc() as long
    hdc = m_hdc
end property
public property get hdib() as long
    hdib = m_hdib
end property
public property get dibsectionbitsptr() as long
    dibsectionbitsptr = m_lptr
end property
public sub randomisebits( _
        optional byval bgray as boolean = false _
    )
dim bdib() as byte
dim x as long, y as long
dim lc as long
dim tsa as safearray2d
dim xend as long
    
    ' get the bits in the from dib section:
    with tsa
        .cbelements = 1
        .cdims = 2
        .bounds(0).llbound = 0
        .bounds(0).celements = m_tbi.bmiheader.biheight
        .bounds(1).llbound = 0
        .bounds(1).celements = bytesperscanline()
        .pvdata = m_lptr
    end with
    copymemory byval varptrarray(bdib()), varptr(tsa), 4

    ' random:
    randomize timer
    
    xend = (width - 1) * 3
    if (bgray) then
        for y = 0 to m_tbi.bmiheader.biheight - 1
            for x = 0 to xend step 3
                lc = rnd * 255
                bdib(x, y) = lc
                bdib(x + 1, y) = lc
                bdib(x + 2, y) = lc
            next x
        next y
    else
        for x = 0 to xend step 3
            for y = 0 to m_tbi.bmiheader.biheight - 1
                bdib(x, y) = 0
                bdib(x + 1, y) = rnd * 255
                bdib(x + 2, y) = rnd * 255
            next y
        next x
    end if
    
    ' clear the temporary array descriptor
    ' (this does not appear to be necessary, but
    ' for safety do it anyway)
    copymemory byval varptrarray(bdib), 0&, 4
    
end sub

public sub clearup()
    if (m_hdc <> 0) then
        if (m_hdib <> 0) then
            selectobject m_hdc, m_hbmpold
            deleteobject m_hdib
        end if
        deletedc m_hdc
    end if
    m_hdc = 0: m_hdib = 0: m_hbmpold = 0: m_lptr = 0
end sub

public function resample( _
        byval lnewheight as long, _
        byval lnewwidth as long _
    ) as cdibsection
dim cdib as cdibsection
    set cdib = new cdibsection
    if cdib.create(lnewwidth, lnewheight) then
        if (lnewwidth <> m_tbi.bmiheader.biwidth) or (lnewheight <> m_tbi.bmiheader.biheight) then
            ' change in size, do resample:
            resampledib cdib
        else
            ' no size change so just return a copy:
            cdib.loadpictureblt m_hdc
        end if
        set resample = cdib
    end if
end function

private function resampledib(byref cdibto as cdibsection) as boolean
dim bdibfrom() as byte
dim bdibto() as byte

dim tsafrom as safearray2d
dim tsato as safearray2d

    ' get the bits in the from dib section:
    with tsafrom
        .cbelements = 1
        .cdims = 2
        .bounds(0).llbound = 0
        .bounds(0).celements = m_tbi.bmiheader.biheight
        .bounds(1).llbound = 0
        .bounds(1).celements = bytesperscanline()
        .pvdata = m_lptr
    end with
    copymemory byval varptrarray(bdibfrom()), varptr(tsafrom), 4

    ' get the bits in the to dib section:
    with tsato
        .cbelements = 1
        .cdims = 2
        .bounds(0).llbound = 0
        .bounds(0).celements = cdibto.height
        .bounds(1).llbound = 0
        .bounds(1).celements = cdibto.bytesperscanline()
        .pvdata = cdibto.dibsectionbitsptr
    end with
    copymemory byval varptrarray(bdibto()), varptr(tsato), 4

dim xscale as single
dim yscale as single

dim x as long, y as long, xend as long, xout as long

dim fx as single, fy as single
dim ify as long, ifx as long
dim dx as single, dy as single
dim r as long, r1 as single, r2 as single, r3 as single, r4 as single
dim g as long, g1 as single, g2 as single, g3 as single, g4 as single
dim b as long, b1 as single, b2 as single, b3 as single, b4 as single
dim ir1 as long, ig1 as long, ib1 as long
dim ir2 as long, ig2 as long, ib2 as long

    xscale = (width - 1) / cdibto.width
    yscale = (height - 1) / cdibto.height
    
    xend = cdibto.width - 1
        
    for y = 0 to cdibto.height - 1
        
        fy = y * yscale
        ify = int(fy)
        dy = fy - ify
        
        for x = 0 to xend
            fx = x * xscale
            ifx = int(fx)
            dx = fx - ifx
            
            ifx = ifx * 3
            ' interpolate using the four nearest pixels in the source
            b1 = bdibfrom(ifx, ify): g1 = bdibfrom(ifx + 1, ify): r1 = bdibfrom(ifx + 2, ify)
            b2 = bdibfrom(ifx + 3, ify): g2 = bdibfrom(ifx + 4, ify): r2 = bdibfrom(ifx + 5, ify)
            b3 = bdibfrom(ifx, ify + 1): g3 = bdibfrom(ifx + 1, ify + 1): r3 = bdibfrom(ifx + 2, ify + 1)
            b4 = bdibfrom(ifx + 3, ify + 1): g4 = bdibfrom(ifx + 4, ify + 1): r4 = bdibfrom(ifx + 5, ify + 1)
            
            ' interplate in x direction:
            ir1 = r1 * (1 - dy) + r3 * dy: ig1 = g1 * (1 - dy) + g3 * dy: ib1 = b1 * (1 - dy) + b3 * dy
            ir2 = r2 * (1 - dy) + r4 * dy: ig2 = g2 * (1 - dy) + g4 * dy: ib2 = b2 * (1 - dy) + b4 * dy
            ' interpolate in y:
            r = ir1 * (1 - dx) + ir2 * dx: g = ig1 * (1 - dx) + ig2 * dx: b = ib1 * (1 - dx) + ib2 * dx
            
            ' set output:
            if (r < 0) then r = 0
            if (r > 255) then r = 255
            if (g < 0) then g = 0
            if (g > 255) then g = 255
            if (b < 0) then b = 0
            if (b > 255) then
                b = 255
            end if
            xout = x * 3
            bdibto(xout, y) = b
            bdibto(xout + 1, y) = g
            bdibto(xout + 2, y) = r
            
        next x
        
    next y

    ' clear the temporary array descriptor
    ' (this does not appear to be necessary, but
    ' for safety do it anyway)
    copymemory byval varptrarray(bdibfrom), 0&, 4
    copymemory byval varptrarray(bdibto), 0&, 4


end function

private sub class_terminate()
    clearup
end sub




