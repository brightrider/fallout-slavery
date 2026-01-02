Scriptname BRFS:MarkerController extends Quest

Form Property EmptyIdleMarker Auto Const

Var[] Markers
Var[] MarkerNames

Bool Lock = False

ObjectReference Function Add(String name, Form markerForm=None)
    AcquireLock()

    If ! markerForm
        markerForm = EmptyIdleMarker
    EndIf

    ObjectReference marker = Game.GetPlayer().PlaceAtMe(markerForm, abForcePersist=True, abDeleteWhenAble=False)

    marker.SetAngle(0.0, 0.0, marker.GetAngleZ())

    Markers = System:Array.Add(Markers, marker)
    MarkerNames = System:Array.Add(MarkerNames, name)

    ReleaseLock()
    Return marker
EndFunction

ObjectReference Function Get(String name)
    AcquireLock()

    Int index = System:Array.IndexOf(MarkerNames, name)
    If index >= 0
        ObjectReference marker = Markers[index] as ObjectReference
        ReleaseLock()
        Return marker
    EndIf

    ReleaseLock()
    Return None
EndFunction

Bool Function Remove(String name)
    AcquireLock()

    Int index = System:Array.IndexOf(MarkerNames, name)
    If index >= 0
        ObjectReference marker = Markers[index] as ObjectReference
        Markers = System:Array.RemoveAt(Markers, index)
        MarkerNames = System:Array.RemoveAt(MarkerNames, index)
        marker.Delete()
        ReleaseLock()
        Return True
    EndIf

    ReleaseLock()
    Return False
EndFunction

Function List(String filter)
    Int i = 0
    While i < System:Array.Count(MarkerNames)
        If System:Strings.Contains(MarkerNames[i], filter)
            System:Console.WriteLine(MarkerNames[i] + " (" + (Markers[i] as ObjectReference).GetCurrentLocation().GetName() + ")")
        EndIf
        i += 1
    EndWhile
EndFunction

Function CreateGrid(String name, String grid, Int width, Int offX, Int offY)
    If offX == 0
        offX = 192
    EndIf
    If offY == 0
        offY = 512
    EndIf
    CreateGridInternal(name, BRFS:Util.StringToIntArray(grid), width, offX, offY)
EndFunction

Function CreateGridInternal(String name, Int[] grid, Int width, Int offX=192, Int offY=512)
    Int i = 0
    While i < grid.Length
        ObjectReference marker = Add(name + i)

        Int newX = offX * (i % width)
        Int newY = offY * (i / width)
        BRFS:Math.TranslateLocalXY(marker, newX, newY)
        BRFS:Math.RotateZ(marker, grid[i])

        i += 1
    EndWhile
EndFunction

Function DestroyGrid(String name)
    Int i = 0
    While True
        If ! Remove(name + i)
            Return
        EndIf

        i += 1
    EndWhile
EndFunction

; ##############################################################################
; # Private Functions
; ##############################################################################
Function AcquireLock(Bool bypass=False, Float spinDelay=0.001)
    If bypass
        Return
    EndIf

    While Lock
        Utility.Wait(spinDelay)
    EndWhile
    Lock = True
EndFunction

Function ReleaseLock(Bool bypass=False)
    If bypass
        Return
    EndIf

    Lock = False
EndFunction
; ##############################################################################
