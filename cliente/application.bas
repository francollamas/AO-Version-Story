attribute vb_name = "application"
'**************************************************************
' application.bas - general api methods regarding the application in general.
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


option explicit

''
' retrieves the active window's hwnd for this app.
'
' @return retrieves the active window's hwnd for this app. if this app is not in the foreground it returns 0.

private declare function getactivewindow lib "user32" () as long

''
' checks if this is the active (foreground) application or not.
'
' @return   true if any of the app's windows are the foreground window, false otherwise.

public function isappactive() as boolean
'***************************************************
'author: juan mart�n sotuyo dodero (maraxus)
'last modify date: 03/03/2007
'checks if this is the active application or not
'***************************************************
    isappactive = (getactivewindow <> 0)
end function
