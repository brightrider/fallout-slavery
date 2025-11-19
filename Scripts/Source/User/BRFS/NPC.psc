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

Function Wait()
    SetLinkedRef(None, BRFS_PackageKeyword1)
    SetLinkedRef(None, BRFS_PackageKeyword2)
    SetValue(Variable08, 0)
    EvaluatePackage()
EndFunction

Function Travel(String target)
    TravelInternal(BRFS_MarkerController.Get(target))
EndFunction

Function TravelInternal(ObjectReference target)
    SetLinkedRef(target, BRFS_PackageKeyword1)
    SetLinkedRef(None, BRFS_PackageKeyword2)
    SetValue(Variable08, 1)
    EvaluatePackage()
EndFunction

Function Follow(String target)
    FollowInternal(BRFS:Util.GetPlayerOrActorByDisplayName(target))
EndFunction

Function FollowInternal(ObjectReference target)
    SetLinkedRef(target, BRFS_PackageKeyword1)
    SetLinkedRef(None, BRFS_PackageKeyword2)
    SetValue(Variable08, 2)
    EvaluatePackage()
EndFunction

Function UseIdleMarker(String target, ObjectReference secondTarget=None)
    UseIdleMarkerInternal(BRFS_MarkerController.Get(target), secondTarget)
EndFunction

Function UseIdleMarkerInternal(ObjectReference target, ObjectReference secondTarget=None)
    SetLinkedRef(target, BRFS_PackageKeyword1)
    SetLinkedRef(secondTarget, BRFS_PackageKeyword2)
    SetValue(Variable08, 3)
    EvaluatePackage()
EndFunction

Function UseWeapon(String target, String loc)
    UseWeaponInternal(BRFS:Util.GetPlayerOrActorByDisplayName(target), BRFS_MarkerController.Get(loc))
EndFunction

Function UseWeaponInternal(ObjectReference target, ObjectReference loc)
    If loc
        SetLinkedRef(loc, BRFS_PackageKeyword1)
    EndIf
    SetLinkedRef(target, BRFS_PackageKeyword2)
    SetValue(Variable08, 4)
    EvaluatePackage()
EndFunction

Function ToggleUseWeapon()
    ObjectReference slot1 = GetLinkedRef(BRFS_PackageKeyword1)
    ObjectReference slot2 = GetLinkedRef(BRFS_PackageKeyword2)

    If IsGuard()
        If IsUsingIdleMarker() && slot2
            UseWeaponInternal(slot2, slot1)
        ElseIf IsUsingWeapon()
            UseIdleMarkerInternal(slot1, slot2)
        EndIf
    EndIf
EndFunction

Function Patrol(String p1, String p2)
    PatrolInternal(BRFS_MarkerController.Get(p1), BRFS_MarkerController.Get(p2))
EndFunction

Function PatrolInternal(ObjectReference p1, ObjectReference p2)
    SetLinkedRef(p1, BRFS_PackageKeyword1)
    SetLinkedRef(p2, BRFS_PackageKeyword2)
    SetValue(Variable08, 6)
    EvaluatePackage()
EndFunction

Function Aim(String target, String loc)
    AimInternal(BRFS:Util.GetPlayerOrActorByDisplayName(target), BRFS_MarkerController.Get(loc))
EndFunction

Function AimInternal(ObjectReference target, ObjectReference loc)
    If loc
        SetLinkedRef(loc, BRFS_PackageKeyword1)
    EndIf
    SetLinkedRef(target, BRFS_PackageKeyword2)
    SetValue(Variable08, 7)
    EvaluatePackage()
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
