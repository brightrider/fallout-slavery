Scriptname BRFS:Controller extends Quest

ActorBase Property BRFS_Guard Auto Const
ActorBase Property BRFS_Slave Auto Const
Faction Property BRFS_Actors Auto Const
Outfit Property BRFS_Outfit_Guard_Default Auto Const

Event OnInit()
    ; TODO: Remove in production
    SetGuardOutfit("1300087b,1300087e,1300088a,13000883")
EndEvent

Function Add(String actorType, String name="")
    If actorType == "Guard"
        BRFS:NPC newActor = Game.GetPlayer().PlaceAtMe(BRFS_Guard, abForcePersist=True, abDeleteWhenAble=False) as BRFS:NPC
        If name != ""
            GardenOfEden2.SetDisplayName(newActor, name)
        EndIf
    ElseIf actorType == "Slave"
        BRFS:NPC newActor = Game.GetPlayer().PlaceAtMe(BRFS_Slave, abForcePersist=True, abDeleteWhenAble=False) as BRFS:NPC
        If name != ""
            GardenOfEden2.SetDisplayName(newActor, name)
        EndIf
    EndIf
EndFunction

Function List(String filter, Float radius)
    If radius == 0.0
        radius = 10240.0
    EndIf

    BRFS:NPC[] actors = BRFS:Util.GetAllActors(radius)
    Int i = 0
    While i < actors.Length
        String desc = actors[i].GetDescription()
        If System:Strings.Contains(desc, filter)
            System:Console.WriteLine(desc)
        EndIf
        i += 1
    EndWhile
EndFunction

Function SetGuardOutfit(String formIds)
    System:Outfit.SetParts(BRFS_Outfit_Guard_Default, BRFS:Util.StringToFormArray(formIds))
EndFunction

Function CreateConvoy(String members)
    CreateConvoyInternal(BRFS:Util.DisplayNamesToRefArray(members))
EndFunction

Function CreateConvoyInternal(ObjectReference[] members)
    Int i = 1
    While i < members.Length
        (members[i] as BRFS:NPC).FollowInternal(members[i - 1])
        i += 1
    EndWhile
EndFunction

Function ExecutionSetup(String guards, String slaves, String markerGridName)
    ExecutionSetupInternal(BRFS:Util.DisplayNamesToRefArray(guards), BRFS:Util.DisplayNamesToRefArray(slaves), markerGridName)
EndFunction

Function ExecutionSetupInternal(ObjectReference[] guards, ObjectReference[] slaves, String markerGridName)
    BRFS:MarkerController markerController = Game.GetFormFromFile(0x000090B6, "FalloutSlavery.esp") as BRFS:MarkerController

    Int i = 0
    While i < guards.Length
        BRFS:NPC guard = guards[i] as BRFS:NPC
        BRFS:NPC slave = slaves[i] as BRFS:NPC
        guard.UseInternal(markerController.Get(markerGridName + i), slave)
        slave.UseInternal(markerController.Get(markerGridName + (guards.Length + i)))
        i += 1
    EndWhile
EndFunction

Function ExecutionIdle()
    BRFS:NPC[] actors = BRFS:Util.GetAllActors(1024.0)
    Int i = 0
    While i < actors.Length
        BRFS:NPC npc = actors[i]
        If npc.IsGuard() && (npc.IsUsingIdleMarker() || npc.IsAiming() || npc.IsUsingWeapon() || npc.IsUsingWeaponOnce())
            npc.UseIdleMarkerInternal(None, None)
        EndIf
        i += 1
    EndWhile
EndFunction

Function ExecutionAim()
    BRFS:NPC[] actors = BRFS:Util.GetAllActors(1024.0)
    Int i = 0
    While i < actors.Length
        BRFS:NPC npc = actors[i]
        If npc.IsGuard() && (npc.IsUsingIdleMarker() || npc.IsAiming() || npc.IsUsingWeapon() || npc.IsUsingWeaponOnce())
            npc.AimInternal(None, None)
        EndIf
        i += 1
    EndWhile
EndFunction

Function ExecutionFire()
    BRFS:NPC[] actors = BRFS:Util.GetAllActors(1024.0)
    Int i = 0
    While i < actors.Length
        BRFS:NPC npc = actors[i]
        If npc.IsGuard() && (npc.IsUsingIdleMarker() || npc.IsAiming() || npc.IsUsingWeapon() || npc.IsUsingWeaponOnce())
            npc.UseWeaponInternal(None, None)
        EndIf
        i += 1
    EndWhile
EndFunction

Function ExecutionFireOnce()
    BRFS:NPC[] actors = BRFS:Util.GetAllActors(1024.0)
    Int i = 0
    While i < actors.Length
        BRFS:NPC npc = actors[i]
        If npc.IsGuard() && (npc.IsUsingIdleMarker() || npc.IsAiming() || npc.IsUsingWeapon() || npc.IsUsingWeaponOnce())
            npc.UseWeaponOnceInternal(None, None)
        EndIf
        i += 1
    EndWhile
EndFunction
