version 5.00
begin vb.form frmhackfound 
   borderstyle     =   1  'fixed single
   caption         =   "danger danger!"
   clientheight    =   2775
   clientleft      =   45
   clienttop       =   330
   clientwidth     =   4680
   beginproperty font 
      name            =   "tahoma"
      size            =   8.25
      charset         =   0
      weight          =   400
      underline       =   0   'false
      italic          =   0   'false
      strikethrough   =   0   'false
   endproperty
   icon            =   "frmhackfound.frx":0000
   linktopic       =   "form1"
   maxbutton       =   0   'false
   minbutton       =   0   'false
   moveable        =   0   'false
   scaleheight     =   2775
   scalewidth      =   4680
   startupposition =   2  'centerscreen
   begin vb.commandbutton cmdcancel 
      caption         =   "cancelar"
      height          =   495
      left            =   3120
      mouseicon       =   "frmhackfound.frx":000c
      mousepointer    =   99  'custom
      tabindex        =   3
      top             =   2160
      width           =   1215
   end
   begin vb.commandbutton cmdaceptar 
      caption         =   "aceptar"
      default         =   -1  'true
      height          =   495
      left            =   300
      mouseicon       =   "frmhackfound.frx":015e
      mousepointer    =   99  'custom
      tabindex        =   2
      top             =   2160
      width           =   1215
   end
   begin vb.label label2 
      alignment       =   2  'center
      caption         =   "noland unique format (tm) es gentileza de noland studios"
      height          =   315
      left            =   180
      tabindex        =   1
      top             =   1620
      width           =   4335
   end
   begin vb.label label1 
      alignment       =   2  'center
      caption         =   $"frmhackfound.frx":02b0
      height          =   1215
      left            =   180
      tabindex        =   0
      top             =   180
      width           =   4335
   end
end
attribute vb_name = "frmhackfound"
attribute vb_globalnamespace = false
attribute vb_creatable = false
attribute vb_predeclaredid = true
attribute vb_exposed = false
option explicit

'[code 002]:matux
private sub cmdaceptar_click()
    end
end sub

private sub cmdcancel_click()
    end
end sub

private sub cmdcancel_mousemove(button as integer, shift as integer, x as single, y as single)
    cmdcancel.left = cint(4770 * rnd)
end sub
'[end]
