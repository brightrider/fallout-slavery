Scriptname BRFS:MarkerController extends Quest

Form Property EmptyIdleMarker Auto Const

Bool Lock = False

ObjectReference Function Add(String name)
    AcquireLock()

    ObjectReference marker = Game.GetPlayer().PlaceAtMe(EmptyIdleMarker, abDeleteWhenAble=False)

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
    EndIf

    ReleaseLock()
    Return True
EndFunction

String[] Function GetNames()
    AcquireLock()

    String[] names = System:SaveVar.GetKeys("BRFS_Markers")

    ReleaseLock()
    Return names
EndFunction

Function List()
    String[] names = GetNames()
    Int i = 0
    While i < names.Length
        System:Console.WriteLine(names[i])
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
