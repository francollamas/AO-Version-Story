attribute vb_name = "mod_cripto"
option explicit
public seed as string

function encryptini$(strg$, password$)
   dim b$, s$, i as long, j as long
   dim a1 as long, a2 as long, a3 as long, p$
   j = 1
   for i = 1 to len(password$)
     p$ = p$ & asc(mid$(password$, i, 1))
   next
    
   for i = 1 to len(strg$)
     a1 = asc(mid$(p$, j, 1))
     j = j + 1: if j > len(p$) then j = 1
     a2 = asc(mid$(strg$, i, 1))
     a3 = a1 xor a2
     b$ = hex$(a3)
     if len(b$) < 2 then b$ = "0" + b$
     s$ = s$ + b$
   next
   encryptini$ = s$
end function

function decryptini$(strg$, password$)
   dim b$, s$, i as long, j as long
   dim a1 as long, a2 as long, a3 as long, p$
   j = 1
   for i = 1 to len(password$)
     p$ = p$ & asc(mid$(password$, i, 1))
   next
   
   for i = 1 to len(strg$) step 2
     a1 = asc(mid$(p$, j, 1))
     j = j + 1: if j > len(p$) then j = 1
     b$ = mid$(strg$, i, 2)
     a3 = val("&h" + b$)
     a2 = a1 xor a3
     s$ = s$ + chr$(a2)
   next
   decryptini$ = s$
end function

function crypt$(strg$, password$)
   dim s$, i as long, j as long
   dim a1 as long, a2 as long, a3 as long, p$
   j = 1
   for i = 1 to len(password$)
     p$ = p$ & asc(mid$(password$, i, 1))
   next
   for i = 1 to len(strg$)
     a1 = asc(mid$(p$, j, 1))
     j = j + 1: if j > len(p$) then j = 1
     a2 = asc(mid$(strg$, i, 1))
     a3 = a1 xor a2
     s$ = s$ + chr$(a3)
     'if i mod 4096 = 0 then j = 1
   next
   crypt$ = s$
end function
