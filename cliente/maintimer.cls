version 1.0 class
begin
  multiuse = -1  'true
  persistable = 0  'notpersistable
  databindingbehavior = 0  'vbnone
  datasourcebehavior  = 0  'vbnone
  mtstransactionmode  = 0  'notanmtsobject
end
attribute vb_name = "clstimer"
attribute vb_globalnamespace = false
attribute vb_creatable = true
attribute vb_predeclaredid = false
attribute vb_exposed = false
'**************************************************************************
'this program is free software; you can redistribute it and/or modify
'it under the terms of the gnu general public license as published by
'the free software foundation; either version 2 of the license, or
'(at your option) any later version.
'
'this program is distributed in the hope that it will be useful,
'but without any warranty; without even the implied warranty of
'merchantability or fitness for a particular purpose.  see the
'affero general public license for more details.
'
'you should have received a copy of the gnu general public license
'along with this program; if not, write to the free software
'foundation, inc., 59 temple place, suite 330, boston, ma  02111-1307  usa
'**************************************************************************

''
' the maintimer of the game.
' controls client�s intervals.
'
' @author nacho (integer) integer-x@hotmail.com
' @version 1.0
' @date 20060428

'*****************************************************
'timer class for argentum online
'designed and implemented by nacho (integer)
'integer-x@hotmail.com
'*****************************************************

option explicit

''
' how many timers we are going to use-
'
' @see see maintimer.createall
    private const cantidadtimers as byte = 8

''
' a timer data structure.
'
' @param interval how long, in miliseconds, a cicle lasts.
' @param currenttick current tick in which the timer is.
' @param starttick tick in which current cicle has started.
' @param run true if the timer is active.

private type timer
    interval as long
    currenttick as long
    starttick as long
    run as boolean
end type

'timers
dim timer(1 to cantidadtimers) as timer

''
' timer�s index.
'
' @param attack                 controls the combat system.
' @param work                   controls the work system.
' @param useitemwithu           controls the usage of items with the "u" key.
' @param useitemwithdblclick    controls the usage of items with double click.
' @param sendrpu                controls the use of the "l" to request a pos update.
' @param castspell              controls the casting of spells.
' @param arrows                 controls the shooting of arrows.
public enum timersindex
    attack = 1
    work = 2
    useitemwithu = 3
    useitemwithdblclick = 4
    sendrpu = 5
    castspell = 6
    arrows = 7
    castattack = 8
end enum


''
' window�s api function.
' a milisecond pricision counter.
'
' @return   miliseconds since midnight.

private declare function gettickcount lib "kernel32" () as long

''
' sets a new intrval for a timer.
'
' @param timerindex timer�s index
' @param interval new lenght for the timer�s cicle in miliseconds.
' @remarks  must be donde after creating the timer and before using it, otherwise, interval will be 0

public sub setinterval(byval timerindex as timersindex, byval interval as long)
'*************************************************
'author: nacho (integer)
'last modified:
'desc: sets a new interval for a timer.
'*************************************************
    if timerindex < 1 or timerindex > cantidadtimers then exit sub
    
    timer(timerindex).interval = interval
end sub

''
' starts the timer.
'
' @param timerindex timer�s index
' @remarks  do this for starting the timer.

public sub start(byval timerindex as timersindex)
'*************************************************
'author: nacho (integer)
'last modified:
'desc: starts running the timer.
'*************************************************
    if timerindex < 1 or timerindex > cantidadtimers then exit sub
    
    timer(timerindex).run = true 'we allow the timer to run.
end sub

''
' resume the timer form where we had stoped.
'
' @param timerindex timer�s index
' @remarks  makes the timer continue from where it had stoped.

public sub continue(byval timerindex as timersindex)
'*************************************************
'author: nacho (integer)
'last modified:
'desc: continue our timer from where we had stopped it.
'*************************************************
    if timerindex < 1 or timerindex > cantidadtimers then exit sub
    
    timer(timerindex).run = true 'we allow the timer to run.
    
    'we�ll set the starttick again
    timer(timerindex).starttick = timer(timerindex).starttick + timer(timerindex).currenttick
end sub

''
' pauses the timer
'
' @param timerindex timer�s index
' @remarks  can be resumed with continue()

public sub pause(byval timerindex as timersindex)
'*************************************************
'author: nacho (integer)
'last modified:
'desc: pauses the timer.
'*************************************************
    if timerindex < 1 or timerindex > cantidadtimers then exit sub
    
    timer(timerindex).run = false 'don�t allow the timer to run.
    
    timer(timerindex).currenttick = gettickcount - timer(timerindex).starttick 'calculates acutual tick
end sub

''
' check if the timer has already completed it�s cicle.
'
' @param timerindex timer�s index
' @param restart if true, restart if we timer has ticked
' @return true if the interval has already been elapsed
' @remarks  can�t be done if the timer is stoped or if it had never been started.

public function check(byval timerindex as timersindex, optional restart as boolean = true) as boolean
'*************************************************
'author: nacho agustin (integer)
'last modified: 08/26/06
'modification: nigo: added restart as boolean
'desc: checks if the timer has alredy "ticked"
'returns: true if it has ticked, false if not.
'*************************************************
    if timerindex < 1 or timerindex > cantidadtimers then exit function
    
    if not timer(timerindex).run then exit function 'if we weren�t allowed to run, exit function
    
    timer(timerindex).currenttick = gettickcount - timer(timerindex).starttick 'calcutates currenttick
    
    if timer(timerindex).currenttick >= timer(timerindex).interval then
        check = true 'we have ticked!
        if restart then
            timer(timerindex).starttick = gettickcount 'restart timer (nicer than calling restart() )
            if (timerindex = timersindex.attack) or (timerindex = timersindex.castspell) then
                timer(timersindex.castattack).starttick = gettickcount 'set cast-attack interval
            elseif timerindex = timersindex.castattack then
                timer(timersindex.attack).starttick = gettickcount 'restart attack interval
                timer(timersindex.castspell).starttick = gettickcount 'restart magic interval
            end if
        end if
    end if
end function

''
' restarts timer.
'
' @param timerindex timer�s index

public sub restart(byval timerindex as timersindex)
'*************************************************
'author: nacho agustin (integer)
'last modified:
'desc: restarts timer
'*************************************************
    if timerindex < 1 or timerindex > cantidadtimers then exit sub
    
    timer(timerindex).starttick = gettickcount
end sub
