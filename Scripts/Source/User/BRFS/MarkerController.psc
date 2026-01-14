Scriptname BRFS:MarkerController extends Quest

Form Property EmptyIdleMarker Auto Const

Var[] Markers
Var[] MarkerNames

Bool Lock = False

ObjectReference Function Add(String name, Form markerForm=None)
    AcquireLock()

    If ! name || Get(name, bypassLock=True)
        ReleaseLock()
        Return None
    EndIf

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

ObjectReference Function Get(String name, Bool bypassLock=False)
    AcquireLock(bypassLock)

    Int index = System:Array.IndexOf(MarkerNames, name)
    If index >= 0
        ObjectReference marker = Markers[index] as ObjectReference
        ReleaseLock(bypassLock)
        Return marker
    EndIf

    ReleaseLock(bypassLock)
    Return None
EndFunction

String Function GetMarkerName(ObjectReference marker, Bool bypassLock=False)
    AcquireLock(bypassLock)

    Int index = System:Array.IndexOf(Markers, marker)
    If index >= 0
        String name = MarkerNames[index]
        ReleaseLock(bypassLock)
        Return name
    EndIf

    ReleaseLock(bypassLock)
    Return ""
EndFunction

Function Rename(String oldName, String newName)
    AcquireLock()

    If ! newName || Get(newName, bypassLock=True)
        ReleaseLock()
        Return
    EndIf

    Int index = System:Array.IndexOf(MarkerNames, oldName)
    If index >= 0
        MarkerNames[index] = newName
    EndIf

    ReleaseLock()
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

Function List(String filter, Float radius)
    If radius == 0.0
        radius = 10240.0
    EndIf

    Int i = 0
    While i < System:Array.Count(MarkerNames)
        String name = MarkerNames[i]
        ObjectReference marker = Markers[i] as ObjectReference

        Float distance = marker.GetDistance(Game.GetPlayer())
        If radius <= 0.0 || distance <= radius
            If distance > 1000000.0 || distance < 0.0
                distance = -1.0
            EndIf

            name += "["
            name += GardenOfEden.GetHexFormID(marker) + ", "
            name += BRFS:Util.GetName(marker, skipMarkerName=True) + ", "
            name += marker.GetCurrentLocation().GetName() + "(" + distance + ")"
            name += "]"
            name += "\n"

            If System:Strings.Contains(name, filter)
                System:Console.WriteLine(name)
            EndIf
        EndIf
        i += 1
    EndWhile
EndFunction

Function CreateGrid(String name, String grid, Int width, Form markerForm, Int offX, Int offY)
    If offX == 0
        offX = 128
    EndIf
    If offY == 0
        offY = 256
    EndIf
    CreateGridInternal(name, BRFS:Util.StringToIntArray(grid), width, markerForm, offX, offY)
EndFunction

Function CreateGridInternal(String name, Int[] grid, Int width, Form markerForm=None, Int offX=128, Int offY=256)
    Int i = 0
    While i < grid.Length
        ObjectReference marker = Add(name + i, markerForm)

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
