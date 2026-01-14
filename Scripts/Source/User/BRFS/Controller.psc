Scriptname BRFS:Controller extends Quest

ActorBase Property BRFS_Guard Auto Const
ActorBase Property BRFS_Slave Auto Const
LeveledActor Property BRFS_LC Auto Const
LeveledActor Property BRFS_LC_Main Auto Const
LeveledActor Property BRFS_LC_Child Auto Const
Faction Property BRFS_Actors Auto Const
Outfit Property BRFS_Outfit_Guard_Default Auto Const

Faction Property REPlayerAlly Auto Const

Message Property BRFS_SelectNpcType Auto Const

Bool Lock = False

Event OnInit()
    ReadNpcTemplates()

    ; TODO: Remove in production
    SetGuardOutfit("1300087b,1300087e,1300088a,13000883")
EndEvent

BRFS:NPC Function Add(String actorType, String name="")
    AcquireLock()

    BRFS:NPC newActor

    If actorType == "Guard"
        SelectNpcTemplateList(BRFS_LC_Main)
        newActor = Game.GetPlayer().PlaceAtMe(BRFS_Guard, abForcePersist=True, abDeleteWhenAble=False) as BRFS:NPC
        If name != ""
            GardenOfEden2.SetDisplayName(newActor, name)
        EndIf
    ElseIf actorType == "Slave"
        SelectNpcTemplateList(BRFS_LC_Main)
        newActor = Game.GetPlayer().PlaceAtMe(BRFS_Slave, abForcePersist=True, abDeleteWhenAble=False) as BRFS:NPC
        If name != ""
            GardenOfEden2.SetDisplayName(newActor, name)
        EndIf
    ElseIf actorType == "Child"
        SelectNpcTemplateList(BRFS_LC_Child)
        newActor = Game.GetPlayer().PlaceAtMe(BRFS_Slave, abForcePersist=True, abDeleteWhenAble=False) as BRFS:NPC
        If name != ""
            GardenOfEden2.SetDisplayName(newActor, name)
        EndIf
    EndIf

    ReleaseLock()
    Return newActor
EndFunction

Function BuyActor()
    Actor player = Game.GetPlayer()
    Form caps = Game.GetForm(0xF)

    Int npcType = BRFS_SelectNpcType.Show()
    If npcType == 4
        Return
    EndIf

    If npcType == 0
        If player.GetItemCount(caps) >= 500
            player.RemoveItem(caps, 500)
            BRFS:NPC newActor = Add("Guard", "")
            newActor.AddToFaction(REPlayerAlly)
        Else
            Debug.Notification("You don't have enough caps.")
        EndIf
    ElseIf npcType == 1
        If player.GetItemCount(caps) >= 500
            player.RemoveItem(caps, 500)
            Add("Slave", "")
        Else
            Debug.Notification("You don't have enough caps.")
        EndIf
    ElseIf npcType == 2
        If player.GetItemCount(caps) >= 1000
            player.RemoveItem(caps, 1000)
            Add("Slave", "")
        Else
            Debug.Notification("You don't have enough caps.")
        EndIf
    ElseIf npcType == 3
        If player.GetItemCount(caps) >= 500
            player.RemoveItem(caps, 500)
            Add("Child", "")
        Else
            Debug.Notification("You don't have enough caps.")
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

Function TrackOnMap(Int slot, String target)
    TrackOnMapInternal(slot, BRFS:Util.GetRef(target))
EndFunction

Function TrackOnMapInternal(Int slot, ObjectReference target)
    (GetAlias(slot + 1) as ReferenceAlias).ForceRefTo(target)
    SetObjectiveDisplayed(slot, abForce=True)
EndFunction

Function ListT()
    String result
    Int i
    While i < 10
        ObjectReference ref = (GetAlias(i + 1) as ReferenceAlias).GetReference()
        result += "Slot " + i + ": " + BRFS:Util.GetName(ref) + "\n"
        i += 1
    EndWhile

    System:Console.WriteLine(result)
EndFunction

Function UntrackOnMap(Int slot)
    SetObjectiveDisplayed(slot, False, abForce=True)
    (GetAlias(slot + 1) as ReferenceAlias).Clear()
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

Function ReadNpcTemplates()
    AcquireLock()

    BRFS_LC_Main.Revert()

    String[] npcTemplates = System:IO:File.ReadAllLines("Data/BRFS/npc-templates.txt")
    Int i
    While i < npcTemplates.Length
        String[] parts = System:Strings.Split(npcTemplates[i], ":")
        BRFS_LC_Main.AddForm(Game.GetFormFromFile(System:Int32.TryParse(parts[1], 16), parts[0]), 1)

        i += 1
    EndWhile

    ReleaseLock()
EndFunction

; ##############################################################################
; # Private Functions
; ##############################################################################
Function SelectNpcTemplateList(LeveledActor list)
    BRFS_LC.Revert()
    BRFS_LC.AddForm(list, 1)
EndFunction

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
