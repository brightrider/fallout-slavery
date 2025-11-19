Scriptname BRFS:NPC extends Actor

BRFS:MarkerController Property BRFS_MarkerController Auto Const

Faction Property BRFS_Guards Auto Const
Faction Property BRFS_Slaves Auto Const

Keyword Property BRFS_PackageKeyword1 Auto Const
Keyword Property BRFS_PackageKeyword2 Auto Const

ActorValue Property Health Auto Const
ActorValue Property Variable08 Auto Const

Bool Lock = False

Event OnInit()
    IgnoreFriendlyHits()

    If IsSlave()
        SetValue(Health, 1.0)
    EndIf
EndEvent

Bool Function IsGuard()
    Return IsInFaction(BRFS_Guards)
EndFunction

Bool Function IsSlave()
    Return IsInFaction(BRFS_Slaves)
EndFunction

Function Wait(Bool bypassLock=False)
    AcquireLock(bypassLock)

    SetLinkedRef(None, BRFS_PackageKeyword1)
    SetLinkedRef(None, BRFS_PackageKeyword2)
    SetValue(Variable08, 0)
    EvaluatePackage()

    ReleaseLock(bypassLock)
EndFunction

Function Travel(ObjectReference target, Bool bypassLock=False)
    AcquireLock(bypassLock)

    SetLinkedRef(target, BRFS_PackageKeyword1)
    SetLinkedRef(None, BRFS_PackageKeyword2)
    SetValue(Variable08, 1)
    EvaluatePackage()

    ReleaseLock(bypassLock)
EndFunction

Function TravelMarker(String target, Bool bypassLock=False)
    AcquireLock(bypassLock)

    Travel(BRFS_MarkerController.Get(target), bypassLock=True)

    ReleaseLock(bypassLock)
EndFunction

Function Follow(ObjectReference target, Bool bypassLock=False)
    AcquireLock(bypassLock)

    SetLinkedRef(target, BRFS_PackageKeyword1)
    SetLinkedRef(None, BRFS_PackageKeyword2)
    SetValue(Variable08, 2)
    EvaluatePackage()

    ReleaseLock(bypassLock)
EndFunction

Function UseIdleMarker(ObjectReference target, ObjectReference secondTarget=None, Bool bypassLock=False)
    AcquireLock(bypassLock)

    SetLinkedRef(target, BRFS_PackageKeyword1)
    SetLinkedRef(secondTarget, BRFS_PackageKeyword2)
    SetValue(Variable08, 3)
    EvaluatePackage()

    ReleaseLock(bypassLock)
EndFunction

Function UseIdleMarkerByName(String target, ObjectReference secondTarget=None, Bool bypassLock=False)
    AcquireLock(bypassLock)

    UseIdleMarker(BRFS_MarkerController.Get(target), secondTarget, bypassLock=True)

    ReleaseLock(bypassLock)
EndFunction

Function UseWeapon(ObjectReference target, ObjectReference loc, Bool bypassLock=False)
    AcquireLock(bypassLock)

    If loc
        SetLinkedRef(loc, BRFS_PackageKeyword1)
    EndIf
    SetLinkedRef(target, BRFS_PackageKeyword2)
    SetValue(Variable08, 4)
    EvaluatePackage()

    ReleaseLock(bypassLock)
EndFunction

Function UseWeaponMarker(ObjectReference target, String loc, Bool bypassLock=False)
    AcquireLock(bypassLock)

    UseWeapon(target, BRFS_MarkerController.Get(loc), bypassLock=True)

    ReleaseLock(bypassLock)
EndFunction

Function ToggleUseWeapon()
    AcquireLock()

    ObjectReference slot1 = GetLinkedRef(BRFS_PackageKeyword1)
    ObjectReference slot2 = GetLinkedRef(BRFS_PackageKeyword2)

    If IsGuard()
        If IsUsingIdleMarker() && slot2
            UseWeapon(slot2, slot1, bypassLock=True)
        ElseIf IsUsingWeapon()
            UseIdleMarker(slot1, slot2, bypassLock=True)
        EndIf
    EndIf

    ReleaseLock()
EndFunction

Function Patrol(ObjectReference p1, ObjectReference p2, Bool bypassLock=False)
    AcquireLock(bypassLock)

    SetLinkedRef(p1, BRFS_PackageKeyword1)
    SetLinkedRef(p2, BRFS_PackageKeyword2)
    SetValue(Variable08, 6)
    EvaluatePackage()

    ReleaseLock(bypassLock)
EndFunction

Function PatrolMarker(String p1, String p2, Bool bypassLock=False)
    AcquireLock(bypassLock)

    Patrol(BRFS_MarkerController.Get(p1), BRFS_MarkerController.Get(p2), bypassLock=True)

    ReleaseLock(bypassLock)
EndFunction

Function Aim(ObjectReference target, ObjectReference loc, Bool bypassLock=False)
    AcquireLock(bypassLock)

    If loc
        SetLinkedRef(loc, BRFS_PackageKeyword1)
    EndIf
    SetLinkedRef(target, BRFS_PackageKeyword2)
    SetValue(Variable08, 7)
    EvaluatePackage()

    ReleaseLock(bypassLock)
EndFunction

Function AimMarker(ObjectReference target, String loc, Bool bypassLock=False)
    AcquireLock(bypassLock)

    Aim(target, BRFS_MarkerController.Get(loc), bypassLock=True)

    ReleaseLock(bypassLock)
EndFunction

Bool Function IsWaiting()
    Return GetValue(Variable08) as Int == 0
EndFunction

Bool Function IsTraveling()
    Return GetValue(Variable08) as Int == 1
EndFunction

Bool Function IsFollowing()
    Return GetValue(Variable08) as Int == 2
EndFunction

Bool Function IsUsingIdleMarker()
    Return GetValue(Variable08) as Int == 3
EndFunction

Bool Function IsUsingWeapon()
    Return GetValue(Variable08) as Int == 4
EndFunction

Bool Function IsPatrolling()
    Return GetValue(Variable08) as Int == 6
EndFunction

Bool Function IsAiming()
    Return GetValue(Variable08) as Int == 7
EndFunction

; TODO: Improve this
String Function GetDescription()
    String type = "Guard"
    If IsSlave()
        type = "Slave"
    EndIf

    String aliveStatus = "Alive"
    If IsDead()
        aliveStatus = "Dead"
    EndIf

    String procedure = "No action assigned"
    Int procedureCode = GetValue(Variable08) as Int
    If procedureCode == 0
        procedure = "Idle"
    ElseIf procedureCode == 1
        procedure = "Traveling"
    ElseIf procedureCode == 2
        procedure = "Following"
    ElseIf procedureCode == 3
        procedure = "Using Idle Marker"
    ElseIf procedureCode == 4
        procedure = "Using weapon"
    ElseIf procedureCode == 6
        procedure = "Patrolling"
    ElseIf procedureCode == 7
        procedure = "Aiming"
    EndIf

    Return GetDisplayName() + "[" + GardenOfEden.GetHexFormID(Self) + ", " + type + ", " + aliveStatus + "] " + procedure
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
