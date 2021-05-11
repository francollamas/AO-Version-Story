version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clsestadisticasipc"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
option explicit

private declare function registerwindowmessage lib "user32" alias "registerwindowmessagea" (byval lpstring as string) as long
private declare function sendnotifymessage lib "user32" alias "sendnotifymessagea" (byval hwnd as long, byval msg as long, byval wparam as long, byval lparam as long) as long
private declare function sendmessage lib "user32" alias "sendmessagea" (byval hwnd as long, byval wmsg as long, byval wparam as long, lparam as any) as long
private declare function sendmessagelong lib "user32" alias "sendmessagea" (byval hwnd as long, byval wmsg as long, byval wparam as long, byval lparam as long) as long

private const wm_user = &h400

private smensaje as long, hventana as long, hventanamia as long

private declare function getwindowtext lib "user32" alias "getwindowtexta" (byval hwnd as long, byval lpstring as string, byval cch as long) as long
private declare function getwindowtextlength lib "user32" alias "getwindowtextlengtha" (byval hwnd as long) as long
private declare function getwindow lib "user32" (byval hwnd as long, byval wcmd as long) as long

private const gw_hwndfirst = 0
private const gw_hwndnext = 2

'*************************************************
public enum estanotificaciones
    cantidad_online = 1
    record_usuarios = 2
    uptime_server = 3
    cantidad_mapas = 4
    evento_nuevo_clan = 5
    
    handle_wnd_server = 100
end enum

'*************************************************

private function buscaventana(wnd as long, str as string) as long
dim w as long
dim l as long
dim t as string


w = getwindow(wnd, gw_hwndfirst)

while w <> 0
   l = getwindowtextlength(w)

   if l > 0 then
      t = space(l + 1)
      l = getwindowtext(w, t, l + 1)

      if left(t, len(str)) = str then
         buscaventana = w
         exit function
      end if
   end if

   w = getwindow(w, gw_hwndnext)
wend

buscaventana = 0

end function

public function informar(byval quecosa as estanotificaciones, byval parametro as long) as long
call buscawndestadisticas
informar = sendmessagelong(hventana, smensaje, quecosa, parametro)

end function

public function estadisticasandando() as boolean
dim ret as long

call buscawndestadisticas
'ret = sendnotifymessage(hventana, smensaje, 0, 0)
estadisticasandando = (hventana <> 0)

end function

public sub inicializa(byval hwnd as long)
hventanamia = hwnd
smensaje = registerwindowmessage("estadisticasao")

end sub

private sub buscawndestadisticas()
hventana = buscaventana(hventanamia, "servidor de estadisticas ao")

end sub
