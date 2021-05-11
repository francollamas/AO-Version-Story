version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clstree"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false

option explicit
'*******************************************************************************************
'pathfinding
'*******************************************************************************************
' julien lecomte
' webmaster@amanitamuscaria.org
' http://www.amanitamuscaria.org
' feel free to use, abuse or distribute. (usus, fructus, & abusus)
' if you improve it, tell me !
' don't take credit for what you didn't create. thanks.
'*******************************************************************************************
'
' vb collection class & vb dictionnary class is *too* slow. to make things fast
' i'll use an array and add elements to the array.
'
' the a* method can be improved. it doesn't care whether a tile has a value of 1
' or 9, it just finds the fastest path, but not the shortest.
' for dijkstra method, it finds the shortest path, but finds it pretty slowly.
' anyhow, the point here isn't the speed of execution, but just the algo used
' i have found only one (complicated and slow) example of pathfinding under vb,
' so i guess this code is a good contribution to the vb community.
'
' if you want more speed under vb, cut out the graphic part of the code in frmpathfinding
' if you want even more speed, then shorten this class module and the code to either use only
' a* or dijkstra.
' if you want even more speed, then don't use vb !
'
' cheers,
' julien
'

'rvt  i've made a few changes in here - purely from a performance perspective
'     i think you'll find it quite a bit quicker at the expense of more storage (space-time continuum again)
'     the only code changes are in here, and in the new zinsort routine (�me)  15 jan 2002
'     im sure it can still be made faster - but the fmrpathfinding will have to see too much rearrangement...
'     in particular the path_getvalue routine is very expensive and is probably better put into this class
'     so that it can be made more efficient (esp now that a copy of aimap is available in here). some other
'     bits may also benefit because of the same.
'     cheers,  ron  15.1.2002

'rvt2 you wont get it faster than it is now i dont think. sort is gone altogether as are nearly all of the
'     scanning lookups. everything is pretty tight now.  55x faster for dijkstra and 23x faster for a* than
'     when i started....
'     the path retrace is also now in the class so that there are now quite a few changes in frmpathfinding
'     ive labelled things as usual
'     cheers ron    17.1.2002

'rvt3 even more found (in a* algorithm) and now i have added complete algorithms (without display capability)
'     which are quickest of all. this is because the calling is reduced to a minimum. ive folded the explore
'     steps into start and updatenode steps, and killed off a few other minor things. changes in here and
'     in frmpathfinding. variables have been renamed in here to make it a little more readable.
'     ill leave you in peace now. thanks for your patience

'     the alorithms are now o(n^2) now, where they were o(n^4).
'     by my estimation dijkstra should be able to handle a 280x280 matrix in 1 sec when compiled in the worst case
'     for a maze-like path 320x320 should be possible in 1 sec  (on a 600mhz machine). that should be good enough
'     for a civil game... other than very sparse matrices, dijkstra will generally win.
'     21.1.2002
'
'
'*******************************************************************************************
'
' version 2.0
'
' dear all,
' i would like to thank ron for his very positive feedback. his comments have been left in the code
' he contributed in a better sorting algorithm, heuristic and exploration of nodes. this deeply
' improved the performance of this vb algorithm.
'
' user interface : you can't change settings, delete map, etc... anymore while pathfinding in progress.
'
' any other changes are labeled "jl" in the code.
'
' cheers,
' julien
' webmaster@amanitamuscaria.org
'
'

private type tnode
  x          as long
  y          as long
  lvalue     as long        'the path value (sum) so far
  lheuristic as long        'a weighted value for choices
  llink      as long        'a link between subsequent nodes in the chain
end type

private const low_bound as long = 1

public high_bound      as long
public bastar          as boolean '// running a* and not dijkstra

private tnodes()       as tnode
private lnodes         as long    'the number of nodes in operation
private lnodecur       as long    'the index of the one we are working on
private lfirstempty    as long    'where to start searching for an empty node

private lbeenhere()    as long    '0 if not, if so index into tnodes(), -2 if impassable
private laimap()       as long    'the connection set aimap

private lendx          as long
private lendy          as long    'to store the end points

private xdim           as long
private ydim           as long    'rvt the x and y dimensions of the tableau (it doesnt need to be square anymore)

private sub class_terminate()
    erase tnodes
    erase lbeenhere
    erase laimap
end sub

public function runsearch(lxstart as long, lystart as long, lxend as long, lyend as long, aimap() as long) as boolean
    '// returns true if path found
  
    startsearch lxstart, lystart, lxend, lyend, aimap()
    
    if bastar then                                            'astar using the nextnode routine
        do until nextnode or runsearch
            runsearch = updatecurrentnode
            doevents
        loop
    else                                                      'dijkstra (with a little optimisation)
        do until lnodecur > lnodes or runsearch
            if tnodes(lnodecur).lvalue = path_empty then
                runsearch = updatecurrentnode
                doevents
            end if
            lnodecur = lnodecur + 1
        loop
    end if
    backtracepath                     'go back from goal to start and record
end function

'================================================================================================================

public sub startsearch(lxstart as long, lystart as long, lxend as long, lyend as long, aimap() as long)
  
    dim xld as long, xud as long, yld as long, yud as long
      
    xld = lbound(aimap, 1)
    xud = ubound(aimap, 1)
    xdim = xud - xld + 1
    
    yld = lbound(aimap, 2)
    yud = ubound(aimap, 2)
    ydim = yud - yld + 1
    
    'take a copy of the connection map - the costs of crossing a tile
    redim laimap(xld to xud, yld to yud) as long
    laimap() = aimap()
    
    'a record of which nodes have been visited ie. are on the queue
    redim lbeenhere(xld to xud, yld to yud) as long
    
    high_bound = xdim * ydim
    redim tnodes(low_bound to high_bound) as tnode
  
    '// store the end point
    lendx = lxend
    lendy = lyend
    
    '// store the start point
    
    add lxstart, lystart 'this one now current
    lnodecur = low_bound 'make it the current one
    with tnodes(lnodecur)
        .lvalue = 0          'startofpath then fist 4 nodes of near neigbours
        if .x > 0 then add .x - 1, .y '// imp
        if .y > 0 then add .x, .y - 1 '// imp
        if (.x + 1) < xdim then add .x + 1, .y
        if (.y + 1) < ydim then add .x, .y + 1
    end with
    
    lnodecur = lnodecur + 1 'the first node to be examined is this one
    lfirstempty = lnodecur
end sub

private sub add(lx as long, ly as long)
    'rvt first check if the point is in the search queue - if so forget it else flag it as in the array
    'rvt ignore it if its going to be impassible anyway
    'rvt this really helps out the both algorithms
    'rvt we turn a linear time in n seek in the array into a constant time operation
    'rvt and limit the nodes checked to only those of use to the answer
    dim ldistx as long, ldisty as long
    
    if lbeenhere(lx, ly) = 0 then                'is it already there ie. seen?
        if laimap(lx, ly) <> th_unwalkable then  'and its a useful point to move to ie dont add duds
            'havent been here and it isn't impassable so add it
            lnodes = lnodes + 1
            with tnodes(lnodes)
            .x = lx
            .y = ly
            .lvalue = path_empty
            .llink = 0                             'to keep track of where we came from
    
            '// when adding a point to the list, figure out a heuristic if in a* mode
            if bastar then
                ldistx = laimap(lx, ly) * (lx - lendx) 'increase the disadvantage of expensive paths
                ldisty = laimap(lx, ly) * (ly - lendy)
                .lheuristic = (ldistx * ldistx + ldisty * ldisty)
            end if
            end with
            lbeenhere(lx, ly) = lnodes       'mark as seen and in queue at this place
        else
            lbeenhere(lx, ly) = path_impossible      'seen but not in queue (impassable)
        end if
    end if
end sub

public function nextnode() as boolean
    dim i as long
    
    if bastar then
        'rvt the a* algorithm looks for the empty_path node with the smallest heuristic value.
        '    so if we keep track of the first empty one and then look for the
        '    smallest from there we save ourselves a sort and one and a bit linear time searches
        
        for i = lfirstempty to lnodes    'look for the first empty node from where we last looked
            if tnodes(i).lvalue = path_empty then exit for
        next

        if i <= lnodes then              'we found one
            lfirstempty = i               'this says where now to look from next time
            lnodecur = smallestemptypath 'this one is therefore the smallest heuristic empty_path node
            exit function
        end if
    else
    
    '// imp
'        dim lbnd&
'        lbnd = lnodes - number_of_tiles
'        if lbnd <= low_bound then lbnd = low_bound
        for i = lfirstempty to lnodes 'lfirstempty increases monotonically (usually check only 1 or 2)
            if tnodes(i).lvalue = path_empty then
'                if i <= lbnd then stop
                lnodecur = i
                lfirstempty = i
                exit function
            end if
        next
    end if
    
    nextnode = true 'at this point the search is at an end - it may not have been successful (deadended)...
                    'btw searches dont always end here - if the end point is encountered they stop anyway
end function

private function smallestemptypath() as long 'find the smallest heuristic path value from lfirstempty on
    dim i as long, minheuristic as long, minnode as long
    
    minnode = lfirstempty
    minheuristic = tnodes(lfirstempty).lheuristic       'remember where and what the heuristic value is
    
    for i = lfirstempty + 1 to lnodes                   'now check the rest keeping track of the smallest lheuristic
        if tnodes(i).lvalue = path_empty then           'must be empty
            if tnodes(i).lheuristic < minheuristic then 'and its smaller
                minnode = i
                minheuristic = tnodes(i).lheuristic
            end if
        end if
    next
  
    if minnode <> lfirstempty then
        swapnodes minnode, lfirstempty
    end if                                            'we swap them around so that the pending list gradually shrinks
  
    smallestemptypath = lfirstempty
end function

private sub swapnodes(byval lnodeidx1 as long, byval lnodeidx2 as long)
    dim z as tnode
    
    'do the swap
    z = tnodes(lnodeidx1)
    tnodes(lnodeidx1) = tnodes(lnodeidx2)
    tnodes(lnodeidx2) = z
    
    'fix the beenhere pointers
    lbeenhere(tnodes(lnodeidx1).x, tnodes(lnodeidx1).y) = lnodeidx1
    lbeenhere(tnodes(lnodeidx2).x, tnodes(lnodeidx2).y) = lnodeidx2
end sub

public function backtracepath()
    dim nodefrom as long, nodeto as long, z as long
    
    'we here take the opportunity to straighten out the path for subsequent use
    'by moving backwards from the goal and reversing the linkages until we get to the start
    'this should be called after the path_search is over
    
    z = lbeenhere(lendx, lendy)
    if z then lnodecur = z
    nodeto = lnodecur
    nodefrom = tnodes(lnodecur).llink
    tnodes(nodeto).llink = 0                 'mark as end of chain
    if nodefrom then
        do
            z = tnodes(nodefrom).llink             'need this for a while
            tnodes(nodefrom).llink = nodeto        'mark the new link
            nodeto = nodefrom
            nodefrom = z
        loop until nodefrom = 0                     'start has llink=0
    end if
end function

public function pathstepnext(byref lx as long, byref ly as long) as long
    lnodecur = tnodes(lbeenhere(lx, ly)).llink
    if lnodecur then getnode lx, ly
    pathstepnext = lnodecur
end function

public function getnode(byref lx as long, byref ly as long)
    lx = tnodes(lnodecur).x
    ly = tnodes(lnodecur).y
end function

public function getnodevalue(byval lx as long, byval ly as long) as long
    '// cannot use current node
    dim i as long
                                            'lbeenhere() records the index of node(x,y) in the nodelist
    i = lbeenhere(lx, ly)                   'a constant time lookup
    if i > 0 then                           'its in the queue
        getnodevalue = tnodes(i).lvalue
    else
        getnodevalue = path_empty
    end if
end function

'we update the shortest path to here - looking at neighbour nodes we already have
'when we can we expand by adding all of those neighbours that are not already there

public function updatecurrentnode() as boolean      'true if this node was the end node
    
    dim lval as long, lpathminval as long
    dim i as long, x as long, y as long
    
    lpathminval = path_huge                  'assume a really large value
    
    with tnodes(lnodecur)
    for x = .x - 1 to .x + 1 step 2        'check left and right
        if x >= 0 then
            if x < xdim then
                i = lbeenhere(x, .y)             'check point
                if i = 0 then
                    add x, .y                      'if not there then expand to it for next time
                elseif i > 0 then
                    lval = tnodes(i).lvalue
                    if lval >= 0 then
                        if lval < lpathminval then
                            lpathminval = lval
                            .llink = i                'new link from here
                        end if
                    end if
                end if
            end if
        end if
    next
    
    for y = .y - 1 to .y + 1 step 2        'check up and down
        if y >= 0 then
            if y < ydim then
                i = lbeenhere(.x, y)             'check point
                if i = 0 then
                    add .x, y                      'if not there then expand to it for next time
                elseif i > 0 then
                    lval = tnodes(i).lvalue
                    if lval >= 0 then
                        if lval < lpathminval then
                            lpathminval = lval
                            .llink = i                'new link from here
                        end if
                    end if
                end if
            end if
        end if
    next
    .lvalue = lpathminval + laimap(.x, .y)                'currently min path cost
    updatecurrentnode = ((.x = lendx) and (.y = lendy))   'true if we found the end
    end with
end function
