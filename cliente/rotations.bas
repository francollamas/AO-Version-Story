attribute vb_name = "rotations"
public function bigshiftleft(value1 as string, shifts as integer) as string
dim tempstr as string
dim loopit as integer, loopinner as integer
dim tempnum as integer

    shifts = shifts mod 32
    
    if shifts = 0 then
        bigshiftleft = value1
        exit function
    end if

    value1 = right$(value1, 8)
    tempstr = string$(8 - len(value1), "0") + value1
    value1 = ""

    ' convert to binary
    for loopit = 1 to 8
        tempnum = val("&h" + mid$(tempstr, loopit, 1))
        for loopinner = 3 to 0 step -1
            if tempnum and 2 ^ loopinner then
                value1 = value1 + "1"
            else
                value1 = value1 + "0"
            end if
        next loopinner
    next loopit
    
    for i = 1 to shifts
        for j = 1 to 32
            mid(value1, j, 1) = mid(value1, j + 1, 1)
        next j
        if not mid(value1, 32, 1) = "0" then mid(value1, 32, 1) = "0"
    next i
    tempstr = value1

    ' and convert back to hex
    value1 = ""
    for loopit = 0 to 7
        tempnum = 0
        for loopinner = 0 to 3
            if val(mid$(tempstr, 4 * loopit + loopinner + 1, 1)) then
                tempnum = tempnum + 2 ^ (3 - loopinner)
            end if
        next loopinner
        value1 = value1 + hex$(tempnum)
    next loopit

    bigshiftleft = right(value1, 8)
end function
public function bigshiftright(value1 as string, shifts as integer) as string
dim tempstr as string
dim loopit as integer, loopinner as integer
dim tempnum as integer

    shifts = shifts mod 32
    
    if shifts = 0 then
        bigshiftright = value1
        exit function
    end if

    value1 = right$(value1, 8)
    tempstr = string$(8 - len(value1), "0") + value1
    value1 = ""

    ' convert to binary
    for loopit = 1 to 8
        tempnum = val("&h" + mid$(tempstr, loopit, 1))
        for loopinner = 3 to 0 step -1
            if tempnum and 2 ^ loopinner then
                value1 = value1 + "1"
            else
                value1 = value1 + "0"
            end if
        next loopinner
    next loopit
    
    for i = 1 to shifts
        for j = 32 to 2 step -1
            mid(value1, j, 1) = mid(value1, j - 1, 1)
        next j
        if not mid(value1, 1, 1) = "0" then mid(value1, 1, 1) = "0"
    next i
    tempstr = value1

    ' and convert back to hex
    value1 = ""
    for loopit = 0 to 7
        tempnum = 0
        for loopinner = 0 to 3
            if val(mid$(tempstr, 4 * loopit + loopinner + 1, 1)) then
                tempnum = tempnum + 2 ^ (3 - loopinner)
            end if
        next loopinner
        value1 = value1 + hex$(tempnum)
    next loopit

    bigshiftright = right(value1, 8)
end function


public function rotleft(byval value1 as string, byval rots as integer) as string
dim tempstr as string
dim loopit as integer, loopinner as integer
dim tempnum as integer

    rots = rots mod 32
    
    if rots = 0 then
        rotleft = value1
        exit function
    end if

    value1 = right$(value1, 8)
    tempstr = string$(8 - len(value1), "0") + value1
    value1 = ""

    ' convert to binary
    for loopit = 1 to 8
        tempnum = val("&h" + mid$(tempstr, loopit, 1))
        for loopinner = 3 to 0 step -1
            if tempnum and 2 ^ loopinner then
                value1 = value1 + "1"
            else
                value1 = value1 + "0"
            end if
        next loopinner
    next loopit
    tempstr = mid$(value1, rots + 1) + left$(value1, rots)

    ' and convert back to hex
    value1 = ""
    for loopit = 0 to 7
        tempnum = 0
        for loopinner = 0 to 3
            if val(mid$(tempstr, 4 * loopit + loopinner + 1, 1)) then
                tempnum = tempnum + 2 ^ (3 - loopinner)
            end if
        next loopinner
        value1 = value1 + hex$(tempnum)
    next loopit

    rotleft = right(value1, 8)
end function
public function rotright(byval value1 as string, byval rots as integer) as string
dim tempstr as string
dim loopit as integer, loopinner as integer
dim tempnum as integer

    rots = rots mod 32
    
    if rots = 0 then
        rotright = value1
        exit function
    end if

    value1 = right$(value1, 8)
    tempstr = string$(8 - len(value1), "0") + value1
    value1 = ""

    ' convert to binary
    for loopit = 1 to 8
        tempnum = val("&h" + mid$(tempstr, loopit, 1))
        for loopinner = 3 to 0 step -1
            if tempnum and 2 ^ loopinner then
                value1 = value1 + "1"
            else
                value1 = value1 + "0"
            end if
        next loopinner
    next loopit
    tempstr = right$(value1, rots) + mid$(value1, 1, len(value1) - rots)

    ' and convert back to hex
    value1 = ""
    for loopit = 0 to 7
        tempnum = 0
        for loopinner = 0 to 3
            if val(mid$(tempstr, 4 * loopit + loopinner + 1, 1)) then
                tempnum = tempnum + 2 ^ (3 - loopinner)
            end if
        next loopinner
        value1 = value1 + hex$(tempnum)
    next loopit

    rotright = right(value1, 8)
end function
public function bigadd(byval value1 as string, byval value2 as string) as string
dim valueans as string
dim loopit as integer, tempnum as integer

    tempnum = len(value1) - len(value2)
    if tempnum < 0 then
        value1 = space$(abs(tempnum)) + value1
    elseif tempnum > 0 then
        value2 = space$(abs(tempnum)) + value2
    end if

    tempnum = 0
    for loopit = len(value1) to 1 step -1
        tempnum = tempnum + val("&h" + mid$(value1, loopit, 1)) + val("&h" + mid$(value2, loopit, 1))
        valueans = hex$(tempnum mod 16) + valueans
        tempnum = int(tempnum / 16)
    next loopit

    if tempnum <> 0 then
        valueans = hex$(tempnum) + valueans
    end if

    bigadd = right(valueans, 8)
end function
function bigand(byval value1 as string, byval value2 as string) as string
dim valueans as string
dim loopit as integer, tempnum as integer

    tempnum = len(value1) - len(value2)
    if tempnum < 0 then
        value2 = mid$(value2, abs(tempnum) + 1)
    elseif tempnum > 0 then
        value1 = mid$(value1, tempnum + 1)
    end if

    for loopit = 1 to len(value1)
        valueans = valueans + hex$(val("&h" + mid$(value1, loopit, 1)) and val("&h" + mid$(value2, loopit, 1)))
    next loopit

    bigand = valueans
end function
function bigmod32add(byval value1 as string, byval value2 as string) as string
    bigmod32add = right$(bigadd(value1, value2), 8)
end function
function bignot(byval value1 as string) as string
dim valueans as string
dim loopit as integer

    value1 = right$(value1, 8)
    value1 = string$(8 - len(value1), "0") + value1
    for loopit = 1 to 8
        valueans = valueans + hex$(15 xor val("&h" + mid$(value1, loopit, 1)))
    next loopit

    bignot = valueans
end function
function bigor(byval value1 as string, byval value2 as string) as string
dim valueans as string
dim loopit as integer, tempnum as integer

    tempnum = len(value1) - len(value2)
    if tempnum < 0 then
        valueans = left$(value2, abs(tempnum))
        value2 = mid$(value2, abs(tempnum) + 1)
    elseif tempnum > 0 then
        valueans = left$(value1, abs(tempnum))
        value1 = mid$(value1, tempnum + 1)
    end if

    for loopit = 1 to len(value1)
        valueans = valueans + hex$(val("&h" + mid$(value1, loopit, 1)) or val("&h" + mid$(value2, loopit, 1)))
    next loopit

    bigor = valueans
end function
function bigxor(byval value1 as string, byval value2 as string) as string
dim valueans as string
dim loopit as integer, tempnum as integer

    tempnum = len(value1) - len(value2)
    if tempnum < 0 then
        valueans = left$(value2, abs(tempnum))
        value2 = mid$(value2, abs(tempnum) + 1)
    elseif tempnum > 0 then
        valueans = left$(value1, abs(tempnum))
        value1 = mid$(value1, tempnum + 1)
    end if

    for loopit = 1 to len(value1)
        valueans = valueans + hex$(val("&h" + mid$(value1, loopit, 1)) xor val("&h" + mid$(value2, loopit, 1)))
    next loopit

    bigxor = right(valueans, 8)
end function
public function dehex(inp as string) as string
for i = 1 to len(inp) step 2
    x = x & chr(val("&h" & mid(inp, i, 2)))
next i
dehex = x
end function
public function enhex(x as string) as string
for i = 1 to len(x)
    v = hex(asc(mid(x, i, 1)))
    if len(v) = 1 then v = "0" & v
    inp = inp & v
next i
enhex = inp
end function
