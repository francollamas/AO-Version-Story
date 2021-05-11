version 5.00
begin vb.form frmtutorial 
   borderstyle     =   0  'none
   caption         =   "form1"
   clientheight    =   7635
   clientleft      =   0
   clienttop       =   0
   clientwidth     =   8745
   linktopic       =   "form1"
   scaleheight     =   509
   scalemode       =   3  'pixel
   scalewidth      =   583
   showintaskbar   =   0   'false
   startupposition =   2  'centerscreen
   begin vb.label lbltitulo 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   13.5
         charset         =   0
         weight          =   700
         underline       =   -1  'true
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00004080&
      height          =   390
      left            =   525
      tabindex        =   4
      top             =   435
      width           =   7725
   end
   begin vb.image imgcheck 
      height          =   450
      left            =   3060
      top             =   6900
      visible         =   0   'false
      width           =   435
   end
   begin vb.image imgmostrar 
      height          =   570
      left            =   3000
      top             =   6855
      visible         =   0   'false
      width           =   2535
   end
   begin vb.image imgsiguiente 
      height          =   360
      left            =   6840
      top             =   6960
      width           =   1455
   end
   begin vb.image imganterior 
      height          =   360
      left            =   480
      top             =   6960
      width           =   1455
   end
   begin vb.label lblmensaje 
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   5790
      left            =   525
      tabindex        =   3
      top             =   840
      width           =   7725
   end
   begin vb.label lblpagtotal 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   255
      left            =   7365
      tabindex        =   2
      top             =   120
      width           =   255
   end
   begin vb.label lblpagactual 
      alignment       =   2  'center
      backstyle       =   0  'transparent
      beginproperty font 
         name            =   "ms sans serif"
         size            =   8.25
         charset         =   0
         weight          =   700
         underline       =   0   'false
         italic          =   0   'false
         strikethrough   =   0   'false
      endproperty
      forecolor       =   &h00ffffff&
      height          =   255
      left            =   6870
      tabindex        =   1
      top             =   120
      width           =   255
   end
   begin vb.label lblcerrar 
      backstyle       =   0  'transparent
      height          =   255
      left            =   8430
      mousepointer    =   99  'custom
      tabindex        =   0
      top             =   75
      width           =   255
   end
end
attribute vb_name = "frmtutorial"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
'argentum online 0.11.6
'
'copyright (c) 2002 m�rquez pablo ignacio
'copyright (c) 2002 otto perez
'copyright (c) 2002 aaron perkins
'copyright (c) 2002 mat�as fernando peque�o
'
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

private clsformulario as clsformmovementmanager

private cbotonsiguiente as clsgraphicalbutton
private cbotonanterior as clsgraphicalbutton

public lastpressed as clsgraphicalbutton

private type ttutorial
    stitle as string
    spage as string
end type

private piccheck as picture
private picmostrar as picture

private tutorial() as ttutorial
private numpages as long
private currentpage as long

private sub form_load()

    ' handles form movement (drag and drop).
    set clsformulario = new clsformmovementmanager
    clsformulario.initialize me
    
    me.picture = loadpicture(dirgraficos & "ventanatutorial.jpg")
    
    call loadbuttons
    
    call loadtutorial
    
    currentpage = 1
    call selectpage(currentpage)
end sub

private sub loadbuttons()
    dim grhpath as string
    
    grhpath = dirgraficos

    set cbotonsiguiente = new clsgraphicalbutton
    set cbotonanterior = new clsgraphicalbutton
    
    set lastpressed = new clsgraphicalbutton
    
    
    call cbotonsiguiente.initialize(imgsiguiente, grhpath & "botonsiguientetutorial.jpg", _
                                    grhpath & "botonsiguienterollovertutorial.jpg", _
                                    grhpath & "botonsiguienteclicktutorial.jpg", me, _
                                    grhpath & "botonsiguientegris.jpg")

    call cbotonanterior.initialize(imganterior, grhpath & "botonanteriortutorial.jpg", _
                                    grhpath & "botonanteriorrollovertutorial.jpg", _
                                    grhpath & "botonanteriorclicktutorial.jpg", me, _
                                    grhpath & "botonanteriorgris.jpg", true)
                                    
    set piccheck = loadpicture(grhpath & "checktutorial.bmp")
    set picmostrar = loadpicture(grhpath & "nomostrartutorial.bmp")
    
    imgmostrar.picture = picmostrar
    
    if not bshowtutorial then
        imgcheck.picture = piccheck
    else
        set imgcheck.picture = nothing
    end if
    
    lblcerrar.mouseicon = picmouseicon
end sub

private sub form_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub

private sub imganterior_click()

    if not cbotonanterior.isenabled then exit sub
    
    currentpage = currentpage - 1
    
    if currentpage = 1 then call cbotonanterior.enablebutton(false)
    
    if not cbotonsiguiente.isenabled then call cbotonsiguiente.enablebutton(true)
    
    call selectpage(currentpage)
end sub

private sub imgcheck_click()
    
    bshowtutorial = not bshowtutorial
    
    if not bshowtutorial then
        imgcheck.picture = piccheck
    else
        set imgcheck.picture = nothing
    end if
end sub

private sub imgsiguiente_click()
    
    if not cbotonsiguiente.isenabled then exit sub
    
    currentpage = currentpage + 1
    
    ' deshabilita el boton siguiente si esta en la ultima pagina
    if currentpage = numpages then call cbotonsiguiente.enablebutton(false)
    
    ' habilita el boton anterior
    if not cbotonanterior.isenabled then call cbotonanterior.enablebutton(true)
    
    call selectpage(currentpage)
end sub

private sub lblcerrar_click()
    unload me
end sub

private sub loadtutorial()
    
    dim tutorialpath as string
    dim lpage as long
    dim numlines as long
    dim lline as long
    dim sline as string
    
    tutorialpath = dirextras & "tutorial.dat"
    numpages = val(getvar(tutorialpath, "init", "numpags"))
    
    if numpages > 0 then
        redim tutorial(1 to numpages)
        
        ' cargo paginas
        for lpage = 1 to numpages
            numlines = val(getvar(tutorialpath, "pag" & lpage, "numlines"))
            
            with tutorial(lpage)
                
                .stitle = getvar(tutorialpath, "pag" & lpage, "title")
                
                ' cargo cada linea de la pagina
                for lline = 1 to numlines
                    sline = getvar(tutorialpath, "pag" & lpage, "line" & lline)
                    .spage = .spage & sline & vbcrlf
                next lline
            end with
            
        next lpage
    end if
    
    lblpagtotal.caption = numpages
end sub

private sub selectpage(byval lpage as long)
    lbltitulo.caption = tutorial(lpage).stitle
    lblmensaje.caption = tutorial(lpage).spage
    lblpagactual.caption = lpage
end sub

private sub lblmensaje_mousemove(button as integer, shift as integer, x as single, y as single)
    lastpressed.toggletonormal
end sub
