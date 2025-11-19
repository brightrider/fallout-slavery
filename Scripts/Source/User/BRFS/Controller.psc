Scriptname BRFS:Controller extends Quest

ActorBase Property BRFS_Guard Auto Const
ActorBase Property BRFS_Slave Auto Const
Faction Property BRFS_Actors Auto Const
Outfit Property BRFS_Outfit_Guard_Default Auto Const

Event OnInit()
    ; TODO: Remove in production
    SetGuardOutfit("1000087b,1000087e,1000088a,10000883")
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

Function List()
    BRFS:NPC[] actors = BRFS:Util.GetAllActors()
    Int i = 0
    While i < actors.Length
        System:Console.WriteLine(actors[i].GetDescription())
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
