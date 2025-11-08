Scriptname BRFS:Controller extends Quest

ActorBase Property BRFS_Guard Auto Const
ActorBase Property BRFS_Slave Auto Const

Function AddActor(String actorType, String name="")
    If actorType == "Guard"
        BRFS:NPC newActor = Game.GetPlayer().PlaceAtMe(BRFS_Guard, abDeleteWhenAble=False) as BRFS:NPC
        If name != ""
            GardenOfEden2.SetDisplayName(newActor, name)
        EndIf
    ElseIf actorType == "Slave"
        BRFS:NPC newActor = Game.GetPlayer().PlaceAtMe(BRFS_Slave, abDeleteWhenAble=False) as BRFS:NPC
        If name != ""
            GardenOfEden2.SetDisplayName(newActor, name)
        EndIf
    EndIf
EndFunction

Function CreateConvoy(ObjectReference[] members)
    Int i = 1
    While i < members.Length
        (members[i] as BRFS:NPC).Follow(members[i - 1])
        i += 1
    EndWhile
EndFunction
