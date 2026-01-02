Scriptname BRFS:MarkerController extends Quest

Form Property EmptyIdleMarker Auto Const

Bool Lock = False

ObjectReference Function Add(String name, Form markerForm=None)
    AcquireLock()

    If ! markerForm
        markerForm = EmptyIdleMarker
    EndIf

    ObjectReference marker = Game.GetPlayer().PlaceAtMe(markerForm, abForcePersist=True, abDeleteWhenAble=False)

    GardenOfEden2.SetDisplayName(marker, name)
    marker.SetAngle(0.0, 0.0, marker.GetAngleZ())

    System:SaveVar.SetValue("BRFS_Markers", name, marker)

    ReleaseLock()
    Return marker
EndFunction

ObjectReference Function Get(String name)
    AcquireLock()

    ObjectReference marker = System:SaveVar.GetValue("BRFS_Markers", name) as ObjectReference

    ReleaseLock()
    Return marker
EndFunction

Bool Function Remove(String name)
    AcquireLock()

    ObjectReference marker = System:SaveVar.GetValue("BRFS_Markers", name) as ObjectReference
    If marker
        System:SaveVar.Remove("BRFS_Markers", name)
        marker.Delete()
        ReleaseLock()
        Return True
    EndIf

    ReleaseLock()
    Return False
EndFunction

String[] Function GetNames()
    AcquireLock()

    String[] names = System:SaveVar.GetKeys("BRFS_Markers")

    ReleaseLock()
    Return names
EndFunction

Function List(String filter)
    String[] names = GetNames()
    Int i = 0
    While i < names.Length
        If System:Strings.Contains(names[i], filter)
            System:Console.WriteLine(names[i])
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
